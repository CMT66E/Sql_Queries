USE BagDropDB_QF_NEW
GO

declare @ReportMonthFirstDay DateTime = '2023/01/01 00:00:00'
declare @ReportMonthEndDay DateTime = '2023/01/31 23:59:59'
declare @AbdType varchar(50) = 'ABD' --KSK or ABD


DECLARE @MyTable TABLE
(
SNo int IDENTITY(1,1),
LocalTime datetime,
PortCode varchar(50),
Terminal varchar(50),
Area varchar(50),
TotalTransactionTime decimal(10,1)
)  

insert into @MyTable(LocalTime, PortCode, Terminal, Area, TotalTransactionTime)
select 
LocalCreationTime, 
c.PortCode,
c.Terminal,
c.Area,
sum(cast(FLOOR(cast(DATEDIFF(MILLISECOND, a.[LocalCreationTime], a.[LocalCompletionTime]) as decimal(10, 0))/1000) as decimal(10,0))) as TotalTransactionTime
FROM [dbo].[CustomerSession] a 
LEFT OUTER JOIN Flight b on a.FlightID = b.ID
INNER JOIN AbdStation c on a.AbdStationID = c.ID
WHERE 
--datepart(year, a.[LocalTime]) = datepart(year, @ReportMonthFirstDay) and datepart(month, a.[LocalTime]) = datepart(month, @ReportMonthFirstDay) 
a.LocalCreationTime between @ReportMonthFirstDay and @ReportMonthEndDay
and c.AbdType = @AbdType --only grab records from KSK
--and cast(FLOOR(cast(DATEDIFF(MILLISECOND, a.[LocalCreationTime], a.[LocalCompletionTime]) as decimal(10, 0))/1000) as decimal(10,0)) > 0 -- add this line to get checked in bags count
and c.PortCode = 'WLG'
group by LocalCreationTime, PortCode, c.Terminal,c.Area,c.SubArea, c.AbdType
order by LocalCreationTime
 
select 
cast(LocalTime as date) as [Date],
PortCode, 
count(TotalTransactionTime) as BagCount
from @MyTable
where PortCode = 'WLG'
group by cast(LocalTime as date), PortCode 