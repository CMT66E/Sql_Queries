	declare @theXmlData xml
	declare @InstrumentID int = 20608  
	
	SELECT @theXmlData = LicenceXML
	FROM tblOnlinePOEOApplication 
	WHERE OnlinePOEOApplicationID = 68

	DECLARE @theAssessablePollutants xml

--declare @RtnVal int
--Exec @RtnVal = uspSavePOEOAssesablePollutants @theAssessablePollutants, @InstrumentID, 0, 0, 0, 1

	--declare @RtnVal int
	--Exec @RtnVal =  uspSavePOEOMonitoringPointEPABPortal @theXmlData, @InstrumentID

	DECLARE @tblAddressPortal tblAddressType
	DECLARE @tblLocationDetailPortal tblLocationType
	DECLARE @AdditionalAddressInformationPortal VARCHAR(255)
	DECLARE @tblLandTitlePortal tblLandTitleType
	DECLARE @tblLandTitleLGAPortal tblLandTitleLGAType
	DECLARE @tblLandTitleCatchmentPortal tblLandTitleCatchmentType
	DECLARE @tblLandTitleElectoratePortal tblLandTitleElectorateType
    DECLARE @tblLandTitleSubCatchmentPortal tblLandTitleSubCatchmentType
	DECLARE @tblLandTitleDetailPortal tblLandTitleDetailType
	DECLARE @SpatialInfoAvailablePortal BIT
	DECLARE @IsLotDPPortal BIT	  

	INSERT INTO @tblAddressPortal(AddressID
						,Address
						,Suburb
						,Postcode
						,StateCode
						,CreatedBySystemUserID
						,OverseasAddressFlag							
						)
	SELECT   -1 AS AddressID,
				RN.S.value('Address[1]','varchar(100)') AS Address,
				RN.S.value('Suburb[1]','varchar(100)') AS Suburb,
				RN.S.value('Postcode[1]','char(10)') AS Postcode,
				RN.S.value('State[1]','char(20)') AS StateCode,
				1 AS CreatedBySystemUserID,
				0 AS OverseasAddressFlag
	FROM @theXmlData.nodes('/POEOLicence/AppplicationPoint/NoisePoints/POEOLicenceNoisePoint/NoiseLocation/Address') AS RN(S)

	select * from @tblAddressPortal

	SELECT @AdditionalAddressInformationPortal = RN.S.value('AdditionalInfo[1]','varchar(1000)') 
			FROM @theXmlData.nodes('/POEOLicence/AppplicationPoint/NoisePoints/POEOLicenceNoisePoint/NoiseLocation/Address') AS RN(S) 

	INSERT INTO @tblLocationDetailPortal(LocationID
						,LocationName
						,AddressID
						,PremisesFlag
						,AdditionalAddressInformation
						,CreatedBySystemUserID
						,InstrumentID)
	SELECT  -1 AS LocationID,
			--RN.S.value('Name[1]','varchar(128)') AS LocationName, 
			RN.S.value('Description[1]','varchar(128)') AS LocationName,
		   -88 AS AddressID,
			1 AS PremisesFlag,
		    @AdditionalAddressInformationPortal AS AdditionalAddressInformation,		 
			1 AS CreatedBySystemUserID,
		   -1 AS InstrumentID			 
    FROM @theXmlData.nodes('/POEOLicence/AppplicationPoint/NoisePoints/POEOLicenceNoisePoint/NoiseLocation') AS RN(S)

	select * from @tblLocationDetailPortal

	SELECT @SpatialInfoAvailablePortal =   RN.S.value('SpatialInfoAvailable[1]','BIT') 	,
			@IsLotDPPortal =   RN.S.value('IsLotDP[1]','BIT')
			FROM @theXmlData.nodes('/POEOLicence/AppplicationPoint/NoisePoints/POEOLicenceNoisePoint/NoiseLocation') AS RN(S) 

