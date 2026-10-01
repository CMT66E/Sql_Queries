USE ReportingDB
GO

declare @ExpectedPreviousVersion nvarchar(25) = '12.1i2'
declare @PatchVersion nvarchar(25) = '12.1i3'

--------------------------- no need change below ---------------------------
-- Pre-patch version check
Declare @CurrentVersion nvarchar(25)
Exec dbo.GetCurrentVersion @CurrentVersion Output
 
Print 'Current DB version is: ' + @CurrentVersion
Print ''
 
If (@CurrentVersion <> @ExpectedPreviousVersion AND @CurrentVersion <> @PatchVersion)
Begin
    Print 'Patching aborted because current database version is not ' + @ExpectedPreviousVersion + ' or ' + @PatchVersion + '.'
    Raiserror ('Patch aborted.',20, 10) With Log
    Return
End
 
IF @CurrentVersion = @PatchVersion
BEGIN
    Print 'Patching aborted because current database version is  ' + @CurrentVersion + ' same as  patch version : ' + @PatchVersion + '.'
    Raiserror ('Patch aborted.',20, 10) With Log
    Return
END
GO 
--------------------------- no need change above ---------------------------

Print 'BEGIN PATCHING'

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO 


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransactionTimePerHourPerServer]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TransactionTimePerHourPerServer]
GO 
CREATE PROCEDURE [dbo].[TransactionTimePerHourPerServer]
(
	@FromDateTime DateTime,
	@ToDateTime DateTime,
	@FlightNumber nvarchar(100),
    @BoardPass nvarchar(25),
    @BagTagType nvarchar(25),
    @Airline nvarchar(25),
    @Terminal nvarchar(10),
	@Area nvarchar(10),
	@SubArea nvarchar(10),
	@ABDStationIDs varchar(400),
	@ABDStationNames varchar(4000),
	@BdsServertype INT
	)
