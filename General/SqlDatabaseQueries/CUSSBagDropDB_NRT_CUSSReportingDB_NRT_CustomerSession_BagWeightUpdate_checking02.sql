

SELECT *       --Total gap: -4
  FROM [CUSSBagDropDB_NRT].[dbo].[CustomerSession]   -- 465990
WHERE DATEPART(year, LocalCreationTime) =2026 and DATEPART(month, LocalCreationTime) = 4

SELECT *       
  FROM [CUSSReportingDB_NRT].[dbo].[CustomerSession] -- 465994
WHERE DATEPART(year, LocalTime) =2026 and DATEPART(month, LocalTime) = 4 

  -------------------------------------
SELECT *       --Total gap: 0
  FROM [CUSSBagDropDB_NRT].[dbo].[BagWeightUpdate]   -- 275704
WHERE DATEPART(year, LocalTime) =2026 and DATEPART(month, LocalTime) = 4 

SELECT *       
  FROM [CUSSReportingDB_NRT].[dbo].[BagWeightUpdate] -- 275704
  WHERE DATEPART(year, LocalTime) =2026 and DATEPART(month, LocalTime) = 4 