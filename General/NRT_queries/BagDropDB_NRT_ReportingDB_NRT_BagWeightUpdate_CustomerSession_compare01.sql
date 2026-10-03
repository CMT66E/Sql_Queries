  SELECT [ID]
      ,[BagID]
      ,[Weight]
      ,[UtcTime]
      ,[CustomerSessionID]
      ,[LocalTime]
  FROM [BagDropDB_NRT].[dbo].[BagWeightUpdate]
  WHERE DATEPART(year, [LocalTime]) = 2026 and DATEPART(month, [LocalTime]) = 6 -- 165,000

  SELECT *
  FROM [BagDropDB_NRT].[dbo].[CustomerSession]
  WHERE DATEPART(year, [LocalCreationTime]) = 2026 and DATEPART(month, [LocalCreationTime]) = 6 -- 173,792

  --

  SELECT *
  FROM [ReportingDB_NRT].[dbo].[BagWeightUpdate]
  WHERE DATEPART(year, [LocalTime]) = 2026 and DATEPART(month, [LocalTime]) = 6 -- 43,057


  SELECT *
  FROM [ReportingDB_NRT].[dbo].[CustomerSession]
  WHERE DATEPART(year, [LocalTime]) = 2026 and DATEPART(month, [LocalTime]) = 6 -- 173,831