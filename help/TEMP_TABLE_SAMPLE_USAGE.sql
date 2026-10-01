DECLARE @FromTime DATETIME
SET @FromTime =  (Select Cast(convert (char(8),DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-2, 0),112) + ' 00:00:00.000' as datetime))

DECLARE @ToTime DATETIME
SET @ToTime =(Select cast(convert (char(8),DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-2, -1),112)+ ' 23:59:59.997' as datetime))

print '@FromTime = ' + cast(@FromTime as varchar) --Jul  1 2022 12:00AM
print '@ToTime = ' + cast(@ToTime as varchar)     --Jul 31 2022 12:00AM



DECLARE @MyTable TABLE
(
SNo int IDENTITY(1,1), 
[Date] DateTime,
AbdStationName varchar(50),
TimeSlotName nvarchar(50),
Bags int
)  

INSERT INTO @MyTable
	SELECT     DATEADD(dd, 0, DATEDIFF(dd, 0, BagWeightUpdate.LocalTime)) AS Date,
		dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea) AS AbdStationName,TimeSlotHourly.TimeSlotName, COUNT(*) AS Bags
	FROM         BagWeightUpdate INNER JOIN
						  AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID INNER JOIN
						  TimeSlotHourly ON BagWeightUpdate.TimeSlotHourlyID = TimeSlotHourly.ID INNER JOIN
						  CustomerSession ON BagWeightUpdate.CustomerSessionID = CustomerSession.ID INNER JOIN
						  Flight ON CustomerSession.FlightID = Flight.ID INNER JOIN 
						  Bag ON BagWeightUpdate.BagID = Bag.ID
	WHERE     (BagWeightUpdate.LocalTime BETWEEN @FromTime AND @ToTime) 
	--AND Flight.MarketingCarrier=@AirlineName
	GROUP BY DATEADD(dd, 0, DATEDIFF(dd, 0, BagWeightUpdate.LocalTime)),AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea,TimeSlotHourly.ID,TimeSlotHourly.TimeSlotName
	ORDER BY DATEADD(dd, 0, DATEDIFF(dd, 0, BagWeightUpdate.LocalTime)),dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea),TimeSlotHourly.ID, TimeSlotHourly.TimeSlotName

select * from @MyTable where AbdStationName like 'T2E_Z05%' order by AbdStationName

select AbdStationName, count(*) as OccurrencesCount from @MyTable where AbdStationName like 'T2E_Z05%' 
group by AbdStationName
order by AbdStationName