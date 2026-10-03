USE [CUSSReportingDB_NRT]  -- including KIX records it has 6324 records, if remove KIX then 6,290
GO

declare @FromDate DateTime = '2026/05/01 00:00:00'
declare @ToDate DateTime = '2026/05/31 23:59:59'

DROP TABLE IF EXISTS #tempCust
DROP TABLE IF EXISTS #tempBagweight
DROP TABLE IF EXISTS #tempTabFinal 

Select * into #tempCust From CustomerSession where LocalTime between @FromDate And @ToDate
Select * into #tempBagweight from BagWeightUpdate where CustomerSessionId In ( Select ID from #tempCust)

SELECT   
			tempt.ID AS CustomerSessionID, 
			CONVERT(varchar(30),tempt.LocalTime,103) + ' ' + LTRIM(RIGHT(CONVERT(CHAR(20),tempt.LocalTime, 22), 11)) As LocalTime, 
			dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea, AbdStation.AbdType) AS ABDStation, 
			Cast(tempt.TransactionTime as Decimal(10,2))as 'TransactionTime(Avg)',
			tempt.SessionDuration,
			Flight.MarketingCarrier,
			Flight.FlightNumber,
			tempt.PNR, 
			tempt.BagCount,
			bagt.Weight, 
			bag.UBI,
			CAST(CASE WHEN bagt.Weight < 23 THEN 'No' ELSE 'H' END AS CHAR) AS IsHeavyBag,
			AbdStation.AbdType
			into #tempTabFinal
			--,AbdStation.PortCode
FROM         #tempBagweight AS bagt INNER JOIN
							(SELECT     CustomerSession.ID, CustomerSession.CustomerID, CustomerSession.AbdStationID, CustomerSession.CustomerLookupType, CustomerSession.PNR, 
													CustomerSession.UtcCreationTime, CustomerSession.FlightID, CustomerSession.TimeSlot5minID, CustomerSession.TimeSlot10minID, 
													CustomerSession.TimeSlotHourlyID, CustomerSession.DayOfTheWeekID, CustomerSession.LocalTime, CustomerSession.UtcCompletionTime, 
													CustomerSession.SessionDuration, COUNT(BagWeightUpdate.BagID) AS BagCount, 
													CustomerSession.SessionDuration / COUNT(BagWeightUpdate.BagID) AS TransactionTime
							FROM         #tempCust CustomerSession INNER JOIN
													#tempBagweight  BagWeightUpdate ON CustomerSession.ID = BagWeightUpdate.CustomerSessionID
							GROUP BY CustomerSession.ID, CustomerSession.CustomerID, CustomerSession.AbdStationID, CustomerSession.CustomerLookupType, CustomerSession.PNR, 
													CustomerSession.UtcCreationTime, CustomerSession.FlightID, CustomerSession.TimeSlot5minID, CustomerSession.TimeSlot10minID, 
													CustomerSession.TimeSlotHourlyID, CustomerSession.DayOfTheWeekID, CustomerSession.LocalTime, CustomerSession.UtcCompletionTime, 
													CustomerSession.SessionDuration
														HAVING      (CustomerSession.LocalTime >= @FromDate
														) AND CustomerSession.LocalTime <= @ToDate --AND CustomerSession.SessionDuration > 0
														) AS tempt ON bagt.CustomerSessionID = tempt.ID INNER JOIN
						Bag ON bagt.BagID = Bag.ID INNER JOIN
						Flight ON tempt.FlightID = Flight.ID INNER JOIN
						AbdStation ON tempt.AbdStationID = AbdStation.ID
where AbdStation.PortCode = 'NRT'  
ORDER BY tempt.BagCount desc
------------------------------------------------------------- total 340,491
select a.* 
from #tempTabFinal a inner join BagWeightUpdate b on a.CustomerSessionID = b.CustomerSessionID
 
