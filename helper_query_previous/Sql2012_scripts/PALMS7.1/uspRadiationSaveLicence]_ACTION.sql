declare @theXmlData xml 
set @theXmlData = 
'
<NewDataSet>
  <RadiationLicence>
    <InstrumentID>5017523</InstrumentID>
    <RadiationLicenceTypeID>795</RadiationLicenceTypeID>
    <DateApplicationReceived>2007-11-19T00:00:00+11:00</DateApplicationReceived>
    <LicencetoUseDurationID>768</LicencetoUseDurationID>
    <AdminFee>0.0000</AdminFee>
    <ConsentForECFlag>false</ConsentForECFlag>
    <RefToRACFlag>false</RefToRACFlag>
    <Notes />
    <DateCreated>2008-09-12T19:04:00+10:00</DateCreated>
    <CreatedBySystemUserID>1</CreatedBySystemUserID>
    <DateUpdated>2016-07-28T11:08:00+10:00</DateUpdated>
    <UpdatedBySystemUserID>1399</UpdatedBySystemUserID>
    <RowTimestamp>AAAAAChluog=</RowTimestamp>
    <OldLicenceNumber>RL34667</OldLicenceNumber>
    <MutualRecognitionStateID>1301</MutualRecognitionStateID>
    <AHPRARegistrationNumber>AXAXAXAX</AHPRARegistrationNumber>
    <AHPRAProvisionalFlag>true</AHPRAProvisionalFlag>
    <MutualRecognitionStateText>QLD</MutualRecognitionStateText>
  </RadiationLicence>
  <RadiationLicenceFitAndProper>
    <RadiationLicenceFitAndProperID>69227</RadiationLicenceFitAndProperID>
    <InstrumentID>5017523</InstrumentID>
    <FitAndProperQuestionID>1</FitAndProperQuestionID>
    <FitAndProperAnswerFlag>false</FitAndProperAnswerFlag>
    <Justification />
    <DateCreated>2014-09-11T15:41:00+10:00</DateCreated>
    <CreatedBySystemUserID>1</CreatedBySystemUserID>
    <DateUpdated>2016-07-28T11:08:00+10:00</DateUpdated>
    <UpdatedBySystemUserID>1399</UpdatedBySystemUserID>
    <RowTimestamp>AAAAAChluoo=</RowTimestamp>
    <Action>I</Action>
  </RadiationLicenceFitAndProper>
  <RadiationLicenceFitAndProper>
    <RadiationLicenceFitAndProperID>69228</RadiationLicenceFitAndProperID>
    <InstrumentID>5017523</InstrumentID>
    <FitAndProperQuestionID>2</FitAndProperQuestionID>
    <FitAndProperAnswerFlag>false</FitAndProperAnswerFlag>
    <Justification />
    <DateCreated>2014-09-11T15:41:00+10:00</DateCreated>
    <CreatedBySystemUserID>1</CreatedBySystemUserID>
    <DateUpdated>2016-07-28T11:08:00+10:00</DateUpdated>
    <UpdatedBySystemUserID>1399</UpdatedBySystemUserID>
    <RowTimestamp>AAAAAChluos=</RowTimestamp>
    <Action>I</Action>
  </RadiationLicenceFitAndProper>
  <RadiationLicenceFitAndProper>
    <RadiationLicenceFitAndProperID>69229</RadiationLicenceFitAndProperID>
    <InstrumentID>5017523</InstrumentID>
    <FitAndProperQuestionID>3</FitAndProperQuestionID>
    <FitAndProperAnswerFlag>false</FitAndProperAnswerFlag>
    <Justification />
    <DateCreated>2014-09-11T15:41:00+10:00</DateCreated>
    <CreatedBySystemUserID>1</CreatedBySystemUserID>
    <DateUpdated>2016-07-28T11:08:00+10:00</DateUpdated>
    <UpdatedBySystemUserID>1399</UpdatedBySystemUserID>
    <RowTimestamp>AAAAAChluow=</RowTimestamp>
    <Action>I</Action>
  </RadiationLicenceFitAndProper>
  <RadiationLicenceFitAndProper>
    <RadiationLicenceFitAndProperID>69230</RadiationLicenceFitAndProperID>
    <InstrumentID>5017523</InstrumentID>
    <FitAndProperQuestionID>4</FitAndProperQuestionID>
    <FitAndProperAnswerFlag>false</FitAndProperAnswerFlag>
    <Justification />
    <DateCreated>2014-09-11T15:41:00+10:00</DateCreated>
    <CreatedBySystemUserID>1</CreatedBySystemUserID>
    <DateUpdated>2016-07-28T11:08:00+10:00</DateUpdated>
    <UpdatedBySystemUserID>1399</UpdatedBySystemUserID>
    <RowTimestamp>AAAAAChluo0=</RowTimestamp>
    <Action>I</Action>
  </RadiationLicenceFitAndProper>
  <Instrument>
    <InstrumentID>5017523</InstrumentID>
    <InstrumentTypeID>750</InstrumentTypeID>
    <InstrumentStatusID>751</InstrumentStatusID>
    <ResponsibleSystemUserID>784</ResponsibleSystemUserID>
    <ResponsibleUser>Radiation ** (SP)</ResponsibleUser>
    <LoginName>SP</LoginName>
    <DECCWSectionID>7</DECCWSectionID>
    <IssuedBySystemUserID>1</IssuedBySystemUserID>
    <IssuedBy>Generated System</IssuedBy>
    <DisplayFlag>false</DisplayFlag>
    <DateCreated>2008-09-12T19:04:00+10:00</DateCreated>
    <CreatedBySystemUserID>1</CreatedBySystemUserID>
    <DateUpdated>2016-07-28T11:08:00+10:00</DateUpdated>
    <UpdatedBySystemUserID>1399</UpdatedBySystemUserID>
    <RowTimestamp>0x000000002865ba87</RowTimestamp>
    <HasRecordService>false</HasRecordService>
    <HasActiveVariation>false</HasActiveVariation>
    <HasActiveSystemNotice>false</HasActiveSystemNotice>
    <SystemNoticeName />
    <SectionName>Hazardous Materials, Chemicals &amp; Radiation</SectionName>
    <HasActiveCorrection>false</HasActiveCorrection>
  </Instrument>
  <AccountableParty>
    <InstrumentAccountablePartyID>29131</InstrumentAccountablePartyID>
    <InstrumentID>5017523</InstrumentID>
    <AccountablePartyID>14033</AccountablePartyID>
    <AccountablePartyName>Irma Villaflor</AccountablePartyName>
    <AddressABN>Childrens Medical Research Institute, 214 Hawkesbury Rd , WESTMEAD, 2145, NSW, AUSTRALIA</AddressABN>
    <LandownerFlag>false</LandownerFlag>
    <DescriptionOfRelationship>Applicant</DescriptionOfRelationship>
    <EffectiveDateFrom>2007-11-19T00:00:00+11:00</EffectiveDateFrom>
    <DateCreated>2008-09-12T19:16:00+10:00</DateCreated>
    <CreatedBySystemUserID>1</CreatedBySystemUserID>
    <DateUpdated>2008-09-12T19:16:00+10:00</DateUpdated>
    <UpdatedBySystemUserID>1</UpdatedBySystemUserID>
    <RowTimestamp>0x0000000000d32ca8</RowTimestamp>
    <CompanyFlag>false</CompanyFlag>
  </AccountableParty>
  <Contact>
    <InstrumentContactID>45204</InstrumentContactID>
    <InstrumentID>5017523</InstrumentID>
    <ContactID>34575</ContactID>
    <ContactName>Irma Villaflor</ContactName>
    <Address>Childrens Medical Research Institute, 214 Hawkesbury Rd , WESTMEAD, 2145, NSW, AUSTRALIA</Address>
    <PostalContactFlag>true</PostalContactFlag>
    <EmailContactFlag>false</EmailContactFlag>
    <DateCreated>2008-09-12T19:16:00+10:00</DateCreated>
    <CreatedBySystemUserID>1</CreatedBySystemUserID>
    <DateUpdated>2016-07-28T11:08:00+10:00</DateUpdated>
    <UpdatedBySystemUserID>1399</UpdatedBySystemUserID>
    <RowTimestamp>0x000000002865ba89</RowTimestamp>
    <Action>U</Action>
  </Contact>
  <RadiationLicenceCondition>
    <RadiationLicenceConditionID>35895</RadiationLicenceConditionID>
    <InstrumentID>5017523</InstrumentID>
    <RadiationConditionID>90</RadiationConditionID>
    <DateCreated>2008-09-12T19:09:00+10:00</DateCreated>
    <CreatedBySystemUserID>1</CreatedBySystemUserID>
    <DateUpdated>2008-09-12T19:09:00+10:00</DateUpdated>
    <UpdatedBySystemUserID>1</UpdatedBySystemUserID>
    <RowTimestamp>AAAAAADU1a8=</RowTimestamp>
    <Action>I</Action>
    <CreatorName>System Generated</CreatorName>
    <RadiationConditionName>S8</RadiationConditionName>
    <RadiationConditionDesc>Use radioactive substances for scientific or research purposes</RadiationConditionDesc>
    <ApparatusRequiredFlag>false</ApparatusRequiredFlag>
    <SubstanceRequiredFlag>true</SubstanceRequiredFlag>
    <MutualRecognitionFlag>false</MutualRecognitionFlag>
    <AHPRARegistrationFlag>false</AHPRARegistrationFlag>
    <RequiredSpecialityFlag>false</RequiredSpecialityFlag>
  </RadiationLicenceCondition>
  <RadiationLicenceCondition>
    <RadiationLicenceConditionID>35896</RadiationLicenceConditionID>
    <InstrumentID>5017523</InstrumentID>
    <RadiationConditionID>1</RadiationConditionID>
    <DateCreated>2016-07-28T11:23:59.8003505+10:00</DateCreated>
    <CreatedBySystemUserID>1399</CreatedBySystemUserID>
    <Action>I</Action>
    <CreatorName>Eric He</CreatorName>
    <RadiationConditionName>EA1</RadiationConditionName>
    <RadiationConditionDesc>Registrar - Nuclear Medicine</RadiationConditionDesc>
    <ApparatusRequiredFlag>false</ApparatusRequiredFlag>
    <SubstanceRequiredFlag>false</SubstanceRequiredFlag>
    <MutualRecognitionFlag>false</MutualRecognitionFlag>
    <AHPRARegistrationFlag>false</AHPRARegistrationFlag>
    <RequiredSpecialityFlag>false</RequiredSpecialityFlag>
    <AHPRANoReason>I am eric he</AHPRANoReason>
  </RadiationLicenceCondition> 
