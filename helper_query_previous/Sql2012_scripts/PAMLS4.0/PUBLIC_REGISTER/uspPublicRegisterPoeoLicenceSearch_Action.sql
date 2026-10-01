 
DECLARE @xmlSearchCriteria XML
DECLARE @NoOfRecordsRequired int
DECLARE @MaxRecordsExport int
DECLARE @ToExport BIT = 0

--here we set all search conditions: <DataSearch>\r\n  <PrimarySearchCriteria>\r\n    <LicenseNo>1010204</LicenseNo>\r\n  </PrimarySearchCriteria>\r\n</DataSearch>
SET @xmlSearchCriteria = '<DataSearch>\r\n  <PrimarySearchCriteria>\r\n    <LicenseStatus>3</LicenseStatus>\r\n  </PrimarySearchCriteria>\r\n</DataSearch>'

--SET @xmlSearchCriteria = '<DataSearch>\r\n  <PrimarySearchCriteria>\r\n<LicenseType>2</LicenseType>\r\n<APName>EMOLEUM ROAD</APName>\r\n</PrimarySearchCriteria>\r\n</DataSearch>'
SET @NoOfRecordsRequired = 5000
SET @MaxRecordsExport = 5000
SET @ToExport = 0


		DECLARE 
				@LicenseNo as int, 
				@LicenseType as int, 
				@LicenseStatus as int, 
				@ResponsibleOfficer as Varchar(120),
				@APName as Varchar(100), 							
				@FeeBasedActID as int,				
				@LGAID as int, 
				@CatchmentID as int, 								
				@Suburb as Varchar(100),
				@Location as Varchar(100),
				@TradingName as Varchar(100), 
				@Postcode as int,				
				@StreetName as Varchar(100)		
		SELECT 
			@LicenseNo = xmlVals.rowvals.value('(LicenseNo)[1]','INT'),
			@LicenseType = xmlVals.rowvals.value('(LicenseType)[1]','INT'),
			@LicenseStatus = xmlVals.rowvals.value('(LicenseStatus)[1]','INT'),			 
			@FeeBasedActID = xmlVals.rowvals.value('(FeeBasedActID)[1]','INT'),			 
			@LGAID = xmlVals.rowvals.value('(LGAID)[1]','INT'),
			@CatchmentID = xmlVals.rowvals.value('(CatchmentID)[1]','INT'),			 
			@Suburb = xmlVals.rowvals.value('(Suburb)[1]','VARCHAR(100)'),
			@StreetName = xmlVals.rowvals.value('(StreetName)[1]','VARCHAR(100)'),
			@Location = xmlVals.rowvals.value('(Location)[1]','VARCHAR(100)'),
			@TradingName = xmlVals.rowvals.value('(TradingName)[1]','VARCHAR(100)'),
			@Postcode = xmlVals.rowvals.value('(Postcode)[1]','INT'),			 
			@APName = xmlVals.rowvals.value('(APName)[1]','VARCHAR(100)')		
		From @xmlSearchCriteria.nodes('//DataSearch/PrimarySearchCriteria') as xmlVals(rowvals)								
		
		--Enable TradingName search for public registery 
		--We get its value from @APName
		
		SET @TradingName = @APName
		
		SET @APName = ISNULL(@APName, '');
		SET @APName = '%' + rtrim(ltrim(@APName)) + '%'	;	
			
		SET @TradingName = ISNULL(@TradingName, '');
		SET @TradingName = '%' + rtrim(ltrim(@TradingName)) + '%'	;
		
		SET @Location = ISNULL(@Location, '');
		SET @Location = '%' + rtrim(ltrim(@Location)) + '%'	;
		SET @Suburb = ISNULL(@Suburb, '');
		SET @Suburb = '%' + rtrim(ltrim(@Suburb)) + '%'	;
		SET @StreetName = ISNULL(@StreetName, '');
		SET @StreetName = '%' + rtrim(ltrim(@StreetName)) + '%'	;
		
		
		DECLARE @StatusTable Table(InstrumentID int)
		
		Declare  @StatusFilterCount int
		Set @StatusFilterCount = 0
		
		
		Declare @InstrumentAllRows Table 
		(
			InstrumentID int,
			StatusID int
		)
		
		Insert Into @InstrumentAllRows
		(
			InstrumentID,
			StatusID
		)
		SELECT 	DISTINCT
			I.InstrumentID,
			I.InstrumentStatusID 
		FROM tblClassification C 
				INNER JOIN tblInstrument I 
				ON C.ClassificationID = I.InstrumentTypeID
				LEFT OUTER JOIN tblClassification C2 
					ON C2.ClassificationID = I.InstrumentStatusID
				LEFT OUTER JOIN tblPOEOLicence P
					ON I.InstrumentID = P.InstrumentID
				LEFT OUTER JOIN tblSystemUser U
					ON U.SystemUserID = I.ResponsibleSystemUserID
				LEFT OUTER JOIN tblInstrumentAccountableParty IAP
					ON IAP.InstrumentID = I.InstrumentID
				LEFT OUTER JOIN viewInstrumentAccountableParty AP
					ON IAP.AccountablePartyID = AP.AccountablePartyID
				LEFT OUTER JOIN tblPOEOLicenceFeeBasedActivity LFBA
					ON LFBA.InstrumentID = I.InstrumentID
				LEFT OUTER JOIN tblFeeBasedActivity FBA
					ON FBA.FeeBasedActivityID = LFBA.FeeBasedActivityID
				LEFT OUTER JOIN tblPOEOLicenceScheduledActivity LSA
					ON LSA.InstrumentID = I.InstrumentID
				LEFT OUTER JOIN tblActivityGroup AG
					ON LSA.ActivityGroupID = AG.ActivityGroupID
				LEFT OUTER JOIN tblDECCWSection DS
					ON DS.DECCWSectionID = I.DECCWSectionID
				LEFT OUTER JOIN tblInstrumentLocation IL
					ON IL.InstrumentID =  I.InstrumentID
				LEFT OUTER JOIN tblLocation L
					ON IL.LocationID = L.LocationID
				LEFT OUTER JOIN tblAddress A
					ON 	A.AddressID = L.AddressID			
				LEFT OUTER JOIN tblLandTitle LT
					ON L.LocationID = LT.LocationID
				LEFT OUTER JOIN tblLandTitleElectorate LTE
					ON LTE.LandTitleID = LT.LandTitleID
				LEFT OUTER JOIN viewElectorate VE
					ON LTE.ElectorateID = VE.ELECTORATE_ID	
				LEFT OUTER JOIN	tblLandTitleLGA LTL 
					ON LT.LandTitleID = LTL.LandTitleID
				LEFT OUTER JOIN viewLGA VL
					ON VL.LGAID = LTL.LGAID
				LEFT OUTER JOIN tblLandTitleCatchment LTC
					ON LTC.LandTitleID = LT.LandTitleID
				LEFT OUTER JOIN viewCatchment VC
					ON LTC.CatchmentID = VC.CATCHMENT_ID
		WHERE 		
				(
					C.ClassificationDomainID = 35
				)
				AND
				(
					@FeeBasedActID IS NULL OR @FeeBasedActID = 0
					OR (FBA.FeeBasedActivityID = @FeeBasedActID)
				)
				AND
				(
					@LicenseStatus IS NULL OR @LicenseStatus = 0
					OR (I.InstrumentStatusID = @LicenseStatus)
				)				
				AND
				(
					@LicenseNo IS NULL OR @LicenseNo = 0 
					OR
					I.InstrumentID = @LicenseNo
				)		 
				AND
				(
					@LGAID IS NULL OR @LGAID = 0
					OR (LTL.LGAID = @LGAID)
				)
				AND
				(	
					@CatchmentID IS NULL OR @CatchmentID =0
					OR (LTC.CatchmentID = @CatchmentID)
				)
				 
				AND
				(
					@Suburb IS NULL OR @Suburb = ''
					OR (PATINDEX(@Suburb, isnull(A.Suburb, '')) > 0)
				)
				AND
				(
					@Location IS NULL OR @Location = ''
					OR (PATINDEX(@Location, ISNULL(L.LocationName,'')) > 0)
				)
				AND
				(
					@Postcode IS NULL OR @Postcode = ''
					OR (A.Postcode = @Postcode)
				)				
				AND
				(
						(
							@APName IS NULL OR @APName = ''
							OR patindex(@APName, ISNULL(AP.APName, '')) > 0
						)
						OR
						(
							@TradingName IS NULL OR @TradingName = ''
							OR patindex(@TradingName, isnull(AP.TradingName, '')) > 0				    
						)
				)
				AND
				(
					@StreetName IS NULL OR @StreetName = ''
					OR patindex(@StreetName, isnull(A.[Address], '')) > 0
				)					
		
			
			IF((Select COUNT(InstrumentID) from @InstrumentAllRows) = 0)
			Begin
				Insert @InstrumentAllRows
				(InstrumentID)Select 0	
			End
			

			
			Declare @InstrumentResultRows Table
			(
				InstrumentTypeID int null, 
				InstrumentID int null, 
				InstrumentStatusID int null, 
				InstrumentStatus Varchar(100) null,
				DateIssued DateTime null,
				ResponsibleSystemUserID int null,				
				AccountablePartyID int null,
				AccountableParty varchar(128) null,				
				TradingName varchar(128) null,
				LocationName varchar(128) null,
				[Address] varchar(100) null,
				Suburb varchar(60) null,
				Postcode varchar(4) null,
				LocationID int null,			
				Catchment Varchar(100),				
				LocationFull Varchar(200),
				RecordType Varchar(255)	
			)
			


			
			IF(NOT(Select COUNT(InstrumentID) from @InstrumentAllRows) > @NoOfRecordsRequired OR @ToExport = 1)
				BEGIN
					 
					Insert Into @InstrumentResultRows
					(
						InstrumentTypeID, 
						InstrumentID, 
						InstrumentStatusID, 
						InstrumentStatus,
						DateIssued,
						ResponsibleSystemUserID,				
						AccountablePartyID,
						AccountableParty,				
						TradingName,
						LocationName,
						[Address],
						Suburb,
						Postcode,
						LocationID,							
						LocationFull,
						RecordType
					)
					SELECT DISTINCT	
						I.InstrumentTypeID, 
						I.InstrumentID, 
						I.InstrumentStatusID, 						
						C2.Name,
						I.DateIssued,
						I.ResponsibleSystemUserID,				
						IAP.AccountablePartyID,
						(CASE WHEN AP.CompanyFlag = 1 THEN AP.OrganisationName ELSE AP.GivenName + ' ' + AP.Surname END) AccountableParty,				
						AP.TradingName,
						L.LocationName,
						A.[Address],
						A.Suburb,
						A.Postcode,
						L.LocationID,						
						(CASE WHEN ISNULL(A.[Address], '') = '' THEN '' ELSE A.[Address] + ', ' END) +
						(CASE WHEN ISNULL(A.[Suburb], '') = '' THEN '' ELSE A.[Suburb] + ', ' END) +			
						(CASE WHEN ISNULL(A.[StateCode], '') = '' THEN '' ELSE A.[StateCode] + ' ' END) +
						(CASE WHEN ISNULL(A.[Postcode], '') = '' THEN '' ELSE A.[Postcode] + '' END) AS LocationFull,	
						C.Name as RecordType
						FROM tblClassification C 
						INNER JOIN tblInstrument I 
							ON C.ClassificationID = I.InstrumentTypeID
						LEFT OUTER JOIN tblClassification C2 
							ON C2.ClassificationID = I.InstrumentStatusID
						LEFT OUTER JOIN tblPOEOLicence P
							ON I.InstrumentID = P.InstrumentID
						LEFT OUTER JOIN tblSystemUser U
							ON U.SystemUserID = I.ResponsibleSystemUserID
						--LEFT OUTER JOIN tblInstrumentAccountableParty IAP
						--	ON IAP.AccountablePartyID = (Select MAX(IAP1.AccountablePartyID) from tblInstrumentAccountableParty IAP1
						--							Where IAP1.InstrumentID = I.InstrumentID)
						LEFT OUTER JOIN tblInstrumentAccountableParty IAP
							ON IAP.InstrumentAccountablePartyID = (Select MIN(IAP1.InstrumentAccountablePartyID) from tblInstrumentAccountableParty IAP1
													Where IAP1.InstrumentID = I.InstrumentID)
						LEFT OUTER JOIN tblAccountableParty AP
							ON IAP.AccountablePartyID = AP.AccountablePartyID
						LEFT OUTER JOIN tblInstrumentLocation IL
							ON IL.InstrumentLocationID = (Select MIN(IL1.InstrumentLocationID) from tblInstrumentLocation IL1
												Where IL1.InstrumentID = I.InstrumentID)
						LEFT OUTER JOIN tblLocation L
							ON IL.LocationID = L.LocationID
						LEFT OUTER JOIN tblAddress A
							ON 	A.AddressID = L.AddressID											
					WHERE 		
						(
							C.ClassificationDomainID = 35
						)
						AND
						(
							@LicenseNo IS NULL OR @LicenseNo =0
							OR (I.InstrumentID = @LicenseNo)
						)	
						AND
						(
							@LicenseStatus IS NULL OR @LicenseStatus = 0
							OR (I.InstrumentStatusID = @LicenseStatus)
						)
						AND
						(
							@LicenseType IS NULL OR @LicenseType =0
							OR (I.InstrumentTypeID = @LicenseType)
						)
						AND
						(
							@StatusFilterCount = 0
							OR
							(
								I.InstrumentID IN(Select InstrumentID from @StatusTable)					
							)	
						)	
						AND
						(	
							
							I.InstrumentID IN(Select InstrumentID from @InstrumentAllRows)
						)	
						
						
						SELECT TOP(@MaxRecordsExport) A.*, 0 as PINNumber FROM @InstrumentResultRows A
															
						END
				
			Else
				Begin
					Select 
						0 InstrumentTypeID, 
						0 InstrumentID, 
						0 InstrumentStatusID, 
						0 InstrumentStatus,
						0 ResponsibleSystemUserID
				End
				
			Delete @StatusTable
			Delete @InstrumentResultRows
			Delete @InstrumentAllRows