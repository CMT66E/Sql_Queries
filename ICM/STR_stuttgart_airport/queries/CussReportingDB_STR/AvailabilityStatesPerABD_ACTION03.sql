declare @FromDateTime DateTime = '2021-05-01 00:00:00'
declare @ToDateTime DateTime = '2021-05-31 23:59:00'
declare @TimeSlotID int = 0
declare @Terminal nvarchar(10) = '%'
declare @Area nvarchar(10) = '%'
declare @SubArea nvarchar(10) = '%'
declare @ABDStationIDs varchar(400) = '0'
declare @ABDStationNames varchar(4000) = ' Display All ABDs'

declare @IsSearchDateAfterApr bit = 1

if not (DatePart(year, @FromDateTime) = 2021 and DatePart(month, @FromDateTime) >= 4)
	select @IsSearchDateAfterApr = 0


if @IsSearchDateAfterApr = 0
begin
	SELECT     AbdStation.ID AS AbdStationID, dbo.GetAbdNameOld(AbdStation.Identifier, AbdStation.Terminal, AbdStation.Area,AbdStation.SubArea) AS AbdStationName, 
		ABDStates.ID AS AbdStateID, ABDStates.State, SUM(ABDAvailability.MinutesInState) as MinutesInState
	FROM         ABDAvailability INNER JOIN
						  ABDStates ON ABDAvailability.ABDStateID = ABDStates.ID INNER JOIN
						  StateTimeSlots ON ABDAvailability.StateTimeSlotID = StateTimeSlots.ID INNER JOIN
						  TimeSlotHourly ON StateTimeSlots.TimeSlotHouryID = TimeSlotHourly.ID LEFT OUTER JOIN
						  AbdStation ON ABDAvailability.AbdStationID = AbdStation.ID
	WHERE        (ABDAvailability.Date  BETWEEN @FromDateTime AND @ToDateTime) 
		AND (@TimeSlotID = 0 OR ABDAvailability.StateTimeSlotID = @TimeSlotID)
		AND (AbdStation.Terminal LIKE @Terminal)
		AND (ISNULL(AbdStation.Area,'') LIKE @Area )
		AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
		AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
		 
		-- AND ABDStation.ID <= 30
	GROUP BY AbdStation.ID, AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea,AbdStation.AbdType,ABDStates.ID, ABDStates.State
	ORDER BY dbo.GetAbdNameOld(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea), ABDStates.State
end

if @IsSearchDateAfterApr = 1
begin
	DECLARE @MyTable TABLE
	(
	AbdStationID int, 
	AbdStationName varchar(50),
	AbdStateID int,
	[State] varchar(50),
	MinutesInState float 
	)    

	DECLARE @MyTableFinal TABLE
	(
	AbdStationNameShort varchar(50),
	AbdStationID int, 
	AbdStationName varchar(50),
	AbdStateID int,
	[State] varchar(50),
	MinutesInState float 
	)  

    insert into @MyTable

	SELECT     AbdStation.ID AS AbdStationID, dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal, AbdStation.Area, AbdStation.SubArea, AbdStation.AbdType) AS AbdStationName, 
		ABDStates.ID AS AbdStateID, ABDStates.State, SUM(ABDAvailability.MinutesInState) as MinutesInState
	FROM         ABDAvailability INNER JOIN
						  ABDStates ON ABDAvailability.ABDStateID = ABDStates.ID INNER JOIN
						  StateTimeSlots ON ABDAvailability.StateTimeSlotID = StateTimeSlots.ID INNER JOIN
						  TimeSlotHourly ON StateTimeSlots.TimeSlotHouryID = TimeSlotHourly.ID LEFT OUTER JOIN
						  AbdStation ON ABDAvailability.AbdStationID = AbdStation.ID
	WHERE        (ABDAvailability.Date  BETWEEN @FromDateTime AND @ToDateTime) 
		AND (@TimeSlotID = 0 OR ABDAvailability.StateTimeSlotID = @TimeSlotID)
		AND (AbdStation.Terminal LIKE @Terminal)
		AND (ISNULL(AbdStation.Area,'') LIKE @Area )
		AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
		AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)

		AND NOT ABDStation.ID in (31, 32, 506)
		--AND ABDStates.ID = 2
	GROUP BY AbdStation.ID, AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea,AbdStation.AbdType,ABDStates.ID, ABDStates.State
	ORDER BY dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area, AbdStation.SubArea, AbdStation.AbdType), ABDStates.State


