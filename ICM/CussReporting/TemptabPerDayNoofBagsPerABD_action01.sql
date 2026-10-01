
declare @FromDateTime DateTime = '2019-06-19 00:00:01'
declare @ToDateTime DateTime = '2019-06-19 23:59:59'

drop table  if exists #TemptabPerDayNoofBagsPerABD 

SELECT     CustomerSession.ID, CustomerSession.CustomerID, CustomerSession.AbdStationID, CustomerSession.CustomerLookupType, CustomerSession.PNR, 
						CustomerSession.UtcCreationTime, CustomerSession.FlightID, CustomerSession.TimeSlot5minID, CustomerSession.TimeSlot10minID, 
						CustomerSession.TimeSlotHourlyID, CustomerSession.DayOfTheWeekID, CustomerSession.LocalTime, CustomerSession.UtcCompletionTime, 
						CustomerSession.SessionDuration, COUNT(BagWeightUpdate.BagID) AS BagCount
INTO #TemptabPerDayNoofBagsPerABD
FROM         CustomerSession LEFT OUTER JOIN
						BagWeightUpdate ON CustomerSession.ID = BagWeightUpdate.CustomerSessionID
WHERE CustomerSession.LocalTime BETWEEN @FromDateTime AND @ToDateTime
GROUP BY CustomerSession.ID, CustomerSession.CustomerID, CustomerSession.AbdStationID, CustomerSession.CustomerLookupType, CustomerSession.PNR, 
						CustomerSession.UtcCreationTime, CustomerSession.FlightID, CustomerSession.TimeSlot5minID, CustomerSession.TimeSlot10minID, 
						CustomerSession.TimeSlotHourlyID, CustomerSession.DayOfTheWeekID, CustomerSession.LocalTime, CustomerSession.UtcCompletionTime, 
						CustomerSession.SessionDuration   

select * from #TemptabPerDayNoofBagsPerABD

SELECT     DATEPART(YEAR, TransactionTimeNoOfBags.LocalTime) AS Year, DATEPART(MONTH, TransactionTimeNoOfBags.LocalTime) 
						AS Month, DATEPART(DAY, TransactionTimeNoOfBags.LocalTime) AS Day, AVG(TransactionTimeNoOfBags.SessionDuration) AS AvgSessionDuration, 
						AVG(TransactionTimeNoOfBags.BagCount) as AvgBagCount, MIN(TransactionTimeNoOfBags.SessionDuration) AS MinSessionDuration, 
						MAX(TransactionTimeNoOfBags.SessionDuration) AS MaxSessionDuration, dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea,AbdStation.AbdType) AS ABDStation, 
						NumberOfBagsMap.NoOfBagsGroupID
FROM          #TemptabPerDayNoofBagsPerABD as TransactionTimeNoOfBags INNER JOIN
						AbdStation ON TransactionTimeNoOfBags.AbdStationID = AbdStation.ID INNER JOIN
						Flight ON TransactionTimeNoOfBags.FlightID = Flight.ID INNER JOIN
						NumberOfBagsMap ON TransactionTimeNoOfBags.BagCount = NumberOfBagsMap.NumberOfBags
GROUP BY DATEPART(YEAR, TransactionTimeNoOfBags.LocalTime), DATEPART(MONTH, TransactionTimeNoOfBags.LocalTime), DATEPART(DAY, TransactionTimeNoOfBags.LocalTime), 
	AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea,AbdStation.AbdType,NumberOfBagsMap.NoOfBagsGroupID
ORDER BY DATEPART(YEAR, TransactionTimeNoOfBags.LocalTime), DATEPART(MONTH, TransactionTimeNoOfBags.LocalTime), DATEPART(DAY, TransactionTimeNoOfBags.LocalTime),
dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea,AbdStation.AbdType),NumberOfBagsMap.NoOfBagsGroupID