

  ---need to do
  SELECT TOP (10) *
  FROM [BagDropDB_NRT].[dbo].[HeavyTagReadSuccessData]
  order by ID desc

SELECT TOP (10) *
  FROM [ReportingDB_NRT].[dbo].[HeavyTagReadSuccessData]
  order by ID desc


select ((select Max(ID) FROM [BagDropDB_NRT].[dbo].[HeavyTagReadSuccessData]) - (select Max(ID) FROM [ReportingDB_NRT].[dbo].[HeavyTagReadSuccessData])) as NumberOfRecordsNeedToInsert