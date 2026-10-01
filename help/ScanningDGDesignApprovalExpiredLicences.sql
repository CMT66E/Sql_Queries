

declare @RtnVal int
declare @UpdatingUser int

SELECT @RtnVal = 0
SELECT @UpdatingUser = 1

--Looping starts
DECLARE @InstrumentID INT
set @InstrumentID = 0

DECLARE @Cnt INT
DECLARE @MyTable TABLE
	(
	SNo int IDENTITY(1,1), 
	InstrumentID int
	)    
 
INSERT INTO @MyTable(InstrumentID)
select A.InstrumentID from tblDGDesignApproval a inner join tblInstrument b on a.InstrumentID = b.InstrumentID 
where ExpiryDate < getdate() and b.InstrumentStatusID = 755
	
SELECT @Cnt = MIN(Sno) FROM @MyTable
	
WHILE (1=1)
BEGIN
   
SELECT @InstrumentID = InstrumentID FROM @MyTable
WHERE SNo = @Cnt
	    
IF @@ROWCOUNT = 0
	BREAK

	UPDATE tblInstrument SET
		InstrumentStatusID = 816,		 
		DateUpdated = Getdate(),
		UpdatedBySystemUserID = @UpdatingUser 
	WHERE InstrumentID = @InstrumentID

	EXEC @RtnVal = uspAuditLogInsert @InstrumentID,'DG Design Approval Expired','DG Design Approval Expired Set by System Auto Checking Process', @UpdatingUser, @UpdatingUser, 1	

	print '@InstrumentID=' + cast(@InstrumentID as varchar)

SELECT @Cnt = @Cnt + 1
		
END
--Looping ends



