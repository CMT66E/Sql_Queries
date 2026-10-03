      SELECT  a.[CustomerSessionID], *              
      FROM [ReportingDB_NRT].[dbo].[BagWeightUpdate] a 
      inner join CustomerSession b on a.CustomerSessionID = b.ID
      inner join AbdStation c on b.AbdStationID = c.ID
      WHERE datepart(year, a.[LocalTime]) = 2026 and datepart(month, a.[LocalTime]) = 3 --and datepart(day, [LocalTime]) in (26, 27, 28)
      and b.[AbdStationID] in
      (
        SELECT ID
        FROM [ReportingDB_NRT].[dbo].[AbdStation]
        WHERE [Terminal] ='2' 
        --and [Area] = 'N' 
        and [SubArea] = 'M'
      )
      order by a.LocalTime  --15,374 --> 2,914

      --

      SELECT  a.[CustomerSessionID], *              
      FROM [ReportingDB_NRT].[dbo].[BagWeightUpdate] a 
      inner join CustomerSession b on a.CustomerSessionID = b.ID
      inner join AbdStation c on b.AbdStationID = c.ID
      WHERE datepart(year, a.[LocalTime]) = 2026 and datepart(month, a.[LocalTime]) = 3 --and datepart(day, [LocalTime]) in (26, 27, 28)
      and b.[AbdStationID] in
      (
        SELECT ID
        FROM [ReportingDB_NRT].[dbo].[AbdStation]
        WHERE [Terminal] ='3' 
        --and [Area] = 'N' 
        and [SubArea] = 'C'
      )
      order by a.LocalTime --1,702 --> 46

      --

      SELECT  a.[CustomerSessionID], *              
      FROM [ReportingDB_NRT].[dbo].[BagWeightUpdate] a 
      inner join CustomerSession b on a.CustomerSessionID = b.ID
      inner join AbdStation c on b.AbdStationID = c.ID
      WHERE datepart(year, a.[LocalTime]) = 2026 and datepart(month, a.[LocalTime]) = 3 --and datepart(day, [LocalTime]) in (26, 27, 28)
      and b.[AbdStationID] in
      (
        SELECT ID
        FROM [ReportingDB_NRT].[dbo].[AbdStation]
        WHERE [Terminal] ='1' 
        --and [Area] = 'N' 
        and [SubArea] = 'C'
      )
      order by a.LocalTime --37,537 --> 6,826