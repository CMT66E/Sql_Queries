--This script will list all those partial data rows to be deleted on databases: CUSSBagDropDB, BagDrop, ReportingDB on table BagWeightUpdate
--on dates: 2022-03-24 and 2022-03-28. Because on these two dates only partial data has been recorded so we need remove them for doing whole day's data recovery
--Eric He 08-04-2022 
declare @DeleteBagWeightUpdateDay1 datetime = '2022-03-24' 
select * from [CUSSBagDropDB_SIN].[dbo].[BagWeightUpdate] 
where datepart(year, LocalTime) = datepart(year, @DeleteBagWeightUpdateDay1) 
	and datepart(month, LocalTime) = datepart(month, @DeleteBagWeightUpdateDay1) 
	and datepart(day, LocalTime) = datepart(day, @DeleteBagWeightUpdateDay1) 

select * from [BagDrop_SIN_ACTION].[dbo].[BagWeightUpdate] 
where datepart(year, LocalTime) = datepart(year, @DeleteBagWeightUpdateDay1) 
	and datepart(month, LocalTime) = datepart(month, @DeleteBagWeightUpdateDay1) 
	and datepart(day, LocalTime) = datepart(day, @DeleteBagWeightUpdateDay1)  

select * from [ReportingDB_SIN].[dbo].[BagWeightUpdate] 
where datepart(year, LocalTime) = datepart(year, @DeleteBagWeightUpdateDay1) 
	and datepart(month, LocalTime) = datepart(month, @DeleteBagWeightUpdateDay1) 
	and datepart(day, LocalTime) = datepart(day, @DeleteBagWeightUpdateDay1)  
-----------------------------------------------------------------------------------
declare @DeleteBagWeightUpdateDay2 datetime = '2022-03-28'
select * from [CUSSBagDropDB_SIN].[dbo].[BagWeightUpdate] 
where datepart(year, LocalTime) = datepart(year, @DeleteBagWeightUpdateDay2) 
	and datepart(month, LocalTime) = datepart(month, @DeleteBagWeightUpdateDay2) 
	and datepart(day, LocalTime) = datepart(day, @DeleteBagWeightUpdateDay2) 

select * from [BagDrop_SIN_ACTION].[dbo].[BagWeightUpdate] 
where datepart(year, LocalTime) = datepart(year, @DeleteBagWeightUpdateDay2) 
	and datepart(month, LocalTime) = datepart(month, @DeleteBagWeightUpdateDay2) 
	and datepart(day, LocalTime) = datepart(day, @DeleteBagWeightUpdateDay2)  

select * from [ReportingDB_SIN].[dbo].[BagWeightUpdate] 
where datepart(year, LocalTime) = datepart(year, @DeleteBagWeightUpdateDay2) 
	and datepart(month, LocalTime) = datepart(month, @DeleteBagWeightUpdateDay2) 
	and datepart(day, LocalTime) = datepart(day, @DeleteBagWeightUpdateDay2)  