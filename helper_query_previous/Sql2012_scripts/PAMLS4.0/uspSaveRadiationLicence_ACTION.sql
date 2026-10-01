declare @theXmlData xml
set @theXmlData = '
<NewDataSet>
  <RadiationLicence>
    <InstrumentID>-1</InstrumentID>
    <RadiationLicenceTypeID>794</RadiationLicenceTypeID>
    <DateApplicationReceived>2014-01-01T00:00:00+11:00</DateApplicationReceived>
    <DateApplicationCompleted>2014-01-22T00:00:00+11:00</DateApplicationCompleted>
    <AdminFee>0</AdminFee>
    <LicencetoUseInstrumentID>5000015</LicencetoUseInstrumentID>
    <ConsentForECFlag>true</ConsentForECFlag>
    <RefToRACFlag>true</RefToRACFlag>
    <DateCreated>2014-01-22T16:40:16.2264735+11:00</DateCreated>
    <CreatedBySystemUserID>1266</CreatedBySystemUserID>
  </RadiationLicence>
  <RadiationLicenceAccreditationType>
    <RadiationLicenceAccreditationTypeID>-1</RadiationLicenceAccreditationTypeID>
    <InstrumentID>-1</InstrumentID>
    <AccreditationTypeID>759</AccreditationTypeID>
    <DateCreated>2014-01-22T16:40:33.5704735+11:00</DateCreated>
    <CreatedBySystemUserID>1266</CreatedBySystemUserID>
    <UpdatedBySystemUserID>1266</UpdatedBySystemUserID>
    <Action>I</Action>
  </RadiationLicenceAccreditationType>
  <RadiationLicenceAccreditationType>
    <RadiationLicenceAccreditationTypeID>2</RadiationLicenceAccreditationTypeID>
    <InstrumentID>-1</InstrumentID>
    <AccreditationTypeID>760</AccreditationTypeID>
    <DateCreated>2014-01-22T16:40:33.9364735+11:00</DateCreated>
    <CreatedBySystemUserID>1266</CreatedBySystemUserID>
    <UpdatedBySystemUserID>1266</UpdatedBySystemUserID>
    <Action>I</Action>
  </RadiationLicenceAccreditationType>
  <RadiationLicenceAccreditationType>
    <RadiationLicenceAccreditationTypeID>3</RadiationLicenceAccreditationTypeID>
    <InstrumentID>-1</InstrumentID>
    <AccreditationTypeID>761</AccreditationTypeID>
    <DateCreated>2014-01-22T16:40:34.3194735+11:00</DateCreated>
    <CreatedBySystemUserID>1266</CreatedBySystemUserID>
    <UpdatedBySystemUserID>1266</UpdatedBySystemUserID>
    <Action>I</Action>
  </RadiationLicenceAccreditationType>
  <RadiationLicenceAccreditationType>
    <RadiationLicenceAccreditationTypeID>4</RadiationLicenceAccreditationTypeID>
    <InstrumentID>-1</InstrumentID>
    <AccreditationTypeID>762</AccreditationTypeID>
    <DateCreated>2014-01-22T16:40:34.6834735+11:00</DateCreated>
    <CreatedBySystemUserID>1266</CreatedBySystemUserID>
    <UpdatedBySystemUserID>1266</UpdatedBySystemUserID>
    <Action>I</Action>
  </RadiationLicenceAccreditationType>
  <RadiationLicenceAccreditationType>
    <RadiationLicenceAccreditationTypeID>5</RadiationLicenceAccreditationTypeID>
    <InstrumentID>-1</InstrumentID>
    <AccreditationTypeID>763</AccreditationTypeID>
    <DateCreated>2014-01-22T16:40:35.0984735+11:00</DateCreated>
    <CreatedBySystemUserID>1266</CreatedBySystemUserID>
    <UpdatedBySystemUserID>1266</UpdatedBySystemUserID>
    <Action>I</Action>
  </RadiationLicenceAccreditationType>
  <RadiationLicenceFitAndProper>
    <RadiationLicenceFitAndProperID>-1</RadiationLicenceFitAndProperID>
    <InstrumentID>-1</InstrumentID>
    <FitAndProperQuestionID>1</FitAndProperQuestionID>
    <FitAndProperAnswerFlag>true</FitAndProperAnswerFlag>
    <DateCreated>2014-01-22T16:40:55.0714735+11:00</DateCreated>
    <CreatedBySystemUserID>1266</CreatedBySystemUserID>
    <UpdatedBySystemUserID>1266</UpdatedBySystemUserID>
    <Action>I</Action>
  </RadiationLicenceFitAndProper>
  <RadiationLicenceFitAndProper>
    <RadiationLicenceFitAndProperID>2</RadiationLicenceFitAndProperID>
    <InstrumentID>-1</InstrumentID>
    <FitAndProperQuestionID>2</FitAndProperQuestionID>
    <FitAndProperAnswerFlag>true</FitAndProperAnswerFlag>
    <DateCreated>2014-01-22T16:40:55.0714735+11:00</DateCreated>
    <CreatedBySystemUserID>1266</CreatedBySystemUserID>
    <UpdatedBySystemUserID>1266</UpdatedBySystemUserID>
    <Action>I</Action>
  </RadiationLicenceFitAndProper>
  <RadiationLicenceFitAndProper>
    <RadiationLicenceFitAndProperID>3</RadiationLicenceFitAndProperID>
    <InstrumentID>-1</InstrumentID>
    <FitAndProperQuestionID>3</FitAndProperQuestionID>
    <FitAndProperAnswerFlag>true</FitAndProperAnswerFlag>
    <DateCreated>2014-01-22T16:40:55.0714735+11:00</DateCreated>
    <CreatedBySystemUserID>1266</CreatedBySystemUserID>
    <UpdatedBySystemUserID>1266</UpdatedBySystemUserID>
    <Action>I</Action>
  </RadiationLicenceFitAndProper>
  <RadiationLicenceFitAndProper>
    <RadiationLicenceFitAndProperID>4</RadiationLicenceFitAndProperID>
    <InstrumentID>-1</InstrumentID>
    <FitAndProperQuestionID>4</FitAndProperQuestionID>
    <FitAndProperAnswerFlag>true</FitAndProperAnswerFlag>
    <DateCreated>2014-01-22T16:40:55.0714735+11:00</DateCreated>
    <CreatedBySystemUserID>1266</CreatedBySystemUserID>
    <UpdatedBySystemUserID>1266</UpdatedBySystemUserID>
    <Action>I</Action>
  </RadiationLicenceFitAndProper>
  <RadiationLicenceFitAndProper>
    <RadiationLicenceFitAndProperID>5</RadiationLicenceFitAndProperID>
    <InstrumentID>-1</InstrumentID>
    <FitAndProperQuestionID>5</FitAndProperQuestionID>
    <FitAndProperAnswerFlag>true</FitAndProperAnswerFlag>
    <DateCreated>2014-01-22T16:40:55.0714735+11:00</DateCreated>
    <CreatedBySystemUserID>1266</CreatedBySystemUserID>
    <UpdatedBySystemUserID>1266</UpdatedBySystemUserID>
    <Action>I</Action>
  </RadiationLicenceFitAndProper>
  <RadiationLicenceFitAndProper>
    <RadiationLicenceFitAndProperID>6</RadiationLicenceFitAndProperID>
    <InstrumentID>-1</InstrumentID>
    <FitAndProperQuestionID>6</FitAndProperQuestionID>
    <FitAndProperAnswerFlag>true</FitAndProperAnswerFlag>
    <DateCreated>2014-01-22T16:40:55.0714735+11:00</DateCreated>
    <CreatedBySystemUserID>1266</CreatedBySystemUserID>
    <UpdatedBySystemUserID>1266</UpdatedBySystemUserID>
    <Action>I</Action>
  </RadiationLicenceFitAndProper>
  <RadiationLicenceFitAndProper>
    <RadiationLicenceFitAndProperID>7</RadiationLicenceFitAndProperID>
    <InstrumentID>-1</InstrumentID>
    <FitAndProperQuestionID>7</FitAndProperQuestionID>
    <FitAndProperAnswerFlag>true</FitAndProperAnswerFlag>
    <DateCreated>2014-01-22T16:40:55.0714735+11:00</DateCreated>
    <CreatedBySystemUserID>1266</CreatedBySystemUserID>
    <UpdatedBySystemUserID>1266</UpdatedBySystemUserID>
    <Action>I</Action>
  </RadiationLicenceFitAndProper>
  <RadiationLicenceFitAndProper>
    <RadiationLicenceFitAndProperID>8</RadiationLicenceFitAndProperID>
    <InstrumentID>-1</InstrumentID>
    <FitAndProperQuestionID>8</FitAndProperQuestionID>
    <FitAndProperAnswerFlag>false</FitAndProperAnswerFlag>
    <DateCreated>2014-01-22T16:40:55.0714735+11:00</DateCreated>
    <CreatedBySystemUserID>1266</CreatedBySystemUserID>
    <UpdatedBySystemUserID>1266</UpdatedBySystemUserID>
    <Action>I</Action>
  </RadiationLicenceFitAndProper>
  <RadiationLicenceQualification>
    <RadiationLicenceQualificationID>-1</RadiationLicenceQualificationID>
    <InstrumentID>-1</InstrumentID>
    <QualificationID>211</QualificationID>
    <DateCreated>2014-01-22T16:40:40.4324735+11:00</DateCreated>
    <CreatedBySystemUserID>1266</CreatedBySystemUserID>
    <Action>I</Action>
    <Name>Australian College of Physical Scientists and Engineers in Medicine (ACPSEM) accreditation program mammography physics and quality control</Name>
    <Provider>University of Sydney</Provider>
  </RadiationLicenceQualification>
  <Instrument>
    <InstrumentID>-1</InstrumentID>
    <InstrumentTypeID>750</InstrumentTypeID>
    <InstrumentStatusID>751</InstrumentStatusID>
    <ResponsibleSystemUserID>1266</ResponsibleSystemUserID>
    <ResponsibleUser>He Eric (DEC\HEE)</ResponsibleUser>
    <LoginName>DEC\HEE</LoginName>
    <CreatedBySystemUserID>1266</CreatedBySystemUserID>
    <HasRecordService>false</HasRecordService>
    <HasActiveVariation>false</HasActiveVariation>
    <HasActiveSystemNotice>false</HasActiveSystemNotice>
    <SectionName>Metropolitan - Sydney Industry</SectionName>
    <HasActiveCorrection>false</HasActiveCorrection>
  </Instrument>
  <AccountableParty>
    <InstrumentAccountablePartyID>-1</InstrumentAccountablePartyID>
    <InstrumentID>-1</InstrumentID>
    <AccountablePartyID>2858</AccountablePartyID>
    <AccountablePartyName>BHP BILLITON INNOVATION PTY. LTD.</AccountablePartyName>
    <AddressABN>41 008 457 154</AddressABN>
    <LandownerFlag>false</LandownerFlag>
    <EffectiveDateFrom>2014-01-21T10:36:00+11:00</EffectiveDateFrom>
    <DateCreated>2014-01-22T16:40:29.5484735+11:00</DateCreated>
    <CreatedBySystemUserID>1266</CreatedBySystemUserID>
    <Action>I</Action>
  </AccountableParty>
  <Contact>
    <InstrumentContactID>-1</InstrumentContactID>
    <InstrumentID>-1</InstrumentID>
    <ContactID>7024</ContactID>
    <ContactName>James Hammond</ContactName>
    <Address>PO BOX 6550, WETHERILL PARK, NSW, 1851</Address>
    <EMail>james.hammond@australbricks.com.au</EMail>
    <PostalContactFlag>false</PostalContactFlag>
    <EmailContactFlag>true</EmailContactFlag>
    <DateCreated>2014-01-22T16:40:29.5484735+11:00</DateCreated>
    <CreatedBySystemUserID>1266</CreatedBySystemUserID>
    <UpdatedBySystemUserID>1266</UpdatedBySystemUserID>
    <Action>I</Action>
  </Contact>
  <Contact>
    <InstrumentContactID>2</InstrumentContactID>
    <InstrumentID>-1</InstrumentID>
    <ContactID>8376</ContactID>
    <ContactName xml:space="preserve"> </ContactName>
    <Address>15 GOW STREET, PADSTOW, NSW, 2211</Address>
    <EMail>james.white@orica.com</EMail>
    <PostalContactFlag>true</PostalContactFlag>
    <EmailContactFlag>false</EmailContactFlag>
    <DateCreated>2014-01-22T16:40:29.5484735+11:00</DateCreated>
    <CreatedBySystemUserID>1266</CreatedBySystemUserID>
    <UpdatedBySystemUserID>1266</UpdatedBySystemUserID>
    <Action>U</Action>
  </Contact>
