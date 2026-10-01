declare @xmlString XML
set @xmlString =
'
<Site>
  <TabID>0</TabID>
  <Id>3108</Id>
  <isCLM>true</isCLM>
  <isUPSS>false</isUPSS>
  <isAudit>true</isAudit>
  <isAllowGeometryAutoUpdate>false</isAllowGeometryAutoUpdate>
  <SiteAddress>
    <AddressId>0</AddressId>
    <StreetAddress>161 Maybe</StreetAddress>
    <StreetType>174</StreetType>
    <Suburb>
      <SuburbId>0</SuburbId>
      <Name>BOMBALA</Name>
      <Postcode>2632</Postcode>
      <State>NSW</State>
    </Suburb>
  </SiteAddress>
  <LotDps>
    <SiteLot>
      <SiteLot_Id>9513</SiteLot_Id>
      <Site_Id>3108</Site_Id>
      <_Lot>
        <Lot_Id>9022</Lot_Id>
        <Plan_Type>DP</Plan_Type>
        <_Lot>1</_Lot>
        <DP>795095</DP>
        <isRegulated>false</isRegulated>
        <isPart>false</isPart>
        <Section />
      </_Lot>
      <UpdatedByUserID>0</UpdatedByUserID>
    </SiteLot>
    <SiteLot>
      <SiteLot_Id>0</SiteLot_Id>
      <Site_Id>3108</Site_Id>
      <_Lot>
        <Lot_Id>0</Lot_Id>
        <Plan_Type>DP</Plan_Type>
        <_Lot>2</_Lot>
        <DP>505616</DP>
        <isRegulated>false</isRegulated>
        <isPart>false</isPart>
        <Section />
      </_Lot>
      <UpdatedByUserID>0</UpdatedByUserID>
    </SiteLot>
  </LotDps>
  <isSiteLotUpdated>true</isSiteLotUpdated>
  <SiteName>Caltex Service Station</SiteName>
  <SiteComment>world records</SiteComment>
  <CreatedBySystemUserID>79</CreatedBySystemUserID>
  <ModifiedBySystemUserID>79</ModifiedBySystemUserID>
  <ConsiteOfficer_Id>37</ConsiteOfficer_Id>
  <Notifications>
    <Notification>
      <Id>521</Id>
      <Old_NotifId>0</Old_NotifId>
      <Site_Id>3108</Site_Id>
      <isNotifierOwner>false</isNotifierOwner>
      <isNotifierPolluter>true</isNotifierPolluter>
      <ContactID>8702</ContactID>
      <CompanyName>Caltex Australia Petroleum Pty Ltd</CompanyName>
      <Name>Paul Seage</Name>
      <Position />
      <Phone>0292505638</Phone>
      <Email />
      <AddressID p4:nil="true" xmlns:p4="http://www.w3.org/2001/XMLSchema-instance" />
      <StreetAddress>2 Market </StreetAddress>
      <StreetType>174</StreetType>
      <SuburbID p4:nil="true" xmlns:p4="http://www.w3.org/2001/XMLSchema-instance" />
      <Suburb>SYDNEY</Suburb>
      <State>NSW</State>
      <Postcode>2000</Postcode>
      <Notified>2010-01-14T00:00:00</Notified>
      <UnderS60>false</UnderS60>
      <NotificationTrimNo>DOC10/4618</NotificationTrimNo>
      <isAirAffected>false</isAirAffected>
      <isAffectedGroundwater>false</isAffectedGroundwater>
      <isAffectedSurfaceWater>false</isAffectedSurfaceWater>
      <isAffectedSediment>false</isAffectedSediment>
      <isAffectedSoil>false</isAffectedSoil>
      <isAffectedStormwater>false</isAffectedStormwater>
      <isAffectedDrinkingWater>false</isAffectedDrinkingWater>
      <isAffectedWetlands>false</isAffectedWetlands>
      <isAffectedOther>false</isAffectedOther>
      <isAtRiskResidents>false</isAtRiskResidents>
      <isAtRiskWorkers>false</isAtRiskWorkers>
      <isAtRiskSchool>false</isAtRiskSchool>
      <isAtRiskThreatSpecies>false</isAtRiskThreatSpecies>
      <isAtRiskAquatic>false</isAtRiskAquatic>
      <isAtRiskPlants>false</isAtRiskPlants>
      <isAtRiskAnimals>false</isAtRiskAnimals>
      <isAtRiskOther>false</isAtRiskOther>
      <CreatedBySystemUserID p4:nil="true" xmlns:p4="http://www.w3.org/2001/XMLSchema-instance" />
      <ModifiedBySystemUserID p4:nil="true" xmlns:p4="http://www.w3.org/2001/XMLSchema-instance" />
      <Created p4:nil="true" xmlns:p4="http://www.w3.org/2001/XMLSchema-instance" />
      <Modified p4:nil="true" xmlns:p4="http://www.w3.org/2001/XMLSchema-instance" />
    </Notification>
  </Notifications>
  <ContamActivity_Id>8</ContamActivity_Id>
  <SiteTankInformation />
  <UnderAssessment>true</UnderAssessment>
  <RegNotRequired>false</RegNotRequired>
  <RegBeingFinalised>false</RegBeingFinalised>
  <CurrentCLM>false</CurrentCLM>
  <CurrentPOEO>false</CurrentPOEO>
  <CurrentPlanningPro>false</CurrentPlanningPro>
  <FormerCLM>false</FormerCLM>
  <FormerPOEO>false</FormerPOEO>
  <FormerPlanningPro>false</FormerPlanningPro>
  <OngoingMaintenance>false</OngoingMaintenance>
  <SiteActions />
  <Exemptions />
  <isExemptionUpdated p2:nil="true" xmlns:p2="http://www.w3.org/2001/XMLSchema-instance" />
  <isOwnerWithheld>false</isOwnerWithheld>
  <isOccupierWithheld>false</isOccupierWithheld>
</Site>
'

