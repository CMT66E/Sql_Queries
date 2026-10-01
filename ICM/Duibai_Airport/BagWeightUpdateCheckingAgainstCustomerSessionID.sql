declare @UpdateMonthFirstDay datetime = '2021-09-01'

SELECT *
  FROM [CussReportingDB_DXB].[dbo].[BagWeightUpdate]
WHERE 
datepart(year, UtcTime) = datepart(year, @UpdateMonthFirstDay) and datepart(month, UtcTime) = datepart(month, @UpdateMonthFirstDay) and datepart(day, UtcTime) = datepart(day, @UpdateMonthFirstDay)
AND NOT CustomerSessionID in 
(
  select ID from  [CUSSReportingDB_DXB].[dbo].[CustomerSession]
)

select * from [CUSSReportingDB_DXB].[dbo].[CustomerSession] where ID in (1157444, 1153050)