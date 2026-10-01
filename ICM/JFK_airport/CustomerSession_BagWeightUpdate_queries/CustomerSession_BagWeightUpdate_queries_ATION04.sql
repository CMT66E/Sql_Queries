/****** Script for SelectTopNRows command from SSMS  ******/
--delete FROM [CUSSReportingDB_JFK].[dbo].[CustomerSession] where ID > 0 --2477
--delete FROM [CUSSReportingDB_JFK].[dbo].BagWeightUpdate where ID > 0   --1908

select count(*) from [CUSSReportingDB_JFK].[dbo].[CustomerSession] where ID > 0 --3474
select count(*) from [CUSSReportingDB_JFK].[dbo].BagWeightUpdate where ID > 0   --2658

select * from [CUSSBagDropDB_JFK].[dbo].[BagWeightUpdate]
WHERE DatePart(year, [LocalTime]) = 2021 and DatePart(month, [LocalTime]) = 6 and DatePart(day, [LocalTime]) = 9
order by ID



select * from [CUSSReportingDB_JFK].[dbo].[BagWeightUpdate]
WHERE DatePart(year, [LocalTime]) = 2021 and DatePart(month, [LocalTime]) = 6 and DatePart(day, [LocalTime]) = 9
--and AbdStationID <> 11 --123 records
order by ID