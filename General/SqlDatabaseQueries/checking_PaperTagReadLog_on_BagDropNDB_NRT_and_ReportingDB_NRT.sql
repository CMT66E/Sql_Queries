select top (5) * 
FROM [BagDropDB_NRT].[dbo].[PaperTagReadLog]
order by ID desc



select top (5) * 
FROM [ReportingDB_NRT].[dbo].[PaperTagReadLog]
order by ID desc

--------------------
select top (5) * 
FROM [BagDropDB_NRT].[dbo].[HeavyTagInjectionLog]
order by ID desc

 

select top (5) * 
FROM [ReportingDB_NRT].[dbo].[HeavyTagInjectionLog]
order by ID desc
--------------------

select top (5) * 
FROM [BagDropDB_NRT].[dbo].[PaperTagReadSuccessData]
order by ID desc



select top (5) * 
FROM [ReportingDB_NRT].[dbo].[PaperTagReadSuccessData]
order by ID desc