    --This script will help to insert missing records which airline reporting engine supposed to transfer them from [BagDropDB_QF_NEW].[dbo].[BagWeightUpdate] to [ReportingDB_QF_NEW].[dbo].[BagWeightUpdate] in QF domestic airport
	--By default it is batch based processing, it can be modified for daily processing.
	--Main purpose: When airline reporting engine miss out transferring some records to ReportingDB_QF_NEW database in QF domestic airport at BagWeightUpdate table we use this to this script to make them up
	--Date: 02-03-2022 Eric He

	--NOTE: please check @IsTest value before exectuing this script
	--***********************************************************************************************************************
	declare @FromDateTime DateTime = '2022/11/19 00:00:00'
    declare @IsTest bit = 1 --if against production please set this value to 0. Local testing run this process set it as 1
	declare @MaxIDReportingDB bigint -- it is the MAX value of IDs in DB: [CUSSReportingDB] on table [CustomerSession]
	declare @UTC_LOCAL_HOURS int = 11 --CDG is 1 hours earlier than UTC time so we set this value as 1. For Sydney time it should be 11
	declare @RowsPerInsertBatch  bigint = 10000  --define the number of rows which batch insert will take to do the database: CUSSReportingDB insert 
	--***********************************************************************************************************************
	
	------------------------------------------------------------------------------
	declare @NoRecordsNeedInsert  bigint
	SELECT @NoRecordsNeedInsert = count(a.ID)
	  FROM [BagDropDB_QF_NEW].[dbo].[BagWeightUpdate] a 
	  inner join CustomerSession b on a.CustomerSessionID = b.ID
	  inner join AbdStation c on b.AbdStationID = c.ID
	where DATEPART(year, a.[LocalTime])= DATEPART(year, @FromDateTime) 
	  and DATEPART(month, a.[LocalTime])= DATEPART(month, @FromDateTime)
	  and DATEPART(day, a.[LocalTime]) in (19, 20, 21)
	  and c.PortCode = 'WLG'
	  and a.Weight > 0
	  and NOT a.ID in
	  (
		SELECT a.ID
		  FROM [ReportingDB_QF_New].[dbo].[BagWeightUpdate] a 
		  inner join CustomerSession b on a.ID = b.AbdStationID
		  inner join AbdStation c on b.AbdStationID = c.ID
		where DATEPART(year, a.[LocalTime])= DATEPART(year, @FromDateTime) 
		  and DATEPART(month, a.[LocalTime])= DATEPART(month, @FromDateTime)
		  and DATEPART(day, a.[LocalTime]) in (19, 20, 21)
		  and c.PortCode = 'WLG'
		  and a.Weight > 0
	  )

	print '@NoRecordsNeedInsert = ' + cast(@NoRecordsNeedInsert as varchar)
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

		DECLARE @tblBagWeightUpdate TABLE
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
	BagWeightUpdateID bigint,
	CustomerSessionID bigint
	)    
	INSERT INTO @MyTable(BagWeightUpdateID, CustomerSessionID)	    
	SELECT a.ID, a.CustomerSessionID
		FROM [BagDropDB_QF_NEW].[dbo].[BagWeightUpdate] a 
		inner join CustomerSession b on a.CustomerSessionID = b.ID
		inner join AbdStation c on b.AbdStationID = c.ID
	where DATEPART(year, a.[LocalTime])= DATEPART(year, @FromDateTime) 
		and DATEPART(month, a.[LocalTime])= DATEPART(month, @FromDateTime)
		and DATEPART(day, a.[LocalTime]) in (19, 20, 21)
		and c.PortCode = 'WLG'
		and a.Weight > 0
		and NOT a.ID in
		(
		SELECT a.ID
			FROM [ReportingDB_QF_New].[dbo].[BagWeightUpdate] a 
			inner join CustomerSession b on a.ID = b.AbdStationID
			inner join AbdStation c on b.AbdStationID = c.ID
		where DATEPART(year, a.[LocalTime])= DATEPART(year, @FromDateTime) 
			and DATEPART(month, a.[LocalTime])= DATEPART(month, @FromDateTime)
			and DATEPART(day, a.[LocalTime]) in (19, 20, 21)
			and c.PortCode = 'WLG'
			and a.Weight > 0
		)                             
	order by a.ID asc

	if (select count(*) from @MyTable) = 0
	  print 'No records needs to be inserted'
	else
	  print cast(@NoRecordsNeedInsert as varchar) + ' records needs to be inserted'

    --select * from @MyTable order by BagWeightUpdateID desc


	DECLARE @CurrentBagWeightUpdateID BIGINT
	DECLARE @CurrentCustomerSessionID BIGINT

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
	DECLARE @TempUtcCompletionTime DATETIME = null
	DECLARE @TempLocalCreationTime  DATETIME = null
	DECLARE @TempSessionDuration FLOAT
	DECLARE @TempApplicationSessionId INT

	DECLARE @CntTotal INT = 0
	DECLARE @CntInternalTotal INT = 0
	DECLARE @CntBatchInertCount INT = 0

    DECLARE @Cnt INT
	SELECT @Cnt = MIN(Sno) FROM @MyTable
	
	WHILE (1=1)
	BEGIN
   
	SELECT @CurrentBagWeightUpdateID = BagWeightUpdateID, @CurrentCustomerSessionID = CustomerSessionID FROM @MyTable  
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
      FROM [BagDropDB_QF_NEW].[dbo].[CustomerSession] WHERE ID = @CurrentCustomerSessionID

	--select @TempLocalTime = CONVERT(datetime, SWITCHOFFSET(CONVERT(datetimeoffset, @TempUtcCreationTime), DATENAME(TzOffset, SYSDATETIMEOFFSET()))) 
	select @TempLocalTime = dateadd(hour, @UTC_LOCAL_HOURS, @TempUtcCreationTime)  --Sydney local time is 11 hour ealier than UTC time

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
      
	--print 'test CurrentBagWeightUpdateID = ' + cast(@CurrentBagWeightUpdateID as varchar)
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
				--insert into @tbCustomerSession(
				--	   [ID]
				--	  ,[CustomerID]
				--	  ,[AbdStationID]
				--	  ,[CustomerLookupType]
				--	  ,[PNR]
				--	  ,[UtcCreationTime]
				--	  ,[FlightID]
				--	  ,[TimeSlot5minID]
				--	  ,[TimeSlot10minID]
				--	  ,[TimeSlotHourlyID]
				--	  ,[DayOfTheWeekID]
				--	  ,[LocalTime]
				--	  ,[UtcCompletionTime]
				--	  ,[SessionDuration]		
				--)
				--select 
				--	   @TempCustomerSessionID 
				--	  ,@TempCustomerID 
				--	  ,@TempAbdStationID
				--	  ,@TempCustomerLookupType
				--	  ,@TempPNR
				--	  ,@TempUtcCreationTime
				--	  ,@TempFlightID
				--	  ,@TempTimeSlot5minID 
				--	  ,@TempTimeSlot10minID
				--	  ,@TempTimeSlotHourlyID 
				--	  ,@TempDayOfTheWeekID
				--	  ,@TempLocalTime
				--	  ,@TempUtcCompletionTime
				--	  ,@TempSessionDuration		
					  
					  --------------------------
					insert into @tblBagWeightUpdate
					(
							[ID],
							[BagID],
							[Weight],
							[UtcTime],
							[CustomerSessionID],
							[TimeSlot5minID],
							[TimeSlot10minID],
							[TimeSlotHourlyID],
							[DayOfTheWeekID],
							[LocalTime],
							[AbdStationID]
					)
					select 
						@CurrentBagWeightUpdateID,
						[BagID],
						[Weight],
						UtcTime,
						CustomerSessionID,
						@TempTimeSlot5minID, 
						@TempTimeSlot10minID,
						@TempTimeSlotHourlyID, 
						@TempDayOfTheWeekID,
						LocalTime,
						@TempAbdStationID
					from [BagDropDB_QF_NEW].[dbo].[BagWeightUpdate] where ID = @CurrentBagWeightUpdateID  
			  end
			  
			  select @CntTotal = @CntTotal + 1
	end
	else
			  begin
				  if not exists(select ID from [ReportingDB_QF_New].[dbo].[BagWeightUpdate] where ID = @CurrentBagWeightUpdateID)	
				  begin
					--insert into @tbCustomerSession(
					--	   [ID]
					--	  ,[CustomerID]
					--	  ,[AbdStationID]
					--	  ,[CustomerLookupType]
					--	  ,[PNR]
					--	  ,[UtcCreationTime]
					--	  ,[FlightID]
					--	  ,[TimeSlot5minID]
					--	  ,[TimeSlot10minID]
					--	  ,[TimeSlotHourlyID]
					--	  ,[DayOfTheWeekID]
					--	  ,[LocalTime]
					--	  ,[UtcCompletionTime]
					--	  ,[SessionDuration]		
					--)
					--select 
					--	   @TempCustomerSessionID 
					--	  ,@TempCustomerID 
					--	  ,@TempAbdStationID
					--	  ,@TempCustomerLookupType
					--	  ,@TempPNR
					--	  ,@TempUtcCreationTime
					--	  ,@TempFlightID
					--	  ,@TempTimeSlot5minID 
					--	  ,@TempTimeSlot10minID
					--	  ,@TempTimeSlotHourlyID 
					--	  ,@TempDayOfTheWeekID
					--	  ,@TempLocalTime
					--	  ,@TempUtcCompletionTime
					--	  ,@TempSessionDuration		
						  
					insert into [ReportingDB_QF_New].[dbo].[BagWeightUpdate]
					(
							[ID],
							[BagID],
							[Weight],
							[UtcTime],
							[CustomerSessionID],
							[TimeSlot5minID],
							[TimeSlot10minID],
							[TimeSlotHourlyID],
							[DayOfTheWeekID],
							[LocalTime],
							[AbdStationID]
					)
					select 
						@CurrentBagWeightUpdateID,
						[BagID],
						[Weight],
						UtcTime,
						CustomerSessionID,
						@TempTimeSlot5minID, 
						@TempTimeSlot10minID,
						@TempTimeSlotHourlyID, 
						@TempDayOfTheWeekID,
						LocalTime,
						@TempAbdStationID
					from [BagDropDB_QF_NEW].[dbo].[BagWeightUpdate] where ID = @CurrentBagWeightUpdateID  

					select @CntTotal = @CntTotal + 1
					select @CntInternalTotal = @CntInternalTotal + 1  --this is internal row count once it reach @RowsPerInsertBatch we do real DB insert action

			      end
	           end 
	SELECT @Cnt = @Cnt + 1		
	END
 

 if @IsTest = 1
begin 
	select * from @tblBagWeightUpdate order by ID desc
	print 'Total ' + cast(@CntTotal as varchar) + ' record(s) has been inserted'
end

else

begin
    print 'Total ' + cast(@CntTotal as varchar) + ' record(s) has been inserted into table CussReportingDB.dbo.CustomerSession'	   
end