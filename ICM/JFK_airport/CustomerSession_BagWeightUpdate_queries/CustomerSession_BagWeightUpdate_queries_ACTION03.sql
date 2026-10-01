select * from [CUSSBagDropDB_JFK].[dbo].[BagWeightUpdate]
WHERE DatePart(year, [LocalTime]) = 2021 and DatePart(month, [LocalTime]) = 6 and DatePart(day, [LocalTime]) = 20
order by ID

select * from [CUSSReportingDB_JFK_PURE].[dbo].[BagWeightUpdate]
WHERE DatePart(year, [LocalTime]) = 2021 and DatePart(month, [LocalTime]) = 6 and DatePart(day, [LocalTime]) = 20
order by ID

select * from [CUSSReportingDB_JFK].[dbo].[BagWeightUpdate]
WHERE DatePart(year, [LocalTime]) = 2021 and DatePart(month, [LocalTime]) = 6 and DatePart(day, [LocalTime]) = 20
order by ID

--delete from [CUSSReportingDB_JFK].[dbo].[BagWeightUpdate] where ID > 0  --total 2658
--delete from [CUSSReportingDB_JFK].[dbo].[CustomerSession] where ID > 0    --total 3474

--select * from [CUSSBagDropDB_JFK].[dbo].[BagWeightUpdate] 
select count(ID) from [CUSSBagDropDB_JFK].[dbo].[BagWeightUpdate]  
select count(ID) from [CUSSReportingDB_JFK_PURE].[dbo].[BagWeightUpdate]
select count(ID) from [CUSSReportingDB_JFK].[dbo].[BagWeightUpdate]  

select count(ID) from [CUSSBagDropDB_JFK].[dbo].[CustomerSession]   
select count(ID) from [CUSSReportingDB_JFK_PURE].[dbo].[CustomerSession] 
select count(ID) from [CUSSReportingDB_JFK].[dbo].[CustomerSession] 
---------------------------------------------------------------------------

select max(ID) from [CUSSBagDropDB_JFK].[dbo].[BagWeightUpdate]  
select max(ID) from [CUSSReportingDB_JFK].[dbo].[BagWeightUpdate]  
select max(ID) from [CUSSReportingDB_JFK_PURE].[dbo].[BagWeightUpdate]

select max(ID) from [CUSSBagDropDB_JFK].[dbo].[CustomerSession]  
select max(ID) from [CUSSReportingDB_JFK].[dbo].[CustomerSession]  
select max(ID) from [CUSSReportingDB_JFK_PURE].[dbo].[CustomerSession]  
---------------------------------------------------------------------------------------------------

select * from [CUSSBagDropDB_JFK].[dbo].[BagWeightUpdate]
WHERE DatePart(year, [UtcTime]) = 2021 and DatePart(month, [UtcTime]) = 6 and DatePart(day, [UtcTime]) = 20
order by ID

select * from [CUSSReportingDB_JFK].[dbo].[BagWeightUpdate]  
WHERE DatePart(year, [UtcTime]) = 2021 and DatePart(month, [UtcTime]) = 6 and DatePart(day, [UtcTime]) = 20
order by ID
---------------------------------------------------------------------------------------------------
select * from [CUSSReportingDB_JFK].[dbo].[BagWeightUpdate]  
WHERE BagID in
(
select BagID from [CUSSBagDropDB_JFK].[dbo].[BagWeightUpdate]
WHERE DatePart(year, [LocalTime]) = 2021 and DatePart(month, [LocalTime]) = 6 and DatePart(day, [LocalTime]) = 20
 
)