select top (5) * 
FROM [BagDropDB_NRT].[dbo].[CustomerSession]
order by ID desc


select top (5) * 
FROM [BagDropDB_NRT].[dbo].[BagWeightUpdate]
order by ID desc

select top (5) * 
FROM [BagDropDB_NRT].[dbo].[Bag]
order by ID desc


--------------------

select top (5) * 
FROM [ReportingDB_NRT].[dbo].[CustomerSession]
order by ID desc


select top (5) * 
FROM [ReportingDB_NRT].[dbo].[BagWeightUpdate]
order by ID desc

select top (5) * 
FROM [ReportingDB_NRT].[dbo].[Bag]
order by ID desc

