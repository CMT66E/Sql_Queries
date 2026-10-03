
select count([ID]) as BagDrop_ABDs 
FROM [BagDropDB_NRT].[dbo].[Bag]
 
select TOP (10) *
FROM [BagDropDB_NRT].[dbo].[Bag]
order by ID desc  


----------------------------------------------


SELECT count([ID]) as ReportingDB_ABDs      
FROM [ReportingDB_NRT].[dbo].[Bag]


SELECT TOP (10) *
FROM [ReportingDB_NRT].[dbo].[Bag]
order by ID desc
----------------------------------------------

 select ((select Max(ID) FROM [BagDropDB_NRT].[dbo].[Bag]) - (select Max(ID) FROM [ReportingDB_NRT].[dbo].[Bag])) as NumberOfRecordsNeedToInsert