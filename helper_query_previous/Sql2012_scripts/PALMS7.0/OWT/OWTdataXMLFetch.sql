declare @InstrumentID            int
declare @theXMLData              XML
declare @ProcessTypeID           int	  
declare @ReturnCustomerID        INT  

set @InstrumentID = 20556
set @theXMLData = 
'
<DataBatchJob>
  <OWTAccountableParty>
    <InstrumentID>20556</InstrumentID>
    <AccountablePartyID>4722</AccountablePartyID>
    <TradingName>DP WORLD SYDNEY LIMITED</TradingName>
    <ACN_ARBN />
    <ActiveFlag>true</ActiveFlag>
    <StreetAddress>PO Box 192</StreetAddress>
    <Suburb>MATRAVILLE</Suburb>
    <PostCode>2036</PostCode>
    <StateCode>NSW</StateCode>
  </OWTAccountableParty>
  <OWTLocation>
    <InstrumentID>20556</InstrumentID>
    <LocationID>4299</LocationID>
    <SiteName>DP WORLD SYDNEY LIMITED</SiteName>
    <StreetAddress>42 Friendship Drive</StreetAddress>
    <Suburb>PORT BOTANY</Suburb>
    <PostCode>2036</PostCode>
    <StateCode>NSW</StateCode>
  </OWTLocation>
  <OWTContact>
    <ContactID>13710</ContactID>
    <TitleCodeID>7</TitleCodeID>
    <Surname>Sansom</Surname>
    <Middlename />
    <GivenName>Gavin</GivenName>
    <OrganisationName>DP WORLD SYDNEY LIMITED </OrganisationName>
    <Phone>(02) 9394 0997</Phone>
    <Mobile>0401 148597</Mobile>
    <AfterHoursNumber />
    <Fax>(02) 9394 0940</Fax>
    <Email />
    <AddressID>18417</AddressID>
    <StreetAddress>PO Box 192</StreetAddress>
    <Suburb>MATRAVILLE</Suburb>
    <PostCode>2036</PostCode>
    <StateCode>NSW</StateCode>
  </OWTContact>
</DataBatchJob>
'

set @ProcessTypeID = 1
set @ReturnCustomerID = 0

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
			[ProcessTypeID])
	 SELECT  @InstrumentID AS InstrumentID,
	         RN.S.value('AccountablePartyID[1]','int') AS AccountablePartyID,
			 RN.S.value('TradingName[1]','varchar(255)') AS TradingName,
			 RN.S.value('ACN_ARBN[1]','varchar(15)') AS ACN_ARBN,				 	 
			 RN.S.value('ActiveFlag[1]','bit') AS ActiveFlag,
			 RN.S.value('StreetAddress[1]','varchar(100)') AS StreetAddress,			  
			 RN.S.value('Suburb[1]','varchar(50)') AS Suburb,	
			 RN.S.value('PostCode[1]','char(4)') AS PostCode,	
			 RN.S.value('StateCode[1]','varchar(4)') AS StateCode,				  
			 @ProcessTypeID AS ProcessTypeID 
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
	INSERT INTO @tblOWTPOEOLicenceWasteType (WasteCode)
	 SELECT RN.S.value('WasteCode[1]','varchar(50)') AS WasteCode				 
     FROM @theXmlData.nodes('/DataBatchJob/OWTPOEOLicenceWaste') AS RN(S)	

 
			 
select * from @tblOWTAccountablePartyType
select * from @tblOWTLocationType
select * from @tblOWTContactType
select * from @tblOWTPOEOLicenceWasteType

    BEGIN TRY
		 	declare @CreatedBySystemUserID int = 1 
			declare @ResponsibleSystemUserID int  = 1
			declare @ReturnSiteID int = 0
			declare @ReturnAccountOperationID int = 0

			set @ReturnCustomerID = 0
			 
			BEGIN TRANSACTION
			
				if @ProcessTypeID = 1 -- New licence - premises
				begin
				  print '@ProcessTypeID = 1'	
				  exec [dbo].[uspPALMSCustomerTypeCreateUpdate]  @tblOWTAccountablePartyType, @ReturnCustomerID out
				  exec [dbo].[uspPALMSSiteTypeCreateUpdate]  @tblOWTLocationType, @ReturnSiteID out

print '@@ReturnCustomerID =' + cast(@ReturnCustomerID as varchar)	
print '@@ReturnSiteID = 1'	
				  exec [dbo].[uspPALMSAccountOperationTypeCreateUpdate]  @InstrumentID, @ReturnCustomerID, @ReturnSiteID, @tblOWTContactType, @ReturnAccountOperationID out
				  --exec [dbo].[uspPALMSOWTWaste] @InstrumentID, @ProcessTypeID, @tblOWTPOEOLicenceWasteType
				end	--end of: if @ProcessTypeID = 1
						
				if @ProcessTypeID = 2 -- New licence - transporter
				begin
				   print '@ProcessTypeID = 2'	 
				end	--end of: if @ProcessTypeID = 2
				
				if @ProcessTypeID = 3 OR @ProcessTypeID = 4 --Vary licence - premises AND Vary licence - transporter
				begin
				   print '@ProcessTypeID = 3 or 4'	 	 
				end --end of: if @ProcessTypeID = 3 OR @ProcessTypeID = 4 
							 
			COMMIT TRANSACTION 
	END TRY
	
	BEGIN CATCH
			DECLARE @ErrorMessage VARCHAR(2000)
			SET @ErrorMessage = dbo.ufn_GetErrorTextPALMS()
			RAISERROR (@ErrorMessage , 16, 1)
			ROLLBACK TRANSACTION 

	END CATCH
 