declare @FromDate DateTime = '2024-11-01 00:00:00'
declare @ToDate DateTime = '2024-11-30 23:59:59'

declare @Terminal varchar(10)

        DROP TABLE IF EXISTS #tempCust
		DROP TABLE IF EXISTS #tempBagweight

		Select a.* into #tempCust From CustomerSession a inner join AbdStation b ON a.AbdStationID = b.ID where LocalTime between @FromDate And @ToDate and b.Terminal = 'SYD3'
		Select * into #tempBagweight from BagWeightUpdate where CustomerSessionId In ( Select ID from #tempCust) --404,155

		SELECT   
				   tempt.ID AS CustomerSessionID, 
				   CONVERT(varchar(30),tempt.LocalTime,103) + ' ' + LTRIM(RIGHT(CONVERT(CHAR(20),tempt.LocalTime, 22), 11)) As LocalTime, 
				   dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea) AS ABDStation, 
				   AbdStation.Terminal,
				   Cast(tempt.TransactionTime as Decimal(10,2))as 'TransactionTime(Avg)',
				   tempt.SessionDuration,
				   Flight.MarketingCarrier,
				   Flight.FlightNumber,
				   tempt.PNR, 
				   tempt.BagCount,
				   bagt.Weight, 
				   bag.UBI,
				   CAST(CASE WHEN bagt.Weight < 23 THEN 'No' ELSE 'H' END AS CHAR) AS IsHeavyBag
		FROM         #tempBagweight AS bagt INNER JOIN
								  (SELECT     CustomerSession.ID, CustomerSession.CustomerID, CustomerSession.AbdStationID, CustomerSession.CustomerLookupType, CustomerSession.PNR, 
														   CustomerSession.UtcCreationTime, CustomerSession.FlightID, CustomerSession.TimeSlot5minID, CustomerSession.TimeSlot10minID, 
														   CustomerSession.TimeSlotHourlyID, CustomerSession.DayOfTheWeekID, CustomerSession.LocalTime, CustomerSession.UtcCompletionTime, 
														   CustomerSession.SessionDuration, COUNT(BagWeightUpdate.BagID) AS BagCount, 
														   CustomerSession.SessionDuration / COUNT(BagWeightUpdate.BagID) AS TransactionTime
									FROM         #tempCust CustomerSession INNER JOIN
														  #tempBagweight  BagWeightUpdate ON CustomerSession.ID = BagWeightUpdate.CustomerSessionID
									GROUP BY CustomerSession.ID, CustomerSession.CustomerID, CustomerSession.AbdStationID, CustomerSession.CustomerLookupType, CustomerSession.PNR, 
														   CustomerSession.UtcCreationTime, CustomerSession.FlightID, CustomerSession.TimeSlot5minID, CustomerSession.TimeSlot10minID, 
														   CustomerSession.TimeSlotHourlyID, CustomerSession.DayOfTheWeekID, CustomerSession.LocalTime, CustomerSession.UtcCompletionTime, 
														   CustomerSession.SessionDuration
																HAVING      (CustomerSession.LocalTime >= @FromDate
															 ) AND CustomerSession.LocalTime <= @ToDate --AND CustomerSession.SessionDuration > 0
															   ) AS tempt ON bagt.CustomerSessionID = tempt.ID INNER JOIN
							  Bag ON bagt.BagID = Bag.ID INNER JOIN
							  Flight ON tempt.FlightID = Flight.ID INNER JOIN
							  AbdStation ON tempt.AbdStationID = AbdStation.ID
		ORDER BY tempt.UtcCreationTime