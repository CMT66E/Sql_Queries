insert into [ReportingDB_NRT].[dbo].[QBagTagReadLog]
select * FROM [BagDropDB_NRT].[dbo].[QBagTagReadLog] 
where ID > (SELECT Max(ID) 
  FROM [ReportingDB_NRT].[dbo].[QBagTagReadLog])