USE [BagDropDB_NRT] 
GO

insert into [ReportingDB_NRT].[dbo].[Bag]
select * FROM [BagDropDB_NRT].[dbo].[Bag]
where ID > (SELECT Max(ID) as temp
  FROM [ReportingDB_NRT].[dbo].[Bag])