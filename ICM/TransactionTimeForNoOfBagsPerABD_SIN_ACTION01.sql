declare @FromDateTime DateTime = '2026-06-01 00:00:00 AM'
declare @ToDateTime DateTime = '2026-06-30 11:59:59 PM'
declare @FlightNumber nvarchar(100)  = '%'
declare @BoardPass nvarchar(25) = '%'
declare @BagTagType nvarchar(25) = '%'
declare @Airline nvarchar(25) = ',BL,JQ,'
declare @Terminal nvarchar(10) = '%'
declare @Area nvarchar(10) = '%'
declare @SubArea nvarchar(10) = '%'
declare @ABDStationIDs varchar(400) = '0'
declare @ABDStationNames varchar(4000) = 'Display All ABDs'

--SELECT Items FROM  dbo.Split(@Airline, ',')

		DROP TABLE IF EXISTS #tempCusSession
		DROP TABLE IF EXISTS #tempTab

		IF (@Airline = '0' OR @Airline ='%' )
		SET @Airline = '%'



		 Select * into #tempCusSession  from CustomerSession Where LocalTime BETWEEN @FromDateTime AND @ToDateTime

		 --select * from #tempCusSession  
        ------------------
		 SELECT     CustomerSession.ID, CustomerSession.CustomerID, CustomerSession.AbdStationID, CustomerSession.CustomerLookupType, CustomerSession.PNR, 
							  CustomerSession.UtcCreationTime, CustomerSession.FlightID, CustomerSession.TimeSlot5minID, CustomerSession.TimeSlot10minID, 
							  CustomerSession.TimeSlotHourlyID, CustomerSession.DayOfTheWeekID, CustomerSession.LocalTime, CustomerSession.UtcCompletionTime, 
							  CustomerSession.SessionDuration, COUNT(BagWeightUpdate.BagID) AS BagCount
		INTO  #tempTab
		FROM        #tempCusSession CustomerSession LEFT OUTER JOIN
							  BagWeightUpdate ON CustomerSession.ID = BagWeightUpdate.CustomerSessionID --AND BagWeightUpdate.UtcTime BETWEEN CustomerSession.UtcCreationTime AND CustomerSession.UtcCompletionTime

		GROUP BY CustomerSession.ID, CustomerSession.CustomerID, CustomerSession.AbdStationID, CustomerSession.CustomerLookupType, CustomerSession.PNR, 
							  CustomerSession.UtcCreationTime, CustomerSession.FlightID, CustomerSession.TimeSlot5minID, CustomerSession.TimeSlot10minID, 
							  CustomerSession.TimeSlotHourlyID, CustomerSession.DayOfTheWeekID, CustomerSession.LocalTime, CustomerSession.UtcCompletionTime, 
							  CustomerSession.SessionDuration   
        -------------------      
		--select * from #tempTab  --449,342

		SELECT     
				dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea) AS AbdStationName, 
				NumberOfBagsMap.NoOfBagsGroupID, 
				TransactionTimeNoOfBags.BagCount, 
				TransactionTimeNoOfBags.SessionDuration, 
				TransactionTimeNoOfBags.SessionDuration, 
				TransactionTimeNoOfBags.SessionDuration,
				TransactionTimeNoOfBags.ID, 
				TransactionTimeNoOfBags.BagCount,*

		FROM         #tempTab AS TransactionTimeNoOfBags INNER JOIN
								AbdStation ON TransactionTimeNoOfBags.AbdStationID = AbdStation.ID AND AbdStation.AbdType = 'ABD' INNER JOIN
								Flight ON TransactionTimeNoOfBags.FlightID = Flight.ID INNER JOIN
								NumberOfBagsMap ON TransactionTimeNoOfBags.BagCount = NumberOfBagsMap.NumberOfBags
		WHERE     
			(CAST(Flight.FlightNumber AS nvarchar(100)) LIKE @FlightNumber) 
			AND (TransactionTimeNoOfBags.CustomerLookupType LIKE @BoardPass) 
            AND (Flight.MarketingCarrier IN (SELECT Items FROM  dbo.Split(@Airline, ',')))
		--------------------------------------
		SELECT     
				dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea) AS AbdStationName, 
				NumberOfBagsMap.NoOfBagsGroupID, 
				AVG(TransactionTimeNoOfBags.BagCount) AS AvgBagCount, 
				AVG(isnull(TransactionTimeNoOfBags.SessionDuration, 0)) AS AvgSessionDuration, 
				MIN(isnull(TransactionTimeNoOfBags.SessionDuration, 0)) AS MinSessionDuration, 
				MAX(isnull(TransactionTimeNoOfBags.SessionDuration, 0)) AS MaxSessionDuration,
				COUNT(TransactionTimeNoOfBags.ID) AS NumberOfCustomerTransactions, 
				SUM(TransactionTimeNoOfBags.BagCount) AS NumberOfBags

		FROM         #tempTab AS TransactionTimeNoOfBags INNER JOIN
								AbdStation ON TransactionTimeNoOfBags.AbdStationID = AbdStation.ID AND AbdStation.AbdType = 'ABD' INNER JOIN
								Flight ON TransactionTimeNoOfBags.FlightID = Flight.ID INNER JOIN
								NumberOfBagsMap ON TransactionTimeNoOfBags.BagCount = NumberOfBagsMap.NumberOfBags
		WHERE     
			(CAST(Flight.FlightNumber AS nvarchar(100)) LIKE @FlightNumber) 
			--AND (TransactionTimeNoOfBags.CustomerLookupType LIKE @BoardPass) 
			--AND (Flight.MarketingCarrier IN (SELECT Items 
			--		FROM  dbo.Split(@Airline, ',')))
			--AND (AbdStation.Terminal LIKE @Terminal )
			--AND (ISNULL(AbdStation.Area,'') LIKE @Area )
			--AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
			--AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)

		GROUP BY AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea, NumberOfBagsMap.NoOfBagsGroupID
		ORDER BY dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea), NumberOfBagsMap.NoOfBagsGroupID
