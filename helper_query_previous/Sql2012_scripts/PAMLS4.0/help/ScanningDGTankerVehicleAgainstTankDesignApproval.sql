declare @outErrorMsg VARCHAR(5000)
declare @Temp VARCHAR(5000)
set @Temp = ''

declare @VehicleGeneralText varchar(100)
set @VehicleGeneralText = ''

declare @TankerTypeText varchar(50)
set @TankerTypeText = ''

declare @RtnVal int
declare @UpdatingUser int

SELECT @RtnVal = 0
SELECT @UpdatingUser = 1

--Looping starts
declare @InstrumentID INT
set @InstrumentID = 5058735

declare @DGVehicleID INT
set @DGVehicleID = 0

declare @Cnt INT
declare @MyTable TABLE
	(
	SNo int IDENTITY(1,1), 
	DGVehicleID int
	)    
 
INSERT INTO @MyTable(DGVehicleID)
select [DGVehicleID] from tblDGLicenceVehicle where InstrumentID = @InstrumentID
	
SELECT @Cnt = MIN(Sno) FROM @MyTable
	
WHILE (1=1)
BEGIN
   
SELECT @DGVehicleID = DGVehicleID FROM @MyTable
WHERE SNo = @Cnt
	    
	IF @@ROWCOUNT = 0
		BREAK

		--get current DGVehicle tanker type texts 
		SELECT @TankerTypeText =isnull(C.[Description], '')      
		FROM [dbo].[tblDGVehicle] A 		 
		INNER JOIN tblClassification C ON A.TankerTypeID = C.ClassificationID
		WHERE A.DGVehicleID = @DGVehicleID

		if len(@TankerTypeText) > 0 
		   set @VehicleGeneralText = 'VehicleID: ' + cast(@DGVehicleID as varchar) + ' | Tank type: ' + @TankerTypeText
		else
		   set @VehicleGeneralText = 'VehicleID: ' + cast(@DGVehicleID as varchar)
		 

	    if not exists(SELECT [DGVehicleID]      
                      FROM [dbo].[tblDGVehicle] A INNER JOIN tblDGDesignApproval B ON A.TankerTypeID = B.TankerTypeID
                      WHERE A.DGVehicleID = @DGVehicleID and A.RegistrationState = B.DesignApprovalState)
			SET @Temp = @Temp + '<br>' + 'Tanker vehicle validation failed because the tanker type of this vehicle (' + @VehicleGeneralText + ') do not match design approval.
