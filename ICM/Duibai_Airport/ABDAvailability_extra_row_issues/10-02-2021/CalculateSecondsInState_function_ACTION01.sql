declare @AbdStationID int = 1107
declare @State varchar(50) = 'Running'
declare @FromTime datetime = '2021-01-28 23:00:03.000'
declare @ToTime datetime = '2021-01-29 00:00:03.000'


	DECLARE @LastStateIDBeforeFromTime bigint
	DECLARE @LastStateBeforeFromTime varchar(50)
	
	DECLARE @LastStateIDBeforeToTime bigint
	DECLARE @LastStateBeforeToTime varchar(50)
	
	--Get the last state before @FromTime
	SELECT TOP 1 @LastStateIDBeforeFromTime = ID, @LastStateBeforeFromTime = State
	FROM AbdStateHistory
	WHERE AbdStationID = @AbdStationID AND LocalTime <= @FromTime
	ORDER BY ID DESC

	--test line start
	SELECT  AbdStateHistory.ID,  State, AbdStateHistory.*
	FROM AbdStateHistory
	WHERE AbdStationID = @AbdStationID AND LocalTime <= @FromTime
	ORDER BY AbdStateHistory.ID DESC

	print '@LastStateIDBeforeFromTime =' + cast(@LastStateIDBeforeFromTime as varchar)
	print '@LastStateBeforeFromTime =' + cast(@LastStateBeforeFromTime as varchar)
	--test line end
	
	--Get the last state before @ToTime
	SELECT TOP 1 @LastStateIDBeforeToTime = ID, @LastStateBeforeToTime = State
	FROM AbdStateHistory
	WHERE AbdStationID = @AbdStationID AND LocalTime <= @ToTime
	ORDER BY ID DESC

	--test line start
	print '@@LastStateIDBeforeToTime =' + cast(@LastStateIDBeforeToTime as varchar)
	print '@@LastStateBeforeToTime =' + cast(@LastStateBeforeToTime as varchar)
	--test line end
	
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
	WHERE PrevStates.State = @State
	
	print ' Finally @SecondsInState = ' + cast(@SecondsInState as varchar)
