DECLARE @MyTable TABLE
	(
	SNo int IDENTITY(1,1), 
	ABDStationID int,
	LastProcessedID bigint
	)    
INSERT INTO @MyTable(ABDStationID, LastProcessedID)	    
SELECT 
AbdStationID ,
ISNULL(MAX(ID),0) AS LastProcessedID 
FROM dbo.AbdStateHistory
group by AbdStationID 

--select * from @MyTable
	
declare @Cnt int
SELECT @Cnt = MIN(Sno) FROM @MyTable
	
declare @TempABDStationID int
declare @TempLastProcessedID bigint

declare @TempLocalTime datetime

WHILE (1=1)
BEGIN
   
SELECT @TempABDStationID = ABDStationID, @TempLastProcessedID = LastProcessedID FROM @MyTable
WHERE SNo = @Cnt
	    
IF @@ROWCOUNT = 0
	BREAK

	if exists(select ID from AbdStateHistory where cast(ABDStationID as varchar) = cast(@TempABDStationID as varchar) and ID = @TempLastProcessedID)
	begin
	      select @TempLocalTime = LocalTime from AbdStateHistory where cast(ABDStationID as varchar) = cast(@TempABDStationID as varchar) and ID = @TempLastProcessedID
		  print '@Cnt =' + cast(@Cnt as varchar)
		 
		  if (cast(cast(@TempLocalTime as date) as varchar) <= '2022-06-08')
		  begin
			print '@TempLocalTime =' + cast(cast(@TempLocalTime as date) as varchar)
			--update AbdStateHistory set [LocalTime] = '2022-06-08' where ID = @TempLastProcessedID
		  end
			
		  print '@TempLastProcessedID =' + cast(@TempLastProcessedID as varchar)
		  print '@TempABDStationID =' + cast(@TempABDStationID as varchar)
		  print '---------------------------------------------'
	end

		
SELECT @Cnt = @Cnt + 1
		
END