	declare @FromTime datetime = '4/5/2022 12:00:00 AM'
	declare @ToTime datetime = '4/6/2022 12:00:00 AM'
	declare @AbdStationID int = 1155
	declare @State varchar(50) = 'HealthyNotAvailable'  --ManualOutOfOrder--Running--InError--OutOfOrder--HealthyNotAvailable--Unknown

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
	
	--Get the last state before @ToTime
	SELECT TOP 1 @LastStateIDBeforeToTime = ID, @LastStateBeforeToTime = State
	FROM AbdStateHistory
	WHERE AbdStationID = @AbdStationID AND LocalTime <= @ToTime
	ORDER BY ID DESC
	
	--start added
	print '@LastStateIDBeforeFromTime =' + cast(@LastStateIDBeforeFromTime as varchar)
	print '@LastStateBeforeFromTime =' + cast(@LastStateBeforeFromTime as varchar)

 
            SELECT DENSE_RANK() OVER (ORDER BY LocalTime) AS Rank, *
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

            SELECT DENSE_RANK() OVER (ORDER BY LocalTime) AS Rank, *
			FROM
			(
				SELECT @LastStateIDBeforeFromTime	AS ID, @LastStateBeforeFromTime AS State,	@FromTime AS LocalTime
				UNION
				SELECT ID, State, LocalTime
				FROM AbdStateHistory
				WHERE AbdStationID = @AbdStationID AND LocalTime >= @FromTime AND LocalTime < @ToTime
				UNION
				SELECT @LastStateIDBeforeToTime	AS ID, @LastStateBeforeToTime AS State,	@ToTime AS LocalTime
			) b

	--print '@SecondsInState =' + cast(@SecondsInState as varchar)

    SELECT *
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
	--end added
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
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