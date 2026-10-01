declare @FromTime datetime = '6/11/2022 2:00:00 PM'
declare @ToTime datetime = '6/12/2022 2:00:00 PM'
declare @AbdStationID int = 7852

--define a table to hold all data
declare @TempABDAvailability TABLE
(	   
	[Date] datetime,
	ABDStationID int,
	StateTimeSlotID int,
	ABDStateID int,
	MinutesInState float
)

declare @MyTableFinal TABLE
(	
    SNo int IDENTITY(1,1), 
	[Date] datetime,
	ABDStationID int,
	StateTimeSlotID int,
	ABDStateID int,
	ABDState varchar(50),
	MinutesInState int,
	FromTime datetime,
	ToTime datetime
)
--end define 

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
insert into @MyTableFinal
SELECT 
CONVERT(DATE,Date) AS Date, 
@AbdStationID AS ABDStationID, 
StateTimeSlots.ID AS StateTimeSlotID,
	AbdStates.ID AS ABDStateID,
	AbdStates.State AS ABDState,
	--dbo.CalculateSecondsInState (@AbdStationID, AbdStates.State, DateTimeRange.FromTime, DateTimeRange.ToTime) / 60.0 AS MinutesInState
	0 AS MinutesInState,	
	DateTimeRange.FromTime,
	DateTimeRange.ToTime
FROM DateTimeRange
JOIN StateTimeSlots ON DateTimeRange.TimeSlotHourlyID = StateTimeSlots.TimeSlotHouryID
CROSS JOIN AbdStates
ORDER BY Date, StateTimeSlots.ID, AbdStates.ID
OPTION (MAXRECURSION 0)	

--INSERT INTO ABDAvailability (Date, AbdStationID, StateTimeSlotID, AbdStateID, MinutesInState)
--SELECT CONVERT(DATE,Date) AS Date, @AbdStationID AS ABDStationID, StateTimeSlots.ID AS StateTimeSlotID,
--	AbdStates.ID AS ABDStateID,
--	dbo.CalculateSecondsInState (@AbdStationID, AbdStates.State, DateTimeRange.FromTime, DateTimeRange.ToTime) / 60.0 AS MinutesInState
--FROM DateTimeRange
--JOIN StateTimeSlots ON DateTimeRange.TimeSlotHourlyID = StateTimeSlots.TimeSlotHouryID
--CROSS JOIN AbdStates
--ORDER BY Date, StateTimeSlots.ID, AbdStates.ID
--OPTION (MAXRECURSION 0)	

declare @Cnt int
SELECT @Cnt = MIN(Sno) FROM @MyTableFinal
	
declare @TempDate date
declare @TempROW_ID int


declare @TempState varchar(50)  
declare @TempStateID int
declare @TempStateTimeSlotID int
declare @TempFromTime datetime 
declare @TempToTime datetime  

WHILE (1=1)
BEGIN
   
SELECT @TempROW_ID = SNo, @TempDate = [Date], @TempStateTimeSlotID = StateTimeSlotID, @TempStateID = ABDStateID,  @TempState = AbdState, @TempFromTime=FromTime, @TempToTime=ToTime FROM @MyTableFinal
WHERE SNo = @Cnt
	    
IF @@ROWCOUNT = 0
	BREAK


	if exists(select * from @MyTableFinal where cast(SNo as varchar) = cast(@TempROW_ID as varchar))
	begin	
		
		print '---------------------------------------------'
		print '@TempROW_ID =' + cast(@TempROW_ID as varchar)
		print '@TempDate =' + cast(@TempDate as varchar)
		print '@TempStateID =' + cast(@TempStateID as varchar)
		print '@TempState =' + cast(@TempState as varchar)
		print '@TempFromTime =' + cast(@TempFromTime as varchar)
		print '@TempToTime =' + cast(@TempToTime as varchar)


		DECLARE @LastStateIDBeforeFromTime bigint
		DECLARE @LastStateBeforeFromTime varchar(50)
	
		DECLARE @LastStateIDBeforeToTime bigint
		DECLARE @LastStateBeforeToTime varchar(50)
	
		--Get the last state before @FromTime
		SELECT TOP 1 @LastStateIDBeforeFromTime = ID, @LastStateBeforeFromTime = State
		FROM AbdStateHistory
		WHERE AbdStationID = @AbdStationID AND LocalTime <= @TempFromTime
		ORDER BY ID DESC
	
		--Get the last state before @ToTime
		SELECT TOP 1 @LastStateIDBeforeToTime = ID, @LastStateBeforeToTime = State
		FROM AbdStateHistory
		WHERE AbdStationID = @AbdStationID AND LocalTime <= @TempToTime
		ORDER BY ID DESC
	
		DECLARE @SecondsInState FLOAT
	
		SELECT @SecondsInState = ISNULL(SUM(DATEDIFF(SECOND, PrevStates.LocalTime, NextStates.LocalTime)),0.0)
		FROM
			(SELECT DENSE_RANK() OVER (ORDER BY LocalTime) AS Rank, *
				FROM
				(
					SELECT @LastStateIDBeforeFromTime	AS ID, @LastStateBeforeFromTime AS State,	@TempFromTime AS LocalTime
					UNION
					SELECT ID, State, LocalTime
					FROM AbdStateHistory
					WHERE AbdStationID = @AbdStationID AND LocalTime >= @TempFromTime AND LocalTime < @TempToTime
					UNION
					SELECT @LastStateIDBeforeToTime	AS ID, @LastStateBeforeToTime AS State,	@TempToTime AS LocalTime
				) a 
			) PrevStates
			JOIN (SELECT DENSE_RANK() OVER (ORDER BY LocalTime) AS Rank, *
				FROM
				(
					SELECT @LastStateIDBeforeFromTime	AS ID, @LastStateBeforeFromTime AS State,	@TempFromTime AS LocalTime
					UNION
					SELECT ID, State, LocalTime
					FROM AbdStateHistory
					WHERE AbdStationID = @AbdStationID AND LocalTime >= @TempFromTime AND LocalTime < @TempToTime
					UNION
					SELECT @LastStateIDBeforeToTime	AS ID, @LastStateBeforeToTime AS State,	@TempToTime AS LocalTime
				) a
			) NextStates
			ON PrevStates.Rank = NextStates.Rank - 1 AND PrevStates.ID IS NOT NULL AND NextStates.ID IS NOT NULL
		WHERE PrevStates.State = @TempState
	
	 
        print '@SecondsInState =' + cast(@SecondsInState as varchar)
		print '---------------------------------------------'

	    INSERT INTO @TempABDAvailability (Date, AbdStationID, StateTimeSlotID, AbdStateID, MinutesInState)
		VALUES(@TempDate, @AbdStationID, @TempStateTimeSlotID, @TempStateID, @SecondsInState / 60)

	end
SELECT @Cnt = @Cnt + 1
		
END

insert into ABDAvailability (Date, AbdStationID, StateTimeSlotID, AbdStateID, MinutesInState)
select Date, AbdStationID, StateTimeSlotID, AbdStateID, MinutesInState from @TempABDAvailability


select Date, AbdStationID, StateTimeSlotID, AbdStateID, MinutesInState from @TempABDAvailability
--select *, dbo.CalculateSecondsInState (@AbdStationID, State, FromTime, ToTime) / 60.0 AS MinutesInState from @MyTableFinal