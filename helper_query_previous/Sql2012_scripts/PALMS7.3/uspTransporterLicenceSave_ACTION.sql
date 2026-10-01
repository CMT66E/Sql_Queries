declare @theXmlData xml =
'
<NewDataSet>
  <Instrument>
    <InstrumentID>-1</InstrumentID>
    <InstrumentTypeID>1417</InstrumentTypeID>
    <InstrumentStatusID>751</InstrumentStatusID>
    <ResponsibleSystemUserID>1399</ResponsibleSystemUserID>
    <ResponsibleUser>He Eric (DEC\HEE)</ResponsibleUser>
    <LoginName>DEC\HEE</LoginName>
    <CreatedBySystemUserID>1399</CreatedBySystemUserID>
    <HasRecordService>false</HasRecordService>
    <HasActiveVariation>false</HasActiveVariation>
    <HasActiveSystemNotice>false</HasActiveSystemNotice>
    <SectionName>South East - Queanbeyan</SectionName>
    <HasActiveCorrection>false</HasActiveCorrection>
  </Instrument>
  <AccountableParty>
    <InstrumentAccountablePartyID>-1</InstrumentAccountablePartyID>
    <InstrumentID>-1</InstrumentID>
    <AccountablePartyID>7515</AccountablePartyID>
    <AccountablePartyName>Ceres Agricultural Company Pty Ltd</AccountablePartyName>
    <AddressABN>40 155 816 416</AddressABN>
    <DateCreated>2017-07-04T15:29:02.49723+10:00</DateCreated>
    <CreatedBySystemUserID>1399</CreatedBySystemUserID>
    <Action>I</Action>
  </AccountableParty>
  <Contact>
    <InstrumentContactID>-1</InstrumentContactID>
    <InstrumentID>-1</InstrumentID>
    <ContactID>99955</ContactID>
    <ContactName>Mr Derek Real</ContactName>
    <Address> PO BOX 45897, PENSHURST, 2222, NSW</Address>
    <EMail>penhurst@mail.com</EMail>
    <PostalContactFlag>true</PostalContactFlag>
    <EmailContactFlag>true</EmailContactFlag>
    <DateCreated>2017-07-04T15:29:13.22923+10:00</DateCreated>
    <CreatedBySystemUserID>1399</CreatedBySystemUserID>
    <UpdatedBySystemUserID>1399</UpdatedBySystemUserID>
    <Action>I</Action>
  </Contact>
  <DGLicenceVehicle>
    <DGLicenceVehicleID>-1</DGLicenceVehicleID>
    <InstrumentID>-1</InstrumentID>
    <DGVehicleID>2158</DGVehicleID>
    <VariationPendingFlag>false</VariationPendingFlag>
    <EffectiveDateFrom>2017-07-04T15:29:24.59523+10:00</EffectiveDateFrom>
    <DateCreated>2017-07-04T15:29:24.59523+10:00</DateCreated>
    <CreatedBySystemUserID>1399</CreatedBySystemUserID>
    <Action>I</Action>
    <RegistrationNumber>CP5145</RegistrationNumber>
    <VINNumber />
    <RegistrationState>NSW</RegistrationState>
    <LicenceClass>3</LicenceClass>
    <VehicleType>Tanker vehicle</VehicleType>
    <FleetNumber>82</FleetNumber>
    <Capacity>7000</Capacity>
  </DGLicenceVehicle>
  <TransporterLocation>
    <InstrumentTransporterLocationID>1000085</InstrumentTransporterLocationID>
    <InstrumentID>-1</InstrumentID>
    <TransporterLocationID>1000085</TransporterLocationID>
    <LocationName>dsdfsdffad</LocationName>
    <Address>af  asdff , BURWOOD, 2134, NSW</Address>
    <IsRiskZone>false</IsRiskZone>
    <DateCreated>2017-07-04T15:30:16.31823+10:00</DateCreated>
    <CreatedBySystemUserID>1399</CreatedBySystemUserID>
    <Action>U</Action>
  </TransporterLocation>
  <DGLicenceeFitAndProper>
    <DGLicenceeFitAndProperID>-1</DGLicenceeFitAndProperID>
    <InstrumentID>-1</InstrumentID>
    <FitAndProperQuestionID>1</FitAndProperQuestionID>
    <FitAndProperAnswerFlag>false</FitAndProperAnswerFlag>
    <Justification />
    <DateCreated>2017-07-04T15:30:30.46023+10:00</DateCreated>
    <CreatedBySystemUserID>1399</CreatedBySystemUserID>
    <UpdatedBySystemUserID>1399</UpdatedBySystemUserID>
    <Action>I</Action>
  </DGLicenceeFitAndProper>
  <DGLicenceeFitAndProper>
    <DGLicenceeFitAndProperID>1</DGLicenceeFitAndProperID>
    <InstrumentID>-1</InstrumentID>
    <FitAndProperQuestionID>2</FitAndProperQuestionID>
    <FitAndProperAnswerFlag>false</FitAndProperAnswerFlag>
    <Justification />
    <DateCreated>2017-07-04T15:30:30.46023+10:00</DateCreated>
    <CreatedBySystemUserID>1399</CreatedBySystemUserID>
    <UpdatedBySystemUserID>1399</UpdatedBySystemUserID>
    <Action>I</Action>
  </DGLicenceeFitAndProper>
  <DGLicenceeFitAndProper>
    <DGLicenceeFitAndProperID>2</DGLicenceeFitAndProperID>
    <InstrumentID>-1</InstrumentID>
    <FitAndProperQuestionID>3</FitAndProperQuestionID>
    <FitAndProperAnswerFlag>false</FitAndProperAnswerFlag>
    <Justification />
    <DateCreated>2017-07-04T15:30:30.46123+10:00</DateCreated>
    <CreatedBySystemUserID>1399</CreatedBySystemUserID>
    <UpdatedBySystemUserID>1399</UpdatedBySystemUserID>
    <Action>I</Action>
  </DGLicenceeFitAndProper>
  <DGLicenceeFitAndProper>
    <DGLicenceeFitAndProperID>3</DGLicenceeFitAndProperID>
    <InstrumentID>-1</InstrumentID>
    <FitAndProperQuestionID>4</FitAndProperQuestionID>
    <FitAndProperAnswerFlag>false</FitAndProperAnswerFlag>
    <Justification />
    <DateCreated>2017-07-04T15:30:30.46123+10:00</DateCreated>
    <CreatedBySystemUserID>1399</CreatedBySystemUserID>
    <UpdatedBySystemUserID>1399</UpdatedBySystemUserID>
    <Action>I</Action>
  </DGLicenceeFitAndProper>
  <DGLicenceeFitAndProper>
    <DGLicenceeFitAndProperID>4</DGLicenceeFitAndProperID>
    <InstrumentID>-1</InstrumentID>
    <FitAndProperQuestionID>5</FitAndProperQuestionID>
    <FitAndProperAnswerFlag>false</FitAndProperAnswerFlag>
    <Justification />
    <DateCreated>2017-07-04T15:30:30.46123+10:00</DateCreated>
    <CreatedBySystemUserID>1399</CreatedBySystemUserID>
    <UpdatedBySystemUserID>1399</UpdatedBySystemUserID>
    <Action>I</Action>
  </DGLicenceeFitAndProper>
  <DGLicenceeFitAndProper>
    <DGLicenceeFitAndProperID>5</DGLicenceeFitAndProperID>
    <InstrumentID>-1</InstrumentID>
    <FitAndProperQuestionID>6</FitAndProperQuestionID>
    <FitAndProperAnswerFlag>false</FitAndProperAnswerFlag>
    <Justification />
    <DateCreated>2017-07-04T15:30:30.46123+10:00</DateCreated>
    <CreatedBySystemUserID>1399</CreatedBySystemUserID>
    <UpdatedBySystemUserID>1399</UpdatedBySystemUserID>
    <Action>I</Action>
  </DGLicenceeFitAndProper>
  <TransporterLicence>
    <InstrumentID>-1</InstrumentID>
    <LicenceTypeID>0</LicenceTypeID>
    <DateApplicationReceived>2017-07-04T00:00:00+10:00</DateApplicationReceived>
    <DateApplicationCompleted>2017-07-04T00:00:00+10:00</DateApplicationCompleted>
    <AdminFee>0</AdminFee>
    <LicenceDurationID>1409</LicenceDurationID>
    <ConsentForECFlag>false</ConsentForECFlag>
    <Notes>none</Notes>
    <DateCreated>2017-07-04T15:28:43.27723+10:00</DateCreated>
    <CreatedBySystemUserID>1399</CreatedBySystemUserID>
  </TransporterLicence>
