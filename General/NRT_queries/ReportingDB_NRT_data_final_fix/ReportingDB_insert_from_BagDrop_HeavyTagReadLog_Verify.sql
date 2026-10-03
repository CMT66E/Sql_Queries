 --these two ok
SELECT TOP (10) *
  FROM [BagDropDB_NRT].[dbo].[HeavyTagReadLog]
  order by ID desc
  

SELECT TOP (10) *
  FROM [ReportingDB_NRT].[dbo].[HeavyTagReadLog]
  order by ID desc


select ((select Max(ID) FROM [BagDropDB_NRT].[dbo].[HeavyTagReadLog]) - (select Max(ID) FROM [ReportingDB_NRT].[dbo].[HeavyTagReadLog])) as NumberOfRecordsNeedToInsert