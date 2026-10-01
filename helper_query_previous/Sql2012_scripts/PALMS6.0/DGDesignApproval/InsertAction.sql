declare @theXmlData xml
set @theXmlData = 
'
<NewDataSet>
  <Instrument>
    <InstrumentID>-1</InstrumentID>
    <InstrumentTypeID>990</InstrumentTypeID>
    <InstrumentStatusID>751</InstrumentStatusID>
    <ResponsibleSystemUserID>1399</ResponsibleSystemUserID>
    <ResponsibleUser>He Eric (DEC\HEE)</ResponsibleUser>
    <LoginName>DEC\HEE</LoginName>
    <CreatedBySystemUserID>1399</CreatedBySystemUserID>
    <HasRecordService>false</HasRecordService>
    <HasActiveVariation>false</HasActiveVariation>
    <HasActiveSystemNotice>false</HasActiveSystemNotice>
    <SectionName>Waste &amp; Resources - Waste Management</SectionName>
    <HasActiveCorrection>false</HasActiveCorrection>
  </Instrument>
  <AccountableParty>
    <InstrumentAccountablePartyID>-1</InstrumentAccountablePartyID>
    <InstrumentID>-1</InstrumentID>
    <AccountablePartyID>12731</AccountablePartyID>
    <AccountablePartyName>James Lee</AccountablePartyName>
    <AddressABN>13 Marcia Street , TOONGABBIE, 2146, NSW</AddressABN>
    <DateCreated>2015-08-12T16:36:21.8726437+10:00</DateCreated>
    <CreatedBySystemUserID>1399</CreatedBySystemUserID>
    <Action>I</Action>
  </AccountableParty>
  <Contact>
    <InstrumentContactID>-1</InstrumentContactID>
    <InstrumentID>-1</InstrumentID>
    <ContactID>34834</ContactID>
    <ContactName>Dr James Lee</ContactName>
    <Address>26 Kardella Avenue , KILLARA, 2071, NSW</Address>
    <EMail>testRadiation@epa.nsw.gova.au</EMail>
    <PostalContactFlag>true</PostalContactFlag>
    <EmailContactFlag>true</EmailContactFlag>
    <DateCreated>2015-08-12T16:37:14.8426437+10:00</DateCreated>
    <CreatedBySystemUserID>1399</CreatedBySystemUserID>
    <UpdatedBySystemUserID>1399</UpdatedBySystemUserID>
    <Action>I</Action>
  </Contact>
  <DGLicence>
    <InstrumentID>-1</InstrumentID>
    <DGLicenceTypeID>990</DGLicenceTypeID>
    <DateApplicationReceived>2015-08-12T00:00:00+10:00</DateApplicationReceived>
    <DateApplicationCompleted>2015-08-12T00:00:00+10:00</DateApplicationCompleted>
    <AdminFee>0</AdminFee>
    <ConsentForECFlag>true</ConsentForECFlag>
    <Notes>nothing</Notes>
    <DateCreated>2015-08-12T16:35:54.1916437+10:00</DateCreated>
    <CreatedBySystemUserID>1399</CreatedBySystemUserID>
  </DGLicence>
  <DGLicenceDriver>
    <InstrumentID>-1</InstrumentID>
    <DateCreated>2015-08-12T16:36:07.1136437+10:00</DateCreated>
    <CreatedBySystemUserID>1399</CreatedBySystemUserID>
    <DateUpdated>2015-08-12T16:38:44.0006437+10:00</DateUpdated>
    <UpdatedBySystemUserID>1399</UpdatedBySystemUserID>
  </DGLicenceDriver>
  <DGDesignApprovalClassUN>
    <DGDesignApprovalClassUNID>-1</DGDesignApprovalClassUNID>
    <InstrumentID>-1</InstrumentID>
    <DGClassID>869</DGClassID>
    <DGClass>2.2</DGClass>
    <DGUNNumberID>0</DGUNNumberID>
    <DGUNNumber />
    <DateCreated>2015-08-12T16:38:23.2456437+10:00</DateCreated>
    <CreatedBySystemUserID>1399</CreatedBySystemUserID>
    <UpdatedBySystemUserID>1399</UpdatedBySystemUserID>
    <Action>I</Action>
  </DGDesignApprovalClassUN>
  <DGDesignApprovalClassUN>
    <DGDesignApprovalClassUNID>-2</DGDesignApprovalClassUNID>
    <InstrumentID>-1</InstrumentID>
    <DGClassID>870</DGClassID>
    <DGClass>2.3</DGClass>
    <DGUNNumberID>0</DGUNNumberID>
    <DGUNNumber />
    <DateCreated>2015-08-12T16:38:25.8606437+10:00</DateCreated>
    <CreatedBySystemUserID>1399</CreatedBySystemUserID>
    <UpdatedBySystemUserID>1399</UpdatedBySystemUserID>
    <Action>I</Action>
  </DGDesignApprovalClassUN>
  <DGDesignApproval>
    <InstrumentID>-1</InstrumentID>
    <NSWDesignApprovalID>10220</NSWDesignApprovalID>
    <DesignApprovalNumber>DGAP9000</DesignApprovalNumber>
    <DesignApprovalTypeID>991</DesignApprovalTypeID>
    <DesignApprovalType>Specific approval – rigid</DesignApprovalType>
    <DateApplicationReceived>2015-08-12T16:38:32.0046437+10:00</DateApplicationReceived>
    <AdminFee>100</AdminFee>
    <DesignApprovalState>NSW</DesignApprovalState>
    <TankerTypeID>865</TankerTypeID>
    <Capacity>456</Capacity>
    <VINNumber>V45646</VINNumber>
    <ExpiryDate>2017-08-12T16:38:32.0046437+10:00</ExpiryDate>
    <CAPDecisionMadeFlag>false</CAPDecisionMadeFlag>
    <DesignApprovalRestrictionID>998</DesignApprovalRestrictionID>
    <ConsentForECFlag>true</ConsentForECFlag>
    <DateCreated>2015-08-12T16:38:32.0056437+10:00</DateCreated>
    <CreatedBySystemUserID>1399</CreatedBySystemUserID>
  </DGDesignApproval>
  <DGDesignApprovalTankMake>
    <DGDesignApprovalTankMakeID>-1</DGDesignApprovalTankMakeID>
    <InstrumentID>-1</InstrumentID>
    <DGTankMakeID>3</DGTankMakeID>
    <DGTankMake>Australian Fueling Systems</DGTankMake>
    <DateCreated>2015-08-12T16:38:29.7426437+10:00</DateCreated>
    <CreatedBySystemUserID>1399</CreatedBySystemUserID>
    <UpdatedBySystemUserID>1399</UpdatedBySystemUserID>
    <Action>I</Action>
  </DGDesignApprovalTankMake>
  <DGDesignApprovalVehicleMake>
    <DGDesignApprovalVehicleMakeID>-1</DGDesignApprovalVehicleMakeID>
    <InstrumentID>-1</InstrumentID>
    <DGVehicleMakeID>3</DGVehicleMakeID>
    <DGVehicleMake>Bedford</DGVehicleMake>
    <DateCreated>2015-08-12T16:38:27.8056437+10:00</DateCreated>
    <CreatedBySystemUserID>1399</CreatedBySystemUserID>
    <UpdatedBySystemUserID>1399</UpdatedBySystemUserID>
    <Action>I</Action>
  </DGDesignApprovalVehicleMake>
