--YVR offpoint in HK airport: because Kiosks won't be able to know if this passenger is going to board to current checking in airline or not. It just records the data whatever the customer sanned
declare @ReportMonthFirstDay DateTime = '2022/08/01 00:00:00'

select *
FROM [dbo].[CustomerSession] a 
INNER JOIN Flight b on a.FlightID = b.ID
LEFT OUTER JOIN AbdStation c on a.AbdStationID = c.ID
WHERE 
datepart(year, b.[DepartureDate]) = datepart(year, @ReportMonthFirstDay) and datepart(month, b.[DepartureDate]) = datepart(month, @ReportMonthFirstDay) 
--and c.AbdType = 'KSK' --only grab records from KSK
--and b.MarketingCarrier = 'KL'
and b.OffPoint = 'YVR'
order by b.DepartureDate 