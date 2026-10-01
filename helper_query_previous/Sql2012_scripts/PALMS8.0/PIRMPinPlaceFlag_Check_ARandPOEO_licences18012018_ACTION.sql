--select PIRMPinPlaceFlag, * from [tblPOEOLicence] where InstrumentID = 692	
 
--select a.PIRMPinPlaceFlag, a.*, b.instrumentID as licenceNo, c.DateIssued from tblAnnualReturn a 
--inner join tblReportingPeriod b on a.ReportingPeriodID = b.ReportingPeriodID
--inner join tblInstrument c on a.InstrumentID = c.InstrumentID
--where c.InstrumentStatusID = 20 and b.instrumentID = 692
--order by c.DateCreated desc		


--select b.instrumentID as licenceNo, count(a.InstrumentID) as ARcount from tblAnnualReturn a 
--inner join tblReportingPeriod b on a.ReportingPeriodID = b.ReportingPeriodID
--inner join tblInstrument c on a.InstrumentID = c.InstrumentID
--where c.InstrumentStatusID = 20
--group by b.instrumentID
--order by count(a.InstrumentID) desc
------------------------------------------------------------------------------------------------
DECLARE @MyTableFinal TABLE
(
SNo int IDENTITY(1,1), 
licenceNo int,
licencePIRMPinPlaceFlag bit,
ARNo int,
ARPIRMPinPlaceFlag bit
)  

DECLARE @MyTable TABLE
	(
	SNo int IDENTITY(1,1), 
	licenceNo int,
	ARcount int
	)    
INSERT INTO @MyTable(licenceNo, ARcount)	    
select b.instrumentID as licenceNo, count(a.InstrumentID) as ARcount 
from tblAnnualReturn a 
inner join tblReportingPeriod b on a.ReportingPeriodID = b.ReportingPeriodID
inner join tblInstrument c on a.InstrumentID = c.InstrumentID
where c.InstrumentStatusID = 20
group by b.instrumentID
order by count(a.InstrumentID) desc

--select * from @MyTable
	
declare @Cnt int
SELECT @Cnt = MIN(Sno) FROM @MyTable
	
declare @TemplicenceNo int
declare @TempARcount int

WHILE (1=1)
BEGIN
   
SELECT @TemplicenceNo = licenceNo, @TempARcount = ARcount FROM @MyTable
WHERE SNo = @Cnt
	    
IF @@ROWCOUNT = 0
	BREAK

	declare @TempPIRMPinPlaceFlagLic bit = 0
	declare @TempPIRMPinPlaceFlagAR bit = 0
	declare @TempARNo int = 0

	if exists(select * from [tblPOEOLicence] where cast(InstrumentID as varchar) = cast(@TemplicenceNo as varchar))
	begin
		if exists(select top 1 a.PIRMPinPlaceFlag from tblAnnualReturn a 
		inner join tblReportingPeriod b on a.ReportingPeriodID = b.ReportingPeriodID
		inner join tblInstrument c on a.InstrumentID = c.InstrumentID
		where c.InstrumentStatusID = 20 and b.instrumentID = @TemplicenceNo and not a.PIRMPinPlaceFlag is null
		order by c.DateCreated desc	)
		begin
			select top 1  @TempPIRMPinPlaceFlagAR = a.PIRMPinPlaceFlag, @TempARNo = c.InstrumentID from tblAnnualReturn a 
			inner join tblReportingPeriod b on a.ReportingPeriodID = b.ReportingPeriodID
			inner join tblInstrument c on a.InstrumentID = c.InstrumentID
			where c.InstrumentStatusID = 20 and b.instrumentID = @TemplicenceNo and not a.PIRMPinPlaceFlag is null
			order by c.DateCreated desc	
			
			select @TempPIRMPinPlaceFlagLic = PIRMPinPlaceFlag from [tblPOEOLicence] where InstrumentID = @TemplicenceNo

			if @TempPIRMPinPlaceFlagAR <> @TempPIRMPinPlaceFlagLic
			begin
			      insert into @MyTableFinal(
						licenceNo,
						licencePIRMPinPlaceFlag,
						ARNo,
						ARPIRMPinPlaceFlag 				  
				  )
				  select 
				  @TemplicenceNo as licenceNo,
				  @TempPIRMPinPlaceFlagLic as licencePIRMPinPlaceFlag,
				  @TempARNo as ARNo,
				  @TempPIRMPinPlaceFlagAR as ARPIRMPinPlaceFlag
			end 
		end 
	end
 
SELECT @Cnt = @Cnt + 1
		
END			

select * from @MyTableFinal

delete @MyTable
delete @MyTableFinal