AS
BEGIN
            --here we check if there is any records in table: BdsAbdMapping
			--if there is no value we won't check it at all no need: AND ABDStation.ID In ( Select AbdStationID from BdsAbdMapping)
			declare @rwCount int
			Select @rwCount = count(AbdStationID) from BdsAbdMapping

			IF (@Airline = '0' OR @Airline ='%' )
            SET @Airline = '%'
			SELECT     Bag.ID, Bag.BagTagType, tempt.ID AS CustomerSessionID, tempt.AbdStationID, tempt.CustomerLookupType, tempt.FlightID, tempt.CustomerID, tempt.PNR, 
								  bagt.TimeSlot5minID, bagt.TimeSlot10minID, bagt.TimeSlotHourlyID, bagt.DayOfTheWeekID, bagt.LocalTime, tempt.SessionDuration, tempt.BagCount, 
								  tempt.TransactionTime, tempt.UtcCreationTime, tempt.UtcCompletionTime
			INTO  #tempTab
			FROM         BagWeightUpdate AS bagt INNER JOIN
									  (SELECT     CustomerSession.ID, CustomerSession.CustomerID, CustomerSession.AbdStationID, CustomerSession.CustomerLookupType, CustomerSession.PNR, 
								  CustomerSession.UtcCreationTime, CustomerSession.FlightID, CustomerSession.TimeSlot5minID, CustomerSession.TimeSlot10minID, 
								  CustomerSession.TimeSlotHourlyID, CustomerSession.DayOfTheWeekID, CustomerSession.LocalTime, CustomerSession.UtcCompletionTime, 
								  CustomerSession.SessionDuration, COUNT(BagWeightUpdate.BagID) AS BagCount, CustomerSession.SessionDuration / COUNT(BagWeightUpdate.BagID) 
								  AS TransactionTime
			FROM         CustomerSession INNER JOIN
								  BagWeightUpdate ON CustomerSession.ID = BagWeightUpdate.CustomerSessionID AND BagWeightUpdate.UtcTime BETWEEN CustomerSession.UtcCreationTime AND CustomerSession.UtcCompletionTime
			WHERE CustomerSession.LocalTime BETWEEN @FromDateTime AND @ToDateTime
			GROUP BY CustomerSession.ID, CustomerSession.CustomerID, CustomerSession.AbdStationID, CustomerSession.CustomerLookupType, CustomerSession.PNR, 
								  CustomerSession.UtcCreationTime, CustomerSession.FlightID, CustomerSession.TimeSlot5minID, CustomerSession.TimeSlot10minID, 
								  CustomerSession.TimeSlotHourlyID, CustomerSession.DayOfTheWeekID, CustomerSession.LocalTime, CustomerSession.UtcCompletionTime, 
								  CustomerSession.SessionDuration
			) AS tempt ON bagt.CustomerSessionID = tempt.ID INNER JOIN
			 Bag ON bagt.BagID = Bag.ID
 
 
		 If @BdsServertype = 0
		 BEGIN
		 
			   IF @Airline = '%'
						SELECT     TimeSlotHourly.TimeSlotName, AVG(TransactionTime.TransactionTime) AS AvgTransactionTime, MIN(TransactionTime.TransactionTime) AS MinTransactionTime, 
											  MAX(TransactionTime.TransactionTime) AS MaxTransactionTime, @ABDStationNames AS ABDStations
						FROM         #tempTab AS TransactionTime INNER JOIN
											  TimeSlotHourly ON TransactionTime.TimeSlotHourlyID = TimeSlotHourly.ID INNER JOIN
											  Flight ON TransactionTime.FlightID = Flight.ID INNER JOIN
											  ABDStation ON ABDStation.ID = TransactionTime.ABDStationID
						WHERE     (CAST(Flight.FlightNumber AS nvarchar(100)) LIKE @FlightNumber) 
							AND (TransactionTime.CustomerLookupType LIKE @BoardPass) 
							AND (TransactionTime.BagTagType LIKE @BagTagType) 
							AND (Flight.MarketingCarrier LIKE @Airline)
							AND (AbdStation.Terminal LIKE @Terminal )
							AND (ISNULL(AbdStation.Area,'') LIKE @Area )
							AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
							AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
							AND ABDStation.ID In (case @rwCount when 0 then ABDStation.ID else (Select AbdStationID from BdsAbdMapping) end)
						GROUP BY TimeSlotHourly.ID,TimeSlotHourly.TimeSlotName
						ORDER BY TimeSlotHourly.ID, TimeSlotHourly.TimeSlotName
				ELSE
						SELECT     TimeSlotHourly.TimeSlotName, AVG(TransactionTime.TransactionTime) AS AvgTransactionTime, MIN(TransactionTime.TransactionTime) AS MinTransactionTime, 
											  MAX(TransactionTime.TransactionTime) AS MaxTransactionTime, @ABDStationNames AS ABDStations
						FROM         #tempTab AS TransactionTime INNER JOIN
											  TimeSlotHourly ON TransactionTime.TimeSlotHourlyID = TimeSlotHourly.ID INNER JOIN
											  Flight ON TransactionTime.FlightID = Flight.ID INNER JOIN
											  ABDStation ON ABDStation.ID = TransactionTime.ABDStationID
						WHERE     (CAST(Flight.FlightNumber AS nvarchar(100)) LIKE @FlightNumber) 
							AND (TransactionTime.CustomerLookupType LIKE @BoardPass) 
							AND (TransactionTime.BagTagType LIKE @BagTagType) 
							AND (Flight.MarketingCarrier IN (SELECT Items 
							FROM  dbo.Split(@Airline, ',')))
							AND (AbdStation.Terminal LIKE @Terminal )
							AND (ISNULL(AbdStation.Area,'') LIKE @Area )
							AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
							AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
							AND ABDStation.ID In (case @rwCount when 0 then ABDStation.ID else (Select AbdStationID from BdsAbdMapping) end)
						GROUP BY TimeSlotHourly.ID,TimeSlotHourly.TimeSlotName
						ORDER BY TimeSlotHourly.ID, TimeSlotHourly.TimeSlotName
		END
		ELSE
		BEGIN
		        IF @Airline = '%'
					   SELECT     TimeSlotHourly.TimeSlotName, AVG(TransactionTime.TransactionTime) AS AvgTransactionTime, MIN(TransactionTime.TransactionTime) AS MinTransactionTime, 
											  MAX(TransactionTime.TransactionTime) AS MaxTransactionTime, @ABDStationNames AS ABDStations
						FROM         #tempTab AS TransactionTime INNER JOIN
											  TimeSlotHourly ON TransactionTime.TimeSlotHourlyID = TimeSlotHourly.ID INNER JOIN
											  Flight ON TransactionTime.FlightID = Flight.ID INNER JOIN
											  ABDStation ON ABDStation.ID = TransactionTime.ABDStationID
						WHERE     (CAST(Flight.FlightNumber AS nvarchar(100)) LIKE @FlightNumber) 
							AND (TransactionTime.CustomerLookupType LIKE @BoardPass) 
							AND (TransactionTime.BagTagType LIKE @BagTagType) 
							AND (Flight.MarketingCarrier LIKE @Airline)
							AND (AbdStation.Terminal LIKE @Terminal )
							AND (ISNULL(AbdStation.Area,'') LIKE @Area )
							AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
							AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
							AND ABDStation.ID In (case @rwCount when 0 then ABDStation.ID else (Select AbdStationID from BdsAbdMapping where BdsServerID =@BdsServertype) end)
						GROUP BY TimeSlotHourly.ID,TimeSlotHourly.TimeSlotName
						ORDER BY TimeSlotHourly.ID, TimeSlotHourly.TimeSlotName
				ELSE
				   SELECT     TimeSlotHourly.TimeSlotName, AVG(TransactionTime.TransactionTime) AS AvgTransactionTime, MIN(TransactionTime.TransactionTime) AS MinTransactionTime, 
											  MAX(TransactionTime.TransactionTime) AS MaxTransactionTime, @ABDStationNames AS ABDStations
						FROM         #tempTab AS TransactionTime INNER JOIN
											  TimeSlotHourly ON TransactionTime.TimeSlotHourlyID = TimeSlotHourly.ID INNER JOIN
											  Flight ON TransactionTime.FlightID = Flight.ID INNER JOIN
											  ABDStation ON ABDStation.ID = TransactionTime.ABDStationID
						WHERE     (CAST(Flight.FlightNumber AS nvarchar(100)) LIKE @FlightNumber) 
							AND (TransactionTime.CustomerLookupType LIKE @BoardPass) 
							AND (TransactionTime.BagTagType LIKE @BagTagType) 
							AND (Flight.MarketingCarrier IN (SELECT Items 
							FROM  dbo.Split(@Airline, ',')))
							AND (AbdStation.Terminal LIKE @Terminal )
							AND (ISNULL(AbdStation.Area,'') LIKE @Area )
							AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
							AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
							AND ABDStation.ID In (case @rwCount when 0 then ABDStation.ID else (Select AbdStationID from BdsAbdMapping where BdsServerID =@BdsServertype) end)
						GROUP BY TimeSlotHourly.ID,TimeSlotHourly.TimeSlotName
						ORDER BY TimeSlotHourly.ID, TimeSlotHourly.TimeSlotName
		END
END

GO
Print 'Drop and Create SP TransactionTimePerHourPerServer'


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DcsTransactionTimePerServer]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[DcsTransactionTimePerServer]
GO
CREATE PROCEDURE [dbo].[DcsTransactionTimePerServer]
	@FromDateTime datetime,
	@ToDateTime datetime,
	@Terminal nvarchar(10),
	@Area nvarchar(10),
	@SubArea nvarchar(10),
	@ABDStationIDs varchar(400),
	@ABDStationNames varchar(4000),
	@BdsServertype INT
AS 

declare @rwCount int
Select @rwCount = count(AbdStationID) from BdsAbdMapping

If @BdsServertype = 0
BEGIN
    if @rwCount > 0
	begin
		SELECT MessageType, AVG(ISNULL(CONVERT(float, MessageTime) / 1000.0,0.0)) AS AvgMessageTime, AVG(ISNULL(CONVERT(float,MessageSize),0.0)) AS AvgMessageSize, 
			COUNT(CMOperationHistory.ID) AS NumberOfMessages, @ABDStationNames AS AbdStationNames
		FROM CMOperationHistory
		JOIN AbdStation
		ON CMOperationHistory.AbdStationID = AbdStation.ID
		WHERE MessageSent BETWEEN @FromDateTime AND @ToDateTime
			AND (AbdStation.Terminal LIKE @Terminal)
			AND (ISNULL(AbdStation.Area,'') LIKE @Area )
			AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
			AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
			AND ABDStation.ID In (Select AbdStationID from BdsAbdMapping)
		GROUP BY MessageType
	end
	else
	begin
		SELECT MessageType, AVG(ISNULL(CONVERT(float, MessageTime) / 1000.0,0.0)) AS AvgMessageTime, AVG(ISNULL(CONVERT(float,MessageSize),0.0)) AS AvgMessageSize, 
			COUNT(CMOperationHistory.ID) AS NumberOfMessages, @ABDStationNames AS AbdStationNames
		FROM CMOperationHistory
		JOIN AbdStation
		ON CMOperationHistory.AbdStationID = AbdStation.ID
		WHERE MessageSent BETWEEN @FromDateTime AND @ToDateTime
			AND (AbdStation.Terminal LIKE @Terminal)
			AND (ISNULL(AbdStation.Area,'') LIKE @Area )
			AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
			AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)			 
		GROUP BY MessageType
	end
