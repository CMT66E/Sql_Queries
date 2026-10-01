                declare @theXmlData xml = 
				'
<NewDataSet>
  <TransporterLicence>
    <InstrumentID>-1</InstrumentID>
    <DGLicenceTypeID xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" p3:nil="true" />
    <DateApplicationReceived>2017-07-18T10:02:57.6415053+10:00</DateApplicationReceived>
    <DateApplicationCompleted>2017-07-18T10:02:57.6415053+10:00</DateApplicationCompleted>
    <DriverLicenceDurationID>0</DriverLicenceDurationID>
    <AdminFee>344.00</AdminFee>
    <ConsentForECFlag>true</ConsentForECFlag>
    <Notes />
    <DateCreated>2017-07-18T10:02:57.6415053+10:00</DateCreated>
    <CreatedBySystemUserID>1</CreatedBySystemUserID>
    <LicenceTypeID>1401</LicenceTypeID>
    <LicenceDurationID>1408</LicenceDurationID>
  </TransporterLicence>
  <DGLicenceeFitAndProper>
    <RadiationLicenceFitAndProperID>-1</RadiationLicenceFitAndProperID>
    <InstrumentID>-1</InstrumentID>
    <FitAndProperQuestionID>1</FitAndProperQuestionID>
    <FitAndProperAnswerFlag>true</FitAndProperAnswerFlag>
    <Justification>Everything</Justification>
    <DateCreated>2017-07-18T10:02:57.6415053+10:00</DateCreated>
    <CreatedBySystemUserID>1</CreatedBySystemUserID>
    <Action>I</Action>
    <DGLicenceeFitAndProperID>0</DGLicenceeFitAndProperID>
  </DGLicenceeFitAndProper>
  <DGLicenceeFitAndProper>
    <RadiationLicenceFitAndProperID>-1</RadiationLicenceFitAndProperID>
    <InstrumentID>-1</InstrumentID>
    <FitAndProperQuestionID>2</FitAndProperQuestionID>
    <FitAndProperAnswerFlag>true</FitAndProperAnswerFlag>
    <Justification>Everything</Justification>
    <DateCreated>2017-07-18T10:02:57.6415053+10:00</DateCreated>
    <CreatedBySystemUserID>1</CreatedBySystemUserID>
    <Action>I</Action>
    <DGLicenceeFitAndProperID>0</DGLicenceeFitAndProperID>
  </DGLicenceeFitAndProper>
  <DGLicenceeFitAndProper>
    <RadiationLicenceFitAndProperID>-1</RadiationLicenceFitAndProperID>
    <InstrumentID>-1</InstrumentID>
    <FitAndProperQuestionID>3</FitAndProperQuestionID>
    <FitAndProperAnswerFlag>true</FitAndProperAnswerFlag>
    <Justification>Everything</Justification>
    <DateCreated>2017-07-18T10:02:57.6415053+10:00</DateCreated>
    <CreatedBySystemUserID>1</CreatedBySystemUserID>
    <Action>I</Action>
    <DGLicenceeFitAndProperID>0</DGLicenceeFitAndProperID>
  </DGLicenceeFitAndProper>
  <DGLicenceeFitAndProper>
    <RadiationLicenceFitAndProperID>-1</RadiationLicenceFitAndProperID>
    <InstrumentID>-1</InstrumentID>
    <FitAndProperQuestionID>4</FitAndProperQuestionID>
    <FitAndProperAnswerFlag>true</FitAndProperAnswerFlag>
    <Justification>Everything</Justification>
    <DateCreated>2017-07-18T10:02:57.6415053+10:00</DateCreated>
    <CreatedBySystemUserID>1</CreatedBySystemUserID>
    <Action>I</Action>
    <DGLicenceeFitAndProperID>0</DGLicenceeFitAndProperID>
  </DGLicenceeFitAndProper>
  <DGLicenceeFitAndProper>
    <RadiationLicenceFitAndProperID>-1</RadiationLicenceFitAndProperID>
    <InstrumentID>-1</InstrumentID>
    <FitAndProperQuestionID>5</FitAndProperQuestionID>
    <FitAndProperAnswerFlag>true</FitAndProperAnswerFlag>
    <Justification>Everything</Justification>
    <DateCreated>2017-07-18T10:02:57.6415053+10:00</DateCreated>
    <CreatedBySystemUserID>1</CreatedBySystemUserID>
    <Action>I</Action>
    <DGLicenceeFitAndProperID>0</DGLicenceeFitAndProperID>
  </DGLicenceeFitAndProper>
  <DGLicenceeFitAndProper>
    <RadiationLicenceFitAndProperID>-1</RadiationLicenceFitAndProperID>
    <InstrumentID>-1</InstrumentID>
    <FitAndProperQuestionID>6</FitAndProperQuestionID>
    <FitAndProperAnswerFlag>true</FitAndProperAnswerFlag>
    <Justification>Everything</Justification>
    <DateCreated>2017-07-18T10:02:57.6415053+10:00</DateCreated>
    <CreatedBySystemUserID>1</CreatedBySystemUserID>
    <Action>I</Action>
    <DGLicenceeFitAndProperID>0</DGLicenceeFitAndProperID>
  </DGLicenceeFitAndProper>
  <Instrument>
    <InstrumentID>-1</InstrumentID>
    <InstrumentTypeID>1417</InstrumentTypeID>
    <InstrumentStatusID>751</InstrumentStatusID>
    <ResponsibleSystemUserID>1</ResponsibleSystemUserID>
    <CreatedBySystemUserID>1</CreatedBySystemUserID>
  </Instrument>
  <AccountableParty>
    <InstrumentAccountablePartyID>-1</InstrumentAccountablePartyID>
    <InstrumentID>-1</InstrumentID>
    <AccountablePartyID>-1</AccountablePartyID>
    <DateCreated>2017-07-18T10:02:57.6425053+10:00</DateCreated>
    <CreatedBySystemUserID>1</CreatedBySystemUserID>
    <Action>I</Action>
  </AccountableParty>
  <Contact>
    <InstrumentContactID>-1</InstrumentContactID>
    <InstrumentID>-1</InstrumentID>
    <ContactID>-1</ContactID>
    <PostalContactFlag>true</PostalContactFlag>
    <EmailContactFlag>false</EmailContactFlag>
    <DateCreated>2017-07-18T10:02:57.6425053+10:00</DateCreated>
    <CreatedBySystemUserID>1</CreatedBySystemUserID>
    <Action>I</Action>
  </Contact>
  <Applicant>
    <LicenceHolderType>0</LicenceHolderType>
    <BirthDate>0001-01-01T00:00:00</BirthDate>
    <IsOverseasAddr>false</IsOverseasAddr>
    <TitleId>551</TitleId>
    <GivenName>Erik</GivenName>
    <MiddleName />
    <Surname>Fred</Surname>
    <IsAddressValidationRequred>true</IsAddressValidationRequred>
    <Unit />
    <StreetNo />
    <StreetName>PO BOX 11</StreetName>
    <Suburb>HURSTVILLE</Suburb>
    <State>NSW</State>
    <Postcode>2220</Postcode>
    <Phone />
    <Email />
    <Fax />
  </Applicant>
  <Application>
    <HasPreviousLicence>false</HasPreviousLicence>
    <InstrumentID xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" p3:nil="true" />
    <OnlineTLApplicationID>1710</OnlineTLApplicationID>
  </Application>
  <DGLicenceVehicle>
    <VehicleID>0</VehicleID>
    <TransportWasteFlag>true</TransportWasteFlag>
    <TransportDGFlag>true</TransportDGFlag>
    <TransportTypeId>1406</TransportTypeId>
    <VehicleTypeID>862</VehicleTypeID>
    <RegistrationNumber>gdh247</RegistrationNumber>
    <RegistrationState>NSW</RegistrationState>
    <FleetNumber />
    <CoveredInsuranceFlag>true</CoveredInsuranceFlag>
    <DGLicenceVehicleID>0</DGLicenceVehicleID>
    <InstrumentID>-1</InstrumentID>
    <DGVehicleID>1</DGVehicleID>
    <Action>I</Action>
    <TankerTypeID>866</TankerTypeID>
    <VehicleMakeID>0</VehicleMakeID>
    <NotListedVehicleMake />
    <TankerMakeID>8</TankerMakeID>
    <NotListedTankerMake />
    <TankerYear>2016</TankerYear>
    <VacuumTankerFlag>true</VacuumTankerFlag>
    <DesignApprovalRegisteredFlag>false</DesignApprovalRegisteredFlag>
    <Capacity>500</Capacity>
    <DateLastHydraulicTest>0001-01-01T00:00:00</DateLastHydraulicTest>
    <StabilityControlFlag>true</StabilityControlFlag>
    <NumberofCompartments>1</NumberofCompartments>
    <GoodsClasses>879/878/877</GoodsClasses>
    <GoodsUNs>1006/1008/1007</GoodsUNs>
    <VariationPendingFlag>false</VariationPendingFlag>
    <DateCreated>2017-07-18T10:02:57.6395053+10:00</DateCreated>
    <EffectiveDateFrom>2017-07-18T10:02:57.6395053+10:00</EffectiveDateFrom>
    <CreatedBySystemUserID>1</CreatedBySystemUserID>
    <VINNumber>1111111111</VINNumber>
  </DGLicenceVehicle>
  <DGLicenceVehicle>
    <VehicleID>0</VehicleID>
    <TransportWasteFlag>true</TransportWasteFlag>
    <TransportDGFlag>true</TransportDGFlag>
    <TransportTypeId>1406</TransportTypeId>
    <VehicleTypeID>862</VehicleTypeID>
    <RegistrationNumber>ggg886</RegistrationNumber>
    <RegistrationState>NSW</RegistrationState>
    <FleetNumber />
    <CoveredInsuranceFlag>true</CoveredInsuranceFlag>
    <DGLicenceVehicleID>0</DGLicenceVehicleID>
    <InstrumentID>-1</InstrumentID>
    <DGVehicleID>2</DGVehicleID>
    <Action>I</Action>
    <TankerTypeID>864</TankerTypeID>
    <VehicleMakeID>0</VehicleMakeID>
    <NotListedVehicleMake />
    <TankerMakeID>69</TankerMakeID>
    <NotListedTankerMake />
    <TankerYear>2016</TankerYear>
    <VacuumTankerFlag>true</VacuumTankerFlag>
    <DesignApprovalRegisteredFlag>false</DesignApprovalRegisteredFlag>
    <Capacity>600</Capacity>
    <DateLastHydraulicTest>0001-01-01T00:00:00</DateLastHydraulicTest>
    <StabilityControlFlag>true</StabilityControlFlag>
    <NumberofCompartments>4</NumberofCompartments>
    <GoodsClasses>868/869/870/871/872</GoodsClasses>
    <GoodsUNs>1000/1001/1002/1003/1004</GoodsUNs>
    <VariationPendingFlag>false</VariationPendingFlag>
    <DateCreated>2017-07-18T10:02:57.6405053+10:00</DateCreated>
    <EffectiveDateFrom>2017-07-18T10:02:57.6405053+10:00</EffectiveDateFrom>
    <CreatedBySystemUserID>1</CreatedBySystemUserID>
    <VINNumber>356356356</VINNumber>
  </DGLicenceVehicle>
  <TransporterLocation>
    <Address>43 Bridge St</Address>
    <Suburb>HURSTVILLE</Suburb>
    <State>NSW</State>
    <Postcode>2220</Postcode>
    <InstrumentTransporterLocationID>0</InstrumentTransporterLocationID>
    <InstrumentID>-1</InstrumentID>
    <TransporterLocationID>0</TransporterLocationID>
    <LocationName />
    <Action>I</Action>
    <IsRiskZone>false</IsRiskZone>
    <AdditionalAddressInformation />
    <DateCreated>2017-07-18T10:02:57.6405053+10:00</DateCreated>
    <CreatedBySystemUserID>1</CreatedBySystemUserID>
  </TransporterLocation>
