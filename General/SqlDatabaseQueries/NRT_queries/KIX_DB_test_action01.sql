SELECT MAX([ID]) as BagDropDB_KIX_CustomerSession_MaxID
       
  FROM [BagDropDB_KIX].[dbo].[CustomerSession]

SELECT MAX([ID]) as ReportingDB_KIX_CustomerSession_MaxID
       
  FROM [ReportingDB_KIX].[dbo].[CustomerSession]
----------------------------------------------------------------------------
SELECT MAX([ID]) as BagDropDB_KIX_CustomerSessionTimeOnEachScreen_MaxID
       
  FROM [BagDropDB_KIX].[dbo].[CustomerSessionTimeOnEachScreen]

SELECT MAX([ID]) as ReportingDB_KIX_CustomerSessionTimeOnEachScreen_MaxID
       
  FROM [ReportingDB_KIX].[dbo].[CustomerSessionTimeOnEachScreen]



  select * from [BagDropDB_KIX].[dbo].[CustomerSessionTimeOnEachScreen] --478 records need to be inserted into [ReportingDB_KIX].[dbo].[CustomerSessionTimeOnEachScreen]
  where ID > 1452890

  insert into [ReportingDB_KIX].[dbo].[CustomerSessionTimeOnEachScreen]
  select * from [BagDropDB_KIX].[dbo].[CustomerSessionTimeOnEachScreen]
  where ID > 1452890