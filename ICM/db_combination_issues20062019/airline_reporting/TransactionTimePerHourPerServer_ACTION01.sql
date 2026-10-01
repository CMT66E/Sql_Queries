 
declare @FlightNumber nvarchar(100)  = '%'
declare @BoardPass nvarchar(25)  = '%'
declare @BagTagType nvarchar(25)  = '%'
declare @Airline nvarchar(25)  = '%'
   
declare @FromDateTime datetime = '2019-06-20'
declare @ToDateTime datetime = '2019-06-26'
declare @BdsServertype INT = 0

declare @Terminal nvarchar(10)  = 'PER3'
declare @Area nvarchar(10)  = '%'
declare @SubArea nvarchar(10)  = '%'
declare @ABDStationIDs varchar(400)  = '0'
declare @ABDStationNames varchar(4000)  = '%'

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

		drop table #tempTab