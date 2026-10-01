USE ReportingDB_CDG
GO	
	
declare @FromDateTime DateTime  = '2022/07/31 00:00:00'
declare @ToDateTime DateTime = '2022/07/31 23:59:59'


SELECT     DATEADD(dd, 0, DATEDIFF(dd, 0, BagWeightUpdate.LocalTime)) AS Date,
	dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea) AS AbdStationName,TimeSlotHourly.TimeSlotName, COUNT(*) AS Bags
FROM         BagWeightUpdate INNER JOIN
						AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID INNER JOIN
						TimeSlotHourly ON BagWeightUpdate.TimeSlotHourlyID = TimeSlotHourly.ID INNER JOIN
						CustomerSession ON BagWeightUpdate.CustomerSessionID = CustomerSession.ID INNER JOIN
						Flight ON CustomerSession.FlightID = Flight.ID INNER JOIN 
						Bag ON BagWeightUpdate.BagID = Bag.ID
WHERE     (BagWeightUpdate.LocalTime BETWEEN @FromDateTime AND @ToDateTime)
GROUP BY DATEADD(dd, 0, DATEDIFF(dd, 0, BagWeightUpdate.LocalTime)),AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea,TimeSlotHourly.ID,TimeSlotHourly.TimeSlotName
ORDER BY DATEADD(dd, 0, DATEDIFF(dd, 0, BagWeightUpdate.LocalTime)),dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea),TimeSlotHourly.ID, TimeSlotHourly.TimeSlotName