</NewDataSet>
				
				'
    DECLARE @CreatedBySystemUserID int = 1399

	DECLARE @tblDGLicenceVehicle tblDGLicenceVehicleType

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


				DECLARE @tblDGVehicle tblDGVehicleType
				DECLARE @NewDGVehicleID int

				INSERT INTO @tblDGVehicle(
							  [DGVehicleID]
							  ,[VehicleTypeID]
							  ,[RegistrationNumber]
							  ,[VINNumber]
							  ,[RegistrationState]
							  ,[VehicleMake]
							  ,[VehicleYear]
							  ,[FleetNumber]
							  ,[TransportWasteFlag]
							  ,[VacuumTankerFlag]
							  ,[CoveredInsuranceFlag]
							  ,[PhotograghAttachedFlag]
							  ,[TankerTypeID]
							  ,[Capacity]
							  ,[TankMake]
							  ,[TankYear]
							  ,[TankSerialNumber]
							  ,[DesignApprovalNo]
							  --,[DateLastHydraulicTest]
							  ,[StabilityControlFlag]
							  ,[Comments]
							  ,[IsVehicleManufacturedAfter01July2014Flag]
							  ,[ProhibitedVehiclesFlag]
							  ,[DateCreated]
							  ,[CreatedBySystemUserID]
							  ,[DateUpdated]
							  ,[UpdatedBySystemUserID]
							  ,[DGVehicleMakeID]
							  ,[DGTankMakeID]
							  ,[DesignApprovalRegisteredFlag]
							  ,[DesignApprovalState]
							  ,[VehicleValidatedFlag]
							  ,[EPATankOnlyCheckFlag]
							  ,[EPATankOnlyCheckNote]
							  ,[TransportDGFlag]
							  --,[UploadDocument]
							  --,[UploadDocumentName]
							  ,[PayloadTypeID]
							    ,[UNNumber]
								,[Class]
							)
				SELECT   RN.S.value('DGVehicleID[1]','int') AS DGVehicleID,
						 RN.S.value('VehicleTypeID[1]','int') AS VehicleTypeID,
						 RN.S.value('RegistrationNumber[1]','varchar(10)') AS RegistrationNumber,
						 RN.S.value('VINNumber[1]','varchar(20)') AS VINNumber,	
						 RN.S.value('RegistrationState[1]','varchar(3)') AS RegistrationState,
						 RN.S.value('VehicleMake[1]','varchar(50)') AS VehicleMake,
						 RN.S.value('VehicleYear[1]','varchar(4)') AS VehicleYear,
						 RN.S.value('FleetNumber[1]','varchar(20)') AS FleetNumber,	
						 RN.S.value('TransportWasteFlag[1]','bit')  AS TransportWasteFlag,
						 RN.S.value('VacuumTankerFlag[1]','bit') AS VacuumTankerFlag,
						 RN.S.value('CoveredInsuranceFlag[1]','bit') AS CoveredInsuranceFlag,
						 RN.S.value('PhotograghAttachedFlag[1]','bit') AS PhotograghAttachedFlag,
						 RN.S.value('TankerTypeID[1]','smallint') AS TankerTypeID,
						 RN.S.value('Capacity[1]','int') AS Capacity,
						 RN.S.value('TankMake[1]','varchar(50)') AS TankMake,
						 RN.S.value('TankYear[1]','varchar(4)') AS TankYear,
						 RN.S.value('TankSerialNumber[1]','varchar(50)') AS TankSerialNumber,
						 RN.S.value('DesignApprovalNo[1]','varchar(50)') AS DesignApprovalNo,
						 --RN.S.value('DateLastHydraulicTest[1]','datetime') AS DateLastHydraulicTest,
						 --RN.S.value('UNNumber[1]','varchar(50)') AS UNNumber,
						 RN.S.value('StabilityControlFlag[1]','bit') AS StabilityControlFlag,
						 RN.S.value('Comments[1]','varchar(600)') AS Comments,
						 RN.S.value('IsVehicleManufacturedAfter01July2014Flag[1]','bit') AS IsVehicleManufacturedAfter01July2014Flag,
						 RN.S.value('ProhibitedVehiclesFlag[1]','bit') AS ProhibitedVehiclesFlag,
						 GETDATE(),
						 1 AS CreatedBySystemUserID,
						 GETDATE(),
						 1 AS UpdatedBySystemUserID,
						 RN.S.value('DGVehicleMakeID[1]','int') AS DGVehicleMakeID,
						 RN.S.value('DGTankMakeID[1]','int') AS DGTankMakeID,			
						 RN.S.value('DesignApprovalRegisteredFlag[1]','bit') AS DesignApprovalRegisteredFlag,
						 RN.S.value('DesignApprovalState[1]','varchar(3)') AS DesignApprovalState,
						 RN.S.value('VehicleValidatedFlag[1]','bit') AS VehicleValidatedFlag,
						 RN.S.value('EPATankOnlyCheckFlag[1]','bit') AS EPATankOnlyCheckFlag,
						 RN.S.value('EPATankOnlyCheckNote[1]','varchar(1000)') AS EPATankOnlyCheckNote,
						 RN.S.value('TransportDGFlag[1]','bit') AS TransportDGFlag,
						 RN.S.value('TransportTypeId[1]','int') AS PayloadTypeID,
						 RN.S.value('GoodsUNs[1]','varchar(500)') AS UNNumber,
						 RN.S.value('GoodsClasses[1]','varchar(500)') AS Classes
						 --RN.S.value('UploadDocument[1]','varbinary(max)') AS UploadDocument,
						 --RN.S.value('UploadDocumentName[1]','varchar(128)') AS UploadDocumentName
			   FROM @theXmlData.nodes('/NewDataSet/DGLicenceVehicle') AS RN(S)

