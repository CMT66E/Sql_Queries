declare @theXmlData xml
declare @theAssessablePollutants xml

set @theXmlData = '<NewDataSet>\r\n  <POEOLicence>\r\n    <InstrumentID>-1</InstrumentID>\r\n    <DateApplicationReceived>2014-01-07T00:00:00</DateApplicationReceived>\r\n    <DateApplicationCompleted>2014-01-07T00:00:00</DateApplicationCompleted>\r\n    <TRIMNumber>888999</TRIMNumber>\r\n    <AdminFee>2825.00</AdminFee>\r\n    <DevConsentGivenTypeID>559</DevConsentGivenTypeID>\r\n    <ConsentForECFlag>false</ConsentForECFlag>\r\n    <LBLFlag>false</LBLFlag>\r\n    <CoastalWaterFlag>false</CoastalWaterFlag>\r\n    <EnclosedWaterFlag>false</EnclosedWaterFlag>\r\n    <EstuarineWaterFlag>false</EstuarineWaterFlag>\r\n    <AssesablePollutants>false</AssesablePollutants>\r\n    <IsRiskZone>false</IsRiskZone>\r\n    <CreatedBySystemUserID>1266</CreatedBySystemUserID>\r\n    <PIRMPinPlaceFlag>false</PIRMPinPlaceFlag>\r\n  </POEOLicence>\r\n  <FeeBasedActivity>\r\n    <POEOLicenceFeeBasedActivityID>-1</POEOLicenceFeeBasedActivityID>\r\n    <InstrumentID>-1</InstrumentID>\r\n    <FeeBasedActivityID>12</FeeBasedActivityID>\r\n    
<FeeBasedActivityName>Agricultural fertiliser (inorganic) production</FeeBasedActivityName>\r\n    <Premises>true</Premises>\r\n    <AssesablePollutants>false</AssesablePollutants>\r\n    <FeeBasedActivityScaleID>792</FeeBasedActivityScaleID>\r\n    <Scale>0-50000 T produced</Scale>\r\n    <TotalFee>2825.00</TotalFee>\r\n    <DateCreated>2014-01-07T14:29:34.7329532</DateCreated>\r\n    <CreatedBySystemUserID>1266</CreatedBySystemUserID>\r\n    <Action>I</Action>\r\n    <GenerateARFlag>true</GenerateARFlag>\r\n    <PrimaryFlag>true</PrimaryFlag>\r\n  </FeeBasedActivity>\r\n  <Instrument>\r\n    <InstrumentID>-1</InstrumentID>\r\n    <InstrumentTypeID>493</InstrumentTypeID>\r\n    <InstrumentStatusID>5</InstrumentStatusID>\r\n    <ResponsibleUser>He Eric (DEC\\HEE)</ResponsibleUser>\r\n    <LoginName>DEC\\HEE</LoginName>\r\n    <CreatedBySystemUserID>1266</CreatedBySystemUserID>\r\n    <HasRecordService>false</HasRecordService>\r\n    <HasActiveVariation>false</HasActiveVariation>\r\n    <HasActiveSystemNotice>false
</HasActiveSystemNotice>\r\n    <SectionName>Metropolitan - Sydney Industry</SectionName>\r\n    <HasActiveCorrection>false</HasActiveCorrection>\r\n  </Instrument>\r\n  <AccountableParty>\r\n    <InstrumentAccountablePartyID>-1</InstrumentAccountablePartyID>\r\n    <InstrumentID>-1</InstrumentID>\r\n    <AccountablePartyID>2858</AccountablePartyID>\r\n    <AccountablePartyName>BHP BILLITON INNOVATION PTY. LTD.</AccountablePartyName>\r\n    <AddressABN>41 008 457 154</AddressABN>\r\n    <DateCreated>2014-01-07T14:29:48.5519532</DateCreated>\r\n    <CreatedBySystemUserID>1266</CreatedBySystemUserID>\r\n    <Action>I</Action>\r\n  </AccountableParty>\r\n  <Contact>\r\n    <InstrumentContactID>-1</InstrumentContactID>\r\n    <InstrumentID>-1</InstrumentID>\r\n    <ContactID>7024</ContactID>\r\n    <ContactName>Mr James Hammond</ContactName>\r\n    <Address>PO BOX 6550, WETHERILL PARK 1851</Address>\r\n    <EMail>james.hammond@australbricks.com.au</EMail>\r\n    <PostalContactFlag>false</PostalContactFlag>\r\n    
<EmailContactFlag>false</EmailContactFlag>\r\n    <DateCreated>2014-01-07T14:30:02.1659532</DateCreated>\r\n    <CreatedBySystemUserID>1266</CreatedBySystemUserID>\r\n    <UpdatedBySystemUserID>1266</UpdatedBySystemUserID>\r\n    <Action>I</Action>\r\n  </Contact>\r\n  <Contact>\r\n    <InstrumentContactID>-2</InstrumentContactID>\r\n    <InstrumentID>-1</InstrumentID>\r\n    <ContactID>7560</ContactID>\r\n    <ContactName />\r\n    <Address>143 PYE ROAD, QUAKERS HILL, NSW, 2763</Address>\r\n    <EMail>ehe868@gmail.com</EMail>\r\n    <PostalContactFlag>true</PostalContactFlag>\r\n    <EmailContactFlag>false</EmailContactFlag>\r\n    <DateCreated>2014-01-07T14:30:02.1659532</DateCreated>\r\n    <CreatedBySystemUserID>1266</CreatedBySystemUserID>\r\n    <UpdatedBySystemUserID>1266</UpdatedBySystemUserID>\r\n    <Action>U</Action>\r\n  </Contact>\r\n  <Location>\r\n    <InstrumentLocationID>-1</InstrumentLocationID>\r\n    <InstrumentID>-1</InstrumentID>\r\n    <LocationID>1145</LocationID>\r\n    
<LocationName>NEWCASTLE SEWERAGE SYSTEM including BURWOOD BEACH WASTEWATER TREATMENT PLANT</LocationName>\r\n    <Address>OFF SCENIC DRIVE MEREWETHER 2291 NSW</Address>\r\n    <IsRiskZone>false</IsRiskZone>\r\n    <DateCreated>2014-01-07T14:30:42.7479532+11:00</DateCreated>\r\n    <CreatedBySystemUserID>1266</CreatedBySystemUserID>\r\n    <Action>I</Action>\r\n  </Location>\r\n</NewDataSet>'