print '@SpatialInfoAvailablePortal=' + cast(@SpatialInfoAvailablePortal as varchar)
print '@IsLotDPPortal=' + cast(@IsLotDPPortal as varchar)

	IF @SpatialInfoAvailablePortal = 1 and  @IsLotDPPortal = 1
	BEGIN
				INSERT INTO @tblLandTitleDetailPortal(LandTitleID
				,LocationID
				,IdentifiedByLotDPFlag
				,SpatialInfoAvailable
				,LotNumber
				,DPNumber
				,SectionNumber
				,Easting
				,Northing
				,ZoneNumber
				,CreatedBySystemUserID
				,PartLotFlag
				,LGA
				,LBLCatchment
				,Electorate
				)
				
	            SELECT -1 AS LandTitleID,
				-1 AS LocationID,
				0 AS IdentifiedByLotDPFlag,
 				0 AS PartLotFlag,
				RN.S.value('Lot[1]', 'varchar(20)') AS LotNumber,
				RN.S.value('DP[1]', 'bigint') AS DPNumber,
				RN.S.value('SectionNumber[1]', 'varchar(20)') AS SectionNumber,
				RN.S.value('Easting[1]', 'int') AS Easting,
				RN.S.value('Northing [1]','int') AS Northing,
				RN.S.value('ZoneNumber[1]', 'int') AS ZoneNumber,
				1 AS CreatedBySystemUserID,
				0,
				RN.S.value('LGA[1]', 'varchar(200)') AS LGA,
				RN.S.value('LBLCatchment[1]', 'varchar(200)') AS LBLCatchment,
				RN.S.value('Electorate[1]', 'varchar(200)') AS Electorate
			    FROM @theXmlData.nodes('/POEOLicence/AppplicationPoint/NoisePoints/POEOLicenceNoisePoint/NoiseLocation/LotDPs/LocationSpatialLotDP') AS RN(S)
	END

	select * from @tblLandTitleDetailPortal

	IF @SpatialInfoAvailablePortal = 1 and  @IsLotDPPortal = 0
	BEGIN
				INSERT INTO @tblLandTitleDetailPortal(LandTitleID
				,LocationID
				,IdentifiedByLotDPFlag
				,SpatialInfoAvailable
				,LotNumber
				,DPNumber
				,SectionNumber
				,Easting
				,Northing
				,ZoneNumber
				,CreatedBySystemUserID
				,PartLotFlag
				,LGA
				,LBLCatchment
				,Electorate
				)
				
		    SELECT -1 AS LandTitleID,
				-1 AS LocationID,
				@IsLotDPPortal AS IdentifiedByLotDPFlag,
 				@SpatialInfoAvailablePortal AS PartLotFlag,
				RN.S.value('Lot[1]', 'varchar(20)') AS LotNumber,
				RN.S.value('DP[1]', 'bigint') AS DPNumber,
				RN.S.value('SectionNumber[1]', 'varchar(20)') AS SectionNumber,
				RN.S.value('Easting[1]', 'int') AS Easting,
				RN.S.value('Northing [1]','int') AS Northing,
				RN.S.value('ZoneNumber[1]', 'int') AS ZoneNumber,
				1 AS CreatedBySystemUserID,
				0,
				RN.S.value('LGA[1]', 'varchar(200)') AS LGA,
				RN.S.value('LBLCatchment[1]', 'varchar(200)') AS LBLCatchment,
				RN.S.value('Electorate[1]', 'varchar(200)') AS Electorate
			FROM @theXmlData.nodes('/POEOLicence/AppplicationPoint/NoisePoints/POEOLicenceNoisePoint/NoiseLocation/SpatialEasting') AS RN(S)
	END

	DECLARE @AddrIDPortal INT
	DECLARE @LocIDPortal INT
	Exec @AddrIDPortal = uspSaveAddress @tblAddressPortal
	IF @AddrIDPortal < 0 RAISERROR ('Problem saving uspSaveAddress' , 16, 1)

	INSERT INTO tblLocation(LocationName
				,AddressID
				,PremisesFlag
				,AdditionalAddressInformation
				,EffectiveDateFrom
				,DateCreated
				,CreatedBySystemUserID)
	Select		 LocationName
			,@AddrIDPortal
			,PremisesFlag
			,AdditionalAddressInformation
			,GETDATE()
			,GETDATE()
			,CreatedBySystemUserID
	From @tblLocationDetailPortal

	SET @LocIDPortal = (SELECT @@IDENTITY)	

	print '@LocIDPortal=' + cast(@LocIDPortal as varchar)

 	IF @InstrumentID >0
 	BEGIN
 	--   SELECT @Cnt=0
 	--   SELECT @Cnt = COUNT(*) FROM tblPOEOLicenceNoisePoint WHERE InstrumentID = @InstrumentID
 		      
 	--   IF @Cnt = 0
 			--SELECT @PointNo=1
 	--   ELSE
	    DECLARE @NoisePointTypeID INT
	    SELECT @NoisePointTypeID = RN.S.value('NoisePointTypeId[1]','int')  FROM @theXmlData.nodes('/POEOLicence/AppplicationPoint/NoisePoints/POEOLicenceNoisePoint') AS RN(S)
 		DECLARE @NoisePointNoPortal INT 
		DECLARE @PointNoPortal INT
 		      
 		SELECT @NoisePointNoPortal = ISNULL(MAX(PointNo),0) FROM tblPOEOLicenceNoisePoint WHERE InstrumentID = @InstrumentID
		SELECT @PointNoPortal = ISNULL(Max(PointNo),0) FROM tblPOEOLicencePoint WHERE InstrumentID = @InstrumentID
			  
		IF (@NoisePointNoPortal > @PointNoPortal)
			SELECT @PointNoPortal = @NoisePointNoPortal + 1
		ELSE
		    SELECT @PointNoPortal = @PointNoPortal + 1
		      
		--- PALMS V3.0		  
 		INSERT INTO tblPOEOLicenceNoisePoint(
					InstrumentID
					,PointNo
					,LocationID
					,DateCreated
					,CreatedBySystemUserID
					,NoisePointTypeID)
		VALUES(@InstrumentID
			,@PointNoPortal
			,@LocIDPortal
			,GETDATE()     
			,1                           --CreatedBySystemUserID
			,@NoisePointTypeID)					 			  
 	END

	

	select * from tblClassification where ClassificationDomainID = 67

     SELECT * FROM tblPOEOLicenceNoisePoint LP
     INNER JOIN tblLocation Loc ON Loc.LocationID = LP.LocationID AND Loc.PremisesFlag=0
     WHERE LP.InstrumentID = 20603

	 select * from tblPOEOLicenceNoisePoint where   InstrumentID = 20603 
	 select * from tblLocation where LocationID in (7269, 7270, 7271)