SELECT TOP (10) *
  FROM [BagDropDB_NRT].[dbo].[PaperTagReadLog]
  order by ID desc


SELECT TOP (10) *
  FROM [ReportingDB_NRT].[dbo].[PaperTagReadLog]
  order by ID desc


select ((select Max(ID) FROM [BagDropDB_NRT].[dbo].[PaperTagReadLog]) - (select Max(ID) FROM [ReportingDB_NRT].[dbo].[PaperTagReadLog])) as NumberOfRecordsNeedToInsert