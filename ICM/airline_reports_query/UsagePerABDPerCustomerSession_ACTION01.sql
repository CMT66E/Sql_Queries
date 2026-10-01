declare @FromDateTime DateTime = '2019/06/16 00:00:00'
declare @ToDateTime DateTime = '2019/06/21 23:59:59'

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
	CustomerSession.ID as CustomersessionID,
	CustomerSession.PNR,
	isnull(Flight.MarketingCarrier, 'xx') as AirlineCode,
	isnull(Flight.FlightNumber, 'xxx') as FlightNumber,
	CustomerSession.LocalTime as Startdate,
	DATEADD(SECOND, CustomerSession.SessionDuration, CustomerSession.LocalTime) as EndDate,  
	CustomerSession.SessionDuration 						   
	FROM         BagWeightUpdate INNER JOIN
							AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID INNER JOIN
							CustomerSession ON BagWeightUpdate.CustomerSessionID = CustomerSession.ID INNER JOIN
							Flight ON CustomerSession.FlightID = Flight.ID INNER JOIN 
							Bag ON BagWeightUpdate.BagID = Bag.ID
	WHERE     (BagWeightUpdate.LocalTime BETWEEN @FromDateTime AND @ToDateTime)
	ORDER BY dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea), isnull(Flight.MarketingCarrier, 'xx'), isnull(Flight.FlightNumber, 'xxx') desc