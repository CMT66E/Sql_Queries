

	declare @FromTime datetime = '1/11/2022 11:00:00 PM'
	declare @ToTime datetime = '1/14/2022 11:00:00 PM'
	declare @AbdStationID int = 90
	declare @State varchar(50) = 'HealthyNotAvailable'

--RETURNS float

	DECLARE @LastStateIDBeforeFromTime bigint
	DECLARE @LastStateBeforeFromTime varchar(50)
	
	DECLARE @LastStateIDBeforeToTime bigint
	DECLARE @LastStateBeforeToTime varchar(50)
	
	--Get the last state before @FromTime
	SELECT TOP 1 @LastStateIDBeforeFromTime = ID, @LastStateBeforeFromTime = State
	FROM AbdStateHistory
	WHERE AbdStationID = @AbdStationID AND LocalTime <= @FromTime
	ORDER BY ID DESC

	--start added
	print '@LastStateIDBeforeFromTime =' + cast(@LastStateIDBeforeFromTime as varchar)
	print '@LastStateBeforeFromTime =' + cast(@LastStateBeforeFromTime as varchar)
	--end added
	
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
	WHERE PrevStates.State = @State

	select @SecondsInState as FinalSecondsInState
	--RETURN @SecondsInState