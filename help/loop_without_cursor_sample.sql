DECLARE @MyTable TABLE
	(
	SNo int IDENTITY(1,1), 
	AddressID int,
	ROW_ID int
	)    
INSERT INTO @MyTable(AddressID, ROW_ID)	    
SELECT AddressID, ROW_ID
FROM [tblAddress]
WHERE datepart(day, DateCreated) = 22 and datepart(month, DateCreated) = 10 and datepart(year, DateCreated) = 2015

--select * from @MyTable
	
declare @Cnt int
SELECT @Cnt = MIN(Sno) FROM @MyTable
	
declare @TempAddressID int
declare @TempROW_ID int

WHILE (1=1)
BEGIN
   
SELECT @TempAddressID = AddressID, @TempROW_ID = ROW_ID FROM @MyTable
WHERE SNo = @Cnt
	    
IF @@ROWCOUNT = 0
	BREAK



	if exists(select * from tblContact where cast(AddressID as varchar) = cast(@TempROW_ID as varchar))
	begin
		--print 'addressID =' + cast(@TempAddressID as varchar)
		--print '@TempROW_ID =' + cast(@TempROW_ID as varchar)
		--print '---------------------------------------------'

	   Update tblContact set AddressID = @TempAddressID where cast(AddressID as varchar) = cast(@TempROW_ID as varchar)  
	end

	--UPDATE tblContact SET
	--	AddressID = @TempAddressID,		 
	--WHERE ROW_ID = @TempROW_ID
		
SELECT @Cnt = @Cnt + 1
		
END

--=============================ANOTHER GOOD LOOP SAMPLE ================================================
WHILE (SELECT COUNT(*) FROM @TempRadiationLicenceRRM WHERE RecordMode = 'A' AND NewRadiationLicenceRRMID IS NULL) > 0
BEGIN
	Select Top 1 @RowID = RadiationLicenceRRMID FROM @TempRadiationLicenceRRM WHERE RecordMode = 'A' AND NewRadiationLicenceRRMID IS NULL

	INSERT INTO [dbo].[tblRadiationLicenceRRM]
		([RRMStatusID]
		,[RRMTypeID]
		,[RRMPurposeID]
		,[RRMID]
		,[WorkArea]
		,[RRMSecurityClassificationID]
		,[LaboratoryClassificationID]
		,[DateCreated]
		,[CreatedBySystemUserID]
		,[RRMDepartmentID])
	SELECT 
		RRMStatusID,
		RRMTypeID,
		RRMPurposeID,
		RRMID,
		WorkArea,
		RRMSecurityClassificationID,
		LaboratoryClassificationID,
		GETDATE(),
		CreatedBySystemUserID,
		(case RRMDepartmentID when null  then null when 0 then null else RRMDepartmentID end) as RRMDepartmentID									
	FROM @TempRadiationLicenceRRM
		WHERE RadiationLicenceRRMID = @RowID

	SET @RadiationLicenceRRMID= @@IDENTITY

	UPDATE @TempRadiationLicenceRRM								
	SET NewRadiationLicenceRRMID = @RadiationLicenceRRMID
	WHERE RadiationLicenceRRMID = @RowID
									 
	UPDATE @TempRadiationLicenceRRMComponent
	SET RadiationLicenceRRMID = @RadiationLicenceRRMID
	WHERE RadiationLicenceRRMID = @RowID
END

