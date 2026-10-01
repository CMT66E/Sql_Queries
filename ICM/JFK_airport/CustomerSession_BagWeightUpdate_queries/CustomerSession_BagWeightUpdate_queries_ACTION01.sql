--delete FROM [CUSSReportingDB_JFK].[dbo].[CustomerSession] where ID > 0 --3357
--delete FROM [CUSSReportingDB_JFK].[dbo].BagWeightUpdate where ID > 0   --2614

select count(*) from CUSSBagDropDB_JFK.[dbo].[CustomerSession] where ID > 0 --4577
select count(*) from CUSSBagDropDB_JFK.[dbo].BagWeightUpdate where ID > 0   --3542

select count(*) from [CUSSReportingDB_JFK].[dbo].[CustomerSession] where ID > 0 --4577
select count(*) from [CUSSReportingDB_JFK].[dbo].BagWeightUpdate where ID > 0   --3542

