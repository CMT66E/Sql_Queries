declare @FromTime datetime = '11/7/2021 1:00:00 PM'
declare @ToTime datetime = '12/7/2021 1:00:00 PM'
declare @AbdStationID int = 2
declare @AbdStatesString varchar(4000) ='1,ManualOutOfOrder;2,Running;3,InError;4,OutOfOrder;5,HealthyNotAvailable;6,Unknown'
declare @StateTimeSlotsString varchar(4000) = '1,1;2,2;3,3;4,4;5,5;6,6;7,7;8,8;9,9;10,10;11,11;12,12;13,13;14,14;15,15;16,16;17,17;18,18;19,19;20,20;21,21;22,22;23,23;24,24'

;WITH DateTimeRange AS 
(
	SELECT @FromTime AS Date, 
	declare   @FromTime AS FromTime,
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

SELECT CONVERT(DATE,Date) AS Date, @AbdStationID AS ABDStationID, StateTimeSlots.ID AS StateTimeSlotID,
	AbdStates.ID AS ABDStateID, AbdStates.State AS ABDState,
	dbo.CalculateSecondsInState (@AbdStationID, AbdStates.State, DateTimeRange.FromTime, DateTimeRange.ToTime) / 60.0 AS MinutesInState
FROM DateTimeRange
JOIN dbo.GetStateTimeSlotsFromString(@StateTimeSlotsString) AS StateTimeSlots ON DateTimeRange.TimeSlotHourlyID = StateTimeSlots.TimeSlotHouryID
CROSS JOIN dbo.GetABDStatesFromString(@AbdStatesString) AS AbdStates
ORDER BY Date, StateTimeSlots.ID, AbdStates.ID
OPTION (MAXRECURSION 0)	