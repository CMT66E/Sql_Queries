--Month

--USE ReportingDB;
--go

Declare @Fromdate Datetime , @Todate Datetime ,@AirlineGroup nvarchar(20)


-----################################################################################################################################### ------

---  Fill values into below parameters

Set @Fromdate ='2022-05-01 00:00:00.000'    -- fromdate 
Set @Todate = '2022-05-24 23:59:59.998'     -- To date 
SET @AirlineGroup = 'JL'   ----   1 - CX , 2- AirAsia Group , 3- Jetstar , 4 - Qantas, 5 - Singapore Airline Group
                          ----   6 - Cebu Pacific, 7 - Emirates, 8 - Qatar Airways, 9 - Korean Air, 10 - All Nippon Airlines
						  ----   11- Japan Airlines, 12 - Malaysia Airlines, 13 - Air New Zealand
						  ----   If only one airline is required, Modify the parameter with above numbers.
                                
DROP TABLE IF EXISTS #temp
DROP TABLE IF EXISTS #temp2
DROP TABLE IF EXISTS #temp3
-----################################################################################################################################### ------

SELECT     bagt.BagID, 
		   tempt.ID AS CustomerSessionID, 
		   CONVERT(varchar(30),tempt.LocalTime,103) + ' ' + LTRIM(RIGHT(CONVERT(CHAR(20),tempt.LocalTime, 22), 11)) As LocalTime, 
		   dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea) AS ABDStation, 
		   Cast(tempt.TransactionTime as Decimal(10,2))TransactionTime, 
		   Flight.MarketingCarrier,
		   Flight.FlightNumber,Bag.UBI, 
           tempt.PNR, 
		   Cast(tempt.SessionDuration as Decimal(10,2)) as SessionDuration, 
		   tempt.BagCount,
		   CONVERT(varchar(30),tempt.UtcCreationTime,103) + ' ' +  LTRIM(RIGHT(CONVERT(CHAR(20),tempt.UtcCreationTime, 22), 11)) AS UtcCreationTime,
		   CONVERT(varchar(30),tempt.UtcCompletionTime,103) + ' ' + LTRIM(RIGHT(CONVERT(CHAR(20),tempt.UtcCompletionTime, 22), 11)) AS UtcCompletionTime, 
		   bagt.Weight, 
           CAST(CASE WHEN bagt.Weight < 23 THEN 'No' ELSE 'H' END AS CHAR) AS IsHeavyBag into #temp
FROM         BagWeightUpdate AS bagt INNER JOIN
                          (SELECT     CustomerSession.ID, CustomerSession.CustomerID, CustomerSession.AbdStationID, CustomerSession.CustomerLookupType, CustomerSession.PNR, 
                                                   CustomerSession.UtcCreationTime, CustomerSession.FlightID, CustomerSession.TimeSlot5minID, CustomerSession.TimeSlot10minID, 
                                                   CustomerSession.TimeSlotHourlyID, CustomerSession.DayOfTheWeekID, CustomerSession.LocalTime, CustomerSession.UtcCompletionTime, 
                                                   CustomerSession.SessionDuration, COUNT(BagWeightUpdate.BagID) AS BagCount, 
                                                   CustomerSession.SessionDuration / COUNT(BagWeightUpdate.BagID) AS TransactionTime
                            FROM          CustomerSession INNER JOIN
                                                   BagWeightUpdate ON CustomerSession.ID = BagWeightUpdate.CustomerSessionID
                            GROUP BY CustomerSession.ID, CustomerSession.CustomerID, CustomerSession.AbdStationID, CustomerSession.CustomerLookupType, CustomerSession.PNR, 
                                                   CustomerSession.UtcCreationTime, CustomerSession.FlightID, CustomerSession.TimeSlot5minID, CustomerSession.TimeSlot10minID, 
                                                   CustomerSession.TimeSlotHourlyID, CustomerSession.DayOfTheWeekID, CustomerSession.LocalTime, CustomerSession.UtcCompletionTime, 
                                                   CustomerSession.SessionDuration
                                                        HAVING      CustomerSession.LocalTime > @Fromdate
                                                       AND CustomerSession.LocalTime < @Todate
                                                       ) AS tempt 
					  ON bagt.CustomerSessionID = tempt.ID INNER JOIN
                      Bag ON bagt.BagID = Bag.ID INNER JOIN
                      Flight ON tempt.FlightID = Flight.ID INNER JOIN
                      AbdStation ON tempt.AbdStationID = AbdStation.ID
					 Where  CharIndex(',' + CONVERT(Varchar(MAX), AirlineGroupID) + ',', ',' + @AirlineGroup + ',' ) > 0
					 
ORDER BY tempt.UtcCreationTime


select distinct * from #temp
Select sum(BagCount) as TotalBagCount from #temp

select distinct 
CustomerSessionID,
LocalTime,
ABDStation, 
TransactionTime,
MarketingCarrier,
UBI,
PNR,
SessionDuration,
BagCount,
UtcCreationTime,
UtcCompletionTime
--count(*) as BagCountFinal
--[Weight]
into #temp2
from #temp
group by CustomerSessionID,
LocalTime,
ABDStation, 
TransactionTime,
MarketingCarrier,
UBI,
PNR,
SessionDuration,
BagCount,
UtcCreationTime,
UtcCompletionTime

select 
CustomerSessionID,
LocalTime,
ABDStation, 
TransactionTime,
MarketingCarrier,
PNR,
SessionDuration,
count(UBI) as BagCount,
UtcCreationTime,
UtcCompletionTime
from #temp2
group by CustomerSessionID,
LocalTime,
ABDStation, 
TransactionTime,
MarketingCarrier,
PNR,
SessionDuration,
UtcCreationTime,
UtcCompletionTime


select 
CustomerSessionID,
LocalTime,
ABDStation, 
TransactionTime,
MarketingCarrier,
PNR,
SessionDuration,
count(UBI) as BagCount,
UtcCreationTime,
UtcCompletionTime into #temp3
from #temp2
group by CustomerSessionID,
LocalTime,
ABDStation, 
TransactionTime,
MarketingCarrier,
PNR,
SessionDuration,
UtcCreationTime,
UtcCompletionTime

select Sum(BagCount) as FinalBagCount from #temp3
 