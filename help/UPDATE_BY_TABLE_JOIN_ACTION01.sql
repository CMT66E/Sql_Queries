USE CUSSReportingDB_PER
GO

declare @ReportMonthFirstDay DateTime = '2022/08/01 00:00:00'

DECLARE @MyTableAUG TABLE
(
SNo int IDENTITY(1,1), 
CustomerSessionID int,
SessionDuration float
)  

insert into @MyTableAUG(CustomerSessionID, SessionDuration)
select 
a.ID as CustomerSessionID,
a.SessionDuration as SessionDuration
FROM [dbo].[CustomerSession] a 
LEFT OUTER JOIN Flight b on a.FlightID = b.ID
LEFT OUTER JOIN AbdStation c on a.AbdStationID = c.ID
WHERE 
datepart(year, a.[LocalTime]) = datepart(year, @ReportMonthFirstDay) and datepart(month, a.[LocalTime]) = datepart(month, @ReportMonthFirstDay)
and c.AbdType = 'KSK' --only grab records from KSK
order by a.SessionDuration

select * from @MyTableAUG

----------------------------------------------------------------------------------------------------------------------------------------------------

--select a.*
--FROM [dbo].[CustomerSession] a 
--LEFT OUTER JOIN Flight b on a.FlightID = b.ID
--LEFT OUTER JOIN AbdStation c on a.AbdStationID = c.ID
--WHERE 
--datepart(year, a.[LocalTime]) = datepart(year, @ReportMonthFirstDay) and datepart(month, a.[LocalTime]) = datepart(month, @ReportMonthFirstDay) 
--and c.AbdType = 'KSK' --only grab records from KSK
------------------------------------------------------------------------------------------------------------------------------------------------------
--insert into CustomerSessionBK
--(
--	[ID],
--	[CustomerID],
--	[AbdStationID],
--	[CustomerLookupType],
--	[PNR],
--	[UtcCreationTime],
--	[FlightID],
--	[TimeSlot5minID],
--	[TimeSlot10minID],
--	[TimeSlotHourlyID],
--	[DayOfTheWeekID],
--	[LocalTime],
--	[UtcCompletionTime],
--	[SessionDuration] 
--)
--select a.*
--FROM [dbo].[CustomerSession] a 
--LEFT OUTER JOIN Flight b on a.FlightID = b.ID
--LEFT OUTER JOIN AbdStation c on a.AbdStationID = c.ID
--WHERE 
--datepart(year, a.[LocalTime]) = datepart(year, @ReportMonthFirstDay) and datepart(month, a.[LocalTime]) = datepart(month, @ReportMonthFirstDay) + 1
--and c.AbdType = 'KSK' --only grab records from KSK
--------------------------------------------------------------------------------------------------------------------------------------------------------

DECLARE @MyTableSEP TABLE
(
SNo int IDENTITY(1,1), 
CustomerSessionID int,
SessionDuration float
)
insert into @MyTableSEP(CustomerSessionID, SessionDuration)
select 
a.ID as CustomerSessionID,
a.SessionDuration as SessionDuration
FROM [dbo].[CustomerSession] a 
LEFT OUTER JOIN Flight b on a.FlightID = b.ID
LEFT OUTER JOIN AbdStation c on a.AbdStationID = c.ID
WHERE 
datepart(year, a.[LocalTime]) = datepart(year, @ReportMonthFirstDay) and datepart(month, a.[LocalTime]) = datepart(month, @ReportMonthFirstDay) + 1 
and c.AbdType = 'KSK' --only grab records from KSK
order by SessionDuration
---------------------------------------------------------------------------------
select * from @MyTableSEP
---------------------------------------------------------------------------------
--Update  a
--set  
--    a.SessionDuration = a.SessionDuration + b.SessionDuration
--from [CustomerSessionBK2] a 
--inner join @MyTableAUG b on  a.SNo = b.SNo

--select * from @MyTableSEP

--select * from [CustomerSessionBK2]