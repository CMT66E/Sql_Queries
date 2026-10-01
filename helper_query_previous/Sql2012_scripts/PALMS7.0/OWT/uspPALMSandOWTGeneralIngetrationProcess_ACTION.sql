declare     @InstrumentID            int
declare     @theXMLData              XML
declare     @ProcessTypeID           int	  
declare     @ReturnCustomerID        int

set @InstrumentID = 6089
set @ProcessTypeID = 9
set @ReturnCustomerID = 0
set @theXMLData = 
'
<DataBatchJob>
  <OWTAccountableParty>
    <InstrumentID>6089</InstrumentID>
    <AccountablePartyID>5049</AccountablePartyID>
    <TradingName>ERS AUSTRALIA PTY LIMITED</TradingName>
    <ACN_ARBN>001 576 889</ACN_ARBN>
    <ActiveFlag>true</ActiveFlag>
    <StreetAddress>177A Concord Road</StreetAddress>
    <Suburb>NORTH STRATHFIELD</Suburb>
    <PostCode>2137</PostCode>
    <StateCode>NSW</StateCode>
    <OldAccountablePartyFlag>true</OldAccountablePartyFlag>
  </OWTAccountableParty>
  <OWTAccountableParty>
    <InstrumentID>6089</InstrumentID>
    <AccountablePartyID>5063</AccountablePartyID>
    <TradingName>BLACKTOWN CUSTOM PACKERS PTY LIMITED</TradingName>
    <ACN_ARBN>88 069 511 995</ACN_ARBN>
    <ActiveFlag>true</ActiveFlag>
    <StreetAddress>177A Concord Road</StreetAddress>
    <Suburb>NORTH STRATHFIELD</Suburb>
    <PostCode>2137</PostCode>
    <StateCode>NSW</StateCode>
    <OldAccountablePartyFlag>false</OldAccountablePartyFlag>
  </OWTAccountableParty>
  <OWTLocation>
    <InstrumentID>6089</InstrumentID>
    <LocationID>2307</LocationID>
    <SiteName>ERS AUSTRALIA PTY LIMITED</SiteName>
    <StreetAddress>Suite 1 Level 1 27-29 Oxford Road</StreetAddress>
    <Suburb>INGLEBURN</Suburb>
    <PostCode>2565</PostCode>
    <StateCode>NSW</StateCode>
  </OWTLocation>
  <OWTContact>
    <ContactID>3739</ContactID>
    <Surname>Bond</Surname>
    <GivenName>James</GivenName>
    <OrganisationName>Spy Co</OrganisationName>
    <Phone>98987788</Phone>
    <AddressID>7463</AddressID>
    <StreetAddress>177A Concord Road</StreetAddress>
    <Suburb>NORTH STRATHFIELD</Suburb>
    <PostCode>2137</PostCode>
    <StateCode>NSW</StateCode>
  </OWTContact>
  <OWTPOEOLicenceWaste>
    <InstrumentID>6089</InstrumentID>
    <WasteCode>B100</WasteCode>
    <TrackableWasteFlag>true</TrackableWasteFlag>
  </OWTPOEOLicenceWaste>
  <OWTPOEOLicenceWaste>
    <InstrumentID>6089</InstrumentID>
    <WasteCode>C100</WasteCode>
    <TrackableWasteFlag>true</TrackableWasteFlag>
  </OWTPOEOLicenceWaste>
  <OWTPOEOLicenceWaste>
    <InstrumentID>6089</InstrumentID>
    <WasteCode>F100</WasteCode>
    <TrackableWasteFlag>true</TrackableWasteFlag>
  </OWTPOEOLicenceWaste>
  <OWTPOEOLicenceWaste>
    <InstrumentID>6089</InstrumentID>
    <WasteCode>F110</WasteCode>
    <TrackableWasteFlag>true</TrackableWasteFlag>
  </OWTPOEOLicenceWaste>
  <OWTPOEOLicenceWaste>
    <InstrumentID>6089</InstrumentID>
    <WasteCode>G110</WasteCode>
    <TrackableWasteFlag>true</TrackableWasteFlag>
  </OWTPOEOLicenceWaste>
  <OWTPOEOLicenceWaste>
    <InstrumentID>6089</InstrumentID>
    <WasteCode>G150</WasteCode>
    <TrackableWasteFlag>true</TrackableWasteFlag>
  </OWTPOEOLicenceWaste>
  <OWTPOEOLicenceWaste>
    <InstrumentID>6089</InstrumentID>
    <WasteCode>G160</WasteCode>
    <TrackableWasteFlag>true</TrackableWasteFlag>
  </OWTPOEOLicenceWaste>
  <OWTPOEOLicenceWaste>
    <InstrumentID>6089</InstrumentID>
    <WasteCode>J100</WasteCode>
    <TrackableWasteFlag>true</TrackableWasteFlag>
  </OWTPOEOLicenceWaste>
  <OWTPOEOLicenceWaste>
    <InstrumentID>6089</InstrumentID>
    <WasteCode>J120</WasteCode>
    <TrackableWasteFlag>true</TrackableWasteFlag>
  </OWTPOEOLicenceWaste>
  <OWTPOEOLicenceWaste>
    <InstrumentID>6089</InstrumentID>
    <WasteCode>N100</WasteCode>
    <TrackableWasteFlag>true</TrackableWasteFlag>
  </OWTPOEOLicenceWaste>
  <OWTPOEOLicenceWaste>
    <InstrumentID>6089</InstrumentID>
    <WasteCode>N220</WasteCode>
    <TrackableWasteFlag>true</TrackableWasteFlag>
  </OWTPOEOLicenceWaste>
  <OWTPOEOLicenceWaste>
    <InstrumentID>6089</InstrumentID>
    <WasteCode>R100</WasteCode>
    <TrackableWasteFlag>true</TrackableWasteFlag>
  </OWTPOEOLicenceWaste>
  <OWTPOEOLicenceWaste>
    <InstrumentID>6089</InstrumentID>
    <WasteCode>T120</WasteCode>
    <TrackableWasteFlag>true</TrackableWasteFlag>
  </OWTPOEOLicenceWaste>
