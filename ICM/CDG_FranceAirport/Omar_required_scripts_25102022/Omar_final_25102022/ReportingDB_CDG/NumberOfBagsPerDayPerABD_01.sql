--Notes: Number of bags treated per day per ABD
--Date: 25-Oct-2022

USE [ReportingDB_CDG]
GO	
	
declare @FromDateTime DateTime  = '2022/07/01 00:00:00'
declare @ToDateTime DateTime = '2022/07/08 23:59:59'

SELECT     DATEPART(YEAR, BagWeightUpdate.LocalTime) AS Year, DATEPART(MONTH, BagWeightUpdate.LocalTime) AS Month, DATEPART(DAY, BagWeightUpdate.LocalTime) AS Day, 
cast(DATEADD(dd, 0, DATEDIFF(dd, 0, BagWeightUpdate.LocalTime)) as date) AS DateBagProcessed,
dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea) AS AbdStationName, SUM(BagWeightUpdate.Weight) AS TotalWeight, COUNT(BagWeightUpdate.LocalTime) AS Bags
						   
FROM         BagWeightUpdate INNER JOIN
					AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID INNER JOIN
					CustomerSession ON BagWeightUpdate.CustomerSessionID = CustomerSession.ID INNER JOIN
					Flight ON CustomerSession.FlightID = Flight.ID INNER JOIN 
					Bag ON BagWeightUpdate.BagID = Bag.ID
WHERE     (BagWeightUpdate.LocalTime BETWEEN @FromDateTime AND @ToDateTime)
GROUP BY DATEPART(YEAR, BagWeightUpdate.LocalTime), DATEPART(MONTH, BagWeightUpdate.LocalTime), DATEPART(DAY, BagWeightUpdate.LocalTime), 
AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea, AbdStation.AbdType,
DATEADD(dd, 0, DATEDIFF(dd, 0, BagWeightUpdate.LocalTime))
ORDER BY DATEPART(YEAR, BagWeightUpdate.LocalTime), DATEPART(MONTH, BagWeightUpdate.LocalTime), DATEPART(DAY, BagWeightUpdate.LocalTime), 
dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea)