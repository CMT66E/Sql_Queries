--This script will list all those partial data rows to be deleted on databases: CUSSBagDropDB, BagDrop, ReportingDB on table CustomerSession
--on dates: 2022-03-24 and 2022-03-28. Because on these two dates only partial data has been recorded so we need remove them for doing whole day's data recovery
--Eric He 08-04-2022 

declare @DeleteCustomerSessionDay1 datetime = '2022-03-24' 
select * from [CUSSBagDropDB].[dbo].[CustomerSession] 
where datepart(year, LocalCreationTime) = datepart(year, @DeleteCustomerSessionDay1) 
	and datepart(month, LocalCreationTime) = datepart(month, @DeleteCustomerSessionDay1) 
	and datepart(day, LocalCreationTime) = datepart(day, @DeleteCustomerSessionDay1) 

select * from [BagDrop].[dbo].[CustomerSession] 
where datepart(year, LocalCreationTime) = datepart(year, @DeleteCustomerSessionDay1) 
	and datepart(month, LocalCreationTime) = datepart(month, @DeleteCustomerSessionDay1) 
	and datepart(day, LocalCreationTime) = datepart(day, @DeleteCustomerSessionDay1)  

select * from [ReportingDB].[dbo].[CustomerSession] 
where datepart(year, LocalTime) = datepart(year, @DeleteCustomerSessionDay1) 
	and datepart(month, LocalTime) = datepart(month, @DeleteCustomerSessionDay1) 
	and datepart(day, LocalTime) = datepart(day, @DeleteCustomerSessionDay1)  
---------------------------------------------------------------------------------------
declare @DeleteCustomerSessionDay2 datetime = '2022-03-28' 
select * from [CUSSBagDropDB].[dbo].[CustomerSession] 
where datepart(year, LocalCreationTime) = datepart(year, @DeleteCustomerSessionDay2) 
	and datepart(month, LocalCreationTime) = datepart(month, @DeleteCustomerSessionDay2) 
	and datepart(day, LocalCreationTime) = datepart(day, @DeleteCustomerSessionDay2) 

select * from [BagDrop].[dbo].[CustomerSession] 
where datepart(year, LocalCreationTime) = datepart(year, @DeleteCustomerSessionDay2) 
	and datepart(month, LocalCreationTime) = datepart(month, @DeleteCustomerSessionDay2) 
	and datepart(day, LocalCreationTime) = datepart(day, @DeleteCustomerSessionDay2)  

select * from [ReportingDB].[dbo].[CustomerSession] 
where datepart(year, LocalTime) = datepart(year, @DeleteCustomerSessionDay2) 
	and datepart(month, LocalTime) = datepart(month, @DeleteCustomerSessionDay2) 
	and datepart(day, LocalTime) = datepart(day, @DeleteCustomerSessionDay2)  