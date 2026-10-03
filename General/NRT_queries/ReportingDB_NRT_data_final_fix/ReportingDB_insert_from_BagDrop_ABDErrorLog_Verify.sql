
  select TOP (10) *
  FROM [BagDropDB_NRT].[dbo].[ABDErrorLog]
  order by ID desc  



  SELECT TOP (10) *
  FROM [ReportingDB_NRT].[dbo].[ABDErrorLog]
  order by ID desc

  select (select Max(ID) FROM [BagDropDB_NRT].[dbo].[ABDErrorLog]) - (select Max(ID) FROM [ReportingDB_NRT].[dbo].[ABDErrorLog]) as NumberOfRecordsNeedToInsert



