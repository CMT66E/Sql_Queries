SELECT a.[ID]
      ,[BagID]
      ,[Weight]
      ,[UtcTime]
      ,[CustomerSessionID]       
      ,[LocalTime]
      ,b.AbdStationID
  FROM [BagDropDB_NRT].[dbo].[BagWeightUpdate] a inner join CustomerSession b on a.CustomerSessionID = b.ID
  WHERE datepart(year, [LocalTime]) = 2026 and datepart(month, [LocalTime]) = 2 and datepart(day, [LocalTime]) in (26, 27, 28)
  and b.[AbdStationID] in
  (
    SELECT ID
    FROM [BagDropDB_NRT].[dbo].[AbdStation]
    WHERE [Terminal] ='3' and [Area] = 'N' and [SubArea] = 'C'
  )
  order by ID desc


  --select * from CustomerSession where AbdStationID in
  --(
  --  SELECT ID
  --  FROM [BagDropDB_NRT].[dbo].[AbdStation]
  --  WHERE [Terminal] ='3' and [Area] = 'N' and [SubArea] = 'C'
  --)
  --and datepart(year, LocalCreationTime) = 2026 and datepart(month, LocalCreationTime) = 3
  -------------------------

SELECT a.[ID]
      ,[BagID]
      ,[Weight]
      ,[UtcTime]
      ,[CustomerSessionID]       
      ,[LocalTime]
      ,b.AbdStationID
  FROM [BagDropDB_NRT].[dbo].[BagWeightUpdate] a inner join CustomerSession b on a.CustomerSessionID = b.ID
  WHERE datepart(year, [LocalTime]) = 2026 and datepart(month, [LocalTime]) = 3 and datepart(day, [LocalTime]) in (1)
  and b.[AbdStationID] in
  (
    SELECT ID
    FROM [BagDropDB_NRT].[dbo].[AbdStation]
    WHERE [Terminal] ='3' and [Area] = 'N' and [SubArea] = 'C'
  )
  order by ID desc