select * from @tblDGVehicle
select * from @tblDGLicenceVehicle

---- start looping ---
			declare @VehicleTableTrans table
			(
			SNo int IDENTITY(1,1), 
			DGVehicleID int,
			VehicleTypeID int,
			RegistrationNumber varchar(30)
			)
			insert into @VehicleTableTrans(DGVehicleID, VehicleTypeID, RegistrationNumber)
			select A.DGVehicleID, A.VehicleTypeID, A.RegistrationNumber from @tblDGVehicle A  

			declare @DGVehicleIDTrans int
			declare @VehicleTypeIDTrans int
			declare @RegistrationNumberTrans varchar(30)

			declare @CntTrans int
			select @CntTrans = MIN(Sno) FROM @VehicleTableTrans

			while (1=1)
			begin
                set @VehicleTypeIDTrans = 0

				select @DGVehicleIDTrans = DGVehicleID, @VehicleTypeIDTrans = VehicleTypeID, @RegistrationNumberTrans = RegistrationNumber from @VehicleTableTrans
				where SNo = @CntTrans
	    
				if @@rowcount = 0
				break

				
				print '@DGVehicleIDTrans=' + cast(@DGVehicleIDTrans as varchar)
				print '@VehicleTypeIDTrans=' + cast(@VehicleTypeIDTrans as varchar)

				--====================================================================================================
				--we check to avoid insert duplicated vehicle into table tblDGVehicle
				if not exists(select * from tblDGVehicle where VehicleTypeID = @VehicleTypeIDTrans and RegistrationNumber = @RegistrationNumberTrans)
				begin
                    INSERT INTO tblDGVehicle(
						 [VehicleTypeID]
						,[RegistrationNumber]
						,[VINNumber]
						,[RegistrationState]
						,[VehicleMake]
						,[VehicleYear]
						,[FleetNumber]
						,[TransportWasteFlag]
						,[VacuumTankerFlag]
						,[CoveredInsuranceFlag]
						,[PhotograghAttachedFlag]
						,[TankerTypeID]
						,[Capacity]
						,[TankMake]
						,[TankYear]
						,[TankSerialNumber]
						,[DesignApprovalNo]
						,[DateLastHydraulicTest]
						,[UNNumber]
						,[StabilityControlFlag]
						,[Comments]
						,[IsVehicleManufacturedAfter01July2014Flag]
						,[ProhibitedVehiclesFlag]
						,[DateCreated]
						,[CreatedBySystemUserID]
						,[DateUpdated]
						,[UpdatedBySystemUserID]
						,[DGVehicleMakeID]
						,[DGTankMakeID]
						,[DesignApprovalRegisteredFlag]
						,[DesignApprovalState]
						--,[VehicleValidatedFlag]
						,[EPATankOnlyCheckFlag]
						,[EPATankOnlyCheckNote]
						,[TransportDGFlag]
						,[PayloadTypeID]
						--,[UploadDocument]
						--,[UploadDocumentName]
						)
					Select		  [VehicleTypeID]
								  ,[RegistrationNumber]
								  ,[VINNumber]
								  ,[RegistrationState]
								  ,[VehicleMake]
								  ,[VehicleYear]
								  ,[FleetNumber]
								  ,[TransportWasteFlag]
								  ,[VacuumTankerFlag]
								  ,[CoveredInsuranceFlag]
								  ,[PhotograghAttachedFlag]
								  ,[TankerTypeID]
								  ,[Capacity]
								  ,[TankMake]
								  ,[TankYear]
								  ,[TankSerialNumber]
								  ,[DesignApprovalNo]
								  ,[DateLastHydraulicTest]
								  ,[UNNumber]
								  ,[StabilityControlFlag]
								  ,[Comments]
								  ,[IsVehicleManufacturedAfter01July2014Flag]
								  ,[ProhibitedVehiclesFlag]
								  ,[DateCreated]
								  ,[CreatedBySystemUserID]
								  ,[DateUpdated]
								  ,[UpdatedBySystemUserID]
								  ,[DGVehicleMakeID]
								  ,[DGTankMakeID]
								  ,[DesignApprovalRegisteredFlag]
								  ,[DesignApprovalState]
								  --For vehicles with DesignApprovalRegisteredFlag = False, the vehicle is saved and tblDGVehicle.VehicleValidatedFlag is set equal to False
								  --,case [DesignApprovalRegisteredFlag] when 0 then 0 else [VehicleValidatedFlag] end
								  ,[EPATankOnlyCheckFlag]
								  ,[EPATankOnlyCheckNote]
								  ,(case PayloadTypeID when 1404 then 0 else 1 end) as [TransportDGFlag]
								  ,[PayloadTypeID]
								  --,[UploadDocument]
								  --,[UploadDocumentName]
					From @tblDGVehicle
					WHERE DGVehicleID = @DGVehicleIDTrans

					select @NewDGVehicleID = @@IDENTITY

					update @tblDGLicenceVehicle
					set DGVehicleID = @NewDGVehicleID
					where DGVehicleID = @DGVehicleIDTrans

					DECLARE @VehicleTypeID INT
					DECLARE @UNNumber VARCHAR(500) = ''
					DECLARE @Class VARCHAR(500) = ''

					SELECT  @VehicleTypeID =VehicleTypeID,
							@UNNumber = UNNumber,
							@Class = Class
					FROM @tblDGVehicle
					WHERE DGVehicleID = @DGVehicleIDTrans

					IF @VehicleTypeID = 862 -------------tanker
					BEGIN
							
					    Declare @tbHoldingRows Table 
						(
							SNo int IDENTITY(1,1), 
							ID varchar(10)							
						)

						IF @UNNumber <> ''
						BEGIN
							insert into @tbHoldingRows
							SELECT piece FROM [dbo].[ufnGetSplit](@UNNumber, '/')
						END

						IF @Class <> ''
						BEGIN
							insert into @tbHoldingRows
							SELECT piece FROM [dbo].[ufnGetSplit](@Class, '/')
						END

						SELECT * FROM @tbHoldingRows
						DECLARE @Cntun INTEGER
						DECLARE @UN VARCHAR(10)
						SELECT @Cntun = MIN(SNo) FROM @tbHoldingRows

						WHILE (1=1)
						BEGIN
							SELECT @UN = ID
							FROM @tbHoldingRows
							WHERE SNo = @Cntun

							IF @@ROWCOUNT = 0
							BREAK

							if @UNNumber <> ''
							BEGIN
								INSERT INTO tblDGVehicleClass(
									   [DGVehicleID]
									  ,[VehicleClassID]
									  ,[UNNumber]
									  ,[UNNumberID]
									  ,[DateCreated]
									  ,[CreatedBySystemUserID]
									  ,[DateUpdated]
									  ,[UpdatedBySystemUserID])
								SELECT 			 @NewDGVehicleID,
												 -1,
												 (select Description from tblclassification where ClassificationID = @UN) as UNNumber,
												 @UN,
												 GetDate(),
												 @CreatedBySystemUserID,
												 GetDate(),
												 @CreatedBySystemUserID
							END
							
							if @Class <> ''
							BEGIN
								INSERT INTO tblDGVehicleClass(
									   [DGVehicleID]
									  ,[VehicleClassID]
									  ,[UNNumber]
									  ,[UNNumberID]
									  ,[DateCreated]
									  ,[CreatedBySystemUserID]
									  ,[DateUpdated]
									  ,[UpdatedBySystemUserID])
								SELECT 			 @NewDGVehicleID,
												 @UN,
												 NULL,
												 NULL,
												 GetDate(),
												 @CreatedBySystemUserID,
												 GetDate(),
												 @CreatedBySystemUserID
							END


							SELECT @Cntun = @Cntun + 1
						END
					END
				end --end of if not exists(select * from tblDGVehicle above
				--====================================================================================================


				select @CntTrans = @CntTrans + 1	
				
			 end --end of while (1=1)
---- end looping -----

select * from @tblDGLicenceVehicle