SET NOCOUNT ON;

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @ErrorMessage varchar(2000)

	DECLARE @SiteTable AS tblSite
	DECLARE @SiteOwner as tblContact
	DECLARE @SitePolluter as tblContact
	DECLARE @SiteOccupier as tblContact
	DECLARE @PersonResponsible as tblContact
	DECLARE @SiteAddress as tblAddress
	DECLARE @SiteSuburb as tblSuburb
	DECLARE @LotDP as tblLot
	DECLARE @SiteTank as tblSiteTank
	DECLARE @Chemical as tblChemical
	DECLARE @Notification as tblNotification
	DECLARE @SiteAction as table(
				[Id] int,
				[Site_Id] int,
				[ActionDate] date,
				[DueDate] datetime,
				[TrimNo] varchar(20),
				[Completed] date,
				[ActionType_Id] int,
				[Descript] varchar(max),
				[CreatedBySystemUserID]int,
				[ModifiedBySystemUserID] int,
				[IsDeleted] int
			)
	DECLARE @Exemption AS tblExemption
	DECLARE @UserID AS INT

	DECLARE @isSiteLotUpdated AS BIT,
			@isSiteTankInfoUpdated AS BIT,
			@isContaminantListUpdated AS BIT,
			@isNotificationUpdated AS BIT,
			@isSiteActionUpdated AS BIT,
			@TabID AS INT
	
	DECLARE @isSiteOwnerWithheld AS BIT
	DECLARE @isSiteOccupierWithheld AS BIT
	
	BEGIN TRY

	--BEGIN TRANSACTION

	DECLARE @SiteID AS INT, @IsCLM AS BIT = 0, @IsUPSS AS BIT = 0, @IsAudit AS BIT = 0, @isAllowGeometryAutoUpdate AS BIT = 1
	
	SELECT
		@SiteID = XD.SiteData.value('Id[1]','int'),
		@IsCLM = XD.SiteData.value('isCLM[1]','bit'),
		@IsUPSS = XD.SiteData.value('isUPSS[1]','bit'),
		@IsAudit = XD.SiteData.value('isAudit[1]','bit'),
		@isSiteOwnerWithheld = XD.SiteData.value('isOwnerWithheld[1]','bit'),
		@isSiteOccupierWithheld = XD.SiteData.value('isOccupierWithheld[1]','bit'),
		@TabID = XD.SiteData.value('TabID[1]','INT'),
		@UserID = XD.SiteData.value('ModifiedBySystemUserID[1]','int'),
		@isAllowGeometryAutoUpdate = XD.SiteData.value('isAllowGeometryAutoUpdate[1]','bit')
	FROM @xmlString.nodes('/Site') AS XD(SiteData) 

	print '@TabID =' + cast(@TabID as varchar)
	

	IF(@SiteID = NULL OR @SiteID <= 0)
		BEGIN
			return;
		END
	
	--if not exists(select systemuserid from tblsystemuser where systemuserid = @UserID) begin set @UserID = 1 end

	--UPDATE S SET
	--	isCLM = @IsCLM,
	--	isUPSS = @IsUPSS,
	--	isAudit = @IsAudit,
	--	isSiteOwnerWithheld = @isSiteOwnerWithheld,
	--	isSiteOccupierWithheld = @isSiteOccupierWithheld,
	--	Modified = GETDATE(),
	--	ModifiedBySystemUserID = @UserID,
	--	isAllowGeometryAutoUpdate = @isAllowGeometryAutoUpdate
	--FROM tblSite S
	--where S.Id = @SiteID

	--IF(@isCLM = 0)
	--	BEGIN
	--		-- Delete any previously entered Site Polluter
	--		--DELETE FROM tblSiteContact WHERE Site_Id = @SiteID AND ContactRole_Id = 4
	--		UPDATE tblSiteContact
	--		SET isDeleted = 1, ModifiedBySystemUserID = @UserID, Modified = GETDATE()
	--		WHERE Site_Id = @SiteID AND ContactRole_Id = 4
			 
	--		--Delete Notifiers
	--		--DELETE FROM tblSiteContact WHERE Site_Id = @SiteID AND ContactRole_Id = 5
	--		UPDATE tblSiteContact
	--		SET isDeleted = 1, ModifiedBySystemUserID = @UserID, Modified = GETDATE()
	--		WHERE Site_Id = @SiteID AND ContactRole_Id = 5

	--		DELETE FROM tblNotification WHERE Site_Id = @SiteID		

	--		--Delete s12 Assessments
	--		delete from tblreportassessment where Assessment_Id in (Select Id from tblAssessment WHERE Site_Id = @SiteID)
	--		DELETE FROM tblAssessment WHERE Site_Id = @SiteID

	--		--Delete management classes
	--		update tblsite
	--			set UnderAssessment = 0, RegNotRequired = 0, 
	--			RegBeingFinalised = 0, CurrentCLM = 0, CurrentPOEO = 0, 
	--			CurrentPlanningPro = 0, FormerCLM = 0, FormerPOEO = 0,FormerPlanningPro = 0, OngoingMaintenance = 0
	--		where id = @SiteID

	--		--delete contaminated site activity
	--		update tblsite
	--			set ContamActivity_Id = null
	--		where id = @SiteID
	--	END

	--IF(@IsUPSS = 0) 
	--	BEGIN		
	--		--Delete any previously entered exemptions
	--		DELETE FROM tblExemption WHERE Site_Id = @SiteID

	--		--Delete any previously entered person responsible
	--		--DELETE FROM tblSiteContact WHERE Site_Id = @SiteID AND ContactRole_Id = 1				
	--		UPDATE tblSiteContact
	--		SET isDeleted = 1, ModifiedBySystemUserID = @UserID, Modified = GETDATE()
	--		WHERE Site_Id = @SiteID AND ContactRole_Id = 1

	--		--Delete any previously entered site info
	--		DELETE FROM tblSiteTank WHERE Site_Id = @SiteID
	--	END

	--IF @TabID != 4 AND @TabID != 5
	--	BEGIN
	--		INSERT INTO @SiteTable 
	--		(Id, isCLM, isUPSS, isAudit, SiteName, SiteComment, EPARegionalContact, EPALicenceNo, 
	--		DangerousGoodsNo, ConsiteOfficer_Id, AreaNo, TrimNo, TankStatus_Id, DataSource_Id,
	--		SiteType_Id, ContamActivity_Id, ContamActivityDesc_Id, UnderAssessment,
	--		RegNotRequired, RegBeingFinalised, CurrentCLM, CurrentPOEO, CurrentPlanningPro, FormerCLM, FormerPOEO, FormerPlanningPro, OngoingMaintenance, isAllowGeometryAutoUpdate)
	--		SELECT  
	--			XD.SiteData.value('Id[1]','int'),
	--			XD.SiteData.value('isCLM[1]','bit'),
	--			XD.SiteData.value('isUPSS[1]','bit'),
	--			XD.SiteData.value('isAudit[1]','bit'),				
	--			XD.SiteData.value('SiteName[1]','varchar(510)'),
	--			XD.SiteData.value('SiteComment[1]','varchar(500)'),			
	--			XD.SiteData.value('EPARegionalContact[1]','varchar(100)'),
	--			XD.SiteData.value('EPALicenceNo[1]','varchar(100)'),
	--			XD.SiteData.value('DangerousGoodsNo[1]','varchar(100)'),
	--			XD.SiteData.value('ConsiteOfficer_Id[1]','int'),
	--			XD.SiteData.value('AreaNo[1]','int'),
	--			XD.SiteData.value('TrimNo[1]','varchar(100)'),
	--			CASE WHEN @IsUPSS = 1 THEN XD.SiteData.value('TankStatus_Id[1]','int') ELSE NULL END,
	--			CASE WHEN @IsUPSS = 1 THEN XD.SiteData.value('DataSource_Id[1]','int') ELSE NULL END,
	--			CASE WHEN @IsUPSS = 1 THEN XD.SiteData.value('SiteType_Id[1]','int') ELSE NULL END,
	--			CASE WHEN @IsCLM = 1 THEN XD.SiteData.value('ContamActivity_Id[1]','int') ELSE NULL END,
	--			XD.SiteData.value('ContamActivityDesc_Id[1]','int'),
	--			CASE WHEN @IsCLM = 1 THEN XD.SiteData.value('UnderAssessment[1]','bit') ELSE 0 END,
	--			CASE WHEN @IsCLM = 1 THEN XD.SiteData.value('RegNotRequired[1]','bit') ELSE 0 END,
	--			CASE WHEN @IsCLM = 1 THEN XD.SiteData.value('RegBeingFinalised[1]','bit') ELSE 0 END,
	--			CASE WHEN @IsCLM = 1 THEN XD.SiteData.value('CurrentCLM[1]','bit') ELSE 0 END,	
	--			CASE WHEN @IsCLM = 1 THEN XD.SiteData.value('CurrentPOEO[1]','bit') ELSE 0 END,
	--			CASE WHEN @IsCLM = 1 THEN XD.SiteData.value('CurrentPlanningPro[1]','bit') ELSE 0 END,
	--			CASE WHEN @IsCLM = 1 THEN XD.SiteData.value('FormerCLM[1]','bit') ELSE 0 END,	
	--			CASE WHEN @IsCLM = 1 THEN XD.SiteData.value('FormerPOEO[1]','bit') ELSE 0 END,
	--			CASE WHEN @IsCLM = 1 THEN XD.SiteData.value('FormerPlanningPro[1]','bit') ELSE 0 END,
	--			CASE WHEN @IsCLM = 1 THEN XD.SiteData.value('OngoingMaintenance[1]','bit') ELSE 0 END,
	--			XD.SiteData.value('isAllowGeometryAutoUpdate[1]','bit')
	--		FROM @xmlString.nodes('/Site') AS XD(SiteData) 

			SELECT  		
				@isSiteLotUpdated = XD.SiteData.value('isSiteLotUpdated[1]','bit'),
				@isSiteTankInfoUpdated = XD.SiteData.value('isSiteTankInfoUpdated[1]','bit'),
				@isContaminantListUpdated = XD.SiteData.value('isContaminantListUpdated[1]','bit'),
				@isNotificationUpdated = XD.SiteData.value('isNotificationUpdated[1]','bit'),
				@isSiteActionUpdated = XD.SiteData.value('isSiteActionUpdated[1]','bit')
			FROM @xmlString.nodes('/Site') AS XD(SiteData) 

print '@isSiteLotUpdated =' + cast(@isSiteLotUpdated as varchar)

	--		INSERT INTO @SiteOwner
	--		(
	--			Id,
	--			ContactCompany,
	--			Name,
	--			Phone,
	--			Email
	--		)
	--		SELECT  
	--			XD.SiteData.value('SiteOwner_Id[1]','int'),
	--			XD.SiteData.value('ContactCompany[1]','varchar(100)'),
	--			XD.SiteData.value('ContactName[1]','varchar(120)'),
	--			XD.SiteData.value('Phone[1]','varchar(40)'),
	--			XD.SiteData.value('Email[1]','varchar(100)')	
	--		FROM @xmlString.nodes('/Site/_SiteOwner') AS XD(SiteData)
	
	--		IF(@isCLM = 1)
	--			BEGIN
	--				INSERT INTO @SitePolluter
	--				(
	--					Id,
	--					ContactCompany,
	--					Name,
	--					Phone,
	--					Email
	--				)
	--				SELECT  
	--					XD.SiteData.value('SitePolluter_Id[1]','int'),
	--					XD.SiteData.value('ContactCompany[1]','varchar(100)'),
	--					XD.SiteData.value('ContactName[1]','varchar(120)'),
	--					XD.SiteData.value('Phone[1]','varchar(40)'),
	--					XD.SiteData.value('Email[1]','varchar(100)')	
	--				FROM @xmlString.nodes('/Site/_SitePolluter') AS XD(SiteData)
	--			END

	--		INSERT INTO @SiteOccupier
	--		(
	--			Id,
	--			ContactCompany,
	--			Name,
	--			Phone,
	--			Email
	--		)
	--		SELECT  
	--			XD.SiteData.value('SiteOccupier_Id[1]','int'),
	--			XD.SiteData.value('ContactCompany[1]','varchar(100)'),
	--			XD.SiteData.value('ContactName[1]','varchar(120)'),
	--			XD.SiteData.value('Phone[1]','varchar(40)'),
	--			XD.SiteData.value('Email[1]','varchar(100)')	
	--		FROM @xmlString.nodes('/Site/_SiteOccupier') AS XD(SiteData)


	--		INSERT INTO @SiteAddress
	--		(
	--			[Id],
	--			[StreetAddress],
	--			[StreetType],		
	--			[Council_Id],
	--			[Electorate_Id],
	--			[Region_Id]
	--		)
	--		SELECT  
	--			ISNULL(XD.SiteData.value('Id[1]','int'), -1),
	--			XD.SiteData.value('StreetAddress[1]','varchar(100)'),
	--			XD.SiteData.value('StreetType[1]','int'),
	--			XD.SiteData.value('Council_Id[1]','int'),
	--			XD.SiteData.value('Electorate_Id[1]','int'),
	--			XD.SiteData.value('Region_Id[1]','int')
	--		FROM @xmlString.nodes('/Site/SiteAddress') AS XD(SiteData)

	--		INSERT INTO @SiteSuburb
	--		(
	--			[Id],
	--			[Name],
	--			[PostCode],
	--			[State_Abbrev]
	--		)
	--		SELECT 
	--			ISNULL(XD.SiteData.value('SuburbId[1]','int'), -1),
	--			XD.SiteData.value('Name[1]','varchar(80)'),
	--			XD.SiteData.value('Postcode[1]','varchar(4)'),
	--			XD.SiteData.value('State[1]','varchar(10)')		
	--		FROM @xmlString.nodes('/Site/SiteAddress/Suburb') AS XD(SiteData)
		
	--		-- Parse LOT Dps XML data into temporary @LotDP table
			INSERT INTO @LotDP
			(
				[Id],
				[Plan_Type],
				[Lot],		
				[DP],
				[isRegulated],
				[isPart],
				[Section]
			)	
			SELECT
				Id = ISNULL(XD.SiteData.value('Id[1]','int'), -1),
				Plan_Type = LTRIM(RTRIM(XD.SiteData.value('(Plan_Type)[1]', 'varchar(10)'))),
				Lot = LTRIM(RTRIM(XD.SiteData.value('(_Lot)[1]', 'varchar(20)'))),
				DP  = ISNULL(XD.SiteData.value('DP[1]','varchar(40)'), -1),
				isRegulated = XD.SiteData.value('isRegulated[1]','bit'),
				isPart = XD.SiteData.value('isPart[1]','bit'),
				SectionNumber = LTRIM(RTRIM(XD.SiteData.value('(Section)[1]', 'varchar(20)')))
			FROM	
				@xmlString.nodes('/Site/LotDps/SiteLot/_Lot') AS XD(SiteData)
	
