
declare @DataDeleteDate datetime = '2021-02-12'

DECLARE @MyTable TABLE
	(
	SNo int IDENTITY(1,1), 
	ID int 
	)    
INSERT INTO @MyTable(ID)	    
SELECT ID 
FROM AbdStation
 
--select * from @MyTable
	
declare @Cnt int
SELECT @Cnt = MIN(Sno) FROM @MyTable
	
declare @TempStationID int
 
WHILE (1=1)
BEGIN
   
SELECT @TempStationID = ID FROM @MyTable
WHERE SNo = @Cnt
	    
IF @@ROWCOUNT = 0
	BREAK



	if exists(select * from ABDAvailability where cast(ABDStationID as varchar) = cast(@TempStationID as varchar))
	begin


		select * from ABDAvailability where ID in
		(
		SELECT        TOP (12) ID 
		FROM            ABDAvailability
		WHERE  (CAST([Date] AS Date) = @DataDeleteDate) and ABDStationID = @TempStationID and StateTimeSlotID = 24
		ORDER by ID DESC
		)	 
		
		if @@ROWCOUNT > 0
		begin
			print '---------------------------------------------'
			print '@ABDStationID =' + cast(@TempStationID as varchar)
			print '---------------------------------------------'
			delete from ABDAvailability where ID in 
			(
				SELECT        TOP (6) ID 
				FROM            ABDAvailability
				WHERE  (CAST([Date] AS Date) = @DataDeleteDate) and ABDStationID = @TempStationID and StateTimeSlotID = 24
				ORDER by ID DESC		
			)
		end
		else
		    print '@ABDStationID no records =' + cast(@TempStationID as varchar)
	end
 
SELECT @Cnt = @Cnt + 1
		
END