declare @ReportMonthFirstDay DateTime = '2022/08/01 00:00:00'

select *
FROM [dbo].[CustomerSession] a 
INNER JOIN Flight b on a.FlightID = b.ID
LEFT OUTER JOIN AbdStation c on a.AbdStationID = c.ID
WHERE 
datepart(year, b.[DepartureDate]) = datepart(year, @ReportMonthFirstDay) and datepart(month, b.[DepartureDate]) = datepart(month, @ReportMonthFirstDay) 
--and datepart(day, b.[DepartureDate]) = datepart(day, @ReportMonthFirstDay)
--and c.AbdType = 'KSK' --only grab records from KSK
and b.MarketingCarrier = 'DE'
--and c.KioskName = 'STR1335K29'

order by b.DepartureDate, a.LocalTime 

--------------------------------------------------------------------------------------------------------------------------------------------------------------

select *
FROM [dbo].[CustomerSession] a 
INNER JOIN Flight b on a.FlightID = b.ID
LEFT OUTER JOIN AbdStation c on a.AbdStationID = c.ID
WHERE 
datepart(year, b.[DepartureDate]) = datepart(year, @ReportMonthFirstDay) and datepart(month, b.[DepartureDate]) = datepart(month, @ReportMonthFirstDay) and datepart(day, b.[DepartureDate]) = datepart(day, @ReportMonthFirstDay)
--and c.AbdType = 'KSK' --only grab records from KSK
and b.MarketingCarrier <> 'DE'
--and c.KioskName = 'STR1335K29'
order by b.DepartureDate, a.LocalTime  