END
ELSE
BEGIN
    if @rwCount > 0
	begin
		SELECT MessageType, AVG(ISNULL(CONVERT(float, MessageTime) / 1000.0,0.0)) AS AvgMessageTime, AVG(ISNULL(CONVERT(float,MessageSize),0.0)) AS AvgMessageSize, 
			COUNT(CMOperationHistory.ID) AS NumberOfMessages, @ABDStationNames AS AbdStationNames
		FROM CMOperationHistory
		JOIN AbdStation
		ON CMOperationHistory.AbdStationID = AbdStation.ID
		WHERE MessageSent BETWEEN @FromDateTime AND @ToDateTime
			AND (AbdStation.Terminal LIKE @Terminal)
			AND (ISNULL(AbdStation.Area,'') LIKE @Area )
			AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
			AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
			AND ABDStation.ID In (Select AbdStationID from BdsAbdMapping where BdsServerID =@BdsServertype)
		GROUP BY MessageType
	end
	else
	begin
		SELECT MessageType, AVG(ISNULL(CONVERT(float, MessageTime) / 1000.0,0.0)) AS AvgMessageTime, AVG(ISNULL(CONVERT(float,MessageSize),0.0)) AS AvgMessageSize, 
			COUNT(CMOperationHistory.ID) AS NumberOfMessages, @ABDStationNames AS AbdStationNames
		FROM CMOperationHistory
		JOIN AbdStation
		ON CMOperationHistory.AbdStationID = AbdStation.ID
		WHERE MessageSent BETWEEN @FromDateTime AND @ToDateTime
			AND (AbdStation.Terminal LIKE @Terminal)
			AND (ISNULL(AbdStation.Area,'') LIKE @Area )
			AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
			AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)			 
		GROUP BY MessageType
	end
END
GO
Print 'Drop and Create SP DcsTransactionTimePerServer' 
 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TotalPassengersPerFlight]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TotalPassengersPerFlight]
GO
CREATE PROCEDURE [dbo].[TotalPassengersPerFlight]
(
	@FromDateTime DateTime,
	@ToDateTime DateTime
)
WITH RECOMPILE
AS
BEGIN
			declare @tblPassengersPerFlight table 
			(
			Id int identity, 
			[Year]  varchar(50),
			[Month]  varchar(50),
			[Day]  varchar(50),
			PortCode nvarchar(10),
			Identifier nvarchar(10),
			Terminal nvarchar(10), 
			Area nvarchar(10), 
			SubArea nvarchar(10), 
			AbdStationName varchar(50),
			DepartureDate datetime,
			AirlineCode nvarchar(10), 
			FlightNumber varchar(50),
			CustomerSessionID BigInt
			)

			insert into @tblPassengersPerFlight
			select distinct
				DATEPART(YEAR, BagWeightUpdate.LocalTime) AS Year, 
				DATEPART(MONTH, BagWeightUpdate.LocalTime) AS Month, 
				DATEPART(DAY, BagWeightUpdate.LocalTime) AS Day, 
				AbdStation.PortCode, 
				AbdStation.Identifier, 
				AbdStation.Terminal,
				AbdStation.Area,
				AbdStation.SubArea,	
				dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea) AS AbdStationName, 
				Flight.DepartureDate,	
				isnull(Flight.MarketingCarrier, 'xx') as AirlineCode,
				isnull(Flight.FlightNumber, 'xxx') as FlightNumber,	 
				CustomerSession.CustomerID
				--count(*) as TotalPax 								   
			FROM BagWeightUpdate INNER JOIN
				AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID INNER JOIN
				CustomerSession ON BagWeightUpdate.CustomerSessionID = CustomerSession.ID INNER JOIN
				Flight ON CustomerSession.FlightID = Flight.ID INNER JOIN 
				Bag ON BagWeightUpdate.BagID = Bag.ID
			WHERE (BagWeightUpdate.LocalTime BETWEEN @FromDateTime AND @ToDateTime)			 
			order by dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea) desc
 
			SELECT  
			[Year], 
			[Month], 
			[Day], 
			PortCode, 
			Identifier, 
			Terminal,
			Area,
			SubArea,	
			AbdStationName, 
			DepartureDate,	
			AirlineCode,
			FlightNumber,	 
			count(CustomerSessionID) as TotalPax 	
			FROM @tblPassengersPerFlight
			GROUP BY 
 				[Year], 
				[Month], 
				[Day], 
				PortCode, 
				Identifier, 
				Terminal,
				Area,
				SubArea,	
				AbdStationName, 
				DepartureDate,	
				AirlineCode,
				FlightNumber
			order by AbdStationName, count(CustomerSessionID) desc
 
END
GO
Print 'Drop and Create SP TotalPassengersPerFlight' 


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UsagePerABDPerCustomerSession]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[UsagePerABDPerCustomerSession]
GO
CREATE PROCEDURE [dbo].[UsagePerABDPerCustomerSession]
(
	@FromDateTime DateTime,
	@ToDateTime DateTime
)
WITH RECOMPILE
AS

BEGIN
    SELECT DISTINCT   
	DATEPART(YEAR, BagWeightUpdate.LocalTime) AS Year, 
	DATEPART(MONTH, BagWeightUpdate.LocalTime) AS Month, 
	DATEPART(DAY, BagWeightUpdate.LocalTime) AS Day, 
	AbdStation.PortCode, 
	AbdStation.Identifier, 
	AbdStation.Terminal,
	AbdStation.Area,
	AbdStation.SubArea,	
	dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea) AS AbdStationName, 
	CustomerSession.ID as CustomersessionID,
	CustomerSession.PNR,
	isnull(Flight.MarketingCarrier, 'xx') as AirlineCode,
	isnull(Flight.FlightNumber, 'xxx') as FlightNumber,
	CustomerSession.LocalTime as Startdate,
	DATEADD(SECOND, CustomerSession.SessionDuration, CustomerSession.LocalTime) as EndDate,  
	CustomerSession.SessionDuration 						   
	FROM         BagWeightUpdate INNER JOIN
							AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID INNER JOIN
							CustomerSession ON BagWeightUpdate.CustomerSessionID = CustomerSession.ID INNER JOIN
							Flight ON CustomerSession.FlightID = Flight.ID INNER JOIN 
							Bag ON BagWeightUpdate.BagID = Bag.ID
	WHERE     (BagWeightUpdate.LocalTime BETWEEN @FromDateTime AND @ToDateTime)
	ORDER BY dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea), isnull(Flight.MarketingCarrier, 'xx'), isnull(Flight.FlightNumber, 'xxx') desc
