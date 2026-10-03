insert into [ReportingDB_NRT].[dbo].[HeavyTagReadLog]
select * FROM [BagDropDB_NRT].[dbo].[HeavyTagReadLog] 
where ID > (SELECT Max(ID) as temp
  FROM [ReportingDB_NRT].[dbo].[HeavyTagReadLog])