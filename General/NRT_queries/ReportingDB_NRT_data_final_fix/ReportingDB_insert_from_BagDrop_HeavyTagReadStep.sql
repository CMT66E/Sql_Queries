insert into [ReportingDB_NRT].[dbo].[HeavyTagReadStep](ID, Summary, [Description], UtcCreateTime, LocalCreateTime, ColorR, ColorB, ColorG, GridColumnWidth, Heading)
select ID, Summary, [Description], UtcCreateTime, LocalCreateTime, '' as ColorR, 0 as ColorB, '' as ColorG, 0 as GridColumnWidth, '' as Heading FROM [BagDropDB_NRT].[dbo].[HeavyTagReadStep] 
where ID > (SELECT Max(ID) as temp
  FROM [ReportingDB_NRT].[dbo].[HeavyTagReadStep])