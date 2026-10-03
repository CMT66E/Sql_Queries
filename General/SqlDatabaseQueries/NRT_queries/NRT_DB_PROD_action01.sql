
SELECT MAX([ID]) as BagDropDB_NRT_CustomerSession_MaxID       --Total gap: 11,073
  FROM [BagDropDB_NRT].[dbo].[CustomerSession]   -- 3734988

SELECT MAX([ID]) as ReportingDB_NRT_CustomerSession_MaxID       
  FROM [ReportingDB_NRT].[dbo].[CustomerSession] -- 3723915

  -------------------------------------
SELECT MAX([ID]) as BagDropDB_NRT_CustomerSessionTimeOnEachScreen_MaxID       --Total gap: 5,518,564
  FROM [BagDropDB_NRT].[dbo].[CustomerSessionTimeOnEachScreen]   -- 71812215

SELECT MAX([ID]) as ReportingDB_NRT_CustomerSessionTimeOnEachScreen_MaxID       
  FROM [ReportingDB_NRT].[dbo].[CustomerSessionTimeOnEachScreen] -- 66293651