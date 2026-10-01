declare @xmlSearchCriteria xml =
'
<DataPRSearch>
  <PrimarySearchCriteria>
    <LicenseType>1</LicenseType>
    <LicenseStatus>755</LicenseStatus>
  </PrimarySearchCriteria>
</DataPRSearch>
'
declare @ToExport bit = 0
declare @MaxRecordsExport int = 5000
declare @NoOfRecordsRequired int = 500


		    --1. Get all search criteria from XML
			DECLARE @LicenseNo as int, 
					@LicenseType as int, 
					@LicenseStatus as int, 			 
					@APName as Varchar(100), 				 
					@LicenseReviewFrom as DateTime, 
					@LicenseReviewTo as DateTime,
					@StatusFromDate as DateTime, 
					@StatusToDate as DateTime, 				 
					@ResponsibleOfficerID as int,
					@Suburb as Varchar(100),				 
					@TradingName as Varchar(100), 
					@Postcode as int,			 
					@FilterCount as int, 				 
					@RadiationLicenceTypeID as int, 
					@ExpiryDateFrom as DateTime, 
					@ExpiryDateTo as DateTime, 			 
					@DGLicenceNo as Varchar(100),
					@DGVehicleID as int,
					@DGRegoNumber as Varchar(100) 
			SELECT 
				@LicenseNo = xmlVals.rowvals.value('(LicenseNo)[1]','INT'),
				@LicenseType = xmlVals.rowvals.value('(LicenseType)[1]','INT'),
				@LicenseStatus = xmlVals.rowvals.value('(LicenseStatus)[1]','INT'),
				@LicenseReviewFrom = xmlVals.rowvals.value('(LicenseReviewFrom)[1]','datetimeoffset'),
				@LicenseReviewTo = xmlVals.rowvals.value('(LicenseReviewTo)[1]','datetimeoffset'),			 
				@Suburb = xmlVals.rowvals.value('(Suburb)[1]','VARCHAR(100)'),			 
				@TradingName = xmlVals.rowvals.value('(TradingName)[1]','VARCHAR(100)'),
				@Postcode = xmlVals.rowvals.value('(Postcode)[1]','INT'),			 
				@APName = xmlVals.rowvals.value('(APName)[1]','VARCHAR(100)'),			 
				@StatusFromDate = xmlVals.rowvals.value('(StatusFromDate)[1]','datetimeoffset'),
				@StatusToDate = xmlVals.rowvals.value('(StatusToDate)[1]','datetimeoffset'),			 
				@RadiationLicenceTypeID = xmlVals.rowvals.value('(RadiationLicenceTypeID)[1]','INT'),   ------------ PALMS V5.0
				@ExpiryDateFrom = xmlVals.rowvals.value('(ExpiryDateFrom)[1]','DateTime'),
				@ExpiryDateTo = xmlVals.rowvals.value('(ExpiryDateTo)[1]','DateTime'),	 
				@DGLicenceNo = xmlVals.rowvals.value('(DGLicenceNo)[1]','VARCHAR(100)'),
				@DGVehicleID = xmlVals.rowvals.value('(DGVehicleID)[1]','INT'),
				@DGRegoNumber = xmlVals.rowvals.value('(DGRegoNumber)[1]','VARCHAR(100)') 			 
			From @xmlSearchCriteria.nodes('//DataPRSearch/PrimarySearchCriteria') as xmlVals(rowvals)					 
			 
			--2. Initialize those search criteria values
			SET @LicenseNo = ISNULL(@LicenseNo, 0);	
			SET @LicenseType = ISNULL(@LicenseType, 0)
			SET @LicenseStatus = ISNULL(@LicenseStatus, 0)

			SET @Suburb = ISNULL(@Suburb, '');		 
			SET @TradingName = ISNULL(@TradingName, '');		 			
			SET @APName = ISNULL(@APName, '');	 
			SET @TradingName = ISNULL(@TradingName, '');
			SET @DGRegoNumber = ISNULL(@DGRegoNumber, '');
			 
            --3 Build the basic query strings
		DECLARE @strSearchCriteria nvarchar(MAX)
		SELECT @strSearchCriteria =N'		
			    SELECT DISTINCT
				I.InstrumentID 
		        FROM tblInstrument I 
		        LEFT OUTER JOIN tblTransporterLicence RL ON RL.InstrumentID = I.InstrumentID		 		 
		        INNER JOIN tblClassification C  
					ON C.ClassificationID = I.InstrumentTypeID
				LEFT OUTER JOIN tblClassification C2 
					ON C2.ClassificationID = I.InstrumentStatusID
				LEFT OUTER JOIN tblSystemUser U
					ON U.SystemUserID = I.ResponsibleSystemUserID
				LEFT OUTER JOIN tblInstrumentAccountableParty IAP
					ON IAP.InstrumentAccountablePartyID = (Select MIN(IAP1.InstrumentAccountablePartyID) from tblInstrumentAccountableParty IAP1
											Where IAP1.InstrumentID = I.InstrumentID)
				LEFT OUTER JOIN tblAccountableParty AP
					ON IAP.AccountablePartyID = AP.AccountablePartyID				 				 		
				LEFT OUTER JOIN tblClassification RadiationLicType
					ON RL.LicenceTypeID = RadiationLicType.ClassificationID
				LEFT OUTER JOIN tblDGLicenceVehicle a ON RL.InstrumentID = a.InstrumentID
				LEFT OUTER JOIN tblDGVehicle b on a.DGVehicleID = (select MIN(b1.DGVehicleID) from tblDGVehicle b1 where b1.DGVehicleID=b.DGVehicleID)	                
				LEFT OUTER JOIN tblInstrumentNotice [IN]
					ON [IN].NoticeInstrumentID = I.InstrumentID
			    LEFT OUTER JOIN tblNotice N
					ON [I].InstrumentID = N.InstrumentID
				LEFT OUTER JOIN tblOnlineLicenceChangeApplication OLC ON [IN].NoticeInstrumentID = OLC.NoticeInstrumentID 

				LEFT OUTER JOIN tblInstrument I2 ON [IN].InstrumentID = I2.InstrumentID
				LEFT OUTER JOIN tblAddress [ADD] ON AP.AddressID = [ADD].AddressID
				WHERE I.InstrumentID > 0 and (I.InstrumentTypeID = 1417 or I2.InstrumentTypeID = 1417) AND I.InstrumentStatusID in (755,757,758,797,816, 566, 11) '

		DECLARE @whereClause0 AS nvarchar(MAX)                        
		SET  @whereClause0 = N''

		IF @LicenseNo > 0
		BEGIN
		    --If the licence number is presented then no more other search necessary
			SET @whereClause0 = @whereClause0 +  ' AND I.InstrumentID = ' + convert(varchar, @LicenseNo)
		END 
		ELSE
		BEGIN
			IF @LicenseStatus > 0
			BEGIN
				SET @whereClause0 = @whereClause0 +  ' AND I.InstrumentStatusID = ' + convert(varchar, @LicenseStatus)
			END 

			IF @RadiationLicenceTypeID > 0
			BEGIN
				SET @whereClause0 = @whereClause0 +  ' AND RL.LicenceTypeID = ' + convert(varchar, @RadiationLicenceTypeID)
			END

			IF @APName IS NOT NULL and LEN(@APName) > 0  
			BEGIN
					SET @whereClause0 = @whereClause0 +  ' AND AP.OrganisationName  like ''%' + convert(varchar, @APName) + '%'' ' 
			END					
					
			IF @TradingName IS NOT NULL and LEN(@TradingName) > 0  
			BEGIN
					SET @whereClause0 = @whereClause0 +  ' AND AP.TradingName  like ''%' + convert(varchar, @TradingName) + '%'' ' 
			END		

			IF @Suburb IS NOT NULL and LEN(@Suburb) > 0  
			BEGIN
					SET @whereClause0 = @whereClause0 +  ' AND [ADD].Suburb  like ''%' + convert(varchar, @Suburb) + '%'' ' 
			END		

			IF @DGRegoNumber IS NOT NULL and LEN(@DGRegoNumber) > 0  
			BEGIN
					SET @whereClause0 = @whereClause0 +  ' AND b.RegistrationNumber  like ''%' + convert(varchar, @DGRegoNumber) + '%'' ' 
			END	
		END
        set @strSearchCriteria = @strSearchCriteria + @whereClause0 

		Declare @ResultRowsCount Table
		(	
			SNo int IDENTITY(1,1),  
			InstrumentID int null 											
		)

		Insert Into @ResultRowsCount 
		(
		  InstrumentID
		)
		EXEC sp_executesql @strSearchCriteria;	

		--*************************** to be deleted ***************************
        select * from @ResultRowsCount
		--*************************** to be deleted ***************************

		DECLARE @NoOfRecords as int	
		SELECT @NoOfRecords=isnull(COUNT(InstrumentID), 0) from @ResultRowsCount


		Create Table #InstrumentResultRows
		(
		    InstrumentID int null, 
			InstrumentStatusID int null, 
			InstrumentStatus Varchar(100) null,			
			DGLicenceTypeID int null ,
			AccountablePartyID int null,
			AccountableParty varchar(128) null,
			InstrumentTypeID int null, 
			InstrumentType VARCHAR(100) null,
			TradingName varchar(128) null,
			RadiationLicenceType VARCHAR(200) null,
			LastUpdated varchar(50) null,
			DateIssued DateTime null,
			RadiationLicenceExpiryDate Date null,
			ResponsibleSystemUserID int null,
			ResponsibleOfficer Varchar(128) null,            
			LocationID int null,
			LocationName varchar(128) null,
			[Address] varchar(100) null,
			Suburb varchar(60) null,
			Postcode varchar(4) null,
			RowCountTotal int null 
		)



		IF(@ToExport = 1)
		BEGIN
				SELECT DISTINCT TOP (@MaxRecordsExport)
							APNo,
							APName,
							Email, 
							ABN,
							ACN,
							FirstName,
							LastName,
							Recordno,
							UserProfile,
							Organisationname,
							TradingName, 
							RecordType,					 									 				 
							RowCountTotal											  
						FROM @ResultRowsFinal  
						ORDER BY APNo	
		END
		ELSE			
			IF (@NoOfRecords <= @NoOfRecordsRequired)
			  BEGIN
			     
				SELECT TOP (@pageSize) *  FROM @ResultRowsFinal 
				WHERE SNo NOT IN  
				( SELECT TOP ((@pageNum - 1) * (@pageSize)) SNo FROM @ResultRowsFinal order by SNo )	
				order by SNo						
			  END		
			ELSE	
				SELECT 
					'0' as [APno], 
					'0' as [APname],
					'0' as [Postaladdress],
					'0' as [Recordno],
					'0' as [Recordtype], 
					'0' as [Section], 					 
					'0' as [Streetname],
					'0' as [Suburb]		
					
					
					
    				