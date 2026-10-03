  ---need to do
  SELECT TOP (10) *
  FROM [BagDropDB_NRT].[dbo].[HeavyTagReadAntenna]
  order by ID desc

SELECT TOP (10) *
  FROM [ReportingDB_NRT].[dbo].[HeavyTagReadAntenna]
  order by ID desc


select ((select Max(ID) FROM [BagDropDB_NRT].[dbo].[HeavyTagReadAntenna]) - (select Max(ID) FROM [ReportingDB_NRT].[dbo].[HeavyTagReadAntenna])) as NumberOfRecordsNeedToInsert