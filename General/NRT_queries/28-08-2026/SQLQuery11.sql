
declare @UpdateMonthFirstDay datetime = '2026-08-01'

SELECT count([ID]) as total_records      
FROM [ReportingDB_NRT].[dbo].[BagWeightUpdate]
WHERE DATEPART(year,  [LocalTime]) = DATEPART(year, @UpdateMonthFirstDay) and DATEPART(month,  [LocalTime]) = DATEPART(month, @UpdateMonthFirstDay)
--72,461