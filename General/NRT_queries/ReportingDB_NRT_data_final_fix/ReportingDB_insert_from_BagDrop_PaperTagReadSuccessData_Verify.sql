SELECT TOP (10) *
  FROM [BagDropDB_NRT].[dbo].[PaperTagReadSuccessData]
  order by ID desc

SELECT TOP (10) *
  FROM [ReportingDB_NRT].[dbo].[PaperTagReadSuccessData]
  order by ID desc


select ((select Max(ID) FROM [BagDropDB_NRT].[dbo].[PaperTagReadSuccessData]) - (select Max(ID) FROM [ReportingDB_NRT].[dbo].[PaperTagReadSuccessData])) as NumberOfRecordsNeedToInsert