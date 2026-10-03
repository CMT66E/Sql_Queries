declare @FromDateTime DateTime = '2026/02/24 00:00:00 AM'


select * from 
[CUSSReportingDB_NRT_FEB2026].[dbo].[CustomerSession] a
WHERE 
DATEPART(year, a.LocalTime) = DATEPART(year, @FromDateTime) and 
DATEPART(month, a.LocalTime) = DATEPART(month, @FromDateTime)      --451,668 short 

select * from 
[CUSSReportingDB_NRT].[dbo].[CustomerSession] a
WHERE 
DATEPART(year, a.LocalTime) = DATEPART(year, @FromDateTime) and 
DATEPART(month, a.LocalTime) = DATEPART(month, @FromDateTime)      --443,589 short 8079 records


select @@version
--------------------------


select * from 
[CUSSReportingDB_NRT_FEB2026].[dbo].[BagWeightUpdate] a
WHERE 
DATEPART(year, a.LocalTime) = DATEPART(year, @FromDateTime) and 
DATEPART(month, a.LocalTime) = DATEPART(month, @FromDateTime)      --257,002 short 

select * from 
[CUSSReportingDB_NRT].[dbo].[BagWeightUpdate] a
WHERE 
DATEPART(year, a.LocalTime) = DATEPART(year, @FromDateTime) and 
DATEPART(month, a.LocalTime) = DATEPART(month, @FromDateTime)      --255,671 short 1331 records
