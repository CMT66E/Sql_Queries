declare @FromDateTime DateTime = '2019/01/01 00:00:00'
declare @ToDateTime DateTime = '2019/01/08 23:59:59'
-------------------------------------------------------------------------------------------------------------------
declare @tblRecordsHolder table 
(
[Year] int, 
[Month] int,
[Day] int,
Airport varchar(50),
ScheduleDate DateTIme,
AirlineCode varchar(10),
TotalBags int
) 
insert into @tblRecordsHolder
SELECT     
	DATEPART(YEAR, BagWeightUpdate.LocalTime) AS Year, 
	DATEPART(MONTH, BagWeightUpdate.LocalTime) AS Month, 
	DATEPART(DAY, BagWeightUpdate.LocalTime) AS Day, 
	AbdStation.PortCode as Airport, 
	Flight.DepartureDate as ScheduleDate,	
	isnull(Flight.MarketingCarrier, 'xx') + isnull(Flight.FlightNumber, 'xxx') as AirlineCode,	  	 
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
	AbdStation.SubArea,
	isnull(Flight.MarketingCarrier, 'xx') + isnull(Flight.FlightNumber, 'xxx'), 
	Flight.DepartureDate
ORDER BY DATEPART(YEAR, BagWeightUpdate.LocalTime), DATEPART(MONTH, BagWeightUpdate.LocalTime), DATEPART(DAY, BagWeightUpdate.LocalTime), 
	isnull(Flight.MarketingCarrier, 'xx') + isnull(Flight.FlightNumber, 'xxx'), Flight.DepartureDate 

select
[Year], 
[Month],
[Day],
Airport,
ScheduleDate,
AirlineCode,
sum(TotalBags) as TotalBags 
from @tblRecordsHolder
group by [Year], 
[Month],
[Day],
Airport,
ScheduleDate,
AirlineCode

 