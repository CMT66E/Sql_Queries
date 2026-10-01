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

-- we loop through the whole table to do calculation in this SP
-- currently this function call CalculateSecondsInState is not efficient at all 25-07-2022
---------------------------------------------------
DECLARE @MyTable TABLE
	(
	SNo int IDENTITY(1,1), 
	ROW_NBR int
	)   

INSERT INTO @MyTable(ROW_NBR)	    
SELECT ROW_NBR from @TempTable

declare @Cnt int
SELECT @Cnt = MIN(Sno) FROM @MyTable
	
declare @TempState varchar(50)
declare @TempFromTime datetime
declare @TempToTime datetime
declare @TempROW_ID int

WHILE (1=1)
BEGIN
   
SELECT @TempROW_ID = ROW_NBR FROM @MyTable
WHERE SNo = @Cnt
	    
IF @@ROWCOUNT = 0
	BREAK



	if exists(select ROW_NBR from @TempTable where cast(ROW_NBR as varchar) = cast(@TempROW_ID as varchar))
	begin
	    select @TempState = AbdStateText, @TempFromTime = FromTime, @TempToTime = ToTime from @TempTable where ROW_NBR = @TempROW_ID
		print '@TempState =' + cast(@TempState as varchar)
		print '@TempROW_ID =' + cast(@TempROW_ID as varchar)
		--print 'MinutesInState =' + cast(dbo.CalculateSecondsInState (@AbdStationID, @TempState, @TempFromTime, @TempToTime) / 60.0 as varchar)
		Print '--------------------------------------'

	DECLARE @LastStateIDBeforeFromTime bigint
	DECLARE @LastStateBeforeFromTime varchar(50)
	
	DECLARE @LastStateIDBeforeToTime bigint
	DECLARE @LastStateBeforeToTime varchar(50)
	
	--Get the last state before @FromTime
	SELECT TOP 1 @LastStateIDBeforeFromTime = ID, @LastStateBeforeFromTime = State
	FROM AbdStateHistory
	WHERE AbdStationID = @AbdStationID AND LocalTime <= @FromTime
	ORDER BY ID DESC
	
	--Get the last state before @ToTime
	SELECT TOP 1 @LastStateIDBeforeToTime = ID, @LastStateBeforeToTime = State
	FROM AbdStateHistory
	WHERE AbdStationID = @AbdStationID AND LocalTime <= @ToTime
	ORDER BY ID DESC

	DECLARE @SecondsInState FLOAT
	
	SELECT @SecondsInState = ISNULL(SUM(DATEDIFF(SECOND, PrevStates.LocalTime, NextStates.LocalTime)),0.0)
	FROM
		(SELECT DENSE_RANK() OVER (ORDER BY LocalTime) AS Rank, *
			FROM
			(
				SELECT @LastStateIDBeforeFromTime	AS ID, @LastStateBeforeFromTime AS State,	@FromTime AS LocalTime
				UNION
				SELECT ID, State, LocalTime
				FROM AbdStateHistory
				WHERE AbdStationID = @AbdStationID AND LocalTime >= @FromTime AND LocalTime < @ToTime
				UNION
				SELECT @LastStateIDBeforeToTime	AS ID, @LastStateBeforeToTime AS State,	@ToTime AS LocalTime
			) a 
		) PrevStates
		JOIN (SELECT DENSE_RANK() OVER (ORDER BY LocalTime) AS Rank, *
			FROM
			(
				SELECT @LastStateIDBeforeFromTime	AS ID, @LastStateBeforeFromTime AS State,	@FromTime AS LocalTime
				UNION
				SELECT ID, State, LocalTime
				FROM AbdStateHistory
				WHERE AbdStationID = @AbdStationID AND LocalTime >= @FromTime AND LocalTime < @ToTime
				UNION
				SELECT @LastStateIDBeforeToTime	AS ID, @LastStateBeforeToTime AS State,	@ToTime AS LocalTime
			) a
		) NextStates
		ON PrevStates.Rank = NextStates.Rank - 1 AND PrevStates.ID IS NOT NULL AND NextStates.ID IS NOT NULL
	WHERE PrevStates.State = @TempState

	    --select @SecondsInState as FinalSecondsInState
		update @TempTable set MinutesInState = @SecondsInState / 60.0 where ROW_NBR = @TempROW_ID
	    print 'FinalSecondsInState =' + cast(@SecondsInState / 60.0 as varchar)
		print '---------------------------------------------'
	end

SELECT @Cnt = @Cnt + 1
		
END
---------------------------------------------------

select * from @TempTable

--select a.*, dbo.CalculateSecondsInState (a.AbdStationID, a.AbdStateText, a.FromTime, a.ToTime) / 60.0 AS MinutesInState 
--from @TempTable a 


--SELECT I.[MinutesInState]
--  ,a.*
--FROM @TempTable a
--CROSS APPLY GetCalculateSecondsInState(a.AbdStationID, a.AbdStateText, a.FromTime, a.ToTime) I