END
GO
Print 'Drop and Create SP UsagePerABDPerCustomerSession' 


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TotalBagsPerFlight]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TotalBagsPerFlight]
GO
CREATE PROCEDURE [dbo].[TotalBagsPerFlight]
(
	@FromDateTime DateTime,
	@ToDateTime DateTime
)
WITH RECOMPILE
AS

BEGIN
            --define table variable for holding temp data
			declare @tblRecordsHolder table 
			(
			[Year] int, 
			[Month] int,
			[Day] int,
			Airport varchar(50),
			ScheduleDate DateTIme,
			Airline varchar(10),
			FlightNumber varchar(10),
			TotalBags int
			) 

			insert into @tblRecordsHolder
			SELECT     
				DATEPART(YEAR, BagWeightUpdate.LocalTime) AS Year, 
				DATEPART(MONTH, BagWeightUpdate.LocalTime) AS Month, 
				DATEPART(DAY, BagWeightUpdate.LocalTime) AS Day, 
				AbdStation.PortCode as Airport, 
				Flight.DepartureDate as ScheduleDate,	
				isnull(Flight.MarketingCarrier, 'xx') as Airline,	
				isnull(Flight.FlightNumber, 'xxx') as FlightNumber,   	 
				COUNT(BagWeightUpdate.LocalTime) AS Bags						   
			FROM         BagWeightUpdate INNER JOIN
									AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID INNER JOIN
									CustomerSession ON BagWeightUpdate.CustomerSessionID = CustomerSession.ID INNER JOIN
									Flight ON CustomerSession.FlightID = Flight.ID INNER JOIN 
									Bag ON BagWeightUpdate.BagID = Bag.ID
			WHERE     (BagWeightUpdate.LocalTime BETWEEN @FromDateTime AND @ToDateTime)
			GROUP BY DATEPART(YEAR, BagWeightUpdate.LocalTime), DATEPART(MONTH, BagWeightUpdate.LocalTime), DATEPART(DAY, BagWeightUpdate.LocalTime),
				AbdStation.PortCode, 	
				AbdStation.Identifier, 
				AbdStation.Terminal,
				AbdStation.Area,
				AbdStation.SubArea,
				isnull(Flight.MarketingCarrier, 'xx'),
				isnull(Flight.FlightNumber, 'xxx'), 
				Flight.DepartureDate
			ORDER BY DATEPART(YEAR, BagWeightUpdate.LocalTime), DATEPART(MONTH, BagWeightUpdate.LocalTime), DATEPART(DAY, BagWeightUpdate.LocalTime), 
				isnull(Flight.MarketingCarrier, 'xx') + isnull(Flight.FlightNumber, 'xxx'), Flight.DepartureDate 

			--finally fetch the data we need 
			select
				[Year], 
				[Month],
				[Day],
				Airport,
				ScheduleDate,
				Airline,
				FlightNumber,
				sum(TotalBags) as TotalBags 
			from @tblRecordsHolder
			group by [Year], 
					 [Month],
					 [Day],
					 Airport,
					 ScheduleDate,
					 Airline,
					 FlightNumber
			order by ScheduleDate desc, sum(TotalBags) desc
END
GO
Print 'Drop and Create SP TotalBagsPerFlight' 


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TotalExcessAmountPerFlight]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TotalExcessAmountPerFlight]
GO
CREATE PROCEDURE [dbo].[TotalExcessAmountPerFlight]
(
	@FromDateTime DateTime,
	@ToDateTime DateTime,
	@FlightNumber Varchar(50),
	@Terminal nvarchar(10) null = '%',
	@Area nvarchar(10) null = '%',
	@SubArea nvarchar(10) null = '%',
	@ABDStationIDs varchar(400) null = '0',
	@ABDStationNames varchar(4000) null = '%'
	)
	WITH RECOMPILE
AS
BEGIN                  
			--1. get all CustomerSession IDs which meets the timeframe in table: ExcessDetailsLog
			declare @tblCustomerSessionID table (Id int) 
			insert into @tblCustomerSessionID
			SELECT distinct
			isnull(CustomerSession.ID, 0)
			FROM BagWeightUpdate
			JOIN AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID
			INNER JOIN ExcessDetailsLog ON BagWeightUpdate.CustomerSessionID = ExcessDetailsLog.CustomerSessionID
			LEFT OUTER JOIN CustomerSession ON ExcessDetailsLog.CustomerSessionID = CustomerSession.ID
			LEFT OUTER JOIN Flight ON CustomerSession.FlightID = Flight.ID			 
			WHERE BagWeightUpdate.LocalTime BETWEEN @FromDateTime AND @ToDateTime  
				AND (AbdStation.Terminal LIKE @Terminal )
				AND (ISNULL(AbdStation.Area,'') LIKE @Area )
				AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
				AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
 
			--2. get all records not in table: ExcessTierLog put into table 
			declare @tblExcessRecords table 
			(
			Id int identity, 
			CustomerSessionID BigInt,
			FlightName varchar(50),
			FlightRoute varchar(50),
			ExcessValue BigInt,
			FlightNumber varchar(50)
			) 

			--records from table: ExcessDetailsLog
			insert into @tblExcessRecords(CustomerSessionID, FlightName, FlightRoute, ExcessValue, FlightNumber)
			select distinct
			custId.Id,
			isnull(Flight.MarketingCarrier + Flight.FlightNumber, 'X') AS FlightName,
			isnull(Flight.BoardPoint + ' - ' + Flight.OffPoint, '') as FlightRoute,
			cast(ExcessDetailsLog.TotalExcessValue as int) AS ExcessValue,
			CAST(Flight.FlightNumber AS nvarchar(100)) as FlightNumber			
			FROM @tblCustomerSessionID custId INNER JOIN BagWeightUpdate on custId.Id = BagWeightUpdate.CustomerSessionID
			INNER JOIN AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID
			INNER JOIN ExcessDetailsLog ON BagWeightUpdate.CustomerSessionID = ExcessDetailsLog.CustomerSessionID
			LEFT OUTER JOIN CustomerSession cs ON ExcessDetailsLog.CustomerSessionID = cs.ID
			LEFT OUTER JOIN Flight ON cs.FlightID = Flight.ID						 
			WHERE Not cs.ID in (select CustomerSessionID from ExcessTierLog)
				AND (AbdStation.Terminal LIKE @Terminal )
				AND (ISNULL(AbdStation.Area,'') LIKE @Area )
				AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
				AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)

			--records from table: ExcessTierLog
			insert into @tblExcessRecords(CustomerSessionID, FlightName, FlightRoute, ExcessValue, FlightNumber)
			select 
			et.CustomerSessionID, 
			isnull(et.Company + cast(et.Flightnumber as varchar), '') as FlightName,
			isnull(et.Origin + ' - ' + et.Destination, '') as FlightRoute,
			cast(et.ChargeValueMoney as BigInt) AS ExcessValue,
			CAST(et.FlightNumber AS nvarchar(100)) as FlightNumber			 
			from ExcessTierLog et
			where et.CustomerSessionID in (select Id from  @tblCustomerSessionID)

			--final results
			select 
			isnull(er.FlightName, 'X') AS FlightName,
			isnull(er.FlightRoute, '') as FlightRoute,
			cast(sum(er.ExcessValue) as int) AS TotalExcessValue, 
			count(er.FlightName) AS NumberOfExcess
			FROM @tblExcessRecords as er
			WHERE (CAST(er.FlightNumber AS nvarchar(100)) LIKE @FlightNumber) 
			GROUP BY FlightName, FlightRoute
			ORDER BY TotalExcessValue DESC
