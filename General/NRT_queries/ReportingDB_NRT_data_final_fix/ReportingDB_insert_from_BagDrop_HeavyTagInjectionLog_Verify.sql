
SELECT TOP (10) *
  FROM [BagDropDB_NRT].[dbo].[HeavyTagInjectionLog]
  order by ID desc


SELECT TOP (10) *
  FROM [ReportingDB_NRT].[dbo].[HeavyTagInjectionLog]
  order by ID desc

select ((select Max(ID) FROM [BagDropDB_NRT].[dbo].[HeavyTagInjectionLog]) - (select Max(ID) FROM [ReportingDB_NRT].[dbo].[HeavyTagInjectionLog])) as NumberOfRecordsNeedToInsert