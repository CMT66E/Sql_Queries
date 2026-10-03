insert into [ReportingDB_NRT].[dbo].[PaperTagReadLog]
select * FROM [BagDropDB_NRT].[dbo].[PaperTagReadLog] 
where ID > (SELECT Max(ID) as temp
  FROM [ReportingDB_NRT].[dbo].[PaperTagReadLog])
