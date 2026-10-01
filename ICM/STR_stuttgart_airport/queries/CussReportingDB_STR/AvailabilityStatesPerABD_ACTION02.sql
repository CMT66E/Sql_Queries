declare @FromDateTime DateTime = '2021-04-01 00:00:00'
declare @ToDateTime DateTime = '2021-04-30 23:59:00'
declare @Terminal nvarchar(10) = '%'
declare @Area nvarchar(10) = '%'
declare @SubArea nvarchar(10) = '%'
declare @ABDStationIDs varchar(400) = '0'
declare @ABDStationNames varchar(4000) = ' Display All ABDs'

declare @IsSearchDateAfterApr bit = 1
if not (DatePart(year, @FromDateTime) = 2021 and DatePart(month, @FromDateTime) >= 4)
	select @IsSearchDateAfterApr = 0

if @IsSearchDateAfterApr = 1  
begin
	SELECT     ABDAvailability.Date,@ABDStationNames AS ABDStations, ABDStates.ID AS AbdStateID,  ABDStates.State, SUM(ABDAvailability.MinutesInState) as MinutesInState
	FROM         ABDAvailability INNER JOIN
						  ABDStates ON ABDAvailability.ABDStateID = ABDStates.ID INNER JOIN
						  StateTimeSlots ON ABDAvailability.StateTimeSlotID = StateTimeSlots.ID INNER JOIN
						  TimeSlotHourly ON StateTimeSlots.TimeSlotHouryID = TimeSlotHourly.ID INNER JOIN
						  ABDStation ON ABDStation.ID = ABDAvailability.ABDStationID
	WHERE        (ABDAvailability.Date BETWEEN @FromDateTime AND @ToDateTime)
		AND (AbdStation.Terminal LIKE @Terminal)
		AND (ISNULL(AbdStation.Area,'') LIKE @Area )
		AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
		AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
		AND ABDAvailability.ABDStationID <= 30
	GROUP BY ABDAvailability.Date, ABDStates.ID, ABDStates.State
	ORDER BY ABDAvailability.Date, ABDStates.State
