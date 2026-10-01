-- declare @UpdateMonthFirstDay datetime = '2022-03-24' 

-- SELECT  * FROM [BagDrop].[dbo].[CustomerSession] where 
--     datepart(year, LocalCreationTime) = datepart(year, @UpdateMonthFirstDay) 
--	and datepart(month, LocalCreationTime) = datepart(month, @UpdateMonthFirstDay) 
--	and datepart(day, LocalCreationTime) = datepart(day, @UpdateMonthFirstDay)

--select * from [BagDrop].[dbo].[PaperBoardPassLookup]
--where CustomerSessionID in
--(
--    SELECT ID FROM [BagDrop].[dbo].[CustomerSession] where 
--     datepart(year, LocalCreationTime) = datepart(year, @UpdateMonthFirstDay) 
--	and datepart(month, LocalCreationTime) = datepart(month, @UpdateMonthFirstDay) 
--	and datepart(day, LocalCreationTime) = datepart(day, @UpdateMonthFirstDay)  
--)

--select * from [BagDrop].[dbo].[CustomerSessionTimeOnEachScreen]
--where CustomerSessionID in
--(
--    SELECT ID FROM [BagDrop].[dbo].[CustomerSession] where 
--     datepart(year, LocalCreationTime) = datepart(year, @UpdateMonthFirstDay) 
--	and datepart(month, LocalCreationTime) = datepart(month, @UpdateMonthFirstDay) 
--	and datepart(day, LocalCreationTime) = datepart(day, @UpdateMonthFirstDay)  
--)

--select * from [BagDrop].[dbo].[BagWeightUpdate]
--where CustomerSessionID in
--(
--    SELECT ID FROM [BagDrop].[dbo].[CustomerSession] where 
--     datepart(year, LocalCreationTime) = datepart(year, @UpdateMonthFirstDay) 
--	and datepart(month, LocalCreationTime) = datepart(month, @UpdateMonthFirstDay) 
--	and datepart(day, LocalCreationTime) = datepart(day, @UpdateMonthFirstDay)  
--)

--------------------------------------------------------------------------------------------------------------------------------------
declare @UpdateMonthDayToDelete datetime = '2022-03-24' 

delete from [BagDrop].[dbo].[BagWeightUpdate]
where CustomerSessionID in
(
    SELECT ID FROM [BagDrop].[dbo].[CustomerSession] where 
     datepart(year, LocalCreationTime) = datepart(year, @UpdateMonthDayToDelete) 
	and datepart(month, LocalCreationTime) = datepart(month, @UpdateMonthDayToDelete) 
	and datepart(day, LocalCreationTime) = datepart(day, @UpdateMonthDayToDelete)  
)

delete from [BagDrop].[dbo].[CustomerSessionTimeOnEachScreen]
where CustomerSessionID in
(
    SELECT ID FROM [BagDrop].[dbo].[CustomerSession] where 
     datepart(year, LocalCreationTime) = datepart(year, @UpdateMonthDayToDelete) 
	and datepart(month, LocalCreationTime) = datepart(month, @UpdateMonthDayToDelete) 
	and datepart(day, LocalCreationTime) = datepart(day, @UpdateMonthDayToDelete)  
)

delete from [BagDrop].[dbo].[PaperBoardPassLookup]
where CustomerSessionID in
(
    SELECT ID FROM [BagDrop].[dbo].[CustomerSession] where 
     datepart(year, LocalCreationTime) = datepart(year, @UpdateMonthDayToDelete) 
	and datepart(month, LocalCreationTime) = datepart(month, @UpdateMonthDayToDelete) 
	and datepart(day, LocalCreationTime) = datepart(day, @UpdateMonthDayToDelete)  
)

delete from [BagDrop].[dbo].[CustomerSession] where 
     datepart(year, LocalCreationTime) = datepart(year, @UpdateMonthDayToDelete) 
	and datepart(month, LocalCreationTime) = datepart(month, @UpdateMonthDayToDelete) 
	and datepart(day, LocalCreationTime) = datepart(day, @UpdateMonthDayToDelete)
	--------------------------------------------------------------------------------------------------------------------------------------
declare @DateToDeleteOnReportingDB datetime = '2022-03-24' 

delete from [ReportingDB].[dbo].[CustomerSessionTimeOnEachScreen]
where CustomerSessionID in
(
    SELECT ID FROM [ReportingDB].[dbo].[CustomerSession] where 
     datepart(year, LocalTime) = datepart(year, @DateToDeleteOnReportingDB) 
	and datepart(month, LocalTime) = datepart(month, @DateToDeleteOnReportingDB) 
	and datepart(day, LocalTime) = datepart(day, @DateToDeleteOnReportingDB)  
)

delete from [ReportingDB].[dbo].[CustomerSession] where 
     datepart(year, LocalTime) = datepart(year, @DateToDeleteOnReportingDB) 
	and datepart(month, LocalTime) = datepart(month, @DateToDeleteOnReportingDB) 
	and datepart(day, LocalTime) = datepart(day, @DateToDeleteOnReportingDB)

	
delete   FROM [ReportingDB].[dbo].[BagWeightUpdate]
WHERE      datepart(year, [LocalTime]) = datepart(year, @DateToDeleteOnReportingDB) 
and datepart(month, [LocalTime]) = datepart(month, @DateToDeleteOnReportingDB) 
and datepart(day, [LocalTime]) = datepart(day, @DateToDeleteOnReportingDB) 

