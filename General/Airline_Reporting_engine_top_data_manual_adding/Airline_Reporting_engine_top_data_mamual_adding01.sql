

--insert into [ReportingDB_SIN].[dbo].[HeavyTagReadLog]
select * FROM [BagDropDB_SIN].[dbo].[HeavyTagReadLog] 
where ID > (SELECT Max(ID) as temp
  FROM [ReportingDB_SIN].[dbo].[HeavyTagReadLog])


--insert into [ReportingDB_SIN].[dbo].[HeavyTagReadAntenna]
select * FROM [BagDropDB_SIN].[dbo].[HeavyTagReadAntenna] 
where ID > (SELECT Max(ID) as temp
  FROM [ReportingDB_SIN].[dbo].[HeavyTagReadAntenna])



--insert into [ReportingDB_SIN].[dbo].[PaperTagReadSuccessData]
select * FROM [BagDropDB_SIN].[dbo].[PaperTagReadSuccessData] 
where ID > (SELECT Max(ID) 
  FROM [ReportingDB_SIN].[dbo].[PaperTagReadSuccessData])



  select ((select Max(ID) FROM [BagDropDB_SIN].[dbo].[PaperTagReadSuccessData]) - (select Max(ID) FROM [ReportingDB_SIN_APR2026].[dbo].[PaperTagReadSuccessData])) as NumberOfRecordsNeedToInsert