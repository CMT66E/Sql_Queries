declare @FromDateTime DateTime = '2019/01/01 00:00:00'
declare @ToDateTime DateTime = '2019/01/01 23:59:59'
-------------------------------------------------------------------------------------------------------------------
SELECT     
	DATEPART(YEAR, BagWeightUpdate.LocalTime) AS Year, 
	DATEPART(MONTH, BagWeightUpdate.LocalTime) AS Month, 
	DATEPART(DAY, BagWeightUpdate.LocalTime) AS Day, 
	AbdStation.PortCode as Airport, 
	Flight.DepartureDate as ScheduleDate,	
	isnull(Flight.MarketingCarrier, 'xx') + isnull(Flight.FlightNumber, 'xxx') as AirlineCode,	  
	COUNT(Flight.DepartureDate) AS Bags
	--COUNT(BagWeightUpdate.LocalTime) AS Bags
						   
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
	AbdStation.SubArea,
	isnull(Flight.MarketingCarrier, 'xx') + isnull(Flight.FlightNumber, 'xxx'), 
	Flight.DepartureDate
ORDER BY DATEPART(YEAR, BagWeightUpdate.LocalTime), DATEPART(MONTH, BagWeightUpdate.LocalTime), DATEPART(DAY, BagWeightUpdate.LocalTime), 
	isnull(Flight.MarketingCarrier, 'xx') + isnull(Flight.FlightNumber, 'xxx'), Flight.DepartureDate
-------------------------------------------------------------------------------------------------------------------
SELECT     
	DATEPART(YEAR, BagWeightUpdate.LocalTime) AS Year, 
	DATEPART(MONTH, BagWeightUpdate.LocalTime) AS Month, 
	DATEPART(DAY, BagWeightUpdate.LocalTime) AS Day, 
	AbdStation.PortCode as Airport, 
	Flight.DepartureDate as ScheduleDate,	
	isnull(Flight.MarketingCarrier, 'xx') + isnull(Flight.FlightNumber, 'xxx') as AirlineCode,	  
	BagWeightUpdate.LocalTime AS Bags
						   
FROM         BagWeightUpdate INNER JOIN
						AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID INNER JOIN
						CustomerSession ON BagWeightUpdate.CustomerSessionID = CustomerSession.ID INNER JOIN
						Flight ON CustomerSession.FlightID = Flight.ID INNER JOIN 
						Bag ON BagWeightUpdate.BagID = Bag.ID
WHERE     (BagWeightUpdate.LocalTime BETWEEN @FromDateTime AND @ToDateTime)
order by isnull(Flight.MarketingCarrier, 'xx') + isnull(Flight.FlightNumber, 'xxx')
-------------------------------------------------------------------------------------------------------------------