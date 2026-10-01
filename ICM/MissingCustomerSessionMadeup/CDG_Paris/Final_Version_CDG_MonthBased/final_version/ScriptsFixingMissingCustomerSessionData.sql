    --This script will help to insert missing records which CUSS supposed to transfer them from [CussBagDropDB].[dbo].[CustomerSession] need to be transferred into [CussReportingDB].[dbo].[CustomerSession]
	--By default it is daily based processing, it can be modified for daily processing.
	--Main purpose: When CUSS engine may miss out transferring some records to CUSSReportingDB database CustomerSession table we use this to this script to make them up
	--Date: 12-03-2022 Eric He

	--NOTE: please check @IsTest value before exectuing this script
	--***********************************************************************************************************************
    DECLARE @IsTest bit = 0 --if against production please set this value to 0. Local run this process set it as 1

	declare @DailyRun  bit = 0                           --default it as daily run mode if it is 1, if its value is 0 then it is monthly running mode	 
	declare @UpdateMonthFirstDay datetime = '2021-11-01' --If @DailyRun = 0, please set this value as the first day of your target month. '2021-11-01' means process all records with in November 2021

	declare @UTC_LOCAL_HOURS int = 1 --Paris is 1 hour earlier than UTC time so we set this value as 1. For Sydney time it should be 11
	declare @RowsPerInsertBatch  bigint = 10000  --define the number of rows which batch insert will take to do the database: CUSSReportingDB insert 
	declare @NoRecordsNeedInsert bigint
	--***********************************************************************************************************************
    
	select @NoRecordsNeedInsert = count(ID) from CussBagDropDB.dbo.CustomerSession -- 2525 records
	where datepart(year, UtcCreationTime) = datepart(year, @UpdateMonthFirstDay) 
	and datepart(month, UtcCreationTime) = datepart(month, @UpdateMonthFirstDay) 
	and datepart(day, UtcCreationTime) = case @DailyRun when 1 then datepart(day, @UpdateMonthFirstDay) else datepart(day, UtcCreationTime) end
	and not ID in 
	(
	select ID from CussReportingDB.dbo.CustomerSession where 
	     datepart(year, UtcCreationTime) = datepart(year, @UpdateMonthFirstDay) 
	     and datepart(month, UtcCreationTime) = datepart(month, @UpdateMonthFirstDay) 
	     and datepart(day, UtcCreationTime) = case @DailyRun when 1 then datepart(day, @UpdateMonthFirstDay) else datepart(day, UtcCreationTime) end
	)
	 
	if @DailyRun = 1 
	   print 'In this day ' + cast(cast(@UpdateMonthFirstDay as date) as varchar(50)) + ', there are total ' + cast(@NoRecordsNeedInsert as varchar) + ' records need to be transferred'
	else
	begin
	    declare @UpdateMonthText  varchar(50)
		select @UpdateMonthText = cast(datepart(year, @UpdateMonthFirstDay) as varchar)  + '-' + cast(datepart(month, @UpdateMonthFirstDay) as varchar) 
		print 'In this month ' + @UpdateMonthText + ', there are total ' + cast(@NoRecordsNeedInsert as varchar) + ' records need to be transferred'
	end
	------------------------------------------------------------------------------	

	if @IsTest = 1
	begin
		DECLARE @tbCustomerSession TABLE
		(
			[ID] [bigint] NOT NULL,
			[CustomerID] [bigint] NOT NULL,
			[AbdStationID] [int] NOT NULL,
			[CustomerLookupType] [nvarchar](25) NOT NULL,
			[PNR] [nvarchar](50) NULL,
			[UtcCreationTime] [datetime] NOT NULL,
			[FlightID] [bigint] NULL,
			[TimeSlot5minID] [int] NULL,
			[TimeSlot10minID] [int] NULL,
			[TimeSlotHourlyID] [int] NULL,
			[DayOfTheWeekID] [int] NULL,
			[LocalTime] [datetime] NULL,
			[UtcCompletionTime] [datetime] NULL,
			[SessionDuration] [float] NULL
		) 
	end

	DECLARE @MyTable TABLE
	(
	SNo int IDENTITY(1,1), 
	CustomerSessionID int
	)    
	INSERT INTO @MyTable(CustomerSessionID)	    
	select ID from CussBagDropDB.dbo.CustomerSession -- 2525 records
	where datepart(year, UtcCreationTime) = datepart(year, @UpdateMonthFirstDay) 
	and datepart(month, UtcCreationTime) = datepart(month, @UpdateMonthFirstDay) 
	and datepart(day, UtcCreationTime) = case @DailyRun when 1 then datepart(day, @UpdateMonthFirstDay) else datepart(day, UtcCreationTime) end
	and not ID in 
	(
	select ID from CussReportingDB.dbo.CustomerSession where 
	    datepart(year, UtcCreationTime) = datepart(year, @UpdateMonthFirstDay) 
	and datepart(month, UtcCreationTime) = datepart(month, @UpdateMonthFirstDay) 
	and datepart(day, UtcCreationTime) = case @DailyRun when 1 then datepart(day, @UpdateMonthFirstDay) else datepart(day, UtcCreationTime) end
	)	 
	order by ID desc

	if (select count(*) from @MyTable) = 0
	  print 'No records needs to be inserted'

	
	DECLARE @CurrentCustomerSessionID INT

	DECLARE @TempCustomerSessionID INT
	DECLARE @TempCustomerID INT
	DECLARE @TempAbdStationID INT
	DECLARE @TempCustomerLookupType NVARCHAR(25)
	DECLARE @TempPNR NVARCHAR(50)
	DECLARE @TempUtcCreationTime DATETIME
	DECLARE @TempFlightID BIGINT = null 
	DECLARE @TempTimeSlot5minID INT = null
	DECLARE @TempTimeSlot10minID  INT = null
	DECLARE @TempTimeSlotHourlyID  INT = null
	DECLARE @TempDayOfTheWeekID INT = null
	DECLARE @TempLocalTime  DATETIME
	DECLARE @TempUtcCompletionTime DATETIME
	DECLARE @TempLocalCreationTime  DATETIME
	DECLARE @TempSessionDuration FLOAT
	DECLARE @TempApplicationSessionId INT

	DECLARE @CntTotal INT = 0
	DECLARE @CntInternalTotal INT = 0
	DECLARE @CntBatchInertCount INT = 0

    DECLARE @Cnt INT
	SELECT @Cnt = MIN(Sno) FROM @MyTable
	
	WHILE (1=1)
	BEGIN
   
	SELECT @CurrentCustomerSessionID = CustomerSessionID FROM @MyTable
	WHERE SNo = @Cnt
	    
	IF @@ROWCOUNT = 0
		BREAK

       SELECT  
       @TempCustomerSessionID = [ID]
      ,@TempCustomerID = [CustomerID]
      ,@TempAbdStationID = [AbdStationID]
      ,@TempCustomerLookupType = [CustomerLookupType]
      ,@TempPNR = [PNR]
      ,@TempUtcCreationTime = [UtcCreationTime]
      ,@TempFlightID = [FlightID] 
      ,@TempUtcCompletionTime = [UtcCompletionTime]
	  ,@TempLocalCreationTime = [LocalCreationTime]
	  ,@TempApplicationSessionId = [ApplicationSessionId]       
      FROM [CUSSBagDropDB].[dbo].[CustomerSession] WHERE ID = @CurrentCustomerSessionID

	--select @TempLocalTime = CONVERT(datetime, SWITCHOFFSET(CONVERT(datetimeoffset, @TempUtcCreationTime), DATENAME(TzOffset, SYSDATETIMEOFFSET()))) 
	select @TempLocalTime = dateadd(hour, @UTC_LOCAL_HOURS, @TempUtcCreationTime)  --Dubai local time is 4 hour ealier than UTC time

	select @TempTimeSlot5minID =  ID from [CUSSReportingDB].[dbo].[TimeSlot5min] where 
		cast(convert(varchar, cast([FromTime] as date)) + ' ' +  SUBSTRING(convert(varchar, @TempLocalTime, 108), 1,5) + ':00:000' as datetime) >= [FromTime]
	and 
		cast(convert(varchar, cast([ToTime] as date)) + ' ' +  SUBSTRING(convert(varchar, @TempLocalTime, 108), 1,5) + ':00:000' as datetime) < [ToTime]

	select @TempTimeSlot10minID = ID from [CUSSReportingDB].[dbo].[TimeSlot10Min] where 
		cast(convert(varchar, cast([FromTime] as date)) + ' ' +  SUBSTRING(convert(varchar, @TempLocalTime, 108), 1,5) + ':00:000' as datetime) >= [FromTime]
	and 
		cast(convert(varchar, cast([ToTime] as date)) + ' ' +  SUBSTRING(convert(varchar, @TempLocalTime, 108), 1,5) + ':00:000' as datetime) < [ToTime]

	select @TempTimeSlotHourlyID = ID from [CUSSReportingDB].[dbo].[TimeSlotHourly] where 
		cast(convert(varchar, cast([FromTime] as date)) + ' ' +  SUBSTRING(convert(varchar, @TempLocalTime, 108), 1,5) + ':00:000' as datetime) >= [FromTime]
	and 
		cast(convert(varchar, cast([ToTime] as date)) + ' ' +  SUBSTRING(convert(varchar, @TempLocalTime, 108), 1,5) + ':00:000' as datetime) < [ToTime]

	if DatePart(year, @TempUtcCompletionTime) != 2000 and DatePart(year, @TempUtcCompletionTime) != 1900 
	begin
			--select @TempSessionDuration = DATEDIFF(SECOND, @TempUtcCompletionTime, @TempUtcCreationTime)
			  select @TempSessionDuration = cast(FLOOR(cast(DATEDIFF(MILLISECOND, @TempUtcCreationTime, @TempUtcCompletionTime) as decimal(10, 0))/1000) as decimal(10,0))			 			   
	end
	else
	          select @TempSessionDuration = 0

    --print 'test CurrentCustomerSessionID = ' + cast(@CurrentCustomerSessionID as varchar)
	--print 'test TempLocalTime = ' + cast(@TempLocalTime as varchar)
	--print 'test TempTimeSlot5minID = ' + cast(@TempTimeSlot5minID as varchar)
	--print 'test TempTimeSlot10minID = ' + cast(@TempTimeSlot10minID as varchar)
	--print 'test TimeSlotHourlyID = ' + cast(@TempTimeSlotHourlyID as varchar)
	--print 'test TempSessionDuration = ' + cast(@TempSessionDuration as varchar)
	--print 'test TempCustomerSessionID = ' + cast(@TempCustomerSessionID as varchar)

	--print 'test TempUtcCreationTime = ' + cast(isnull(@TempUtcCreationTime, '') as varchar)
	--print 'test TempUtcCompletionTime = ' + cast(isnull(@TempUtcCompletionTime, '') as varchar)


	select @TempDayOfTheWeekID = ID from [CUSSReportingDB].[dbo].DayOfTheWeek where lower(DayOfTheWeek) = lower(DATENAME(WEEKDAY, @TempLocalTime))
	--in c# CUSS Engine code Sunday has been set as 0 so we modified above to match this. Even though it should be 7 in table DayOfweek
	--if @TempDayOfTheWeekID = 7
	--   set @TempDayOfTheWeekID = 0

	if @IsTest = 1
			  begin
			  print 'test insert action called = ' + cast(@Cnt as varchar)
			  if not exists(select ID from @tbCustomerSession where ID = @TempCustomerSessionID)	
			  begin
				insert into @tbCustomerSession(
					   [ID]
					  ,[CustomerID]
					  ,[AbdStationID]
					  ,[CustomerLookupType]
					  ,[PNR]
					  ,[UtcCreationTime]
					  ,[FlightID]
					  ,[TimeSlot5minID]
					  ,[TimeSlot10minID]
					  ,[TimeSlotHourlyID]
					  ,[DayOfTheWeekID]
					  ,[LocalTime]
					  ,[UtcCompletionTime]
					  ,[SessionDuration]		
				)
				select 
					   @TempCustomerSessionID 
					  ,@TempCustomerID 
					  ,@TempAbdStationID
					  ,@TempCustomerLookupType
					  ,@TempPNR
					  ,@TempUtcCreationTime
					  ,@TempFlightID
					  ,@TempTimeSlot5minID 
					  ,@TempTimeSlot10minID
					  ,@TempTimeSlotHourlyID 
					  ,@TempDayOfTheWeekID
					  ,@TempLocalTime
					  ,@TempUtcCompletionTime
					  ,@TempSessionDuration				 
			  end
			  
			  select @CntTotal = @CntTotal + 1
	end
	else
			  begin
				  if not exists(select ID from [CussReportingDB].[dbo].[CustomerSession] where ID = @TempCustomerSessionID)	
				  begin
					insert into @tbCustomerSession(
						   [ID]
						  ,[CustomerID]
						  ,[AbdStationID]
						  ,[CustomerLookupType]
						  ,[PNR]
						  ,[UtcCreationTime]
						  ,[FlightID]
						  ,[TimeSlot5minID]
						  ,[TimeSlot10minID]
						  ,[TimeSlotHourlyID]
						  ,[DayOfTheWeekID]
						  ,[LocalTime]
						  ,[UtcCompletionTime]
						  ,[SessionDuration]		
					)
					select 
						   @TempCustomerSessionID 
						  ,@TempCustomerID 
						  ,@TempAbdStationID
						  ,@TempCustomerLookupType
						  ,@TempPNR
						  ,@TempUtcCreationTime
						  ,@TempFlightID
						  ,@TempTimeSlot5minID 
						  ,@TempTimeSlot10minID
						  ,@TempTimeSlotHourlyID 
						  ,@TempDayOfTheWeekID
						  ,@TempLocalTime
						  ,@TempUtcCompletionTime
						  ,@TempSessionDuration			

					select @CntTotal = @CntTotal + 1
					select @CntInternalTotal = @CntInternalTotal + 1  --this is internal row count once it reach @RowsPerInsertBatch we do real DB insert action

					--we take real action once the temp table @tbCustomerSession got @RowsPerInsertBatch records
					--or it reaches to the max number of rows we need insert
					if @CntInternalTotal = @RowsPerInsertBatch or @CntTotal = @NoRecordsNeedInsert 
					begin
						--insert into CUSSReportingDB table CustomerSession table using bulk insert so it can speed up insert speed
						insert into CussReportingDB.dbo.CustomerSession(
							[ID]
							,[CustomerID]
							,[AbdStationID]
							,[CustomerLookupType]
							,[PNR]
							,[UtcCreationTime]
							,[FlightID]
							,[TimeSlot5minID]
							,[TimeSlot10minID]
							,[TimeSlotHourlyID]
							,[DayOfTheWeekID]
							,[LocalTime]
							,[UtcCompletionTime]
							,[SessionDuration]		
							)
							select 
							[ID] [bigint],
							[CustomerID],
							[AbdStationID],
							[CustomerLookupType],
							[PNR],
							[UtcCreationTime],
							[FlightID],
							[TimeSlot5minID],
							[TimeSlot10minID],
							[TimeSlotHourlyID],
							[DayOfTheWeekID],
							[LocalTime],
							[UtcCompletionTime],
							[SessionDuration]
							from @tbCustomerSession

						select @CntBatchInertCount = @CntBatchInertCount + 1
						select @CntInternalTotal = 0  --reset the default insert action row value currently we set it as @RowsPerInsertBatch
						delete from @tbCustomerSession
						print 'Batch insert count ' + cast(@CntBatchInertCount as varchar) + ' => ' + cast(@RowsPerInsertBatch as varchar) + ' record(s) has been inserted'
					end
			      end
	           end 
	SELECT @Cnt = @Cnt + 1		
	END
 

 if @IsTest = 1
begin 
	select * from @tbCustomerSession order by ID desc
	print 'Total ' + cast(@CntTotal as varchar) + ' record(s) has been inserted'
end

else

begin
    print 'Total ' + cast(@CntTotal as varchar) + ' record(s) has been inserted into table CussReportingDB.dbo.CustomerSession'	   
end