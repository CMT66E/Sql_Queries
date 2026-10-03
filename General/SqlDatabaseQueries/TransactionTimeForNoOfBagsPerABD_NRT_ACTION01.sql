USE ReportingDB_NRT -- T1S Zone C
GO


declare @FromDateTime DateTime = '2024-11-01 00:00:00 AM'
declare @ToDateTime DateTime = '2024-11-30 11:59:59 PM'
declare @FlightNumber nvarchar(100)  = '%'
declare @BoardPass nvarchar(25) = '%'
declare @BagTagType nvarchar(25) = '%'
declare @Airline nvarchar(25) = 'AC,NH,NQ,NZ,TG'
declare @Terminal nvarchar(10) = '%'
declare @Area nvarchar(10) = '%'
declare @SubArea nvarchar(10) = '%'
declare @ABDStationIDs varchar(400) = ',81,82,83,84,85,86,87,88,89,90,'

		IF OBJECT_ID('tempdb..#tempCusSession') is not null
				DROP TABLE [dbo].[#tempCusSession]

		IF OBJECT_ID('tempdb..##temp') is not null
				DROP TABLE [dbo].[##temp]	
				
		IF OBJECT_ID('tempdb..#tempTab') is not null
				DROP TABLE [dbo].[#tempTab]	

		IF (@Airline = '0' OR @Airline ='%' )
		SET @Airline = '%'

		 Select * into #tempCusSession  from CustomerSession Where LocalTime BETWEEN @FromDateTime AND @ToDateTime
 
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
                      
        IF @Airline = '%'   
			SELECT     dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea) AS AbdStationName, NumberOfBagsMap.NoOfBagsGroupID, 
				  AVG(TransactionTimeNoOfBags.BagCount) AS AvgBagCount, AVG(TransactionTimeNoOfBags.SessionDuration) AS AvgSessionDuration, 
				  MIN(TransactionTimeNoOfBags.SessionDuration) AS MinSessionDuration, MAX(TransactionTimeNoOfBags.SessionDuration) AS MaxSessionDuration,
				  COUNT(TransactionTimeNoOfBags.ID) AS NumberOfCustomerTransactions, SUM(TransactionTimeNoOfBags.BagCount) AS NumberOfBags
			FROM         #tempTab AS TransactionTimeNoOfBags INNER JOIN
								  AbdStation ON TransactionTimeNoOfBags.AbdStationID = AbdStation.ID AND AbdStation.AbdType = 'ABD' INNER JOIN
								  Flight ON TransactionTimeNoOfBags.FlightID = Flight.ID INNER JOIN
								  NumberOfBagsMap ON TransactionTimeNoOfBags.BagCount = NumberOfBagsMap.NumberOfBags
			WHERE     (CAST(Flight.FlightNumber AS nvarchar(100)) LIKE @FlightNumber) 
				AND (TransactionTimeNoOfBags.CustomerLookupType LIKE @BoardPass) 
				AND (Flight.MarketingCarrier LIKE @Airline)
				AND (AbdStation.Terminal LIKE @Terminal )
				AND (ISNULL(AbdStation.Area,'') LIKE @Area )
				AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
				AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
			GROUP BY AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea, NumberOfBagsMap.NoOfBagsGroupID
			ORDER BY dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea), NumberOfBagsMap.NoOfBagsGroupID
		ELSE
		 BEGIN


			SELECT     dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea) AS AbdStationName, NumberOfBagsMap.NoOfBagsGroupID, 
				  AVG(TransactionTimeNoOfBags.BagCount) AS AvgBagCount, AVG(TransactionTimeNoOfBags.SessionDuration) AS AvgSessionDuration, 
				  MIN(TransactionTimeNoOfBags.SessionDuration) AS MinSessionDuration, MAX(TransactionTimeNoOfBags.SessionDuration) AS MaxSessionDuration,
				  COUNT(TransactionTimeNoOfBags.ID) AS NumberOfCustomerTransactions, SUM(TransactionTimeNoOfBags.BagCount) AS NumberOfBags
			FROM         #tempTab AS TransactionTimeNoOfBags INNER JOIN
								  AbdStation ON TransactionTimeNoOfBags.AbdStationID = AbdStation.ID AND AbdStation.AbdType = 'ABD' INNER JOIN
								  Flight ON TransactionTimeNoOfBags.FlightID = Flight.ID INNER JOIN
								  NumberOfBagsMap ON TransactionTimeNoOfBags.BagCount = NumberOfBagsMap.NumberOfBags
			WHERE     (CAST(Flight.FlightNumber AS nvarchar(100)) LIKE @FlightNumber) 
				AND (TransactionTimeNoOfBags.CustomerLookupType LIKE @BoardPass) 
				AND (Flight.MarketingCarrier IN (SELECT Items 
						FROM  dbo.Split(@Airline, ',')))
				AND (AbdStation.Terminal LIKE @Terminal )
				AND (ISNULL(AbdStation.Area,'') LIKE @Area )
				AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
				AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
			
			GROUP BY AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea, NumberOfBagsMap.NoOfBagsGroupID
			ORDER BY NumberOfBagsMap.NoOfBagsGroupID, dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea), AVG(TransactionTimeNoOfBags.BagCount)
		END