set @theAssessablePollutants = '<NewDataSet />'

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
	
	DECLARE @tblPOEOLicenceEnvironmentalRiskLevelType tblPOEOLicenceEnvironmentalRiskLevelType
	
  --RN.S.value('xs:dateTime(EffectiveDateFrom[1])','smalldatetime') AS EffectiveDateFrom,
  --RN.S.value('xs:dateTime(EffectiveDateTo[1])','smalldatetime') AS EffectiveDateTo,	
  --RN.S.value('AdditionalAddressInformation[1]','varchar(255)') AS AdditionalAddressInformation,		
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
						 PIRMPinPlaceFlag)
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
			  RN.S.value('PIRMPinPlaceFlag[1]','bit') AS PIRMPinPlaceFlag
   FROM @theXmlData.nodes('/NewDataSet/POEOLicence') AS RN(S)
	
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
 	--RN.S.value('LandownerFlag[1]', 'bit') AS LandownerFlag,
	
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
	
	
	------------- PALMS V4.0
	INSERT INTO @tblPOEOLicenceEnvironmentalRiskLevelType
			(POEOLicenceEnvironmentalRiskLevelID,
			EnvironmentalRiskLevelID,
			ChangedReasonID,
			Remarks,
			UpdatedBySystemUserID,
			Action)
	SELECT RN.S.value('POEOLicenceEnvironmentalRiskLevelID[1]','int') AS POEOLicenceEnvironmentalRiskLevelID,		
			RN.S.value('EnvironmentalRiskLevelID[1]','int') AS EnvironmentalRiskLevelID,	
			RN.S.value('ChangedReasonID[1]','int') AS ChangedReasonID,	
			RN.S.value('Remarks[1]','varchar(500)') AS Remarks,	
			RN.S.value('UpdatedBySystemUserID[1]','int') AS UpdatedBySystemUserID,
			RN.S.value('Action[1]','char(1)') AS Action
	FROM @theXmlData.nodes('/NewDataSet/EnvironmentalRiskLevel') AS RN(S)
	WHERE RN.S.value('Action[1]','char(1)') = 'U'		
	
	
	
	
	
	--------------------------------------- 		
		
	SELECT @InstrumentID = InstrumentID,@CreatedBySystemUserID = CreatedBySystemUserID,
		   @UpdatedBySystemUserID = UpdatedBySystemUserID
	FROM @tblInstrument
	
	SELECT @Cnt = count(*) From tblInstrument Where InstrumentID = @InstrumentID
	
	IF @InstrumentID>0 AND @Cnt=1  
	   SELECT @INSERT = 0
	ELSE  
	   SELECT @INSERT = 1
	
	BEGIN TRAN A
	--Insert or Update Address
	Exec @InstrumentID = uspSaveInstrument @tblInstrument
	
	IF @InstrumentID < 0 RAISERROR ('Problem saving uspSaveInstrument' , 16, 1)
    
	--Insert/Update Location record	
    IF @INSERT=1
	  BEGIN
			--- PALMS V3.0 ----------------------
		    INSERT INTO tblPOEOLicence(InstrumentID,
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
										DateCreated,
										CreatedBySystemUserID,
										PIRMPinPlaceFlag)
			Select		  @InstrumentID,
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
						  GETDATE(),
						  CreatedBySystemUserID,
						  PIRMPinPlaceFlag
			From @tblPOEO
			
			--Add an entry in to Audit log table
			SELECT @RtnVal = 0
			EXEC @RtnVal = uspAuditLogInsert @InstrumentID,'Licence created and Assigned Draft status','Licence created and Assigned Draft status',@CreatedBySystemUserID,@CreatedBySystemUserID,1
			
	  END
	ELSE
	  BEGIN  
	        SELECT @TempRowTimeStamp = RowTimeStamp,@TempRiskFlag = LowRiskFlag FROM @tblPOEO WHERE InstrumentID = @InstrumentID
			
			SELECT @RowTimeStamp = dbo.ufn_varbintohexstr(RowTimeStamp),@POEORiskFlag = LowRiskFlag FROM tblPOEOLicence WHERE InstrumentID = @InstrumentID
			
			SELECT @CreatedBySystemUserID = @UpdatedBySystemUserID            
			--IF @RowTimeStamp <> @TempRowTimeStamp
			-- BEGIN
			--	ROLLBACK TRAN A
			--    RETURN -2 -- Concurency problem
			-- END
			--ELSE
			--   BEGIN
			    ---     PALMS V3.0
				UPDATE tblPOEOLicence SET DateApplicationReceived = Temp.DateApplicationReceived,
										  DateApplicationCompleted = Temp.DateApplicationCompleted,
										  TRIMNumber = Temp.TRIMNumber,
										  AdminFee = Temp.AdminFee,
										  AnniversaryDate = Temp.AnniversaryDate,
										  ReviewDueDate = Temp.ReviewDueDate,
										  DevConsentGivenTypeID = Temp.DevConsentGivenTypeID,
										  LowRiskFlag = Temp.LowRiskFlag,
										  ConsentForECFlag = Temp.ConsentForECFlag,
										  LBLFlag = Temp.LBLFlag,
										  CoastalWaterFlag = Temp.CoastalWaterFlag,
										  EnclosedWaterFlag = Temp.EnclosedWaterFlag,
										  EstuarineWaterFlag = Temp.EstuarineWaterFlag,
										  DateUpdated = GETDATE(),
										  UpdatedBySystemUserID = Temp.UpdatedBySystemUserID,
										  PIRMPinPlaceFlag = Temp.PIRMPinPlaceFlag
				From tblPOEOLicence AS POEO
				JOIN @tblPOEO AS Temp ON POEO.InstrumentID = Temp.InstrumentID
				WHERE POEO.InstrumentID = @InstrumentID 
				
				--Add an entry in to Audit log table if risk flag is changed
				IF @TempRiskFlag <> @POEORiskFlag
				   BEGIN
						IF @TempRiskFlag = 1 --Low risk flag is true
							SELECT @AuditLogMsg = 'Licence risk level changed from High to Low risk'
						ELSE 
							SELECT @AuditLogMsg = 'Licence risk level changed from Low to High risk'
					    
					    SELECT @RtnVal = 0
						EXEC @RtnVal = uspAuditLogInsert @InstrumentID,@AuditLogMsg,@AuditLogMsg,@CreatedBySystemUserID,@CreatedBySystemUserID		
				   END
			   --END
	  END
	
	
	--Insert/Update Accountable Party records
	SELECT @RtnVal =0
	Exec @RtnVal = uspLinkAccountableParties @tblAccountableParty,@InstrumentID
	IF @RtnVal <> 0 RAISERROR ('Problem saving uspLinkAccountableParty' , 16, 1) 
	
	--Insert/Update Contact records
	SELECT @RtnVal =0
	Exec @RtnVal = uspLinkContacts @tblContact,@InstrumentID
	IF @RtnVal <> 0 RAISERROR ('Problem saving uspLinkContacts' , 16, 1) 
	
	--Insert/Update Location records
	SELECT @RtnVal =0
	Exec @RtnVal = uspLinkLocations @tblLocation,@InstrumentID
	IF @RtnVal <> 0 RAISERROR ('Problem saving uspLinkLocations' , 16, 1) 
	
	---Fee based activities
	--If there is no record in dataset do not proceed
	SELECT @CntFeeBasedActivity = 0
	SELECT @CntFeeBasedActivity = COUNT(*) FROM @tblFeeBasedActivity
	IF @CntFeeBasedActivity <= 0
		RETURN 
		
	-- loop through Fee Based Activity records
	-- Add the conditions associated to the fee Based activity list
	SELECT @RtnVal = 0
	Exec @RtnVal = uspAddInstrumentConditionsByFeeBasedActivity @tblFeeBasedActivity,@InstrumentID
	IF @RtnVal <> 0 RAISERROR ('Problem saving uspAddInstrumentConditionsByFeeBasedActivity' , 16, 1) 
	---
	SET @Cnt = 1
	WHILE @Cnt <= @CntFeeBasedActivity
		BEGIN
			
			SELECT @POEOFeeBasedActivityID = POEOLicenceFeeBasedActivityID,@RowAction = Action FROM @tblFeeBasedActivity
			WHERE Sno =  @Cnt
			
			IF @RowAction='I' AND @POEOFeeBasedActivityID < 0  --Insert new record
  			   BEGIN
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

				END 
			ELSE IF @RowAction='I' AND @POEOFeeBasedActivityID > 0  --update record
				BEGIN
					UPDATE tblPOEOLicenceFeeBasedActivity
					SET FeeBasedActivityID = Temp.FeeBasedActivityID,
						FeeBasedActivityScaleID = Temp.FeeBasedActivityScaleID,
				 	    DateUpdated = GetDate(),
					    UpdatedBySystemUserID = Temp.UpdatedBySystemUserID,
					    PrimaryFlag = Temp.PrimaryFlag     --- PALMS V3.0
					FROM tblPOEOLicenceFeeBasedActivity FBA
					JOIN @tblFeeBasedActivity Temp ON FBA.POEOLicenceFeeBasedActivityID = Temp.POEOLicenceFeeBasedActivityID
					Where FBA.POEOLicenceFeeBasedActivityID = @POEOFeeBasedActivityID
				END
			ELSE IF @RowAction='D' AND @POEOFeeBasedActivityID > 0  --Delete record	
			  BEGIN 
			       DELETE FROM tblPOEOLicenceFeeBasedActivity
			       WHERE POEOLicenceFeeBasedActivityID = @POEOFeeBasedActivityID
			  END  
			  SELECT @Cnt = @Cnt+1
		END -- End of loop
	
	--
	--Add/Update scheduled activities based on the feebased activities
	Exec @RtnVal = uspSaveScheduledActivities @InstrumentID,@CreatedBySystemUserID
	IF @RtnVal < 0 RAISERROR ('Problem saving uspSaveScheduledActivities' , 16, 1) 
	--	
	--Save/Update Assessable pollutants
	Exec @RtnVal = uspSavePOEOAssesablePollutants @theAssessablePollutants,@InstrumentID,0,0,0,1
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
	
	
	
	----------------- PALMS V4.0
	IF EXISTS (SELECT COUNT(*) FROM @tblPOEOLicenceEnvironmentalRiskLevelType)
	BEGIN
		UPDATE tblPOEOLicenceEnvironmentalRiskLevel
		SET EnvironmentalRiskLevelID = B.EnvironmentalRiskLevelID,
			ChangedReasonID = B.ChangedReasonID,
			Remarks =B.Remarks,
			UpdatedBySystemUserID = B.UpdatedBySystemUserID,
			DateUpdated = GETDATE()
		FROM tblPOEOLicenceEnvironmentalRiskLevel A, @tblPOEOLicenceEnvironmentalRiskLevelType B
		WHERE A.POEOLicenceEnvironmentalRiskLevelID = B.POEOLicenceEnvironmentalRiskLevelID
	END
	
			
	COMMIT TRAN A
	--If creating new site return site id else return 0(i.e update sucess)
	IF @INSERT=0 --for updating
		SELECT 0
    ELSE
	    SELECT @InstrumentID --for inserting