end

 
if @IsSearchDateAfterApr = 1
begin
	DECLARE @MyTable TABLE
	(
	[Date] DateTime, 
	AbdStationID int, 
	ABDStations varchar(50),
	AbdStateID int,
	[State] varchar(50),
	MinutesInState float 
	)    

	DECLARE @MyTableFinal TABLE
	(
	[Date] DateTime,
	AbdStationNameShort varchar(50),
	AbdStationID int, 
	ABDStations varchar(50),
	AbdStateID int,
	[State] varchar(50),
	MinutesInState float 
	)  

    insert into @MyTable

	SELECT     
	ABDAvailability.Date,
	AbdStation.ID AS AbdStationID,
	dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal, AbdStation.Area, AbdStation.SubArea, AbdStation.AbdType) AS ABDStations, 
	ABDStates.ID AS AbdStateID,  
	ABDStates.State, 
	SUM(ABDAvailability.MinutesInState) as MinutesInState
	FROM         ABDAvailability INNER JOIN
						  ABDStates ON ABDAvailability.ABDStateID = ABDStates.ID INNER JOIN
						  StateTimeSlots ON ABDAvailability.StateTimeSlotID = StateTimeSlots.ID INNER JOIN
						  TimeSlotHourly ON StateTimeSlots.TimeSlotHouryID = TimeSlotHourly.ID INNER JOIN
						  ABDStation ON ABDStation.ID = ABDAvailability.ABDStationID
	WHERE        (ABDAvailability.Date BETWEEN @FromDateTime AND @ToDateTime)
		AND (AbdStation.Terminal LIKE @Terminal)
		AND (ISNULL(AbdStation.Area,'') LIKE @Area )
		AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
		AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
		AND NOT ABDStation.ID in (31, 32, 506)		 
	GROUP BY ABDAvailability.Date, AbdStation.ID, dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal, AbdStation.Area, AbdStation.SubArea, AbdStation.AbdType), ABDStates.ID, ABDStates.State
	ORDER BY ABDAvailability.Date, ABDStates.State


	DECLARE @MyTableTemp TABLE
	(
	TempAbdStationID int, 
	AbdStationName varchar(50),	 
	AbdStationNameShort varchar(50) 
	)  

	insert into @MyTableTemp
	select Max(AbdStationID) as TempAbdStationID, ABDStations, SUBSTRING(ABDStations, 12, 3) as AbdStationNameShort from @MyTable
	group by ABDStations
	having not Max(AbdStationID) in (31, 32, 506)
	order by cast(SUBSTRING(ABDStations, 12, 3) as int)

	DECLARE @MyTB TABLE
		(
		SNo int IDENTITY(1,1), 
		AbdStationNameShort varchar(10) 
		)    
	INSERT INTO @MyTB(AbdStationNameShort)	    
	select distinct AbdStationNameShort from @MyTableTemp

	DECLARE @MyTBState TABLE
		(
		SeqNo int IDENTITY(1,1), 
		ABDStateID int,
		StateDesc varchar(50) 
		)  
	insert into @MyTBState
	select ABDStateID, [State] from @MyTable
	group by ABDStateID, [State]

	--select * from @MyTBState

	--start looping through @MyTBState
	declare @CntTop int
	SELECT @CntTop = MIN(SeqNo) FROM @MyTBState
	
	declare @TempTopABDStateID int
	declare @TempTopStateDesc varchar(50) 

	WHILE (1=1)
	BEGIN
   
	SELECT @TempTopABDStateID = ABDStateID, @TempTopStateDesc = StateDesc FROM @MyTBState
	WHERE SeqNo = @CntTop
	    
	IF @@ROWCOUNT = 0
		BREAK
	 --start inner looping
				 --1. we only loop through 30 KIOSKs which we get it from table: @MyTableTemp
				 
				declare @Cnt int
				SELECT @Cnt = MIN(Sno) FROM @MyTB
	
				declare @TempAbdStationNameShort  varchar(10)
				declare @TempMaxAbdStationID  int
				declare @TempMaxAbdStationName  varchar(50)
				declare @TempAbdStationID  int
				declare @TempAbdStateID int
				declare @TempAbdState  varchar(50)
				declare @TempMinMinutesInState  float
				declare @TempDate DateTime

				WHILE (1=1)
				BEGIN
   
				SELECT @TempAbdStationNameShort = AbdStationNameShort  FROM @MyTB
				WHERE SNo = @Cnt
	    
				IF @@ROWCOUNT = 0
					BREAK

					if exists(select Max(AbdStationID) from @MyTable where cast(SUBSTRING(ABDStations, 12, 3) as varchar) = cast(@TempAbdStationNameShort as varchar) and AbdStateID = @TempTopABDStateID)
					begin
						  print '@TempAbdStationNameShort =' + cast(@TempAbdStationNameShort as varchar)

						 
					     select @TempMaxAbdStationID = Max(AbdStationID) from @MyTable where cast(SUBSTRING(ABDStations, 12, 3) as varchar) = cast(@TempAbdStationNameShort as varchar) and AbdStateID = @TempTopABDStateID
						   
						  print '@TempMaxAbdStationID =' + cast(@TempMaxAbdStationID as varchar)

						  if @TempTopABDStateID = 2

							  select 
							  @TempMinMinutesInState = isnull(SUM(MinutesInState), 0) 		   
							  from @MyTable where cast(SUBSTRING(ABDStations, 12, 3) as varchar) = cast(@TempAbdStationNameShort as varchar) and SUBSTRING(@TempMaxAbdStationName, 1, 4) = 'STR1' and AbdStateID = @TempTopABDStateID
					  
						  else

							  select 
							  @TempMinMinutesInState = isnull(SUM(MinutesInState), 0) 		   
							  from @MyTable where cast(SUBSTRING(ABDStations, 12, 3) as varchar) = cast(@TempAbdStationNameShort as varchar) and SUBSTRING(@TempMaxAbdStationName, 1, 4) = 'STR1' and AbdStateID = @TempTopABDStateID

						  select 	
						  @TempDate = [Date],
						  @TempMaxAbdStationName = ABDStations,
						  @TempAbdStationID = AbdStationID,
						  @TempAbdStateID = AbdStateID,
						  @TempAbdState = [State]
						  from @MyTable where cast(SUBSTRING(ABDStations, 12, 3) as varchar) = cast(@TempAbdStationNameShort as varchar) and AbdStationID = @TempMaxAbdStationID and AbdStateID = @TempTopABDStateID


						  print '@TempMaxAbdStationName =' + cast(SUBSTRING(@TempMaxAbdStationName, 1, 4) as varchar)
						  print '@TempMinMinutesInState =' + cast(@TempMinMinutesInState as varchar)

						  print '---------------------------------------------'

						  insert into @MyTableFinal
						  (
						        [Date],
								AbdStationNameShort,
								AbdStationID, 
								ABDStations,
								AbdStateID,
								[State],
								MinutesInState 
						  )
						  values
						  (
						  @TempDate,
						  @TempAbdStationNameShort,
						  @TempMaxAbdStationID,
						  @ABDStationNames,
						  @TempAbdStateID,
						  @TempAbdState,
						  @TempMinMinutesInState
						  )
					end
 
				SELECT @Cnt = @Cnt + 1
		
				END

	 --end inner lopping
		
	SELECT @CntTop = @CntTop + 1
		
	END
	--end looping through @MyTBState 

	select 
	[Date],	 
	ABDStations,
	AbdStateID,
	State,
	SUM(MinutesInState) as MinutesInState
	from @MyTableFinal
	group by [Date], ABDStations, AbdStateID, State

	 
end