</DataBatchJob> 
'

SET NOCOUNT ON;
	    declare @ReturnOldCustomerID  int
		set @ReturnOldCustomerID = 0

	    --@ProcessTypeID map to: ----------------------------------------
        --[DescriptionAttribute("New licence - premises")]
        --NewPremises = 1,
        --[DescriptionAttribute("New licence - transporter")]
        --NewTransporter = 2,

        --[DescriptionAttribute("Vary licence - premises")]
        --VaryPremises = 3,
        --[DescriptionAttribute("Vary licence - transporter")]
        --VaryTransporter = 4,

        --[DescriptionAttribute("Revoke licence -  premises")]
        --RevokePremises = 5,
        --[DescriptionAttribute("Revoke licence - transporter")]
        --RevokeTransporter = 6,

        --[DescriptionAttribute("Lift suspension - premises")]
        --SuspensionPremises = 7,
        --[DescriptionAttribute("Lift suspension - transporter")]
        --SuspensionTransporter = 8,

        --[DescriptionAttribute("Transfer licence - premises")]
        --TransferPremises = 9,
        --[DescriptionAttribute("Transfer licence - transporter")]
        --TransferTransporter = 10	
	    ------------------------------------------------------------------

	--we define the table type variables here
	DECLARE @tblOWTAccountablePartyType OWTAccountablePartyType	
	DECLARE @tblOWTLocationType OWTLocationType
	DECLARE @tblOWTContactType OWTContactType
	DECLARE @tblOWTPOEOLicenceWasteType OWTPOEOLicenceWasteType
    
	--1.Insert data into @tblOWTAccountablePartyType
	INSERT INTO @tblOWTAccountablePartyType(
			[InstrumentID],
			[AccountablePartyID],
			[TradingName],
			[ACN_ARBN],
			[ActiveFlag],
			[StreetAddress],
			[Suburb],
			[PostCode],
			[StateCode],
			[ProcessTypeID],
			[OldAccountablePartyFlag]
			)
	 SELECT  @InstrumentID AS InstrumentID,
	         RN.S.value('AccountablePartyID[1]','int') AS AccountablePartyID,
			 RN.S.value('TradingName[1]','varchar(255)') AS TradingName,
			 RN.S.value('ACN_ARBN[1]','varchar(15)') AS ACN_ARBN,				 	 
			 RN.S.value('ActiveFlag[1]','bit') AS ActiveFlag,
			 RN.S.value('StreetAddress[1]','varchar(100)') AS StreetAddress,			  
			 RN.S.value('Suburb[1]','varchar(50)') AS Suburb,	
			 RN.S.value('PostCode[1]','char(4)') AS PostCode,	
			 RN.S.value('StateCode[1]','varchar(4)') AS StateCode,				  
			 @ProcessTypeID AS ProcessTypeID,
			 RN.S.value('OldAccountablePartyFlag[1]','bit') AS OldAccountablePartyFlag
    FROM @theXmlData.nodes('/DataBatchJob/OWTAccountableParty') AS RN(S)	
	
	--2.Insert data into @tblOWTLocationType
	INSERT INTO @tblOWTLocationType(
			[InstrumentID],
			[LocationID],
			[SiteName],			 
			[StreetAddress],
			[Suburb],
			[PostCode],
			[StateCode],
			[ProcessTypeID])
	 SELECT  @InstrumentID AS InstrumentID,
	         RN.S.value('LocationID[1]','int') AS LocationID,
			 RN.S.value('SiteName[1]','varchar(255)') AS SiteName,			 
			 RN.S.value('StreetAddress[1]','varchar(100)') AS StreetAddress,			  
			 RN.S.value('Suburb[1]','varchar(50)') AS Suburb,	
			 RN.S.value('PostCode[1]','char(4)') AS PostCode,	
			 RN.S.value('StateCode[1]','varchar(4)') AS StateCode,				  
			 @ProcessTypeID AS ProcessTypeID 
    FROM @theXmlData.nodes('/DataBatchJob/OWTLocation') AS RN(S)			
	
	--3.Insert data into @tblOWTContactType
	INSERT INTO @tblOWTContactType(
			[InstrumentID],
			[ContactID],
			[TitleCodeID],
			[Surname],
			[Middlename],
			[GivenName],
			[OrganisationName],
			[Phone],
			[Mobile],
			[AfterHoursNumber],
			[Fax],
			[Email],
			[AddressID],
			[StreetAddress],
			[Suburb],
			[Postcode],
			[StateCode],	
			[ProcessTypeID])
	 SELECT  @InstrumentID AS InstrumentID,
	         RN.S.value('ContactID[1]','int') AS ContactID,
			 RN.S.value('TitleCodeID[1]','int') AS TitleCodeID,

			 RN.S.value('Surname[1]','varchar(50)') AS Surname,		
			 RN.S.value('Middlename[1]','varchar(50)') AS Middlename,	
			 RN.S.value('GivenName[1]','varchar(50)') AS GivenName,	
			 RN.S.value('OrganisationName[1]','varchar(128)') AS OrganisationName,	
			 RN.S.value('Phone[1]','varchar(20)') AS Phone,	
			 RN.S.value('Mobile[1]','varchar(20)') AS Mobile,	
			 RN.S.value('AfterHoursNumber[1]','varchar(20)') AS AfterHoursNumber,	
			 RN.S.value('Fax[1]','varchar(20)') AS Fax,	
			 RN.S.value('Email[1]','varchar(128)') AS Email,	
			 
			 RN.S.value('AddressID[1]','int') AS AddressID,	 
			 RN.S.value('StreetAddress[1]','varchar(100)') AS StreetAddress,			  
			 RN.S.value('Suburb[1]','varchar(50)') AS Suburb,	
			 RN.S.value('PostCode[1]','char(4)') AS PostCode,	
			 RN.S.value('StateCode[1]','varchar(4)') AS StateCode,				  
			 @ProcessTypeID AS ProcessTypeID 
    FROM @theXmlData.nodes('/DataBatchJob/OWTContact') AS RN(S)				 

	--4.Insert data into @tblOWTContactType
	INSERT INTO @tblOWTPOEOLicenceWasteType (WasteCode, TrackableWasteFlag)
	SELECT RN.S.value('WasteCode[1]','varchar(50)') AS WasteCode,
	       RN.S.value('TrackableWasteFlag[1]','bit') AS TrackableWasteFlag				 
    FROM @theXmlData.nodes('/DataBatchJob/OWTPOEOLicenceWaste') AS RN(S)	

    BEGIN TRY
		 	declare @CreatedBySystemUserID int = 1 
			declare @ResponsibleSystemUserID int  = 1
			declare @ReturnSiteID int = 0
			declare @ReturnAccountOperationID int = 0
			declare @ReturnOldAccountOperationID int = 0
			set @ReturnCustomerID = 0

			----------------------------------------- Start ProcessTypeID descriptions ---------------------------------------------
			--[DescriptionAttribute("New licence - premises")]
			--NewPremises = 1,
			--[DescriptionAttribute("New licence - transporter")]
			--NewTransporter = 2,

			--[DescriptionAttribute("Vary licence - premises")]
			--VaryPremises = 3,
			--[DescriptionAttribute("Vary licence - transporter")]
			--VaryTransporter = 4,

			--[DescriptionAttribute("Revoke licence -  premises")]
			--RevokePremises = 5,
			--[DescriptionAttribute("Revoke licence - transporter")]
			--RevokeTransporter = 6,

			--[DescriptionAttribute("Lift suspension - premises")]
			--SuspensionPremises = 7,
			--[DescriptionAttribute("Lift suspension - transporter")]
			--SuspensionTransporter = 8,

			--[DescriptionAttribute("Transfer licence - premises")]
			--TransferPremises = 9,
			--[DescriptionAttribute("Transfer licence - transporter")]
			--TransferTransporter = 10
			----------------------------------------- End ProcessTypeID descriptions -------------------------------------------------

			--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ Main Processes ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
			BEGIN TRANSACTION
				--Here we need check: Does licence allow receipt of trackable waste?
				declare @IsTrackableWaste bit = 0
				if exists(select * from @tblOWTPOEOLicenceWasteType where TrackableWasteFlag = 1)
					set @IsTrackableWaste = 1 --This will be used to check if licence allow receipt of trackable waste in SP: uspPALMSAccountOperationTypeCreateUpdate	

				if @ProcessTypeID = 1 OR @ProcessTypeID = 2 -- New licence - premises AND New licence - transporter
				begin
					--print '@ProcessTypeID = 1 or 2'	
					exec [dbo].[uspPALMSCustomerTypeCreateUpdate]  @tblOWTAccountablePartyType, @ReturnCustomerID out, @ReturnOldCustomerID out
					exec [dbo].[uspPALMSSiteTypeCreateUpdate]  @tblOWTLocationType, @ReturnSiteID out
					exec [dbo].[uspPALMSAccountOperationTypeCreateUpdate]  @InstrumentID, @ReturnCustomerID, @ReturnOldCustomerID, @ReturnSiteID, @tblOWTContactType, @IsTrackableWaste, @ReturnAccountOperationID out, @ReturnOldAccountOperationID out					 
					exec [dbo].[uspPALMSOWTWaste] @InstrumentID, @ProcessTypeID, @tblOWTPOEOLicenceWasteType, @ReturnOldAccountOperationID
				end	--end of: if @ProcessTypeID = 1 OR @ProcessTypeID = 2
				 
				----------------------------------------------------------------
				
				if @ProcessTypeID = 3 OR @ProcessTypeID = 4 --Vary licence - premises AND Vary licence - transporter
				begin
					print '@ProcessTypeID = 3 or 4'	 	 
					exec [dbo].[uspPALMSCustomerTypeCreateUpdate]  @tblOWTAccountablePartyType, @ReturnCustomerID out, @ReturnOldCustomerID out
					exec [dbo].[uspPALMSSiteTypeCreateUpdate]  @tblOWTLocationType, @ReturnSiteID out
					exec [dbo].[uspPALMSOWTCascadeUpdateCA] @InstrumentID, @ProcessTypeID
					
					if @ProcessTypeID = 3  --For vary premises licence because vary transport licence no need do anything on allowable wate codes
						exec [dbo].[uspPALMSOWTWaste] @InstrumentID, @ProcessTypeID, @tblOWTPOEOLicenceWasteType, @ReturnOldAccountOperationID	
							
					--Commented out the following line as we only create AccountOperation record inside SP: [uspPALMSOWTWaste]
					--Because it is under some conditions  Eric He 11-01-2016
					--exec [dbo].[uspPALMSAccountOperationTypeCreateUpdate]  @InstrumentID, @ReturnCustomerID, @ReturnOldCustomerID, @ReturnSiteID, @tblOWTContactType, @IsTrackableWaste, @ReturnAccountOperationID out, @ReturnOldAccountOperationID out								
				end --end of: if @ProcessTypeID = 3 OR @ProcessTypeID = 4 

				----------------------------------------------------------------

				if @ProcessTypeID = 5 OR @ProcessTypeID = 6 --Revoke licence - premises AND Revoke licence - transporter
				begin
					print '@ProcessTypeID = 5 or 6'	 	 
					exec [dbo].[uspPALMSCustomerTypeCreateUpdate]  @tblOWTAccountablePartyType, @ReturnCustomerID out, @ReturnOldCustomerID out
					exec [dbo].[uspPALMSSiteTypeCreateUpdate]  @tblOWTLocationType, @ReturnSiteID out
					exec [dbo].[uspPALMSAccountOperationTypeCreateUpdate]  @InstrumentID, @ReturnCustomerID, @ReturnOldCustomerID, @ReturnSiteID, @tblOWTContactType, @IsTrackableWaste, @ReturnAccountOperationID out, @ReturnOldAccountOperationID out
					exec [dbo].[uspPALMSOWTWaste] @InstrumentID, @ProcessTypeID, @tblOWTPOEOLicenceWasteType, @ReturnOldAccountOperationID
				end --end of: if @ProcessTypeID = 5 OR @ProcessTypeID = 6 

				----------------------------------------------------------------

				if @ProcessTypeID = 7 OR @ProcessTypeID = 8 --Lift suspension licence - premises AND Lift suspension licence - transporter
				begin
					print '@ProcessTypeID = 7 or 8'	 	 
					exec [dbo].[uspPALMSCustomerTypeCreateUpdate]  @tblOWTAccountablePartyType, @ReturnCustomerID out, @ReturnOldCustomerID out
					exec [dbo].[uspPALMSSiteTypeCreateUpdate]  @tblOWTLocationType, @ReturnSiteID out
					exec [dbo].[uspPALMSAccountOperationTypeCreateUpdate]  @InstrumentID, @ReturnCustomerID, @ReturnOldCustomerID, @ReturnSiteID, @tblOWTContactType, @IsTrackableWaste, @ReturnAccountOperationID out, @ReturnOldAccountOperationID out
					exec [dbo].[uspPALMSOWTWaste] @InstrumentID, @ProcessTypeID, @tblOWTPOEOLicenceWasteType, @ReturnOldAccountOperationID
				end --end of: if @ProcessTypeID = 7 OR @ProcessTypeID = 8 

				----------------------------------------------------------------

				if @ProcessTypeID = 9 OR @ProcessTypeID = 10 --Transfer licence - premises AND Transfer licence - transporter
				begin
					print '@ProcessTypeID = 9 or 10'	 
					exec [dbo].[uspPALMSCustomerTypeCreateUpdate]  @tblOWTAccountablePartyType, @ReturnCustomerID out, @ReturnOldCustomerID out
					exec [dbo].[uspPALMSSiteTypeCreateUpdate]  @tblOWTLocationType, @ReturnSiteID out
					exec [dbo].[uspPALMSAccountOperationTypeCreateUpdate]  @InstrumentID, @ReturnCustomerID, @ReturnOldCustomerID, @ReturnSiteID, @tblOWTContactType, @IsTrackableWaste, @ReturnAccountOperationID out, @ReturnOldAccountOperationID out
					

					declare @OldAccounOperationID int
					set @OldAccounOperationID = @ReturnOldAccountOperationID -- temp prupose please fix it shortly

					declare @NewAccounOperationID int 
					set @NewAccounOperationID = @ReturnAccountOperationID 

					--UspPALMSOWTSiteTransfer need process: Site Transfer function for consigor 
					exec [dbo].[uspPALMSOWTSiteTransfer] @ProcessTypeID, @OldAccounOperationID, @NewAccounOperationID
						
					--Transfer licence - premises: in this case we need do something on AccountOperation table
					if @ProcessTypeID = 9 
					begin	
					    print '@ProcessTypeID = 9'				    
						
						declare @PALMSAccountablePartyID int = 0
						select top 1 @PALMSAccountablePartyID = AccountablePartyID		   
						from @tblOWTAccountablePartyType
						WHERE OldAccountablePartyFlag = 0

						declare @AccountOperationRoleTypeID int
						set @AccountOperationRoleTypeID = 289 --receiver    

						declare @CustomerID int = 0
						select @CustomerID = CustomerID from Customer where PALMSAccountablePartyID = @PALMSAccountablePartyID
						 
						declare @IsRecordTypeReceiver bit
						select  @IsRecordTypeReceiver = [dbo].[ufn_PALMSReceiverRecordExist](@CustomerID, @ReturnSiteID) 

						--Commented out the following line as this check is not good enough even it is from Function Specifications
						--if @IsRecordTypeReceiver = 1  --this checking may not be reliable because we only use CustomerID and SiteID
						--we use the direct AccountOperation table check?  --288 : Consignor and 289 : Receiver and 290 : Transporter
						--Does receiver record exists in AccountOperation? old licence here 
						if exists(select AccountOperationID from AccountOperation where AccountOperationRoleTypeID = 289 and AccountOperationPermit = cast(@InstrumentID as varchar) and CustomerID = @ReturnOldCustomerID)
						begin
						    select @ReturnOldAccountOperationID = AccountOperationID from AccountOperation where AccountOperationRoleTypeID = 289 and AccountOperationPermit = cast(@InstrumentID as varchar) and CustomerID = @ReturnOldCustomerID
						    print 'we do the following processes - premises'	
							
							print '@ReturnCustomerID =' + cast(@ReturnCustomerID as varchar)
							print '@ReturnOldCustomerID =' + cast(@ReturnOldCustomerID as varchar)

							print '@ReturnAccountOperationID =' + cast(@ReturnAccountOperationID as varchar)
							print '@ReturnOldAccountOperationID =' + cast(@ReturnOldAccountOperationID as varchar)

						    --Delete all allowable waste codes (oldlicensee) 
							--DELETE FROM OWTAccountOperationWasteCode
							--WHERE AccountOperationID = @ReturnOldAccountOperationID

							select @OldAccounOperationID = @ReturnOldAccountOperationID 
						    --Delete receiver record in AccountOperation (old licensee)
							UPDATE AccountOperation set EffectiveDateTo = getdate() WHERE AccountOperationID = @ReturnOldAccountOperationID and AccountOperationRoleTypeID = @AccountOperationRoleTypeID -- here is 289 : receiver
							DELETE FROM OWTAccountOperationWasteCode where AccountOperationID = @ReturnOldAccountOperationID

							--we can not delete the below as The conflict occurred in database "WDS", table "dbo.OWTLevyInvoice", column 'AccountOperationID'.
							--DELETE FROM AccountOperation
							--WHERE AccountOperationID = @ReturnOldAccountOperationID and AccountOperationRoleTypeID = @AccountOperationRoleTypeID -- here is 289 : receiver
						
							declare @AfterHoursNumber        varchar(20)
							declare @Phone                   varchar(20)
							declare @Mobile                  varchar(20)
							select top 1
									@InstrumentID = InstrumentID,					 
									@Phone = Phone,
									@Mobile = Mobile,
									@AfterHoursNumber = AfterHoursNumber					   				   
							from @tblOWTContactType		 

							--Create receiver record in AccountOperation (new licensee)
							  if not exists(select AccountOperationID from AccountOperation where CustomerID = @CustomerID and AccountOperationPermit = cast(@InstrumentiD as varchar) and AccountOperationRoleTypeID = @AccountOperationRoleTypeID)
							  begin
								  insert into
								  dbo.AccountOperation
								  (
									CustomerID,
									SiteID,
									AccountOperationPermit,
									AccountOperationRoleTypeID,
									RegionCode,
									MaximumWasteTonnesPerYear,
									EmergencyContactPhoneNumber,
									ConsignmentAuthorisationCreateFlag,
									EffectiveDateFrom,
									EffectiveDateTo,
									DateCreated,
									CreatedBySystemUserID,
									CreatedIPAddress,
									DateUpdated,
									UpdatedBySystemUserID,
									UpdatedIPAddress,
									NSWLicenceFlag,
									ApprovalMultipleWasteCAFlag
								  )
								  select 
									@CustomerID as CustomerID,
									@ReturnSiteID as SiteID,
									cast(@InstrumentID as varchar) as AccountOperationPermit,
									@AccountOperationRoleTypeID as AccountOperationRoleTypeID,
									null as RegionCode,
									null as MaximumWasteTonnesPerYear,
									(case isnull(@AfterHoursNumber,  '') when '' then (case isnull(@Phone, '') when '' then (case isnull(@Mobile, '') when '' then '(00) 0000 0000' else @Mobile end) else @Phone end) else @AfterHoursNumber end) as EmergencyContactPhoneNumber,
									0 as ConsignmentAuthorisationCreateFlag,
									getdate() as EffectiveDateFrom,
									null as EffectiveDateTo,
									getdate() as DateCreated,
									@CreatedBySystemUserID as CreatedBySystemUserID,
									'' as CreatedIPAddress,
									getdate() as DateUpdated,
									1 as UpdatedBySystemUserID,
									'' as UpdatedIPAddress,
									1 as NSWLicenceFlag,
									0 as ApprovalMultipleWasteCAFlag

								  select @NewAccounOperationID = @@IDENTITY
							  end
							  else
							     select @NewAccounOperationID = AccountOperationID from AccountOperation where CustomerID = @CustomerID and AccountOperationPermit = cast(@InstrumentiD as varchar) and AccountOperationRoleTypeID = @AccountOperationRoleTypeID

							--Add PALMS waste codes to allowable waste codes in OWT (new licensee)
							  exec [dbo].[uspPALMSOWTWaste] @InstrumentID, @ProcessTypeID, @tblOWTPOEOLicenceWasteType, @ReturnOldAccountOperationID	

							print '@@ReturnOldAccountOperationID =' + cast(@ReturnOldAccountOperationID as varchar)
							print '@@NewAccounOperationID =' + cast(@NewAccounOperationID as varchar)
							print '@@@ProcessTypeID =' + cast(@ProcessTypeID as varchar)
							--uspPALMSOWTSiteTransfer need process: Site Transfer function for receiver ******************************* Need fix the following shortly ****************************
							  exec [dbo].[uspPALMSOWTSiteTransfer] @ProcessTypeID, @ReturnOldAccountOperationID, @NewAccounOperationID
						end
					end				 

					--Transfer licence - transporter: in this case we need do something on AccountOperation table
					if @ProcessTypeID = 10 
					begin
					   --It seems this SP: uspPALMSOWTSiteTransfer already did the following work which has been commented out
					   print 'we do the following processes - transporter'	
					   --Delete all allowable waste codes (oldlicensee) 
							  --DELETE FROM OWTAccountOperationWasteCode
							  --WHERE AccountOperationID = @ReturnOldAccountOperationID

					   --Add all waste codes to allowable waste codes in OWT (new licensee)
					    
					end
				end --end of: if @ProcessTypeID = 9 OR @ProcessTypeID = 10 
							 
			COMMIT TRANSACTION 
			--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ End of Main Processes +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	END TRY
	
	BEGIN CATCH
			DECLARE @ErrorMessage VARCHAR(2000)
			SET @ErrorMessage = dbo.ufn_GetErrorTextPALMS()
			RAISERROR (@ErrorMessage , 16, 1)
			ROLLBACK TRANSACTION 

	END CATCH
 