

  select * from [BagDropDB_NRT].[dbo].[CustomerSessionTimeOnEachScreen] --5,518,564 records need to be inserted into [ReportingDB_NRT].[dbo].[CustomerSessionTimeOnEachScreen]
  where ID > 66293651

  insert into [ReportingDB_NRT].[dbo].[CustomerSessionTimeOnEachScreen]
  select * from [BagDropDB_NRT].[dbo].[CustomerSessionTimeOnEachScreen]
  where ID > 66293651