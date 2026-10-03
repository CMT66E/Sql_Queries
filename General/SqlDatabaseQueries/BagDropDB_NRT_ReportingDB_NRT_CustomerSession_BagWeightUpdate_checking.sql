

--gaps: 202,909 reords

SELECT *      --225,806
FROM [BagDropDB_NRT].[dbo].[BagWeightUpdate]
WHERE DATEPART(year, LocalTime) =2026 and DATEPART(month, LocalTime) = 4
  
  ----------------------------
SELECT *     -- 22,897
FROM [ReportingDB_NRT].[dbo].[BagWeightUpdate]
WHERE DATEPART(year, LocalTime) =2026 and DATEPART(month, LocalTime) = 4

-------------find missing ones-----------------
SELECT *      --202,909 reords
FROM [BagDropDB_NRT].[dbo].[BagWeightUpdate]
WHERE DATEPART(year, LocalTime) =2026 and DATEPART(month, LocalTime) = 4 and 
not ID in
(
select distinct ID from [ReportingDB_NRT].[dbo].[BagWeightUpdate]
WHERE DATEPART(year, LocalTime) =2026 and DATEPART(month, LocalTime) = 4
)

 