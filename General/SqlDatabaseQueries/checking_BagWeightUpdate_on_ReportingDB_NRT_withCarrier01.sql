SELECT a.[ID]
      ,[BagID]
      ,[Weight]
      ,[UtcTime]
      ,[CustomerSessionID]       
      ,[LocalTime]
      ,b.AbdStationID
      ,c.Identifier
      ,c.Terminal
      ,c.Area
      ,c.SubArea
      ,d.MarketingCarrier
  FROM [ReportingDB_NRT].[dbo].[BagWeightUpdate] a 
  inner join CustomerSession b on a.CustomerSessionID = b.ID
  inner join AbdStation c on b.AbdStationID = c.ID
  inner join Flight d on b.FlightID = d.ID
  WHERE datepart(year, [LocalTime]) = 2026 and datepart(month, [LocalTime]) = 2 and d.MarketingCarrier = 'CX'
  and b.[AbdStationID] in
  (
    SELECT ID
    FROM [ReportingDB_NRT].[dbo].[AbdStation]
    WHERE [Terminal] ='2' and [Area] = 'L' or [SubArea] = 'E'
  )
  order by ID desc