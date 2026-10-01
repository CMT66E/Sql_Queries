SELECT     TOP (100) PERCENT MIN(BagWeightUpdate.ID) AS ID, 
DATEPART(YEAR, BagWeightUpdate.LocalTime) AS Year, 
DATEPART(MONTH, BagWeightUpdate.LocalTime) AS Month, 
DATEPART(DAY, BagWeightUpdate.LocalTime) AS Day, 
SUM(BagWeightUpdate.Weight) AS TotalWeight, 
COUNT(BagWeightUpdate.LocalTime) AS Bags, 
'All' AS ABDStation,
Flight.FlightNumber

FROM         BagWeightUpdate INNER JOIN
						CustomerSession ON BagWeightUpdate.CustomerSessionID = CustomerSession.ID INNER JOIN
						Flight ON CustomerSession.FlightID = Flight.ID
WHERE     (BagWeightUpdate.LocalTime > '2018/02/01') 
AND (BagWeightUpdate.LocalTime < '2019/02/21') 
--AND (CAST(Flight.FlightNumber as varchar(100)) like 'QF')
	
GROUP BY DATEPART(YEAR, BagWeightUpdate.LocalTime), DATEPART(MONTH, BagWeightUpdate.LocalTime), DATEPART(DAY, BagWeightUpdate.LocalTime), Flight.FlightNumber
ORDER BY 'Year', 'Month', 'Day'