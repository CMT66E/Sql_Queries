  select TOP (10) *
  FROM [BagDropDB_NRT].[dbo].[CMOperationHistory]
  order by ID desc  



  SELECT TOP (10) *
  FROM [ReportingDB_NRT].[dbo].[CMOperationHistory]
  order by ID desc



  select (select count([ID]) FROM [BagDropDB_NRT].[dbo].[CMOperationHistory]) - (SELECT count([ID]) as ReportingDB_ABDs FROM [ReportingDB_NRT].[dbo].[CMOperationHistory]) as RowsNeedToInsert