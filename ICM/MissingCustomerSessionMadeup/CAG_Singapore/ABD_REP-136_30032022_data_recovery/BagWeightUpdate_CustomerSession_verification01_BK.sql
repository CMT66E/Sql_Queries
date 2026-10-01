 


declare @UpdateMonthFirstDay datetime = '2022-03-24' 
--Total BagWeightUpdate records on 2022-03-24 is 2710
select * from [CUSSBagDropDB_SIN].[dbo].[BagWeightUpdate] 
where datepart(year, LocalTime) = datepart(year, @UpdateMonthFirstDay) 
	and datepart(month, LocalTime) = datepart(month, @UpdateMonthFirstDay) 
	and datepart(day, LocalTime) = datepart(day, @UpdateMonthFirstDay)  

----------------------------------------------------------------------------------
--Total BagWeightUpdate CustomerSessionID records on 2022-03-24 is 1691
select distinct CustomerSessionID from [CUSSBagDropDB_SIN].[dbo].[BagWeightUpdate] 
where datepart(year, LocalTime) = datepart(year, @UpdateMonthFirstDay) 
	and datepart(month, LocalTime) = datepart(month, @UpdateMonthFirstDay) 
	and datepart(day, LocalTime) = datepart(day, @UpdateMonthFirstDay) 

----------------------------------------------------------------------------------
    --total 2392 records
	select *
	from  [CUSSBagDropDB_SIN].[dbo].CustomerSession b INNER JOIN
		  [CUSSBagDropDB_SIN].[dbo].BagWeightUpdate a  ON b.ID = a.CustomerSessionID INNER JOIN
		  [CUSSBagDropDB_SIN].[dbo].Flight c ON b.FlightID = c.ID INNER JOIN 
		  [CUSSBagDropDB_SIN].[dbo].Bag d ON a.BagID = d.ID 
    where  
    datepart(year, b.LocalCreationTime) = datepart(year, @UpdateMonthFirstDay) 
	and datepart(month, b.LocalCreationTime) = datepart(month, @UpdateMonthFirstDay) 
	and datepart(day, b.LocalCreationTime) = datepart(day, @UpdateMonthFirstDay)
    and a.Weight > 0

	select distinct a.CustomerSessionID 
	from  [CUSSBagDropDB_SIN].[dbo].CustomerSession b INNER JOIN
		  [CUSSBagDropDB_SIN].[dbo].BagWeightUpdate a  ON b.ID = a.CustomerSessionID INNER JOIN
		  [CUSSBagDropDB_SIN].[dbo].Flight c ON b.FlightID = c.ID INNER JOIN 
		  [CUSSBagDropDB_SIN].[dbo].Bag d ON a.BagID = d.ID 
    where  
    datepart(year, b.LocalCreationTime) = datepart(year, @UpdateMonthFirstDay) 
	and datepart(month, b.LocalCreationTime) = datepart(month, @UpdateMonthFirstDay) 
	and datepart(day, b.LocalCreationTime) = datepart(day, @UpdateMonthFirstDay)
    and a.Weight > 0