insert into [ReportingDB_NRT].[dbo].[HeavyTagInjectionLog]
select * FROM [BagDropDB_NRT].[dbo].[HeavyTagInjectionLog] 
where ID > (SELECT Max(ID) 
  FROM [ReportingDB_NRT].[dbo].[HeavyTagInjectionLog])