END
GO
Print 'Drop and Create SP TotalExcessAmountPerFlight' 


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AvailabilityStatesPerABD]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AvailabilityStatesPerABD]
GO
CREATE PROCEDURE [dbo].[AvailabilityStatesPerABD]
(
	@FromDateTime DateTime,
	@ToDateTime DateTime,
	@TimeSlotID int,
	@Terminal nvarchar(10) null = '%',
	@Area nvarchar(10) null = '%',
	@SubArea nvarchar(10) null = '%',
	@ABDStationIDs varchar(400) null = '0',
	@ABDStationNames varchar(4000) null = '%'
	)
		WITH RECOMPILE
AS

	SELECT     AbdStation.ID AS AbdStationID, dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,
		AbdStation.Area,AbdStation.SubArea) AS AbdStationName, 
		ABDStates.ID AS AbdStateID, ABDStates.State, SUM(ABDAvailability.MinutesInState) as MinutesInState
	FROM         ABDAvailability INNER JOIN
						  ABDStates ON ABDAvailability.ABDStateID = ABDStates.ID INNER JOIN
						  StateTimeSlots ON ABDAvailability.StateTimeSlotID = StateTimeSlots.ID INNER JOIN
						  TimeSlotHourly ON StateTimeSlots.TimeSlotHouryID = TimeSlotHourly.ID LEFT OUTER JOIN
						  AbdStation ON ABDAvailability.AbdStationID = AbdStation.ID
	WHERE        (ABDAvailability.Date  BETWEEN @FromDateTime AND @ToDateTime) 
		AND (@TimeSlotID = 0 OR ABDAvailability.StateTimeSlotID = @TimeSlotID)
		AND (AbdStation.Terminal LIKE @Terminal )
		AND (ISNULL(AbdStation.Area,'') LIKE @Area )
		AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
		AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
	GROUP BY AbdStation.ID, AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea,ABDStates.ID, ABDStates.State
	ORDER BY dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea), ABDStates.State

	RETURN
GO
Print 'Drop and Create SP AvailabilityStatesPerABD' 


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CMOperationalTimePerServer]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[CMOperationalTimePerServer]
GO
CREATE Procedure [dbo].[CMOperationalTimePerServer]
@FromDateTime DaTeTime,
@ToDateTime  Datetime,
@BDSServerType INT,
@Terminal nvarchar(10) null = '%',
@Area nvarchar(10) null = '%',
@SubArea nvarchar(10) null = '%',
@ABDStationIDs varchar(400) null = '0',
@ABDStationNames varchar(4000) null = '%'
As
Begin

		 IF @BDSServerType = 0
		 BEGIN
				SELECT isnull(BdsServerID, 0) as BdsServerID, isnull(ServerName, 'xxx') as ServerName, ROUND(AVG(ISNULL(CONVERT(float, MessageTime) / 1000.00,0.0)),2)  AS AvgMessageTime, ROUND(AVG(ISNULL(CONVERT(float,MessageSize),0.0)),2) AS AvgMessageSize, 
					COUNT(CMOperationHistory.ID) AS NumberOfMessages
				FROM CMOperationHistory
				JOIN AbdStation
				ON CMOperationHistory.AbdStationID = AbdStation.ID
				LEFT OUTER JOIN BdsAbdMapping 
				ON  BdsAbdMapping.AbdStationID = AbdStation.ID
				LEFT OUTER JOIN BDSServerType 
				ON BDSServerType.ID = BdsServerID
				WHERE MessageSent BETWEEN @FromDateTime AND @ToDateTime
				AND (AbdStation.Terminal LIKE @Terminal )
				AND (ISNULL(AbdStation.Area,'') LIKE @Area )
				AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
				AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
				GROUP BY BdsAbdMapping.BdsServerID,servername
		END
		ELSE
		BEGIN
				SELECT isnull(BdsServerID, 0) as BdsServerID, isnull(ServerName, 'xxx') as ServerName, ROUND(AVG(ISNULL(CONVERT(float, MessageTime) / 1000.00,0.0)),2)  AS AvgMessageTime, ROUND(AVG(ISNULL(CONVERT(float,MessageSize),0.0)),2) AS AvgMessageSize, 
					COUNT(CMOperationHistory.ID) AS NumberOfMessages
				FROM CMOperationHistory
				JOIN AbdStation
				ON CMOperationHistory.AbdStationID = AbdStation.ID
				LEFT OUTER JOIN BdsAbdMapping 
				ON  BdsAbdMapping.AbdStationID = AbdStation.ID
				LEFT OUTER JOIN BDSServerType 
				ON BDSServerType.ID = BdsServerID
				WHERE MessageSent BETWEEN @FromDateTime AND @ToDateTime
				AND BDSServerType.ID = @BDSServerType
				AND (AbdStation.Terminal LIKE @Terminal )
				AND (ISNULL(AbdStation.Area,'') LIKE @Area )
				AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
				AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
				GROUP BY BdsAbdMapping.BdsServerID,servername
		END
