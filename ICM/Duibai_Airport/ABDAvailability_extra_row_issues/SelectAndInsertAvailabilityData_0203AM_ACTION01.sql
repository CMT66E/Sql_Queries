--simulate the schedule task run at 2:03AM situation
--so the StateTimeSlotID 1 rows will be inserted into database

declare @FromTime datetime = '01/29/2021 00:00:00 AM'
declare @ToTime datetime ='01/29/2021 01:00:00 AM'
declare @AbdStationID int = 1107

-----------------------------------------------------------------------------------------------------------------------------------------
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
--JOIN StateTimeSlots ON DateTimeRange.TimeSlotHourlyID = StateTimeSlots.TimeSlotHouryID 
--CROSS JOIN AbdStates

-----------------------------------------------------------------------------------------------------------------------------------------
--SELECT CONVERT(DATE,Date) AS Date, @AbdStationID AS ABDStationID, StateTimeSlots.ID AS StateTimeSlotID,
--	AbdStates.ID AS ABDStateID,
--	dbo.CalculateSecondsInState (@AbdStationID, AbdStates.State, DateTimeRange.FromTime, DateTimeRange.ToTime) / 60.0 AS MinutesInState
--FROM DateTimeRange
--JOIN StateTimeSlots ON DateTimeRange.TimeSlotHourlyID = StateTimeSlots.TimeSlotHouryID
--CROSS JOIN AbdStates
--ORDER BY CONVERT(DATE,Date), StateTimeSlots.ID, AbdStates.ID 
--OPTION (MAXRECURSION 0)	