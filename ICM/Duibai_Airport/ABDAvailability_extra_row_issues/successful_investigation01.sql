--declare @CurrentTime datetime = '02/08/2021 01:00:03 AM'
--declare @CurrentTimeReduceAnHour datetime 
--select @CurrentTimeReduceAnHour = dateadd(hour, -1, @CurrentTime)
--print '@CurrentTimeReduceAnHour=' + CONVERT(VARCHAR(30), @CurrentTimeReduceAnHour, 109)

declare @FromTime datetime = '02/12/2021 10:00:00 PM'  
declare @ToTime datetime =   '02/12/2021 11:00:00 PM'  -- actual time is: 02/08/2021 12:03:00 AM
declare @AbdStationID int =1


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

--SELECT CONVERT(DATE,Date) AS Date, @AbdStationID AS ABDStationID, StateTimeSlots.ID AS StateTimeSlotID,
--	AbdStates.ID AS ABDStateID,
--	dbo.CalculateSecondsInState (@AbdStationID, AbdStates.State, DateTimeRange.FromTime, DateTimeRange.ToTime) / 60.0 AS MinutesInState
--FROM DateTimeRange
--JOIN StateTimeSlots ON DateTimeRange.TimeSlotHourlyID = StateTimeSlots.TimeSlotHouryID
--CROSS JOIN AbdStates
--ORDER BY CONVERT(DATE,Date), StateTimeSlots.ID, AbdStates.ID 
--OPTION (MAXRECURSION 0)	


set @FromTime  = '02/12/2021 11:00:00 PM'
set @ToTime ='02/13/2021 12:00:00 AM'                 -- actual time is: 02/08/2021 01:03:00 AM  NOTHING WILL BE INSERTED on this schedule call
set @AbdStationID = 1


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


set @FromTime  = '02/12/2021 11:00:00 PM'
set @ToTime ='02/13/2021 01:00:00 AM'                 -- actual time is: 02/08/2021 02:03:00 AM
set @AbdStationID = 1


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
