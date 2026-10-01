declare @FromTime datetime = '4/5/2022 12:00:00 AM'
declare @ToTime datetime = '4/6/2022 12:00:00 AM'
declare @AbdStationID int = 1155



declare @TempTable TABLE
(
Date datetime, 
AbdStationID INT, 
StateTimeSlotID INT,
AbdStateID INT,
AbdStateText varchar(50),
MinutesInState float,
FromTime datetime,
ToTime datetime,
ROW_NBR INT
)



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

--INSERT INTO ABDAvailability (Date, AbdStationID, StateTimeSlotID, AbdStateID, MinutesInState)
insert into @TempTable(Date, AbdStationID, StateTimeSlotID, AbdStateID, AbdStateText, MinutesInState, FromTime, ToTime, ROW_NBR)
SELECT CONVERT(DATE,Date) AS Date, @AbdStationID AS ABDStationID, StateTimeSlots.ID AS StateTimeSlotID,
	AbdStates.ID AS ABDStateID,
	--dbo.CalculateSecondsInState (@AbdStationID, AbdStates.State, DateTimeRange.FromTime, DateTimeRange.ToTime) / 60.0 AS MinutesInState
	ABDStates.State,
	0 AS MinutesInState,
	DateTimeRange.FromTime,
	DateTimeRange.ToTime,
	Row_number () OVER (PARTITION BY Date ORDER BY Date) AS ROW_NBR 
FROM DateTimeRange
JOIN StateTimeSlots ON DateTimeRange.TimeSlotHourlyID = StateTimeSlots.TimeSlotHouryID
CROSS JOIN AbdStates
ORDER BY Date, StateTimeSlots.ID, AbdStates.ID
OPTION (MAXRECURSION 0)	

delete from @TempTable where ROW_NBR > 2

select * from @TempTable

--select a.*, dbo.CalculateSecondsInState (a.AbdStationID, a.AbdStateText, a.FromTime, a.ToTime) / 60.0 AS MinutesInState 
--from @TempTable a 


SELECT I.[MinutesInState]
  ,a.*
FROM @TempTable a
CROSS APPLY GetCalculateSecondsInState(a.AbdStationID, a.AbdStateText, a.FromTime, a.ToTime) I




