SELECT MAX([ID]) as CUSSBagDropDB_NRT_CustomerSession_MaxID       --Total gap: 11,073
  FROM [CUSSBagDropDB_NRT].[dbo].[CustomerSession]   -- 3734988

SELECT MAX([ID]) as ReportingDB_NRT_CustomerSession_MaxID       
  FROM [CUSSReportingDB_NRT].[dbo].[CustomerSession] -- 3723915

  -------------------------------------
SELECT MAX([ID]) as CUSSBagDropDB_NRT_BagWeightUpdate_MaxID       --Total gap: 5,518,564
  FROM [CUSSBagDropDB_NRT].[dbo].[BagWeightUpdate]   -- 71812215

SELECT MAX([ID]) as CUSSReportingDB_NRT_BagWeightUpdate_MaxID       
  FROM [CUSSReportingDB_NRT].[dbo].[BagWeightUpdate] -- 66293651