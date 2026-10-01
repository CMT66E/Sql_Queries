--EXEC AvailabilityStatesPerHour '2019-06-19 00:00:00', '%', '%', '%', '0', '%'

declare @FromDateTime DateTime = '6/19/2019 12:00:00 AM'
declare @ToDateTime DateTime = '6/19/2019 11:59:59 PM'
declare @FlightNumber nvarchar(100)  = '%'
declare @BoardPass nvarchar(25) = '%'
declare @BagTagType nvarchar(25) = '%'
declare @Airline nvarchar(25) = '%'
declare @Terminal nvarchar(10) = '%'
declare @Area nvarchar(10) = '%'
declare @SubArea nvarchar(10) = '%'
declare @ABDStationIDs varchar(400) = '0'
declare @ABDStationNames varchar(4000) = 'Display All ABDs'

--result: 2019-06-19 13:44:59.557

		IF OBJECT_ID('tempdb..##tempCusSession') is not null
				DROP TABLE [dbo].[##tempCusSession]

		IF OBJECT_ID('tempdb..##temp') is not null
				DROP TABLE [dbo].[##temp]		

		Select * into ##tempCusSession  from CustomerSession Where LocalTime BETWEEN @FromDateTime AND @ToDateTime
 
		SELECT     CustomerSession.ID, CustomerSession.CustomerID, CustomerSession.AbdStationID, CustomerSession.CustomerLookupType, CustomerSession.PNR, 
							  CustomerSession.UtcCreationTime, CustomerSession.FlightID, CustomerSession.TimeSlot5minID, CustomerSession.TimeSlot10minID, 
							  CustomerSession.TimeSlotHourlyID, CustomerSession.DayOfTheWeekID, CustomerSession.LocalTime, CustomerSession.UtcCompletionTime, 
							  CustomerSession.SessionDuration, COUNT(BagWeightUpdate.BagID) AS BagCount
							  INTO ##temp
		FROM       ##tempCusSession  CustomerSession LEFT OUTER JOIN
							  BagWeightUpdate ON CustomerSession.ID = BagWeightUpdate.CustomerSessionID
		GROUP BY CustomerSession.ID, CustomerSession.CustomerID, CustomerSession.AbdStationID, CustomerSession.CustomerLookupType, CustomerSession.PNR, 
							  CustomerSession.UtcCreationTime, CustomerSession.FlightID, CustomerSession.TimeSlot5minID, CustomerSession.TimeSlot10minID, 
							  CustomerSession.TimeSlotHourlyID, CustomerSession.DayOfTheWeekID, CustomerSession.LocalTime, CustomerSession.UtcCompletionTime, 
							  CustomerSession.SessionDuration
        --test line start
	    --select * from ##tempCusSession where AbdStationID = 12
		--select * from ##temp where AbdStationID = 12 and BagCount = 0
		--test line end

		declare @TransactionTimeNoOfBags table 
		(
		[AbdStationName]  varchar(50),
		[NoOfBagsGroupID]  int,
		[AvgBagCount]  int,
		[AvgSessionDuration] float,
		[MinSessionDuration] float,
		[MaxSessionDuration] float,
		[NumberOfCustomerTransactions] bigint, 
		[NumberOfBags] int
		)

		insert into @TransactionTimeNoOfBags
		SELECT     
		dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea,AbdStation.AbdType) AS AbdStationName, 
		NumberOfBagsMap.NoOfBagsGroupID, 
		AVG(TransactionTimeNoOfBags.BagCount) AS AvgBagCount, 
		AVG(TransactionTimeNoOfBags.SessionDuration) AS AvgSessionDuration, 
		MIN(TransactionTimeNoOfBags.SessionDuration) AS MinSessionDuration, 
		MAX(TransactionTimeNoOfBags.SessionDuration) AS MaxSessionDuration,
		COUNT(TransactionTimeNoOfBags.ID) AS NumberOfCustomerTransactions, 
		SUM(TransactionTimeNoOfBags.BagCount) AS NumberOfBags

		FROM  ##temp  AS TransactionTimeNoOfBags INNER JOIN
							  AbdStation ON TransactionTimeNoOfBags.AbdStationID = AbdStation.ID INNER JOIN
							  Flight ON TransactionTimeNoOfBags.FlightID = Flight.ID INNER JOIN
							  NumberOfBagsMap ON TransactionTimeNoOfBags.BagCount = NumberOfBagsMap.NumberOfBags
		WHERE     (CAST(Flight.FlightNumber AS nvarchar(100)) LIKE @FlightNumber) 
			AND (TransactionTimeNoOfBags.CustomerLookupType LIKE @BoardPass) 
			AND (Flight.MarketingCarrier LIKE @Airline)
			AND (AbdStation.Terminal LIKE @Terminal)
			AND (ISNULL(AbdStation.Area,'') LIKE @Area )		
			AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea ) 
			AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
		GROUP BY AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.AbdType,AbdStation.SubArea, NumberOfBagsMap.NoOfBagsGroupID
		ORDER BY dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea,AbdStation.AbdType), NumberOfBagsMap.NoOfBagsGroupID

		select [AbdStationName],  
		[NoOfBagsGroupID],
		[AvgBagCount],
		isnull([AvgSessionDuration], 0) as AvgSessionDuration,
		isnull([MinSessionDuration], 0) as MinSessionDuration,
		isnull([MaxSessionDuration], 0) as MaxSessionDuration,
		isnull([NumberOfCustomerTransactions], 0) as NumberOfCustomerTransactions, 
		[NumberOfBags] from @TransactionTimeNoOfBags