declare @theXmlData xml
set @theXmlData =
'
<NewDataSet>
  <RadiationLicence>
    <InstrumentID>5000013</InstrumentID>
    <RadiationLicenceTypeID>795</RadiationLicenceTypeID>
    <DateApplicationReceived>2014-01-05T00:00:00+11:00</DateApplicationReceived>
    <DateApplicationCompleted>2014-01-19T00:00:00+11:00</DateApplicationCompleted>
    <LicencetoUseDurationID>769</LicencetoUseDurationID>
    <AdminFee>0</AdminFee>
    <LicencetoUseInstrumentID>666889</LicencetoUseInstrumentID>
    <ConsentForECFlag>true</ConsentForECFlag>
    <RefToRACFlag>true</RefToRACFlag>
    <DateCreated>2014-01-20T10:39:00+11:00</DateCreated>
    <CreatedBySystemUserID>1266</CreatedBySystemUserID>
    <DateUpdated>2014-02-11T16:06:00+11:00</DateUpdated>
    <UpdatedBySystemUserID>1266</UpdatedBySystemUserID>
    <RowTimestamp>AAAAAADIIDw=</RowTimestamp>
  </RadiationLicence>
  <RadiationLicenceFitAndProper>
    <RadiationLicenceFitAndProperID>17</RadiationLicenceFitAndProperID>
    <InstrumentID>5000013</InstrumentID>
    <FitAndProperQuestionID>1</FitAndProperQuestionID>
    <FitAndProperAnswerFlag>true</FitAndProperAnswerFlag>
    <Justification>m</Justification>
    <DateCreated>2014-01-20T10:39:00+11:00</DateCreated>
    <CreatedBySystemUserID>1266</CreatedBySystemUserID>
    <DateUpdated>2014-02-11T16:06:00+11:00</DateUpdated>
    <UpdatedBySystemUserID>1266</UpdatedBySystemUserID>
    <RowTimestamp>AAAAAADIIH0=</RowTimestamp>
    <Action>I</Action>
  </RadiationLicenceFitAndProper>
  <RadiationLicenceFitAndProper>
    <RadiationLicenceFitAndProperID>18</RadiationLicenceFitAndProperID>
    <InstrumentID>5000013</InstrumentID>
    <FitAndProperQuestionID>2</FitAndProperQuestionID>
    <FitAndProperAnswerFlag>true</FitAndProperAnswerFlag>
    <Justification>m</Justification>
    <DateCreated>2014-01-20T10:39:00+11:00</DateCreated>
    <CreatedBySystemUserID>1266</CreatedBySystemUserID>
    <DateUpdated>2014-02-11T16:06:00+11:00</DateUpdated>
    <UpdatedBySystemUserID>1266</UpdatedBySystemUserID>
    <RowTimestamp>AAAAAADIIH4=</RowTimestamp>
    <Action>I</Action>
  </RadiationLicenceFitAndProper>
  <RadiationLicenceFitAndProper>
    <RadiationLicenceFitAndProperID>19</RadiationLicenceFitAndProperID>
    <InstrumentID>5000013</InstrumentID>
    <FitAndProperQuestionID>3</FitAndProperQuestionID>
    <FitAndProperAnswerFlag>true</FitAndProperAnswerFlag>
    <Justification>m</Justification>
    <DateCreated>2014-01-20T10:39:00+11:00</DateCreated>
    <CreatedBySystemUserID>1266</CreatedBySystemUserID>
    <DateUpdated>2014-02-11T16:06:00+11:00</DateUpdated>
    <UpdatedBySystemUserID>1266</UpdatedBySystemUserID>
    <RowTimestamp>AAAAAADIIH8=</RowTimestamp>
    <Action>I</Action>
  </RadiationLicenceFitAndProper>
  <RadiationLicenceFitAndProper>
    <RadiationLicenceFitAndProperID>20</RadiationLicenceFitAndProperID>
    <InstrumentID>5000013</InstrumentID>
    <FitAndProperQuestionID>4</FitAndProperQuestionID>
    <FitAndProperAnswerFlag>true</FitAndProperAnswerFlag>
    <Justification>m</Justification>
    <DateCreated>2014-01-20T10:39:00+11:00</DateCreated>
    <CreatedBySystemUserID>1266</CreatedBySystemUserID>
    <DateUpdated>2014-02-11T16:06:00+11:00</DateUpdated>
    <UpdatedBySystemUserID>1266</UpdatedBySystemUserID>
    <RowTimestamp>AAAAAADIIIA=</RowTimestamp>
    <Action>I</Action>
  </RadiationLicenceFitAndProper>
  <RadiationLicenceFitAndProper>
    <RadiationLicenceFitAndProperID>21</RadiationLicenceFitAndProperID>
    <InstrumentID>5000013</InstrumentID>
    <FitAndProperQuestionID>5</FitAndProperQuestionID>
    <FitAndProperAnswerFlag>false</FitAndProperAnswerFlag>
    <DateCreated>2014-01-20T10:39:00+11:00</DateCreated>
    <CreatedBySystemUserID>1266</CreatedBySystemUserID>
    <DateUpdated>2014-02-11T16:06:00+11:00</DateUpdated>
    <RowTimestamp>AAAAAADIIIE=</RowTimestamp>
    <Action>I</Action>
  </RadiationLicenceFitAndProper>
  <RadiationLicenceFitAndProper>
    <RadiationLicenceFitAndProperID>22</RadiationLicenceFitAndProperID>
    <InstrumentID>5000013</InstrumentID>
    <FitAndProperQuestionID>6</FitAndProperQuestionID>
    <FitAndProperAnswerFlag>false</FitAndProperAnswerFlag>
    <DateCreated>2014-01-20T10:39:00+11:00</DateCreated>
    <CreatedBySystemUserID>1266</CreatedBySystemUserID>
    <DateUpdated>2014-02-11T16:06:00+11:00</DateUpdated>
    <RowTimestamp>AAAAAADIIII=</RowTimestamp>
    <Action>I</Action>
  </RadiationLicenceFitAndProper>
  <RadiationLicenceFitAndProper>
    <RadiationLicenceFitAndProperID>23</RadiationLicenceFitAndProperID>
    <InstrumentID>5000013</InstrumentID>
    <FitAndProperQuestionID>7</FitAndProperQuestionID>
    <FitAndProperAnswerFlag>false</FitAndProperAnswerFlag>
    <DateCreated>2014-01-20T10:39:00+11:00</DateCreated>
    <CreatedBySystemUserID>1266</CreatedBySystemUserID>
    <DateUpdated>2014-02-11T16:06:00+11:00</DateUpdated>
    <RowTimestamp>AAAAAADIIIM=</RowTimestamp>
    <Action>I</Action>
  </RadiationLicenceFitAndProper>
  <RadiationLicenceFitAndProper>
    <RadiationLicenceFitAndProperID>24</RadiationLicenceFitAndProperID>
    <InstrumentID>5000013</InstrumentID>
    <FitAndProperQuestionID>8</FitAndProperQuestionID>
    <FitAndProperAnswerFlag>false</FitAndProperAnswerFlag>
    <DateCreated>2014-01-20T10:39:00+11:00</DateCreated>
    <CreatedBySystemUserID>1266</CreatedBySystemUserID>
    <DateUpdated>2014-02-11T16:06:00+11:00</DateUpdated>
    <RowTimestamp>AAAAAADIIIQ=</RowTimestamp>
    <Action>I</Action>
  </RadiationLicenceFitAndProper>
  <RadiationLicenceQualification>
    <RadiationLicenceQualificationID>38</RadiationLicenceQualificationID>
    <InstrumentID>5000013</InstrumentID>
    <QualificationID>220</QualificationID>
    <DateCreated>2014-01-20T10:39:00+11:00</DateCreated>
    <CreatedBySystemUserID>1266</CreatedBySystemUserID>
    <DateUpdated>2014-02-11T16:06:00+11:00</DateUpdated>
    <RowTimestamp>AAAAAADIIGI=</RowTimestamp>
    <Action>I</Action>
    <Name>EPA assessement</Name>
  </RadiationLicenceQualification>
  <RadiationLicenceQualification>
    <RadiationLicenceQualificationID>39</RadiationLicenceQualificationID>
    <InstrumentID>5000013</InstrumentID>
    <QualificationID>214</QualificationID>
    <DateCreated>2014-01-20T10:39:00+11:00</DateCreated>
    <CreatedBySystemUserID>1266</CreatedBySystemUserID>
    <DateUpdated>2014-02-11T16:06:00+11:00</DateUpdated>
    <RowTimestamp>AAAAAADIIGM=</RowTimestamp>
    <Action>I</Action>
    <Name>Quality assurance in diagnostic radiology certificate of successful completion radiography and fluor</Name>
    <Provider>University of Sydney</Provider>
  </RadiationLicenceQualification>
  <Instrument>
    <InstrumentID>5000013</InstrumentID>
    <InstrumentTypeID>750</InstrumentTypeID>
    <InstrumentStatusID>755</InstrumentStatusID>
    <ResponsibleSystemUserID>1266</ResponsibleSystemUserID>
    <ResponsibleUser>He Eric (DEC\HEE)</ResponsibleUser>
    <LoginName>DEC\HEE</LoginName>
    <DECCWSectionID>15</DECCWSectionID>
    <IssuedBySystemUserID>1266</IssuedBySystemUserID>
    <IssuedBy>He Eric</IssuedBy>
    <DateIssued>2014-02-10T16:10:00+11:00</DateIssued>
    <DisplayFlag>false</DisplayFlag>
    <DateCreated>2014-01-20T10:39:00+11:00</DateCreated>
    <CreatedBySystemUserID>1266</CreatedBySystemUserID>
    <DateUpdated>2014-02-11T16:06:00+11:00</DateUpdated>
    <UpdatedBySystemUserID>1266</UpdatedBySystemUserID>
    <RowTimestamp>0x0000000000c8203b</RowTimestamp>
    <HasRecordService>false</HasRecordService>
    <HasActiveVariation>true</HasActiveVariation>
    <HasActiveSystemNotice>false</HasActiveSystemNotice>
    <SystemNoticeName />
    <SectionName>Metropolitan - Sydney Industry</SectionName>
    <HasActiveCorrection>false</HasActiveCorrection>
  </Instrument>
  <AccountableParty>
    <InstrumentAccountablePartyID>22788</InstrumentAccountablePartyID>
    <InstrumentID>5000013</InstrumentID>
    <AccountablePartyID>2858</AccountablePartyID>
    <AccountablePartyName>BHP BILLITON INNOVATION PTY. LTD.</AccountablePartyName>
    <AddressABN>41 008 457 154</AddressABN>
    <LandownerFlag>false</LandownerFlag>
    <EffectiveDateFrom>2014-01-20T10:39:00+11:00</EffectiveDateFrom>
    <DateCreated>2014-01-20T10:39:00+11:00</DateCreated>
    <CreatedBySystemUserID>1266</CreatedBySystemUserID>
    <RowTimestamp>0x0000000000c7e787</RowTimestamp>
  </AccountableParty>
  <Contact>
    <InstrumentContactID>23062</InstrumentContactID>
    <InstrumentID>5000013</InstrumentID>
    <ContactID>7024</ContactID>
    <ContactName>James Hammond</ContactName>
    <Address>PO BOX 6550, WETHERILL PARK, NSW, 1851</Address>
    <EMail>james.hammond@australbricks.com.au</EMail>
    <PostalContactFlag>false</PostalContactFlag>
    <EmailContactFlag>true</EmailContactFlag>
    <DateCreated>2014-01-20T10:39:00+11:00</DateCreated>
    <CreatedBySystemUserID>1266</CreatedBySystemUserID>
    <DateUpdated>2014-02-11T16:06:00+11:00</DateUpdated>
    <UpdatedBySystemUserID>1266</UpdatedBySystemUserID>
    <RowTimestamp>0x0000000000c8203d</RowTimestamp>
    <Action>U</Action>
  </Contact>
  <Contact>
    <InstrumentContactID>23063</InstrumentContactID>
    <InstrumentID>5000013</InstrumentID>
    <ContactID>8182</ContactID>
    <ContactName xml:space="preserve"> </ContactName>
    <Address>11 MEADOW ROAD, NEW LAMBTON, NSW, 2305</Address>
    <EMail>ehe868@gmail.com</EMail>
    <PostalContactFlag>true</PostalContactFlag>
    <EmailContactFlag>false</EmailContactFlag>
    <DateCreated>2014-01-20T10:39:00+11:00</DateCreated>
    <CreatedBySystemUserID>1266</CreatedBySystemUserID>
    <DateUpdated>2014-02-11T16:06:00+11:00</DateUpdated>
    <UpdatedBySystemUserID>1266</UpdatedBySystemUserID>
    <RowTimestamp>0x0000000000c8203e</RowTimestamp>
    <Action>U</Action>
  </Contact>
  <AuditLog>
    <InstrumentID>5000013</InstrumentID>
    <DateCreated>2014-02-11T14:17:00+11:00</DateCreated>
    <DescriptionOfAction>Radiation variation changed from Draft to Complete</DescriptionOfAction>
    <Details>Radiation Licence VariationID: 9</Details>
    <UserName>Eric He</UserName>
    <CreatedBySystemUserID>1266</CreatedBySystemUserID>
  </AuditLog>
  <AuditLog>
    <InstrumentID>5000013</InstrumentID>
    <DateCreated>2014-02-10T16:10:00+11:00</DateCreated>
    <DescriptionOfAction>Radiation licence Issued</DescriptionOfAction>
    <Details>Radiation licence Issued</Details>
    <UserName>Eric He</UserName>
    <CreatedBySystemUserID>1266</CreatedBySystemUserID>
  </AuditLog>
  <AuditLog>
    <InstrumentID>5000013</InstrumentID>
    <DateCreated>2014-02-10T16:09:00+11:00</DateCreated>
    <DescriptionOfAction>Radiation licence Issued</DescriptionOfAction>
    <Details>Radiation licence Issued</Details>
    <UserName>Eric He</UserName>
    <CreatedBySystemUserID>1266</CreatedBySystemUserID>
  </AuditLog>
  <AuditLog>
    <InstrumentID>5000013</InstrumentID>
    <DateCreated>2014-02-10T16:00:00+11:00</DateCreated>
    <DescriptionOfAction>Radiation</DescriptionOfAction>
    <Details>Radiation</Details>
    <UserName>Eric He</UserName>
    <CreatedBySystemUserID>1266</CreatedBySystemUserID>
  </AuditLog>
  <AuditLog>
    <InstrumentID>5000013</InstrumentID>
    <DateCreated>2014-01-20T10:39:00+11:00</DateCreated>
    <DescriptionOfAction>Radiation Licence created and Assigned Draft statu</DescriptionOfAction>
    <Details>Radiation Licence created and Assigned Draft status</Details>
    <UserName>Eric He</UserName>
    <CreatedBySystemUserID>1266</CreatedBySystemUserID>
  </AuditLog>
  <ClockHistory>
    <InstrumentClockHistoryID>35657</InstrumentClockHistoryID>
    <InstrumentClockID>4835</InstrumentClockID>
    <ClockActionTypeID>561</ClockActionTypeID>
    <ActionName>Stopped</ActionName>
    <Reason>Radiation License issued</Reason>
    <DaysRemaining>37</DaysRemaining>
    <CreatedBySystemUserId>1266</CreatedBySystemUserId>
    <DateCreated>2014-02-10T16:09:00+11:00</DateCreated>
  </ClockHistory>
  <ClockHistory>
    <InstrumentClockHistoryID>35656</InstrumentClockHistoryID>
    <InstrumentClockID>4835</InstrumentClockID>
    <ClockActionTypeID>560</ClockActionTypeID>
    <ActionName>Started</ActionName>
    <Reason>Radiation License Completed Date Entered</Reason>
    <DaysRemaining>60</DaysRemaining>
    <CreatedBySystemUserId>1266</CreatedBySystemUserId>
    <DateCreated>2014-01-18T13:00:00+11:00</DateCreated>
  </ClockHistory>
  <Clock>
    <InstrumentClockID>4835</InstrumentClockID>
    <InstrumentID>5000013</InstrumentID>
    <ClockID>7</ClockID>
    <ClockStatusID>512</ClockStatusID>
    <ClockStartDate>2014-01-18T13:00:00+11:00</ClockStartDate>
    <AlertSentFlag>false</AlertSentFlag>
    <CreatedBySystemUserID>1266</CreatedBySystemUserID>
    <UpdatedBySystemUserID>1266</UpdatedBySystemUserID>
    <RowTimeStamp>AAAAAADIFmQ=</RowTimeStamp>
    <ManualStopClockFlag>true</ManualStopClockFlag>
  </Clock>
  <RadiationLicenceVariation>
    <RadiationLicenceVariationID>9</RadiationLicenceVariationID>
    <InstrumentID>5000013</InstrumentID>
    <VariationReason>add one more add one more
