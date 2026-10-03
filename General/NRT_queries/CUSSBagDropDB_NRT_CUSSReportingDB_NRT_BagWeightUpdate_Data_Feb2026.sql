declare @FromDateTime DateTime = '2026/02/24 00:00:00 AM'

--select * from 
--[CUSSBagDropDB_NRT].[dbo].[BagWeightUpdate] a
--WHERE 
--DATEPART(year, a.LocalTime) = DATEPART(year, @FromDateTime) and 
--DATEPART(month, a.LocalTime) = DATEPART(month, @FromDateTime)  -- 257,002

--select * from 
--[CUSSReportingDB_NRT].[dbo].[BagWeightUpdate] a
--WHERE 
--DATEPART(year, a.LocalTime) = DATEPART(year, @FromDateTime) and 
--DATEPART(month, a.LocalTime) = DATEPART(month, @FromDateTime)    -- 255,317 no short  

select * from 
[CUSSReportingDB_NRT_FEB2026].[dbo].[BagWeightUpdate] a
WHERE 
DATEPART(year, a.LocalTime) = DATEPART(year, @FromDateTime) and 
DATEPART(month, a.LocalTime) = DATEPART(month, @FromDateTime)      --257,002 short 6 records