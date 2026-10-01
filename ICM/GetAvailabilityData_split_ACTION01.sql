
declare @FromTime datetime = '2022-06-22 12:00:00 PM'
declare @ToTime datetime = '2022-06-22 01:00:00 PM'
declare @AbdStationID int = 1
declare @AbdStatesString varchar(4000) ='1,ManualOutOfOrder;2,Running;3,InError;4,OutOfOrder;5,HealthyNotAvailable;6,Unknown'
declare @StateTimeSlotsString varchar(4000) = '1,1;2,2;3,3;4,4;5,5;6,6;7,7;8,8;9,9;10,10;11,11;12,12;13,13;14,14;15,15;16,16;17,17;18,18;19,19;20,20;21,21;22,22;23,23;24,24'

DECLARE @MyTable TABLE
	(
	SNo int IDENTITY(1,1), 
	[Date] DateTime,
	FromTime DateTime,
	ToTime DateTime,
	TimeSlotHourlyID int
	)  
 
;WITH DateTimeRange AS 
(
	SELECT @FromTime AS Date, 
		@FromTime AS FromTime,
		DATEADD(HOUR, 1, @FromTime) AS ToTime,  --add 1 hour from FromTime to be ToTime 
		DATEPART(HOUR, @FromTime) + 1 AS TimeSlotHourlyID --TimeSlotHourlyID is integer which is the value of current hour integer value plus 1
	UNION ALL
	SELECT DATEADD(DAY, 0, DATEDIFF(DAY, 0, DATEADD(HOUR, 1, FromTime))),  -- current FromTime adding 1 hour
		DATEADD(HOUR, 1, FromTime), --add 1 hour from FromTime to be FromTime
		DATEADD(HOUR, 1, ToTime),   --add 1 hour from ToTime to be ToTime
		DATEPART(HOUR, DATEADD(HOUR, 1, FromTime)) + 1 
	FROM DateTimeRange
	WHERE ToTime < @ToTime
)

insert into @MyTable
select * from DateTimeRange
OPTION (MAXRECURSION 0)	

select * from @MyTable

declare @MyTableSecond TABLE 
(
	ID int,
	TimeSlotHouryID int
)

insert into @MyTableSecond
SELECT * FROM [dbo].[GetStateTimeSlotsFromString](@StateTimeSlotsString);
select * from @MyTableSecond

declare @MyTableThird TABLE
(
	ID int,
	[State] varchar(50)
)
insert into @MyTableThird
select * from dbo.GetABDStatesFromString(@AbdStatesString)


--select * from @MyTableSecond CROSS JOIN dbo.GetABDStatesFromString(@AbdStatesString) AS AbdStates
select * from @MyTableThird

-- total 4320 rows
SELECT 
CONVERT(DATE, [Date]) AS Date, 
@AbdStationID AS ABDStationID, 
StateTimeSlots.ID AS StateTimeSlotID,
AbdStates.ID AS ABDStateID,
AbdStates.State AS ABDState
--,dbo.CalculateSecondsInState (@AbdStationID, AbdStates.State, MyTable.FromTime, MyTable.ToTime) / 60 AS MinutesInState
, AbdStates.State
, MyTable.FromTime
, MyTable.ToTime
FROM @MyTable as MyTable
JOIN @MyTableSecond AS StateTimeSlots ON MyTable.TimeSlotHourlyID = StateTimeSlots.TimeSlotHouryID
CROSS JOIN @MyTableThird AS AbdStates
ORDER BY Date, StateTimeSlots.ID, AbdStates.ID

declare @MyTableFinal TABLE
(	
	[Date] datetime,
	ABDStationID int,
	StateTimeSlotID int,
	ABDStateID int,
	ABDState varchar(50),
	[State] varchar(50),
	FromTime datetime,
	ToTime datetime
)
insert into @MyTableFinal
SELECT 
CONVERT(DATE, [Date]) AS Date, 
@AbdStationID AS ABDStationID, 
StateTimeSlots.ID AS StateTimeSlotID,
AbdStates.ID AS ABDStateID,
AbdStates.State AS ABDState
, AbdStates.State
, MyTable.FromTime
, MyTable.ToTime
FROM @MyTable as MyTable
JOIN @MyTableSecond AS StateTimeSlots ON MyTable.TimeSlotHourlyID = StateTimeSlots.TimeSlotHouryID
CROSS JOIN @MyTableThird AS AbdStates
ORDER BY Date, StateTimeSlots.ID, AbdStates.ID

select 
[Date], 
ABDStationID, 
ABDStateID, 
ABDState,   
dbo.CalculateSecondsInState (@AbdStationID, ABDState, FromTime, ToTime) / 60.0 as MinutesInState
from @MyTableFinal
 