END
GO 
Print 'Drop and Create SP CMOperationalTimePerServer' 


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FrequencyDistributionOfResponseTimeData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[FrequencyDistributionOfResponseTimeData]
GO
CREATE PROC [dbo].[FrequencyDistributionOfResponseTimeData]
(
	@FromTime datetime,
	@ToTime datetime,
	@MessageType varchar(100),
	@Terminal nvarchar(10) null = '%',
	@Area nvarchar(10) null = '%',
	@SubArea nvarchar(10) null = '%',
	@ABDStationIDs varchar(400) null = '0',
	@ABDStationNames varchar(4000) null = '%'
)
AS 

;WITH ResponseTimeIntervals AS
(
	SELECT 0 AS FromMilliseconds, 1000 AS ToMilliseconds, '0000 - 1000 ms' AS TimeIntervalName
	UNION ALL
	SELECT 1001 AS FromMilliseconds, 2000 AS ToMilliseconds, '1001 - 2000 ms'
	UNION ALL
	SELECT 2001 AS FromMilliseconds, 3000 AS ToMilliseconds, '2001 - 3000 ms'
	UNION ALL
	SELECT 3001 AS FromMilliseconds, 4000 AS ToMilliseconds, '3001 - 4000 ms'
	UNION ALL
	SELECT 4001 AS FromMilliseconds, 5000 AS ToMilliseconds, '4001 - 5000 ms'
	UNION ALL
	SELECT 5001 AS FromMilliseconds, 6000 AS ToMilliseconds, '5001 - 6000 ms'
	UNION ALL
	SELECT 6001 AS FromMilliseconds, 7000 AS ToMilliseconds, '6001 - 7000 ms'
	UNION ALL
	SELECT 7001 AS FromMilliseconds, 9999999 AS ToMilliseconds, '> than 7000 ms'
)


SELECT ResponseTimeIntervals.TimeIntervalName, COUNT(CMOperationHistory.ID) NumberOfDCSMsgs,
	AVG(CMOperationHistory.MessageTime) AS AverageMessageTime, STDEV(CMOperationHistory.MessageTime) AS StandardDeviationMessageTime,
	MAX(CMOperationHistory.MessageTime) AS MaxMessageTime, MIN(CMOperationHistory.MessageTime) AS MinMessageTime
FROM CMOperationHistory
JOIN ResponseTimeIntervals
ON CMOperationHistory.MessageTime BETWEEN ResponseTimeIntervals.FromMilliseconds AND ResponseTimeIntervals.ToMilliseconds
INNER JOIN AbdStation ON CMOperationHistory.ABDStationID = AbdStation.ID
WHERE CMOperationHistory.MessageSent BETWEEN @FromTime AND @ToTime
	AND MessageType LIKE @MessageType
    AND (AbdStation.Terminal LIKE @Terminal )
    AND (ISNULL(AbdStation.Area,'') LIKE @Area )
    AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
    AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
GROUP BY ResponseTimeIntervals.TimeIntervalName,ResponseTimeIntervals.FromMilliseconds
ORDER BY ResponseTimeIntervals.FromMilliseconds
GO
Print 'Drop and Create SP FrequencyDistributionOfResponseTimeData' 


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HeavyTagReadPerABD]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HeavyTagReadPerABD]
GO
CREATE PROCEDURE [dbo].[HeavyTagReadPerABD]
(
	@FromDateTime DateTime,
	@ToDateTime DateTime,
    @Antenna nvarchar(50),
	@Terminal nvarchar(10) null = '%',
	@Area nvarchar(10) null = '%',
	@SubArea nvarchar(10) null = '%',
	@ABDStationIDs varchar(400) null = '0',
	@ABDStationNames varchar(4000) null = '%'
	)
	WITH RECOMPILE
AS

SELECT     dbo.GetAbdName(AbdStation.Identifier,AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea) AS AbdStationName,
	HeavyTagReadLog.HeavyTagReadStepID, HeavyTagReadStep.Heading,HeavyTagReadStep.Description, COUNT(HeavyTagReadLog.LocalLogTime) AS HeavyTagReads		  
FROM         HeavyTagReadLog 
				INNER JOIN AbdStation ON HeavyTagReadLog.AbdStationID = AbdStation.ID
				INNER JOIN HeavyTagReadAntenna ON HeavyTagReadLog.ID = HeavyTagReadAntenna.HeavyTagReadLogID 
				INNER JOIN RfidAntennaType ON HeavyTagReadAntenna.RfidAntennaTypeID = RfidAntennaType.ID 
				INNER JOIN HeavyTagReadStep on HeavyTagReadLog.HeavyTagReadStepID = HeavyTagReadStep.ID AND HeavyTagReadLog.WasReadSuccessful = 1
WHERE     (HeavyTagReadLog.LocalLogTime BETWEEN @FromDateTime AND @ToDateTime)
		    AND (RfidAntennaType.ShortName LIKE @Antenna)
			AND (AbdStation.Terminal LIKE @Terminal )
			AND (ISNULL(AbdStation.Area,'') LIKE @Area )
			AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
			AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
GROUP BY AbdStation.Identifier,AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea, HeavyTagReadLog.HeavyTagReadStepID, HeavyTagReadStep.Heading,HeavyTagReadStep.Description
ORDER BY dbo.GetAbdName(AbdStation.Identifier,AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea), HeavyTagReadStep.Heading
GO
Print 'Drop and Create SP HeavyTagReadPerABD' 


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HeavyTagsInjected]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HeavyTagsInjected]
GO
CREATE PROCEDURE [dbo].[HeavyTagsInjected]
(
	@FromDateTime DateTime,
	@ToDateTime DateTime,
	@Terminal nvarchar(10) null = '%',
	@Area nvarchar(10) null = '%',
	@SubArea nvarchar(10) null = '%',
	@ABDStationIDs varchar(400) null = '0',
	@ABDStationNames varchar(4000) null = '%'
	)
	WITH RECOMPILE
AS
/****** REV:5929  StoredProcedure [dbo].[HeavyTagsInjected]    Script Date: 05/21/2012 16:37:47 ******/
SELECT dbo.GetAbdName(AbdStation.Identifier,AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea) AS AbdStationName,
	t1.HeavyTagsPrinted, CAST(ISNULL(t3.HeavyTagsInjected,0) AS INT) as HeavyTagsInjected 
