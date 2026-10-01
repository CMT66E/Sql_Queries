DECLARE @MyTable TABLE
	(
	SNo int IDENTITY(1,1), 
	ABDStationID int,
	ABD_Reached_Date datetime
	)    
INSERT INTO @MyTable(ABDStationID, ABD_Reached_Date)	    
select   [ABDStationID],
      max([Date]) as ABD_Reached_Date 
FROM ABDAvailability INNER JOIN AbdStation on ABDAvailability.[ABDStationID] = AbdStation.ID
group by [ABDStationID]
order by   max([Date]) desc

--select * from @MyTable
	
declare @Cnt int
SELECT @Cnt = MIN(Sno) FROM @MyTable
	
declare @TempABDStationID int
declare @TempABD_Reached_Date datetime

declare @TempABDAvailabilityID int

WHILE (1=1)
BEGIN
   
SELECT @TempABDStationID = ABDStationID, @TempABD_Reached_Date = ABD_Reached_Date FROM @MyTable
WHERE SNo = @Cnt
	    
IF @@ROWCOUNT = 0
	BREAK

	--if exists(select ID from ABDAvailability where cast(ABDStationID as varchar) = cast(@TempABDStationID as varchar) and [Date] = @TempABD_Reached_Date)
	--begin
	      select @TempABDAvailabilityID = ID from ABDAvailability where cast(ABDStationID as varchar) = cast(@TempABDStationID as varchar) and [Date] = @TempABD_Reached_Date
		  print '@Cnt =' + cast(@Cnt as varchar)
		 
		  if (cast(cast(@TempABD_Reached_Date as date) as varchar) <= '2022-07-11' OR cast(cast(@TempABD_Reached_Date as date) as varchar) <= '2022-04-01')
		  begin
			print '@TempABD_Reached_Date =' + cast(cast(@TempABD_Reached_Date as date) as varchar)
			update ABDAvailability set [date] = '2022-04-30' where ID = @TempABDAvailabilityID
		  end
			
		  print '@TempABDAvailabilityID =' + cast(@TempABDAvailabilityID as varchar)
		  print '@TempABDStationID =' + cast(@TempABDStationID as varchar)
		  print '---------------------------------------------'
	--end

		
SELECT @Cnt = @Cnt + 1
		
END