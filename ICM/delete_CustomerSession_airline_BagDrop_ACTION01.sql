 declare @UpdateMonthFirstDay datetime = '2022-03-24' 

 SELECT  * FROM [BagDrop_SIN_ACTION].[dbo].[CustomerSession] where 
     datepart(year, LocalCreationTime) = datepart(year, @UpdateMonthFirstDay) 
	and datepart(month, LocalCreationTime) = datepart(month, @UpdateMonthFirstDay) 
	and datepart(day, LocalCreationTime) = datepart(day, @UpdateMonthFirstDay)

select * from [BagDrop_SIN_ACTION].[dbo].[PaperBoardPassLookup]
where CustomerSessionID in
(
    SELECT ID FROM [BagDrop_SIN_ACTION].[dbo].[CustomerSession] where 
     datepart(year, LocalCreationTime) = datepart(year, @UpdateMonthFirstDay) 
	and datepart(month, LocalCreationTime) = datepart(month, @UpdateMonthFirstDay) 
	and datepart(day, LocalCreationTime) = datepart(day, @UpdateMonthFirstDay)  
)

select * from [BagDrop_SIN_ACTION].[dbo].[CustomerSessionTimeOnEachScreen]
where CustomerSessionID in
(
    SELECT ID FROM [BagDrop_SIN_ACTION].[dbo].[CustomerSession] where 
     datepart(year, LocalCreationTime) = datepart(year, @UpdateMonthFirstDay) 
	and datepart(month, LocalCreationTime) = datepart(month, @UpdateMonthFirstDay) 
	and datepart(day, LocalCreationTime) = datepart(day, @UpdateMonthFirstDay)  
)

select * from [BagDrop_SIN_ACTION].[dbo].[BagWeightUpdate]
where CustomerSessionID in
(
    SELECT ID FROM [BagDrop_SIN_ACTION].[dbo].[CustomerSession] where 
     datepart(year, LocalCreationTime) = datepart(year, @UpdateMonthFirstDay) 
	and datepart(month, LocalCreationTime) = datepart(month, @UpdateMonthFirstDay) 
	and datepart(day, LocalCreationTime) = datepart(day, @UpdateMonthFirstDay)  
)

--------------------------------------------------------------------------------------------------------------------------------------
--delete from [BagDrop_SIN_ACTION].[dbo].[BagWeightUpdate]
--where CustomerSessionID in
--(
--    SELECT ID FROM [BagDrop_SIN_ACTION].[dbo].[CustomerSession] where 
--     datepart(year, LocalCreationTime) = datepart(year, @UpdateMonthFirstDay) 
--	and datepart(month, LocalCreationTime) = datepart(month, @UpdateMonthFirstDay) 
--	and datepart(day, LocalCreationTime) = datepart(day, @UpdateMonthFirstDay)  
--)

--delete from [BagDrop_SIN_ACTION].[dbo].[CustomerSessionTimeOnEachScreen]
--where CustomerSessionID in
--(
--    SELECT ID FROM [BagDrop_SIN_ACTION].[dbo].[CustomerSession] where 
--     datepart(year, LocalCreationTime) = datepart(year, @UpdateMonthFirstDay) 
--	and datepart(month, LocalCreationTime) = datepart(month, @UpdateMonthFirstDay) 
--	and datepart(day, LocalCreationTime) = datepart(day, @UpdateMonthFirstDay)  
--)

--delete from [BagDrop_SIN_ACTION].[dbo].[PaperBoardPassLookup]
--where CustomerSessionID in
--(
--    SELECT ID FROM [BagDrop_SIN_ACTION].[dbo].[CustomerSession] where 
--     datepart(year, LocalCreationTime) = datepart(year, @UpdateMonthFirstDay) 
--	and datepart(month, LocalCreationTime) = datepart(month, @UpdateMonthFirstDay) 
--	and datepart(day, LocalCreationTime) = datepart(day, @UpdateMonthFirstDay)  
--)

--delete from [BagDrop_SIN_ACTION].[dbo].[CustomerSession] where 
--     datepart(year, LocalCreationTime) = datepart(year, @UpdateMonthFirstDay) 
--	and datepart(month, LocalCreationTime) = datepart(month, @UpdateMonthFirstDay) 
--	and datepart(day, LocalCreationTime) = datepart(day, @UpdateMonthFirstDay)