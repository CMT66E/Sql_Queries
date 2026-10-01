USE [CUSSReportingDB]
GO
--------------------------------- Drop and Create GetAvailabilityData ---------------------------------------
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetAvailabilityData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetAvailabilityData]
GO

CREATE PROC [dbo].[GetAvailabilityData]
	@FromTime datetime,
	@ToTime datetime,
	@AbdStationID int

AS
 
--DateTimeRange
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

GO
Print 'Updated Procedure GetAvailabilityData'