</NewDataSet>
'

    DECLARE @TempRadiationLicenceTypeID INT
	DECLARE @tblRadiationLicence tblRadiationLicenceType

	DECLARE @tblDGDesignApproval tblDGDesignApprovalType
	DECLARE @tblDGDesignApprovalClassUN tblDGDesignApprovalClassUNType
	DECLARE @tblDGDesignApprovalVehicleMake tblDGDesignApprovalVehicleMakeType
	DECLARE @tblDGDesignApprovalTankMake tblDGDesignApprovalTankMakeType

	DECLARE @tblInstrument tblInstrumentType
	DECLARE @tblAccountableParty tblInstrumentAccountablePartyType
	DECLARE @tblContact tblInstrumentContactType

	DECLARE	@InstrumentID Int	
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

	--Insert into table variable before we actually take actions on those tables in DB
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

    INSERT INTO @tblDGDesignApproval(
				  [InstrumentID],
				  [NSWDesignApprovalID],
				  [DesignApprovalNumber],
				  [DesignApprovalTypeID],
				  [DateApplicationReceived],
				  [DateApplicationCompleted],
				  [AdminFee],
				  [DesignApprovalState],
				  [TankerTypeID],
				  [Capacity],
				  [VINNumber],
				  [ExpiryDate],
				  [CAPDecisionMadeFlag],
				  [CAPDecisionNumber],
				  [CAPDecisionDate],
				  [DesignApprovalRestrictionID],
				  [ConsentForECFlag],
				  [Notes],
				  [DateCreated],
				  [CreatedBySystemUserID],
				  [DateUpdated],
				  [UpdatedBySystemUserID])
	SELECT RN.S.value('InstrumentID[1]','int') AS InstrumentID,
	         RN.S.value('NSWDesignApprovalID[1]','int') AS NSWDesignApprovalID,
			 RN.S.value('DesignApprovalNumber[1]','varchar(30)')  AS DesignApprovalNumber,
			 RN.S.value('DesignApprovalTypeID[1]','smallint') AS DesignApprovalTypeID,
			 RN.S.value('DateApplicationReceived[1]','smalldatetime') AS DateApplicationReceived,
			 RN.S.value('DateApplicationCompleted[1]','smalldatetime') AS DateApplicationCompleted,	
			 RN.S.value('AdminFee[1]','money') AS AdminFee,		
			 RN.S.value('DesignApprovalState[1]','varchar(3)')  AS DesignApprovalState,
			 RN.S.value('TankerTypeID[1]','smallint') AS TankerTypeID,
	         RN.S.value('Capacity[1]','int') AS Capacity,
			 RN.S.value('VINNumber[1]','varchar(20)')  AS VINNumber,
			 RN.S.value('ExpiryDate[1]','smalldatetime') AS ExpiryDate,
			 RN.S.value('CAPDecisionMadeFlag[1]','bit') AS CAPDecisionMadeFlag,
			 RN.S.value('CAPDecisionNumber[1]','varchar(30)')  AS CAPDecisionNumber,
			 RN.S.value('CAPDecisionDate[1]','smalldatetime') AS CAPDecisionDate,
			 RN.S.value('DesignApprovalRestrictionID[1]','smallint') AS DesignApprovalRestrictionID,			 
			 RN.S.value('ConsentForECFlag[1]','bit') AS ConsentForECFlag,	
			 RN.S.value('Notes[1]','varchar(1000)')  AS Notes,		 
			 GETDATE(),
			 RN.S.value('CreatedBySystemUserID[1]','int') AS CreatedBySystemUserID,
			 null,
			 RN.S.value('UpdatedBySystemUserID[1]','int') AS UpdatedBySystemUserID 
   FROM @theXmlData.nodes('/NewDataSet/DGDesignApproval') AS RN(S)

    INSERT INTO @tblDGDesignApprovalClassUN(
	                   [DGDesignApprovalClassUNID]
					  ,[InstrumentID]
					  ,[DGClassID]
					  ,[DGUNNumberID]
					  ,[DateCreated]
					  ,[CreatedBySystemUserID]
					  ,[DateUpdated]
					  ,[UpdatedBySystemUserID]
					  ,[Action])
	SELECT   RN.S.value('DGDesignApprovalClassUNID[1]','int') AS DGDesignApprovalClassUNID,
	         RN.S.value('InstrumentID[1]','int') AS InstrumentID,
			 RN.S.value('DGClassID[1]','int') AS DGClassID,
			 RN.S.value('DGUNNumberID[1]','int') AS DGUNNumberID,				 
			 GETDATE(),
			 RN.S.value('CreatedBySystemUserID[1]','int') AS CreatedBySystemUserID,
			 null,
			 RN.S.value('UpdatedBySystemUserID[1]','int') AS UpdatedBySystemUserID,
			 RN.S.value('Action[1]','char(1)') AS Action 
    FROM @theXmlData.nodes('/NewDataSet/DGDesignApprovalClassUN') AS RN(S)
  
    INSERT INTO @tblDGDesignApprovalVehicleMake(
	                   [DGDesignApprovalVehicleMakeID]
					  ,[InstrumentID]
					  ,[DGVehicleMakeID]					 
					  ,[DateCreated]
					  ,[CreatedBySystemUserID]
					  ,[DateUpdated]
					  ,[UpdatedBySystemUserID]
					  ,[Action])
	SELECT   RN.S.value('DGDesignApprovalVehicleMakeID[1]','int') AS DGDesignApprovalVehicleMakeID,
	         RN.S.value('InstrumentID[1]','int') AS InstrumentID,
			 RN.S.value('DGVehicleMakeID[1]','int') AS DGVehicleMakeID,			  	
			 GETDATE(),
			 RN.S.value('CreatedBySystemUserID[1]','int') AS CreatedBySystemUserID,
			 null,
			 RN.S.value('UpdatedBySystemUserID[1]','int') AS UpdatedBySystemUserID,
			 RN.S.value('Action[1]','char(1)') AS Action 
    FROM @theXmlData.nodes('/NewDataSet/DGDesignApprovalVehicleMake') AS RN(S)

    INSERT INTO @tblDGDesignApprovalTankMake(
	                   [DGDesignApprovalTankMakeID]
					  ,[InstrumentID]
					  ,[DGTankMakeID]					 
					  ,[DateCreated]
					  ,[CreatedBySystemUserID]
					  ,[DateUpdated]
					  ,[UpdatedBySystemUserID]
					  ,[Action])
	SELECT   RN.S.value('DGDesignApprovalTankMakeID[1]','int') AS DGDesignApprovalTankMakeID,
	         RN.S.value('InstrumentID[1]','int') AS InstrumentID,
			 RN.S.value('DGTankMakeID[1]','int') AS DGVehicleMakeID,			  	
			 GETDATE(),
			 RN.S.value('CreatedBySystemUserID[1]','int') AS CreatedBySystemUserID,
			 null,
			 RN.S.value('UpdatedBySystemUserID[1]','int') AS UpdatedBySystemUserID,
			 RN.S.value('Action[1]','char(1)') AS Action 
    FROM @theXmlData.nodes('/NewDataSet/DGDesignApprovalTankMake') AS RN(S)

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
	 
	-------------------------------------------------------------------------------------------------------------
		
	SELECT @InstrumentID = InstrumentID, @CreatedBySystemUserID = CreatedBySystemUserID,
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
	
	select * from @tblDGDesignApproval
	print '@InstrumentID =' + cast(@InstrumentID as varchar)

	IF @InstrumentID < 0 RAISERROR ('Problem saving uspSaveInstrument' , 16, 1)
    
	--Insert/Update Location record	
    IF @INSERT=1
	  BEGIN
			--- PALMS V5.0 ----------------------
			--Management licence expiry date calculation
			--765: Sell, possess, store or give away regulated material (including radiation apparatus, radioactive substances or items containing radioactive substances) for 1 year
			--766: Sell regulated material (including radiation apparatus, radioactive substances or items containing radioactive substances) for 1 year (sell only)
			--767: Sell regulated material (including radiation apparatus, radioactive substances or items containing radioactive substances) for 3 years (sell only)
			 
		    INSERT INTO tblDGDesignApproval(
						[InstrumentID],
						[NSWDesignApprovalID],
						[DesignApprovalNumber],
						[DesignApprovalTypeID],
						[DateApplicationReceived],
						[DateApplicationCompleted],
						[AdminFee],
						[DesignApprovalState],
						[TankerTypeID],
						[Capacity],
						[VINNumber],						 
						[ExpiryDate],
						[CAPDecisionMadeFlag],	
						[CAPDecisionNumber],
						[CAPDecisionDate],
						[DesignApprovalRestrictionID],					 
						[ConsentForECFlag],
						[Notes], 
						[DateCreated],
						[CreatedBySystemUserID],
						[DateUpdated],
						[UpdatedBySystemUserID]
						)
			Select		  @InstrumentID,
			              [NSWDesignApprovalID],
			              [DesignApprovalNumber],
			              [DesignApprovalTypeID],  --991 to 997
						  dateadd(day, 1, DateApplicationReceived),						  
						  dateadd(day, 1, DateApplicationCompleted),
						  AdminFee, 
						  [DesignApprovalState], --DesignApprovalState
						  [TankerTypeID],   --TankerTypeID
						  [Capacity],   --Capacity
						  [VINNumber], --VINNumber						 
						  isnull(ExpiryDate, getdate()) as ExpiryDate,	
						  [CAPDecisionMadeFlag],
						  [CAPDecisionNumber],
						  getdate(),
						  [DesignApprovalRestrictionID],  --998 to 999 range					  			 
						  ConsentForECFlag,
						  Notes, 
						  DateCreated,
						  CreatedBySystemUserID,
						  DateUpdated,
						  UpdatedBySystemUserID
			From @tblDGDesignApproval
			
			--Add an entry in to Audit log table
			SELECT @RtnVal = 0
			EXEC @RtnVal = uspAuditLogInsert @InstrumentID,'Dangerous goods design approval created','Dangerous goods design approval licence created and Assigned Draft status',@CreatedBySystemUserID,@CreatedBySystemUserID,1	  END
	ELSE
	  BEGIN  
	        --SELECT @TempRowTimeStamp = RowTimeStamp FROM @tblDGLicence WHERE InstrumentID = @InstrumentID			
			--SELECT @RowTimeStamp = dbo.ufn_varbintohexstr(RowTimeStamp) FROM @tblDGLicence WHERE InstrumentID = @InstrumentID			
			SELECT @CreatedBySystemUserID = @UpdatedBySystemUserID
			UPDATE tblDGDesignApproval 
			SET 
			ConsentForECFlag = B.ConsentForECFlag, 
			Notes = B.Notes,
			UpdatedBySystemUserID = B.UpdatedBySystemUserID, 
			DateUpdated = Getdate(),
			AdminFee = B.AdminFee,
			DesignApprovalTypeID = B.DesignApprovalTypeID,
			DateApplicationCompleted = dateadd(day, 1, B.DateApplicationCompleted),
			DateApplicationReceived = dateadd(day, 1, B.DateApplicationReceived)  
			FROM tblDGDesignApproval AS A JOIN @tblDGDesignApproval B ON A.InstrumentID = B.InstrumentID        			 
	  END
	
	
	--Insert/Update Accountable Party records
	SELECT @RtnVal =0
	Exec @RtnVal = uspLinkAccountableParties @tblAccountableParty, @InstrumentID
	IF @RtnVal <> 0 RAISERROR ('Problem saving uspLinkAccountableParty' , 16, 1) 
	
	--Insert/Update Contact records
	SELECT @RtnVal =0
	Exec @RtnVal = uspLinkContacts @tblContact, @InstrumentID
	IF @RtnVal <> 0 RAISERROR ('Problem saving uspLinkContacts' , 16, 1) 
	
	-----------------------------------------------------------------------------------------
	--A. Insert/Update DGDesignApproval records
	SELECT @RtnVal =0
	Exec @RtnVal = uspSaveDGDesignApprovalAdd @tblDGDesignApproval, @InstrumentID
	IF @RtnVal <> 0 RAISERROR ('Problem saving uspSaveDGDesignApprovalAdd' , 16, 1) 
	
	--B. Insert/Update tblDGDesignApprovalClassUN records
	SELECT @RtnVal =0
	Exec @RtnVal = uspSaveDGDesignApprovalClassUN @tblDGDesignApprovalClassUN, @InstrumentID
	IF @RtnVal <> 0 RAISERROR ('Problem saving uspSaveDGDesignApprovalClassUN' , 16, 1) 

	--C. Insert/Update tblDGDesignApprovalVehicleMake records
	SELECT @RtnVal =0
	Exec @RtnVal = uspSaveDGDesignApprovalVehicleMake @tblDGDesignApprovalVehicleMake, @InstrumentID
	IF @RtnVal <> 0 RAISERROR ('Problem saving uspSaveDGDesignApprovalVehicleMake' , 16, 1) 

	--D. Insert/Update tblDGDesignApprovalTankMake records
	SELECT @RtnVal =0
	Exec @RtnVal = uspSaveDGDesignApprovalTankMake @tblDGDesignApprovalTankMake, @InstrumentID
	IF @RtnVal <> 0 RAISERROR ('Problem saving uspSaveDGDesignApprovalTankMake' , 16, 1) 
    ------------------------------------------------------------------------------------------

	--Clock event:Check for Application completed date, If Exists Start the clock.
	DECLARE @AppCompleteDate DateTime
	SELECT @AppCompleteDate =  dateadd(day, 1, DateApplicationCompleted) From @tblDGDesignApproval
	
	--we get instrument type id as this SP will be used to handle dangerous good and pesticide licence as well
	DECLARE @InstrumentTypeID int -- 750: radiation licence; 817: Dangerous Goods Licence; 818: Pesticide Licence; 990: DG Design Approval 
	select @InstrumentTypeID = InstrumentTypeID from tblInstrument where InstrumentID = @InstrumentID

	DECLARE @EventIdTemp int
	SET @EventIdTemp = 0

	if @InstrumentTypeID = 750 --radiation licence	  
	   set @EventIdTemp = 14  --/SB:Event ID 14 is to start clock in tblEvent for Radiation License Clock
    else if @InstrumentTypeID = 817 --Dangerous Goods Licence
	   set @EventIdTemp = 17
	else if @InstrumentTypeID = 818 --Pesticide Licence            
       set @EventIdTemp = 19

	--SB:Create clock if Instrument status is Draft

	IF (EXISTS(SELECT * FROM tblInstrument WHERE InstrumentID = @InstrumentID AND InstrumentStatusID = 751) AND @AppCompleteDate IS NOT NULL)
   	BEGIN
   			SELECT @RtnVal = 0
			EXEC @RtnVal = uspInstrument_Clock_Create @InstrumentID, @EventIdTemp, 0, @CreatedBySystemUserID, @AppCompleteDate 
	END
		
	  --SB:31/05/2011:Following code is also implemented in uspUpdatePOEOStatus because requirement is changed to create SAP customer when creating Radiation Licence not when issued
	  --and Invoice is generated when Issuing the licence

	------------------------ comment by mwu -----------------------
	--IF @INSERT=1
	--	EXEC uspFinanceLicneceFee @InstrumentID, @CreatedBySystemUserID
	--ELSE
	--    BEGIN
	--	 --in case the user changed accountable part or contact information we need update the tblSAPCustomer and tblInstrumentSAPCustomer tables
	--	 --we get the old Accountable party ID and Contact IDs then we compare them 
	--	 declare @OldAccountablePartyID int

	--	END
	
	------------------------ comment by mwu -----------------------
	 
			
	--COMMIT TRAN A
	--If creating new site return site id else return 0(i.e update sucess)
	IF @INSERT=0 --for updating
		SELECT 0
    ELSE
	    SELECT @InstrumentID --for inserting