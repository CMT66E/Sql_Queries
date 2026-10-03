    --This script will help to recover missing records by exporting data from CUSS reporting system CUSSReportingDB_NRT_FEB2026 and importing them into CUSSReportingDB_NRT reporting system for NRT airport which its CUSS reporting data is missing in both tables: BagWeightUpdate and CustomerSession
	--For example we transfer them from 
	-- [ReportingDB_NRT_FEB2026].[dbo].[CustomerSession] to [ReportingDB_NRT].[dbo].[CustomerSession] and 
	-- [ReportingDB_NRT_FEB2026].[dbo].[BagWeightUpdate] to [ReportingDB_NRT].[dbo].[BagWeightUpdate] and bag information data etc.

	-- 
	--It is only used for Japan NRT airport data missing in February 2026.
	--Main ideas: When CUSS reporting missing some records we get them from CUSSReportingDB_NRT_FEB2026 database in NRT airport at CustomerSession, BagWeightUpdate tables and insert them into CUSSReportingDB_NRT CustomerSession, BagWeightUpdate tables
	--Date: 09-04-2026 Eric He

	--NOTE: please check @IsTest value before exectuing this script
	--***********************************************************************************************************************
    DECLARE @IsTest bit = 0 -- if against production please set this value to 0. Local run this process set it as 1

	 
	declare @UpdateMonthFirstDay datetime = '2026-02-24' -- This is the target day which we need recover data from CUSSReportingDB_NRT_FEB2026 reporting system into CUSSReportingDB_NRT reporting system, please run this script one by one by setting it as : 2022-03-24, 2022-03-25, 2022-03-26, 2022-03-27, 2022-03-28 individually

	declare @UTC_LOCAL_HOURS int = 9                     -- NRT is 9 hour earlier than UTC time so we set this value as 1. For Sydney time it should be 11
	declare @RowsPerInsertBatch  bigint = 1              -- define the number of rows which batch insert will take to do the database insert 
	declare @NoRecordsNeedInsert bigint

	declare @TargetAirline VARCHAR(10) = 'ZE'
	--***********************************************************************************************************************
    
	select @NoRecordsNeedInsert = count(distinct a.ID) 
	from 
	[ReportingDB_NRT_FEB2026].[dbo].[BagWeightUpdate] a 
	inner join [ReportingDB_NRT_FEB2026].[dbo].[CustomerSession] b on a.CustomerSessionID = b.ID
	inner join [ReportingDB_NRT_FEB2026].[dbo].[Flight] c on b.FlightID = c.ID
	WHERE 
	DATEPART(year, a.LocalTime) = DATEPART(year, @UpdateMonthFirstDay) and 
	DATEPART(month, a.LocalTime) = DATEPART(month, @UpdateMonthFirstDay)  --Feb: 442,500 short 9,174 records Mar: 509,883
	and c.MarketingCarrier = @TargetAirline
	and NOT a.ID in
	(
		select a.ID from 
		[ReportingDB_NRT].[dbo].[BagWeightUpdate] a 
		inner join [ReportingDB_NRT].[dbo].[CustomerSession] b on a.CustomerSessionID = b.ID
		inner join [ReportingDB_NRT].[dbo].[Flight] c on b.FlightID = c.ID
		WHERE 
		DATEPART(year, a.LocalTime) = DATEPART(year, @UpdateMonthFirstDay) and 
		DATEPART(month, a.LocalTime) = DATEPART(month, @UpdateMonthFirstDay)  --Feb: 442,500 short 9,174 records Mar: 509,883
		and c.MarketingCarrier = @TargetAirline
	)
    --and a.Weight > 0
	
	print 'In this day ' + cast(cast(@UpdateMonthFirstDay as date) as varchar(50)) + ', there are total ' + cast(@NoRecordsNeedInsert as varchar) + ' records need to be transferred'
 
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
			[SessionDuration] [float] NULL,
			SessionEndReasonID [int] NULL,
			SessionEndPageID [int] NULL,
			MachineTime [float] NULL,
			PaxTime [float] NULL,
			DcsTime [float] NULL,
			BhsTime [float] NULL,
			CsaTime [float] NULL
		) 

		DECLARE @tbBagWeightUpdate TABLE
		(
			[ID] [bigint] NOT NULL,
			[BagID] [bigint] NOT NULL,
			[Weight] [decimal](18, 0) NOT NULL,
			[UtcTime] [datetime] NOT NULL,
			[CustomerSessionID] [bigint] NOT NULL,
			[TimeSlot5minID] [int] NOT NULL,
			[TimeSlot10minID] [int] NOT NULL,
			[TimeSlotHourlyID] [int] NOT NULL,
			[DayOfTheWeekID] [int] NOT NULL,
			[LocalTime] [datetime] NULL,
			AbdStationID [bigint] NOT NULL
		)

		DECLARE @tbCustomer TABLE
		(
			[ID] [bigint] IDENTITY(1,1) NOT NULL,
			[UCI] [nvarchar](50) NULL,
			[Title] [nvarchar](25) NULL,
			[GivenName] [nvarchar](255) NULL,
			[Surname] [nvarchar](255) NULL,
			[Gender] [nvarchar](25) NULL 
		)

		DECLARE @tbAbdStation TABLE
		(
			[ID] [int] NOT NULL,
			[PortCode] [nvarchar](10) NOT NULL,
			[Identifier] [nvarchar](10) NOT NULL,
			[AbdType] [nvarchar](10) NOT NULL,
			[Terminal] [nvarchar](10) NOT NULL,
			[Zone] [nvarchar](10) NULL,
			[Area] [nvarchar](10) NULL,
			[SubArea] [nvarchar](10) NULL
		)

		DECLARE @tbFlight TABLE
		(
			[ID] [bigint]  NOT NULL,
			[MarketingCarrier] [nvarchar](25) NOT NULL,
			[FlightNumber] [nvarchar](25) NOT NULL,
			[DepartureDate] [datetime] NOT NULL,
			[BoardPoint] [nvarchar](25) NULL,
			[OffPoint] [nvarchar](25) NULL,
			AirlineGroupID [int]  NOT NULL
		)

		DECLARE @tbBag TABLE
		(
			[ID] [bigint] NOT NULL,
			[UBI] [nvarchar](50) NOT NULL,
			[BagTagType] [nvarchar](25) NOT NULL
		)

	end

	DECLARE @MyTable TABLE
	(
	SNo int IDENTITY(1,1), 
	CustomerSessionID int
	)   

	INSERT INTO @MyTable(CustomerSessionID)	    
	select distinct a.CustomerSessionID  ----------------------please remove test contents if there is any
    from 
	[ReportingDB_NRT_FEB2026].[dbo].[BagWeightUpdate] a 
	inner join [ReportingDB_NRT_FEB2026].[dbo].[CustomerSession] b on a.CustomerSessionID = b.ID
	inner join [ReportingDB_NRT_FEB2026].[dbo].[Flight] c on b.FlightID = c.ID
	WHERE 
	DATEPART(year, a.LocalTime) = DATEPART(year, @UpdateMonthFirstDay) and 
	DATEPART(month, a.LocalTime) = DATEPART(month, @UpdateMonthFirstDay)  --Feb: 442,500 short 9,174 records Mar: 509,883
	and c.MarketingCarrier = @TargetAirline
	and NOT a.ID in
	(
		select a.ID from 
		[ReportingDB_NRT].[dbo].[BagWeightUpdate] a 
		inner join [ReportingDB_NRT].[dbo].[CustomerSession] b on a.CustomerSessionID = b.ID
		inner join [ReportingDB_NRT].[dbo].[Flight] c on b.FlightID = c.ID
		WHERE 
		DATEPART(year, a.LocalTime) = DATEPART(year, @UpdateMonthFirstDay) and 
		DATEPART(month, a.LocalTime) = DATEPART(month, @UpdateMonthFirstDay)  --Feb: 442,500 short 9,174 records Mar: 509,883
		and c.MarketingCarrier = @TargetAirline
	)

	---test line below
	select * from @MyTable

	if (select count(*) from @MyTable) = 0
	  print 'No records needs to be inserted'

	DECLARE @CurrentCustomerSessionID BIGINT
	DECLARE @TempCustomerSessionID BIGINT
	DECLARE @TempCustomerID BIGINT
	DECLARE @TempAbdStationID BIGINT
	DECLARE @TempCustomerLookupType NVARCHAR(25)
	DECLARE @TempPNR NVARCHAR(50)
	
	DECLARE @TempFlightID BIGINT = null 
	DECLARE @TempTimeSlot5minID INT = null
	DECLARE @TempTimeSlot10minID  INT = null
	DECLARE @TempTimeSlotHourlyID  INT = null
	DECLARE @TempDayOfTheWeekID INT = null
	DECLARE @TempLocalTime  DATETIME
	
	DECLARE @TempLocalCreationTime  DATETIME
	DECLARE @TempUtcCreationTime DATETIME

	DECLARE @TempLocalCompletionTime  DATETIME
	DECLARE @TempUtcCompletionTime DATETIME

	DECLARE @TempSessionDuration FLOAT

	DECLARE @TempSessionEndReasonID [int] = null
	DECLARE @TempSessionEndPageID [int] = null
	DECLARE @TempMachineTime [float] = null
	DECLARE @TempPaxTime [float] = null
	DECLARE @TempDcsTime [float] = null
	DECLARE @TempBhsTime [float] = null
	DECLARE @TempCsaTime [float] = null

	DECLARE @TempApplicationSessionId INT

	DECLARE @CntTotal INT = 0
	DECLARE @CntInternalTotal INT = 0
	DECLARE @CntBatchInertCount INT = 0

	--these variables will be created by SQL insert actions
	DECLARE @AutoTempCustomerSessionID BIGINT
	DECLARE @AutoTempCustomerID BIGINT
	DECLARE @AutoTempAbdStationID INT
	DECLARE @AutoTempFlightID BIGINT = null 

	declare @TempAbdStationInsertCount int = 0
	declare @TempFlightInsertCount int = 0
	declare @TempCustomerSessionInsertCount int = 0

	declare @TempBagInsertCount int = 0
	declare @TempBagWeightUpdateInsertCount int = 0

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
	  ,@TempTimeSlot5minID = [TimeSlot5minID]
	  ,@TempTimeSlot10minID = [TimeSlot10minID]
	  ,@TempTimeSlotHourlyID = [TimeSlotHourlyID]
	  ,@TempDayOfTheWeekID = [DayOfTheWeekID]
	  ,@TempLocalCreationTime = [LocalTime]
      ,@TempUtcCompletionTime = [UtcCompletionTime]
	  ,@TempSessionDuration = [SessionDuration] 
	 
	  ,@TempSessionEndReasonID = [SessionEndReasonID] 
	  ,@TempSessionEndPageID = [SessionEndPageID] 
	  ,@TempMachineTime = [MachineTime] 
	  ,@TempPaxTime = [PaxTime] 
	  ,@TempDcsTime = [DcsTime] 
	  ,@TempBhsTime = [BhsTime] 
	  ,@TempCsaTime = [CsaTime]  
      FROM [ReportingDB_NRT_FEB2026].[dbo].[CustomerSession] WHERE ID = @CurrentCustomerSessionID

	--select @TempLocalTime = CONVERT(datetime, SWITCHOFFSET(CONVERT(datetimeoffset, @TempUtcCreationTime), DATENAME(TzOffset, SYSDATETIMEOFFSET()))) 

	--select @TempLocalTime = dateadd(hour, @UTC_LOCAL_HOURS, @TempUtcCreationTime)              --Singapore local time is 8 hour ealier than UTC time
	--select @TempLocalCompletionTime = dateadd(hour, @UTC_LOCAL_HOURS, @TempUtcCompletionTime)  --Singapore local time is 8 hour ealier than UTC time

	--if DatePart(year, @TempUtcCompletionTime) != 2000 and DatePart(year, @TempUtcCompletionTime) != 1900 
	--begin
	--		--select @TempSessionDuration = DATEDIFF(SECOND, @TempUtcCompletionTime, @TempUtcCreationTime)
	--		  select @TempSessionDuration = cast(FLOOR(cast(DATEDIFF(MILLISECOND, @TempUtcCreationTime, @TempUtcCompletionTime) as decimal(10, 0))/1000) as decimal(10,0))			 			   
	--end
	--else
	--          select @TempSessionDuration = 0

	select @TempLocalTime = @TempLocalCreationTime
	select @TempLocalCompletionTime = @TempUtcCompletionTime

    print 'test CurrentCustomerSessionID = ' + cast(isnull(@CurrentCustomerSessionID, '') as varchar)
	print 'test @TempCustomerID = ' + cast(isnull(@TempCustomerID, '') as varchar)
	print 'test @TempAbdStationID = ' + cast(isnull(@TempAbdStationID, '') as varchar)
	print 'test @TempFlightID = ' + cast(isnull(@TempFlightID, '') as varchar)

	--insert into [BagDrop_SIN_ACTION].[dbo].[Customer]
	--select * from [CUSSBagDropDB_SIN].[dbo].[Customer] where ID  = @TempCustomerID
	--select @AutoTempCustomerID = @@IDENTITY


	--print 'test TempLocalTime = ' + cast(@TempLocalTime as varchar)
	--print 'test TempTimeSlot5minID = ' + cast(@TempTimeSlot5minID as varchar)
	--print 'test TempTimeSlot10minID = ' + cast(@TempTimeSlot10minID as varchar)
	--print 'test TimeSlotHourlyID = ' + cast(@TempTimeSlotHourlyID as varchar)
	--print 'test TempSessionDuration = ' + cast(@TempSessionDuration as varchar)
	--print 'test TempCustomerSessionID = ' + cast(@TempCustomerSessionID as varchar)

	--print 'test TempUtcCreationTime = ' + cast(isnull(@TempUtcCreationTime, '') as varchar)
	--print 'test TempUtcCompletionTime = ' + cast(isnull(@TempUtcCompletionTime, '') as varchar)

	--select @TempDayOfTheWeekID = ID from [CUSSReportingDB_CDG].[dbo].DayOfTheWeek where lower(DayOfTheWeek) = lower(DATENAME(WEEKDAY, @TempLocalTime))
	--in c# CUSS Engine code Sunday has been set as 0 so we modified above to match this. Even though it should be 7 in table DayOfweek
	--if @TempDayOfTheWeekID = 7
	--   set @TempDayOfTheWeekID = 0

	declare @TempAbdStationIDAirline int = 0
	declare @PortCode varchar(50) 
	declare @Identifier varchar(50)  
	declare @AbdType varchar(50) 
	declare @Terminal varchar(50)  
	declare @Zone varchar(50) 
	declare @Area varchar(50) 
	declare @SubArea varchar(50) 

	declare @TempFlightIDCuss int
	declare @TempFlightIDAirline int = 0
	declare @MarketingCarrier varchar(50) 
	declare @FlightNumber varchar(50)  
	declare @DepartureDate DateTime
	declare @BoardPoint varchar(50) 
	declare @OffPoint varchar(50)
	declare @AirlineGroupID int = 0

	declare @TempCustomerSessionIDNEW bigint = 0

	declare @TempBagID bigint = 0
	declare @TempBagIDNew bigint = 0
	declare @TempBagUBI varchar(50) 
	declare @TempBagTagType varchar(50) 

	if @IsTest = 1
			  begin
			  print 'test insert action called = ' + cast(@Cnt as varchar)
			  if @TempCustomerSessionID > 0	
			  begin
			    --insert Customer data
			 --   insert into @tbCustomer	 ([UCI], [Title], [GivenName], [Surname], [Gender])
				--select [UCI], [Title], [GivenName], [Surname], [Gender] from [ReportingDB_NRT_FEB2026].[dbo].[Customer] where ID  = @TempCustomerID
				--select @TempCustomerID = @@IDENTITY
				--end insert Customer data

				--insert AbdStation data	

				select 						
				    @PortCode = [PortCode],
					@Identifier = [Identifier],
					@AbdType = [AbdType],
					@Terminal = [Terminal],
					@Zone = [Zone],
					@Area = [Area],
					@SubArea = [SubArea]
                from [ReportingDB_NRT_FEB2026].[dbo].[AbdStation] where ID  = @TempAbdStationID
				
				print 'test @TempAbdStationID = ' + cast(@TempAbdStationID as varchar)
				print 'test @PortCode = ' + cast(@PortCode as varchar)
				print 'test @Identifier = ' + cast(@Identifier as varchar)
				print 'test @AbdType = ' + cast(@AbdType as varchar)
				print 'test @Terminal = ' + cast(@Terminal as varchar)
				print 'test @Zone = ' + cast(@Zone as varchar)
				print 'test @Area = ' + cast(@Area as varchar)
				print 'test @SubArea = ' + cast(@SubArea as varchar)

				--start insert AbdStation data if necessary
				select @TempAbdStationIDAirline = max(isnull(ID, 0))
				from [ReportingDB_NRT_FEB2026].[dbo].[AbdStation]
				where				   
				   upper([Identifier]) = upper(@Identifier) and 
				   upper([AbdType]) = upper(@AbdType) and 
				   upper([Terminal]) = upper(@Terminal)and 				  
				   upper([Area]) = upper(@Area)   
				   
                print 'test @TempAbdStationIDAirline = ' + cast(@TempAbdStationIDAirline as varchar)
				   if @TempAbdStationIDAirline > 0
				      set @TempAbdStationID =  @TempAbdStationIDAirline
				   else
				      set @TempAbdStationID = 0

				if not exists(
				    select * from @tbAbdStation 
					where 				    
				    PortCode = @PortCode and 
					Identifier = @Identifier and 
					AbdType = @AbdType and 
					Terminal = @Terminal and 
					[Zone] = @Zone and 
					Area = @Area and 
					SubArea = @SubArea) and not exists (select ID from [ReportingDB_NRT].[dbo].[AbdStation] where ID = @TempAbdStationIDAirline)
				begin
							insert into @tbAbdStation(		
							                            [ID],
														[PortCode],
														[Identifier],
														[AbdType],
														[Terminal],
														[Zone],
														[Area],
														[SubArea]
													 )
							select  @TempAbdStationID,
									@PortCode,
									@Identifier,
									@AbdType,
									@Terminal,
									@Zone,
									@Area,
									@SubArea
 
							print 'Not found records in @tbAbdStation'  
				end
				else
				begin
				            select @TempAbdStationID = @TempAbdStationIDAirline
							print 'Found records in @tbAbdStation'  
				end
				--end insert AbdStation data


				--start insert Flight data
				select 
				  @TempFlightIDCuss = ID,
				  @MarketingCarrier = MarketingCarrier,
				  @FlightNumber = FlightNumber,
				  @DepartureDate = DepartureDate,
				  @BoardPoint = BoardPoint,
				  @OffPoint =  OffPoint
				from [ReportingDB_NRT_FEB2026].[dbo].[Flight] where ID = @TempFlightID

				-----------start checking [BagDrop_SIN_ACTION].[dbo].[Flight]
				select @TempFlightIDAirline = isnull(ID, 0) from [ReportingDB_NRT].[dbo].[Flight]
				where 		MarketingCarrier = @MarketingCarrier and 
							FlightNumber = @FlightNumber and
							DepartureDate = @DepartureDate and 
							BoardPoint = @BoardPoint and 
							OffPoint = @OffPoint
                print 'test @TempFlightIDAirline ============= ' + cast(@TempFlightIDAirline as varchar)
				-----------end checking [BagDrop_SIN_ACTION].[dbo].[Flight]

				if not exists(select * from @tbFlight where 
							MarketingCarrier = @MarketingCarrier and 
							FlightNumber = @FlightNumber and
							DepartureDate = @DepartureDate and 
							BoardPoint = @BoardPoint and 
							OffPoint = @OffPoint
				) and not exists (select ID from [ReportingDB_NRT].[dbo].[Flight] where ID = @TempFlightID)

				begin
				  insert into @tbFlight
				  select * from [ReportingDB_NRT_FEB2026].[dbo].[Flight] where ID = @TempFlightID
				end
				--end insert Flight data


				--start insert CustomerSession data, we need to make sure this CustomerSession record is not existing in [ReportingDB_NRT].[dbo].CustomerSession
				if not exists (select ID from [ReportingDB_NRT].[dbo].CustomerSession where ID = @TempCustomerSessionID)
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
						,[SessionEndReasonID]
						,[SessionEndPageID]
						,[MachineTime]
						,[PaxTime]
						,[DcsTime]
						,[BhsTime]
						,[CsaTime]						  
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
						,@TempSessionEndReasonID 
						,@TempSessionEndPageID 
						,@TempMachineTime 
						,@TempPaxTime 
						,@TempDcsTime 
						,@TempBhsTime 
						,@TempCsaTime 

				 end	 	
			    --end insert CustomerSession data

				--start loop insert action because one CustomerSessionID could map to mutiple CustomerSessionIDs
				DECLARE @MyTableInner TABLE
				(
					SNo int IDENTITY(1,1), 
					BagWeightUpdateID BIGINT
				)    
				INSERT INTO @MyTableInner(BagWeightUpdateID)	    
				select b.ID 
				from [ReportingDB_NRT_FEB2026].[dbo].CustomerSession a INNER JOIN
		                         [ReportingDB_NRT_FEB2026].[dbo].BagWeightUpdate b ON a.ID = b.CustomerSessionID 
				where b.CustomerSessionID = @TempCustomerSessionID
				      and DATEPART(year, b.LocalTime) = DATEPART(year, @UpdateMonthFirstDay) and DATEPART(month, b.LocalTime) = DATEPART(month, @UpdateMonthFirstDay) 
																	 
				DECLARE @TempBagWeightUpdateID BIGINT
				DECLARE @TempBagWeightUpdateBagID BIGINT
				 
				DECLARE @CntSecond INT
				SELECT @CntSecond = MIN(Sno) FROM @MyTableInner
	
				WHILE (1=1)
				BEGIN
   
					SELECT @TempBagWeightUpdateID = BagWeightUpdateID FROM @MyTableInner
					WHERE SNo = @CntSecond
	    
					IF @@ROWCOUNT = 0
						BREAK

					select @TempBagWeightUpdateBagID = BagID 
					from [ReportingDB_NRT_FEB2026].[dbo].[BagWeightUpdate] where ID = @TempBagWeightUpdateID

					if not exists (select ID from [ReportingDB_NRT].[dbo].[Bag] where ID = @TempBagWeightUpdateBagID)
					insert into @tbBag(
						ID,
						UBI,
						BagTagType
					)
					select ID, isnull(UBI, '8888899999'), BagTagType from [ReportingDB_NRT_FEB2026].[dbo].[Bag] WHERE ID = @TempBagWeightUpdateBagID


					if not exists (select ID from @tbBagWeightUpdate where ID = @TempBagWeightUpdateID) and not exists (select ID from [ReportingDB_NRT].[dbo].BagWeightUpdate where ID = @TempBagWeightUpdateID)
					insert into @tbBagWeightUpdate
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
						ID,
						@TempBagWeightUpdateBagID,
						[Weight],
						UtcTime,
						CustomerSessionID,
						[TimeSlot5minID],
						[TimeSlot10minID],
						[TimeSlotHourlyID],
						[DayOfTheWeekID],
						[LocalTime],
						[AbdStationID]
					from [ReportingDB_NRT_FEB2026].[dbo].[BagWeightUpdate] where ID = @TempBagWeightUpdateID  
		
					 
		
					SELECT @CntSecond = @CntSecond + 1		
				END
				--end loop insert action because one CustomerSessionID could map to mutiple CustomerSessionIDs

				--start insert Bag data
				--insert into @tbBag(
				--	ID,
				--	BaggageGroupID,
				--	UBI,
				--	BagTagType
				--)
				--select ID, 6481392, UBI, BagTagType from [CUSSBagDropDB_SIN].[dbo].[Bag]
				--where ID in
				--(
				--  select BagID from [CUSSBagDropDB_SIN].[dbo].[BagWeightUpdate] where CustomerSessionID = @TempCustomerSessionID 
				--)
				--end insert bag data

			    --start insert BagWeightUpdate data
				--if not exists(select ID from @tbBagWeightUpdate where CustomerSessionID = @TempCustomerSessionID)
				--insert into @tbBagWeightUpdate
				--(
				--	[ID],
				--	[BagID],
				--	[Weight],
				--	[UtcTime],
				--	[CustomerSessionID],
				--	[LocalTime]
				--)
				--select 
				--	ID,
				--	BagID,
				--	[Weight],
				--	UtcTime,
				--	CustomerSessionID,
				--	LocalTime
				--from [CUSSBagDropDB_SIN].[dbo].[BagWeightUpdate] where CustomerSessionID = @TempCustomerSessionID  
				--end insert BagWeightUpdate data


			  end
			  
			  select @CntTotal = @CntTotal + 1
	end
	else
			  begin
			      print 'production insert action called = ' + cast(@Cnt as varchar)
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
						,[SessionEndReasonID]
						,[SessionEndPageID]
						,[MachineTime]
						,[PaxTime]
						,[DcsTime]
						,[BhsTime]
						,[CsaTime]							  
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
						  ,@TempLocalCompletionTime 
						  ,@TempSessionDuration
						,@TempSessionEndReasonID 
						,@TempSessionEndPageID 
						,@TempMachineTime 
						,@TempPaxTime 
						,@TempDcsTime 
						,@TempBhsTime 
						,@TempCsaTime 			 	

					select @CntTotal = @CntTotal + 1
					select @CntInternalTotal = @CntInternalTotal + 1  --this is internal row count once it reach @RowsPerInsertBatch we do real DB insert action

					--we take real action once the temp table @tbCustomerSession got @RowsPerInsertBatch records
					--or it reaches to the max number of rows we need insert

					print 'TOP @TempFlightID = ' + cast(@TempFlightID as varchar)
					print 'TOP @CntInternalTotal = ' + cast(@CntInternalTotal as varchar)
					print 'TOP @RowsPerInsertBatch = ' + cast(@RowsPerInsertBatch as varchar)
					print 'TOP @CntTotal = ' + cast(@CntTotal as varchar)
					print 'TOP @NoRecordsNeedInsert = ' + cast(@NoRecordsNeedInsert as varchar)

					if @CntInternalTotal = @RowsPerInsertBatch or @CntTotal = @NoRecordsNeedInsert 
					begin

						--insert CUSS DB has no Customer data commented out the following lines
						--insert into [ReportingDB_NRT].dbo.Customer	 ([UCI], [Title], [GivenName], [Surname], [Gender])
						--select isnull([UCI], newid()), [Title], [GivenName], [Surname], [Gender] from [CUSSBagDropDB_SIN].[dbo].[Customer] where ID  = @TempCustomerID
						--select @TempCustomerID = @@IDENTITY
						--end insert Customer data

						select 						
							@PortCode = [PortCode],
							@Identifier = [Identifier],
							@AbdType = [AbdType],
							@Terminal = [Terminal],
							@Zone = [Zone],
							@Area = [Area],
							@SubArea = [SubArea]
						from [ReportingDB_NRT_FEB2026].[dbo].[AbdStation] where ID  = @TempAbdStationID
				
						print 'production @TempAbdStationID = ' + cast(@TempAbdStationID as varchar)
						print 'production @PortCode = ' + cast(@PortCode as varchar)
						print 'production @Identifier = ' + cast(@Identifier as varchar)
						print 'production @AbdType = ' + cast(@AbdType as varchar)
						print 'production @Terminal = ' + cast(@Terminal as varchar)
						print 'production @Zone = ' + cast(@Zone as varchar)
						print 'production @Area = ' + cast(@Area as varchar)
						print 'production @SubArea = ' + cast(@SubArea as varchar)

						--start insert AbdStation data if necessary
						select @TempAbdStationIDAirline = max(isnull(ID, 0))
						from [ReportingDB_NRT_FEB2026].[dbo].[AbdStation]			   
						where ID = 	@TempAbdStationID	
						
						if @TempAbdStationIDAirline = 0 
						    select @TempAbdStationInsertCount  = @TempAbdStationInsertCount + 1
				   
						--print 'production @TempAbdStationIDAirline = ' + cast(@TempAbdStationIDAirline as varchar)
						--if @TempAbdStationIDAirline > 0
						--	set @TempAbdStationID =  @TempAbdStationIDAirline
						--else
						--	begin
						--	set @TempAbdStationID = 0
						--	print 'PRODUCTION AbdStation ID COULD NOT BE FOUND' 
						--	end

							-- please note here we do NOT insert new AbdStation records into table AbdStation in ReportingDB_NRT database
							-- if we could not find its mapped AbdStation ID then we put it as 0			
						--end insert AbdStation data

						--start insert Flight data
						select 
						  @TempFlightIDCuss = ID,
						  @MarketingCarrier = MarketingCarrier,
						  @FlightNumber = FlightNumber,
						  @DepartureDate = DepartureDate,
						  @BoardPoint = BoardPoint,
						  @OffPoint =  OffPoint,
						  @AirlineGroupID = AirlineGroupID
						from [ReportingDB_NRT_FEB2026].[dbo].[Flight] where ID = @TempFlightID

						-----------start checking [ReportingDB_NRT].[dbo].[Flight]
						select @TempFlightIDAirline = isnull(ID, 0) from [ReportingDB_NRT].[dbo].[Flight]
						where 		ID = @TempFlightID
						print 'production @TempFlightIDAirline ============= ' + cast(@TempFlightIDAirline as varchar)
						-----------end checking [BagDrop_SIN_ACTION].[dbo].[Flight]

						if @TempFlightIDAirline = 0 and not exists(select ID from [ReportingDB_NRT].[dbo].[Flight] where ID = @TempFlightID)
						begin
						   set @TempFlightInsertCount = @TempFlightInsertCount + 1
						  --insert into [ReportingDB_NRT].[dbo].[Flight](MarketingCarrier, FlightNumber, DepartureDate, BoardPoint, OffPoint)
						  --select MarketingCarrier, FlightNumber, DepartureDate, BoardPoint, OffPoint from [ReportingDB_NRT_FEB2026].[dbo].[Flight] where ID = @TempFlightID
						  --select @TempFlightID = @@IDENTITY
						end
						else
						  select @TempFlightID = @TempFlightIDAirline
						--end insert Flight data
						---------------------------------------------------------------------------------------------------------------------------------
						--start insert into BagDrop_SIN table CustomerSession table  
						if not exists (select ID from [ReportingDB_NRT].[dbo].CustomerSession where ID = @TempCustomerSessionID)
						begin
							     insert into [ReportingDB_NRT].dbo.CustomerSession(
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
								,[SessionEndReasonID]
								,[SessionEndPageID]
								,[MachineTime]
								,[PaxTime]
								,[DcsTime]
								,[BhsTime]
								,[CsaTime]	
								)
								select 
								@TempCustomerSessionID,
								@TempCustomerID,
								@TempAbdStationID,
								@TempCustomerLookupType,
								@TempPNR,
								@TempUtcCreationTime,
								@TempFlightID,

								@TempTimeSlot5minID,
								@TempTimeSlot10minID,
								@TempTimeSlotHourlyID,
								@TempDayOfTheWeekID,

								@TempLocalTime,
								@TempUtcCompletionTime,
								@TempSessionDuration,
								@TempSessionEndReasonID,
								@TempSessionEndPageID, 
								@TempMachineTime, 
								@TempPaxTime, 
								@TempDcsTime, 
								@TempBhsTime, 
								@TempCsaTime 								
								from @tbCustomerSession

							    --select @TempCustomerSessionIDNEW = @@IDENTITY							    
								select @TempCustomerSessionIDNEW = @TempCustomerSessionID  -- we just use this CustomerSessionID from @TempCustomerSessionID which is from DB [ReportingDB_NRT_FEB2026].[dbo].[CustomerSession]
								set @TempCustomerSessionInsertCount = @TempCustomerSessionInsertCount + 1
						end
						print 'production @TempCustomerSessionIDNEW ============= ' + cast(@TempCustomerSessionIDNEW as varchar)
                        --end insert into BagDrop_SIN table CustomerSession table  

						--start insert BagDrop_SIN table Bag data			 
						--insert into [BagDrop_SIN_ACTION].[dbo].[Bag](
						--	ID,
						--	BaggageGroupID,
						--	UBI,
						--	BagTagType
						--)
						--select ID, 6481392, '8888899999', BagTagType from [CUSSBagDropDB_SIN].[dbo].[Bag]
						--where ID in
						--(
						--  select BagID from [CUSSBagDropDB_SIN].[dbo].[BagWeightUpdate] where CustomerSessionID = @TempCustomerSessionID 
						--)
						--end insert BagDrop_SIN table Bag data

						--start insert BagWeightUpdate data
						--if @TempCustomerSessionID > 0
						--insert into BagDrop_SIN_ACTION.dbo.BagWeightUpdate
					 --   (							 
						--	[BagID],
						--	[Weight],
						--	[UtcTime],
						--	[CustomerSessionID],
						--	[LocalTime]
						--)
						--select 							 
						--	BagID,
						--	[Weight],
						--	UtcTime,
						--	@TempCustomerSessionIDNEW,
						--	LocalTime
						--from [CUSSBagDropDB_SIN].[dbo].[BagWeightUpdate] where CustomerSessionID = @TempCustomerSessionID  
						--end insert BagWeightUpdate data 

						--start loop insert action because one CustomerSessionID could map to mutiple CustomerSessionIDs
						print 'production @TempCustomerSessionID before insert BagWeightUpdate ============= ' + cast(@TempCustomerSessionID as varchar)

	
						DECLARE @MyTableInner2 TABLE
						(
						SNo int IDENTITY(1,1), 
						BagWeightUpdateID BIGINT
						) 


						INSERT INTO @MyTableInner2(BagWeightUpdateID)	    
						select b.ID from [ReportingDB_NRT_FEB2026].[dbo].CustomerSession a INNER JOIN
		                               [ReportingDB_NRT_FEB2026].[dbo].BagWeightUpdate b ON a.ID = b.CustomerSessionID where b.CustomerSessionID = @TempCustomerSessionID 
									   and DATEPART(year, b.LocalTime) = DATEPART(year, @UpdateMonthFirstDay) and DATEPART(month, b.LocalTime) = DATEPART(month, @UpdateMonthFirstDay) 

																	 
						DECLARE @TempBagWeightUpdateID2 BIGINT
						DECLARE @TempBagWeightUpdateBagID2 BIGINT
				 

						DECLARE @CntSecond2 INT
						SELECT @CntSecond2 = MIN(Sno) FROM @MyTableInner2
	
	                    --select * from @MyTableInner2

						WHILE (1=1)
						BEGIN
   
							SELECT @TempBagWeightUpdateID2 = BagWeightUpdateID FROM @MyTableInner2
							WHERE SNo = @CntSecond2
	    
							IF @@ROWCOUNT = 0
								BREAK

							select @TempBagWeightUpdateBagID2 = BagID 
							from [ReportingDB_NRT_FEB2026].[dbo].[BagWeightUpdate] where ID = @TempBagWeightUpdateID2

							--get Bag info from [CUSSBagDropDB_SIN].[dbo].[Bag] insert into [BagDrop_SIN_ACTION].[dbo].[Bag]
							--then we get the newly created Bag IDs for [BagDrop_SIN_ACTION].[dbo].[BagWeightUpdate] insert action
							if not exists (select ID from [CUSSReportingDB_NRT].[dbo].[Bag] where ID = @TempBagWeightUpdateBagID2)
                            begin
							    select @TempBagInsertCount = @TempBagInsertCount + 1

								--insert into [CUSSReportingDB_NRT].[dbo].[Bag](
								--	ID,
								--	UBI,
								--	BagTagType
								--)
								--select ID, isnull(UBI, '8888899999'), BagTagType 
								--from [CUSSReportingDB_NRT_FEB2026].[dbo].[Bag] WHERE ID = @TempBagWeightUpdateBagID2
								--select @TempBagWeightUpdateBagID2 = @@IDENTITY
							end

							print 'production @TempBagWeightUpdateBagID2 = ' + cast(@TempBagWeightUpdateBagID2 as varchar)
							--get data from [CUSSBagDropDB_SIN].[dbo].[BagWeightUpdate] and insert into [BagDrop_SIN_ACTION].[dbo].[BagWeightUpdate]
							--with new [BagID] and [CustomerSessionID]
							if @TempBagWeightUpdateBagID2 > 0 and not exists (select ID from [ReportingDB_NRT].[dbo].BagWeightUpdate where ID = @TempBagWeightUpdateID2)
							begin
							    print 'production insert BagWeightUpdate action =>' + cast(@TempBagWeightUpdateBagID2 as varchar)

								insert into [ReportingDB_NRT].[dbo].[BagWeightUpdate]
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
									@TempBagWeightUpdateID2,
									@TempBagWeightUpdateBagID2,
									[Weight],
									UtcTime,
									[CustomerSessionID],
									TimeSlot5minID,
									TimeSlot10minID,
									TimeSlotHourlyID,
									DayOfTheWeekID,
									LocalTime,
									AbdStationID
								from [ReportingDB_NRT_FEB2026].[dbo].[BagWeightUpdate] where ID = @TempBagWeightUpdateID2 

								--and datepart(year, LocalTime) = datepart(year, @UpdateMonthFirstDay) 
								--and datepart(month, LocalTime) = datepart(month, @UpdateMonthFirstDay) 
								--and datepart(day, LocalTime) = datepart(day, @UpdateMonthFirstDay) 
								
								select @TempBagWeightUpdateInsertCount = @TempBagWeightUpdateInsertCount + 1
							end
					        
							delete from @MyTableInner2 where BagWeightUpdateID = @TempBagWeightUpdateID2

		                    select @TempBagWeightUpdateBagID2 = 0
							SELECT @CntSecond2 = @CntSecond2 + 1		
						END
						--end loop insert action because one CustomerSessionID could map to mutiple CustomerSessionIDs

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
    select * from @tbCustomer
	select * from @tbAbdStation
	select * from @tbFlight
	select * from @tbCustomerSession --order by ID desc	
	select * from @tbBagWeightUpdate --order by ID desc	
	select * from @tbBag
	print 'Total ' + cast(@CntTotal as varchar) + ' record(s) has been inserted'
end

else

begin
    select * from @tbCustomerSession
    print 'Total ' + cast(@CntTotal as varchar) + ' record(s) has been inserted into table CussReportingDB_CDG.dbo.CustomerSession'	  
	print 'AbdStation insert count = '+ cast(@TempAbdStationInsertCount as varchar) + ' if it is 0 then NO need insert to [CUSSReportingDB_NRT].[dbo].[AbdStation] table'
	print 'Flight insert count = '+ cast(@TempFlightInsertCount as varchar) + ' if it is 0 then NO need insert to [CUSSReportingDB_NRT].[dbo].[Flight] table'
	print 'CustomerSession insert count = '+ cast(@TempCustomerSessionInsertCount as varchar) + ' if it is 0 then NO need insert to [CUSSReportingDB_NRT].[dbo].[CustomerSession] table'

	print 'Bag insert count = '+ cast(@TempBagInsertCount as varchar) + ' if it is 0 then NO need insert to [CUSSReportingDB_NRT].[dbo].[Bag] table'
	print 'BagWeightUpdate insert count = '+ cast(@TempBagWeightUpdateInsertCount as varchar) + ' if it is 0 then NO need insert to [CUSSReportingDB_NRT].[dbo].[BagWeightUpdate] table'
end