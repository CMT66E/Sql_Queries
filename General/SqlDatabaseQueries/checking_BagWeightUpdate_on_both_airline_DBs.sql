SELECT a.[ID]
      ,[BagID]
      ,[Weight]
      ,[UtcTime]
      ,[CustomerSessionID]
      ,[LocalTime]
      ,b.[AbdStationID]
  FROM [BagDropDB_NRT].[dbo].[BagWeightUpdate] a inner join CustomerSession b on a.CustomerSessionID = b.ID
  WHERE datepart(year, [LocalTime]) = 2026 and datepart(month, [LocalTime]) = 2
  and NOT a.ID in
  (
  SELECT [ID]      
  FROM [ReportingDB_NRT].[dbo].[BagWeightUpdate]
  WHERE datepart(year, [LocalTime]) = 2026 and datepart(month, [LocalTime]) = 2
  )
  order by [LocalTime]