select * from @LotDP

	--		IF(@IsUPSS = 1)
	--			BEGIN
	--				-- Parse Site tank information XML data into temporary @@SiteTank table
	--				INSERT INTO @SiteTank
	--				(
	--					[Id],		
	--					[Fuel_Id],
	--					[NoOfTanks]
	--				)
	--				SELECT 
	--					ISNULL(XD.SiteData.value('Id[1]','int'), -1),
	--					XD.SiteData.value('Fuel_Id[1]','int'),
	--					XD.SiteData.value('NoOfTanks[1]','int')
	--				FROM @xmlString.nodes('/Site/SiteTankInformation/SiteTank') AS XD(SiteData)
	--			END

	--		INSERT INTO @Chemical
	--		(
	--			Id,
	--			ChemGroup,
	--			ContamClass_Id
	--		)
	--		SELECT 
	--			ISNULL(XD.SiteData.value('Id[1]','int'), -1),
	--			XD.SiteData.value('ChemGroup[1]','varchar(510)'),
	--			XD.SiteData.value('ContamClass_Id[1]','int')
	--		FROM @xmlString.nodes('/Site/ContaminantList/Chemical') AS XD(SiteData)
	
	--		IF(@IsCLM = 1)
	--			BEGIN
	--				INSERT INTO @Notification
	--				(
	--					Id,
	--					Site_Id,
	--					Notified,
	--					isNotifierTheOwner,
	--					isNotifierThePolluter,
	--					ContactID,
	--					ContactCompany,
	--					Name,
	--					Position,
	--					Phone,
	--					Email,
	--					StreetAddress,
	--					StreetType,
	--					Suburb,
	--					[State],
	--					Postcode,
	--					S60Comment,
	--					UnderS60,
	--					NotificationTrimNo,
	--					ReponseTrimNo,
	--					isAirAffected,
	--					isAffectedGroundwater,
	--					isAffectedSurfaceWater,
	--					isAffectedSediment,
	--					isAffectedSoil,
	--					isAffectedStormwater,
	--					isAffectedDrinkingWater,
	--					isAffectedWetlands,
	--					isAffectedOther,
	--					OtherAffectedSpecify,
	--					isAtRiskAnimals,
	--					isAtRiskOther,
	--					isAtRiskAquatic,
	--					isAtRiskPlants,
	--					isAtRiskResidents,
	--					isAtRiskSchool,
	--					isAtRiskThreatSpecies,
	--					isAtRiskWorkers,
	--					AtRiskOtherSpecify
	--				)
	--				SELECT 
	--					ISNULL(XD.SiteData.value('Id[1]','int'), -1),
	--					ISNULL(XD.SiteData.value('Site_Id[1]','int'), -1),
	--					XD.SiteData.value('Notified[1]','Date'),
	--					XD.SiteData.value('isNotifierOwner[1]','bit'),
	--					XD.SiteData.value('isNotifierPolluter[1]','bit'),
	--					XD.SiteData.value('ContactID[1]','int'),
	--					XD.SiteData.value('CompanyName[1]','varchar(100)'),
	--					XD.SiteData.value('Name[1]','varchar(120)'),
	--					XD.SiteData.value('Position[1]','varchar(100)'),
	--					XD.SiteData.value('Phone[1]','varchar(40)'),
	--					XD.SiteData.value('Email[1]','varchar(100)'),		
	--					XD.SiteData.value('StreetAddress[1]','varchar(100)'),
	--					XD.SiteData.value('StreetType[1]','varchar(10)'),
	--					XD.SiteData.value('Suburb[1]','varchar(100)'),
	--					XD.SiteData.value('State[1]','varchar(10)'),
	--					XD.SiteData.value('Postcode[1]','varchar(4)'),
	--					XD.SiteData.value('S60Comment[1]','varchar(100)'),
	--					XD.SiteData.value('UnderS60[1]','bit'),
	--					XD.SiteData.value('NotificationTrimNo[1]','varchar(15)'),
	--					XD.SiteData.value('ReponseTrimNo[1]','varchar(15)'),
	--					XD.SiteData.value('isAirAffected[1]','bit'),
	--					XD.SiteData.value('isAffectedGroundwater[1]','bit'),
	--					XD.SiteData.value('isAffectedSurfaceWater[1]','bit'),
	--					XD.SiteData.value('isAffectedSediment[1]','bit'),
	--					XD.SiteData.value('isAffectedSoil[1]','bit'),
	--					XD.SiteData.value('isAffectedStormwater[1]','bit'),
	--					XD.SiteData.value('isAffectedDrinkingWater[1]','bit'),
	--					XD.SiteData.value('isAffectedWetlands[1]','bit'),
	--					XD.SiteData.value('isAffectedOther[1]','bit'),
	--					XD.SiteData.value('OtherAffectedSpecify[1]','varchar(50)'),
	--					XD.SiteData.value('isAtRiskAnimals[1]','bit'),
	--					XD.SiteData.value('isAtRiskOther[1]','bit'),
	--					XD.SiteData.value('isAtRiskAquatic[1]','bit'),
	--					XD.SiteData.value('isAtRiskPlants[1]','bit'),
	--					XD.SiteData.value('isAtRiskResidents[1]','bit'),
	--					XD.SiteData.value('isAtRiskSchool[1]','bit'),
	--					XD.SiteData.value('isAtRiskThreatSpecies[1]','bit'),
	--					XD.SiteData.value('isAtRiskWorkers[1]','bit'),
	--					XD.SiteData.value('AtRiskOtherSpecify[1]','varchar(50)')
	--				FROM @xmlString.nodes('/Site/Notifications/Notification') AS XD(SiteData)
	--			END
		

	--		INSERT INTO @SiteAction
	--		(
	--			[Id],
	--			[Site_Id],
	--			[ActionDate],
	--			[DueDate],
	--			[TrimNo],
	--			[Completed],
	--			[ActionType_Id],
	--			[Descript],
	--			[CreatedBySystemUserID],
	--			[ModifiedBySystemUserID],
	--			[IsDeleted]
	--		)
	--		SELECT 
	--			ISNULL(XD.SiteData.value('Id[1]','int'), -1),
	--			ISNULL(XD.SiteData.value('Site_Id[1]','int'), -1),
	--			XD.SiteData.value('ActionDate[1]','Date'),
	--			XD.SiteData.value('DueDate[1]','Date'),
	--			XD.SiteData.value('TrimNo[1]','varchar(20)'),
	--			XD.SiteData.value('DateCompleted[1]','Date'),
	--			XD.SiteData.value('ActionType_Id[1]','int'),
	--			XD.SiteData.value('Descript[1]','varchar(4000)'),
	--			XD.SiteData.value('CreatedBySystemUserID[1]','varchar(256)'),
	--			XD.SiteData.value('ModifiedBySystemUserID[1]','varchar(256)'),
	--			ISNULL(XD.SiteData.value('IsDeleted[1]','int'), 0)
	--		FROM @xmlString.nodes('/Site/SiteActions/SiteAction') AS XD(SiteData)

	--		--Create a record in the site table
	--		UPDATE S
	--			SET
	--				isCLM = ST.isCLM, isUPSS = ST.isUPSS, isAudit = ST.isAudit,
	--				SiteName = ST.SiteName, SiteComment = ST.SiteComment, ConsiteOfficer_Id = ST.ConsiteOfficer_Id,
	--				DangerousGoodsNo = ST.DangerousGoodsNo, ContamActivity_Id = ST.ContamActivity_Id, 
	--				ContamActivityDesc_Id = ST.ContamActivityDesc_Id, TankStatus_Id = ST.TankStatus_Id, 
	--				DataSource_Id = ST.DataSource_Id, SiteType_Id = ST.SiteType_Id, 
	--				EPARegionalContact = ST.EPARegionalContact, EPALicenceNo = ST.EPALicenceNo, 
	--				TrimNo = ST.TrimNo, UnderAssessment = ST.UnderAssessment, RegNotRequired = ST.RegNotRequired, 
	--				RegBeingFinalised = ST.RegBeingFinalised, CurrentCLM = ST.CurrentCLM, CurrentPOEO = ST.CurrentPOEO, 
	--				CurrentPlanningPro = ST.CurrentPlanningPro, FormerCLM = ST.FormerCLM, FormerPOEO = ST.FormerPOEO,FormerPlanningPro = ST.FormerPlanningPro, OngoingMaintenance = ST.OngoingMaintenance, Modified = GETDATE(), ModifiedBySystemUserID = @UserID,
	--				isAllowGeometryAutoUpdate = ST.isAllowGeometryAutoUpdate
	--			FROM tblSite S
	--			INNER JOIN @SiteTable ST ON S.Id = ST.Id

	--		IF(@siteId > 0)
	--			BEGIN
	--			--Add site owner
	--			IF(SELECT COUNT(1) FROM @SiteOwner) > 0
	--				BEGIN						
	--					--Check if site owner exists then update it
	--					IF(EXISTS(SELECT Id FROM tblSiteContact WHERE Site_Id = @SiteID AND ContactRole_Id = 2 AND IsDeleted = 0))
	--						BEGIN
	--							DECLARE @SiteOwnerContact_Id as int
	--							SELECT @SiteOwnerContact_Id = 
	--							Contact_Id FROM tblSiteContact WHERE Id =
	--							(select max(s1.id) from tblSiteContact s1 where 
	--							Site_Id = @SiteID AND ContactRole_Id = 2 AND IsDeleted = 0)
								
	--							update @SiteOwner
	--							set id = @SiteOwnerContact_Id
	--							where id = 0

	--							UPDATE C
	--							SET [ContactCompany] = S.ContactCompany
	--							   ,[Name] = S.Name
	--							   ,[Phone] = S.Phone
	--							   ,[Email] = S.Email
	--							FROM tblContact C INNER JOIN
	--							@SiteOwner S ON C.Id = S.Id

	--							UPDATE tblSiteContact
	--							SET  ModifiedBySystemUserID = @UserID, Modified = GETDATE()
	--							WHERE Id =
	--							(select max(s1.id) from tblSiteContact s1 where 
	--							Site_Id = @SiteID AND ContactRole_Id = 2 AND IsDeleted = 0)
	--						END
	--					ELSE
	--						BEGIN								
	--							DECLARE @SiteOwnerID as int = 0

	--							INSERT INTO tblContact
	--							(
	--								[ContactCompany]
	--							   ,[Name]
	--							   ,[Phone]
	--							   ,[Email]
	--							)
	--							SELECT ContactCompany, Name, Phone, Email FROM @SiteOwner

	--							Select @SiteOwnerID = @@IDENTITY;
								
	--							--Add site owner record in tblSiteContact
	--							IF(@SiteOwnerID > 0)
	--								BEGIN
	--									INSERT INTO tblSiteContact
	--									(
	--									   [Contact_Id]
	--									  ,[Site_Id]
	--									  ,[ContactRole_Id]
	--									  ,[ValidFrom]
	--									  ,[Created]
	--									  ,[CreatedBySystemUserID]
	--									  ,[Modified]
	--									  ,[ModifiedBySystemUserID]
	--									)
	--									SELECT
	--										@SiteOwnerID
	--										,@siteId
	--										,2
	--										,GETDATE()
	--										,GETDATE()
	--										,@UserID
	--										,GETDATE()
	--										,@UserID									
	--								END
	--						END
	--				END
	--			ELSE
	--				BEGIN
	--					--Delete previously entered site owner
	--					--DELETE FROM tblSiteContact WHERE Site_Id = @SiteID AND ContactRole_Id = 2
	--					UPDATE tblSiteContact
	--					SET isDeleted = 1, ModifiedBySystemUserID = @UserID, Modified = GETDATE()
	--					WHERE Site_Id = @SiteID AND ContactRole_Id = 2
	--				END

	--		--Add site polluter
	--		IF(SELECT COUNT(1) FROM @SitePolluter) > 0
	--			BEGIN
	--				--Check if site polluter exists then update it
	--				IF(EXISTS(SELECT Id FROM tblSiteContact WHERE Site_Id = @SiteID AND ContactRole_Id = 4 and IsDeleted = 0))
	--					BEGIN	
	--						DECLARE @SitePolluterContact_Id as int
	--						SELECT @SitePolluterContact_Id = 
	--						Contact_Id FROM tblSiteContact WHERE Id =
	--						(select max(s1.id) from tblSiteContact s1 where 
	--						Site_Id = @SiteID AND ContactRole_Id = 4 AND IsDeleted = 0)
								
	--						update @SitePolluter
	--						set id = @SitePolluterContact_Id
	--						where id = 0		
											
	--						UPDATE C
	--						SET [ContactCompany] = S.ContactCompany
	--						   ,[Name] = S.Name
	--						   ,[Phone] = S.Phone
	--						   ,[Email] = S.Email
	--						FROM tblContact C INNER JOIN
	--						@SitePolluter S ON C.Id = S.Id

	--						UPDATE tblSiteContact
	--						SET  ModifiedBySystemUserID = @UserID, Modified = GETDATE()
	--						WHERE Id =
	--						(select max(s1.id) from tblSiteContact s1 where 
	--						Site_Id = @SiteID AND ContactRole_Id = 4 AND IsDeleted = 0)
	--					END
	--				ELSE
	--					BEGIN
	--						DECLARE @SitePolluterID as int = 0

	--						INSERT INTO tblContact
	--						(
	--							[ContactCompany]
	--						   ,[Name]
	--						   ,[Phone]
	--						   ,[Email]
	--						)
	--						SELECT ContactCompany, Name, Phone, Email FROM @SitePolluter

	--						Select @SitePolluterID = @@IDENTITY;

	--						--Add site polluter record in tblSiteContact
	--						IF(@SitePolluterID > 0)
	--							BEGIN
	--								INSERT INTO tblSiteContact
	--								(
	--								   [Contact_Id]
	--								  ,[Site_Id]
	--								  ,[ContactRole_Id]
	--								  ,[ValidFrom]									  
	--								  ,[CreatedBySystemUserID]
	--								  ,[Created]
	--								  ,[Modified]
	--								  ,[ModifiedBySystemUserID]
	--								)
	--								SELECT
	--									@SitePolluterID
	--									,@SiteID
	--									,4
	--									,GETDATE()
	--									,@UserID
	--									,GETDATE()
	--									,GETDATE()
	--									,@UserID
	--							END
	--				END
	--			END
	--		ELSE
	--			BEGIN
	--				--Delete previously entered site polluter
	--				--DELETE FROM tblSiteContact WHERE Site_Id = @SiteID AND ContactRole_Id = 4

	--				UPDATE tblSiteContact
	--					SET isDeleted = 1, ModifiedBySystemUserID = @UserID, Modified = GETDATE()
	--					WHERE Site_Id = @SiteID AND ContactRole_Id = 4
	--			END

	--		--Add Site Occupier
	--		IF(SELECT COUNT(1) FROM @SiteOccupier) > 0
	--			BEGIN
	--				--Check if site occupier exists then update it
	--				IF(EXISTS(SELECT Id FROM tblSiteContact WHERE Site_Id = @SiteID AND ContactRole_Id = 3 and isDeleted = 0))
	--					BEGIN		
	--						DECLARE @SiteOccupierContact_Id as int
	--						SELECT @SiteOccupierContact_Id = 
	--						Contact_Id FROM tblSiteContact WHERE Id =
	--						(select max(s1.id) from tblSiteContact s1 where 
	--						Site_Id = @SiteID AND ContactRole_Id = 3 AND IsDeleted = 0)
								
	--						update @SiteOccupier
	--						set id = @SiteOccupierContact_Id
	--						where id = 0
												
	--						UPDATE C
	--						SET [ContactCompany] = S.ContactCompany
	--						   ,[Name] = S.Name
	--						   ,[Phone] = S.Phone
	--						   ,[Email] = S.Email
	--						FROM tblContact C INNER JOIN
	--						@SiteOccupier S ON C.Id = S.Id

	--						UPDATE tblSiteContact
	--						SET  ModifiedBySystemUserID = @UserID, Modified = GETDATE()
	--						WHERE Id =
	--						(select max(s1.id) from tblSiteContact s1 where 
	--						Site_Id = @SiteID AND ContactRole_Id = 3 AND IsDeleted = 0)
	--					END
	--				ELSE
	--					BEGIN
	--						DECLARE @SiteOccupierID as int =0

	--						INSERT INTO tblContact
	--						(
	--							[ContactCompany]
	--						   ,[Name]
	--						   ,[Phone]
	--						   ,[Email]
	--						)
	--						SELECT ContactCompany, Name, Phone, Email FROM @SiteOccupier

	--						Select @SiteOccupierID = @@IDENTITY;

	--						--Add site occupier record in tblSiteContact
	--						IF(@SiteOccupierID > 0)
	--							BEGIN
	--								INSERT INTO tblSiteContact
	--								(
	--								   [Contact_Id]
	--								  ,[Site_Id]
	--								  ,[ContactRole_Id]
	--								  ,[ValidFrom]									  
	--								  ,[CreatedBySystemUserID]
	--								  ,[Created]
	--								  ,[Modified]
	--							      ,[ModifiedBySystemUserID]
	--								)
	--								SELECT
	--									@SiteOccupierID
	--									,@siteId
	--									,3
	--									,GETDATE()
	--									,@UserID
	--									,GETDATE()
	--									,GETDATE()
	--									,@UserID
	--							END
	--				END
	--			END
	--		ELSE
	--			BEGIN
	--				--Delete previously entered site occupier
	--				--DELETE FROM tblSiteContact WHERE Site_Id = @SiteID AND ContactRole_Id = 3

	--				UPDATE tblSiteContact
	--					SET isDeleted = 1, ModifiedBySystemUserID = @UserID, Modified = GETDATE()
	--					WHERE Site_Id = @SiteID AND ContactRole_Id = 3
	--			END
							
	--		Update tblSite
	--		SET SiteAddress_Id = null
	--		where Id = @SiteID

	--		DECLARE @Ex_AddressID AS INT
	--		SELECT @Ex_AddressID = SiteAddress_Id FROM tblSite WHERE Id = @SiteID
	--		DELETE FROM tblAddress WHERE Id = @Ex_AddressID
					 
	--		--Get suburbID
	--		DECLARE @SuburbID AS INT
	--		IF(SELECT COUNT(1) FROM @SiteSuburb) > 0
	--			BEGIN
	--				SELECT @SuburbID = S.Id FROM tblSuburb S
	--				INNER JOIN @SiteSuburb SS ON S.Name = SS.Name AND S.PostCode = SS.PostCode AND S.State_Abbrev = SS.State_Abbrev
	--			END
			
	--		--Add site address
	--		DECLARE @SiteAddressID AS INT
	--		IF(SELECT COUNT(1) FROM @SiteAddress) > 0
	--			BEGIN
	--				INSERT INTO [dbo].[tblAddress]
	--				(
	--				[StreetAddress]
	--				,[StreetType_Abbrev]
	--				,[Suburb_Id]
	--				,[Council_Id]
	--				,[Electorate_Id]
	--				,[Region_Id]
	--				)
	--				SELECT 
	--					[StreetAddress]
	--					,ST.Abbrev
	--					,@SuburbID
	--					,[Council_Id]
	--					,[Electorate_Id]
	--					,[Region_Id]
	--				FROM @SiteAddress SA
	--				LEFT JOIN tblStreetType ST ON ST.Id = SA.StreetType

	--				SELECT @SiteAddressID = @@IDENTITY;					
	--			END
	--		ELSE --If address not found then check if suburb exists
	--			BEGIN
	--				IF(@SuburbID > 0)
	--					BEGIN
	--						INSERT INTO [dbo].[tblAddress]
	--						(
	--							[Suburb_Id]
	--						)
	--						SELECT 
	--							@SuburbID								
	--						FROM @SiteAddress	
	--					END

	--				SELECT @SiteAddressID = @@IDENTITY;
	--			END
			
	--		--update address id in site table
	--		IF(@SiteAddressID > 0)
	--			BEGIN
	--				UPDATE tblSite
	--				SET SiteAddress_Id = @SiteAddressID
	--				WHERE Id = @siteId
	--			END

			

	--		--Add Lot/Dps
			IF(@isSiteLotUpdated = 1)
				BEGIN
					--Delete existing lot dps
					DECLARE @DeleteLotTable TABLE(Lot_ID INT)

					INSERT INTO @DeleteLotTable(Lot_ID)
					SELECT L.Id FROM tblLot L
					INNER JOIN tblSiteLot SL ON L.Id = SL.Lot_Id WHERE SL.Site_Id = @SiteID			
					AND L.Id NOT IN(Select Lot_Id FROM tblSiteLot WHERE Site_Id != @SiteID)

					DELETE FROM tblSiteLot WHERE Site_Id = @SiteID

					DELETE L FROM tblLot L WHERE Id IN (Select Lot_ID FROM @DeleteLotTable)

					--if(Select SiteBoundary from tblsite where id = @SiteID) is null
					--	begin
					--		DECLARE @SiteBoundary as Geometry

					--		EXEC [dbo].[uspSpatialGetGeometryForSite] @xmlString, @SiteBoundary out

					--		if(@SiteBoundary is not null)
					--			begin
					--				update tblsite
					--				set SiteBoundary = @SiteBoundary
					--				where id = @SiteID

					--				update tblsite
					--				set SitePoint = [SiteBoundary].STCentroid()
					--				where id = @SiteID and SiteBoundary is not null
					--			end
					--	end
					if(SELECT COUNT(1) FROM @LotDP) > 0
						begin
							DECLARE @Lot varchar(20), @DP varchar(40), @Section varchar(20), @Plan_Type varchar(10)
							DECLARE @isRegulated bit, @isPart bit
							DECLARE @ObjectID int

							DECLARE lotdp_cursor CURSOR FOR 
							SELECT Lot, DP, Section, Plan_Type, isRegulated, isPart
							FROM @LotDP;

							OPEN lotdp_cursor

							FETCH NEXT FROM lotdp_cursor 
							INTO @Lot, @DP, @Section, @Plan_Type, @isRegulated, @isPart

							WHILE @@FETCH_STATUS = 0
							BEGIN
								print '@Lot =' + cast(@Lot as varchar)
								print '@DP =' + cast(@DP as varchar)
								print '@Section =' + cast(@Section as varchar)
								print '@Plan_Type =' + cast(@Plan_Type as varchar)

								--EXECUTE AS user = 'epacsdb_rw'
								--EXEC [dbo].[uspSpatialGetObjectIDLotDP] @Lot, @DP, @Section,@Plan_Type, @ObjectID out	
							 					
								--EXEC [dbo].[uspSpatialGetIntersectsForSiteSingleRow] @Lot, @DP, @Section, @Plan_Type
						        --REVERT

								--EXECUTE AS user = 'admin-hee'	
						        --print '@ObjectID =' + cast(@ObjectID as varchar)


								IF(SELECT COUNT(1) FROM tblReturnIntersectsTmp) > 0
									BEGIN
										DECLARE @Lga AS VARCHAR(1000)
										DECLARE @Electoral AS VARCHAR(1000)
										DECLARE @Region AS VARCHAR(1000)
										SELECT 
											@Lga = (substring((SELECT ( ', ' + rtrim(CAST(s1.FeatureName AS VARCHAR(1000))))
											   FROM tblReturnIntersectsTmp s1
											   WHERE LayerName = 'LGA'
											   FOR XML PATH( '' )
											  ), 3, 1000 ))

										SELECT 
											@Electoral = (substring((SELECT ( ', ' + rtrim(CAST(s1.FeatureName AS VARCHAR(1000))))
											   FROM tblReturnIntersectsTmp s1
											   WHERE LayerName = 'Electoral'
											   FOR XML PATH( '' )
											  ), 3, 1000 ))

										SELECT 
											@Region = (substring((SELECT ( ', ' + rtrim(CAST(s1.FeatureName AS VARCHAR(1000))))
											   FROM tblReturnIntersectsTmp s1
											   WHERE LayerName = 'Region'
											   FOR XML PATH( '' )
											  ), 3, 1000 ))
							
										--Insert records in LOT table and SiteLot table
										DECLARE @LotID as INT
										INSERT INTO tblLot
										(
											Lot,
											Plan_NO,
											Section,
											Plan_Type,
											isRegulated,
											isPart,
											Council,
											Electorate,
											Region,
											ObjectID
										)
										SELECT @Lot, @DP, @Section,isnull(@Plan_Type,'DP'), @isRegulated, @isPart, @Lga, @Electoral, @Region, @ObjectID

										SELECT @LotID = @@IDENTITY

										INSERT INTO tblSiteLot
										(
											Site_Id,
											Lot_Id
										)
										SELECT @SiteID, @LotID								
									END
								ELSE --If Spatial attributes are not availabel then just add lot dp information
									BEGIN
										INSERT INTO tblLot
										(
											Lot,
											Plan_NO,
											Section,
											Plan_Type,
											isRegulated,
											isPart,
											ObjectID
										)
										SELECT @Lot, @DP, @Section, isnull(@Plan_Type,'DP'), @isRegulated, @isPart, @ObjectID

										SELECT @LotID = @@IDENTITY

										print '@LotID =' + cast(@LotID as varchar)

										INSERT INTO tblSiteLot
										(
											Site_Id,
											Lot_Id
										)
										SELECT @SiteID, @LotID	
									END
						
								FETCH NEXT FROM lotdp_cursor 
								INTO @Lot, @DP, @Section, @Plan_Type, @isRegulated, @isPart
							END	
							CLOSE lotdp_cursor;
							DEALLOCATE lotdp_cursor;

							--Notes: 01-06-2017 Eric He here we add stored procedure call EXEC uspUpdateSiteBoundaryBySiteId SiteID
							--to update the SiteBoundary on table: tblSite. Because the map viewer will use this geometry data to draw the 
							--land boundaries. Whenever the user update LOT/DP data we need update this column
							if exists(select isAllowGeometryAutoUpdate from tblSite where [Id] = @SiteID and isAllowGeometryAutoUpdate = 1) 
								exec uspUpdateSiteBoundaryBySiteId @SiteID	
						end			
				END

	--		IF(@isSiteTankInfoUpdated = 1)
	--			BEGIN
	--				--Delete existing fuel
	--				Delete FROM tblSiteTank WHERE Site_Id = @SiteID

	--				--Add fuel information
	--				if(SELECT COUNT(1) FROM @SiteTank) > 0
	--					BEGIN
	--						INSERT INTO tblSiteTank
	--						(
	--							Site_Id,
	--							Fuel_Id,
	--							NoOfTanks
	--						)
	--						SELECT
	--							@siteId,
	--							Fuel_Id,
	--							NoOfTanks
	--						FROM @SiteTank

	--					END
	--			END

	--		--IF(@isContaminantListUpdated = 1)
	--		--	BEGIN
	--		--		Delete FROM tblSiteChemical WHERE Site_Id = @SiteID

	--		--		--Add Contaminants
	--		--		if(SELECT COUNT(1) FROM @Chemical) > 0
	--		--			BEGIN
	--		--				INSERT INTO tblSiteChemical
	--		--				(
	--		--					Site_Id,
	--		--					Chemical_Id
	--		--				)
	--		--				SELECT DISTINCT
	--		--					@siteId,
	--		--					TC.Id
	--		--				FROM tblChemical TC
	--		--				INNER JOIN @Chemical C ON
	--		--				TC.ContamClass_Id = C.ContamClass_Id AND
	--		--				TC.ChemGroup = C.ChemGroup
	--		--			END
	--		--	END
			
	--		IF(@isNotificationUpdated = 1)
	--			BEGIN
	--				DECLARE @ContactToBeDeleted AS TABLE(ContactID INT)

	--				--Add Notifications
	--				if(SELECT COUNT(1) FROM @Notification) > 0
	--																																																																																																																																																																																																																																																																																																																																																																																																																																									BEGIN
	--				--Delete existing Notifications and addresses
	--				INSERT INTO @ContactToBeDeleted(ContactID)
	--				SELECT C.Id FROM tblContact C INNER JOIN tblSiteContact SC ON C.Id = SC.Contact_Id 
	--				WHERE Site_Id = @SiteID AND ContactRole_Id = 5  and SC.isDeleted = 0
	--				AND C.Id NOT IN(SELECT [ContactID] FROM @Notification)
	--				AND C.Id NOT IN(Select Contact_Id FROM tblSiteContact WHERE Site_Id != @SiteID)

	--				--DELETE FROM tblSiteContact WHERE Site_Id = @SiteID AND ContactRole_Id = 5
	--				UPDATE tblSiteContact
	--					SET isDeleted = 1, ModifiedBySystemUserID = @UserID, Modified = GETDATE()
	--					WHERE Site_Id = @SiteID AND ContactRole_Id = 5

	--				DELETE FROM tblNotification WHERE Site_Id = @SiteID
	--				DELETE FROM tblContact WHERE Id IN(SELECT ContactID FROM @ContactToBeDeleted)

	--				DECLARE @isNotifierTheOwner bit, @isNotifierThePolluter bit, @ContactID int, @ContactCompany varchar(100),
	--				@Name varchar(120), @Phone varchar(40), @Email varchar(100), @Position varchar(100), 
	--				@StreetAddress varchar(100), @StreetType varchar(10), @Suburb varchar(100),
	--				@State varchar(10), @Postcode varchar(4), @Notified date, @S60Comment varchar(100),
	--				@Under60 bit, @NotificationTrimNo varchar(15), @ResponseTrimNo varchar(15),
	--				@isAirAffected bit, @isAffectedGroundwater bit, @isAffectedSurfaceWater bit,
	--				@isAffectedSediment bit, @isAffectedSoil bit, @isAffectedStormwater bit,
	--				@isAffectedDrinkingWater bit, @isAffectedWetlands bit, @isAffectedOther bit,
	--				@OtherAffectedSpecify varchar(50), @isAtRiskResidents bit, @isRiskWorkers bit,
	--				@isAtRiskSchool bit, @isAtRiskThreatSpecies bit, @isRiskAquatic bit, @isRiskPlants bit,
	--				@isAtRiskAnimals bit, @isAtRiskOther bit, @AtRiskOtherSpecify varchar(50)
					
	--				DECLARE notif_cursor CURSOR FOR 
	--				SELECT [isNotifierTheOwner],[isNotifierThePolluter], [ContactID], [ContactCompany],
	--							[Name],[Phone],[Email],[Position],[StreetAddress],[StreetType],
	--							[Suburb], [State], [PostCode],[Notified]
	--							,[S60Comment],[UnderS60],[NotificationTrimNo],[ReponseTrimNo], [isAirAffected]
	--							,[isAffectedGroundwater],[isAffectedSurfaceWater],[isAffectedSediment]
	--							,[isAffectedSoil],[isAffectedStormwater],[isAffectedDrinkingWater]
	--							,[isAffectedWetlands],[isAffectedOther],[OtherAffectedSpecify]
	--							,[isAtRiskResidents],[isAtRiskWorkers],[isAtRiskSchool]
	--							,[isAtRiskThreatSpecies],[isAtRiskAquatic],[isAtRiskPlants]
	--							,[isAtRiskAnimals],[isAtRiskOther],[AtRiskOtherSpecify]
	--				FROM @Notification;

	--				OPEN notif_cursor

	--				FETCH NEXT FROM notif_cursor 
	--				INTO @isNotifierTheOwner, @isNotifierThePolluter,@ContactID, @ContactCompany, @Name, @Phone,
	--					@Email, @Position, @StreetAddress, @StreetType, @Suburb, @State, @Postcode, @Notified, @S60Comment,
	--					@Under60, @NotificationTrimNo, @ResponseTrimNo,	@isAirAffected, @isAffectedGroundwater, 
	--					@isAffectedSurfaceWater, @isAffectedSediment, @isAffectedSoil, @isAffectedStormwater, 
	--					@isAffectedDrinkingWater, @isAffectedWetlands, @isAffectedOther, @OtherAffectedSpecify, @isAtRiskResidents, @isRiskWorkers ,
	--					@isAtRiskSchool, @isAtRiskThreatSpecies, @isRiskAquatic, @isRiskPlants,
	--					@isAtRiskAnimals, @isAtRiskOther, @AtRiskOtherSpecify 


	--				WHILE @@FETCH_STATUS = 0
	--				BEGIN						
	--					DECLARE @OldContact BIT = 0
	--					DECLARE @Street_Abbrev AS VARCHAR(100)
	--					DECLARE @Contact_ID AS INT

	--					if(@ContactID > 0 AND EXISTS(SELECT Id FROM tblContact WHERE Id = @ContactID))
	--						BEGIN
	--							SET @Contact_ID = @ContactID
	--							SET @OldContact = 1
	--						END
						
	--					DECLARE @Suburb_ID AS INT
	--					SELECT @Suburb_ID = S.Id FROM tblSuburb S
	--					WHERE S.Name = @Suburb AND Postcode = @Postcode AND S.State_Abbrev = @State


	--					IF(@OldContact = 0)
	--						BEGIN
	--							DECLARE @Address_ID AS INT
	--							if(LTRIM(RTRIM(@StreetAddress)) != '' or LTRIM(RTRIM(@StreetType)) != '' OR @Suburb_ID > 0)
	--								BEGIN										
	--									IF LTRIM(RTRIM(@StreetType)) != '' 
	--										BEGIN
	--										SELECT @Street_Abbrev = Abbrev
	--										FROM tblStreetType WHERE Id = @StreetType
	--										END

	--									INSERT INTO [dbo].[tblAddress]
	--									(
	--									[StreetAddress]
	--									,[StreetType_Abbrev]
	--									,[Suburb_Id]
	--									)
	--									SELECT 
	--										@StreetAddress
	--										,@Street_Abbrev
	--										,@SuburbID								

	--									SELECT @Address_ID = @@IDENTITY;
	--								END
						
									

	--								INSERT INTO tblContact
	--								(
	--									[ContactCompany]
	--									,[Name]
	--									,[Phone]
	--									,[Email]
	--									,[Position]
	--									,[Address_Id]
	--								)
	--								SELECT @ContactCompany, @Name, @Phone, @Email, @Position, @Address_Id

	--								SELECT @Contact_ID = @@IDENTITY;
	--						END
	--					ELSE
	--						BEGIN
	--							SET @Street_Abbrev = ''
	--							IF LTRIM(RTRIM(@StreetType)) != '' 
	--										BEGIN
	--										SELECT @Street_Abbrev = Abbrev
	--										FROM tblStreetType WHERE Id = @StreetType
	--										END

	--							UPDATE A
	--								SET [StreetAddress] = @StreetAddress,
	--								[StreetType_Abbrev] = (CASE WHEN @Street_Abbrev = '' THEN null ELSE @Street_Abbrev END)
	--							FROM [dbo].[tblAddress] A
	--							INNER JOIN [dbo].[tblContact] C
	--							ON A.Id = C.[Address_Id] WHERE C.Id = @ContactID
						
	--							UPDATE [dbo].[tblContact]
	--							SET [ContactCompany] = @ContactCompany
	--									,[Name] = @Name
	--									,[Phone] = @Phone
	--									,[Email] = @Email
	--									,[Position] = @Position
	--							WHERE Id = @ContactID
	--						END	
						
	--					--Add site notifier record in tblSiteContact
	--					IF(@Contact_ID > 0)
	--						BEGIN
	--							INSERT INTO tblSiteContact
	--							(
	--							   [Contact_Id]
	--							  ,[Site_Id]
	--							  ,[ContactRole_Id]
	--							  ,[ValidFrom]
	--							  ,[CreatedBySystemUserID]
	--							  ,[Created]	
	--							  ,[Modified]
	--							  ,[ModifiedBySystemUserID]							  
	--							)
	--							SELECT
	--								@Contact_ID
	--								,@siteId
	--								,5
	--								,GETDATE()
	--								,@UserID
	--								,GETDATE()
	--								,GETDATE()
	--								,@UserID
	--						END

	--					INSERT INTO [dbo].[tblNotification]
	--					([Site_Id]
	--					,[isNotifierTheOwner]
	--					,[isNotifierThePolluter]
	--					,[NotifierContact_Id]
	--					,[Notified]
	--					,[S60Comment]
	--					,[UnderS60]
	--					,[NotificationTrimNo]
	--					,[ReponseTrimNo]
	--					,[isAirAffected]
	--					,[isAffectedGroundwater]
	--					,[isAffectedSurfaceWater]
	--					,[isAffectedSediment]
	--					,[isAffectedSoil]
	--					,[isAffectedStormwater]
	--					,[isAffectedDrinkingWater]
	--					,[isAffectedWetlands]
	--					,[isAffectedOther]
	--					,[OtherAffectedSpecify]
	--					,[isAtRiskResidents]
	--					,[isAtRiskWorkers]
	--					,[isAtRiskSchool]
	--					,[isAtRiskThreatSpecies]
	--					,[isAtRiskAquatic]
	--					,[isAtRiskPlants]
	--					,[isAtRiskAnimals]
	--					,[isAtRiskOther]
	--					,[AtRiskOtherSpecify]
	--					,[Created]
	--					,[CreatedBySystemUserID])
	--					SELECT 
	--						@siteId,
	--						@isNotifierTheOwner
	--						,@isNotifierThePolluter
	--						,@Contact_Id
	--						,@Notified
	--						,@S60Comment
	--						,@Under60
	--						,@NotificationTrimNo
	--						,@ResponseTrimNo
	--						,@isAirAffected
	--						,@isAffectedGroundwater
	--						,@isAffectedSurfaceWater
	--						,@isAffectedSediment
	--						,@isAffectedSoil
	--						,@isAffectedStormwater
	--						,@isAffectedDrinkingWater
	--						,@isAffectedWetlands
	--						,@isAffectedOther
	--						,@OtherAffectedSpecify
	--						,@isAtRiskResidents
	--						,@isRiskWorkers
	--						,@isAtRiskSchool
	--						,@isAtRiskThreatSpecies
	--						,@isRiskAquatic
	--						,@isRiskPlants
	--						,@isAtRiskAnimals
	--						,@isAtRiskOther
	--						,@AtRiskOtherSpecify
	--						,GETDATE()
	--						,@UserID

	--					FETCH NEXT FROM notif_cursor 
	--					INTO @isNotifierTheOwner, @isNotifierThePolluter,@ContactID, @ContactCompany, @Name, @Phone,
	--						@Email, @Position, @StreetAddress, @StreetType, @Suburb, @State, @Postcode, @Notified, @S60Comment,
	--						@Under60, @NotificationTrimNo, @ResponseTrimNo,	@isAirAffected, @isAffectedGroundwater, 
	--						@isAffectedSurfaceWater, @isAffectedSediment, @isAffectedSoil, @isAffectedStormwater, 
	--						@isAffectedDrinkingWater, @isAffectedWetlands, @isAffectedOther, @OtherAffectedSpecify, @isAtRiskResidents, @isRiskWorkers ,
	--						@isAtRiskSchool, @isAtRiskThreatSpecies, @isRiskAquatic, @isRiskPlants,
	--						@isAtRiskAnimals, @isAtRiskOther, @AtRiskOtherSpecify
	--				END

	--				CLOSE notif_cursor;
	--				DEALLOCATE notif_cursor;	
	--			END
	--				ELSE
	--					BEGIN
	--						--Delete existing Notifications and addresses
	--						INSERT INTO @ContactToBeDeleted(ContactID)
	--						SELECT C.Id FROM tblContact C INNER JOIN tblSiteContact SC ON C.Id = SC.Contact_Id 
	--						WHERE Site_Id = @SiteID AND ContactRole_Id = 5 and SC.IsDeleted = 0
	--						AND C.Id NOT IN(SELECT [ContactID] FROM @Notification)
	--						AND C.Id NOT IN(Select Contact_Id FROM tblSiteContact WHERE Site_Id != @SiteID)

	--						--DELETE FROM tblSiteContact WHERE Site_Id = @SiteID AND ContactRole_Id = 5					
	--						UPDATE tblSiteContact
	--							SET isDeleted = 1, ModifiedBySystemUserID = @UserID, Modified = GETDATE()
	--							WHERE Site_Id = @SiteID AND ContactRole_Id = 5

	--						DELETE FROM tblNotification WHERE Site_Id = @SiteID
	--						DELETE FROM tblContact WHERE Id IN(SELECT ContactID FROM @ContactToBeDeleted)
	--					END
	--			END
			
	--		IF(@isSiteActionUpdated = 1)
 --               BEGIN
 --                   --Add Site Actions
 --                   if(SELECT COUNT(1) FROM @SiteAction) > 0
 --                       BEGIN
 --                           --Delete FROM tblAction WHERE Site_Id = @SiteID
 --                           --  AND Id NOT IN(SELECT Id FROM @SiteAction)
                            
 --                           Delete FROM tblAction WHERE Site_Id = @SiteID
 --                               AND Id IN(SELECT Id FROM @SiteAction where IsDeleted=1)
                            
 --                           INSERT INTO tblAction
 --                           (
 --                               Site_Id,
 --                               ActionDate,
 --                               DueDate,
 --                               TrimNo,
 --                               isComplete,
 --                               Completed,
 --                               ActionType_Id,
 --                               Descript,
 --                               Created,
 --                               CreatedBySystemUserID,
 --                               Modified,
 --                               ModifiedBySystemUserID
 --                           )
 --                           SELECT DISTINCT
 --                               @siteId,
 --                               ActionDate,
 --                               DueDate,
 --                               TrimNo,
 --                               CASE WHEN Completed is not null THEN 1 ELSE 0 END,
 --                               Completed,
 --                               ActionType_Id,
 --                               Descript,
 --                               GETDATE(),
 --                               @UserID,
 --                               GETDATE(),
 --                               @UserID
 --                           FROM @SiteAction WHERE Id <= 0 and IsDeleted=0
 
 --                           UPDATE A
 --                           SET 
 --                               ActionDate = B.ActionDate,
 --                               DueDate = B.DueDate,
 --                               TrimNo = B.TrimNo,
 --                               Completed = B.Completed,
 --                               ActionType_Id = B.ActionType_Id,
 --                               Descript = B.Descript,
 --                               Modified = GETDATE(),
 --                               ModifiedBySystemUserID = @UserID
 --                           FROM tblAction A
 --                           INNER JOIN @SiteAction B ON A.Id = B.Id
 --                       END
 --                   --else
 --                       --BEGIN
 --                       --  Delete FROM tblAction WHERE Site_Id = @SiteID
 --                       --END
 --               END
 --       END 
 --       END
	--ELSE IF @TabID = 4	
	--	BEGIN
	--		IF(@IsUPSS = 1)
	--			BEGIN
	--				INSERT INTO @PersonResponsible
	--				(
	--					Id,
	--					Title,
	--					Name,
	--					ContactCompany,						
	--					Company,
	--					Phone,
	--					Phone1,
	--					Email,
	--					Position,
	--					StartDate,
	--					EndDate
	--				)
	--				SELECT  
	--					XD.SiteData.value('PersonResponsible_Id[1]','int'),
	--					XD.SiteData.value('Title[1]','varchar(10)'),
	--					XD.SiteData.value('Name[1]','varchar(120)'),
	--					XD.SiteData.value('ContactCompany[1]','varchar(100)'),						
	--					XD.SiteData.value('Company[1]','varchar(120)'),
	--					XD.SiteData.value('Phone[1]','varchar(40)'),
	--					XD.SiteData.value('Phone1[1]','varchar(40)'),
	--					XD.SiteData.value('Email[1]','varchar(100)'),
	--					XD.SiteData.value('Occupation[1]','varchar(100)'),
	--					XD.SiteData.value('StartDate[1]','DateTime'),
	--					XD.SiteData.value('EndDate[1]','DateTime')
	--				FROM @xmlString.nodes('/Site/_PersonResponsible') AS XD(SiteData)
								

	--				DECLARE @PRAddress as tblAddress
	--				DECLARE @PRSuburb as tblSuburb

	--				INSERT INTO @PRAddress
	--				(
	--					[Id],
	--					[StreetAddress],
	--					[StreetType]
	--				)
	--				SELECT  
	--					ISNULL(XD.SiteData.value('Id[1]','int'), -1),
	--					XD.SiteData.value('StreetAddress[1]','varchar(100)'),
	--					XD.SiteData.value('StreetType[1]','int')
	--				FROM @xmlString.nodes('/Site/_PersonResponsible') AS XD(SiteData)
					
	--				INSERT INTO @PRSuburb
	--				(
	--					[Id],
	--					[Name],
	--					[PostCode],
	--					[State_Abbrev]
	--				)
	--				SELECT 
	--					ISNULL(XD.SiteData.value('SuburbId[1]','int'), -1),
	--					XD.SiteData.value('SuburbName[1]','varchar(80)'),
	--					XD.SiteData.value('Postcode[1]','varchar(4)'),
	--					XD.SiteData.value('State[1]','varchar(10)')		
	--				FROM @xmlString.nodes('/Site/_PersonResponsible') AS XD(SiteData)
					
	--				DECLARE @StreetAddress1 varchar(100), @StreetType1 varchar(10), 
	--								@Suburb1 varchar(100), @Street_Abbrev1 varchar(100),
	--								@State1 varchar(10), @Postcode1 varchar(4)
	--				DECLARE @Suburb_ID1 AS INT
	--				DECLARE @Address_ID1 AS INT

	--				--Add Person Responsible
	--				IF(SELECT COUNT(1) FROM @PersonResponsible) > 0
	--					BEGIN														
	--						DECLARE @PersonResponsible_Id AS INT,
	--						@StartDate AS DATETIME, @EndDate AS DATETIME

	--						SELECT @PersonResponsible_Id = Id,
	--							@StartDate = StartDate,
	--							@EndDate = EndDate							
	--						FROM @PersonResponsible
							
	--						--Check if person responsible exists then update it
	--						IF(EXISTS(SELECT Id FROM tblSiteContact WHERE Site_Id = @SiteID AND 
	--							ContactRole_Id = 1 AND Contact_Id = @PersonResponsible_Id and ValidTo is null))
	--							BEGIN
	--								DECLARE @PersRespAddressID AS INT
									
	--								SELECT @PersRespAddressID = C.Address_Id
	--								FROM tblContact C INNER JOIN
	--								@PersonResponsible S ON C.Id = S.Id

	--								--UPDATE C
	--								--SET Address_Id = null
	--								--FROM tblContact C INNER JOIN
	--								--@PersonResponsible S ON C.Id = S.Id
									
	--								--DELETE FROM tblAddress where Id = @DeleteAddress								
									
	--								Select
	--									@StreetAddress1 = StreetAddress,
	--									@Street_Abbrev1 = StreetType
	--								FROM @PRAddress									
									
	--								Select
	--									@Suburb1 = Name,
	--									@Postcode1 = PostCode,
	--									@State1 = State_Abbrev
	--								FROM @PRSuburb

	--								SELECT @Suburb_ID1 = S.Id FROM tblSuburb S
	--								WHERE S.Name = @Suburb1 AND Postcode = @Postcode1 AND S.State_Abbrev = @State1
									

	--								if(LTRIM(RTRIM(@StreetAddress1)) != '' or LTRIM(RTRIM(@Street_Abbrev1)) != '' OR 
	--									@Suburb_ID1 > 0)
	--									BEGIN		
	--										if(@PersRespAddressID>0)
	--											begin
	--												IF LTRIM(RTRIM(@Street_Abbrev1)) != '' 
	--													BEGIN
	--													SELECT @Street_Abbrev1 = Abbrev
	--													FROM tblStreetType WHERE Id = @Street_Abbrev1
	--													END

	--												update tbladdress
	--												set [StreetAddress] = @StreetAddress1,
	--													[StreetType_Abbrev] = @Street_Abbrev1,
	--													[Suburb_Id] = @Suburb_ID1
	--												where id = @PersRespAddressID

	--												set @Address_ID1 = @PersRespAddressID
	--											end
	--										else
	--											begin							
	--												IF LTRIM(RTRIM(@Street_Abbrev1)) != '' 
	--													BEGIN
	--													SELECT @Street_Abbrev1 = Abbrev
	--													FROM tblStreetType WHERE Id = @Street_Abbrev1
	--													END

	--												INSERT INTO [dbo].[tblAddress]
	--												(
	--												[StreetAddress]
	--												,[StreetType_Abbrev]
	--												,[Suburb_Id]
	--												)
	--												SELECT 
	--													@StreetAddress1
	--													,@Street_Abbrev1
	--													,@Suburb_ID1								

	--												SELECT @Address_ID1 = @@IDENTITY;
	--										end
	--									END
	--								else
	--									begin
	--										UPDATE C
	--										SET Address_Id = null
	--										FROM tblContact C INNER JOIN
	--										@PersonResponsible S ON C.Id = S.Id
	--									end
													
	--								UPDATE C
	--								SET [ContactCompany] = S.ContactCompany
	--								   ,[Name] = S.Name
	--								   ,[Phone] = S.Phone
	--								   ,[Email] = S.Email
	--								   ,[Company] = S.Company
	--								   ,[Phone1] = S.Phone1
	--								   ,[Position] = S.Position
	--								   ,[Title] = S.Title
	--								   ,[Address_Id] = @Address_ID1
	--								FROM tblContact C INNER JOIN
	--								@PersonResponsible S ON C.Id = S.Id

	--								UPDATE tblSiteContact
	--								SET ValidFrom = ISNULL(@StartDate,getDATE()),
	--									ValidTo = @EndDate, ModifiedBySystemUserID = @UserID, Modified = GETDATE()
	--								WHERE ContactRole_Id = 1 AND
	--								Contact_Id = @PersonResponsible_Id AND
	--								Site_Id = @SiteID
	--							END
	--						ELSE
	--							BEGIN
	--								--SET @PersonResponsible_Id = 0
	--								if(@PersonResponsible_Id > 0)
	--									BEGIN										
	--										DECLARE @PersRespAddressID1 AS INT
									
	--										SELECT @PersRespAddressID1 = C.Address_Id
	--										FROM tblContact C INNER JOIN
	--										@PersonResponsible S ON C.Id = S.Id

	--										--UPDATE C
	--										--SET Address_Id = null
	--										--FROM tblContact C INNER JOIN
	--										--@PersonResponsible S ON C.Id = S.Id

	--										--DELETE FROM tblAddress where Id = @DeleteAddress								
									
	--										Select
	--											@StreetAddress1 = StreetAddress,
	--											@Street_Abbrev1 = StreetType
	--										FROM @PRAddress									
									
	--										Select
	--											@Suburb1 = Name,
	--											@Postcode1 = PostCode,
	--											@State1 = State_Abbrev
	--										FROM @PRSuburb

	--										SELECT @Suburb_ID1 = S.Id FROM tblSuburb S
	--										WHERE S.Name = @Suburb1 AND Postcode = @Postcode1 AND S.State_Abbrev = @State1
									

	--										if(LTRIM(RTRIM(@StreetAddress1)) != '' or LTRIM(RTRIM(@Street_Abbrev1)) != '' OR 
	--											@Suburb_ID1 > 0)
	--											BEGIN		
	--												if(@PersRespAddressID>0)
	--													begin
	--														IF LTRIM(RTRIM(@Street_Abbrev1)) != '' 
	--															BEGIN
	--															SELECT @Street_Abbrev1 = Abbrev
	--															FROM tblStreetType WHERE Id = @Street_Abbrev1
	--															END

	--														update tbladdress
	--														set [StreetAddress] = @StreetAddress1,
	--															[StreetType_Abbrev] = @Street_Abbrev1,
	--															[Suburb_Id] = @Suburb_ID1
	--														where id = @PersRespAddressID

	--														set @Address_ID1 = @PersRespAddressID
	--													end
	--												else
	--													begin							
	--														IF LTRIM(RTRIM(@Street_Abbrev1)) != '' 
	--															BEGIN
	--															SELECT @Street_Abbrev1 = Abbrev
	--															FROM tblStreetType WHERE Id = @Street_Abbrev1
	--															END

	--														INSERT INTO [dbo].[tblAddress]
	--														(
	--														[StreetAddress]
	--														,[StreetType_Abbrev]
	--														,[Suburb_Id]
	--														)
	--														SELECT 
	--															@StreetAddress1
	--															,@Street_Abbrev1
	--															,@Suburb_ID1								

	--														SELECT @Address_ID1 = @@IDENTITY;
	--												end
	--											END
	--										else
	--											begin
	--												UPDATE C
	--												SET Address_Id = null
	--												FROM tblContact C INNER JOIN
	--												@PersonResponsible S ON C.Id = S.Id
	--											end
									
													
	--										UPDATE C
	--										SET [ContactCompany] = S.ContactCompany
	--										   ,[Name] = S.Name
	--										   ,[Phone] = S.Phone
	--										   ,[Email] = S.Email
	--										   ,[Company] = S.Company
	--										   ,[Phone1] = S.Phone1
	--										   ,[Position] = S.Position
	--										   ,[Title] = S.Title
	--										   ,[Address_Id] = @Address_ID1
	--										FROM tblContact C INNER JOIN
	--										@PersonResponsible S ON C.Id = S.Id

	--										DECLARE @IsNewPersonResponsible as bit

	--										IF(EXISTS(SELECT Id FROM tblSiteContact WHERE Site_Id = @SiteID AND 
	--											ContactRole_Id = 1 AND Contact_Id = @PersonResponsible_Id))
	--											begin
	--												set @IsNewPersonResponsible = 0
	--											end
	--										else
	--											begin
	--												set @IsNewPersonResponsible = 1
	--											end
											
	--										if(@IsNewPersonResponsible = 1)
	--											begin
	--												update tblsitecontact set validto = GETDATE(), ModifiedBySystemUserID = @UserID, Modified = GETDATE()
	--												where site_id = @SiteID and validto is null

	--												INSERT INTO tblSiteContact
	--												(
	--												   [Contact_Id]
	--												  ,[Site_Id]
	--												  ,[ContactRole_Id]
	--												  ,[ValidFrom]
	--												  ,[ValidTo]
	--												  ,[Created]
	--												  ,[CreatedBySystemUserID]
	--												  ,[Modified]
	--												  ,[ModifiedBySystemUserID]
	--												)
	--												SELECT
	--													@PersonResponsible_Id
	--													,@siteId
	--													,1
	--													,ISNULL(@StartDate,GETDATE())
	--													,@EndDAte
	--													,GETDATE()
	--													,@UserID
	--													,GETDATE()
	--													,@UserID
	--											end
	--										else
	--											begin
	--												update tblsitecontact
	--												set validfrom = @StartDate,
	--													validto = @EndDate, ModifiedBySystemUserID = @UserID, Modified = GETDATE()
	--												where  Site_Id = @SiteID AND 
	--												ContactRole_Id = 1 AND Contact_Id = @PersonResponsible_Id
	--											end
	--									END
	--								ELSE
	--									BEGIN
	--										update tblsitecontact set validto = GETDATE(), ModifiedBySystemUserID = @UserID, Modified = GETDATE()
	--										where site_id = @SiteID and validto is null

	--										Select
	--											@StreetAddress1 = StreetAddress,
	--											@Street_Abbrev1 = StreetType
	--										FROM @PRAddress									
									

	--										Select
	--											@Suburb1 = Name,
	--											@Postcode1 = PostCode,
	--											@State1 = State_Abbrev
	--										FROM @PRSuburb
																						
	--										SELECT @Suburb_ID1 = S.Id FROM tblSuburb S
	--										WHERE S.Name = @Suburb1 AND Postcode = @Postcode1 AND S.State_Abbrev = @State1
																		
	--										if(LTRIM(RTRIM(@StreetAddress1)) != '' or LTRIM(RTRIM(@Street_Abbrev1)) != '' OR 
	--											@Suburb_ID1 > 0)
	--											BEGIN										
	--												IF LTRIM(RTRIM(@Street_Abbrev1)) != '' 
	--													BEGIN
	--													SELECT @Street_Abbrev1 = Abbrev
	--													FROM tblStreetType WHERE Id = @Street_Abbrev1
	--													END

	--												INSERT INTO [dbo].[tblAddress]
	--												(
	--												[StreetAddress]
	--												,[StreetType_Abbrev]
	--												,[Suburb_Id]
	--												)
	--												SELECT 
	--													@StreetAddress1
	--													,@Street_Abbrev1
	--													,@Suburb_ID1								

	--												SELECT @Address_ID1 = @@IDENTITY;
	--											END

	--										INSERT INTO tblContact
	--										(
	--											[ContactCompany]
	--											,[Title]
	--										   ,[Name]
	--										   ,[Phone]
	--										   ,[Email]
	--										   ,[Phone1]
	--										   ,[Position]
	--										   ,[Company],
	--										   [Address_Id]
	--										)
	--										SELECT ContactCompany, Title, Name, Phone, Email, Phone1,
	--											Position, Company, @Address_ID1
	--										FROM @PersonResponsible

	--										Select @PersonResponsible_Id = @@IDENTITY;
											
	--										--Add person responsible record in tblSiteContact
	--										IF(@PersonResponsible_Id > 0)
	--											BEGIN
	--												INSERT INTO tblSiteContact
	--												(
	--												   [Contact_Id]
	--												  ,[Site_Id]
	--												  ,[ContactRole_Id]
	--												  ,[ValidFrom]
	--												  ,[ValidTo]
	--												  ,[Created]
	--												  ,[CreatedBySystemUserID]
	--												  ,[Modified]
	--												  ,[ModifiedBySystemUserID]
	--												)
	--												SELECT
	--													@PersonResponsible_Id
	--													,@siteId
	--													,1
	--													,ISNULL(@StartDate,GETDATE())
	--													,@EndDAte
	--													,GETDATE()
	--													,@UserID
	--													,GETDATE()
	--													,@UserID
	--											END
	--									END									
	--						END
	--					END
	--			END
	--		ELSE --Delete any previously entered person responsible
	--			BEGIN
	--				--DELETE FROM tblSiteContact WHERE Site_Id = @SiteID AND ContactRole_Id = 1
	--				UPDATE tblSiteContact
	--					SET isDeleted = 1, ModifiedBySystemUserID = @UserID, Modified = GETDATE()
	--					WHERE Site_Id = @SiteID AND ContactRole_Id = 1
	--			END
	--	END
	--ELSE IF @TabID = 5
	--	BEGIN
	--		IF(@IsUPSS = 1)
	--			BEGIN
	--				INSERT INTO @Exemption
	--				(
	--					Id,
	--					[Contact_Id],
	--					[Site_Id],
	--					[AppliedFor],
	--					[DateGenerated],
	--					[DateExpiry],
	--					[ExemptionStatus_Id],
	--					[ExemptionClass_Id],
	--					[OrderNumber],
	--					[Notes],
	--					[Site_Contact_Id],
	--					[Created],
	--					[CreatedBySystemUserID],
	--					[Modified],
	--					[ModifiedBySystemUserID]
	--				)
	--				SELECT  
	--					XD.SiteData.value('Id[1]','int'),
	--					XD.SiteData.value('Contact_Id[1]','int'),
	--					XD.SiteData.value('Site_Id[1]','int'),
	--					XD.SiteData.value('AppliedFor[1]','date'),
	--					XD.SiteData.value('DateGenerated[1]','smalldatetime'),
	--					XD.SiteData.value('DateExpiry[1]','smalldatetime'),
	--					XD.SiteData.value('Status_Id[1]','varchar(40)'),
	--					XD.SiteData.value('Class_Id[1]','varchar(100)'),
	--					XD.SiteData.value('Order_Number[1]','int'),
	--					XD.SiteData.value('Notes[1]','varchar(4000)'),
	--					XD.SiteData.value('SiteContact_Id[1]','int'),
	--					XD.SiteData.value('Created[1]','smalldatetime'),
	--					XD.SiteData.value('CreatedBySystemUserID[1]','varchar(256)'),
	--					XD.SiteData.value('Modified[1]','smalldatetime'),
	--					XD.SiteData.value('ModifiedBySystemUserID[1]','varchar(256)')
	--				FROM @xmlString.nodes('/Site/Exemptions/Exemption') AS XD(SiteData)
					
	--				DELETE FROM tblExemption WHERE Id not in(select Id from @Exemption) AND Site_Id = @SiteID

	--				--Add Person Responsible
	--				IF(SELECT COUNT(1) FROM @Exemption) > 0
	--					BEGIN
	--						DECLARE @NextOrderNumber AS INT

	--						Select top 1 @NextOrderNumber = OrderNumber from tblexemption order by OrderNumber desc

	--						if @NextOrderNumber is not null
	--							begin
	--								SET @NextOrderNumber = @NextOrderNumber + 1
	--							end
	--						else
	--							begin
	--								SET @NextOrderNumber = 1
	--							end
							
	--						DECLARE @E_Contact_Id int, @E_Site_Id int,
	--							@E_AppliedFor date, @E_DateGenerated smalldatetime, @E_DateExpiry smalldatetime, @E_ExemptionStatus_Id int, @E_ExemptionClass_Id int,
	--							@E_OrderNumber int, @E_Notes varchar(400), @E_Site_Contact_Id int, @E_CreatedBy varchar(256);

	--						DECLARE rr_cursor CURSOR FOR 
	--						Select
	--							[Contact_Id],
	--							[Site_Id],
	--							[AppliedFor],
	--							[DateGenerated],
	--							[DateExpiry],
	--							[ExemptionStatus_Id],
	--							[ExemptionClass_Id],
	--							[OrderNumber],
	--							[Notes],
	--							[Site_Contact_Id],
	--							[CreatedBySystemUserID]
	--						FROM @Exemption
	--						WHERE Id <= 0

	--						OPEN rr_cursor

	--						FETCH NEXT FROM rr_cursor 
	--						INTO @E_Contact_Id, @E_Site_Id, @E_AppliedFor, @E_DateGenerated, @E_DateExpiry, @E_ExemptionStatus_Id, @E_ExemptionClass_Id,
	--						@E_OrderNumber,@E_Notes,@E_Site_Contact_Id,@E_CreatedBy

	--						WHILE @@FETCH_STATUS = 0
	--						BEGIN
	--							select @E_Site_Contact_Id = Id from tblsitecontact where site_id = @E_Site_Id and contact_id = @E_Contact_Id

	--							INSERT INTO tblExemption
	--							(
	--								[Contact_Id],
	--								[Site_Id],
	--								[AppliedFor],
	--								[DateGenerated],
	--								[DateExpiry],
	--								[ExemptionStatus_Id],
	--								[ExemptionClass_Id],
	--								[OrderNumber],
	--								[Notes],
	--								[Site_Contact_Id],
	--								[Created],
	--								[CreatedBySystemUserID],
	--								[Modified],
	--								[ModifiedBySystemUserID]
	--							)
	--							Select
	--								@E_Contact_Id,
	--								@E_Site_Id,
	--								case when year(@E_AppliedFor) < 1970 then null else @E_AppliedFor end,
	--								@E_DateGenerated,
	--								@E_DateExpiry,
	--								@E_ExemptionStatus_Id,
	--								@E_ExemptionClass_Id,
	--								@NextOrderNumber,
	--								@E_Notes,
	--								@E_Site_Contact_Id,
	--								GETDATE(),
	--								@UserID,
	--								GETDATE(),
	--								@UserID

	--							SET @NextOrderNumber = @NextOrderNumber + 1;

	--							FETCH NEXT FROM rr_cursor 
	--							INTO @E_Contact_Id, @E_Site_Id, @E_AppliedFor, @E_DateGenerated, @E_DateExpiry, @E_ExemptionStatus_Id, @E_ExemptionClass_Id,
	--							@E_OrderNumber,@E_Notes,@E_Site_Contact_Id,@E_CreatedBy
	--						END 
	--						CLOSE rr_cursor;
	--						DEALLOCATE rr_cursor;										
							

	--						UPDATE e								
	--						SET [AppliedFor] = ex.[AppliedFor],
	--							[DateGenerated] = ex.[DateGenerated],
	--							[DateExpiry] = ex.[DateExpiry],
	--							[ExemptionStatus_Id] = ex.[ExemptionStatus_Id],
	--							[ExemptionClass_Id] = ex.[ExemptionClass_Id],
	--							[OrderNumber] = ex.[OrderNumber],
	--							[Notes] = ex.[Notes],
	--							[Modified] = GETDATE(),
	--							[ModifiedBySystemUserID] = @UserID
	--						FROM tblExemption e
	--						INNER JOIN @Exemption ex ON e.Id = ex.Id
	--					END
	--			END
	--		ELSE --Delete any previously entered person responsible
	--			BEGIN
	--				DELETE FROM tblExemption WHERE Site_Id = @SiteID
	--			END
	--	END

	--COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
        --ROLLBACK TRANSACTION
        SET @ErrorMessage = dbo.ufn_GetErrorText()
        RAISERROR(@ErrorMessage, 16, 1)
	END CATCH