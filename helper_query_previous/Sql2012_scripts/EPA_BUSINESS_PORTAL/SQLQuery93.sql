	--declare @theXmlData xml
	--declare @InstrumentID int = 20600  
	
	--SELECT @theXmlData = LicenceXML
	--FROM tblOnlinePOEOApplication 
	--WHERE OnlinePOEOApplicationID = 68


	DECLARE @POEOApplicationid INT
	set @POEOApplicationid = 68

    DECLARE	 @theXmlData xml
	DECLARE @theAssessablePollutants xml

	DECLARE @tblPOEO tblPOEOType
	DECLARE @tblInstrument tblInstrumentType
	DECLARE @tblAccountableParty tblInstrumentAccountablePartyType
	DECLARE @tblContact tblInstrumentContactType
	DECLARE @tblLocation tblInstrumentLocationType
	DECLARE @tblFeeBasedActivity tblPOEOFeeBasedActivityType
	DECLARE	@InstrumentID Int
	DECLARE	@TInstrumentID Int
    DECLARE @RtnVal int
    DECLARE @TempRowTimeStamp varchar(4000)
    DECLARE @RowTimeStamp varchar(4000)
	DECLARE @INSERT bit	
	DECLARE @Cnt as int
	DECLARE @CntFeeBasedActivity as int
	DECLARE @POEOFeeBasedActivityID as int
	DECLARE @LocNameExists as bit=0
	DECLARE @RowAction char(1)
	DECLARE @CreatedBySystemUserID int
	DECLARE @UpdatedBySystemUserID int
	DECLARE @TempRiskFlag bit
	DECLARE @POEORiskFlag bit
	DECLARE @AuditLogMsg varchar(400)
	DECLARE @Coastal bit
	DECLARE @Enclosed bit
	DECLARE @Estuarine bit
	
	--PALMS V5.2
	DECLARE @PIRMPinPlaceFlag	BIT
	DECLARE @PIRMPLastTestedDate SMALLDATETIME
	--DECLARE @PIRMPLastUpdatedDate SMALLDATETIME

	DECLARE @tblPOEOLicenceEnvironmentalRiskLevelType tblPOEOLicenceEnvironmentalRiskLevelType


	--------------------------------------------

	DECLARE @LicenceTypeID INT
	DECLARE @ApplicantTypeID INT
	DECLARE @tblAccountablePartyDetailType tblAccountablePartyDetailType
	DECLARE @tblContactDetailType tblContactDetailType

	DECLARE @tblPOEOAncillaryActivity  tblPOEOFeeBasedActivityType

	

	SELECT @theXmlData = LicenceXML
	FROM tblOnlinePOEOApplication 
	WHERE OnlinePOEOApplicationID = 	@POEOApplicationid


	SELECT @LicenceTypeID  = RN.S.value('LicenceTypeID[1]','int')	,
		   @ApplicantTypeID  = RN.S.value('ApplicantTypeID[1]','int')	
   FROM @theXmlData.nodes('/POEOLicence') AS RN(S)

   select 	 @LicenceTypeID

   if @LicenceTypeID = 1103
   BEGIN
	   
				 SELECT -1 AS POEOLicenceFeeBasedActivityID,
			   0 AS InstrumentID,
			   RN.S.value('FeeBasedActivityId[1]','int') AS FeeBasedActivityID,
			   RN.S.value('FeeBasedActivityScaleId[1]','int') AS FeeBasedActivityScaleID

		FROM @theXmlData.nodes('/POEOLicence/NonScheduledActivityList/POEONonScheduledActivity') AS RN(S)

		   INSERT INTO @tblFeeBasedActivity(
						POEOLicenceFeeBasedActivityID,
									 InstrumentID,
									 FeeBasedActivityID,
									 FeeBasedActivityScaleID,
									  Action,
									  PrimaryFlag,
									  CreatedBySystemUserID
									)
				SELECT 
						-1 AS POEOLicenceFeeBasedActivityID,
					   0 AS InstrumentID,
					   RN.S.value('FeeBasedActivityId[1]','int') AS FeeBasedActivityId,
					   RN.S.value('FeeBasedActivityScaleId[1]','int') AS FeeBasedActivityScaleID   ,
					    'I',
						0,
						1
				FROM @theXmlData.nodes('/POEOLicence/NonScheduledActivityList/POEONonScheduledActivity') AS RN(S)
	   END
	ELSE
	   BEGIN
		    SELECT 88 AS POEOLicenceFeeBasedActivityID,
			   0 AS InstrumentID,
			   RN.S.value('FeeBasedActivityId[1]','int') AS FeeBasedActivityID,
			   RN.S.value('FeeBasedActivityScaleId[1]','int') AS FeeBasedActivityScaleID

		FROM @theXmlData.nodes('/POEOLicence/ScheduledActivityList/POEOScheduledActivity') AS RN(S)
			print 'sdsdfsfsdf'
		  INSERT INTO @tblFeeBasedActivity(	
									POEOLicenceFeeBasedActivityID,
									 InstrumentID,
									 FeeBasedActivityID,
									 FeeBasedActivityScaleID ,
									  Action ,
									  PrimaryFlag,
									  CreatedBySystemUserID
									)
				SELECT 	 
						-1 AS POEOLicenceFeeBasedActivityID,
					   0 AS InstrumentID,
				   RN.S.value('FeeBasedActivityId[1]','int') AS FeeBasedActivityID,
			   RN.S.value('FeeBasedActivityScaleId[1]','int') AS FeeBasedActivityScaleID,
					   'I',
					   0,
					   1
			FROM @theXmlData.nodes('/POEOLicence/ScheduledActivityList/POEOScheduledActivity') AS RN(S)


			   INSERT INTO @tblPOEOAncillaryActivity(	
									POEOLicenceFeeBasedActivityID,
									 InstrumentID,
									 FeeBasedActivityID,
									 FeeBasedActivityScaleID ,
									  Action ,
									  PrimaryFlag
									)
				SELECT 	 
						-1 AS POEOLicenceFeeBasedActivityID,
					   0 AS InstrumentID,
				   RN.S.value('FeeBasedActivityId[1]','int') AS FeeBasedActivityID,
			   0 AS FeeBasedActivityScaleID,
					   'I',
					   0
			FROM @theXmlData.nodes('/POEOLicence/AncillaryActivities/POEOAncillaryActivity') AS RN(S)


		
	   END

	   ---------------- PRIMARY FEE BASED ACTIVITY
	   UPDATE @tblFeeBasedActivity
	   SET PrimaryFlag = 1
	   where SNo = 1


	 --  SELECT 88 AS POEOLicenceFeeBasedActivityID,
		--	   0 AS InstrumentID,
		--	   RN.S.value('FeeBasedActivityId[1]','int') AS FeeBasedActivityID,
		--	   RN.S.value('FeeBasedActivityScaleId[1]','int') AS FeeBasedActivityScaleID

		--FROM @theXmlData.nodes('/POEOLicence/PostalContact') AS RN(S)
	   

	 IF @ApplicantTypeID = 1104   -------- INDIVIDUAL
	 BEGIN
		

		  INSERT INTO @tblAccountablePartyDetailType
			(TitleID,
			 Surname,
			 GivenName,
			 MiddleName,
			 TradingName)
			 --ContactRoleFlag)
			 SELECT    RN.S.value('TitleId[1]','int') AS TitleID,
						RN.S.value('Surname[1]','varchar(50)') AS Surname,
						RN.S.value('GivenName[1]','varchar(50)') AS GivenName,
						RN.S.value('MiddleName[1]','varchar(50)') AS MiddleName,
						RN.S.value('TradingName[1]','varchar(128)') AS TradingName
						--RN.S.value('ContactRoleFlag[1]','bit') AS ContactRoleFlag
			FROM @theXmlData.nodes('/POEOLicence/AccountablePartyIndividualList/POEOAccountablePartyIndividual') AS RN(S)

	 END
	 ELSE
	 BEGIN
		 INSERT INTO @tblAccountablePartyDetailType
			(ABN,
			 ACN,
			 OrganisationName,
			 TradingName)
			 SELECT    RN.S.value('ABN[1]','varchar(14)') AS ABN,
						RN.S.value('ACN[1]','varchar(14)') AS ACN,
						RN.S.value('OrganizationName[1]','varchar(128)') AS OrganizationName,
						RN.S.value('TradingName[1]','varchar(128)') AS TradingName
			FROM @theXmlData.nodes('/POEOLicence/AccountablePartyList/POEOAccountableParty') AS RN(S)
	 END

	


	--INSERT INTO @tblContactDetailType
	--(ABN,
	-- ACN,
	-- OrganisationName,
	-- TradingName)
	-- SELECT    RN.S.value('ABN[1]','varchar(14)') AS ABN,
	--			RN.S.value('ACN[1]','varchar(14)') AS ACN,
	--			RN.S.value('OrganizationName[1]','varchar(128)') AS OrganizationName,
	--			RN.S.value('TradingName[1]','varchar(128)') AS TradingName
	--FROM @theXmlData.nodes('/POEOLicence/PostalContact') AS RN(S)

	   INSERT INTO @tblContactDetailType
	   (
	   TitleID,
		GivenName,
	   Surname,
		OrganisationName,
		 Position,
		  Phone,
		   Mobile,
		   AfterHoursNumber,
			Fax,
		   Email,
			Pager,
	   PrefixAddress,
	   OverseasAddressFlag,
		 Address,
		 Suburb,
		 Postcode,
		Statecode,
		PostalContactFlag,
		EmailContactFlag)
	  SELECT  		 RN.S.value('(TitleID)[1]','VARCHAR(100)'), 
	  				 RN.S.value('(GivenName)[1]','VARCHAR(60)'), 
	  				 RN.S.value('(Surname)[1]','VARCHAR(60)'),  
					  RN.S.value('(OrganisationName)[1]','VARCHAR(128)'),  
					   RN.S.value('(Position)[1]','VARCHAR(128)'),
					    RN.S.value('(Phone)[1]','VARCHAR(20)'), 
								  RN.S.value('(Mobile)[1]','VARCHAR(20)'), 
						   RN.S.value('(AfterHoursNumber)[1]','VARCHAR(20)'),
					 RN.S.value('(Fax)[1]','VARCHAR(20)'), 
					  RN.S.value('(Email)[1]','VARCHAR(128)'), 
					   RN.S.value('(Pager)[1]','VARCHAR(20)'),
							RN.S.value('(PrefixAddress)[1]','VARCHAR(100)'), 
							0 as OverseasAddressFlag,
			       	
					Rtrim((case isnull(RN.S.value('(Unit)[1]','VARCHAR(50)'), '') when '' then '' else RN.S.value('(Unit)[1]','VARCHAR(50)') + ' ' end) +  
					(case isnull(RN.S.value('(StreetNo)[1]','VARCHAR(100)'), '') when '' then '' else RN.S.value('(StreetNo)[1]','VARCHAR(100)') + ' ' end) +
					(case isnull(RN.S.value('(StreetName)[1]','VARCHAR(100)'), '') when '' then '' else RN.S.value('(StreetName)[1]','VARCHAR(100)') + ' ' end) + 
					(case isnull(RN.S.value('(Address)[1]','VARCHAR(100)'), '') when '' then '' else RN.S.value('(Address)[1]','VARCHAR(100)') + ' ' end)) as [Address], 

					RN.S.value('(Suburb)[1]','VARCHAR(50)'),
					RN.S.value('(Postcode)[1]','VARCHAR(10)'),
					 RN.S.value('(State)[1]','VARCHAR(20)'),
					 1,
					 0
		   From  @theXmlData.nodes('/POEOLicence/PostalContact') as RN(S)


		INSERT INTO @tblContactDetailType
	   (
	   TitleID,
		GivenName,
	   Surname,
		OrganisationName,
		 Position,
		  Phone,
		   Mobile,
		   AfterHoursNumber,
			Fax,
		   Email,
			Pager,
	   PrefixAddress,
	   OverseasAddressFlag, 
		 Address,
		 Suburb,
		 Postcode,
		Statecode,
		PostalContactFlag,
		EmailContactFlag)
	  SELECT  		 RN.S.value('(TitleID)[1]','VARCHAR(100)'), 
	  				 RN.S.value('(GivenName)[1]','VARCHAR(60)'), 
	  				 RN.S.value('(Surname)[1]','VARCHAR(60)'),  
					  RN.S.value('(OrganisationName)[1]','VARCHAR(128)'),  
					   RN.S.value('(Position)[1]','VARCHAR(128)'),
					    RN.S.value('(Phone)[1]','VARCHAR(20)'), 
								  RN.S.value('(Mobile)[1]','VARCHAR(20)'), 
						   RN.S.value('(AfterHoursNumber)[1]','VARCHAR(20)'),
					 RN.S.value('(Fax)[1]','VARCHAR(20)'), 
					  RN.S.value('(Email)[1]','VARCHAR(128)'), 
					   RN.S.value('(Pager)[1]','VARCHAR(20)'),
							RN.S.value('(PrefixAddress)[1]','VARCHAR(100)'), 
							0 as OverseasAddressFlag,
			       	RN.S.value('(Address)[1]','VARCHAR(100)'), 
					RN.S.value('(Suburb)[1]','VARCHAR(50)'),
					RN.S.value('(Postcode)[1]','VARCHAR(10)'),
					 RN.S.value('(State)[1]','VARCHAR(20)'),
					 0,
					 0
		   From  @theXmlData.nodes('/POEOLicence/PrimaryContact') as RN(S)



	   ----------------------  LOCATION --------------------------

	   DECLARE @tblAddress tblAddressType
	   DECLARE @tblLocationDetail tblLocationType
	   DECLARE @AdditionalAddressInformation VARCHAR(255)
	   DECLARE @tblLandTitle tblLandTitleType
	   DECLARE @tblLandTitleLGA tblLandTitleLGAType
	   DECLARE @tblLandTitleCatchment tblLandTitleCatchmentType
	   DECLARE @tblLandTitleElectorate tblLandTitleElectorateType
       DECLARE @tblLandTitleSubCatchment tblLandTitleSubCatchmentType
	   DECLARE @tblLandTitleDetail tblLandTitleDetailType
	   DECLARE @SpatialInfoAvailable BIT
	   DECLARE @IsLotDP BIT	   

	   INSERT INTO @tblAddress(AddressID
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
	   FROM @theXmlData.nodes('/POEOLicence/LocationDetails/Address') AS RN(S)

	   SELECT @AdditionalAddressInformation =   RN.S.value('AdditionalInfo[1]','varchar(1000)') 
			FROM @theXmlData.nodes('/POEOLicence/LocationDetails/Address') AS RN(S) 

	   INSERT INTO @tblLocationDetail(LocationID
							,LocationName
							,AddressID
							,PremisesFlag
							,AdditionalAddressInformation
							,CreatedBySystemUserID
							,InstrumentID)
	   SELECT  -1 AS LocationID,
			 RN.S.value('Name[1]','varchar(128)') AS LocationName,
			 -88 AS AddressID,
			 1 AS PremisesFlag,
			@AdditionalAddressInformation AS AdditionalAddressInformation,		 
			 1 AS CreatedBySystemUserID,
			 -1 AS InstrumentID			 
       FROM @theXmlData.nodes('/POEOLicence/LocationDetails') AS RN(S)


	   SELECT @SpatialInfoAvailable =   RN.S.value('SpatialInfoAvailable[1]','BIT') 	,
			@IsLotDP =   RN.S.value('IsLotDP[1]','BIT')
			FROM @theXmlData.nodes('/POEOLicence/LocationDetails') AS RN(S) 

		IF @SpatialInfoAvailable = 1 and  @IsLotDP = 1
		BEGIN
					 INSERT INTO @tblLandTitleDetail(LandTitleID
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
				 @IsLotDP AS IdentifiedByLotDPFlag,
 				 @SpatialInfoAvailable AS PartLotFlag,
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
				FROM @theXmlData.nodes('/POEOLicence/LocationDetails/LotDPs/LocationSpatialLotDP') AS RN(S)
		END

		IF @SpatialInfoAvailable = 1 and  @IsLotDP = 0
		BEGIN
					 INSERT INTO @tblLandTitleDetail(LandTitleID
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
				 @IsLotDP AS IdentifiedByLotDPFlag,
 				 @SpatialInfoAvailable AS PartLotFlag,
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
				FROM @theXmlData.nodes('/POEOLicence/LocationDetails/SpatialEasting') AS RN(S)
		END

 
	 

 	SELECT * FROM @tblAccountablePartyDetailType
	select * from @tblContactDetailType

	select * from @tblFeeBasedActivity

	SELECT * FROM @tblAddress

	SELECT * FROM @tblLocationDetail


	SELECT  @SpatialInfoAvailable, @IsLotDP


	select * from @tblLandTitleDetail

	SELECT * FROM @tblPOEOAncillaryActivity
 
	--return 
	
	
  --RN.S.value('xs:dateTime(EffectiveDateFrom[1])','smalldatetime') AS EffectiveDateFrom,
  --RN.S.value('xs:dateTime(EffectiveDateTo[1])','smalldatetime') AS EffectiveDateTo,	
  --RN.S.value('AdditionalAddressInformation[1]','varchar(255)') AS AdditionalAddressInformation,	
  /*
  	
	INSERT INTO @tblPOEO(InstrumentID,
						 DateApplicationReceived,
						 DateApplicationCompleted,
						 TRIMNumber,
						 AdminFee,
						 AnniversaryDate,
						 ReviewDueDate,
						 DevConsentGivenTypeID,
						 LowRiskFlag,
						 ConsentForECFlag,
						 LBLFlag,
						 CoastalWaterFlag,
						 EnclosedWaterFlag,
						 EstuarineWaterFlag,
						 IDANo,
						 IDATypeID,
						 IDADevelopmentTypeID,
						 IDAApplicationFee,
						 CreatedBySystemUserID,
						 UpdatedBySystemUserID,
						 RowTimestamp,
						 PIRMPinPlaceFlag,
						 PIRMPLastTestedDate
						 --PIRMPLastUpdatedDate
						 )
	SELECT RN.S.value('InstrumentID[1]','int') AS InstrumentID,
			 RN.S.value('DateApplicationReceived[1]','smalldatetime') AS DateApplicationReceived,
			 RN.S.value('DateApplicationCompleted[1]','smalldatetime') AS DateApplicationCompleted,
			 RN.S.value('TRIMNumber[1]','varchar(20)') AS TRIMNumber,
			 RN.S.value('AdminFee[1]','money') AS AdminFee,
			 RN.S.value('AnniversaryDate[1]','smalldatetime') AS AnniversaryDate,
			 RN.S.value('ReviewDueDate[1]','smalldatetime') AS ReviewDueDate,
			 RN.S.value('DevConsentGivenTypeID[1]','smallint') AS DevConsentGivenTypeID,
			 RN.S.value('LowRiskFlag[1]','bit') AS LowRiskFlag,
			 RN.S.value('ConsentForECFlag[1]','bit') AS ConsentForECFlag,
			 RN.S.value('LBLFlag[1]','bit') AS LBLFlag,
			 RN.S.value('CoastalWaterFlag[1]','bit') AS CoastalWaterFlag,
			 RN.S.value('EnclosedWaterFlag[1]','bit') AS EnclosedWaterFlag,
			 RN.S.value('EstuarineWaterFlag[1]','bit') AS EstuarineWaterFlag,
			 RN.S.value('IDANo[1]','int') AS IDANo,
			 RN.S.value('IDATypeID[1]','smallint') AS IDATypeID,
			 RN.S.value('IDADevelopmentTypeID[1]','smallint') AS IDADevelopmentTypeID,
			 RN.S.value('IDAApplicationFee[1]','money') AS IDAApplicationFee,
			 RN.S.value('CreatedBySystemUserID[1]','int') AS CreatedBySystemUserID,
			 RN.S.value('UpdatedBySystemUserID[1]','int') AS UpdatedBySystemUserID,
			 RN.S.value('RowTimestamp[1]','varchar(4000)') AS RowTimestamp,
			 RN.S.value('PIRMPinPlaceFlag[1]','bit') AS PIRMPinPlaceFlag,
	         RN.S.value('PIRMPLastTestedDate[1]','smalldatetime') AS PIRMPLastTestedDate
	        -- RN.S.value('PIRMPLastUpdatedDate[1]','smalldatetime') AS PIRMPLastUpdatedDate
   FROM @theXmlData.nodes('/NewDataSet/POEOLicence') AS RN(S)

   */
	
	INSERT INTO @tblInstrument(InstrumentID,
							   InstrumentTypeID,
							   InstrumentStatusID,
							   ResponsibleSystemUserID,
							   --ResponsibleUserLogin,
							   DECCWSectionID,
							   --IssuedBySystemUserID,
							   --DateIssued,
							   DisplayFlag,
							   CreatedBySystemUserID)
							   --UpdatedBySystemUserID)
							   --RowTimestamp)
	SELECT -1 AS InstrumentID,
		   493 AS InstrumentTypeID,
		   5 AS InstrumentStatusID,
		  1063 AS ResponsibleSystemUserID,
		 --'' AS ResponsibleUserLogin,
		  27 AS DECCWSectionID,
		   --RN.S.value('IssuedBySystemUserID[1]','int') AS IssuedBySystemUserID,
		   --RN.S.value('DateIssued[1]','smalldatetime') AS DateIssued,
		   1 AS DisplayFlag,		 
		1 AS CreatedBySystemUserID
		--1063 AS UpdatedBySystemUserID
		   --RN.S.value('RowTimestamp[1]','varchar(4000)') AS RowTimestamp

	

 	--RN.S.value('LandownerFlag[1]', 'bit') AS LandownerFlag,
	

	
	
   	   /*
	---    PALMS V3.0  --------------------
	INSERT INTO @tblFeeBasedActivity(POEOLicenceFeeBasedActivityID,
									 InstrumentID,
									 FeeBasedActivityID,
									 FeeBasedActivityScaleID,
									 CreatedBySystemUserID,
									 UpdatedBySystemUserID,
									 RowTimestamp,
									 Action,
									 PrimaryFlag)
	SELECT RN.S.value('POEOLicenceFeeBasedActivityID[1]','int') AS POEOLicenceFeeBasedActivityID,
		   RN.S.value('InstrumentID[1]','int') AS InstrumentID,
		   RN.S.value('FeeBasedActivityID[1]','int') AS FeeBasedActivityID,
		   RN.S.value('FeeBasedActivityScaleID[1]','int') AS FeeBasedActivityScaleID,
		   RN.S.value('CreatedBySystemUserID[1]','int') AS CreatedBySystemUserID,
		   RN.S.value('UpdatedBySystemUserID[1]','int') AS UpdatedBySystemUserID,
		   RN.S.value('RowTimestamp[1]','varchar(4000)') AS RowTimestamp,
		   RN.S.value('Action[1]','char(1)') AS Action,
		   RN.S.value('PrimaryFlag[1]','bit') AS PrimaryFlag
	FROM @theXmlData.nodes('/NewDataSet/FeeBasedActivity') AS RN(S)
	
	
	
	--------------------------------------- 	
	
	*/	
		
	SELECT @InstrumentID = InstrumentID,@CreatedBySystemUserID = CreatedBySystemUserID,
		   @UpdatedBySystemUserID = UpdatedBySystemUserID
	FROM @tblInstrument
	
	SELECT @Cnt = count(*) From tblInstrument Where InstrumentID = @InstrumentID
	
	IF @InstrumentID>0 AND @Cnt=1  
	   SELECT @INSERT = 0
	ELSE  
	   SELECT @INSERT = 1
	
	--BEGIN TRAN A
	--Insert or Update Address
	Exec @InstrumentID = uspSaveInstrument @tblInstrument
	

    
	
			--- PALMS V3.0 ----------------------
		    INSERT INTO tblPOEOLicence(InstrumentID,
										DateApplicationReceived,
										--TRIMNumber,
										AdminFee,
										--AnniversaryDate,
										--ReviewDueDate,
										DevConsentGivenTypeID,
										--LowRiskFlag,
										--ConsentForECFlag,
										LBLFlag,
										--CoastalWaterFlag,
										--EnclosedWaterFlag,
										--EstuarineWaterFlag,
										DateCreated,
										CreatedBySystemUserID
										--PIRMPinPlaceFlag,
										--PIRMPLastTestedDate,
										--PIRMPLastUpdatedDate
										)
			Select		  @InstrumentID,
						  GETDATE(),
						  --DateApplicationCompleted,
						  --TRIMNumber,
						  333,
						  --AnniversaryDate,
						  --ReviewDueDate,
						  557,
						  --LowRiskFlag,
						  --ConsentForECFlag,
						  0,
						  --CoastalWaterFlag,
						  --EnclosedWaterFlag,
						  --EstuarineWaterFlag,
						  GETDATE(),
						  1
						  --PIRMPinPlaceFlag,
						  --PIRMPLastTestedDate,
						  --PIRMPLastUpdatedDate
			--From @tblPOEO
			
			--Add an entry in to Audit log table
			SELECT @RtnVal = 0
			EXEC @RtnVal = uspAuditLogInsert @InstrumentID,'Licence created and Assigned Draft status','Licence created and Assigned Draft status',@CreatedBySystemUserID,@CreatedBySystemUserID,1
			

	
	----------- ADD NEW ACCOUNTABLE PARTY

	
	DECLARE @CntContact INT
	DECLARE @AddressID INT
	DECLARE @ContactID INT
	DECLARE @PostalContactFlag BIT
	DECLARE @EmailContactFlag BIT
	Declare
			        @PrefixAddress          varchar(100),
					@Country                varchar(100),
					@OverseasAddressFlag    bit,
			        @Address				varchar(100),
					@Suburb					varchar(50),
					@Postcode				char(10),
					@Statecode				char(20),
					@Title					int,
					@FirstName				varchar(60),
					@MiddleName				varchar(60),
					@LastName				varchar(60),
					@OrganisationName       varchar(128),
					@Position				varchar(128),
					@Phone					varchar(20),
					@Mobile					varchar(20),
					@AfterHoursNumber		varchar(20),
					@Fax					varchar(20),
					@Email					varchar(128),
					@Pager					varchar(20)




	DECLARE @AccountablePartyID INT
	DECLARE @AccountablePartyContact INT
	  SET @AccountablePartyID = 0

	  SET @Cnt = 1
	SELECT 	@AccountablePartyContact = COUNT(*) FROM   @tblAccountablePartyDetailType
	WHILE @Cnt <= @AccountablePartyContact
	BEGIN
			IF @ApplicantTypeID = 1104   -------- INDIVIDUAL
			BEGIN
		   	    SELECT @PrefixAddress         = PrefixAddress, 
			         @Country               = Country , 
			         @OverseasAddressFlag   = OverseasAddressFlag, 
					 @Address               = Address, 
					 @Suburb                = Suburb,
					 @Postcode              =Postcode,
					 @Statecode             = StateCode, 
					 @CreatedBySystemUserID = 1	 ,
					 @PostalContactFlag =PostalContactFlag,
					  @EmailContactFlag = EmailContactFlag
			  FROM @tblContactDetailType
			  WHERE   PostalContactFlag = 1

				  	 Exec dbo.uspAddAddress 
											 @PrefixAddress        ,  
											 @Country             ,
											 @OverseasAddressFlag  ,					                         
											 @Address, 
  					                         @Suburb, 
  							                 @Postcode,
  									         @Statecode, 
  											 @CreatedBySystemUserID, 
  											 @AddressID OUTPUT      	
			 select @AddressID

			 Insert Into dbo.tblAccountableParty
				(
					CompanyFlag,
					ContactRoleFlag,
					TradingName,
					TitleID,
					GivenName,
					MiddleName,
					Surname,
					AddressID,
					EffectiveDateFrom,
					DateCreated,
					CreatedBySystemUserID
				)			
				SELECT
					0, 
					0, 
					TradingName,
					TitleID,
					GivenName,
					MiddleName,
					Surname,
					@AddressID,
					GETDATE(),
					GETDATE() ,
					1
					From @tblAccountablePartyDetailType
					 WHERE Sno =  @Cnt


				SET @AccountablePartyID =  @@IDENTITY;			   

			 END
			 ELSE
			 BEGIN		  --------------- ORGANISATION ------------------------
					 DECLARE @ABN VARCHAR(14)
					 DECLARE @ACN VARCHAR(20)
					 DECLARE @ABNExisted BIT = 0
					 
					 SELECT @ABN = ABN, @ACN = ACN
					 From @tblAccountablePartyDetailType
					WHERE Sno =  @Cnt

					IF 	@ABN IS NOT NULL AND @ABN <> ''
					BEGIN
						IF EXISTS (SELECT * FROM tblAccountableParty WHERE ABN = @ABN)
						BEGIN
							 SELECT @ABNExisted = 1

							 SELECT @AccountablePartyID = AccountablePartyID  
							 FROM tblAccountableParty 
							 WHERE ABN = @ABN;

						END
					END

					IF 	@ACN IS NOT NULL AND @ACN <> ''
					BEGIN
						IF EXISTS (SELECT * FROM tblAccountableParty WHERE ACN = @ACN)
						BEGIN
							 SELECT @ABNExisted = 1

							 SELECT @AccountablePartyID = AccountablePartyID  
							 FROM tblAccountableParty 
							 WHERE ACN = @ACN;

						END
					END

					IF @ABNExisted = 0
					BEGIN
						   Insert Into dbo.tblAccountableParty
					(
						CompanyFlag,
						ContactRoleFlag,
						ABN,
						ACN,
						OrganisationName,
						TradingName,
						CompanyWebsite,
						Email,				
						EffectiveDateFrom,
						DateCreated,
						CreatedBySystemUserID
							)			
					 SELECT
								1,
								0,
								ABN,
								ACN,
								OrganisationName,
								TradingName,
								CompanyWebsite,
								Email,
								GETDATE(),
								GETDATE(),			
								1				
							From @tblAccountablePartyDetailType
							 WHERE Sno =  @Cnt

						SET @AccountablePartyID =  @@IDENTITY;
					END
									
			 END
			

	  	INSERT INTO @tblAccountableParty(InstrumentAccountablePartyID,
									 InstrumentID,
									 AccountablePartyID,
									 LandownerFlag,
									 CreatedBySystemUserID,
									 Action)
		SELECT -1*@Cnt,
			   -1,
			   @AccountablePartyID AS AccountablePartyID,
			   0,
			   1,
			   'I' AS Action
			

			SELECT @Cnt  = @Cnt +1
	END
		
		--Insert/Update Accountable Party records
			SELECT @RtnVal =0
			Exec @RtnVal = uspLinkAccountableParties @tblAccountableParty,@InstrumentID
			IF @RtnVal <> 0 RAISERROR ('Problem saving uspLinkAccountableParty' , 16, 1) 

	

	


	-----------------  ADD CONTACT -----------------


	SET @Cnt = 1
	SELECT 	@CntContact = COUNT(*) FROM   @tblContactDetailType
	WHILE @Cnt <= @CntContact
		BEGIN
			
				  SELECT @PrefixAddress         = PrefixAddress, 
			         @Country               = Country , 
			         @OverseasAddressFlag   = OverseasAddressFlag, 
					 @Address               = Address, 
					 @Suburb                = Suburb,
					 @Postcode              =Postcode,
					 @Statecode             = StateCode, 
					 @CreatedBySystemUserID = 1	 ,
					 @PostalContactFlag =PostalContactFlag,
					  @EmailContactFlag = EmailContactFlag
			  FROM @tblContactDetailType
			  WHERE Sno =  @Cnt

				  	 Exec dbo.uspAddAddress 
											 @PrefixAddress        ,  
											 @Country             ,
											 @OverseasAddressFlag  ,					                         
											 @Address, 
  					                         @Suburb, 
  							                 @Postcode,
  									         @Statecode, 
  											 @CreatedBySystemUserID, 
  											 @AddressID OUTPUT      	
		   select @AddressID

		      SELECT
					@Title				   = TitleID, 
					@FirstName			   = GivenName, 
					--@MiddleName			   = MiddleName, 
					@LastName			   = Surname, 
					@OrganisationName      = OrganisationName, 
					@Position			   = Position,
					@Phone				   = Phone, 
					@Mobile				   = Mobile, 
					@AfterHoursNumber      = AfterHoursNumber, 
					@Fax				   = Fax, 
					@Email                 = Email, 
					@Pager                 = Pager,
					@CreatedBySystemUserID = 1
			    FROM @tblContactDetailType
			WHERE Sno =  @Cnt


			  EXEC dbo.uspAddContact @AddressID, 
			                         @Title, 
			                         @FirstName, 
									 @MiddleName,
			                         @LastName, 
			                         @OrganisationName,
			                         @Position, 
			                         @Phone, 
			                         @Mobile, 
			                         @AfterHoursNumber, 
			                         @Fax,
			                         @Email, 
			                         @Pager, 
			                         @CreatedBySystemUserID, 
			                         @ContactID OUTPUT	

						
						--DELETE FROM  @tblContact
						print cast (@Cnt as varchar(10))

						INSERT INTO @tblContact(InstrumentContactID,
							InstrumentID,
							ContactID,
							PostalContactFlag,
							EmailContactFlag,
							CreatedBySystemUserID,
							Action)
				SELECT -1*@Cnt,
			   -1,
			   @ContactID AS ContactID,
			   @PostalContactFlag  ,
			   @EmailContactFlag,
			   1,
			   'I' AS Action
		
		

	
		

			 -------------- ADD CONTACT
			 SELECT @Cnt = @Cnt+1

		END

		 	select count(*) from @tblContact
			--Insert/Update Contact records
			SELECT @RtnVal =0
			Exec @RtnVal = uspLinkContacts @tblContact,@InstrumentID
			IF @RtnVal <> 0 RAISERROR ('Problem saving uspLinkContacts' , 16, 1) 


	
					
		
				-----------------  ADD location -----------------		
				DECLARE @AddrID INT
				DECLARE @LocID INT
				Exec @AddrID = uspSaveAddress @tblAddress
				IF @AddrID < 0 RAISERROR ('Problem saving uspSaveAddress' , 16, 1)

			   INSERT INTO tblLocation(LocationName
							,AddressID
							,PremisesFlag
							,AdditionalAddressInformation
							,EffectiveDateFrom
							,DateCreated
							,CreatedBySystemUserID)
			Select		 LocationName
						,@AddrID
						,PremisesFlag
						,AdditionalAddressInformation
						,GETDATE()
						,GETDATE()
						,CreatedBySystemUserID
			From @tblLocationDetail

			 SET @LocID = (SELECT @@IDENTITY)	

			 DECLARE @LGAID INT
			 DECLARE @LGA  VARCHAR(200)

			 SET @Cnt = 1
			SELECT 	@CntContact = COUNT(*) FROM   @tblLandTitleDetail
			WHILE @Cnt <= @CntContact
				BEGIN
						INSERT INTO @tblLandTitle(LandTitleID
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
								,PartLotFlag)
				
						SELECT SNo
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
					FROM @tblLandTitleDetail 
					WHERE SNo =  @Cnt

					SELECT @LGA = LGA
					 FROM @tblLandTitleDetail 
					WHERE SNo =  @Cnt

					SELECT @LGAID = LGAID
					FROM tblLGA
					WHERE Name = @LGA

					--INSERT INTO tblLandTitleLGA(LandTitleID
					--			,LGAID
					--			,DateCreated
					--			,CreatedBySystemUserID)
					--SELECT 		 SNo
					--			,@LGAID
					--			,GetDate()
					--			,CreatedBySystemUserID
					--FROM @tblLandTitleDetail 
					--WHERE SNo =  @Cnt

					INSERT INTO @tblLandTitleLGA(LandTitleLGAID
								,LandTitleID
								,LGAID
								,CreatedBySystemUserID
								)
					SELECT -1 AS LandTitleLGAID,
							 SNo AS LandTitleID,
							 tblLGA.LGAID AS LGAID,
							 1		 
					FROM @tblLandTitleDetail Z	   				
					INNER JOIN tblLGA ON Z.LGA = tblLGA.Name
					WHERE SNo =  @Cnt

					INSERT INTO @tblLandTitleElectorate(LandTitleElectorateID
								,LandTitleID
								,ElectorateID
								,CreatedBySystemUserID
								)
					SELECT -1 AS LandTitleLGAID,
							 SNo AS LandTitleID,
							 tblElectorate.ElectorateID AS ElectorateID,
							 1		 
					FROM @tblLandTitleDetail Z	   				
					INNER JOIN tblElectorate ON Z.Electorate = tblElectorate.Name
					WHERE SNo =  @Cnt

					INSERT INTO @tblLandTitleCatchment(LandTitleCatchmentID
								,LandTitleID
								,CatchmentID
								,CreatedBySystemUserID
								)
					SELECT -1 AS LandTitleLGAID,
							 SNo AS LandTitleID,
							 tblCatchment.CatchmentID AS CatchmentID,
							 1		 
					FROM @tblLandTitleDetail Z	   				
					INNER JOIN tblCatchment ON Z.LBLCatchment = tblCatchment.Name
					WHERE SNo =  @Cnt
			


						
					SELECT @Cnt  = @Cnt +1
				END
				
  	Exec @RtnVal = uspSaveLandTitle @LocID,@tblLandTitle,@tblLandTitleLGA,@tblLandTitleElectorate,@tblLandTitleCatchment,@tblLandTitleSubCatchment
	IF @RtnVal < 0 RAISERROR ('Problem saving uspSaveLandTitle' , 16, 1) 
	  		

		
	
	INSERT INTO @tblLocation(InstrumentLocationID,
							 InstrumentID,
							 LocationID,
							 CreatedBySystemUserID,
								 Action)
	SELECT -1 AS InstrumentLocationID,
			 -1 AS InstrumentID,
			 @LocID AS LocationID,
			 1 AS CreatedBySystemUserID,
			'I' AS Action

			SELECT @RtnVal =0
	Exec @RtnVal = uspLinkLocations @tblLocation,@InstrumentID
	IF @RtnVal <> 0 RAISERROR ('Problem saving uspLinkLocations' , 16, 1) 

		



		INSERT INTO tblPOEOLicenceFeeBasedActivity(
											InstrumentID,
											FeeBasedActivityID,
											FeeBasedActivityScaleID,
											DateCreated,
											CreatedBySystemUserID,
											PrimaryFlag)
					SELECT 	@InstrumentID,
							FeeBasedActivityID,
							FeeBasedActivityScaleID,
						    GetDate(),
						    1,
						    PrimaryFlag
					FROM @tblFeeBasedActivity 

		-- loop through Fee Based Activity records
		-- Add the conditions associated to the fee Based activity list
		SELECT @RtnVal = 0
		Exec @RtnVal = uspAddInstrumentConditionsByFeeBasedActivity @tblFeeBasedActivity,@InstrumentID
		IF @RtnVal <> 0 RAISERROR ('Problem saving uspAddInstrumentConditionsByFeeBasedActivity' , 16, 1) 
		---


		---------Ancillary   Activity ---------------------------------
		INSERT INTO tblPOEOLicenceAncillaryActivity (
											InstrumentID,
											ActivityDescription,
											DateCreated,
											CreatedBySystemUserID
											)
					SELECT 	@InstrumentID,
							B.Description,
							GetDate(),
							1
					FROM @tblPOEOAncillaryActivity A INNER JOIN tblFeeBasedActivity B
						ON A.FeeBasedActivityID = B.FeeBasedActivityID 




					/*

		SET @Cnt = 1
	WHILE @Cnt <= @CntFeeBasedActivity
		BEGIN
			
			SELECT @POEOFeeBasedActivityID = POEOLicenceFeeBasedActivityID,@RowAction = Action FROM @tblFeeBasedActivity
			WHERE Sno =  @Cnt
			
					--- PALMS V3.0
					INSERT INTO tblPOEOLicenceFeeBasedActivity(
											InstrumentID,
											FeeBasedActivityID,
											FeeBasedActivityScaleID,
											DateCreated,
											CreatedBySystemUserID,
											PrimaryFlag)
					SELECT 	@InstrumentID,
							FeeBasedActivityID,
							FeeBasedActivityScaleID,
						    GetDate(),
						    CreatedBySystemUserID,
						    PrimaryFlag
					FROM @tblFeeBasedActivity Where POEOLicenceFeeBasedActivityID = @POEOFeeBasedActivityID

				
			  SELECT @Cnt = @Cnt+1
		END -- End of loop

		*/

			  --commit TRAN
			    --Rollback TRAN
	-- RETURN ----------------------------------
	
	--Insert/Update Location records
	SELECT @RtnVal =0
	Exec @RtnVal = uspLinkLocations @tblLocation, @InstrumentID
	IF @RtnVal <> 0 RAISERROR ('Problem saving uspLinkLocations' , 16, 1) 
	
	---Fee based activities
	--If there is no record in dataset do not proceed
	SELECT @CntFeeBasedActivity = 0
	SELECT @CntFeeBasedActivity = COUNT(*) FROM @tblFeeBasedActivity
	--IF @CntFeeBasedActivity <= 0
	--	RETURN 
		
	

	
	--
	--Add/Update scheduled activities based on the feebased activities
	Exec @RtnVal = uspSaveScheduledActivities @InstrumentID,@CreatedBySystemUserID
	IF @RtnVal < 0 RAISERROR ('Problem saving uspSaveScheduledActivities' , 16, 1) 
	--	
	--Save/Update Assessable pollutants
	Exec @RtnVal = uspSavePOEOAssesablePollutants @theAssessablePollutants, @InstrumentID, 0, 0, 0, 1
	IF @RtnVal < 0 RAISERROR ('Problem saving uspSavePOEOAssesablePollutants' , 16, 1) 
	
	--Clock event:Check for Application completed date, If Exists Start the clock.
	DECLARE @AppCompleteDate DateTime
	SELECT @AppCompleteDate = DateApplicationCompleted From @tblPOEO
	
	--SB:Create clock if Instrument status is Draft
	IF (EXISTS(SELECT * FROM tblInstrument WHERE InstrumentID = @InstrumentID AND InstrumentStatusID = 5) AND @AppCompleteDate IS NOT NULL)
   	   BEGIN
   			SELECT @RtnVal = 0
			EXEC @RtnVal = uspInstrument_Clock_Create @InstrumentID,1, 0,@CreatedBySystemUserID, @AppCompleteDate --/SB:Event ID 1 is to start clock in tblEvent
	   END
		
	  --SB:31/05/2011:Following code is also implemented in uspUpdatePOEOStatus because requirement is changed to create SAP customer when creating POEO Licence not when issued
	  --and Invoice is generated when Issuing the licence
	 -- IF @INSERT=1
		--EXEC uspFinanceLicneceFee @InstrumentID, @CreatedBySystemUserID
	
	
	--26-10-2015 Eric He here we call SP to Save POEOMonitoringPoint  
    Exec @RtnVal =  uspSavePOEOMonitoringPointEPABPortal @theXmlData, @InstrumentID

	print '@InstrumentID='+ cast(@InstrumentID as varchar)
	--end of adding POEOMonitoringPoint

	---------------------- START LOCATION INFORMATION FOR NoisePoints Data Insert: Added by Eric He for EPA Business Portal--------------------------
	--DECLARE @tblAddressPortal tblAddressType
	--DECLARE @tblLocationDetailPortal tblLocationType
	--DECLARE @AdditionalAddressInformationPortal VARCHAR(255)
	--DECLARE @tblLandTitlePortal tblLandTitleType
	--DECLARE @tblLandTitleLGAPortal tblLandTitleLGAType
	--DECLARE @tblLandTitleCatchmentPortal tblLandTitleCatchmentType
	--DECLARE @tblLandTitleElectoratePortal tblLandTitleElectorateType
 --   DECLARE @tblLandTitleSubCatchmentPortal tblLandTitleSubCatchmentType
	--DECLARE @tblLandTitleDetailPortal tblLandTitleDetailType
	--DECLARE @SpatialInfoAvailablePortal BIT
	--DECLARE @IsLotDPPortal BIT	  

	--INSERT INTO @tblAddressPortal(AddressID
	--					,Address
	--					,Suburb
	--					,Postcode
	--					,StateCode
	--					,CreatedBySystemUserID
	--					,OverseasAddressFlag							
	--					)
	--SELECT   -1 AS AddressID,
	--			RN.S.value('Address[1]','varchar(100)') AS Address,
	--			RN.S.value('Suburb[1]','varchar(100)') AS Suburb,
	--			RN.S.value('Postcode[1]','char(10)') AS Postcode,
	--			RN.S.value('State[1]','char(20)') AS StateCode,
	--			1 AS CreatedBySystemUserID,
	--			0 AS OverseasAddressFlag
	--FROM @theXmlData.nodes('/POEOLicence/AppplicationPoint/NoisePoints/POEOLicenceNoisePoint/NoiseLocation/Address') AS RN(S)

	--SELECT @AdditionalAddressInformationPortal = RN.S.value('AdditionalInfo[1]','varchar(1000)') 
	--		FROM @theXmlData.nodes('/POEOLicence/AppplicationPoint/NoisePoints/POEOLicenceNoisePoint/NoiseLocation/Address') AS RN(S) 

	--INSERT INTO @tblLocationDetailPortal(LocationID
	--					,LocationName
	--					,AddressID
	--					,PremisesFlag
	--					,AdditionalAddressInformation
	--					,CreatedBySystemUserID
	--					,InstrumentID)
	--SELECT  -1 AS LocationID,
	--		--RN.S.value('Name[1]','varchar(128)') AS LocationName, 
	--		RN.S.value('Description[1]','varchar(128)') AS LocationName,
	--	   -88 AS AddressID,
	--		0 AS PremisesFlag,
	--	    @AdditionalAddressInformationPortal AS AdditionalAddressInformation,		 
	--		1 AS CreatedBySystemUserID,
	--	   -1 AS InstrumentID			 
 --   FROM @theXmlData.nodes('/POEOLicence/AppplicationPoint/NoisePoints/POEOLicenceNoisePoint/NoiseLocation') AS RN(S)

	--SELECT @SpatialInfoAvailablePortal =   RN.S.value('SpatialInfoAvailable[1]','BIT') 	,
	--		@IsLotDPPortal =   RN.S.value('IsLotDP[1]','BIT')
	--		FROM @theXmlData.nodes('/POEOLicence/AppplicationPoint/NoisePoints/POEOLicenceNoisePoint/NoiseLocation') AS RN(S) 

	--IF @SpatialInfoAvailablePortal = 1 and  @IsLotDPPortal = 1
	--BEGIN
	--			INSERT INTO @tblLandTitleDetailPortal(LandTitleID
	--			,LocationID
	--			,IdentifiedByLotDPFlag
	--			,SpatialInfoAvailable
	--			,LotNumber
	--			,DPNumber
	--			,SectionNumber
	--			,Easting
	--			,Northing
	--			,ZoneNumber
	--			,CreatedBySystemUserID
	--			,PartLotFlag
	--			,LGA
	--			,LBLCatchment
	--			,Electorate
	--			)
				
	--            SELECT -1 AS LandTitleID,
	--			-1 AS LocationID,
	--			0 AS IdentifiedByLotDPFlag,
 --				0 AS PartLotFlag,
	--			RN.S.value('Lot[1]', 'varchar(20)') AS LotNumber,
	--			RN.S.value('DP[1]', 'bigint') AS DPNumber,
	--			RN.S.value('SectionNumber[1]', 'varchar(20)') AS SectionNumber,
	--			RN.S.value('Easting[1]', 'int') AS Easting,
	--			RN.S.value('Northing [1]','int') AS Northing,
	--			RN.S.value('ZoneNumber[1]', 'int') AS ZoneNumber,
	--			1 AS CreatedBySystemUserID,
	--			0,
	--			RN.S.value('LGA[1]', 'varchar(200)') AS LGA,
	--			RN.S.value('LBLCatchment[1]', 'varchar(200)') AS LBLCatchment,
	--			RN.S.value('Electorate[1]', 'varchar(200)') AS Electorate
	--		    FROM @theXmlData.nodes('/POEOLicence/AppplicationPoint/NoisePoints/POEOLicenceNoisePoint/NoiseLocation/LotDPs/LocationSpatialLotDP') AS RN(S)
	--END

	--IF @SpatialInfoAvailablePortal = 1 and  @IsLotDPPortal = 0
	--BEGIN
	--			INSERT INTO @tblLandTitleDetailPortal(LandTitleID
	--			,LocationID
	--			,IdentifiedByLotDPFlag
	--			,SpatialInfoAvailable
	--			,LotNumber
	--			,DPNumber
	--			,SectionNumber
	--			,Easting
	--			,Northing
	--			,ZoneNumber
	--			,CreatedBySystemUserID
	--			,PartLotFlag
	--			,LGA
	--			,LBLCatchment
	--			,Electorate
	--			)
				
	--	    SELECT -1 AS LandTitleID,
	--			-1 AS LocationID,
	--			@IsLotDPPortal AS IdentifiedByLotDPFlag,
 --				@SpatialInfoAvailablePortal AS PartLotFlag,
	--			RN.S.value('Lot[1]', 'varchar(20)') AS LotNumber,
	--			RN.S.value('DP[1]', 'bigint') AS DPNumber,
	--			RN.S.value('SectionNumber[1]', 'varchar(20)') AS SectionNumber,
	--			RN.S.value('Easting[1]', 'int') AS Easting,
	--			RN.S.value('Northing [1]','int') AS Northing,
	--			RN.S.value('ZoneNumber[1]', 'int') AS ZoneNumber,
	--			1 AS CreatedBySystemUserID,
	--			0,
	--			RN.S.value('LGA[1]', 'varchar(200)') AS LGA,
	--			RN.S.value('LBLCatchment[1]', 'varchar(200)') AS LBLCatchment,
	--			RN.S.value('Electorate[1]', 'varchar(200)') AS Electorate
	--		FROM @theXmlData.nodes('/POEOLicence/AppplicationPoint/NoisePoints/POEOLicenceNoisePoint/NoiseLocation/SpatialEasting') AS RN(S)
	--END

	--DECLARE @AddrIDPortal INT
	--DECLARE @LocIDPortal INT
	--Exec @AddrIDPortal = uspSaveAddress @tblAddressPortal
	--IF @AddrIDPortal < 0 RAISERROR ('Problem saving uspSaveAddress' , 16, 1)

	--INSERT INTO tblLocation(LocationName
	--			,AddressID
	--			,PremisesFlag
	--			,AdditionalAddressInformation
	--			,EffectiveDateFrom
	--			,DateCreated
	--			,CreatedBySystemUserID)
	--Select		 LocationName
	--		,@AddrIDPortal
	--		,PremisesFlag
	--		,AdditionalAddressInformation
	--		,GETDATE()
	--		,GETDATE()
	--		,CreatedBySystemUserID
	--From @tblLocationDetailPortal

	--SET @LocIDPortal = (SELECT @@IDENTITY)	

 --	IF @InstrumentID >0
 --	BEGIN
 --	--   SELECT @Cnt=0
 --	--   SELECT @Cnt = COUNT(*) FROM tblPOEOLicenceNoisePoint WHERE InstrumentID = @InstrumentID
 		      
 --	--   IF @Cnt = 0
 --			--SELECT @PointNo=1
 --	--   ELSE
	--    DECLARE @NoisePointTypeID INT
	--    SELECT @NoisePointTypeID = RN.S.value('NoisePointTypeId[1]','int')  FROM @theXmlData.nodes('/POEOLicence/AppplicationPoint/NoisePoints/POEOLicenceNoisePoint') AS RN(S)
 --		DECLARE @NoisePointNoPortal INT 
	--	DECLARE @PointNoPortal INT
 		      
 --		SELECT @NoisePointNoPortal = ISNULL(MAX(PointNo),0) FROM tblPOEOLicenceNoisePoint WHERE InstrumentID = @InstrumentID
	--	SELECT @PointNoPortal = ISNULL(Max(PointNo),0) FROM tblPOEOLicencePoint WHERE InstrumentID = @InstrumentID
			  
	--	IF (@NoisePointNoPortal > @PointNoPortal)
	--		SELECT @PointNoPortal = @NoisePointNoPortal + 1
	--	ELSE
	--	    SELECT @PointNoPortal = @PointNoPortal + 1
		      
	--	--- PALMS V3.0		  
 --		INSERT INTO tblPOEOLicenceNoisePoint(
	--				InstrumentID
	--				,PointNo
	--				,LocationID
	--				,DateCreated
	--				,CreatedBySystemUserID
	--				,NoisePointTypeID)
	--	VALUES(@InstrumentID
	--		,@PointNoPortal
	--		,@LocIDPortal
	--		,GETDATE()     
	--		,1                           --CreatedBySystemUserID
	--		,@NoisePointTypeID)
					
	--	--SELECT @Cnt=0
			  
 --	END
	---------------------- END LOCATION INFORMATION FOR NoisePoints Data Insert--------------------------

	----------------- PALMS V4.0
	--Modified by WR - PALMS v6.5 - This functionality is moved to stored proc uspEnvironmentRiskLevelChange
	--IF EXISTS (SELECT COUNT(*) FROM @tblPOEOLicenceEnvironmentalRiskLevelType)
	--BEGIN
	--	UPDATE tblPOEOLicenceEnvironmentalRiskLevel
	--	SET EnvironmentalRiskLevelID = B.EnvironmentalRiskLevelID,
	--		ChangedReasonID = B.ChangedReasonID,
	--		Remarks =B.Remarks,
	--		UpdatedBySystemUserID = B.UpdatedBySystemUserID,
	--		DateUpdated = GETDATE()
	--	FROM tblPOEOLicenceEnvironmentalRiskLevel A, @tblPOEOLicenceEnvironmentalRiskLevelType B
	--	WHERE A.POEOLicenceEnvironmentalRiskLevelID = B.POEOLicenceEnvironmentalRiskLevelID
	--END
	
			
	--COMMIT TRAN A
	--If creating new site return site id else return 0(i.e update sucess)
	--IF @INSERT=0 --for updating
	--	SELECT 0
 --   ELSE
	--    SELECT @InstrumentID --for inserting