	declare @FinalInspection table
	( 
		InstrumentID int null,
		NextInspectionDueDate datetime null
	)	
	
	DECLARE @MyTable TABLE
	(
	SNo int IDENTITY(1,1), 
	LicenceNo int 
	)    
	INSERT INTO @MyTable(LicenceNo)	    
	select distinct d.InstrumentID as LicenceNo 
	from tblNotice a inner join tblInstrument b on a.InstrumentID = b.InstrumentID 
	inner join tblNotice c on a.InstrumentID = c.InstrumentID
	inner join tblInstrumentNotice d on c.InstrumentID = d.NoticeInstrumentID
	where a.NoticeTemplateID = 532 and b.InstrumentStatusID in (11, 12) 
	and d.InstrumentID in (select InstrumentID from tblPOEOLicenceEnvironmentalRiskLevel where EnvironmentalRiskLevelID in (713, 714, 715))

    declare @Cnt int
    SELECT @Cnt = MIN(Sno) FROM @MyTable
	
	declare @RowCount int = 0
	select @RowCount = count(*) from @MyTable
	print '@RowCount = ' + cast(@RowCount as varchar(50))

	declare @TempLicenceNo int
	declare @InstrumentID int 

	WHILE (1=1)
	BEGIN
   
	SELECT @TempLicenceNo = LicenceNo FROM @MyTable WHERE SNo = @Cnt
	    
	IF @@ROWCOUNT = 0
		BREAK

		if @TempLicenceNo > 0
		begin		
		        set @InstrumentID = @TempLicenceNo 	  
			    print '@TempLicenceNo = ' + cast(@TempLicenceNo as varchar(50))
			  
			  -- start to get next inspection date based on current licence number
		declare @ProcessInstrumentID int		 
		DECLARE @Today as date = GETDATE()
		 
		select top 1 @ProcessInstrumentID = isnull(b.InstrumentID, 0)
		from tblInstrumentNotice a 
		inner join tblNotice b on a.NoticeInstrumentID = b.InstrumentID
		left outer join tblInstrument c on b.InstrumentID = c.InstrumentID
		where a.InstrumentID = @InstrumentID 
		and b.NoticeTemplateID = 532 
		and c.InstrumentStatusID = 12   --11: issued AND 12: Complete
		order by b.InspectionDate desc
		-----------------------------------------------------------------------------
		--2. How many eixisitng Inspection records we can find
		DECLARE @ExistingCount int = 0
		if @ProcessInstrumentID > 0
		    select @ExistingCount = 1 
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

			--1. Current financial year start and end date
			declare @StartDateCurrentFY date 
			declare @EndDateCurrenyFY date

			select @StartDateCurrentFY = dbo.GetFinYearDate(1)
			select @EndDateCurrenyFY = dbo.GetFinYearDate(0)

			--2. Next financial year start and end date
			declare @StartDateNextFY date 
			declare @EndDateNextFY date

			select @StartDateNextFY = dateadd(year, 1, dbo.GetFinYearDate(1))
			select @EndDateNextFY = dateadd(year, 1, dbo.GetFinYearDate(0))
			----------------------------------------------------------------------------
			--3. Counting how many inspections have been done during current fiancial year
			declare @InspectionCountCurrentFY int = 0

			select @InspectionCountCurrentFY = isnull(count(b.InstrumentID), 0) 
			from tblInstrumentNotice a 
			inner join tblNotice b on a.NoticeInstrumentID = b.InstrumentID
			left outer join tblInstrument c on b.InstrumentID = c.InstrumentID
			where 
			a.InstrumentID = @InstrumentID
			and 
			b.NoticeTemplateID = 532 
			and c.InstrumentStatusID = 12
			and b.InspectionDate >= @StartDateCurrentFY and b.InspectionDate <= @EndDateCurrenyFY
		 
			--4. different cases check
			declare @TempCurrentYear int
			select @TempCurrentYear = datepart(year, getdate())

			declare @TempLastYear int
			set @TempLastYear = @TempCurrentYear -1

			declare @TempLastNov date
			select @TempLastNov = CONVERT(date, '30/11/' + cast(@TempLastYear as varchar), 103)

			declare @TempCurrentApr date
			select @TempCurrentApr = CONVERT(date, '30/04/' + cast(@TempCurrentYear as varchar), 103)

			declare @TempCurrentNov date
			select @TempCurrentNov = CONVERT(date, '30/11/' + cast(@TempCurrentYear as varchar), 103)

			declare @TempNextApr date
			select @TempNextApr = CONVERT(date, '30/04/' + cast(@TempCurrentYear + 1 as varchar), 103)

			declare @TempNextNov date
			select @TempNextNov = CONVERT(date, '30/11/' + cast(@TempCurrentYear + 1 as varchar), 103)

			--a. If none namely @InspectionCountCurrentFY = 0
			if @InspectionCountCurrentFY = 0
			begin				 
				select @TempNextInspectionDueDateLevel3 = @TempCurrentNov
						set @TempDueInMonth = 0	

			end
			--b. If 1 namely @InspectionCountCurrentFY = 1
			if @InspectionCountCurrentFY = 1
			begin
						select @TempNextInspectionDueDateLevel3 = @TempNextApr
						set @TempDueInMonth = 0		   
			end
			--c. If 2 or more namely @InspectionCountCurrentFY >= 2 
			if @InspectionCountCurrentFY >= 2
			begin
						select @TempNextInspectionDueDateLevel3 = @TempNextNov
						set @TempDueInMonth = 0		   
			end

		end
		 
		if @ExistingCount = 1
		begin			 
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

				   --print '@LatestInspectionDate = ' + cast(@LatestInspectionDate as varchar)

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
			end
		end

		if @ExistingCount = 0
		begin 
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
					 
			select @TempNextInspectionDueDate = @TempIssuedDate
		end			  

			  insert into @FinalInspection(InstrumentID, NextInspectionDueDate)
			  select @TempLicenceNo as InstrumentID, @TempNextInspectionDueDate as NextInspectionDueDate 
			  -- end get next inspection date based on current licence number			  
		end
	 
	SELECT @Cnt = @Cnt + 1
		
	END
	delete @MyTable

	select * from @FinalInspection