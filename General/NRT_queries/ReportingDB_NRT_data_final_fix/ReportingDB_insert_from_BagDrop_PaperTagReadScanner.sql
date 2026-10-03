insert into [ReportingDB_NRT].[dbo].[PaperTagReadScanner]
select * FROM [BagDropDB_NRT].[dbo].[PaperTagReadScanner] 
where ID > (SELECT Max(ID) as temp
  FROM [ReportingDB_NRT].[dbo].[PaperTagReadScanner])