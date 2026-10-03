

insert into [ReportingDB_NRT].[dbo].[HeavyTagReadAntenna]
select * FROM [BagDropDB_NRT].[dbo].[HeavyTagReadAntenna] 
where ID > (SELECT Max(ID) as temp
  FROM [ReportingDB_NRT].[dbo].[HeavyTagReadAntenna])