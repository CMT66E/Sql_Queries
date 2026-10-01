declare 	@FromTime datetime = '2/16/2022 12:00:00 AM'
declare 	@ToTime datetime = '2/17/2022 12:00:00 AM'
declare 	@AbdStationID int = 195

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

INSERT INTO ABDAvailability (Date, AbdStationID, StateTimeSlotID, AbdStateID, MinutesInState)
SELECT CONVERT(DATE,Date) AS Date, @AbdStationID AS ABDStationID, StateTimeSlots.ID AS StateTimeSlotID,
	AbdStates.ID AS ABDStateID,
	dbo.CalculateSecondsInState (@AbdStationID, AbdStates.State, DateTimeRange.FromTime, DateTimeRange.ToTime) / 60.0 AS MinutesInState
FROM DateTimeRange
JOIN StateTimeSlots ON DateTimeRange.TimeSlotHourlyID = StateTimeSlots.TimeSlotHouryID
CROSS JOIN AbdStates
ORDER BY Date, StateTimeSlots.ID, AbdStates.ID
OPTION (MAXRECURSION 0)	