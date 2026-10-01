--Date: 16-02-2022 
--Purpose: This script will use input date range to count the number of bags each ABD station processed based on each day's hour slots.
--defaut we caculate the whole year of 2021
--The original request from CAG:
--CAG is requesting for statistics to study the hourly usage on SBD of selected airline i.e. To display the SBD used, 
--number of bags dropped during each hour and selected date (daily or month) of an airline.


declare @FromDateTime DateTime = '2021/12/01 00:00:00'
declare @ToDateTime DateTime = '2021/12/31 23:59:59'

DECLARE @MyTable TABLE
(
SNo int IDENTITY(1,1), 
ABDStationID int,
AbdStationName varchar(50),
TimeSlotName varchar(50),
Airline varchar(10),
CountingDate datetime,
TotalBags int
)   

insert into @MyTable
SELECT AbdStation.ID AS ABDStationID, 
dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea) AS AbdStationName, 
TimeSlotHourly.TimeSlotName, 
Flight.MarketingCarrier,
cast(BagWeightUpdate.LocalTime as date) as CountingDate,
COUNT(*) AS Bags
FROM         BagWeightUpdate INNER JOIN
						AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID INNER JOIN
						TimeSlotHourly ON BagWeightUpdate.TimeSlotHourlyID = TimeSlotHourly.ID INNER JOIN
				  CustomerSession ON BagWeightUpdate.CustomerSessionID = CustomerSession.ID INNER JOIN
				  Flight ON CustomerSession.FlightID = Flight.ID
WHERE     (BagWeightUpdate.LocalTime BETWEEN @FromDateTime AND @ToDateTime) 
GROUP BY AbdStation.ID,AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea, TimeSlotHourly.ID,TimeSlotHourly.TimeSlotName, Flight.MarketingCarrier, cast(BagWeightUpdate.LocalTime as date)
ORDER BY dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea), TimeSlotHourly.ID, TimeSlotHourly.TimeSlotName, Flight.MarketingCarrier, cast(BagWeightUpdate.LocalTime as date)

select 
ABDStationID,
AbdStationName,
TimeSlotName,
Airline,
CountingDate,
TotalBags
from @MyTable 
--where CountingDate = '2021-12-01' and TimeSlotName = '15' and Airline = 'TR'
order by CountingDate asc