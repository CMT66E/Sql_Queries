  SELECT [ID]
      ,[BagID]
      ,[Weight]
      ,[UtcTime]
      ,[CustomerSessionID]
      ,[LocalTime]
  FROM [BagDropDB_SIN].[dbo].[BagWeightUpdate]
  WHERE DATEPART(year, [LocalTime]) = 2026 and DATEPART(month, [LocalTime]) = 4 -- 482,470


  SELECT *
  FROM [ReportingDB_SIN_APR2026].[dbo].[BagWeightUpdate]
  WHERE DATEPART(year, [LocalTime]) = 2026 and DATEPART(month, [LocalTime]) = 4 -- 479,421

    --

  SELECT *
  FROM [BagDropDB_SIN].[dbo].[CustomerSession]
  WHERE DATEPART(year, [LocalCreationTime]) = 2026 and DATEPART(month, [LocalCreationTime]) = 4  and DATEPART(day, [LocalCreationTime]) = 1 -- 493,599


  SELECT *
  FROM [ReportingDB_SIN_APR2026].[dbo].[CustomerSession]
  WHERE DATEPART(year, [LocalTime]) = 2026 and DATEPART(month, [LocalTime]) = 4  and DATEPART(day, [LocalTime]) = 1 -- 491,665