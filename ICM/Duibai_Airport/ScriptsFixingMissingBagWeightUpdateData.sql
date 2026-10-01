    --This script will help to insert missing records which CUSS supposed to transfer them from [CussBagDropDB_DXB].[dbo].[BagWeightUpdate] need to be transferred into [CUSSReportingDB_DXB].[dbo].[BagWeightUpdate]
	--By default it is daily based processing, it can be modified for daily processing.
	--Main purpose: When CUSS engine may miss out transferring some records to CUSSReportingDB_DXB database BagWeightUpdate table we use this to this script to make them up
	--Date: 28-10-2021 Eric He

	--NOTE: please check @IsTest value before exectuing this script
	--***********************************************************************************************************************
    DECLARE @IsTest bit = 1 --if against production please set this value to 0. Local run this process set it as 1
	declare @UpdateMonthFirstDay datetime = '2021-10-02' -- please set this value as the first day of your target month. '2021-10-01' means process all records with in October 2021
	declare @UTC_LOCAL_HOURS int = 4 --Dubai is 4 hours earlier than UTC time so we set this value as 4. For Sydney time it should be 11
	--***********************************************************************************************************************
   
	if @IsTest = 1
	begin
		DECLARE @tbBagWeightUpdate TABLE
		(
			[ID] [bigint] NOT NULL,
			[BagID] [bigint] NOT NULL,
			[Weight] [decimal](18, 0) NOT NULL,
			[UtcTime] [datetime] NOT NULL,
			[CustomerSessionID] [bigint] NOT NULL,
			[TimeSlot5minID] [int] NULL,
			[TimeSlot10minID] [int] NULL,
			[TimeSlotHourlyID] [int] NULL,
			[DayOfTheWeekID] [int] NULL,
			[LocalTime] [datetime] NULL,
			[AbdStationID] [int] NULL
		) 
	end

	DECLARE @MyTable TABLE
	(
	SNo int IDENTITY(1,1), 
	BagWeightUpdateID int
	)    
	INSERT INTO @MyTable(BagWeightUpdateID)	    
	 
	SELECT ID
	  FROM [CussBagDropDB_DXB].[dbo].[BagWeightUpdate]
	WHERE 
	datepart(year, UtcTime) = datepart(year, @UpdateMonthFirstDay) and datepart(month, UtcTime) = datepart(month, @UpdateMonthFirstDay) 
	and datepart(day, UtcTime) = datepart(day, @UpdateMonthFirstDay)
	AND NOT ID in 
	(
	  select ID from  [CUSSReportingDB_DXB].[dbo].[BagWeightUpdate] WHERE datepart(year, UtcTime) = datepart(year, @UpdateMonthFirstDay) and datepart(month, UtcTime) = datepart(month, @UpdateMonthFirstDay) 
	  and datepart(day, UtcTime) = datepart(day, @UpdateMonthFirstDay)
	)
	order by ID desc

	if (select count(*) from @MyTable) = 0
	  print 'No records needs to be inserted'

	
	DECLARE @CurrentBagWeightUpdateID INT

	DECLARE @TempID bigint
	DECLARE @TempBagID bigint
	DECLARE @TempWeight decimal(18, 0)
	DECLARE @TempUtcTime datetime
	DECLARE @TempCustomerSessionID bigint 
	DECLARE @TempTimeSlot5minID int
	DECLARE @TempTimeSlot10minID int 
	DECLARE @TempTimeSlotHourlyID int 
	DECLARE @TempDayOfTheWeekID int 
	DECLARE @TempLocalTime datetime 
	DECLARE @TempAbdStationID int 

	DECLARE @CntTotal INT = 0
    DECLARE @Cnt INT
	SELECT @Cnt = MIN(Sno) FROM @MyTable
	
	WHILE (1=1)
	BEGIN
   
	SELECT @CurrentBagWeightUpdateID = BagWeightUpdateID FROM @MyTable
	WHERE SNo = @Cnt
	    
	IF @@ROWCOUNT = 0
		BREAK

       SELECT  
       @TempID = [ID]
      ,@TempBagID = [BagID]
      ,@TempWeight = [Weight]
      ,@TempUtcTime = [UtcTime]
      ,@TempCustomerSessionID = [CustomerSessionID]
      ,@TempLocalTime = [LocalTime]       
      FROM [CUSSBagDropDB_DXB].[dbo].[BagWeightUpdate] WHERE ID = @CurrentBagWeightUpdateID

	--select @TempLocalTime = CONVERT(datetime, SWITCHOFFSET(CONVERT(datetimeoffset, @TempUtcTime), DATENAME(TzOffset, SYSDATETIMEOFFSET()))) 
	select @TempLocalTime = dateadd(hour, @UTC_LOCAL_HOURS, @TempUtcTime) 

	select @TempTimeSlot5minID =  ID from [CUSSReportingDB_DXB].[dbo].[TimeSlot5min] where 
		cast(convert(varchar, cast([FromTime] as date)) + ' ' +  SUBSTRING(convert(varchar, @TempLocalTime, 108), 1,5) + ':00:000' as datetime) >= [FromTime]
	and 
		cast(convert(varchar, cast([ToTime] as date)) + ' ' +  SUBSTRING(convert(varchar, @TempLocalTime, 108), 1,5) + ':00:000' as datetime) < [ToTime]

	select @TempTimeSlot10minID = ID from [CUSSReportingDB_DXB].[dbo].[TimeSlot10Min] where 
		cast(convert(varchar, cast([FromTime] as date)) + ' ' +  SUBSTRING(convert(varchar, @TempLocalTime, 108), 1,5) + ':00:000' as datetime) >= [FromTime]
	and 
		cast(convert(varchar, cast([ToTime] as date)) + ' ' +  SUBSTRING(convert(varchar, @TempLocalTime, 108), 1,5) + ':00:000' as datetime) < [ToTime]

	select @TempTimeSlotHourlyID = ID from [CUSSReportingDB_DXB].[dbo].[TimeSlotHourly] where 
		cast(convert(varchar, cast([FromTime] as date)) + ' ' +  SUBSTRING(convert(varchar, @TempLocalTime, 108), 1,5) + ':00:000' as datetime) >= [FromTime]
	and 
		cast(convert(varchar, cast([ToTime] as date)) + ' ' +  SUBSTRING(convert(varchar, @TempLocalTime, 108), 1,5) + ':00:000' as datetime) < [ToTime]

	select @TempAbdStationID = AbdStationID from CustomerSession where ID = @TempCustomerSessionID
		--in c# CUSS Engine code Sunday has been set as 0 so we modified above to match this. Even though it should be 7 in table DayOfweek
	--if @TempDayOfTheWeekID = 7
	--   set @TempDayOfTheWeekID = 0

	print 'test TempLocalTime = ' + cast(@TempLocalTime as varchar)
	print 'test TempTimeSlot5minID = ' + cast(@TempTimeSlot5minID as varchar)
	print 'test TempTimeSlot10minID = ' + cast(@TempTimeSlot10minID as varchar)
	print 'test TimeSlotHourlyID = ' + cast(@TempTimeSlotHourlyID as varchar)
	print 'test TempCustomerSessionID = ' + cast(@TempCustomerSessionID as varchar)
	print 'test TempID = ' + cast(@CurrentBagWeightUpdateID as varchar)


	select @TempDayOfTheWeekID = ID from [CUSSReportingDB_DXB].[dbo].DayOfTheWeek where lower(DayOfTheWeek) = lower(DATENAME(WEEKDAY, @TempLocalTime))

	if @IsTest = 1
			  begin
			  print 'test insert action called = ' + cast(@Cnt as varchar)
			  if not exists(select ID from @tbBagWeightUpdate where ID = @CurrentBagWeightUpdateID)	
			  begin
				insert into @tbBagWeightUpdate(
					   [ID]
					  ,[BagID]					  
					  ,[Weight]					  
					  ,[UtcTime]
					  ,[CustomerSessionID]
					  ,[TimeSlot5minID]
					  ,[TimeSlot10minID]
					  ,[TimeSlotHourlyID]
					  ,[DayOfTheWeekID]
					  ,[LocalTime]
					  ,[AbdStationID]		
				)
				select 
					   @CurrentBagWeightUpdateID 
					  ,@TempBagID 					 
					  ,@TempWeight
					  ,@TempUtcTime
					  ,@TempCustomerSessionID					   
					  ,@TempTimeSlot5minID 
					  ,@TempTimeSlot10minID
					  ,@TempTimeSlotHourlyID 
					  ,@TempDayOfTheWeekID
					  ,@TempLocalTime
					  ,@TempAbdStationID			 
			  end
			  
			  select @CntTotal = @CntTotal + 1
	end
	else
			  begin
				  if not exists(select ID from [CussReportingDB_DXB].[dbo].[BagWeightUpdate] where ID = @TempCustomerSessionID)	
				  begin
					insert into CussReportingDB_DXB.dbo.[BagWeightUpdate](
					   [ID]
					  ,[BagID]					  
					  ,[Weight]					  
					  ,[UtcTime]
					  ,[CustomerSessionID]
					  ,[TimeSlot5minID]
					  ,[TimeSlot10minID]
					  ,[TimeSlotHourlyID]
					  ,[DayOfTheWeekID]
					  ,[LocalTime]
					  ,[AbdStationID]		
					)
					select 
					   @CurrentBagWeightUpdateID 
					  ,@TempBagID 					 
					  ,@TempWeight
					  ,@TempUtcTime
					  ,@TempCustomerSessionID					   
					  ,@TempTimeSlot5minID 
					  ,@TempTimeSlot10minID
					  ,@TempTimeSlotHourlyID 
					  ,@TempDayOfTheWeekID
					  ,@TempLocalTime
					  ,@TempAbdStationID	

					select @CntTotal = @CntTotal + 1
			  end
	end 
	SELECT @Cnt = @Cnt + 1		
	END
 

 if @IsTest = 1
begin 
	select * from @tbBagWeightUpdate
	print 'Total ' + cast(@CntTotal as varchar) + ' record(s) has been inserted'
end

else

begin
    print 'Total ' + cast(@CntTotal as varchar) + ' record(s) has been inserted into table CussReportingDB_DXB.dbo.CustomerSession'	   
end