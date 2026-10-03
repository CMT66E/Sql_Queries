
select top (5) * 
FROM [BagDropDB_NRT].[dbo].[HeavyTagPrintLog]
order by ID desc

--------------------

select top (5) * 
FROM [ReportingDB_NRT].[dbo].[HeavyTagPrintLog]
order by ID desc
