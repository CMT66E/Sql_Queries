--simulate the schedule task run at 12:03AM situation
--so the StateTimeSlotID 23 rows will be inserted into database

declare @FromTime datetime = '01/28/2021 10:00:00 PM'
declare @ToTime datetime ='01/28/2021 11:00:00 PM'
declare @AbdStationID int = 1107


;WITH DateTimeRange AS 
(
	SELECT @FromTime AS Date, 
		@FromTime AS FromTime,
		DATEADD(HOUR, 1, @FromTime) AS ToTime,
		DATEPART(HOUR, @FromTime) + 1 AS TimeSlotHourlyID
	UNION ALL
	SELECT DATEADD(DAY, 0, DATEDIFF(DAY, 0, DATEADD(HOUR, 1, FromTime))),
		DATEADD(HOUR, 1, FromTime),
		DATEADD(HOUR, 1, ToTime),
		DATEPART(HOUR, DATEADD(HOUR, 1, FromTime)) + 1
	FROM DateTimeRange
	WHERE ToTime < @ToTime
)

select * from DateTimeRange