--select * from @MyTable

--select Max(AbdStationID) as TempAbdStationID, AbdStationName, SUBSTRING(AbdStationName, 12, 3) as AbdStationNameShort from @MyTable
--group by AbdStationName
--having not Max(AbdStationID) in (31, 32, 506)
--order by cast(SUBSTRING(AbdStationName, 12, 3) as int)


DECLARE @MyTableTemp TABLE
(
TempAbdStationID int, 
AbdStationName varchar(50),	 
AbdStationNameShort varchar(50) 
)  

insert into @MyTableTemp
select Max(AbdStationID) as TempAbdStationID, AbdStationName, SUBSTRING(AbdStationName, 12, 3) as AbdStationNameShort from @MyTable
group by AbdStationName
having not Max(AbdStationID) in (31, 32, 506)
order by cast(SUBSTRING(AbdStationName, 12, 3) as int)


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

			WHILE (1=1)
			BEGIN
   
			SELECT @TempAbdStationNameShort = AbdStationNameShort  FROM @MyTB
			WHERE SNo = @Cnt
	    
			IF @@ROWCOUNT = 0
				BREAK

				if exists(select Max(AbdStationID) from @MyTable where cast(SUBSTRING(AbdStationName, 12, 3) as varchar) = cast(@TempAbdStationNameShort as varchar) and AbdStateID = @TempTopABDStateID)
				begin
					  print '@TempAbdStationNameShort =' + cast(@TempAbdStationNameShort as varchar)
					   
					  select @TempMaxAbdStationID = Max(AbdStationID) from @MyTable where cast(SUBSTRING(AbdStationName, 12, 3) as varchar) = cast(@TempAbdStationNameShort as varchar) and AbdStateID = @TempTopABDStateID					 
					  print '@TempMaxAbdStationID =' + cast(@TempMaxAbdStationID as varchar)

					 
					if @TempTopABDStateID = 2
						select 
						@TempMinMinutesInState = isnull(MAX(MinutesInState), 0) 		   
						from @MyTable where cast(SUBSTRING(AbdStationName, 12, 3) as varchar) = cast(@TempAbdStationNameShort as varchar) and SUBSTRING(@TempMaxAbdStationName, 1, 4) = 'STR1' and AbdStateID = @TempTopABDStateID
					  
					else
						select 
						@TempMinMinutesInState = isnull(Min(MinutesInState), 0) 		   
						from @MyTable where cast(SUBSTRING(AbdStationName, 12, 3) as varchar) = cast(@TempAbdStationNameShort as varchar) and SUBSTRING(@TempMaxAbdStationName, 1, 4) = 'STR1' and AbdStateID = @TempTopABDStateID
				 

					  select 		  
					  @TempMaxAbdStationName = AbdStationName,
					  @TempAbdStationID = AbdStationID,
					  @TempAbdStateID = AbdStateID,
					  @TempAbdState = [State]
					  from @MyTable where cast(SUBSTRING(AbdStationName, 12, 3) as varchar) = cast(@TempAbdStationNameShort as varchar) and AbdStationID = @TempMaxAbdStationID and AbdStateID = @TempTopABDStateID


					  print '@TempMaxAbdStationName =' + cast(SUBSTRING(@TempMaxAbdStationName, 1, 4) as varchar)
					  print '@TempMinMinutesInState =' + cast(@TempMinMinutesInState as varchar)

					  print '---------------------------------------------'

					  insert into @MyTableFinal
					  (
							AbdStationNameShort,
							AbdStationID, 
							AbdStationName,
							AbdStateID,
							[State],
							MinutesInState 
					  )
					  values
					  (
					  @TempAbdStationNameShort,
					  @TempMaxAbdStationID,
					  @TempMaxAbdStationName,
					  @TempAbdStateID,
					  @TempAbdState,
					  @TempMinMinutesInState
					  )
				end
 
			SELECT @Cnt = @Cnt + 1
		    print '@@Cnt =' + cast(@Cnt as varchar)
			END
			--2. we check the AbdStationIDs and only keep those ones with largest digital values also we update its MinutesInState which we only keep their lowest values
			--select * from @MyTableFinal
 --end inner lopping
		
SELECT @CntTop = @CntTop + 1
		
END
--end looping through @MyTBState 

select AbdStationID,
AbdStationName,
AbdStateID,
State,
MinutesInState from @MyTableFinal

end