</NewDataSet>
'


DECLARE @tblTransporterLicence tblTransporterLicenceType --added on 26-06-2017

	--DECLARE @tblDGLicenceDriver tblDGLicenceDriverType
	DECLARE @tblDGLicenceVehicle tblDGLicenceVehicleType

	DECLARE @tblInstrument tblInstrumentType
	DECLARE @tblAccountableParty tblInstrumentAccountablePartyType
	DECLARE @tblContact tblInstrumentContactType

	DECLARE @tblRadiationLocation tblInstrumentRadiationLocationType
	DECLARE @tblTransporterLocation tblTransporterLocationTypeNew

	DECLARE @tblDGWTLicenceReferral tblDGWTLicenceReferralType
 
	DECLARE	@InstrumentID Int
	 
	DECLARE @CntDGLicenceFitAndProper INT
	DECLARE @tblDGLicenceeFitAndProper tblDGLicenceeFitAndProperType
	DECLARE @DGLicenceeFitAndProperID INT
	DECLARE @FitAndProperQuestionID INT
	DECLARE @FitAndProperAnswerFlag BIT

	DECLARE @CntRadiationLicenceVariation INT
	DECLARE @tblRadiationLicenceVariation tblRadiationLicenceVariationType
	DECLARE @RadiationLicenceVariationID INT
	DECLARE @VariationStatusID INT
	DECLARE @VariationReason varchar(500)

	DECLARE @CntRadiationLicenceRenewal INT
	DECLARE @tblRadiationLicenceRenewal tblRadiationLicenceRenewalType
	DECLARE @RadiationLicenceRenewalID INT
	DECLARE @RenewalNotes varchar(500)
 
	DECLARE	@TInstrumentID Int
    DECLARE @RtnVal int
    DECLARE @TempRowTimeStamp varchar(4000)
    DECLARE @RowTimeStamp varchar(4000)
	DECLARE @INSERT bit	
	DECLARE @Cnt as int
		
	DECLARE @LocNameExists as bit=0
	DECLARE @RowAction char(1)
	DECLARE @CreatedBySystemUserID int
	DECLARE @UpdatedBySystemUserID int
	DECLARE @TempRiskFlag bit
	 
	DECLARE @AuditLogMsg varchar(400)
	DECLARE @Coastal bit
	DECLARE @Enclosed bit
	DECLARE @Estuarine bit	
 
    --Added on 26-06-2017 for Transporter Licence 
    INSERT INTO @tblTransporterLicence
   (
       [InstrumentID]
      ,[LicenceTypeID]
      ,[TrackableWasteTransportTypeID]
      ,[DateApplicationReceived]
      ,[DateApplicationCompleted]
      ,[AdminFee]
      ,[LicenceDurationID]
      ,[ExpiryDate]
      ,[ReviewDueDate]
      ,[ConsentForECFlag]
      ,[Notes]
      ,[TRIMNumber]
      ,[PairedInstrumentID]
      ,[PrimaryTransporterLicenceFlag]
      ,[OldLicenceNumber]
      ,[RenewalNoticeSentDate]
      ,[PendingVariationAlertSentDate]
      ,[DateCreated]
      ,[CreatedBySystemUserID]
      ,[DateUpdated]
      ,[UpdatedBySystemUserID]     
   )
	SELECT   RN.S.value('InstrumentID[1]','int') AS InstrumentID,
	         RN.S.value('LicenceTypeID[1]','int') AS LicenceTypeID,
			 isnull(RN.S.value('TrackableWasteTransportTypeID[1]','int'), 0) AS TrackableWasteTransportTypeID,
			 RN.S.value('DateApplicationReceived[1]','smalldatetime') AS DateApplicationReceived,
			 RN.S.value('DateApplicationCompleted[1]','smalldatetime') AS DateApplicationCompleted,	
			 RN.S.value('AdminFee[1]','money') AS AdminFee,
			 RN.S.value('LicenceDurationID[1]','smallint') AS LicenceDurationID,
			 RN.S.value('ExpiryDate[1]','smalldatetime') AS ExpiryDate,
			 RN.S.value('ReviewDueDate[1]','smalldatetime') AS ReviewDueDate,
			 RN.S.value('ConsentForECFlag[1]','bit') AS ConsentForECFlag,	
			 RN.S.value('Notes[1]','varchar(1000)')  AS Notes,
			 RN.S.value('TRIMNumber[1]','varchar(100)')  AS TRIMNumber,
			 RN.S.value('PairedInstrumentID[1]','int') AS PairedInstrumentID,
			 RN.S.value('PrimaryTransporterLicenceFlag[1]','bit') AS PrimaryTransporterLicenceFlag,
			 RN.S.value('OldLicenceNumber[1]','varchar(100)')  AS OldLicenceNumber,
			 RN.S.value('RenewalNoticeSentDate[1]','smalldatetime') AS RenewalNoticeSentDate,
			 RN.S.value('PendingVariationAlertSentDate[1]','smalldatetime') AS PendingVariationAlertSentDate,
			 GETDATE(),
			 RN.S.value('CreatedBySystemUserID[1]','int') AS CreatedBySystemUserID,
			 null,
			 RN.S.value('UpdatedBySystemUserID[1]','int') AS UpdatedBySystemUserID			  
   FROM @theXmlData.nodes('/NewDataSet/TransporterLicence') AS RN(S)

    INSERT INTO @tblDGLicenceVehicle(
					[DGLicenceVehicleID]
					,[InstrumentID]
					,[DGVehicleID]
					,[VariationPendingFlag]
					,[NewDGLicenceID]
					,[Notes]
					,[EffectiveDateFrom]
					,[EffectiveDateTo]
					,[DateCreated]
					,[CreatedBySystemUserID]
					,[DateUpdated]
					,[UpdatedBySystemUserID]
					,[Action])
	SELECT RN.S.value('DGLicenceVehicleID[1]','int') AS DGLicenceVehicleID,
	         RN.S.value('InstrumentID[1]','int') AS InstrumentID,
			 RN.S.value('DGVehicleID[1]','int') AS DGVehicleID,
			 RN.S.value('VariationPendingFlag[1]','bit') AS VariationPendingFlag,	
			 RN.S.value('NewDGLicenceID[1]','int') AS NewDGLicenceID,
			 RN.S.value('Notes[1]','varchar(255)') AS Notes,
			 RN.S.value('EffectiveDateFrom[1]','smalldatetime') AS EffectiveDateFrom,
			 RN.S.value('EffectiveDateTo[1]','smalldatetime') AS EffectiveDateTo,	
			 GETDATE(),
			 RN.S.value('CreatedBySystemUserID[1]','int') AS CreatedBySystemUserID,
			 null,
			 RN.S.value('UpdatedBySystemUserID[1]','int') AS UpdatedBySystemUserID,
			 RN.S.value('Action[1]','char(1)') AS Action 
   FROM @theXmlData.nodes('/NewDataSet/DGLicenceVehicle') AS RN(S)

 --   INSERT INTO @tblDGLicenceDriver(
	--						  [InstrumentID]
	--						  ,[DriversLicenceNo]
	--						  ,[DriversLicenceClass]
	--						  ,[LicenceIssuedState]
	--						  ,[HeldDriversLicenceForFiveYearsFlag]
	--						  ,[StateTerritoryOfIssue]
	--						  ,[LicenceDisqualifiedFlag]
	--						  ,[DGLicenceRTOID]
	--						  ,[CourseConductedBy]
	--						  ,[DateOfCourse]
	--						  ,[CourseHeldAt]
	--						  ,[MedicalAssessmentID]
	--						  ,[MedicalPractitionerName]
	--						  ,[MedicalPractitionerTelephone]
	--						  ,[DateMedicalExamination]
	--						  ,[DateCreated]
	--						  ,[CreatedBySystemUserID]
	--						  ,[DateUpdated]
	--						  ,[UpdatedBySystemUserID]
	--						  ,[DGLicenceCourseConductedByID]
	--						  ,[TrainingRequiredFlag]
	--						  ,[MFARequiredFlag]	
	--							)
	--SELECT RN.S.value('InstrumentID[1]','int') AS InstrumentID,
	--		 RN.S.value('DriversLicenceNo[1]','varchar(15)') AS DriversLicenceNo,
	--		 RN.S.value('DriversLicenceClass[1]','varchar(15)') AS DriversLicenceClass,
	--		 RN.S.value('LicenceIssuedState[1]','varchar(3)') AS LicenceIssuedState,	
	--		 RN.S.value('HeldDriversLicenceForFiveYearsFlag[1]','bit') AS HeldDriversLicenceForFiveYearsFlag,
	--		 RN.S.value('StateTerritoryOfIssue[1]','varchar(3)') AS StateTerritoryOfIssue,
	--		 RN.S.value('LicenceDisqualifiedFlag[1]','bit') AS LicenceDisqualifiedFlag,
	--		 RN.S.value('DGLicenceRTOID[1]','int') AS DGLicenceRTOID,	
	--		 RN.S.value('CourseConductedBy[1]','varchar(100)')  AS CourseConductedBy,
	--		 RN.S.value('DateOfCourse[1]','smalldatetime') AS DateOfCourse,
	--		 RN.S.value('CourseHeldAt[1]','varchar(100)') AS CourseHeldAt,
	--		 RN.S.value('MedicalAssessmentID[1]','int') AS MedicalAssessmentID,
	--		 RN.S.value('MedicalPractitionerName[1]','varchar(100)') AS MedicalPractitionerName,
	--		 RN.S.value('MedicalPractitionerTelephone[1]','varchar(20)') AS MedicalPractitionerTelephone,
	--		 RN.S.value('DateMedicalExamination[1]','smalldatetime') AS DateMedicalExamination,
	--		 GETDATE(),
	--		 RN.S.value('CreatedBySystemUserID[1]','int') AS CreatedBySystemUserID,
	--		 GETDATE(),
	--		 RN.S.value('UpdatedBySystemUserID[1]','int') AS UpdatedBySystemUserID,
	--		 RN.S.value('DGLicenceCourseConductedByID[1]','int') AS DGLicenceCourseConductedByID,
	--		 RN.S.value('TrainingRequiredFlag[1]','int') AS TrainingRequiredFlag,
	--		 RN.S.value('MFARequiredFlag[1]','int') AS MFARequiredFlag
 --  FROM @theXmlData.nodes('/NewDataSet/DGLicenceDriver') AS RN(S)
   	
    INSERT INTO @tblInstrument(InstrumentID,
							   InstrumentTypeID,
							   InstrumentStatusID,
							   ResponsibleSystemUserID,
							   ResponsibleUserLogin,
							   DECCWSectionID,
							   IssuedBySystemUserID,
							   DateIssued,
							   DisplayFlag,
							   CreatedBySystemUserID,
							   UpdatedBySystemUserID,
							   RowTimestamp)
	SELECT RN.S.value('InstrumentID[1]','int') AS InstrumentID,
		   RN.S.value('InstrumentTypeID[1]','smallint') AS InstrumentTypeID,
		   RN.S.value('InstrumentStatusID[1]','smallint') AS InstrumentStatusID,
		   RN.S.value('ResponsibleSystemUserID[1]','int') AS ResponsibleSystemUserID,
		   RN.S.value('LoginName[1]','varchar(20)') AS ResponsibleUserLogin,
		   RN.S.value('DECCWSectionID[1]','smallint') AS DECCWSectionID,
		   RN.S.value('IssuedBySystemUserID[1]','int') AS IssuedBySystemUserID,
		   RN.S.value('DateIssued[1]','smalldatetime') AS DateIssued,
		   RN.S.value('DisplayFlag[1]','bit') AS DisplayFlag,		 
		   RN.S.value('CreatedBySystemUserID[1]','int') AS CreatedBySystemUserID,
		   RN.S.value('UpdatedBySystemUserID[1]','int') AS UpdatedBySystemUserID,
		   RN.S.value('RowTimestamp[1]','varchar(4000)') AS RowTimestamp
	FROM @theXmlData.nodes('/NewDataSet/Instrument') AS RN(S)
	
	INSERT INTO @tblAccountableParty(InstrumentAccountablePartyID,
									 InstrumentID,
									 AccountablePartyID,
									 LandownerFlag,
									 DescriptionOfRelationship,
									 EffectiveDateFrom,
									 EffectiveDateTo,
									 CreatedBySystemUserID,
									 UpdatedBySystemUserID,
									 RowTimestamp,
									 Action)
	SELECT RN.S.value('InstrumentAccountablePartyID[1]','int') AS InstrumentAccountablePartyID,
		   RN.S.value('InstrumentID[1]','int') AS InstrumentID,
		   RN.S.value('AccountablePartyID[1]','int') AS AccountablePartyID,
		   0,
		   RN.S.value('DescriptionOfRelationship[1]', 'varchar(200)') AS DescriptionOfRelationship,
		   RN.S.value('EffectiveDateFrom[1]', 'smalldatetime') AS EffectiveDateFrom,
		   RN.S.value('EffectiveDateTo[1]', 'smalldatetime') AS EffectiveDateTo,
		   RN.S.value('CreatedBySystemUserID[1]','int') AS CreatedBySystemUserID,
		   RN.S.value('UpdatedBySystemUserID[1]','int') AS UpdatedBySystemUserID,
		   RN.S.value('RowTimestamp[1]','varchar(4000)') AS RowTimestamp,
		   RN.S.value('Action[1]','char(1)') AS Action
	FROM @theXmlData.nodes('/NewDataSet/AccountableParty') AS RN(S)
 	 	
	INSERT INTO @tblContact(InstrumentContactID,
							InstrumentID,
							ContactID,
							PostalContactFlag,
							EmailContactFlag,
							CreatedBySystemUserID,
							UpdatedBySystemUserID,
							RowTimestamp,
							Action)
	SELECT RN.S.value('InstrumentContactID[1]','int') AS InstrumentContactID,
			 RN.S.value('InstrumentID[1]','int') AS InstrumentID,
			 RN.S.value('ContactID[1]','int') AS ContactID,
			 RN.S.value('PostalContactFlag[1]','bit') AS PostalContactFlag,
			 RN.S.value('EmailContactFlag[1]','bit') AS EmailContactFlag,
			 RN.S.value('CreatedBySystemUserID[1]','int') AS CreatedBySystemUserID,
	  	     RN.S.value('UpdatedBySystemUserID[1]','int') AS UpdatedBySystemUserID,
			 RN.S.value('RowTimestamp[1]','varchar(4000)') AS RowTimestamp,
			 RN.S.value('Action[1]','char(1)') AS Action
	FROM @theXmlData.nodes('/NewDataSet/Contact') AS RN(S)
	
	INSERT INTO @tblRadiationLocation(InstrumentRadiationLocationID,
							 InstrumentID,
							 RadiationLocationID,
							 VariationPendingFlag,
							 EffectiveDateFrom,
							 CreatedBySystemUserID,
							 UpdatedBySystemUserID,
							 RowTimestamp,
							 Action)
	SELECT RN.S.value('InstrumentRadiationLocationID[1]','int') AS InstrumentLocationID,
			 RN.S.value('InstrumentID[1]','int') AS InstrumentID,
			 RN.S.value('RadiationLocationID[1]','int') AS RadiationLocationID,
			 RN.S.value('VariationPendingFlag[1]','BIT') AS VariationPendingFlag,
			 RN.S.value('EffectiveDateFrom[1]','smalldatetime') AS EffectiveDateFrom,
			 RN.S.value('CreatedBySystemUserID[1]','int') AS CreatedBySystemUserID,
			 RN.S.value('UpdatedBySystemUserID[1]','int') AS UpdatedBySystemUserID,
			 RN.S.value('RowTimestamp[1]','varchar(4000)') AS RowTimestamp,
			 RN.S.value('Action[1]','char(1)') AS Action
	FROM @theXmlData.nodes('/NewDataSet/InstrumentRadiationLocation') AS RN(S)
	
	INSERT INTO @tblTransporterLocation(
	                         InstrumentTransporterLocationID,
							 InstrumentID,
							 TransporterLocationID,
							 LocationName,
							 [Address],
							 IsRiskZone,
							 CreatedBySystemUserID,
							 UpdatedBySystemUserID,
							 RowTimestamp,
							 Action)
	SELECT RN.S.value('InstrumentTransporterLocationID[1]','int') AS InstrumentTransporterLocationID,
			 RN.S.value('InstrumentID[1]','int') AS InstrumentID,
			 RN.S.value('TransporterLocationID[1]','int') AS TransporterLocationID,
			 RN.S.value('LocationName[1]','varchar(128)') AS LocationName,
			 RN.S.value('Address[1]','varchar(128)') AS [Address],
			 RN.S.value('IsRiskZone[1]','bit') AS IsRiskZone,
			 RN.S.value('CreatedBySystemUserID[1]','int') AS CreatedBySystemUserID,
			 RN.S.value('UpdatedBySystemUserID[1]','int') AS UpdatedBySystemUserID,
			 RN.S.value('RowTimestamp[1]','varchar(4000)') AS RowTimestamp,
			 RN.S.value('Action[1]','char(1)') AS Action
	FROM @theXmlData.nodes('/NewDataSet/TransporterLocation') AS RN(S) 

	INSERT INTO @tblDGWTLicenceReferral
	                         (
	                         DGWTLicenceReferralID,
							 InstrumentID,
							 DataEntryScreen,
							 ReferralTypeID,
							 ReferralTypeText,
							 RequiredNewData,
							 CompletedFlag,
							 CreatedBySystemUserID,
							 UpdatedBySystemUserID,
							 RowTimestamp,
							 Action
							 )
	SELECT RN.S.value('DGWTLicenceReferralID[1]','int') AS DGWTLicenceReferralID,
			 RN.S.value('InstrumentID[1]','int') AS InstrumentID,
			 RN.S.value('DataEntryScreen[1]','varchar(500)') AS DataEntryScreen,
			 RN.S.value('ReferralTypeID[1]','int') AS ReferralTypeID,			 
			 RN.S.value('ReferralTypeText[1]','varchar(500)') AS ReferralTypeText,
			 RN.S.value('RequiredNewData[1]','varchar(250)') AS RequiredNewData,
			 RN.S.value('CompletedFlag[1]','bit') AS CompletedFlag,
			 RN.S.value('CreatedBySystemUserID[1]','int') AS CreatedBySystemUserID,
			 RN.S.value('UpdatedBySystemUserID[1]','int') AS UpdatedBySystemUserID,
			 RN.S.value('RowTimestamp[1]','varchar(4000)') AS RowTimestamp,
			 RN.S.value('Action[1]','char(1)') AS Action
	FROM @theXmlData.nodes('/NewDataSet/DGWTLicenceReferral') AS RN(S) 
 
	INSERT INTO @tblDGLicenceeFitAndProper(
	 [DGLicenceeFitAndProperID]  
	,[InstrumentID]
	,[FitAndProperQuestionID] 
	,[FitAndProperAnswerFlag] 
	,[Justification]
	,[DateCreated]
	,[CreatedBySystemUserID] 
	,[DateUpdated] 
	,[UpdatedBySystemUserID]
	,[Action]
	)
	SELECT RN.S.value('DGLicenceeFitAndProperID[1]','int') AS DGLicenceeFitAndProperID,
		   RN.S.value('InstrumentID[1]','int') AS InstrumentID,
		   RN.S.value('FitAndProperQuestionID[1]','int') AS FitAndProperQuestionID,
		   RN.S.value('FitAndProperAnswerFlag[1]','bit') AS FitAndProperAnswerFlag,
		   RN.S.value('Justification[1]','varchar(500)') AS Justification,
		   RN.S.value('DateCreated[1]','datetime') AS DateCreated,
		   RN.S.value('CreatedBySystemUserID[1]','int') AS CreatedBySystemUserID,
		   RN.S.value('DateUpdated[1]','datetime') AS DateUpdated,
		   RN.S.value('UpdatedBySystemUserID[1]','int') AS UpdatedBySystemUserID,
		   RN.S.value('Action[1]','char(1)') AS Action    
	FROM @theXmlData.nodes('/NewDataSet/DGLicenceeFitAndProper') AS RN(S)

	INSERT INTO @tblRadiationLicenceVariation(
	[RadiationLicenceVariationID],
	[InstrumentID],
	[VariationStatusID],
	[VariationReason],
	[VariationFeeAppliedFlag],
	[RefToRACFlag],
	[VariationCompletedFlag],
	[VariationCompleteDate],
	[VariationCompletedBySystemUserID],
	[DateCreated],
	[CreatedBySystemUserID],
	[DateUpdated],
	[UpdatedBySystemUserID],
	[Action]
	)
	SELECT RN.S.value('RadiationLicenceVariationID[1]','int') AS RadiationLicenceVariationID,
		   RN.S.value('InstrumentID[1]','int') AS InstrumentID,
		   RN.S.value('VariationStatusID[1]','int') AS VariationStatusID,
		   RN.S.value('VariationReason[1]','varchar(500)') AS VariationReason,
		   RN.S.value('VariationFeeAppliedFlag[1]','bit') AS VariationFeeAppliedFlag,
		   RN.S.value('RefToRACFlag[1]','bit') AS RefToRACFlag,
		   RN.S.value('VariationCompletedFlag[1]','bit') AS VariationCompletedFlag,
		   RN.S.value('VariationCompleteDate[1]','datetime') AS VariationCompleteDate,
		   RN.S.value('VariationCompletedBySystemUserID[1]','int') AS VariationCompletedBySystemUserID,
		   RN.S.value('DateCreated[1]','datetime') AS DateCreated,
		   RN.S.value('CreatedBySystemUserID[1]','int') AS CreatedBySystemUserID,
		   RN.S.value('DateUpdated[1]','datetime') AS DateUpdated,
		   RN.S.value('UpdatedBySystemUserID[1]','int') AS UpdatedBySystemUserID,
		   RN.S.value('Action[1]','char(1)') AS Action    
	FROM @theXmlData.nodes('/NewDataSet/RadiationLicenceVariation') AS RN(S)

	INSERT INTO @tblRadiationLicenceRenewal(
	[RadiationLicenceRenewalID],
	[InstrumentID],
    [RenewalStatusID],
    [DateRenewalNoticeSent],
    [LicenceExpiryDate],
    [InvoicePaidFlag],
    [RenewalCompleteDate],
    [RenewalCompletedBySystemUserID],
    [Notes],
	[DateCreated],
	[CreatedBySystemUserID],
	[DateUpdated],
	[UpdatedBySystemUserID],
	[Action]
	)
	SELECT RN.S.value('RadiationLicenceRenewalID[1]','int') AS RadiationLicenceRenewalID,
		   RN.S.value('InstrumentID[1]','int') AS InstrumentID,
		   RN.S.value('RenewalStatusID[1]','int') AS RenewalStatusID,
		   RN.S.value('DateRenewalNoticeSent[1]','datetime') AS DateRenewalNoticeSent,
		   RN.S.value('LicenceExpiryDate[1]','datetime') AS LicenceExpiryDate,
		   RN.S.value('InvoicePaidFlag[1]','bit') AS InvoicePaidFlag,
		   RN.S.value('RenewalCompleteDate[1]','datetime') AS RenewalCompleteDate,
		   RN.S.value('RenewalCompletedBySystemUserID[1]','int') AS RenewalCompletedBySystemUserID,
		   RN.S.value('Notes[1]','varchar(500)') AS Notes,		     		   
		   RN.S.value('DateCreated[1]','datetime') AS DateCreated,
		   RN.S.value('CreatedBySystemUserID[1]','int') AS CreatedBySystemUserID,
		   RN.S.value('DateUpdated[1]','datetime') AS DateUpdated,
		   RN.S.value('UpdatedBySystemUserID[1]','int') AS UpdatedBySystemUserID,
		   RN.S.value('Action[1]','char(1)') AS Action    
	FROM @theXmlData.nodes('/NewDataSet/RadiationLicenceRenewal') AS RN(S)

	-------------------------------------------------------------------------------------------------------------
		
	SELECT @InstrumentID = InstrumentID,@CreatedBySystemUserID = CreatedBySystemUserID,
		   @UpdatedBySystemUserID = UpdatedBySystemUserID
	FROM @tblInstrument

	SELECT @Cnt = count(*) From tblInstrument Where InstrumentID = @InstrumentID
	
	IF @InstrumentID>0 AND @Cnt=1  
	   SELECT @INSERT = 0
	ELSE  
	   SELECT @INSERT = 1
	 
	BEGIN TRAN A

		------------------------- eConnect EPA --------------------------------------

	DECLARE @OnlineDGDLApplicationID INT = 0
	DECLARE @OLDInstrumentId INT = 0

	SELECT @OnlineDGDLApplicationID = RN.S.value('OnlineTLApplicationID[1]','int'),
			@OLDInstrumentId =  RN.S.value('InstrumentId[1]','int')
	FROM @theXmlData.nodes('/NewDataSet/Application') AS RN(S)


	IF @OnlineDGDLApplicationID > 0
		BEGIN
			DECLARE @PaymentTypeID int = 0
			DECLARE @CreditCardPaymentConfirmedFlag BIT = 0
			DECLARE @OLDAccountablePartyID INT  =0 
			DECLARE @TodayDate DATE

			SELECT @TodayDate = GETDATE()

			SELECT @CreatedBySystemUserID = 1

			UPDATE @tblInstrument
			Set ResponsibleSystemUserID = 784


			SELECT @PaymentTypeID = PaymentTypeID, 
				@CreditCardPaymentConfirmedFlag = CreditCardPaymentConfirmedFlag 
			FROM tblOnlineTLApplication 
			WHERE OnlineTLApplicationID = @OnlineDGDLApplicationID 
 
			update @tblTransporterLicence
			set DateApplicationReceived =  dateadd(day, -1, @TodayDate),
				DateApplicationCompleted = dateadd(day, -1, @TodayDate)

			IF @OLDInstrumentId > 0
			BEGIN
				SELECT @OLDAccountablePartyID = AccountablePartyID
				FROM tblInstrumentAccountableParty
				WHERE EffectiveDateTo IS NULL AND InstrumentID = @OLDInstrumentId
			END
			

			DECLARE @BirthDate DATE
			DECLARE @IsOverseasAddr BIT
			DECLARE @TitleId INT
			DECLARE @GivenName VARCHAR(60)
			DECLARE @MiddleName VARCHAR(60)
			DECLARE @Surname VARCHAR(60)
			DECLARE @BusinessName VARCHAR(128)
			DECLARE @Address VARCHAR(120)
			DECLARE @Suburb VARCHAR(100)
			DECLARE @StateCode VARCHAR(20)
			DECLARE @Postcode VARCHAR(10)
			DECLARE @Country VARCHAR(100)
			DECLARE @Unit VARCHAR(100)
			DECLARE @Phone VARCHAR(20)
			DECLARE @Mobile VARCHAR(20)
			DECLARE @Fax VARCHAR(20)
			DECLARE @Email VARCHAR(128)
			DECLARE @AddressID INT
			DECLARE @AccountablePartyID INT
			DECLARE @ContactId INT
	

			SELECT @BirthDate =  RN.S.value('BirthDate[1]','smalldatetime'),
				@IsOverseasAddr =  RN.S.value('IsOverseasAddr[1]','bit'),
				@TitleId =  RN.S.value('TitleId[1]','int'),
				@GivenName =  RN.S.value('GivenName[1]','varchar(60)'),
				@MiddleName =  RN.S.value('MiddleName[1]','varchar(60)'),
				@Surname =  RN.S.value('Surname[1]','varchar(60)'),
				@BusinessName =  RN.S.value('BusinessName[1]','varchar(128)'),
				@Address =  ISNULL(RN.S.value('Unit[1]','varchar(20)'), '') + ' ' + ISNULL(RN.S.value('StreetNo[1]','varchar(20)'), '') + ' ' +  ISNULL(RN.S.value('StreetName[1]','varchar(80)'), ''),
				@Suburb =  RN.S.value('Suburb[1]','varchar(100)'),
				@StateCode =  RN.S.value('State[1]','varchar(20)'),
				@Postcode =  RN.S.value('Postcode[1]','varchar(10)'),
				@Country =  RN.S.value('Country[1]','varchar(100)'),
				@Unit =  RN.S.value('Unit[1]','varchar(100)'),
				@Phone =  RN.S.value('Phone[1]','varchar(20)'),
				@Mobile =  RN.S.value('Mobile[1]','varchar(20)'),
				@Fax =  RN.S.value('Fax[1]','varchar(20)'),
				@Email =  RN.S.value('Email[1]','varchar(128)')
			
			FROM @theXmlData.nodes('/NewDataSet/Applicant') AS RN(S)
			


			SELECT @Address = LTRIM(@Address)

			SELECT @Address = LEFT(@Address,100)

		 
		
			Exec dbo.uspAddAddress 
												 @BusinessName        ,  
												 @Country             ,
												 @IsOverseasAddr  ,					                         
												 @Address, 
  												 @Suburb, 
  												 @Postcode,
  												 @Statecode, 
  												 @CreatedBySystemUserID, 
  												 @AddressID OUTPUT      	
			 
				 select @AddressID

				 IF @OLDAccountablePartyID = 0
				 BEGIN
					    Insert Into dbo.tblAccountableParty
						(
							CompanyFlag,
							ContactRoleFlag,
							--TradingName,
							TitleID,
							GivenName,
							MiddleName,
							Surname,
							AddressID,
							EffectiveDateFrom,
							DateCreated,
							CreatedBySystemUserID,
							DateOfBirth,
							Email,
							Phone,
							Mobile
						)			
						SELECT
							0, 
							0, 
							--@BusinessName,
							@TitleId,
							@GivenName,
							@MiddleName,
							@Surname,
							@AddressID,
							GETDATE(),
							GETDATE() ,
							1,
							@BirthDate,
							@Email,
							@Phone,
							@Mobile


						SET @AccountablePartyID =  @@IDENTITY;
						--SELECT @AccountablePartyID

						UPDATE @tblAccountableParty
						SET AccountablePartyID = @AccountablePartyID
				END
				ELSE
				BEGIN
					UPDATE @tblAccountableParty
					SET AccountablePartyID = @OLDAccountablePartyID

				END				

				Insert into tblContact
					(
						TitleId,
						Surname,
						MiddleName,
						GivenName,
						OrganisationName,
						--Position,
						AddressID,
						Phone,
						Mobile,
						Fax,
						Email,
						EffectiveDateFrom,
						DateCreated,
						CreatedBySystemUserID
					)
				
					SELECT
			
						@TitleId,     --dbo.ufn_GetTitleID(@Title),
						@Surname,
						@MiddleName,
						@GivenName,
						@BusinessName,
						@AddressID,
						@Phone,
						@Mobile,
						@Fax,
						@Email,
						GETDATE(),
						GETDATE(),
						@CreatedBySystemUserID
			
		
				Select @ContactId = @@IDENTITY;

				UPDATE @tblContact
				SET ContactID = @ContactId

		END
	

	---------------------------------- END eConnect EPA --------------------------------------


	--Insert or Update Address
	Exec @InstrumentID = uspSaveInstrument @tblInstrument
	
	IF @InstrumentID < 0 RAISERROR ('Problem saving uspSaveInstrument' , 16, 1)
    
	--Insert/Update Location record	
    IF @INSERT=1
	  BEGIN			 
			INSERT INTO tblTransporterLicence
			(
			   [InstrumentID]
			  ,[LicenceTypeID]
			  ,[TrackableWasteTransportTypeID]
			  ,[DateApplicationReceived]
			  ,[DateApplicationCompleted]
			  ,[AdminFee]
			  ,[LicenceDurationID]
			  ,[ExpiryDate]
			  ,[ReviewDueDate]
			  ,[ConsentForECFlag]
			  ,[Notes]
			  ,[TRIMNumber]
			  ,[PairedInstrumentID]
			  ,[PrimaryTransporterLicenceFlag]
			  ,[OldLicenceNumber]
			  ,[RenewalNoticeSentDate]
			  ,[PendingVariationAlertSentDate]
			  ,[DateCreated]
			  ,[CreatedBySystemUserID]
			  ,[DateUpdated]
			  ,[UpdatedBySystemUserID]     
			)
			Select		  @InstrumentID,
			              case LicenceTypeID when 0 then 0 else LicenceTypeID end,
						  case TrackableWasteTransportTypeID when 0 then 0 else TrackableWasteTransportTypeID end,
						  dateadd(day, 1, DateApplicationReceived),						  
						  dateadd(day, 1, DateApplicationCompleted),
						  AdminFee, 
						  [LicenceDurationID], 
						  [ExpiryDate], 
						  [ReviewDueDate], 
						  [ConsentForECFlag], 
						  [Notes], 
						  [TRIMNumber], 
						  [PairedInstrumentID], 
						  isnull([PrimaryTransporterLicenceFlag], 1), 
						  [OldLicenceNumber], 
						  [RenewalNoticeSentDate], 
						  [PendingVariationAlertSentDate], 
						  [DateCreated], 
						  [CreatedBySystemUserID], 
						  [DateUpdated], 
						  [UpdatedBySystemUserID]     			   
			From @tblTransporterLicence
			SELECT @RtnVal = 0
			EXEC @RtnVal = uspAuditLogInsert @InstrumentID,'Transporter Licence created','Transporter Licence created and Assigned Draft status', @CreatedBySystemUserID, @CreatedBySystemUserID, 1
			
	  END
	ELSE
	  BEGIN  
	   
			--Added on 26-06-2017 for TransporterLicence
	        SELECT @TempRowTimeStamp = RowTimeStamp FROM @tblTransporterLicence WHERE InstrumentID = @InstrumentID			
			SELECT @RowTimeStamp = dbo.ufn_varbintohexstr(RowTimeStamp) FROM @tblTransporterLicence WHERE InstrumentID = @InstrumentID			
			SELECT @CreatedBySystemUserID = @UpdatedBySystemUserID

			UPDATE tblTransporterLicence 
			SET ConsentForECFlag = B.ConsentForECFlag, 
			Notes = B.Notes,
			UpdatedBySystemUserID = B.UpdatedBySystemUserID, 
			DateUpdated = Getdate(),
			AdminFee = B.AdminFee,
			LicenceDurationID=B.LicenceDurationID,
			DateApplicationCompleted = dateadd(day, 1, B.DateApplicationCompleted),
			DateApplicationReceived = dateadd(day, 1, B.DateApplicationReceived),
			LicenceTypeID = B.LicenceTypeID,
			TrackableWasteTransportTypeID = B.TrackableWasteTransportTypeID 
			FROM tblTransporterLicence AS A JOIN @tblTransporterLicence B ON A.InstrumentID = B.InstrumentID     				 
	  END
	
	
	--Insert/Update Accountable Party records
	SELECT @RtnVal =0
	Exec @RtnVal = uspLinkAccountableParties @tblAccountableParty, @InstrumentID
	IF @RtnVal <> 0 RAISERROR ('Problem saving uspLinkAccountableParty' , 16, 1) 
	
	--Insert/Update Contact records
	SELECT @RtnVal =0
	Exec @RtnVal = uspLinkContacts @tblContact, @InstrumentID
	IF @RtnVal <> 0 RAISERROR ('Problem saving uspLinkContacts' , 16, 1) 

	--Insert/Update DGLicenceVehicle records
	--SELECT @RtnVal =0
	--Exec @RtnVal = uspSaveDGLicenceDriver @tblDGLicenceDriver, @InstrumentID
	--IF @RtnVal <> 0 RAISERROR ('Problem saving uspSaveDGLicenceDriver' , 16, 1) 
	
	--Added in 17-10-2016 to update EPA checklist data     
	if exists(SELECT InstrumentID FROM tblDGLicenceVehicle WHERE InstrumentID = @InstrumentID)
	begin
	    declare @CntDGWTLicenceReferral int = 0		 
		SELECT @CntDGWTLicenceReferral = COUNT(*) FROM @tblDGWTLicenceReferral
		IF @CntDGWTLicenceReferral > 0
		BEGIN	
          update a set 
		  a.CompletedFlag = b.CompletedFlag,
		  a.DateUpdated = getdate(),
		  a.UpdatedBySystemUserID = 1
		  from tblDGWTLicenceReferral a inner join @tblDGWTLicenceReferral b 
		  on a.DGWTLicenceReferralID = b.DGWTLicenceReferralID 
		  where a.InstrumentID = @InstrumentID
		END
	end

	--Insert/Update DGLicenceVehicle records
	SELECT @RtnVal =0
	Exec @RtnVal = uspLinkDGVehicle @tblDGLicenceVehicle, @InstrumentID
	IF @RtnVal <> 0 RAISERROR ('Problem saving uspLinkDGVehicle' , 16, 1) 
		
	
	--Insert/Update Location records
	SELECT @RtnVal =0
	Exec @RtnVal = uspRadiationLinkLocations @tblRadiationLocation, @InstrumentID
	IF @RtnVal <> 0 RAISERROR ('Problem saving uspLinkRadiationLocations' , 16, 1) 

	SELECT @RtnVal =0
	Exec @RtnVal = uspLinkTransporterLocations @tblTransporterLocation, @InstrumentID
	IF @RtnVal <> 0 RAISERROR ('Problem saving uspLinkDGVehicleTransportationLocations' , 16, 1) 
			
	SELECT @CntDGLicenceFitAndProper = 0
	SELECT @CntDGLicenceFitAndProper = COUNT(*) FROM @tblDGLicenceeFitAndProper
    IF @CntDGLicenceFitAndProper > 0
	BEGIN	
	-- loop through @tblDGLicenceeFitAndProper records
	-- Add @DGLicenceFitAndProperType list to table tblDGLicenceeFitAndProper
	 
	  SET @Cnt = 1
	  WHILE @Cnt <= @CntDGLicenceFitAndProper
		BEGIN
			
			SELECT @DGLicenceeFitAndProperID = DGLicenceeFitAndProperID, 
			@FitAndProperQuestionID  = FitAndProperQuestionID, 
			@FitAndProperAnswerFlag = FitAndProperAnswerFlag,
			@CreatedBySystemUserID = CreatedBySystemUserID,
			@UpdatedBySystemUserID = UpdatedBySystemUserID,			 
			@RowAction = Action 
			FROM @tblDGLicenceeFitAndProper
			WHERE Sno =  @Cnt
			
			IF @RowAction='I' AND not exists(select * from tblDGLicenceeFitAndProper where InstrumentID = @InstrumentID and FitAndProperQuestionID=@FitAndProperQuestionID)  --Insert new record
  			   BEGIN
					--- PALMS V5.0
					--we need avoid the duplicated FitAndProperQuestionID under the same instrumentID
					if not exists(select * from tblDGLicenceeFitAndProper where InstrumentID = @InstrumentID and FitAndProperQuestionID=@FitAndProperQuestionID)
					begin
						INSERT INTO tblDGLicenceeFitAndProper(       
												   InstrumentID
												  ,FitAndProperQuestionID
												  ,FitAndProperAnswerFlag
												  ,Justification
												  ,DateCreated
												  ,CreatedBySystemUserID											  
												)
						SELECT 	@InstrumentID,
								FitAndProperQuestionID,
								FitAndProperAnswerFlag,
								Justification,
								GetDate(),						  
								CreatedBySystemUserID						    
						FROM @tblDGLicenceeFitAndProper WHERE Sno =  @Cnt    
					end		
				END 
			ELSE IF @RowAction='I' AND exists(select * from tblDGLicenceeFitAndProper where InstrumentID = @InstrumentID and FitAndProperQuestionID=@FitAndProperQuestionID)  --update record
				BEGIN
					UPDATE tblDGLicenceeFitAndProper 
					SET 
					    FitAndProperQuestionID = B.FitAndProperQuestionID,
					    FitAndProperAnswerFlag = @FitAndProperAnswerFlag,
						Justification = B.Justification,				     					 
				 	    DateUpdated = GetDate(),
					    UpdatedBySystemUserID = @UpdatedBySystemUserID					  
					FROM tblDGLicenceeFitAndProper A INNER JOIN @tblDGLicenceeFitAndProper B ON A.DGLicenceeFitAndProperID = B.DGLicenceeFitAndProperID 				 
					Where A.DGLicenceeFitAndProperID = @DGLicenceeFitAndProperID AND A.InstrumentID = @InstrumentID
				END
			ELSE IF @RowAction='D' AND @DGLicenceeFitAndProperID > 0  --Delete record	
			  BEGIN 
			       DELETE FROM tblDGLicenceeFitAndProper
			       WHERE DGLicenceeFitAndProperID = @DGLicenceeFitAndProperID AND InstrumentID = @InstrumentID
			  END  
			  SELECT @Cnt = @Cnt+1
		END 
		-- End of loop
	END  

	--Radiation Licence Variation
	SELECT @CntRadiationLicenceVariation = 0
	SELECT @CntRadiationLicenceVariation = COUNT(*) FROM @tblRadiationLicenceVariation
    IF @CntRadiationLicenceVariation > 0
	BEGIN	
	  SET @Cnt = 1
	  WHILE @Cnt <= @CntRadiationLicenceVariation
		BEGIN
			
			SELECT @RadiationLicenceVariationID = RadiationLicenceVariationID,
			@VariationStatusID = VariationStatusID,
			@VariationReason = VariationReason, 			
			@CreatedBySystemUserID = CreatedBySystemUserID,
			@UpdatedBySystemUserID = UpdatedBySystemUserID,			 
			@RowAction = Action 
			FROM @tblRadiationLicenceVariation
			WHERE Sno =  @Cnt
			
			IF @RowAction='I' AND not exists(select * from tblRadiationLicenceVariation where InstrumentID = @InstrumentID and RadiationLicenceVariationID=@RadiationLicenceVariationID)  --Insert new record
  			   BEGIN
					--- PALMS V5.0
					--we need avoid the duplicated FitAndProperQuestionID under the same instrumentID
					if not exists(select * from tblRadiationLicenceVariation where InstrumentID = @InstrumentID and RadiationLicenceVariationID=@RadiationLicenceVariationID)
					begin

					    --here we back up all existing licence data in case this variation has been terminated then we can restore them back
					    if @VariationStatusID = 812  --pending status					         		   
		                      exec dbo.uspBackUpRadiationLicenceData @InstrumentID 
							  	    
						INSERT INTO tblRadiationLicenceVariation(       
												    InstrumentID,
													VariationStatusID,
													VariationReason,
													VariationFeeAppliedFlag,
													RefToRACFlag,
													VariationCompletedFlag,
													VariationCompleteDate,
													VariationCompletedBySystemUserID, 
												    DateCreated,
												    CreatedBySystemUserID											  
												)
						SELECT 	@InstrumentID,
						        VariationStatusID,
								VariationReason,
								VariationFeeAppliedFlag,
								RefToRACFlag,
								VariationCompletedFlag,
								(case VariationCompletedFlag when 0 then null else VariationCompleteDate end),								
								VariationCompletedBySystemUserID, 
								GetDate(),						  
								CreatedBySystemUserID						    
						FROM @tblRadiationLicenceVariation WHERE Sno =  @Cnt    
					end		
				END 
			ELSE IF @RowAction='I' AND exists(select * from tblRadiationLicenceVariation where InstrumentID = @InstrumentID and RadiationLicenceVariationID=@RadiationLicenceVariationID)  --update record
				BEGIN			    
					--if @VariationStatusID = 814  --complete status					         		   
		   --                   exec dbo.uspDeleteBackUpRadiationLicenceData @InstrumentID

					UPDATE tblRadiationLicenceVariation 
					SET 
					    VariationReason = @VariationReason,	
						VariationStatusID = A.VariationStatusID,
						VariationFeeAppliedFlag = A.VariationFeeAppliedFlag,				     					 
				 	    DateUpdated = GetDate(),
					    UpdatedBySystemUserID = @UpdatedBySystemUserID					  
					FROM tblRadiationLicenceVariation B INNER JOIN @tblRadiationLicenceVariation A ON B.RadiationLicenceVariationID = A.RadiationLicenceVariationID   			 
					Where A.RadiationLicenceVariationID = @RadiationLicenceVariationID AND A.InstrumentID = @InstrumentID
				END
			ELSE IF @RowAction='D' AND @CntRadiationLicenceVariation > 0  --Delete record actually we handle terminate variation here	
			  BEGIN 
					--if @VariationStatusID = 813  --terminated status					         		   
		   --                   exec dbo.uspRestoreRadiationLicenceData @InstrumentID 	

					UPDATE tblRadiationLicenceVariation 
					SET 
					    VariationCompletedFlag =0,	
						VariationStatusID = @VariationStatusID,	
						VariationCompleteDate = null,
						VariationCompletedBySystemUserID = null,					 			     					 
				 	    DateUpdated = GetDate(),
					    UpdatedBySystemUserID = @UpdatedBySystemUserID					  
					FROM tblRadiationLicenceVariation B INNER JOIN @tblRadiationLicenceVariation A ON B.RadiationLicenceVariationID = A.RadiationLicenceVariationID   			 
					Where A.RadiationLicenceVariationID = @RadiationLicenceVariationID AND A.InstrumentID = @InstrumentID

			       --DELETE FROM tblRadiationLicenceVariation
			       --WHERE RadiationLicenceVariationID = @RadiationLicenceVariationID AND InstrumentID = @InstrumentID
			  END  
			  SELECT @Cnt = @Cnt+1
		END 	   
	END

	--Radiation licence renewal 
	SELECT @CntRadiationLicenceRenewal = 0
	SELECT @CntRadiationLicenceRenewal = COUNT(*) FROM @tblRadiationLicenceRenewal
    IF @CntRadiationLicenceRenewal > 0
	BEGIN	
	  SET @Cnt = 1
	  WHILE @Cnt <= @CntRadiationLicenceRenewal
		BEGIN
			
			SELECT @RadiationLicenceRenewalID = RadiationLicenceRenewalID,
			@RenewalNotes = Notes, 			
			@CreatedBySystemUserID = CreatedBySystemUserID,
			@UpdatedBySystemUserID = UpdatedBySystemUserID,			 
			@RowAction = Action 
			FROM @tblRadiationLicenceRenewal
			WHERE Sno =  @Cnt

			IF @RowAction='I' AND exists(select * from tblRadiationLicenceRenewal where InstrumentID = @InstrumentID and RadiationLicenceRenewalID=@RadiationLicenceRenewalID)  --update record
				BEGIN
					UPDATE tblRadiationLicenceRenewal 
					SET 
					    notes = @RenewalNotes,	
						InvoicePaidFlag = A.InvoicePaidFlag,				     					 
				 	    DateUpdated = GetDate(),
					    UpdatedBySystemUserID = @UpdatedBySystemUserID					  
					FROM tblRadiationLicenceRenewal B INNER JOIN @tblRadiationLicenceRenewal A ON B.RadiationLicenceRenewalID = A.RadiationLicenceRenewalID   			 
					Where A.RadiationLicenceRenewalID = @RadiationLicenceRenewalID AND A.InstrumentID = @InstrumentID
				END
			ELSE IF @RowAction='D' AND @CntRadiationLicenceRenewal > 0  --Delete record	
			  BEGIN 
			       DELETE FROM tblRadiationLicenceRenewal
			       WHERE RadiationLicenceRenewalID = @RadiationLicenceRenewalID AND InstrumentID = @InstrumentID
			  END  
			  SELECT @Cnt = @Cnt+1
		END 	   
	END
	--end of radiation licence renewal
 
	--Clock event:Check for Application completed date, If Exists Start the clock.
	DECLARE @AppCompleteDate DateTime
	SELECT @AppCompleteDate =  dateadd(day, 1, DateApplicationCompleted) From @tblTransporterLicence
	
	--we get instrument type id as this SP will be used to handle dangerous good and pesticide licence as well
	DECLARE @InstrumentTypeID int -- 750: radiation licence; 817: Dangerous Goods Licence; 818: Pesticide Licence 
	select @InstrumentTypeID = InstrumentTypeID from tblInstrument where InstrumentID = @InstrumentID
	DECLARE @EventIdTemp int
	SET @EventIdTemp = 0

	if @InstrumentTypeID = 750 --radiation licence	  
	   set @EventIdTemp = 14  --/SB:Event ID 14 is to start clock in tblEvent for Radiation License Clock
    else if @InstrumentTypeID = 817 --Dangerous Goods Licence
	   set @EventIdTemp = 17
	else if @InstrumentTypeID = 818 --Pesticide Licence            
       set @EventIdTemp = 19
	else if  @InstrumentTypeID = 1417 --Transporter Licence            
       set @EventIdTemp = 22

	--SB:Create clock if Instrument status is Draft

	IF (EXISTS(SELECT * FROM tblInstrument WHERE InstrumentID = @InstrumentID AND InstrumentStatusID = 751) AND @AppCompleteDate IS NOT NULL)
   	BEGIN
   			SELECT @RtnVal = 0
			EXEC @RtnVal = uspInstrument_Clock_Create @InstrumentID, @EventIdTemp, 0, @CreatedBySystemUserID, @AppCompleteDate 
	END
	 
	--------------------------------- eConnect EPA    ---------------------------------------
		
	IF @OnlineDGDLApplicationID > 0
	BEGIN
		
		------------------------ create invoice ----------------------------------------------
		DECLARE @OnlineApplicationFee MONEY
		DECLARE @RadiationLicenceInvoiceID INT = 0
		DECLARE @CreditCardPaymentDate SMALLDATETIME
		DECLARE @CreditCardPaymentReceiptNo VARCHAR(20)
			

		SELECT @OnlineApplicationFee = AdminFee 
		FROM tblDGLicence 
		WHERE InstrumentID = @InstrumentID

			
		EXEC uspRadiationCreateLicneceFeeforeConnect @InstrumentID,1,@OnlineApplicationFee,''

		---------- need to address payment --------------------------
			
			
		SELECT @RadiationLicenceInvoiceID = RadiationLicenceInvoiceID
		FROM tblRadiationLicenceInvoice
		WHERE InstrumentID = @InstrumentID

		IF @RadiationLicenceInvoiceID > 0
		BEGIN
			IF @CreditCardPaymentConfirmedFlag = 1 and @PaymentTypeID = 1130
			BEGIN
					
				SELECT @CreditCardPaymentDate = CreditCardPaymentDate, @CreditCardPaymentReceiptNo = CreditCardPaymentReceiptNo
				FROM tblOnlineRADApplication
				WHERE OnlineRADApplicationID = @OnlineDGDLApplicationID

				UPDATE tblRadiationLicenceInvoice
				SET InvoiceBalance = 0,
					PaymentTypeID = 895, 
					PaymentDate = @CreditCardPaymentDate, 
					PaidBySystemUserID = 1,
					ReceiptNumber = @CreditCardPaymentReceiptNo
				WHERE RadiationLicenceInvoiceID = @RadiationLicenceInvoiceID
					
			END
				
		END
			
		-------------------------- update online table ----------------------------------

		UPDATE tblOnlineTLApplication
		SET InstrumentID = @InstrumentID
		WHERE OnlineTLApplicationID = @OnlineDGDLApplicationID

	END
		--------------------------------- END eConnect EPA        ------------------------------------------


			
	COMMIT TRAN A
	--If creating new site return site id else return 0(i.e update sucess)
	IF @INSERT=0 --for updating
		SELECT 0
    ELSE
	    SELECT @InstrumentID --for inserting