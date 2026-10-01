declare @FromDateTime DateTime = '2019/01/01 00:00:00'
declare @ToDateTime DateTime = '2019/01/01 23:59:59'
-------------------------------------------------------------------------------------------------------------------
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
	Flight.DepartureDate,	
	isnull(Flight.MarketingCarrier, 'xx') as AirlineCode,
	isnull(Flight.FlightNumber, 'xxx') as FlightNumber,	 
	CustomerSession.CustomerID 						   
FROM         BagWeightUpdate INNER JOIN
						AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID INNER JOIN
						CustomerSession ON BagWeightUpdate.CustomerSessionID = CustomerSession.ID INNER JOIN
						Flight ON CustomerSession.FlightID = Flight.ID INNER JOIN 
						Bag ON BagWeightUpdate.BagID = Bag.ID
WHERE     (BagWeightUpdate.LocalTime BETWEEN @FromDateTime AND @ToDateTime)
-------------------------------------------------------------------------------------------------------------------
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
	Flight.DepartureDate,	
	isnull(Flight.MarketingCarrier, 'xx') as AirlineCode,
	isnull(Flight.FlightNumber, 'xxx') as FlightNumber,	 
	count(CustomerSession.CustomerID) as TotalPax 						   
FROM         BagWeightUpdate INNER JOIN
						AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID INNER JOIN
						CustomerSession ON BagWeightUpdate.CustomerSessionID = CustomerSession.ID INNER JOIN
						Flight ON CustomerSession.FlightID = Flight.ID INNER JOIN 
						Bag ON BagWeightUpdate.BagID = Bag.ID
WHERE     (BagWeightUpdate.LocalTime BETWEEN @FromDateTime AND @ToDateTime)
group by
	DATEPART(YEAR, BagWeightUpdate.LocalTime), 
	DATEPART(MONTH, BagWeightUpdate.LocalTime), 
	DATEPART(DAY, BagWeightUpdate.LocalTime), 
	AbdStation.PortCode, 
	AbdStation.Identifier, 
	AbdStation.Terminal,
	AbdStation.Area,
	AbdStation.SubArea,	
	dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea),
	Flight.DepartureDate,	
	isnull(Flight.MarketingCarrier, 'xx'),
	isnull(Flight.FlightNumber, 'xxx')
