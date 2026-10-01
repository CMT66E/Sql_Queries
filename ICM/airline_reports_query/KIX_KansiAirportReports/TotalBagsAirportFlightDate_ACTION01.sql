declare @FromDateTime DateTime = '2019/01/01 00:00:00'
declare @ToDateTime DateTime = '2019/01/08 23:59:59'
-------------------------------------------------------------------------------------------------------------------
SELECT     
	DATEPART(YEAR, BagWeightUpdate.LocalTime) AS Year, 
	DATEPART(MONTH, BagWeightUpdate.LocalTime) AS Month, 
	DATEPART(DAY, BagWeightUpdate.LocalTime) AS Day, 
	AbdStation.PortCode, 
	AbdStation.Identifier, 
	AbdStation.Terminal,
	AbdStation.Area,
	AbdStation.SubArea,	
	dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea) AS AbdStationName, 
	Flight.MarketingCarrier,
	Flight.FlightNumber,
	Flight.DepartureDate,	
	dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea) AS AbdStationName, 
	BagWeightUpdate.Weight AS TotalWeight, 
	BagWeightUpdate.LocalTime AS Bags
						   
FROM         BagWeightUpdate INNER JOIN
						AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID INNER JOIN
						CustomerSession ON BagWeightUpdate.CustomerSessionID = CustomerSession.ID INNER JOIN
						Flight ON CustomerSession.FlightID = Flight.ID INNER JOIN 
						Bag ON BagWeightUpdate.BagID = Bag.ID
WHERE     (BagWeightUpdate.LocalTime BETWEEN @FromDateTime AND @ToDateTime)
-------------------------------------------------------------------------------------------------------------------
SELECT     
	DATEPART(YEAR, BagWeightUpdate.LocalTime) AS Year, 
	DATEPART(MONTH, BagWeightUpdate.LocalTime) AS Month, 
	DATEPART(DAY, BagWeightUpdate.LocalTime) AS Day, 
	AbdStation.PortCode, 
	AbdStation.Identifier, 
	AbdStation.Terminal,
	AbdStation.Area,
	AbdStation.SubArea,	
	dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea) AS AbdStationName, 
	SUM(BagWeightUpdate.Weight) AS TotalWeight, 
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
	AbdStation.SubArea
ORDER BY DATEPART(YEAR, BagWeightUpdate.LocalTime), DATEPART(MONTH, BagWeightUpdate.LocalTime), DATEPART(DAY, BagWeightUpdate.LocalTime), 
	dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea)