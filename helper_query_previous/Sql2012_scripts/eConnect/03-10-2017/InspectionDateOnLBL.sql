declare @InstrumentID int = 11222 --here this is POEO licence number

-----------------------------------------------------------------------------
--1. we check exisitng inspection record based on current licence number
DECLARE @MyTable TABLE
(
	SNo int IDENTITY(1,1), 
	InstrumentID int null	 
)
insert into @MyTable
select top 1 b.InstrumentID
from tblInstrumentNotice a 
inner join tblNotice b on a.NoticeInstrumentID = b.InstrumentID
left outer join tblInstrument c on b.InstrumentID = c.InstrumentID
where a.InstrumentID = @InstrumentID 
and b.NoticeTemplateID = 532 
and c.InstrumentStatusID in (11, 12) 
order by c.DateIssued desc
-----------------------------------------------------------------------------
--2. How many eixisitng Inspection records we can find
DECLARE @ExistingCount int = 0
select @ExistingCount = count(*) from @MyTable
print '@ExistingCount = ' + cast(@ExistingCount as varchar)
--select * from @MyTable
-----------------------------------------------------------------------------
declare @TempNextInspectionDueDateLevel3 datetime  --level 3 has its own predefied next due date

--3. add the lastest inspection notice record into above table
declare @TempEnvironmentalRiskLevelID int = 0
select top 1 @TempEnvironmentalRiskLevelID = EnvironmentalRiskLevelID from tblPOEOLicenceEnvironmentalRiskLevel
where InstrumentID = @InstrumentID and EnvironmentalRiskLevelID in (713, 714, 715)
order by CompleteDate desc

declare @TempLevelText varchar(10)
select @TempLevelText = [description] from tblClassification where ClassificationID = @TempEnvironmentalRiskLevelID

declare @TempDueInMonth int = 0
if @TempEnvironmentalRiskLevelID = 713 --level 1: 36 months
   set @TempDueInMonth = 36
if @TempEnvironmentalRiskLevelID = 714 --level 2: 12 months
   set @TempDueInMonth = 12
if @TempEnvironmentalRiskLevelID = 715 --level 3:  
begin
    set @TempDueInMonth = 6
	--we get current year
	declare @TempCurrentYear int
	select @TempCurrentYear = datepart(year, getdate())

	declare @TempLastYear int
	set @TempLastYear = @TempCurrentYear -1

	declare @TempLastNov date
	select @TempLastNov = CONVERT(date, '01/07/' + cast(@TempLastYear as varchar), 103)

	declare @TempCurrentApr date
	select @TempCurrentApr = CONVERT(date, '30/04/' + cast(@TempCurrentYear as varchar), 103)

	declare @TempCurrentNov date
	select @TempCurrentNov = CONVERT(date, '01/07/' + cast(@TempCurrentYear as varchar), 103)

	--If no inspection report completed from 30/11 last year to 30/04 current year:
	--30/04 current year
	if not exists(select b.InstrumentID 
					from tblInstrumentNotice a 
					inner join tblNotice b on a.NoticeInstrumentID = b.InstrumentID
					left outer join tblInstrument c on b.InstrumentID = c.InstrumentID
					where 
					a.InstrumentID = @InstrumentID 
					and 
					b.NoticeTemplateID = 532 
					and c.InstrumentStatusID in (11, 12) 
					and c.DateIssued >= @TempLastNov and c.DateIssued <= @TempCurrentApr)
	begin
	   select @TempNextInspectionDueDateLevel3 = @TempCurrentApr
	   set @TempDueInMonth = 0	  
	end

	else 
	
	--If no inspection report completed from 30/04 current year to 30/11 current year:
	--30/11 current year   
	if not exists(select b.InstrumentID 
					from tblInstrumentNotice a 
					inner join tblNotice b on a.NoticeInstrumentID = b.InstrumentID
					left outer join tblInstrument c on b.InstrumentID = c.InstrumentID
					where 
					a.InstrumentID = @InstrumentID 
					and 
					b.NoticeTemplateID = 532 
					and c.InstrumentStatusID in (11, 12) 
					and c.DateIssued >= @TempCurrentApr and c.DateIssued <= @TempCurrentNov)
	begin
	   select @TempNextInspectionDueDateLevel3 = @TempCurrentNov
	   set @TempDueInMonth = 0	   
	end	 
end

print '@TempDueInMonth = ' + cast(@TempDueInMonth as varchar)

print '@TempEnvironmentalRiskLevelID = ' + cast(@TempEnvironmentalRiskLevelID as varchar)
--------------------------------------------------------------------
DECLARE @MyTableInspectionLBL TABLE
(
	SNo int IDENTITY(1,1), 
	InspectionNo int null,
	NextInspectionDueDate datetime null,
	InspectedDate datetime null,
	Officer varchar(100) null,
	[Level] varchar(10) null,
	Comments varchar(1000) null
)
--------------------------------------------------------------------
 
if @ExistingCount = 1
begin
    print 'has 1 previous records'
	--in table @MyTable we have 1 record1 
	--first we get the second one (old one) inspection date
	declare @ProcessInstrumentID int
	select @ProcessInstrumentID = InstrumentID from @MyTable 

	print '@@ProcessInstrumentID = ' + cast(@ProcessInstrumentID as varchar)

	if @ProcessInstrumentID > 0
	begin
		   --first row insert
		   declare @LatestInspectionDate datetime 

		   if exists(select InspectionDate from tblNotice where InstrumentID = @ProcessInstrumentID and Not InspectionDate is null)
		        select @LatestInspectionDate = InspectionDate from tblNotice where InstrumentID = @ProcessInstrumentID and Not InspectionDate is null
		   else
		   begin
		            declare @InstrumentIssueDate as Date
					select @InstrumentIssueDate = DateIssued from tblInstrument where InstrumentID = @ProcessInstrumentID
		          	select @LatestInspectionDate = DateAdd(month, @TempDueInMonth, @InstrumentIssueDate)
		   end

		   print '@LatestInspectionDate = ' + cast(@LatestInspectionDate as varchar)

		   declare @TempNextInspectionDueDate datetime

		   if @TempEnvironmentalRiskLevelID <> 715 
		      select @TempNextInspectionDueDate = DateAdd(month, @TempDueInMonth, @LatestInspectionDate)  --level1 and level2 cases
		   else
			   begin
			       if @TempDueInMonth = 0
				         select @TempNextInspectionDueDate = @TempNextInspectionDueDateLevel3
				   else
				         select @TempNextInspectionDueDate = DateAdd(month, @TempDueInMonth, @LatestInspectionDate)
			   end
		   
		   
		   insert into @MyTableInspectionLBL(NextInspectionDueDate)
		   select @TempNextInspectionDueDate

		   --second row insert
		   insert into @MyTableInspectionLBL(
		   InspectionNo,
		   NextInspectionDueDate,
		   InspectedDate,
		   Officer,
		   [Level],
		   Comments
		   )
		   select top 1 
		   @ProcessInstrumentID as InspectionNo,  
		   null as NextInspectionDueDate,
		   b.InspectionDate as InspectedDate,
		   (select top 1 b.GivenName + ' ' + b.Surname from tblInstrument a inner join tblSystemUser b on a.ResponsibleSystemUserID = b.SystemUserID
		   where a.InstrumentID = @InstrumentID) as Officer,
		   @TempLevelText as [Level],
		   b.ReasonForNotice as Comments
		   from tblNotice b  
		   where b.InstrumentID = @ProcessInstrumentID 		   
	end
end

if @ExistingCount = 0
begin
    print 'has none previous records at all so we use the top level licence issue date to do the next inspection due date calculation '
	--only first row insert
	declare @TempIssuedDate datetime
	
	if @TempEnvironmentalRiskLevelID <> 715 
	begin
		select @TempIssuedDate = DateIssued from tblInstrument where InstrumentID = @InstrumentID
		select @TempIssuedDate = DateAdd(month, @TempDueInMonth, @TempIssuedDate)
	end
	else
	begin
	    if @TempDueInMonth = 0
		     set @TempIssuedDate = @TempNextInspectionDueDateLevel3
	    else
		     begin
				select @TempIssuedDate = DateIssued from tblInstrument where InstrumentID = @InstrumentID
				select @TempIssuedDate = DateAdd(month, @TempDueInMonth, @TempIssuedDate)
			 end
	end

	insert into @MyTableInspectionLBL(NextInspectionDueDate)
	select @TempIssuedDate
end
 
--------------------------------------------------------------------


 
--test line 
select * from @MyTableInspectionLBL

---------------------------Final clean up----------------------------------------
delete @MyTable
delete @MyTableInspectionLBL
-------------------------------------------------------------------