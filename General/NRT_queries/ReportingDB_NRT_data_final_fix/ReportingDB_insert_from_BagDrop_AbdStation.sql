USE [BagDropDB_NRT] 
GO

insert into [ReportingDB_NRT].[dbo].[AbdStation]
select * FROM [BagDropDB_NRT].[dbo].[AbdStation]
where ID > (SELECT Max(ID) as temp
  FROM [ReportingDB_NRT].[dbo].[AbdStation])