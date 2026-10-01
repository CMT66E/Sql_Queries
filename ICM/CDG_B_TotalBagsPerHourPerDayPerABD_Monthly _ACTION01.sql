DECLARE @FromTime DATETIME
SET @FromTime =  (Select Cast(convert (char(8),DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-2, 0),112) + ' 00:00:00.000' as datetime))

DECLARE @ToTime DATETIME
SET @ToTime =(Select cast(convert (char(8),DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-2, -1),112)+ ' 23:59:59.997' as datetime))

print '@FromTime = ' + cast(@FromTime as varchar)
print '@ToTime = ' + cast(@ToTime as varchar)

EXEC TotalBagsPerHourPerDayPerABD_SSIS @FromTime, @ToTime, 'AF'