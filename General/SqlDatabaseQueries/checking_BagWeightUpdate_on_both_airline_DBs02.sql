SELECT [ID]
      ,[BagID]
      ,[Weight]
      ,[UtcTime]
      ,[CustomerSessionID]
      ,[LocalTime]
  FROM [BagDropDB_NRT].[dbo].[BagWeightUpdate]
  WHERE datepart(year, [LocalTime]) = 2026 and datepart(month, [LocalTime]) = 2


SELECT [ID]
      ,[BagID]
      ,[Weight]
      ,[UtcTime]
      ,[CustomerSessionID]
      ,[LocalTime]
      ,AbdStationID
  FROM [ReportingDB_NRT].[dbo].[BagWeightUpdate]
  WHERE datepart(year, [LocalTime]) = 2026 and datepart(month, [LocalTime]) = 2
  order by [LocalTime]
