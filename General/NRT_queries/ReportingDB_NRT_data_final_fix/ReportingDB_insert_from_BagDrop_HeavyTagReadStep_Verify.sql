  SELECT TOP (10) *
  FROM [BagDropDB_NRT].[dbo].[HeavyTagReadStep]
  order by ID desc

SELECT TOP (10) *
  FROM [ReportingDB_NRT].[dbo].[HeavyTagReadStep]
  order by ID desc


select ((select Max(ID) FROM [BagDropDB_NRT].[dbo].[HeavyTagReadStep]) - (select Max(ID) FROM [ReportingDB_NRT].[dbo].[HeavyTagReadStep])) as NumberOfRecordsNeedToInsert