FROM  (SELECT     AbdStationID, COUNT(LocalLogTime) as HeavyTagsPrinted
		FROM         HeavyTagPrintLog
		WHERE     (HeavyTagPrintLog.LocalLogTime BETWEEN @FromDateTime AND @ToDateTime) 
		GROUP BY AbdStationID) as t1

LEFT OUTER JOIN (
	SELECT t2.AbdStationID, t2.HeavyTagsInjected 
	FROM  (SELECT     AbdStationID, COUNT(LocalLogTime) as HeavyTagsInjected
			FROM         HeavyTagInjectionLog
			WHERE     (HeavyTagInjectionLog.LocalLogTime BETWEEN @FromDateTime AND @ToDateTime) 
			GROUP BY AbdStationID) as t2 ) as t3
	ON  t3.AbdStationID = t1.AbdStationID
INNER JOIN AbdStation ON AbdStation.ID = t1.AbdStationID
WHERE (AbdStation.Terminal LIKE @Terminal )
    AND (ISNULL(AbdStation.Area,'') LIKE @Area )
    AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
    AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
ORDER BY dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea)

RETURN
GO
Print 'Drop and Create SP HeavyTagsInjected' 


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QBagTagReadPerABD]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[QBagTagReadPerABD]
GO
CREATE PROCEDURE [dbo].[QBagTagReadPerABD]
(
	@FromDateTime DateTime,
	@ToDateTime DateTime,
    @Antenna nvarchar(50),
	@Terminal nvarchar(10) null = '%',
	@Area nvarchar(10) null = '%',
	@SubArea nvarchar(10) null = '%',
	@ABDStationIDs varchar(400) null = '0',
	@ABDStationNames varchar(4000) null = '%'
	)
	WITH RECOMPILE
AS

Select * Into #Temp from QBagTagReadLog Where QBagTagReadLog.LocalLogTime BETWEEN @FromDateTime AND @ToDateTime

SELECT dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea) AS AbdStationName,
	QBagTagReadLog.QBagTagReadStepID,QBagTagReadStep.Heading, QBagTagReadStep.Description, 
	COUNT(QBagTagReadLog.LocalLogTime) AS QBagTagReads
	  
FROM     #Temp    QBagTagReadLog 
	INNER JOIN AbdStation ON QBagTagReadLog.AbdStationID = AbdStation.ID
	INNER JOIN QBagTagReadAntenna ON QBagTagReadLog.ID = QBagTagReadAntenna.QBagTagReadLogID 
	INNER JOIN RfidAntennaType ON QBagTagReadAntenna.RfidAntennaTypeID = RfidAntennaType.ID 
	INNER JOIN QBagTagReadStep on QBagTagReadLog.QBagTagReadStepID = QBagTagReadStep.ID AND QBagTagReadLog.WasReadSuccessful = 1	  
WHERE     (QBagTagReadLog.LocalLogTime BETWEEN @FromDateTime AND @ToDateTime)
		  AND (RfidAntennaType.ShortName LIKE @Antenna)
		  AND (AbdStation.Terminal LIKE @Terminal )
		  AND (ISNULL(AbdStation.Area,'') LIKE @Area )
		  AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
		  AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
GROUP BY AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea, QBagTagReadLog.QBagTagReadStepID,  
	QBagTagReadStep.Heading, QBagTagReadStep.Description
ORDER BY dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea), QBagTagReadStep.Heading

GO
Print 'Drop and Create SP QBagTagReadPerABD' 


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QBagTagWritePerABD]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[QBagTagWritePerABD]
GO
CREATE PROCEDURE [dbo].[QBagTagWritePerABD]
(
	@FromDateTime DateTime,
	@ToDateTime DateTime,
    @Antenna nvarchar(50),
	@Terminal nvarchar(10) null = '%',
	@Area nvarchar(10) null = '%',
	@SubArea nvarchar(10) null = '%',
	@ABDStationIDs varchar(400) null = '0',
	@ABDStationNames varchar(4000) null = '%'
	)
	WITH RECOMPILE
AS

Select * Into #Temp from QBagTagWriteLog Where QBagTagWriteLog.LocalLogTime BETWEEN @FromDateTime AND @ToDateTime

SELECT dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea) AS AbdStationName,
QBagTagWriteLog.QBagTagWriteStepID,QBagTagWriteStep.Heading, QBagTagWriteStep.Description, 
COUNT(QBagTagWriteLog.LocalLogTime) AS QBagTagWrites
	  
FROM     #Temp    QBagTagWriteLog 
	INNER JOIN AbdStation ON QBagTagWriteLog.AbdStationID = AbdStation.ID
	INNER JOIN QBagTagWriteAntenna ON QBagTagWriteLog.ID = QBagTagWriteAntenna.QBagTagWriteLogID 
	INNER JOIN RfidAntennaType ON QBagTagWriteAntenna.RfidAntennaTypeID = RfidAntennaType.ID 
	INNER JOIN QBagTagWriteStep on QBagTagWriteLog.QBagTagWriteStepID = QBagTagWriteStep.ID AND QBagTagWriteLog.WasWriteSuccessful = 1	  
WHERE     (QBagTagWriteLog.LocalLogTime BETWEEN @FromDateTime AND @ToDateTime)
		  AND (RfidAntennaType.ShortName LIKE @Antenna)
		  AND (AbdStation.Terminal LIKE @Terminal )
		  AND (ISNULL(AbdStation.Area,'') LIKE @Area )
		  AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
		  AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
GROUP BY AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea, QBagTagWriteLog.QBagTagWriteStepID,  
	QBagTagWriteStep.Heading, QBagTagWriteStep.Description
ORDER BY dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea), QBagTagWriteStep.Heading

