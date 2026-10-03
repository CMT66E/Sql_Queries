insert into [ReportingDB_NRT].[dbo].[HeavyTagReadSuccessData]
select * FROM [BagDropDB_NRT].[dbo].[HeavyTagReadSuccessData] 
where ID > (SELECT Max(ID) 
  FROM [ReportingDB_NRT].[dbo].[HeavyTagReadSuccessData])