insert into [ReportingDB_NRT].[dbo].[PaperTagReadSuccessData]
select * FROM [BagDropDB_NRT].[dbo].[PaperTagReadSuccessData] 
where ID > (SELECT Max(ID) 
  FROM [ReportingDB_NRT].[dbo].[PaperTagReadSuccessData])