'  	

	    if not exists(SELECT [DGVehicleID]      
                      FROM [dbo].[tblDGVehicle] A INNER JOIN tblDGDesignApproval B ON A.TankerTypeID = B.TankerTypeID
                      WHERE A.DGVehicleID = @DGVehicleID and A.RegistrationState = B.DesignApprovalState and A.Capacity < B.Capacity * 1.1)
			SET @Temp = @Temp + '<br>' + 'Tanker vehicle validation failed because the capacity of this tanker vehicle (' + @VehicleGeneralText + ') should be within 10% of the approved capacity' 
        
		if not exists(select InstrumentID from [tblDGVehicle] A INNER JOIN tblDGDesignApproval B ON A.TankerTypeID = B.TankerTypeID where A.DGVehicleID = @DGVehicleID and A.RegistrationState = B.DesignApprovalState and B.VINNumber is null)
		begin
	        if not exists(SELECT [DGVehicleID]      
                      FROM [dbo].[tblDGVehicle] A INNER JOIN tblDGDesignApproval B ON A.TankerTypeID = B.TankerTypeID
                      WHERE A.DGVehicleID = @DGVehicleID and A.RegistrationState = B.DesignApprovalState and isnull(A.VINNumber, '') = isnull(B.VINNumber, '')) 
			SET @Temp = @Temp + '<br>' + 'Tanker vehicle validation failed because the VIN of this tanker vehicle (' + @VehicleGeneralText + ') has to match the approved VIN in Tanker Design Approval' 
		end

        --print '------------------------------------------------'
		--print '@DGVehicleID=' + cast(@DGVehicleID as varchar)
		--print '@Temp=' + cast(@Temp as varchar(5000))
		--print '------------------------------------------------'

		--Get tblDGVehicleClass checking against the tblDGDesignApprovalClassUN
		--1. [VehicleClassID] checking according to the function specification: For all records related to the vehicle in tblDGVehicleClass, if VehicleClassID is not null, then, for each record, VehicleClassID must equal one of the tblDGDesignApprovalClass.ClassificationID values for the design approval.
		--we need looping through the whole VehicleClassID list
		declare @VehicleClassID int
		set @VehicleClassID = 0

		declare @Cnt1 INT
		declare @MyTable1 TABLE
			(
			SNo int IDENTITY(1,1), 
			VehicleClassID int
			)    
		INSERT INTO @MyTable1(VehicleClassID)
		select [VehicleClassID] from tblDGVehicleClass where [DGVehicleID] = @DGVehicleID AND [UNNumberID] is null 
	
		SELECT @Cnt1 = MIN(Sno) FROM @MyTable1
	
		WHILE (1=1)
		BEGIN
   
		SELECT @VehicleClassID = VehicleClassID FROM @MyTable1
		WHERE SNo = @Cnt1
	    
			IF @@ROWCOUNT = 0
				BREAK

			IF not exists(SELECT DGClassID FROM tblDGDesignApprovalClassUN WHERE InstrumentID = 
							(SELECT DISTINCT B.InstrumentID 
							FROM [dbo].[tblDGVehicle] A INNER JOIN tblDGDesignApproval B ON A.TankerTypeID = B.TankerTypeID
							WHERE A.DGVehicleID = @DGVehicleID and A.RegistrationState = B.DesignApprovalState)
							AND  DGClassID = @VehicleClassID)
			    SET @Temp = @Temp + '<br>' + 'Tanker vehicle validation failed because the VehicleClassID of this tanker vehicle (' + @VehicleGeneralText + ' | VehicleClassID: ' + cast(@VehicleClassID as varchar) + ' ) has to match the approved VehicleClassID in Tanker Design Approval' 

			SELECT @Cnt1 = @Cnt1 + 1
		
		END

		--2. [UNNumberID] checking according to the function specification: For all records related to the vehicle in tblDGVehicleClass, if UNNumberID is not null, then, for each record, UNNumberID must equal one of the tblDGDesignApprovalClass. UNNumberID values for the design approval.
		--we need looping through the whole UNNumberID list
		declare @UNNumberID int
		set @UNNumberID = 0

		declare @Cnt2 INT
		declare @MyTable2 TABLE
			(
			SNo int IDENTITY(1,1), 
			UNNumberID int
			)    
		INSERT INTO @MyTable2(UNNumberID)
		select [UNNumberID] from tblDGVehicleClass where [DGVehicleID] = @DGVehicleID AND [VehicleClassID] is null 
	
		SELECT @Cnt2 = MIN(Sno) FROM @MyTable2
	
		WHILE (1=1)
		BEGIN
   
		SELECT @UNNumberID = UNNumberID FROM @MyTable2
		WHERE SNo = @Cnt2
	    
			IF @@ROWCOUNT = 0
				BREAK

			IF not exists(SELECT DGUNNumberID FROM tblDGDesignApprovalClassUN WHERE InstrumentID = 
							(SELECT DISTINCT B.InstrumentID 
							FROM [dbo].[tblDGVehicle] A INNER JOIN tblDGDesignApproval B ON A.TankerTypeID = B.TankerTypeID
							WHERE A.DGVehicleID = @DGVehicleID and A.RegistrationState = B.DesignApprovalState)
							AND  DGUNNumberID = @UNNumberID)
			    SET @Temp = @Temp + '<br>' + 'Tanker vehicle validation failed because the UNNumberID of this tanker vehicle (' + @VehicleGeneralText + ' | UNNumberID: ' + cast(@UNNumberID as varchar) + ') has to match the approved UNNumberID in Tanker Design Approval' 

			SELECT @Cnt2 = @Cnt2 + 2
		
		END

		--3. [DGVehicleMakeID] checking according to the function specification: If tblDGDesignApprovalVehicleMake.VehicleMakeID not null, tblDGVehicle.VehicleMakeID must equal one of the DGVehicleMakeID values for the design approval
		declare @DGVehicleMakeID int
		set @DGVehicleMakeID = 0

		declare @Cnt3 INT
		declare @MyTable3 TABLE
			(
			SNo int IDENTITY(1,1), 
			DGVehicleMakeID int
			)    
		INSERT INTO @MyTable3(DGVehicleMakeID)
		select [DGVehicleMakeID] from tblDGVehicle where [DGVehicleID] = @DGVehicleID 
	
		SELECT @Cnt3 = MIN(Sno) FROM @MyTable3
	
		WHILE (1=1)
		BEGIN
   
		SELECT @DGVehicleMakeID = isnull(DGVehicleMakeID, 0) FROM @MyTable3
		WHERE SNo = @Cnt3
	    
			IF @@ROWCOUNT = 0
				BREAK

            IF exists(SELECT * FROM tblDGDesignApprovalVehicleMake WHERE InstrumentID = 
							(SELECT DISTINCT B.InstrumentID 
							FROM [dbo].[tblDGVehicle] A INNER JOIN tblDGDesignApproval B ON A.TankerTypeID = B.TankerTypeID
							WHERE A.DGVehicleID = @DGVehicleID and A.RegistrationState = B.DesignApprovalState and DGVehicleMakeID is not null))
		    begin
			    IF not exists(SELECT DGVehicleMakeID FROM tblDGDesignApprovalVehicleMake WHERE InstrumentID = 
							(SELECT DISTINCT B.InstrumentID 
							FROM [dbo].[tblDGVehicle] A INNER JOIN tblDGDesignApproval B ON A.TankerTypeID = B.TankerTypeID
							WHERE A.DGVehicleID = @DGVehicleID and A.RegistrationState = B.DesignApprovalState) AND DGVehicleMakeID = @DGVehicleMakeID)
			    SET @Temp = @Temp + '<br>' + 'Tanker vehicle validation failed because the DGVehicleMakeID of this tanker vehicle (' + @VehicleGeneralText + ' | DGVehicleMakeID: ' + cast(@DGVehicleMakeID as varchar) + ') has to match the approved DGVehicleMakeID in Tanker Design Approval' 

		    end
			SELECT @Cnt3 = @Cnt3 + 3
		
		END

		--4. [DGTankMakeID] checking according to the function specification: If tblDGDesignApprovalTankMake.TankMakeID not null, tblDGVehicle.TankMakeID must equal one of the DGTankMakeID values for the design approval.
		declare @DGTankMakeID int
		set @DGTankMakeID = 0

		declare @Cnt4 INT
		declare @MyTable4 TABLE
			(
			SNo int IDENTITY(1,1), 
			DGTankMakeID int
			)    
		INSERT INTO @MyTable4(DGTankMakeID)
		select [DGTankMakeID] from tblDGVehicle where [DGVehicleID] = @DGVehicleID 
	
		SELECT @Cnt4 = MIN(Sno) FROM @MyTable4
	
		WHILE (1=1)
		BEGIN
   
		SELECT @DGTankMakeID = isnull(DGTankMakeID, 0) FROM @MyTable4
		WHERE SNo = @Cnt4
	    
			IF @@ROWCOUNT = 0
				BREAK

            IF exists(SELECT * FROM tblDGDesignApprovalTankMake WHERE InstrumentID = 
							(SELECT DISTINCT B.InstrumentID 
							FROM [dbo].[tblDGVehicle] A INNER JOIN tblDGDesignApproval B ON A.TankerTypeID = B.TankerTypeID
							WHERE A.DGVehicleID = @DGVehicleID and A.RegistrationState = B.DesignApprovalState and DGTankMakeID is not null))
		    begin
			    IF not exists(SELECT DGTankMakeID FROM tblDGDesignApprovalTankMake WHERE InstrumentID = 
							(SELECT DISTINCT B.InstrumentID 
							FROM [dbo].[tblDGVehicle] A INNER JOIN tblDGDesignApproval B ON A.TankerTypeID = B.TankerTypeID
							WHERE A.DGVehicleID = @DGVehicleID and A.RegistrationState = B.DesignApprovalState) AND DGTankMakeID = @DGTankMakeID) 
			    SET @Temp = @Temp + '<br>' + 'Tanker vehicle validation failed because the DGTankMakeID of this tanker vehicle (' + @VehicleGeneralText + ' | DGTankMakeID: ' + cast(@DGTankMakeID as varchar) + ') has to match the approved DGTankMakeID in Tanker Design Approval' 
			end

			SELECT @Cnt4 = @Cnt4 + 4
		
		END

		--5. DGTanker Year checking: tblInstrument.DateIssued (year) <=  tblDGVehicle.TankYear <= tblDGDesignApproval.ExpiryDate (year)
		declare @TankYear varchar(4)
		set @TankYear = ''
		declare @Cnt5 INT
		declare @MyTable5 TABLE
			(
			SNo int IDENTITY(1,1), 
			TankYear varchar(4)
			)    
		INSERT INTO @MyTable5(TankYear)
		select TankYear from tblDGVehicle where [DGVehicleID] = @DGVehicleID and isnull(TankYear, '') <> ''
	
		SELECT @Cnt5 = MIN(Sno) FROM @MyTable5
	
		WHILE (1=1)
		BEGIN
   
		SELECT @TankYear = TankYear FROM @MyTable5
		WHERE SNo = @Cnt5
	    
			IF @@ROWCOUNT = 0
				BREAK
			
            IF @TankYear<> ''
			BEGIN
			    DECLARE @ExpiryDate datetime

				IF exists(SELECT * FROM [dbo].[tblDGVehicle] A INNER JOIN tblDGDesignApproval B ON A.TankerTypeID = B.TankerTypeID
								WHERE A.DGVehicleID = @DGVehicleID and A.RegistrationState = B.DesignApprovalState and ExpiryDate is not null)
				begin
				    select @ExpiryDate = ExpiryDate from [dbo].[tblDGVehicle] A INNER JOIN tblDGDesignApproval B ON A.TankerTypeID = B.TankerTypeID
								WHERE A.DGVehicleID = @DGVehicleID and A.RegistrationState = B.DesignApprovalState and ExpiryDate is not null
                    
					--here we get the year part of ExpiryDate
					declare @ExpiryYear int
                    select @ExpiryYear = datepart(year, @ExpiryDate)

					if (cast(@TankYear as int) > @ExpiryYear)
					      SET @Temp = @Temp + '<br>' + 'Tanker vehicle validation failed because the tanker year of this tanker vehicle (' + @VehicleGeneralText + ' | TankYear: ' + cast(@TankYear as varchar) + ') has to less or equal the approved expiry date year (' + cast(@ExpiryYear as varchar) + ') in Tanker Design Approval'                     
				end

				if exists(select InstrumentID from tblInstrument where InstrumentID = @InstrumentID and DateIssued is not null)
				begin 
					    DECLARE @DateIssued datetime
						select @DateIssued = DateIssued from tblInstrument where InstrumentID = @InstrumentID and DateIssued is not null
					    declare @DateIssuedYear int
                        select @DateIssuedYear = datepart(year, @DateIssued)
						
						if (@DateIssuedYear > cast(@TankYear as int))
					      SET @Temp = @Temp + '<br>' + 'Tanker vehicle validation failed because the tanker year of this tanker vehicle (' + @VehicleGeneralText + ' | TankYear: ' + cast(@TankYear as varchar) + ')  has to greater or equal the approved date issued year (' + cast(@DateIssuedYear as varchar) + ') in Tanker Design Approval' 
				end
			END
			SELECT @Cnt5 = @Cnt5 + 5
		
		END

        print '------------------------------------------------'
		print '@DGVehicleID=' + cast(@DGVehicleID as varchar)
		print '@Temp=' + cast(@Temp as varchar(5000))
		print '------------------------------------------------'

    --Top level loop count increasing 
	SELECT @Cnt = @Cnt + 1
		
END
--Looping ends



