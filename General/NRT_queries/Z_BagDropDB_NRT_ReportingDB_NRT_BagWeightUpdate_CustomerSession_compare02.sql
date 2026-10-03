  SELECT [ID]
      ,[BagID]
      ,[Weight]
      ,[UtcTime]
      ,[CustomerSessionID]
      ,[LocalTime]
  FROM [BagDropDB_NRT].[dbo].[BagWeightUpdate]
  WHERE DATEPART(year, [LocalTime]) = 2026 and DATEPART(month, [LocalTime]) = 7 -- 205,067


  SELECT *
  FROM [ReportingDB_NRT].[dbo].[BagWeightUpdate]
  WHERE DATEPART(year, [LocalTime]) = 2026 and DATEPART(month, [LocalTime]) = 7 -- 205,067 ----gap: 0

  --

  SELECT *
  FROM [BagDropDB_NRT].[dbo].[CustomerSession]
  WHERE DATEPART(year, [LocalCreationTime]) = 2026 and DATEPART(month, [LocalCreationTime]) = 7  --and DATEPART(day, [LocalCreationTime]) = 1 -- 215,424


  SELECT *
  FROM [ReportingDB_NRT].[dbo].[CustomerSession]
  WHERE DATEPART(year, [LocalTime]) = 2026 and DATEPART(month, [LocalTime]) = 7  --and DATEPART(day, [LocalTime]) = 1 -- 215,424
  --

  SELECT count(ID)as TotalRows
  FROM [BagDropDB_NRT].[dbo].[CustomerSession]
  WHERE DATEPART(year, [LocalCreationTime]) = 2026 and DATEPART(month, [LocalCreationTime]) = 7  --and DATEPART(day, [LocalTime]) = 1 -- 215,424


  SELECT count(ID)as TotalRows
  FROM [ReportingDB_NRT].[dbo].[CustomerSession]
  WHERE DATEPART(year, [LocalTime]) = 2026 and DATEPART(month, [LocalTime]) = 7  --and DATEPART(day, [LocalTime]) = 1 -- 215,424