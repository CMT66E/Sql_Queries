 declare @UpdateMonthFirstDay datetime = '2022-03-28' 

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
declare @UpdateMonthDayToDelete datetime = '2022-03-28' 

delete from [BagDrop_SIN_ACTION].[dbo].[BagWeightUpdate]
where CustomerSessionID in
(
    SELECT ID FROM [BagDrop_SIN_ACTION].[dbo].[CustomerSession] where 
     datepart(year, LocalCreationTime) = datepart(year, @UpdateMonthDayToDelete) 
	and datepart(month, LocalCreationTime) = datepart(month, @UpdateMonthDayToDelete) 
	and datepart(day, LocalCreationTime) = datepart(day, @UpdateMonthDayToDelete)  
)

delete from [BagDrop_SIN_ACTION].[dbo].[CustomerSessionTimeOnEachScreen]
where CustomerSessionID in
(
    SELECT ID FROM [BagDrop_SIN_ACTION].[dbo].[CustomerSession] where 
     datepart(year, LocalCreationTime) = datepart(year, @UpdateMonthDayToDelete) 
	and datepart(month, LocalCreationTime) = datepart(month, @UpdateMonthDayToDelete) 
	and datepart(day, LocalCreationTime) = datepart(day, @UpdateMonthDayToDelete)  
)

delete from [BagDrop_SIN_ACTION].[dbo].[PaperBoardPassLookup]
where CustomerSessionID in
(
    SELECT ID FROM [BagDrop_SIN_ACTION].[dbo].[CustomerSession] where 
     datepart(year, LocalCreationTime) = datepart(year, @UpdateMonthDayToDelete) 
	and datepart(month, LocalCreationTime) = datepart(month, @UpdateMonthDayToDelete) 
	and datepart(day, LocalCreationTime) = datepart(day, @UpdateMonthDayToDelete)  
)

delete from [BagDrop_SIN_ACTION].[dbo].[CustomerSession] where 
     datepart(year, LocalCreationTime) = datepart(year, @UpdateMonthDayToDelete) 
	and datepart(month, LocalCreationTime) = datepart(month, @UpdateMonthDayToDelete) 
	and datepart(day, LocalCreationTime) = datepart(day, @UpdateMonthDayToDelete)
	--------------------------------------------------------------------------------------------------------------------------------------
declare @DateToDeleteOnReportingDB datetime = '2022-03-28' 

delete from [ReportingDB_SIN].[dbo].[CustomerSessionTimeOnEachScreen]
where CustomerSessionID in
(
    SELECT ID FROM [ReportingDB_SIN].[dbo].[CustomerSession] where 
     datepart(year, LocalTime) = datepart(year, @DateToDeleteOnReportingDB) 
	and datepart(month, LocalTime) = datepart(month, @DateToDeleteOnReportingDB) 
	and datepart(day, LocalTime) = datepart(day, @DateToDeleteOnReportingDB)  
)

delete from [ReportingDB_SIN].[dbo].[CustomerSession] where 
     datepart(year, LocalTime) = datepart(year, @DateToDeleteOnReportingDB) 
	and datepart(month, LocalTime) = datepart(month, @DateToDeleteOnReportingDB) 
	and datepart(day, LocalTime) = datepart(day, @DateToDeleteOnReportingDB)

	
delete   FROM [ReportingDB_SIN].[dbo].[BagWeightUpdate]
WHERE      datepart(year, [LocalTime]) = datepart(year, @DateToDeleteOnReportingDB) 
and datepart(month, [LocalTime]) = datepart(month, @DateToDeleteOnReportingDB) 
and datepart(day, [LocalTime]) = datepart(day, @DateToDeleteOnReportingDB) 

