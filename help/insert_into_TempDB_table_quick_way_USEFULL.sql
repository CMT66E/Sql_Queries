/****** Script for SelectTopNRows command from SSMS  ******/
SELECT COUNT(*)
  FROM [CUSSReportingDB_CDG].[dbo].[AbdStateHistory]
  --order by [ID] desc
  --111160027

  SELECT        AbdStation.ID AS AbdStationID, ISNULL(MAX(AbdStateHistory.ID), 0) AS LastProcessedID 
FROM            AbdStateHistory RIGHT OUTER JOIN
                         AbdStation ON AbdStateHistory.AbdStationID = AbdStation.ID
WHERE  (AbdStation.AbdType = 'ABD' OR AbdStation.AbdType = 'KSK' OR AbdStation.AbdType = 'K')
GROUP BY AbdStation.ID 

---40513526
 
SELECT        AbdStation.ID AS AbdStationID, ISNULL(MAX(AbdStateHistory.ID), 0) AS LastProcessedID  into #tempAvailability
FROM            AbdStateHistory RIGHT OUTER JOIN
                         AbdStation ON AbdStateHistory.AbdStationID = AbdStation.ID
WHERE  (AbdStation.AbdType = 'ABD' OR AbdStation.AbdType = 'KSK' OR AbdStation.AbdType = 'K')
GROUP BY AbdStation.ID 
--  into #tempAvailability -> 40513526 ABD ID 754

select * from #tempAvailability where LastProcessedID = 40513526