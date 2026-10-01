--Terminal 1 and T1 cases
SELECT [ID]
      ,[PortCode]
      ,[Identifier]
      ,[AbdType]
      ,[Terminal]
      ,[KioskName]
      ,[Zone]
      ,[Area]
      ,[SubArea]
  FROM [CUSSBagDropDB_PER].[dbo].[AbdStation]
  where  Terminal <> 'PER1' and Terminal = '1' order by cast([Identifier] as int)

  SELECT [ID]
      ,[PortCode]
      ,[Identifier]
      ,[AbdType]
      ,[Terminal]
      ,[KioskName]
      ,[Zone]
      ,[Area]
      ,[SubArea]
  FROM [CUSSBagDropDB_PER].[dbo].[AbdStation]
  where  Terminal <> 'PER1' and Terminal = 'T1' order by cast([Identifier] as int)


  select [ID]   FROM [CUSSBagDropDB_PER].[dbo].[AbdStation]
  where  Terminal <> 'PER1' and Terminal = '1'

select * from AbdModeHistory where AbdStationID in (select [ID]   FROM [CUSSBagDropDB_PER].[dbo].[AbdStation]
  where  Terminal <> 'PER1' and Terminal = '1')

select * from AbdStateHistory where AbdStationID in (select [ID]   FROM [CUSSBagDropDB_PER].[dbo].[AbdStation]
  where  Terminal <> 'PER1' and Terminal = '1')

select * from AbdWayfinderStateHistory where AbdStationID in (select [ID]   FROM [CUSSBagDropDB_PER].[dbo].[AbdStation]
  where  Terminal <> 'PER1' and Terminal = '1')

select * from CussSession where AbdStationID in (select [ID]   FROM [CUSSBagDropDB_PER].[dbo].[AbdStation]
  where  Terminal <> 'PER1' and Terminal = '1')

select * from CustomerSession where ApplicationSessionId in (select ApplicationSessionId from ApplicationSession where CussSessionId in (select CussSessionId from CussSession where AbdStationID in (select [ID]   FROM [CUSSBagDropDB_PER].[dbo].[AbdStation]
  where  Terminal <> 'PER1' and Terminal = '1') ))

select * from ApplicationSession where CussSessionId in (select CussSessionId from CussSession where AbdStationID in (select [ID]   FROM [CUSSBagDropDB_PER].[dbo].[AbdStation]
  where  Terminal <> 'PER1' and Terminal = '1'))
  ---------------------------------------------------------------------

    select [ID]   FROM [CUSSBagDropDB_PER].[dbo].[AbdStation]
  where  Terminal <> 'PER1' and Terminal = 'T1' order by cast([Identifier] as int)