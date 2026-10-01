--function: CalculateSecondsInState in action

declare @FromTime datetime = '01/28/2021 11:00:00 PM'
declare @ToTime datetime ='01/29/2021 00:00:00 AM'
declare @AbdStationID int = 1
declare @State varchar(50) = 'Running'


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
	WHERE PrevStates.State = @State
	
	print '@SecondsInState =' + cast(@SecondsInState as varchar)