</NewDataSet>
'




	DECLARE @TempRadiationLicenceTypeID INT

	DECLARE @tblRadiationLicence tblRadiationLicenceType
	DECLARE @tblInstrument tblInstrumentType
	DECLARE @tblAccountableParty tblInstrumentAccountablePartyType
	DECLARE @tblContact tblInstrumentContactType
	DECLARE @tblLocation tblInstrumentLocationType
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
	DECLARE @VariationReason varchar(500)

	DECLARE @CntRadiationLicenceCondition INT
	DECLARE @tblRadiationLicenceCondition tblRadiationLicenceConditionType
	DECLARE @RadiationLicenceConditionID INT	
	DECLARE @RadiationConditionID INT

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

	print '@TempRadiationLicenceTypeID=' + cast(@TempRadiationLicenceTypeID as varchar)


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
			 RN.S.value('Notes[1]','varchar(4000)') AS Notes,
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
	
	INSERT INTO @tblLocation(InstrumentLocationID,
							 InstrumentID,
							 LocationID,
							 CreatedBySystemUserID,
							 UpdatedBySystemUserID,
							 RowTimestamp,
							 Action)
	SELECT RN.S.value('InstrumentLocationID[1]','int') AS InstrumentLocationID,
			 RN.S.value('InstrumentID[1]','int') AS InstrumentID,
			 RN.S.value('LocationID[1]','int') AS LocationID,
			 RN.S.value('CreatedBySystemUserID[1]','int') AS CreatedBySystemUserID,
			 RN.S.value('UpdatedBySystemUserID[1]','int') AS UpdatedBySystemUserID,
			 RN.S.value('RowTimestamp[1]','varchar(4000)') AS RowTimestamp,
			 RN.S.value('Action[1]','char(1)') AS Action
	FROM @theXmlData.nodes('/NewDataSet/Location') AS RN(S)
	
 
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
	)
	SELECT RN.S.value('RadiationLicenceConditionID[1]','int') AS RadiationLicenceConditionID,
		   RN.S.value('InstrumentID[1]','int') AS InstrumentID,
		   RN.S.value('RadiationConditionID[1]','int') AS RadiationConditionID,		 
		   RN.S.value('DateCreated[1]','datetime') AS DateCreated,
		   RN.S.value('CreatedBySystemUserID[1]','int') AS CreatedBySystemUserID,
		   RN.S.value('DateUpdated[1]','datetime') AS DateUpdated,
		   RN.S.value('UpdatedBySystemUserID[1]','int') AS UpdatedBySystemUserID,
		   RN.S.value('Action[1]','char(1)') AS Action    
	FROM @theXmlData.nodes('/NewDataSet/RadiationLicenceCondition') AS RN(S)
	--------------------------------------- 		
		
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

	
	BEGIN TRAN A
	--Insert or Update Address
	Exec @InstrumentID = uspSaveInstrument @tblInstrument
	
	IF @InstrumentID < 0 RAISERROR ('Problem saving uspSaveInstrument' , 16, 1)
    
	--Insert/Update Location record	
    IF @INSERT=1
	  BEGIN
			--- PALMS V3.0 ----------------------
		    INSERT INTO tblRadiationLicence(
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
						[UpdatedBySystemUserID]
						)
			Select		  @InstrumentID,
			              RadiationLicenceTypeID,
						  DateApplicationReceived,
						  DateApplicationCompleted,
						  ManagementLicenceActivityandDurationID,
						  LicencetoUseDurationID,
						  AdminFee,
						  ExpiryDate,
						  ReviewDueDate,						 
						  LicencetoUseInstrumentID,
						  ConsentForECFlag,
						  RefToRACFlag,
						  Notes,
						  DateCreated,
						  CreatedBySystemUserID,
						  DateUpdated,
						  UpdatedBySystemUserID
			From @tblRadiationLicence
			
			--Add an entry in to Audit log table
			SELECT @RtnVal = 0
			EXEC @RtnVal = uspAuditLogInsert @InstrumentID,'Radiation Licence created and Assigned Draft status','Radiation Licence created and Assigned Draft status',@CreatedBySystemUserID,@CreatedBySystemUserID,1
			
	  END
	ELSE
	  BEGIN  
	        SELECT @TempRowTimeStamp = RowTimeStamp FROM @tblRadiationLicence WHERE InstrumentID = @InstrumentID			
			SELECT @RowTimeStamp = dbo.ufn_varbintohexstr(RowTimeStamp) FROM @tblRadiationLicence WHERE InstrumentID = @InstrumentID			
			SELECT @CreatedBySystemUserID = @UpdatedBySystemUserID
			UPDATE tblRadiationLicence SET ConsentForECFlag = B.ConsentForECFlag, RefToRACFlag = B.RefToRACFlag, UpdatedBySystemUserID = B.UpdatedBySystemUserID, DateUpdated = Getdate()
			FROM tblRadiationLicence AS A JOIN @tblRadiationLicence B ON A.InstrumentID = B.InstrumentID        			 
	  END

	----TEST LINES------
	select * from @tblAccountableParty
	----END TEST LINES ----------


	--Insert/Update Accountable Party records
	SELECT @RtnVal =0
	Exec @RtnVal = uspLinkAccountableParties @tblAccountableParty, @InstrumentID
	IF @RtnVal <> 0 RAISERROR ('Problem saving uspLinkAccountableParty' , 16, 1) 
	
	----TEST LINES------
	select * from @tblContact
	----END TEST LINES ----------

	--Insert/Update Contact records
	SELECT @RtnVal =0
	Exec @RtnVal = uspLinkContacts @tblContact, @InstrumentID
	IF @RtnVal <> 0 RAISERROR ('Problem saving uspLinkContacts' , 16, 1) 
	
	--Insert/Update Location records
	SELECT @RtnVal =0
	Exec @RtnVal = uspLinkLocations @tblLocation,@InstrumentID
	IF @RtnVal <> 0 RAISERROR ('Problem saving uspLinkLocations' , 16, 1) 
	
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
			ELSE IF @RowAction='U' AND exists(select * from tblRadiationLicenceFitAndProper where InstrumentID = @InstrumentID and FitAndProperQuestionID=@FitAndProperQuestionID)  --update record
				BEGIN
					UPDATE tblRadiationLicenceFitAndProper
					SET 
					    FitAndProperAnswerFlag = @FitAndProperAnswerFlag,					     					 
				 	    DateUpdated = GetDate(),
					    UpdatedBySystemUserID = @UpdatedBySystemUserID					  
					FROM tblRadiationLicenceFitAndProper A				 
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
	  WHILE @Cnt <= @CntRadiationLicenceFitAndProper
		BEGIN
			
			SELECT @RadiationLicenceVariationID = RadiationLicenceVariationID,
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
						INSERT INTO tblRadiationLicenceVariation(       
												    InstrumentID,
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
								VariationReason,
								VariationFeeAppliedFlag,
								RefToRACFlag,
								VariationCompletedFlag,
								VariationCompleteDate,
								VariationCompletedBySystemUserID, 
								GetDate(),						  
								CreatedBySystemUserID						    
						FROM @tblRadiationLicenceVariation WHERE Sno =  @Cnt    
					end		
				END 
			ELSE IF @RowAction='U' AND exists(select * from tblRadiationLicenceVariation where InstrumentID = @InstrumentID and RadiationLicenceVariationID=@RadiationLicenceVariationID)  --update record
				BEGIN
					UPDATE tblRadiationLicenceVariation
					SET 
					    VariationReason = @VariationReason,					     					 
				 	    DateUpdated = GetDate(),
					    UpdatedBySystemUserID = @UpdatedBySystemUserID					  
					FROM @tblRadiationLicenceVariation A				 
					Where A.RadiationLicenceVariationID = @RadiationLicenceVariationID AND A.InstrumentID = @InstrumentID
				END
			ELSE IF @RowAction='D' AND @RadiationLicenceFitAndProperID > 0  --Delete record	
			  BEGIN 
			       DELETE FROM tblRadiationLicenceVariation
			       WHERE RadiationLicenceVariationID = @RadiationLicenceVariationID AND InstrumentID = @InstrumentID
			  END  
			  SELECT @Cnt = @Cnt+1
		END 	   
	END

	--Apply to Radiation Accreditation
	IF @TempRadiationLicenceTypeID = 794
	BEGIN
	   print 'Radiation licence Accreditation'
	END

	--Apply to Licence to use only
	IF @TempRadiationLicenceTypeID = 795
	BEGIN
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
					@RowAction = Action 
					FROM @tblRadiationLicenceCondition
					WHERE Sno =  @Cnt
			
					IF @RowAction='I' AND not exists(select * from tblRadiationLicenceCondition where InstrumentID = @InstrumentID and RadiationLicenceConditionID=@RadiationLicenceConditionID)  --Insert new record
  					   BEGIN
							--- PALMS V5.0
							--we need avoid the duplicated FitAndProperQuestionID under the same instrumentID
							if not exists(select * from tblRadiationLicenceCondition where InstrumentID = @InstrumentID and RadiationLicenceConditionID=@RadiationLicenceConditionID)
							begin
								INSERT INTO tblRadiationLicenceCondition(       
														   InstrumentID
														  ,RadiationConditionID														 
														  ,DateCreated
														  ,CreatedBySystemUserID											  
														)
								SELECT 	@InstrumentID,
										@RadiationConditionID,										 
										GetDate(),						  
										CreatedBySystemUserID						    
								FROM @tblRadiationLicenceCondition WHERE Sno =  @Cnt    
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
	END

	--Apply to Radiation Management Licence
	IF @TempRadiationLicenceTypeID = 796
	BEGIN
	   print 'Radiation Management Licence'
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
	SELECT @AppCompleteDate = DateApplicationCompleted From @tblRadiationLicence
	
	--SB:Create clock if Instrument status is Draft
	IF (EXISTS(SELECT * FROM tblInstrument WHERE InstrumentID = @InstrumentID AND InstrumentStatusID = 751) AND @AppCompleteDate IS NOT NULL)
   	   BEGIN
   			SELECT @RtnVal = 0
			EXEC @RtnVal = uspInstrument_Clock_Create @InstrumentID,1, 0,@CreatedBySystemUserID, @AppCompleteDate --/SB:Event ID 1 is to start clock in tblEvent
	   END
		
	  --SB:31/05/2011:Following code is also implemented in uspUpdatePOEOStatus because requirement is changed to create SAP customer when creating Radiation Licence not when issued
	  --and Invoice is generated when Issuing the licence
	IF @INSERT=1
		EXEC uspFinanceLicneceFee @InstrumentID, @CreatedBySystemUserID
	
	
	
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
	
			
	COMMIT TRAN A
	--If creating new site return site id else return 0(i.e update sucess)
	IF @INSERT=0 --for updating
		SELECT 0
    ELSE
	    SELECT @InstrumentID --for inserting
	    
