SELECT TOP (10) *
  FROM [BagDropDB_NRT].[dbo].[Flight]
  order by ID desc


SELECT TOP (10) *
  FROM [ReportingDB_NRT].[dbo].[Flight]
  order by ID desc


select ((select Max(ID) FROM [BagDropDB_NRT].[dbo].[Flight]) - (select Max(ID) FROM [ReportingDB_NRT].[dbo].[Flight])) as NumberOfRecordsNeedToInsert