add one more add one more
add one more add one more
add one more add one more</VariationReason>
    <VariationFeeAppliedFlag>true</VariationFeeAppliedFlag>
    <RefToRACFlag>false</RefToRACFlag>
    <VariationCompletedFlag>true</VariationCompletedFlag>
    <VariationCompleteDate>2014-02-11T14:17:00+11:00</VariationCompleteDate>
    <VariationCompletedBySystemUserID>1266</VariationCompletedBySystemUserID>
    <DateCreated>2014-02-10T17:20:00+11:00</DateCreated>
    <CreatedBySystemUserID>1266</CreatedBySystemUserID>
    <DateUpdated>2014-02-11T16:06:00+11:00</DateUpdated>
    <RowTimestamp>AAAAAADIIJc=</RowTimestamp>
    <Action>I</Action>
    <CreatorName>Eric He</CreatorName>
  </RadiationLicenceVariation>
  <RadiationLicenceVariation>
    <RadiationLicenceVariationID>11</RadiationLicenceVariationID>
    <InstrumentID>5000013</InstrumentID>
    <VariationReason>add one more</VariationReason>
    <VariationFeeAppliedFlag>true</VariationFeeAppliedFlag>
    <RefToRACFlag>false</RefToRACFlag>
    <VariationCompletedFlag>false</VariationCompletedFlag>
    <VariationCompletedBySystemUserID>1266</VariationCompletedBySystemUserID>
    <DateCreated>2014-02-11T14:17:00+11:00</DateCreated>
    <CreatedBySystemUserID>1266</CreatedBySystemUserID>
    <DateUpdated>2014-02-11T16:06:00+11:00</DateUpdated>
    <RowTimestamp>AAAAAADIIJg=</RowTimestamp>
    <Action>I</Action>
    <CreatorName>Eric He</CreatorName>
  </RadiationLicenceVariation>
  <RadiationLicenceCondition>
    <RadiationLicenceConditionID>2</RadiationLicenceConditionID>
    <InstrumentID>5000013</InstrumentID>
    <RadiationConditionID>87</RadiationConditionID>
    <DateCreated>2014-01-20T10:39:00+11:00</DateCreated>
    <CreatedBySystemUserID>1266</CreatedBySystemUserID>
    <RowTimestamp>AAAAAADH55Q=</RowTimestamp>
    <Action>I</Action>
    <CreatorName>Eric He</CreatorName>
    <RadiationConditionName>S50</RadiationConditionName>
    <RadiationConditionDesc>Authorised Officer appointed under the Radiation Control Act</RadiationConditionDesc>
  </RadiationLicenceCondition>
  <RadiationLicenceRadioactiveSubstances>
    <RadiationLicenceRadioactiveSubstancesID>9</RadiationLicenceRadioactiveSubstancesID>
    <InstrumentID>5000013</InstrumentID>
    <RadioactiveSubstanceTypeID>808</RadioactiveSubstanceTypeID>
    <MaxActivity>23</MaxActivity>
    <MaxActivityUOMID>778</MaxActivityUOMID>
    <RadionuclideID>28</RadionuclideID>
    <DateCreated>2014-02-10T16:00:00+11:00</DateCreated>
    <CreatedBySystemUserID>1266</CreatedBySystemUserID>
    <RowTimestamp>AAAAAADIFck=</RowTimestamp>
    <Action>I</Action>
    <SubstanceTypeText>Sealed</SubstanceTypeText>
    <RadionuclideText>strontium-90 (yttrium-90)</RadionuclideText>
  </RadiationLicenceRadioactiveSubstances>
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
			 (case @TempRadiationLicenceTypeID when 794 then RN.S.value('Notes[1]','varchar(1000)') else null end) AS Notes,
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
		   RN.S.value('Action[1]','char(1)') AS Action    
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
	)
	SELECT RN.S.value('RadiationLicenceRadioactiveSubstancesID[1]','int') AS RadiationLicenceRadioactiveSubstancesID,
		   RN.S.value('InstrumentID[1]','int') AS InstrumentID,
		   RN.S.value('RadioactiveSubstanceTypeID[1]','int') AS RadioactiveSubstanceTypeID,	
		   RN.S.value('MaxActivity[1]','int') AS MaxActivity,	
		   RN.S.value('MaxActivityUOMID[1]','int') AS MaxActivityUOMID,	
		   RN.S.value('RadionuclideID[1]','int') AS RadionuclideID,	
		   RN.S.value('PurposeOfUse[1]','varchar(255)') AS PurposeOfUse, 	 
		   RN.S.value('DateCreated[1]','datetime') AS DateCreated,
		   RN.S.value('CreatedBySystemUserID[1]','int') AS CreatedBySystemUserID,
		   RN.S.value('DateUpdated[1]','datetime') AS DateUpdated,
		   RN.S.value('UpdatedBySystemUserID[1]','int') AS UpdatedBySystemUserID,
		   RN.S.value('Action[1]','char(1)') AS Action    
	FROM @theXmlData.nodes('/NewDataSet/RadiationLicenceRadioactiveSubstances') AS RN(S)
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

	
	--SELECT @TempRadiationLicenceTypeID = RadiationLicenceTypeID FROM @tblRadiationLicence WHERE InstrumentID = @InstrumentID

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
			UPDATE tblRadiationLicence 
			SET ConsentForECFlag = B.ConsentForECFlag, 
			Notes = B.Notes,
			RefToRACFlag = B.RefToRACFlag, 
			UpdatedBySystemUserID = B.UpdatedBySystemUserID, 
			DateUpdated = Getdate(),
			LicencetoUseDurationID = B.LicencetoUseDurationID,
			ManagementLicenceActivityandDurationID = B.ManagementLicenceActivityandDurationID,
			AdminFee = B.AdminFee 
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

	select * from @tblRadiationLicenceVariation
	select * from tblRadiationLicenceVariation where InstrumentID = 5000013

	--Radiation Licence Variation
	SELECT @CntRadiationLicenceVariation = 0
	SELECT @CntRadiationLicenceVariation = COUNT(*) FROM @tblRadiationLicenceVariation
    IF @CntRadiationLicenceVariation > 0
	BEGIN	
	  SET @Cnt = 1
	  WHILE @Cnt <= @CntRadiationLicenceVariation
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
								(case VariationCompletedFlag when 0 then null else VariationCompleteDate end),								
								VariationCompletedBySystemUserID, 
								GetDate(),						  
								CreatedBySystemUserID						    
						FROM @tblRadiationLicenceVariation WHERE Sno =  @Cnt    
					end		
				END 
			ELSE IF upper(@RowAction)='I' 
			--AND exists(select * from tblRadiationLicenceVariation where InstrumentID = @InstrumentID and RadiationLicenceVariationID=@RadiationLicenceVariationID)  --update record
				BEGIN
					UPDATE tblRadiationLicenceVariation 
					SET 
					    VariationReason = @VariationReason,	
						VariationFeeAppliedFlag = A.VariationFeeAppliedFlag,				     					 
				 	    DateUpdated = GetDate(),
					    UpdatedBySystemUserID = @UpdatedBySystemUserID					  
					FROM tblRadiationLicenceVariation B INNER JOIN @tblRadiationLicenceVariation A ON B.RadiationLicenceVariationID = A.RadiationLicenceVariationID   			 
					Where A.RadiationLicenceVariationID = @RadiationLicenceVariationID AND A.InstrumentID = @InstrumentID				
				END
			ELSE IF @RowAction='D' AND @CntRadiationLicenceVariation > 0  --Delete record	
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
														)
								SELECT 	@InstrumentID,
										@RadiationApparatuID,	
										MaximummA,
										MaximumkVp,
										PurposeOfUse,																				 
										GetDate(),						  
										CreatedBySystemUserID						    
								FROM @tblRadiationLicenceRadioactiveApparatus WHERE Sno =  @Cnt    
							end		
						END 
					ELSE IF @RowAction='U' AND exists(select * from tblRadiationLicenceRadioactiveApparatus where InstrumentID = @InstrumentID and RadiationLicenceRadioactiveApparatusID=@RadiationLicenceRadioactiveApparatusID)  --update record
						BEGIN
							UPDATE tblRadiationLicenceRadioactiveApparatus
							SET 
								RadiationApparatuID = @RadiationApparatuID,	
								MaximummA = B.MaximummA,
								MaximumkVp = B.MaximumkVp, 
								PurposeOfUse = B.PurposeOfUse,				     					 
				 				DateUpdated = GetDate(),
								UpdatedBySystemUserID = @UpdatedBySystemUserID					  
							FROM tblRadiationLicenceRadioactiveApparatus A INNER JOIN @tblRadiationLicenceRadioactiveApparatus B ON A.RadiationLicenceRadioactiveApparatusID = B.RadiationLicenceRadioactiveApparatusID				 
							Where A.RadiationLicenceRadioactiveApparatusID = @RadiationLicenceRadioactiveApparatusID AND A.InstrumentID = @InstrumentID
						END
					ELSE IF @RowAction='D' AND @RadiationLicenceConditionID > 0  --Delete record	
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
														)
								SELECT 	@InstrumentID,
										@RadioactiveSubstanceTypeID,	
										MaxActivity,
										MaxActivityUOMID,
										RadionuclideID,
										PurposeOfUse,																				 
										GetDate(),						  
										CreatedBySystemUserID						    
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
								UpdatedBySystemUserID = @UpdatedBySystemUserID					  
							FROM tblRadiationLicenceRadioactiveSubstances A INNER JOIN @tblRadiationLicenceRadioactiveSubstances B ON A.RadiationLicenceRadioactiveSubstancesID = B.RadiationLicenceRadioactiveSubstancesID				 
							Where A.RadiationLicenceRadioactiveSubstancesID = @RadiationLicenceRadioactiveSubstancesID AND A.InstrumentID = @InstrumentID
						END
					ELSE IF @RowAction='D' AND @RadiationLicenceConditionID > 0  --Delete record	
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
			EXEC @RtnVal = uspInstrument_Clock_Create @InstrumentID, 14, 0, @CreatedBySystemUserID, @AppCompleteDate --/SB:Event ID 14 is to start clock in tblEvent for Radiation License Clock
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