GO
Print 'Drop and Create SP QBagTagWritePerABD' 


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransactionTimePerServer]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TransactionTimePerServer]
GO
CREATE PROCEDURE [dbo].[TransactionTimePerServer]
(
	@FromDateTime DateTime,
	@ToDateTime DateTime,
	@BdsServerTypeID INT,
	@Terminal nvarchar(10) null = '%',
	@Area nvarchar(10) null = '%',
	@SubArea nvarchar(10) null = '%',
	@ABDStationIDs varchar(400) null = '0',
	@ABDStationNames varchar(4000) null = '%'
)
AS
BEGIN
			declare @rwCount int
			Select @rwCount = count(AbdStationID) from BdsAbdMapping
		
			SELECT     Bag.ID, Bag.BagTagType, tempt.ID AS CustomerSessionID, tempt.AbdStationID, tempt.CustomerLookupType, tempt.FlightID, tempt.CustomerID, tempt.PNR, 
								  bagt.TimeSlot5minID, bagt.TimeSlot10minID, bagt.TimeSlotHourlyID, bagt.DayOfTheWeekID, bagt.LocalTime, tempt.SessionDuration, tempt.BagCount, 
								  tempt.TransactionTime, tempt.UtcCreationTime, tempt.UtcCompletionTime
			INTO  #tempTab
			FROM         BagWeightUpdate AS bagt INNER JOIN
									  (SELECT     CustomerSession.ID, CustomerSession.CustomerID, CustomerSession.AbdStationID, CustomerSession.CustomerLookupType, CustomerSession.PNR, 
								  CustomerSession.UtcCreationTime, CustomerSession.FlightID, CustomerSession.TimeSlot5minID, CustomerSession.TimeSlot10minID, 
								  CustomerSession.TimeSlotHourlyID, CustomerSession.DayOfTheWeekID, CustomerSession.LocalTime, CustomerSession.UtcCompletionTime, 
								  CustomerSession.SessionDuration, COUNT(BagWeightUpdate.BagID) AS BagCount, CustomerSession.SessionDuration / COUNT(BagWeightUpdate.BagID) 
								  AS TransactionTime
			FROM         CustomerSession INNER JOIN
								  BagWeightUpdate ON CustomerSession.ID = BagWeightUpdate.CustomerSessionID AND BagWeightUpdate.UtcTime BETWEEN CustomerSession.UtcCreationTime AND CustomerSession.UtcCompletionTime
			WHERE CustomerSession.LocalTime BETWEEN @FromDateTime AND @ToDateTime
			GROUP BY CustomerSession.ID, CustomerSession.CustomerID, CustomerSession.AbdStationID, CustomerSession.CustomerLookupType, CustomerSession.PNR, 
								  CustomerSession.UtcCreationTime, CustomerSession.FlightID, CustomerSession.TimeSlot5minID, CustomerSession.TimeSlot10minID, 
								  CustomerSession.TimeSlotHourlyID, CustomerSession.DayOfTheWeekID, CustomerSession.LocalTime, CustomerSession.UtcCompletionTime, 
								  CustomerSession.SessionDuration
			) AS tempt ON bagt.CustomerSessionID = tempt.ID INNER JOIN
			 Bag ON bagt.BagID = Bag.ID
 
 
		 If @BdsServerTypeID = 0
		 BEGIN
				IF @rwCount > 0
				BEGIN	 
					SELECT      B.ServerName, AVG(TransactionTime.TransactionTime) AS AvgTransactionTime, MIN(TransactionTime.TransactionTime) AS MinTransactionTime, 
											MAX(TransactionTime.TransactionTime) AS MaxTransactionTime
					FROM         #tempTab AS TransactionTime INNER JOIN
											Flight ON TransactionTime.FlightID = Flight.ID INNER JOIN
											ABDStation ON ABDStation.ID = TransactionTime.ABDStationID
											JOIN BdsAbdMapping ON ABDStation.ID = BdsAbdMapping.AbdStationID
											JOIN BDSServerType B ON B.ID = BdsAbdMapping.BdsServerID
					WHERE  (AbdStation.Terminal LIKE @Terminal )
							AND (ISNULL(AbdStation.Area,'') LIKE @Area )
							AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
							AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
					Group by B.ServerName
				END
				ELSE
				BEGIN
					SELECT      dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea) as ServerName, AVG(TransactionTime.TransactionTime) AS AvgTransactionTime, MIN(TransactionTime.TransactionTime) AS MinTransactionTime, 
											MAX(TransactionTime.TransactionTime) AS MaxTransactionTime
					FROM         #tempTab AS TransactionTime INNER JOIN
											Flight ON TransactionTime.FlightID = Flight.ID INNER JOIN
											ABDStation ON ABDStation.ID = TransactionTime.ABDStationID
					WHERE  (AbdStation.Terminal LIKE @Terminal )
							AND (ISNULL(AbdStation.Area,'') LIKE @Area )
							AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
							AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
					Group by dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea)
				END
		END
		ELSE
		BEGIN
				IF @rwCount > 0
				BEGIN
					SELECT      B.ServerName, AVG(TransactionTime.TransactionTime) AS AvgTransactionTime, MIN(TransactionTime.TransactionTime) AS MinTransactionTime, 
												MAX(TransactionTime.TransactionTime) AS MaxTransactionTime
						FROM         #tempTab AS TransactionTime INNER JOIN
												Flight ON TransactionTime.FlightID = Flight.ID INNER JOIN
												ABDStation ON ABDStation.ID = TransactionTime.ABDStationID
												JOIN BdsAbdMapping ON ABDStation.ID = BdsAbdMapping.AbdStationID
												JOIN BDSServerType B ON B.ID = BdsAbdMapping.BdsServerID
					WHERE B.ID = @BdsServerTypeID 
								AND (AbdStation.Terminal LIKE @Terminal )
								AND (ISNULL(AbdStation.Area,'') LIKE @Area )
								AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
								AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
					Group by B.ServerName
				END
				ELSE
				BEGIN
					SELECT  dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea) as ServerName, 
					AVG(TransactionTime.TransactionTime) AS AvgTransactionTime, 
					MIN(TransactionTime.TransactionTime) AS MinTransactionTime, 
												MAX(TransactionTime.TransactionTime) AS MaxTransactionTime
						FROM         #tempTab AS TransactionTime INNER JOIN
												Flight ON TransactionTime.FlightID = Flight.ID INNER JOIN
												ABDStation ON ABDStation.ID = TransactionTime.ABDStationID
					WHERE AbdStation.ID = @BdsServerTypeID 
								AND (AbdStation.Terminal LIKE @Terminal )
								AND (ISNULL(AbdStation.Area,'') LIKE @Area )
								AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
								AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
					Group by dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea)
				END
		END
END

GO
Print 'Drop and Create SP TransactionTimePerServer'

GO
Print 'END PATCHING'

------------------------------------------ no need change below ------------------------------------------
Declare @PatchVersion nvarchar(25) = '12.1i3'
 
-- Post-patch version deployment recording
Exec dbo.RecordVersionDeployment @PatchVersion
Print 'Recorded DB version deployment for: ' + @PatchVersion
GO
------------------------------------------ no need change above ------------------------------------------