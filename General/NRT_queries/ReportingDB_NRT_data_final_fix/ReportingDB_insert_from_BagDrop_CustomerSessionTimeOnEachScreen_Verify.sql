  SELECT TOP (10) * FROM [BagDropDB_NRT].[dbo].[CustomerSessionTimeOnEachScreen]  a inner join CustomerSession b on a.CustomerSessionID = b.ID order by a.ID desc
  SELECT TOP (10) * FROM [ReportingDB_NRT].[dbo].[CustomerSessionTimeOnEachScreen]  a inner join CustomerSession b on a.CustomerSessionID = b.ID order by a.ID desc
  
   select (select count([ID]) FROM [BagDropDB_NRT].[dbo].[CustomerSessionTimeOnEachScreen]) - (SELECT count([ID]) as ReportingDB_ABDs FROM [ReportingDB_NRT].[dbo].[CustomerSessionTimeOnEachScreen]) as RowsNeedToInsert
