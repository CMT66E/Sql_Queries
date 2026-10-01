 
--1. AvailabilityStatesPerDayPerABD_SSISAF   --- AvailabilityStatesPerHourPerDayPerABD_Monthly

DECLARE @FromDateTime DATETIME,@ToDateTime DATETIME
SET @FromDateTime = (Select Cast(convert (char(8),DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-1, 0),112) + ' 00:00:00.000' as datetime))

SET @ToDateTime = (Select cast(convert (char(8),DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1),112)+ ' 00:00:00.000' as datetime))

print '@FromDateTime = ' + cast(@FromDateTime as varchar)
print '@ToDateTime = ' + cast(@ToDateTime as varchar)

EXEC AvailabilityStatesPerDayPerABD_SSISAF  @FromDateTime, @ToDateTime

 