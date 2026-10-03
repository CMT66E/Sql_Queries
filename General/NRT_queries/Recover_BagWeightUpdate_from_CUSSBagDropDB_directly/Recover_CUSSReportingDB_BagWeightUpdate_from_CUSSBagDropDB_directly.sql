    --This script will help to recover BagWeightUpdate records by exporting data from CUSSBagDropDB reporting database and importing them into CUSS reporting system for reporting purposes
	--For example we transfer them from [BagDropDB_NRT].[dbo].[CustomerSession] to [CUSSReportingDB].[dbo].[BagWeightUpdate] 
	-- 
	--Main ideas: When CUSSReportingDB BagWeightUpdate data missing some records we can get them from CussBagDropDB database in NRT airport at CustomerSession 
	--BagWeightUpdate tables and insert them into BagDrop CustomerSession, BagWeightUpdate tables
	--Date: 30-03-2022 Eric He

	--NOTE: please check @IsTest value before exectuing this script
	--***********************************************************************************************************************
    DECLARE @IsTest bit = 1 --if against production please set this value to 0. Local run this process set it as 1
	declare @UpdateMonthFirstDay datetime = '2026-06-01' -- please set this value as the first day of your target month. '2021-10-01' means process all records with in October 2021, comment out the day value to handle the monthly data
	declare @UTC_LOCAL_HOURS int = 10 --Tokyo is 9 hours earlier than UTC time so we set this value as 9. For Sydney time it should be 11 
	--***********************************************************************************************************************
	declare @FromDate datetime = '2026-06-01 00:00:00'
	declare @ToDateTime datetime ='2026-06-30 23:59:59'
	declare @Terminal nvarchar(10) = '%'
	declare @Area nvarchar(10) = '%'
	declare @SubArea nvarchar(10) ='%'
	declare @ABDStationIDs varchar(400) = ',150,158,164,151,159,160,157,161,162,163,167,166,165,153,147,148,149,152,154,155,144,145,156,146,'  --'144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167'
	declare @ABDStationNames varchar(4000) = 'T3_L_S_ABD_001,T3_L_S_ABD_002,T3_L_S_ABD_003,T3_L_S_ABD_004,T3_L_S_ABD_005,T3_L_S_ABD_006,T3_L_S_ABD_007,T3_L_S_ABD_008,T3_L_S_ABD_009,T3_L_S_ABD_010,T3_L_S_ABD_011,T3_L_S_ABD_012,T3_L_S_ABD_013,T3_L_S_ABD_014,T3_L_S_ABD_015,T3_L_S_ABD_016,T3_L_S_ABD_017,T3_L_S_ABD_018,T3_L_S_ABD_019,T3_L_S_ABD_020,T3_L_S_ABD_021,T3_L_S_ABD_022,T3_L_S_ABD_023,T3_L_S_ABD_024'
	
	---start temp table --
	DROP TABLE IF EXISTS #TempBagWeightUpdate;
	CREATE TABLE #TempBagWeightUpdate (
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
	);
	--end temp table --
   
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
	  FROM [CUSSBagDropDB_NRT].[dbo].[CustomerSession]
	WHERE 
	datepart(year, LocalCreationTime) = datepart(year, @UpdateMonthFirstDay) and datepart(month, LocalCreationTime) = datepart(month, @UpdateMonthFirstDay)  
	AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStationID AS varchar(10)) + ',', @ABDStationIDs) > 0) AND DATEDIFF(second, [LocalCreationTime], [LocalCompletionTime]) > 20 -- at least took more than 20 seconds then we treat them as checked-in
	order by ID desc

	select * from @MyTable

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
      ,@TempBagID = [AbdStationID]
      ,@TempWeight = 16
      ,@TempUtcTime = [UtcCreationTime]
      ,@TempCustomerSessionID = [ID]
      ,@TempLocalTime = [LocalCreationTime]       
      FROM [CUSSBagDropDB_NRT].[dbo].[CustomerSession] WHERE ID = @CurrentBagWeightUpdateID

	--select @TempLocalTime = CONVERT(datetime, SWITCHOFFSET(CONVERT(datetimeoffset, @TempUtcTime), DATENAME(TzOffset, SYSDATETIMEOFFSET()))) 
	select @TempLocalTime = dateadd(hour, @UTC_LOCAL_HOURS, @TempUtcTime) 

	select @TempTimeSlot5minID =  ID from [CUSSReportingDB_NRT].[dbo].[TimeSlot5min] where 
		cast(convert(varchar, cast([FromTime] as date)) + ' ' +  SUBSTRING(convert(varchar, @TempLocalTime, 108), 1,5) + ':00:000' as datetime) >= [FromTime]
	and 
		cast(convert(varchar, cast([ToTime] as date)) + ' ' +  SUBSTRING(convert(varchar, @TempLocalTime, 108), 1,5) + ':00:000' as datetime) < [ToTime]

	select @TempTimeSlot10minID = ID from [ReportingDB_NRT].[dbo].[TimeSlot10Min] where 
		cast(convert(varchar, cast([FromTime] as date)) + ' ' +  SUBSTRING(convert(varchar, @TempLocalTime, 108), 1,5) + ':00:000' as datetime) >= [FromTime]
	and 
		cast(convert(varchar, cast([ToTime] as date)) + ' ' +  SUBSTRING(convert(varchar, @TempLocalTime, 108), 1,5) + ':00:000' as datetime) < [ToTime]

	select @TempTimeSlotHourlyID = ID from [ReportingDB_NRT].[dbo].[TimeSlotHourly] where 
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


	select @TempDayOfTheWeekID = ID from [ReportingDB_NRT].[dbo].DayOfTheWeek where lower(DayOfTheWeek) = lower(DATENAME(WEEKDAY, @TempLocalTime))

	if @IsTest = 1
			  begin
			  print 'test insert action called = ' + cast(@Cnt as varchar)
			  if not exists(select ID from #TempBagWeightUpdate where ID = @CurrentBagWeightUpdateID)	
			  begin
				insert into #TempBagWeightUpdate(
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
				  if not exists(select ID from [ReportingDB_NRT].[dbo].[BagWeightUpdate] where ID = @CurrentBagWeightUpdateID)	
				  begin
				    print 'comment out the actual DB insert action below'
					--insert into [ReportingDB_NRT].dbo.[BagWeightUpdate](
					--   [ID]
					--  ,[BagID]					  
					--  ,[Weight]					  
					--  ,[UtcTime]
					--  ,[CustomerSessionID]
					--  ,[TimeSlot5minID]
					--  ,[TimeSlot10minID]
					--  ,[TimeSlotHourlyID]
					--  ,[DayOfTheWeekID]
					--  ,[LocalTime]
					--  ,[AbdStationID]		
					--)
					--select 
					--   @CurrentBagWeightUpdateID 
					--  ,@TempBagID 					 
					--  ,@TempWeight
					--  ,@TempUtcTime
					--  ,@TempCustomerSessionID					   
					--  ,@TempTimeSlot5minID 
					--  ,@TempTimeSlot10minID
					--  ,@TempTimeSlotHourlyID 
					--  ,@TempDayOfTheWeekID
					--  ,@TempLocalTime
					--  ,@TempAbdStationID	

					select @CntTotal = @CntTotal + 1
			  end
	end 
	SELECT @Cnt = @Cnt + 1		
	END
 

 if @IsTest = 1
begin 
	select * from #TempBagWeightUpdate
	print 'Total ' + cast(@CntTotal as varchar) + ' record(s) has been inserted'
end

else

begin
    print 'Total ' + cast(@CntTotal as varchar) + ' record(s) has been inserted into table ReportingDB_NRT.dbo.BagWeightUpdate'	   
end



