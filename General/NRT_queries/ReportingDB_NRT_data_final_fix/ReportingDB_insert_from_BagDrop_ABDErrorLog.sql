

insert into [ReportingDB_NRT].[dbo].[ABDErrorLog]
select * FROM [BagDropDB_NRT].[dbo].[ABDErrorLog] 
where ID > (SELECT Max(ID) 
  FROM [ReportingDB_NRT].[dbo].[ABDErrorLog])