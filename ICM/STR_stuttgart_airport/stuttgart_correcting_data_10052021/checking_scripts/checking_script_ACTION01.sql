SELECT *
  FROM [CUSSBagDropDB_STR].[dbo].[Flight]
  WHERE DatePart(year, [DepartureDate]) = 2021 and 
  DatePart(month, [DepartureDate]) = 4   and
 [MarketingCarrier] not in ('A3', 'AF', 'DE', 'EW', 'KL', 'TK')


select *
 from [dbo].[Flight]
where DatePart(year, [DepartureDate]) = 2021  
and DatePart(month, [DepartureDate]) = 4  
and MarketingCarrier = 'AF'



select *
from [dbo].[CustomerSession] where FlightID in 
(
	SELECT ID
	FROM [dbo].[Flight]
	WHERE DatePart(year, [DepartureDate]) = 2021  
	and DatePart(month, [DepartureDate]) = 4  
	and MarketingCarrier = 'AF'
)