</NewDataSet>
'

SET NOCOUNT ON

	BEGIN TRY

	DECLARE @TempRadiationLicenceTypeID INT

	DECLARE @tblRadiationLicence tblRadiationLicenceType

	DECLARE @tblInstrument tblInstrumentType
	DECLARE @tblAccountableParty tblInstrumentAccountablePartyType
	DECLARE @tblContact tblInstrumentContactType

	DECLARE @tblRadiationLocation tblInstrumentRadiationLocationType
	DECLARE @tblRadiationLicenceQualification tblRadiationLicenceQualificationType
	DECLARE @CntRadiationLicenceQualification as int
	DECLARE @RadiationLicenceQualificationID as int
	DECLARE @QualificationID as int
	DECLARE	@InstrumentID Int
	DECLARE @tblRadiationLicenceAccreditationType tblRadiationLicenceAccreditationTypeType

	DECLARE @CntRadiationLicenceAccreditationType INT
	DECLARE @RadiationLicenceAccreditationTypeID INT
	DECLARE @AccreditationTypeID INT	 

	DECLARE @CntRadiationLicenceFitAndProper INT
	DECLARE @tblRadiationLicenceFitAndProper tblRadiationLicenceFitAndProperType
	DECLARE @RadiationLicenceFitAndProperID INT
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

	DECLARE @CntRadiationLicenceCondition INT
	DECLARE @tblRadiationLicenceCondition tblRadiationLicenceConditionType
	DECLARE @RadiationLicenceConditionID INT	
	DECLARE @RadiationConditionID INT

	DECLARE @CntRadiationLicenceRadioactiveApparatus INT
	DECLARE @tblRadiationLicenceRadioactiveApparatus tblRadiationLicenceRadioactiveApparatusType
	DECLARE @RadiationLicenceRadioactiveApparatusID INT
	DECLARE @RadiationApparatuID smallint

	DECLARE @CntRadiationLicenceRadioactiveSubstances INT
	DECLARE @tblRadiationLicenceRadioactiveSubstances tblRadiationLicenceRadioactiveSubstancesType
	DECLARE @RadiationLicenceRadioactiveSubstancesID INT
	DECLARE @RadioactiveSubstanceTypeID smallint

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
	DECLARE @tblRadiationLicenceLicenceEnvironmentalRiskLevelType tblPOEOLicenceEnvironmentalRiskLevelType
	 
	SELECT @TempRadiationLicenceTypeID = xmlVals.rowvals.value('(RadiationLicenceTypeID)[1]','INT')			 
	From @theXmlData.nodes('//NewDataSet/RadiationLicence') as xmlVals(rowvals)	
	

	--In order to handle radiation licence for licence to use report type we add these data handlers 27-07-2016 Eric He
	-------------------------------------------------------
	if @TempRadiationLicenceTypeID = 795
	begin
	     declare @TempMutualRecognitionStateID Int
		 declare @TempAHPRARegistrationNumber varchar(20)
		 declare @TempAHPRAProvisionalFlag bit

		 SELECT @TempMutualRecognitionStateID = RN.S.value('MutualRecognitionStateID[1]','int'),
			   @TempAHPRARegistrationNumber = RN.S.value('AHPRARegistrationNumber[1]','varchar(20)'),
			   @TempAHPRAProvisionalFlag = RN.S.value('AHPRAProvisionalFlag[1]','bit') 
		 FROM @theXmlData.nodes('/NewDataSet/RadiationLicence') AS RN(S)

		 --declare @TempMutualRecognitionFlag bit
		 --declare @TempAHPRARegistrationFlag bit
		 --declare @TempRequiredSpecialityFlag bit
		 --declare @TempAHPRANoReason varchar(500)
		 --declare @TempSpecialtyNoReason varchar(500)

		 --SELECT @TempMutualRecognitionFlag = RN.S.value('MutualRecognitionFlag[1]', 'bit'),
			--    @TempAHPRARegistrationFlag = RN.S.value('AHPRARegistrationFlag[1]', 'bit'),
			--    @TempRequiredSpecialityFlag = RN.S.value('RequiredSpecialityFlag[1]', 'bit'),
			--	@TempAHPRANoReason = RN.S.value('AHPRANoReason[1]','varchar(500)'),
			--	@TempSpecialtyNoReason = RN.S.value('SpecialtyNoReason[1]','varchar(500)')
		 --FROM @theXmlData.nodes('/NewDataSet/RadiationLicenceCondition') AS RN(S)
	end
	--------------------------------------------------------
	--End of In order to handle radiation licence



	INSERT INTO @tblRadiationLicence(
			[InstrumentID],
			[RadiationLicenceTypeID],
			[DateApplicationReceived],
			[DateApplicationCompleted],
			[ManagementLicenceActivityandDurationID],
			[LicencetoUseDurationID],
			[AdminFee],
			[ExpiryDate],
			[ReviewDueDate],
			[LicencetoUseInstrumentID],
			[ConsentForECFlag],
			[RefToRACFlag],
			[Notes],
			[DateCreated],
			[CreatedBySystemUserID],
			[DateUpdated],
			[UpdatedBySystemUserID])
	SELECT RN.S.value('InstrumentID[1]','int') AS InstrumentID,
	         RN.S.value('RadiationLicenceTypeID[1]','int') AS RadiationLicenceTypeID,
			 RN.S.value('DateApplicationReceived[1]','smalldatetime') AS DateApplicationReceived,
			 RN.S.value('DateApplicationCompleted[1]','smalldatetime') AS DateApplicationCompleted,	
			 (case @TempRadiationLicenceTypeID when 796 then RN.S.value('ManagementLicenceActivityandDurationID[1]','int') else null end) as ManagementLicenceActivityandDurationID,
			 (case @TempRadiationLicenceTypeID when 795 then RN.S.value('LicencetoUseDurationID[1]','int') else null end) as LicencetoUseDurationID,			 			 		
			 RN.S.value('AdminFee[1]','money') AS AdminFee,
			 RN.S.value('ExpiryDate[1]','smalldatetime') AS ExpiryDate,
			 RN.S.value('ReviewDueDate[1]','smalldatetime') AS ReviewDueDate,
			 RN.S.value('LicencetoUseInstrumentID[1]','int') AS LicencetoUseInstrumentID,	 		 
			 RN.S.value('ConsentForECFlag[1]','bit') AS ConsentForECFlag,
			 RN.S.value('RefToRACFlag[1]','bit') AS RefToRACFlag,			  
			 --(case @TempRadiationLicenceTypeID when 794 then RN.S.value('Notes[1]','varchar(1000)') else null end) AS Notes,
			 RN.S.value('Notes[1]','varchar(1000)')  AS Notes,
			 GETDATE(),
			 RN.S.value('CreatedBySystemUserID[1]','int') AS CreatedBySystemUserID,
			 null,
			 RN.S.value('UpdatedBySystemUserID[1]','int') AS UpdatedBySystemUserID 
   FROM @theXmlData.nodes('/NewDataSet/RadiationLicence') AS RN(S)
	
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
	
 
	INSERT INTO @tblRadiationLicenceQualification(
       [RadiationLicenceQualificationID]
      ,[InstrumentID]
      ,[QualificationID]
      ,[DateCreated]
      ,[CreatedBySystemUserID]
      ,[DateUpdated]
      ,[UpdatedBySystemUserID]
      ,[Action]
	)
	SELECT RN.S.value('RadiationLicenceQualificationID[1]','int') AS RadiationLicenceQualificationID,
		   RN.S.value('InstrumentID[1]','int') AS InstrumentID,
		   RN.S.value('QualificationID[1]','int') AS QualificationID,
		   RN.S.value('DateCreated[1]','datetime') AS DateCreated,
		   RN.S.value('CreatedBySystemUserID[1]','int') AS CreatedBySystemUserID,
		   RN.S.value('DateUpdated[1]','datetime') AS DateUpdated,
		   RN.S.value('UpdatedBySystemUserID[1]','int') AS UpdatedBySystemUserID,
		   RN.S.value('Action[1]','char(1)') AS Action    
	FROM @theXmlData.nodes('/NewDataSet/RadiationLicenceQualification') AS RN(S)

	INSERT INTO @tblRadiationLicenceAccreditationType(
	 [RadiationLicenceAccreditationTypeID]  
	,[InstrumentID]
	,[AccreditationTypeID]  
	,[DateCreated]
	,[CreatedBySystemUserID] 
	,[DateUpdated] 
	,[UpdatedBySystemUserID]
	,[Action]
	)
	SELECT RN.S.value('RadiationLicenceAccreditationTypeID[1]','int') AS RadiationLicenceAccreditationTypeID,
		   RN.S.value('InstrumentID[1]','int') AS InstrumentID,
		   RN.S.value('AccreditationTypeID[1]','int') AS AccreditationTypeID,
		   RN.S.value('DateCreated[1]','datetime') AS DateCreated,
		   RN.S.value('CreatedBySystemUserID[1]','int') AS CreatedBySystemUserID,
		   RN.S.value('DateUpdated[1]','datetime') AS DateUpdated,
		   RN.S.value('UpdatedBySystemUserID[1]','int') AS UpdatedBySystemUserID,
		   RN.S.value('Action[1]','char(1)') AS Action    
	FROM @theXmlData.nodes('/NewDataSet/RadiationLicenceAccreditationType') AS RN(S)

	INSERT INTO @tblRadiationLicenceFitAndProper(
	 [RadiationLicenceFitAndProperID]  
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
	SELECT RN.S.value('RadiationLicenceFitAndProperID[1]','int') AS RadiationLicenceFitAndProperID,
		   RN.S.value('InstrumentID[1]','int') AS InstrumentID,
		   RN.S.value('FitAndProperQuestionID[1]','int') AS FitAndProperQuestionID,
		   RN.S.value('FitAndProperAnswerFlag[1]','bit') AS FitAndProperAnswerFlag,
		   RN.S.value('Justification[1]','varchar(500)') AS Justification,
		   RN.S.value('DateCreated[1]','datetime') AS DateCreated,
		   RN.S.value('CreatedBySystemUserID[1]','int') AS CreatedBySystemUserID,
		   RN.S.value('DateUpdated[1]','datetime') AS DateUpdated,
		   RN.S.value('UpdatedBySystemUserID[1]','int') AS UpdatedBySystemUserID,
		   RN.S.value('Action[1]','char(1)') AS Action    
	FROM @theXmlData.nodes('/NewDataSet/RadiationLicenceFitAndProper') AS RN(S)

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

	--RadiationLicenceCondition table
	INSERT INTO @tblRadiationLicenceCondition(
       [RadiationLicenceConditionID]
      ,[InstrumentID]
      ,[RadiationConditionID]
      ,[DateCreated]
      ,[CreatedBySystemUserID]
      ,[DateUpdated]
      ,[UpdatedBySystemUserID]
      ,[Action]
	  ,[MutualRecognitionFlag]
	  ,[AHPRARegistrationFlag]
	  ,[RequiredSpecialityFlag]
	  ,[AHPRANoReason]
	  ,[SpecialtyNoReason]
	)
	SELECT RN.S.value('RadiationLicenceConditionID[1]','int') AS RadiationLicenceConditionID,
		   RN.S.value('InstrumentID[1]','int') AS InstrumentID,
		   RN.S.value('RadiationConditionID[1]','int') AS RadiationConditionID,		 
		   RN.S.value('DateCreated[1]','datetime') AS DateCreated,
		   RN.S.value('CreatedBySystemUserID[1]','int') AS CreatedBySystemUserID,
		   RN.S.value('DateUpdated[1]','datetime') AS DateUpdated,
		   RN.S.value('UpdatedBySystemUserID[1]','int') AS UpdatedBySystemUserID,
		   RN.S.value('Action[1]','char(1)') AS Action,		       
		   RN.S.value('MutualRecognitionFlag[1]','bit') AS MutualRecognitionFlag,
		   RN.S.value('AHPRARegistrationFlag[1]','bit') AS AHPRARegistrationFlag,
		   RN.S.value('RequiredSpecialityFlag[1]','bit') AS RequiredSpecialityFlag,
		   RN.S.value('AHPRANoReason[1]','varchar(500)') AS AHPRANoReason,
		   RN.S.value('SpecialtyNoReason[1]','varchar(500)') AS SpecialtyNoReason
	FROM @theXmlData.nodes('/NewDataSet/RadiationLicenceCondition') AS RN(S)

	--tblRadiationLicenceRadioactiveApparatus
	INSERT INTO @tblRadiationLicenceRadioactiveApparatus(
       [RadiationLicenceRadioactiveApparatusID]
      ,[InstrumentID]
      ,[RadiationApparatuID]
      ,[MaximummA]
      ,[MaximumkVp]
      ,[PurposeOfUse]
      ,[DateCreated]
      ,[CreatedBySystemUserID]
      ,[DateUpdated]
      ,[UpdatedBySystemUserID]    
      ,[Action]
	  ,[RadiationConditionID]
	)
	SELECT RN.S.value('RadiationLicenceRadioactiveApparatusID[1]','int') AS RadiationLicenceRadioactiveApparatusID,
		   RN.S.value('InstrumentID[1]','int') AS InstrumentID,
		   RN.S.value('RadiationApparatuID[1]','int') AS RadiationApparatuID,	
		   RN.S.value('MaximummA[1]','int') AS MaximummA,	
		   RN.S.value('MaximumkVp[1]','int') AS MaximumkVp,	
		   RN.S.value('PurposeOfUse[1]','varchar(255)') AS PurposeOfUse, 	 
		   RN.S.value('DateCreated[1]','datetime') AS DateCreated,
		   RN.S.value('CreatedBySystemUserID[1]','int') AS CreatedBySystemUserID,
		   RN.S.value('DateUpdated[1]','datetime') AS DateUpdated,
		   RN.S.value('UpdatedBySystemUserID[1]','int') AS UpdatedBySystemUserID,
		   RN.S.value('Action[1]','char(1)') AS Action,
		   RN.S.value('RadiationConditionID[1]','int') AS RadiationConditionID    
	FROM @theXmlData.nodes('/NewDataSet/RadiationLicenceRadioactiveApparatus') AS RN(S)

	--tblRadiationLicenceRadioactiveSubstances
	INSERT INTO @tblRadiationLicenceRadioactiveSubstances(
       [RadiationLicenceRadioactiveSubstancesID]
      ,[InstrumentID]
      ,[RadioactiveSubstanceTypeID]
      ,[MaxActivity]
      ,[MaxActivityUOMID]
      ,[RadionuclideID]
      ,[PurposeOfUse]
      ,[DateCreated]
      ,[CreatedBySystemUserID]
      ,[DateUpdated]
      ,[UpdatedBySystemUserID]
      ,[Action]
	  ,[RadiationConditionID]
	)
	SELECT RN.S.value('RadiationLicenceRadioactiveSubstancesID[1]','int') AS RadiationLicenceRadioactiveSubstancesID,
		   RN.S.value('InstrumentID[1]','int') AS InstrumentID,
		   RN.S.value('RadioactiveSubstanceTypeID[1]','int') AS RadioactiveSubstanceTypeID,	
		   RN.S.value('MaxActivity[1]','bigint') AS MaxActivity,	
		   RN.S.value('MaxActivityUOMID[1]','int') AS MaxActivityUOMID,	
		   RN.S.value('RadionuclideID[1]','int') AS RadionuclideID,	
		   RN.S.value('PurposeOfUse[1]','varchar(255)') AS PurposeOfUse, 	 
		   RN.S.value('DateCreated[1]','datetime') AS DateCreated,
		   RN.S.value('CreatedBySystemUserID[1]','int') AS CreatedBySystemUserID,
		   RN.S.value('DateUpdated[1]','datetime') AS DateUpdated,
		   RN.S.value('UpdatedBySystemUserID[1]','int') AS UpdatedBySystemUserID,
		   RN.S.value('Action[1]','char(1)') AS Action,
		   RN.S.value('RadiationConditionID[1]','int') AS RadiationConditionID    
	FROM @theXmlData.nodes('/NewDataSet/RadiationLicenceRadioactiveSubstances') AS RN(S)
	-------------------------------------------------------------------------------------------------------------
		
	SELECT @InstrumentID = InstrumentID,@CreatedBySystemUserID = CreatedBySystemUserID,
		   @UpdatedBySystemUserID = UpdatedBySystemUserID
	FROM @tblInstrument

	SELECT @Cnt = count(*) From tblInstrument Where InstrumentID = @InstrumentID
	
	IF @InstrumentID>0 AND @Cnt=1  
	   SELECT @INSERT = 0
	ELSE  
	   SELECT @INSERT = 1
	
	--here we check radiationlicencetypeid
	--it is value range:
    --[DescriptionAttribute("Radiation Management Licence")]
    --RadiationManagementLicence = 796,

    --[DescriptionAttribute("Radiation Licence To Use")]
    --RadiationLicenceToUse = 795,

    --[DescriptionAttribute("Radiation Accreditation")]
    --RadiationAccredication = 794

	
	--SELECT @TempRadiationLicenceTypeID = RadiationLicenceTypeID FROM @tblRadiationLicence WHERE InstrumentID = @InstrumentID

	--BEGIN TRAN A
	--Insert or Update Address
	Exec @InstrumentID = uspSaveInstrument @tblInstrument
	
	IF @InstrumentID < 0 RAISERROR ('Problem saving uspSaveInstrument' , 16, 1)
    
	

	--Insert/Update Location record	
    IF @INSERT=1
	  BEGIN
			--- PALMS V5.0 ----------------------
			--Management licence expiry date calculation
			--765: Sell, possess, store or give away regulated material (including radiation apparatus, radioactive substances or items containing radioactive substances) for 1 year
			--766: Sell regulated material (including radiation apparatus, radioactive substances or items containing radioactive substances) for 1 year (sell only)
			--767: Sell regulated material (including radiation apparatus, radioactive substances or items containing radioactive substances) for 3 years (sell only)

		    INSERT INTO tblRadiationLicence(
						[InstrumentID],
						[RadiationLicenceTypeID],
						[DateApplicationReceived],
						[DateApplicationCompleted],
						[ManagementLicenceActivityandDurationID],
						[LicencetoUseDurationID],
						[AdminFee],
						--[ExpiryDate],
						[ReviewDueDate],
						[LicencetoUseInstrumentID],
						[ConsentForECFlag],
						[RefToRACFlag],
						[Notes],
						[DateCreated],
						[CreatedBySystemUserID],
						[DateUpdated],
						[UpdatedBySystemUserID],
						[MutualRecognitionStateID],
						[AHPRARegistrationNumber],
						[AHPRAProvisionalFlag]
						)
			Select		  @InstrumentID,
			              RadiationLicenceTypeID,
						  dateadd(day, 1, DateApplicationReceived),						  
						  dateadd(day, 1, DateApplicationCompleted),
						  ManagementLicenceActivityandDurationID,
						  LicencetoUseDurationID,
						  AdminFee,

						  --case isnull(DateApplicationCompleted, '') when '' then null 
						  --else
								--  (case [RadiationLicenceTypeID] 
								--  when 794 then DATEADD(year, 1, DateApplicationCompleted)    --Accreditation
								--  when 795 then (case LicencetoUseDurationID when 768 then  DATEADD(year, 1, DateApplicationCompleted)
								--											 when 769 then DATEADD(year, 3, DateApplicationCompleted) end
								--  )    --Licence to use
								--  when 796 then ( 
								--		case ManagementLicenceActivityandDurationID when 765 then DATEADD(year, 1, DateApplicationCompleted)
								--													when 766 then DATEADD(year, 1, DateApplicationCompleted)
								--													when 767 then DATEADD(year, 3, DateApplicationCompleted) end
								--  )    --Management licence
								--  end)
						  --end
						  --, 						  
						  ReviewDueDate,						 
						  LicencetoUseInstrumentID,
						  ConsentForECFlag,
						  RefToRACFlag,
						  Notes,
						  DateCreated,
						  CreatedBySystemUserID,
						  DateUpdated,
						  UpdatedBySystemUserID,
						  (case @TempRadiationLicenceTypeID  when 795 then @TempMutualRecognitionStateID else null end) as MutualRecognitionStateID,
						  (case @TempRadiationLicenceTypeID  when 795 then @TempAHPRARegistrationNumber else null end) as AHPRARegistrationNumber,
						  (case @TempRadiationLicenceTypeID  when 795 then @TempAHPRAProvisionalFlag else null end) as AHPRAProvisionalFlag
			From @tblRadiationLicence
			
			--Add an entry in to Audit log table
			SELECT @RtnVal = 0
			EXEC @RtnVal = uspAuditLogInsert @InstrumentID,'Radiation Licence created','Radiation Licence created and Assigned Draft status',@CreatedBySystemUserID,@CreatedBySystemUserID,1
			
	  END
	ELSE
	  BEGIN  
	        SELECT @TempRowTimeStamp = RowTimeStamp FROM @tblRadiationLicence WHERE InstrumentID = @InstrumentID			
			SELECT @RowTimeStamp = dbo.ufn_varbintohexstr(RowTimeStamp) FROM @tblRadiationLicence WHERE InstrumentID = @InstrumentID			
			SELECT @CreatedBySystemUserID = @UpdatedBySystemUserID

			UPDATE tblRadiationLicence 
			SET ConsentForECFlag = B.ConsentForECFlag, 
			Notes = B.Notes,
			RefToRACFlag = B.RefToRACFlag, 
			UpdatedBySystemUserID = B.UpdatedBySystemUserID, 
			DateUpdated = Getdate(),
			LicencetoUseDurationID = B.LicencetoUseDurationID,
			ManagementLicenceActivityandDurationID = B.ManagementLicenceActivityandDurationID,
			--AdminFee = B.AdminFee,
			DateApplicationCompleted = dateadd(day, 1, B.DateApplicationCompleted),
			DateApplicationReceived = dateadd(day, 1, B.DateApplicationReceived),
			[MutualRecognitionStateID] = (case @TempRadiationLicenceTypeID when 795 then @TempMutualRecognitionStateID else null end),
			[AHPRARegistrationNumber] = (case @TempRadiationLicenceTypeID when 795 then @TempAHPRARegistrationNumber else null end),
			[AHPRAProvisionalFlag] = (case @TempRadiationLicenceTypeID when 795 then @TempAHPRAProvisionalFlag else null end) 			  
			FROM tblRadiationLicence AS A JOIN @tblRadiationLicence B ON A.InstrumentID = B.InstrumentID        			 
	  END
	
	
	--Insert/Update Accountable Party records
	SELECT @RtnVal =0
	Exec @RtnVal = uspLinkAccountableParties @tblAccountableParty, @InstrumentID
	IF @RtnVal <> 0 RAISERROR ('Problem saving uspLinkAccountableParty' , 16, 1) 
	
	--Insert/Update Contact records
	SELECT @RtnVal =0
	Exec @RtnVal = uspLinkContacts @tblContact, @InstrumentID
	IF @RtnVal <> 0 RAISERROR ('Problem saving uspLinkContacts' , 16, 1) 
	
	--Insert/Update Location records
	SELECT @RtnVal =0
	Exec @RtnVal = uspRadiationLinkLocations @tblRadiationLocation, @InstrumentID
	IF @RtnVal <> 0 RAISERROR ('Problem saving uspLinkRadiationLocations' , 16, 1) 
	
	--RadiationLicenceQualification
	--If there is no record in dataset do not proceed
	SELECT @CntRadiationLicenceQualification = 0
	SELECT @CntRadiationLicenceQualification = COUNT(*) FROM @tblRadiationLicenceQualification
	
	IF @CntRadiationLicenceQualification > 0
	BEGIN		
	-- loop through @tblRadiationLicenceQualification records
	-- Add @tblRadiationLicenceQualification list to table tblRadiationLicenceQualification 
	 
	  SET @Cnt = 1
	  WHILE @Cnt <= @CntRadiationLicenceQualification
		BEGIN
			
			SELECT @RadiationLicenceQualificationID = RadiationLicenceQualificationID, @QualificationID = QualificationID, @RowAction = Action FROM @tblRadiationLicenceQualification
			WHERE Sno =  @Cnt
			
			IF @RowAction='I' AND not exists(select * from tblRadiationLicenceQualification where InstrumentID = @InstrumentID and QualificationID=@QualificationID)  --Insert new record
  			   BEGIN
					--- PALMS V5.0
					--we need avoid the duplicated qualificationID under the same instrumentID
					if not exists(select * from tblRadiationLicenceQualification where InstrumentID = @InstrumentID and QualificationID=@QualificationID)
					begin
						INSERT INTO tblRadiationLicenceQualification(       
												   InstrumentID
												  ,QualificationID
												  ,DateCreated
												  ,CreatedBySystemUserID											  
												)
						SELECT 	@InstrumentID,
								QualificationID,
								GetDate(),						  
								CreatedBySystemUserID						    
						FROM @tblRadiationLicenceQualification WHERE Sno =  @Cnt    
					end		
				END 
			ELSE IF @RowAction='I' AND exists(select * from tblRadiationLicenceQualification where InstrumentID = @InstrumentID and QualificationID=@QualificationID)  --update record
				BEGIN
					UPDATE tblRadiationLicenceQualification
					SET 
					    --QualificationID = A.QualificationID,						 
				 	    DateUpdated = GetDate(),
					    UpdatedBySystemUserID = A.UpdatedBySystemUserID					  
					FROM @tblRadiationLicenceQualification A				 
					Where A.RadiationLicenceQualificationID = @RadiationLicenceQualificationID AND A.InstrumentID = @InstrumentID
				END
			ELSE IF @RowAction='D' AND @RadiationLicenceQualificationID > 0  --Delete record	
			  BEGIN 
			       DELETE FROM tblRadiationLicenceQualification
			       WHERE RadiationLicenceQualificationID = @RadiationLicenceQualificationID AND InstrumentID = @InstrumentID
			  END  
			  SELECT @Cnt = @Cnt+1
		END 
		-- End of loop
	END -- End of IF @CntRadiationLicenceQualification > 0

	-------------------------------------------------------------
	--Insert into tblRadiationLicenceAccreditationType
	-------------------------------------------------------------
	
	SELECT @CntRadiationLicenceAccreditationType = 0
	SELECT @CntRadiationLicenceAccreditationType = COUNT(*) FROM @tblRadiationLicenceAccreditationType
    IF @CntRadiationLicenceAccreditationType > 0
	BEGIN	
	-- loop through @RadiationLicenceAccreditationType records
	-- Add @RadiationLicenceAccreditationType list to table tblRadiationLicenceAccreditationType
	 
	  SET @Cnt = 1
	  WHILE @Cnt <= @CntRadiationLicenceAccreditationType
		BEGIN
			
			SELECT @RadiationLicenceAccreditationTypeID = RadiationLicenceAccreditationTypeID, @AccreditationTypeID  = AccreditationTypeID, @UpdatedBySystemUserID = UpdatedBySystemUserID,	@RowAction = Action FROM @tblRadiationLicenceAccreditationType
			WHERE Sno =  @Cnt
			
			IF @RowAction='I' AND not exists(select * from tblRadiationLicenceAccreditationType where InstrumentID = @InstrumentID and AccreditationTypeID=@AccreditationTypeID)  --Insert new record
  			   BEGIN
					--- PALMS V5.0
					--we need avoid the duplicated qualificationID under the same instrumentID
					if not exists(select * from tblRadiationLicenceAccreditationType where InstrumentID = @InstrumentID and AccreditationTypeID=@AccreditationTypeID)
					begin
						INSERT INTO tblRadiationLicenceAccreditationType(       
												   InstrumentID
												  ,AccreditationTypeID
												  ,DateCreated
												  ,CreatedBySystemUserID											  
												)
						SELECT 	@InstrumentID,
								AccreditationTypeID,
								GetDate(),						  
								CreatedBySystemUserID						    
						FROM @tblRadiationLicenceAccreditationType WHERE Sno =  @Cnt    
					end		
				END 
			ELSE IF @RowAction='I' AND exists(select * from tblRadiationLicenceAccreditationType where InstrumentID = @InstrumentID and AccreditationTypeID=@AccreditationTypeID)  --update record
				BEGIN
					UPDATE tblRadiationLicenceAccreditationType
					SET 					     					 
				 	    DateUpdated = GetDate(),
					    UpdatedBySystemUserID = @UpdatedBySystemUserID					  
					FROM tblRadiationLicenceAccreditationType A				 
					Where A.RadiationLicenceAccreditationTypeID = @RadiationLicenceAccreditationTypeID AND A.InstrumentID = @InstrumentID
				END
			ELSE IF @RowAction='D' AND @RadiationLicenceAccreditationTypeID > 0  --Delete record	
			  BEGIN 
			       DELETE FROM tblRadiationLicenceAccreditationType
			       WHERE RadiationLicenceAccreditationTypeID = @RadiationLicenceAccreditationTypeID AND InstrumentID = @InstrumentID
			  END  
			  SELECT @Cnt = @Cnt+1
		END 
		-- End of loop
	END -- END OF IF @CntRadiationLicenceAccreditationType > 0

	
	SELECT @CntRadiationLicenceFitAndProper = 0
	SELECT @CntRadiationLicenceFitAndProper = COUNT(*) FROM @tblRadiationLicenceFitAndProper
    IF @CntRadiationLicenceFitAndProper > 0
	BEGIN	
	-- loop through @tblRadiationLicenceFitAndProper records
	-- Add @RadiationLicenceFitAndProperType list to table tblRadiationLicenceFitAndProper
	 
	  SET @Cnt = 1
	  WHILE @Cnt <= @CntRadiationLicenceFitAndProper
		BEGIN
			
			SELECT @RadiationLicenceFitAndProperID = RadiationLicenceFitAndProperID, 
			@FitAndProperQuestionID  = FitAndProperQuestionID, 
			@FitAndProperAnswerFlag = FitAndProperAnswerFlag,
			@CreatedBySystemUserID = CreatedBySystemUserID,
			@UpdatedBySystemUserID = UpdatedBySystemUserID,			 
			@RowAction = Action 
			FROM @tblRadiationLicenceFitAndProper
			WHERE Sno =  @Cnt
			
			IF @RowAction='I' AND not exists(select * from tblRadiationLicenceFitAndProper where InstrumentID = @InstrumentID and FitAndProperQuestionID=@FitAndProperQuestionID)  --Insert new record
  			   BEGIN
					--- PALMS V5.0
					--we need avoid the duplicated FitAndProperQuestionID under the same instrumentID
					if not exists(select * from tblRadiationLicenceFitAndProper where InstrumentID = @InstrumentID and FitAndProperQuestionID=@FitAndProperQuestionID)
					begin
						INSERT INTO tblRadiationLicenceFitAndProper(       
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
						FROM @tblRadiationLicenceFitAndProper WHERE Sno =  @Cnt    
					end		
				END 
			ELSE IF @RowAction='I' AND exists(select * from tblRadiationLicenceFitAndProper where InstrumentID = @InstrumentID and FitAndProperQuestionID=@FitAndProperQuestionID)  --update record
				BEGIN
					UPDATE tblRadiationLicenceFitAndProper 
					SET 
					    FitAndProperQuestionID = B.FitAndProperQuestionID,
					    FitAndProperAnswerFlag = @FitAndProperAnswerFlag,
						Justification = B.Justification,				     					 
				 	    DateUpdated = GetDate(),
					    UpdatedBySystemUserID = @UpdatedBySystemUserID					  
					FROM tblRadiationLicenceFitAndProper A INNER JOIN @tblRadiationLicenceFitAndProper B ON A.RadiationLicenceFitAndProperID = B.RadiationLicenceFitAndProperID 				 
					Where A.RadiationLicenceFitAndProperID = @RadiationLicenceFitAndProperID AND A.InstrumentID = @InstrumentID
				END
			ELSE IF @RowAction='D' AND @RadiationLicenceFitAndProperID > 0  --Delete record	
			  BEGIN 
			       DELETE FROM tblRadiationLicenceFitAndProper
			       WHERE RadiationLicenceFitAndProperID = @RadiationLicenceFitAndProperID AND InstrumentID = @InstrumentID
			  END  
			  SELECT @Cnt = @Cnt+1
		END 
		-- End of loop
	END -- END OF @CntRadiationLicenceAccreditationType > 0



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

	--Apply to Radiation Accreditation
	IF @TempRadiationLicenceTypeID = 794
	BEGIN
	   print 'Radiation licence Accreditation'
	END

	--Apply to Licence to use only
	IF @TempRadiationLicenceTypeID = 795
	BEGIN


select * from @tblRadiationLicenceCondition

		 declare @TempMutualRecognitionFlag bit
		 declare @TempAHPRARegistrationFlag bit
		 declare @TempRequiredSpecialityFlag bit
		 declare @TempAHPRANoReason varchar(500)
		 declare @TempSpecialtyNoReason varchar(500)

	   --Radiation licence condition
		SELECT @CntRadiationLicenceCondition = 0
		SELECT @CntRadiationLicenceCondition = COUNT(*) FROM @tblRadiationLicenceCondition
		IF @CntRadiationLicenceCondition > 0
		BEGIN
			  SET @Cnt = 1
			  WHILE @Cnt <= @CntRadiationLicenceCondition
				BEGIN
			
					SELECT @RadiationLicenceConditionID = RadiationLicenceConditionID, 
					@RadiationConditionID  = RadiationConditionID, 					 
					@CreatedBySystemUserID = CreatedBySystemUserID,
					@UpdatedBySystemUserID = UpdatedBySystemUserID,			 
					@RowAction = Action,
					@TempMutualRecognitionFlag = MutualRecognitionFlag,
					@TempAHPRARegistrationFlag = AHPRARegistrationFlag,
					@TempRequiredSpecialityFlag = RequiredSpecialityFlag,
					@TempAHPRANoReason = AHPRANoReason,
					@TempSpecialtyNoReason = SpecialtyNoReason
					FROM @tblRadiationLicenceCondition
					WHERE Sno =  @Cnt
			
					IF @RowAction='I' AND not exists(select * from tblRadiationLicenceCondition where InstrumentID = @InstrumentID and RadiationLicenceConditionID=@RadiationLicenceConditionID)  --Insert new record
  					   BEGIN
							--- PALMS V5.0
							--we need avoid the duplicated FitAndProperQuestionID under the same instrumentID
							if not exists(select * from tblRadiationLicenceCondition where InstrumentID = @InstrumentID and RadiationLicenceConditionID=@RadiationLicenceConditionID)
							begin
							    declare @NewRadiationLicenceConditionID int
								set @NewRadiationLicenceConditionID = 0

								INSERT INTO tblRadiationLicenceCondition(       
														   InstrumentID
														  ,RadiationConditionID														 
														  ,DateCreated
														  ,CreatedBySystemUserID
														  ,MutualRecognitionFlag
														  ,AHPRARegistrationFlag
														  ,RequiredSpecialityFlag											  
														)
								SELECT 	@InstrumentID,
										@RadiationConditionID,										 
										GetDate(),						  
										CreatedBySystemUserID,
										(case @TempRadiationLicenceTypeID  when 795 then @TempMutualRecognitionFlag else null end) as MutualRecognitionFlag,
										(case @TempRadiationLicenceTypeID  when 795 then @TempAHPRARegistrationFlag else null end) as AHPRARegistrationFlag,
										(case @TempRadiationLicenceTypeID  when 795 then @TempRequiredSpecialityFlag else null end) as RequiredSpecialityFlag		 
								FROM @tblRadiationLicenceCondition WHERE Sno =  @Cnt    

								select @NewRadiationLicenceConditionID = @@identity

print '@NewRadiationLicenceConditionID = ' + cast(@NewRadiationLicenceConditionID as varchar)
print '@@TempMutualRecognitionFlag = ' + cast(@TempMutualRecognitionFlag as varchar)
print '@@TempAHPRARegistrationFlag = ' + cast(@TempAHPRARegistrationFlag as varchar)

								--Here we insert reason texts into table: tblRACReferral
								if @NewRadiationLicenceConditionID > 0 and @TempMutualRecognitionFlag = 0 and @TempAHPRARegistrationFlag = 0  ---AHPRA registration? NO
								begin
											--1310	129	RACREF1	No AHPRA registration	 
											--1311	129	RACREF2	AHPRA registration not in speciality	
											--1312	129	RACREF3	Provisional AHPRA registration not in speciality 
											if not exists(select * from tblRACReferral where InstrumentID = @InstrumentID 
														   and RadiationConditionID = @RadiationConditionID 
														   and ReferralTypeID = 1310)
											begin
											    print 'insert action start'
												insert into tblRACReferral(InstrumentID,
																		   RadiationConditionID,
																		   ReferralTypeID,
																		   ReasonForReferral,
																		   DateCreated,
																		   CreatedBySystemUserID										
																		  )
												values (
														   @InstrumentID,
														   @RadiationConditionID,
														   1310,
														   @TempAHPRANoReason,
														   getdate(),
														   @CreatedBySystemUserID
												)

												print 'insert action end'
											end
								end

								if @TempMutualRecognitionFlag = 0 and @TempAHPRARegistrationFlag = 1 ---AHPRA registration? YES
								begin
								    if @TempRequiredSpecialityFlag = 0  ---Is AHPRA registration in the required specialty: NO
									begin
											if not exists(select * from tblRACReferral where InstrumentID = @InstrumentID 
														   and RadiationConditionID = @NewRadiationLicenceConditionID 
														   and ReferralTypeID = 1311)
											begin
												insert into tblRACReferral(InstrumentID,
																		   RadiationConditionID,
																		   ReferralTypeID,
																		   ReasonForReferral,
																		   DateCreated,
																		   CreatedBySystemUserID										
																		  )
												values (
														   @InstrumentID,
														   @NewRadiationLicenceConditionID,
														   1311,
														   @TempAHPRANoReason,
														   getdate(),
														   @CreatedBySystemUserID
												)
											end									      
									end
								end
							end		
						END 
					ELSE IF @RowAction='U' AND exists(select * from tblRadiationLicenceCondition where InstrumentID = @InstrumentID and RadiationLicenceConditionID=@RadiationLicenceConditionID)  --update record
						BEGIN
							UPDATE tblRadiationLicenceCondition
							SET 
								RadiationConditionID = @RadiationConditionID,					     					 
				 				DateUpdated = GetDate(),
								UpdatedBySystemUserID = @UpdatedBySystemUserID					  
							FROM tblRadiationLicenceCondition A				 
							Where A.RadiationLicenceConditionID = @RadiationLicenceConditionID AND A.InstrumentID = @InstrumentID
						END
					ELSE IF @RowAction='D' AND @RadiationLicenceConditionID > 0  --Delete record	
					  BEGIN 
						   DELETE FROM tblRadiationLicenceCondition
						   WHERE RadiationLicenceConditionID = @RadiationLicenceConditionID AND InstrumentID = @InstrumentID
					  END  
					  SELECT @Cnt = @Cnt+1
				END 
				-- End of loop
		END 

	   --RadiationLicenceRadioactiveApparatus
		SELECT @CntRadiationLicenceRadioactiveApparatus  = 0
		SELECT @CntRadiationLicenceRadioactiveApparatus  = COUNT(*) FROM @tblRadiationLicenceRadioactiveApparatus
		IF @CntRadiationLicenceRadioactiveApparatus > 0
		BEGIN
			  SET @Cnt = 1
			  WHILE @Cnt <= @CntRadiationLicenceRadioactiveApparatus
				BEGIN
			
					SELECT @RadiationLicenceRadioactiveApparatusID = RadiationLicenceRadioactiveApparatusID, 
					@RadiationApparatuID  = RadiationApparatuID, 					 
					@CreatedBySystemUserID = CreatedBySystemUserID,
					@UpdatedBySystemUserID = UpdatedBySystemUserID,			 
					@RowAction = Action 
					FROM @tblRadiationLicenceRadioactiveApparatus
					WHERE Sno =  @Cnt
			
					IF @RowAction='I' AND not exists(select * from tblRadiationLicenceRadioactiveApparatus where InstrumentID = @InstrumentID and RadiationLicenceRadioactiveApparatusID=@RadiationLicenceRadioactiveApparatusID)  --Insert new record
  					   BEGIN
							--- PALMS V5.0
							--we need avoid the duplicated RRMID under the same instrumentID
							if not exists(select * from tblRadiationLicenceRadioactiveApparatus where InstrumentID = @InstrumentID and RadiationLicenceRadioactiveApparatusID=@RadiationLicenceRadioactiveApparatusID)
							begin
								INSERT INTO tblRadiationLicenceRadioactiveApparatus(       
														   InstrumentID
														  ,RadiationApparatuID
														  ,[MaximummA]
														  ,[MaximumkVp]
														  ,[PurposeOfUse]														  														 
														  ,DateCreated
														  ,CreatedBySystemUserID
														  ,RadiationConditionID											  
														)
								SELECT 	@InstrumentID,
										@RadiationApparatuID,	
										(case MaximummA when -1 then null else MaximummA end) as [MaximummA],
										(case MaximumkVp when -1 then null else MaximumkVp end) as [MaximumkVp],
										PurposeOfUse,																				 
										GetDate(),						  
										CreatedBySystemUserID,
										case RadiationConditionID when 0 then null else RadiationConditionID end 						    
								FROM @tblRadiationLicenceRadioactiveApparatus WHERE Sno =  @Cnt    
							end		
						END 
					ELSE IF @RowAction='U' AND exists(select * from tblRadiationLicenceRadioactiveApparatus where InstrumentID = @InstrumentID and RadiationLicenceRadioactiveApparatusID=@RadiationLicenceRadioactiveApparatusID)  --update record
						BEGIN
							UPDATE tblRadiationLicenceRadioactiveApparatus
							SET 
								RadiationApparatuID = @RadiationApparatuID,	
								MaximummA = (case B.MaximummA when -1 then null else B.MaximummA end),
								MaximumkVp = (case B.MaximumkVp when -1 then null else B.MaximumkVp end), 
								PurposeOfUse = B.PurposeOfUse,				     					 
				 				DateUpdated = GetDate(),
								UpdatedBySystemUserID = @UpdatedBySystemUserID,
								RadiationConditionID = case @RadiationConditionID when 0 then null else @RadiationConditionID end					  
							FROM tblRadiationLicenceRadioactiveApparatus A INNER JOIN @tblRadiationLicenceRadioactiveApparatus B ON A.RadiationLicenceRadioactiveApparatusID = B.RadiationLicenceRadioactiveApparatusID				 
							Where A.RadiationLicenceRadioactiveApparatusID = @RadiationLicenceRadioactiveApparatusID AND A.InstrumentID = @InstrumentID
						END
					ELSE IF @RowAction='D' AND @RadiationLicenceRadioactiveApparatusID > 0  --Delete record	
					  BEGIN 
						   DELETE FROM tblRadiationLicenceRadioactiveApparatus
						   WHERE RadiationLicenceRadioactiveApparatusID = @RadiationLicenceRadioactiveApparatusID AND InstrumentID = @InstrumentID
					  END  
					  SELECT @Cnt = @Cnt+1
				END 
				-- End of loop
		END 

	   --RadiationLicenceRadioactiveSubstances
		SELECT @CntRadiationLicenceRadioactiveSubstances  = 0
		SELECT @CntRadiationLicenceRadioactiveSubstances  = COUNT(*) FROM @tblRadiationLicenceRadioactiveSubstances
		IF @CntRadiationLicenceRadioactiveSubstances > 0
		BEGIN
			  SET @Cnt = 1
			  WHILE @Cnt <= @CntRadiationLicenceRadioactiveSubstances
				BEGIN
			
					SELECT @RadiationLicenceRadioactiveSubstancesID = RadiationLicenceRadioactiveSubstancesID, 
					@RadioactiveSubstanceTypeID  = RadioactiveSubstanceTypeID, 					 
					@CreatedBySystemUserID = CreatedBySystemUserID,
					@UpdatedBySystemUserID = UpdatedBySystemUserID,			 
					@RowAction = Action 
					FROM @tblRadiationLicenceRadioactiveSubstances
					WHERE Sno =  @Cnt
			
					IF @RowAction='I' AND not exists(select * from tblRadiationLicenceRadioactiveSubstances where InstrumentID = @InstrumentID and RadiationLicenceRadioactiveSubstancesID=@RadiationLicenceRadioactiveSubstancesID)  --Insert new record
  					   BEGIN
							--- PALMS V5.0
							--we need avoid the duplicated RRMID under the same instrumentID
							if not exists(select * from tblRadiationLicenceRadioactiveSubstances where InstrumentID = @InstrumentID and RadiationLicenceRadioactiveSubstancesID=@RadiationLicenceRadioactiveSubstancesID)
							begin
								INSERT INTO tblRadiationLicenceRadioactiveSubstances(       
														   InstrumentID
														  ,RadioactiveSubstanceTypeID
														  ,MaxActivity
														  ,MaxActivityUOMID
														  ,RadionuclideID
														  ,PurposeOfUse														  														 
														  ,DateCreated
														  ,CreatedBySystemUserID
														  ,RadiationConditionID											  
														)
								SELECT 	@InstrumentID,
										@RadioactiveSubstanceTypeID,	
										MaxActivity,
										MaxActivityUOMID,
										RadionuclideID,
										PurposeOfUse,																				 
										GetDate(),						  
										CreatedBySystemUserID,
										case RadiationConditionID when 0 then null else RadiationConditionID end						    
								FROM @tblRadiationLicenceRadioactiveSubstances WHERE Sno =  @Cnt    
							end		
						END 
					ELSE IF @RowAction='U' AND exists(select * from tblRadiationLicenceRadioactiveSubstances where InstrumentID = @InstrumentID and RadiationLicenceRadioactiveSubstancesID=@RadiationLicenceRadioactiveSubstancesID)  --update record
						BEGIN
							UPDATE tblRadiationLicenceRadioactiveSubstances
							SET 
								RadioactiveSubstanceTypeID = @RadioactiveSubstanceTypeID,	
								MaxActivity = B.MaxActivity,
								MaxActivityUOMID = B.MaxActivityUOMID, 
								RadionuclideID = B.RadionuclideID,
								PurposeOfUse = B.PurposeOfUse,				     					 
				 				DateUpdated = GetDate(),
								UpdatedBySystemUserID = @UpdatedBySystemUserID,
								RadiationConditionID = case @RadiationConditionID when 0 then null else @RadiationConditionID end					  
							FROM tblRadiationLicenceRadioactiveSubstances A INNER JOIN @tblRadiationLicenceRadioactiveSubstances B ON A.RadiationLicenceRadioactiveSubstancesID = B.RadiationLicenceRadioactiveSubstancesID				 
							Where A.RadiationLicenceRadioactiveSubstancesID = @RadiationLicenceRadioactiveSubstancesID AND A.InstrumentID = @InstrumentID
						END
					ELSE IF @RowAction='D' AND @RadiationLicenceRadioactiveSubstancesID > 0  --Delete record	
					  BEGIN 
						   DELETE FROM tblRadiationLicenceRadioactiveSubstances
						   WHERE RadiationLicenceRadioactiveSubstancesID = @RadiationLicenceRadioactiveSubstancesID AND InstrumentID = @InstrumentID
					  END  
					  SELECT @Cnt = @Cnt+1
				END 
				-- End of loop
		END 

	END --end of IF @TempRadiationLicenceTypeID = 795 licence to use

	--Apply to Radiation Management Licence
	IF @TempRadiationLicenceTypeID = 796
	BEGIN
	   print 'Radiation Management Licence'
	   --if location is no longer necessary we just delete it from tblInstrumentRadiationLocation table here Eric He 06-03-2014
	   declare @ManagementLicenceActivityandDurationID as INT
	   select @ManagementLicenceActivityandDurationID = isnull(ManagementLicenceActivityandDurationID, 0)  from tblRadiationLicence where InstrumentID = @InstrumentID
	   if @ManagementLicenceActivityandDurationID <> 765 and @ManagementLicenceActivityandDurationID > 0
	   begin
	    --no location data needed anymore we delete it from tblInstrumentRadiationLocation
		 delete from tblInstrumentRadiationLocation where InstrumentID = @InstrumentID
	   end
	END

	--Add/Update scheduled activities based on the feebased activities
	--Exec @RtnVal = uspSaveScheduledActivities @InstrumentID,@CreatedBySystemUserID
	--IF @RtnVal < 0 RAISERROR ('Problem saving uspSaveScheduledActivities' , 16, 1) 
	--	
	--Save/Update Assessable pollutants
	--Exec @RtnVal = uspSavePOEOAssesablePollutants @theAssessablePollutants,@InstrumentID,0,0,0,1
	--IF @RtnVal < 0 RAISERROR ('Problem saving uspSavePOEOAssesablePollutants' , 16, 1) 
	
	--Clock event:Check for Application completed date, If Exists Start the clock.
	DECLARE @AppCompleteDate DateTime
	SELECT @AppCompleteDate =  dateadd(day, 1, DateApplicationCompleted) From @tblRadiationLicence
	
	--SB:Create clock if Instrument status is Draft
	IF (EXISTS(SELECT * FROM tblInstrument WHERE InstrumentID = @InstrumentID AND InstrumentStatusID = 751) AND @AppCompleteDate IS NOT NULL)
   	BEGIN
   			SELECT @RtnVal = 0
			EXEC @RtnVal = uspInstrument_Clock_Create @InstrumentID, 14, 0, @CreatedBySystemUserID, @AppCompleteDate --/SB:Event ID 14 is to start clock in tblEvent for Radiation License Clock
	END
		
	  --SB:31/05/2011:Following code is also implemented in uspUpdatePOEOStatus because requirement is changed to create SAP customer when creating Radiation Licence not when issued
	  --and Invoice is generated when Issuing the licence

	----------------- comment by mwu ------------------
	--IF @INSERT=1
	--	EXEC uspFinanceLicneceFee @InstrumentID, @CreatedBySystemUserID
	--ELSE
	--    BEGIN
	--	 --in case the user changed accountable part or contact information we need update the tblSAPCustomer and tblInstrumentSAPCustomer tables
	--	 --we get the old Accountable party ID and Contact IDs then we compare them 
	--	 declare @OldAccountablePartyID int

	--	END
	
	----------------- comment by mwu ------------------
	
	----------------- PALMS V4.0
	--IF EXISTS (SELECT COUNT(*) FROM @tblRadiationLicenceLicenceEnvironmentalRiskLevelType)
	--BEGIN
	--	UPDATE tblPOEOLicenceEnvironmentalRiskLevel
	--	SET EnvironmentalRiskLevelID = B.EnvironmentalRiskLevelID,
	--		ChangedReasonID = B.ChangedReasonID,
	--		Remarks =B.Remarks,
	--		UpdatedBySystemUserID = B.UpdatedBySystemUserID,
	--		DateUpdated = GETDATE()
	--	FROM tblPOEOLicenceEnvironmentalRiskLevel A, @tblRadiationLicenceLicenceEnvironmentalRiskLevelType B
	--	WHERE A.POEOLicenceEnvironmentalRiskLevelID = B.POEOLicenceEnvironmentalRiskLevelID
	--END
	
			
	--COMMIT TRAN A
	--If creating new site return site id else return 0(i.e update sucess)
	IF @INSERT=0 --for updating
		SELECT 0
    ELSE
	    SELECT @InstrumentID --for inserting
	    
	END TRY
	BEGIN CATCH
		DECLARE @ErrorMessage VARCHAR(2000)
		
		--ROLLBACK TRAN A
	
		SET @ErrorMessage = dbo.ufn_GetErrorText()
		
		RAISERROR (@ErrorMessage , 16, 1)
	
	END CATCH