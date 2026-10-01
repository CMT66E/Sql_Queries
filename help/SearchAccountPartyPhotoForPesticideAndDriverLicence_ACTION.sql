declare @xmlSearchCriteria XML
set @xmlSearchCriteria =
'<DataAccountableParty>
  <SearchCriteria>
    <AccountablePartyNo>0</AccountablePartyNo>
    <TradingName />
    <ABN />
    <FirstName />
    <LastName>sh</LastName>
    <PostalAddress />
    <PrimaryRecordType>818</PrimaryRecordType>
    <PrimaryRecordNo>0</PrimaryRecordNo>
    <ACN />
  </SearchCriteria>
</DataAccountableParty>
'
declare @NoOfRecordsRequired int
set @NoOfRecordsRequired = 500

declare @MaxRecordsExport int
set @MaxRecordsExport = 5000

declare @ToExport BIT = 0
declare @pageSize int = 50
declare @pageNum int = 1

 DECLARE @FirstName AS VARCHAR(60), @LastName AS VARCHAR(60),@AccountablePartyNo AS INT,@PostalAddress AS VARCHAR(200),
				@TradingName AS VARCHAR(128),@ABN AS VARCHAR(14), @RecordType as INT, @RecordNo as INT, @ACN AS VARCHAR(20),@SubRecordType as INT
		
		
		SET @FirstName = (SELECT xmlVals.rowvals.query('FirstName').value('.','VARCHAR(60)') From @xmlSearchCriteria.nodes('//DataAccountableParty/SearchCriteria') as xmlVals(rowvals))
		SET @LastName = (SELECT xmlVals.rowvals.query('LastName').value('.','VARCHAR(60)') From @xmlSearchCriteria.nodes('//DataAccountableParty/SearchCriteria') as xmlVals(rowvals))
		SET @AccountablePartyNo = (SELECT xmlVals.rowvals.query('AccountablePartyNo').value('.','INT') From @xmlSearchCriteria.nodes('//DataAccountableParty/SearchCriteria') as xmlVals(rowvals))
		SET @PostalAddress = (SELECT xmlVals.rowvals.query('PostalAddress').value('.','VARCHAR(200)') From @xmlSearchCriteria.nodes('//DataAccountableParty/SearchCriteria') as xmlVals(rowvals))
		SET @TradingName = (SELECT xmlVals.rowvals.query('TradingName').value('.','VARCHAR(128)') From @xmlSearchCriteria.nodes('//DataAccountableParty/SearchCriteria') as xmlVals(rowvals))
		SET @ABN = (SELECT xmlVals.rowvals.query('ABN').value('.','VARCHAR(14)') From @xmlSearchCriteria.nodes('//DataAccountableParty/SearchCriteria') as xmlVals(rowvals))
		SET @RecordType = (SELECT xmlVals.rowvals.query('PrimaryRecordType').value('.','INT') From @xmlSearchCriteria.nodes('//DataAccountableParty/SearchCriteria') as xmlVals(rowvals))
		SET @RecordNo = (SELECT xmlVals.rowvals.query('PrimaryRecordNo').value('.','INT') From @xmlSearchCriteria.nodes('//DataAccountableParty/SearchCriteria') as xmlVals(rowvals))

		SET @SubRecordType = (SELECT xmlVals.rowvals.query('SubRecordType').value('.','INT') From @xmlSearchCriteria.nodes('//DataAccountableParty/SearchCriteria') as xmlVals(rowvals))

		--PALMS V1.3
		SET @ACN = (SELECT xmlVals.rowvals.query('ACN').value('.','VARCHAR(20)') From @xmlSearchCriteria.nodes('//DataAccountableParty/SearchCriteria') as xmlVals(rowvals))
		
		SET @FirstName = ISNULL(@FirstName, '');
		SET @FirstName = '%' + rtrim(ltrim(@FirstName)) + '%'		
		SET @LastName = ISNULL(@LastName, '');
		SET @LastName = '%' + rtrim(ltrim(@LastName)) + '%'
		SET @AccountablePartyNo = ISNULL(@AccountablePartyNo, 0);
		SET @PostalAddress = ISNULL(@PostalAddress, '');
		SET @PostalAddress = '%' + rtrim(ltrim(@PostalAddress)) + '%'
		SET @TradingName = ISNULL(@TradingName, '');
		SET @TradingName = '%' + rtrim(ltrim(@TradingName)) + '%'
		SET @ABN = ISNULL(@ABN, '');
		SET @RecordType = ISNULL(@RecordType, 0)
		SET @RecordNo = ISNULL(@RecordNo, 0)
		SET @SubRecordType = ISNULL(@SubRecordType,0)

		
		SET @ACN = ISNULL(@ACN, '');
		
		DECLARE @NoOfRecords as int		
		
		SELECT DISTINCT @NoOfRecords=COUNT(A.AccountablePartyID)
		FROM tblAccountableParty A
			LEFT OUTER JOIN tblAddress ADDR ON ADDR.AddressID = A.AddressID
			LEFT OUTER JOIN tblInstrumentAccountableParty IAP ON IAP.AccountablePartyID = A.AccountablePartyID
			LEFT OUTER JOIN tblInstrument I ON I.InstrumentID = IAP.InstrumentID
			LEFT OUTER JOIN tblClassification C ON C.ClassificationID = I.InstrumentTypeID
			LEFT OUTER JOIN tblDECCWSection D ON D.DECCWSectionID = I. DECCWSectionID
			LEFT OUTER JOIN tblInstrumentLocation IL ON IL.InstrumentLocationID = (SELECT MIN(IL1.InstrumentLocationID) FROM tblInstrumentLocation IL1 
																				WHERE IL1.InstrumentID = I.InstrumentID)
			LEFT OUTER JOIN tblLocation L ON IL.LocationID = L.LocationID
			LEFT OUTER JOIN tblAddress ADDRL ON ADDRL.AddressID = L.AddressID
			LEFT OUTER JOIN tblInstrumentAccountableParty IAPR ON IAPR.InstrumentAccountablePartyID = (SELECT MIN(IAPR1.InstrumentAccountablePartyID)
															FROM tblInstrumentAccountableParty IAPR1 WHERE IAPR1.InstrumentID = I.InstrumentID)
			LEFT OUTER JOIN tblAccountableParty APR ON APR.AccountablePartyID = IAPR.AccountablePartyID
			LEFT OUTER JOIN tblAccountablePartyPhoto APRP ON APR.AccountablePartyID = APRP.AccountablePartyID
			LEFT OUTER JOIN tblDGLicenceDriver DGDL ON I.InstrumentID = DGDL.InstrumentID	
			LEFT OUTER JOIN tblPesticideLicence PL ON I.InstrumentID = PL.InstrumentID
		WHERE
			(
				@FirstName IS NULL OR @FirstName = ''
				OR patindex(@FirstName, isnull(A.GivenName, '')) > 0					
			)
			AND (
				@LastName IS NULL OR @LastName = ''
				OR patindex(@LastName, isnull(A.Surname, '')) > 0
				)
			AND (
				@AccountablePartyNo IS NULL OR @AccountablePartyNo = 0
				OR (A.AccountablePartyID = @AccountablePartyNo)
				)
			AND (
				@PostalAddress IS NULL OR @PostalAddress = ''
				OR patindex(@PostalAddress, isnull((ADDR.[Address] + ', ' + ADDR.Suburb + ', ' + ADDR.Postcode + ', ' + ADDR.StateCode), '')) > 0
				)
			AND (
				@TradingName IS NULL OR @TradingName = ''
				OR patindex(@TradingName, isnull(A.TradingName, '')) > 0
				)
			AND (
				@ABN IS NULL OR @ABN = ''
				OR (A.ABN = @ABN)
				)
			AND (
				@RecordNo IS NULL OR @RecordNo = 0
				OR (I.InstrumentID = @RecordNo)
				)
			AND (
				@RecordType IS NULL OR @RecordType = 0
				OR (I.InstrumentTypeID = @RecordType)
				)
			AND (
				A.CompanyFlag = 0
				)	
			AND -- PALMS V1.3
				(
				@ACN IS NULL OR @ACN = ''
				OR (A.ACN = @ACN)
				)
			--AND (
			--	@SubRecordType IS NULL OR @SubRecordType = 0
			--	OR ((@SubRecordType= 818 or @SubRecordType= 819) AND A.DateOfBirth is not null)--for DangerousGood Driver's licence only return DOB not null
			--	)
			
			

		--IF(NOT(@NoOfRecords > @NoOfRecordsRequired) OR @ToExport = 1)
		  IF(@ToExport = 1)
			Begin
				SELECT DISTINCT TOP (@MaxRecordsExport)
					A.AccountablePartyID	APNo,
					(A.GivenName + (CASE isnull(A.MiddleName, '') WHEN '' THEN '' ELSE ' ' + A.MiddleName END) + ' ' + A.Surname)	APName,
					(case ADDR.OverseasAddressFlag 
					      when 1 then ADDR.[Address] + ', ' + ADDR.Suburb + (case isnull(ADDR.Postcode, '') when '' then '' else ', ' + ADDR.Postcode end) + (case isnull(ADDR.StateCode, '') when '' then '' else ', ' + ADDR.StateCode end) + ', ' + ADDR.Country
					      else ADDR.[Address] + ', ' + ADDR.Suburb + ', ' + ADDR.Postcode + ', ' + ADDR.StateCode
					 end) PostalAddress,
					I.InstrumentID Recordno,
					(CASE WHEN I.InstrumentTypeID = 554 THEN NT.TemplateName ELSE C.Name END) RecordType,
					D.Name	Section,
					dbo.ufn_GetLGAByLocation(L.LocationID) LGA,
					L.LocationName	Location,
					ADDRL.[Address]	[StreetName],
					ADDRL.Suburb,
					A.ABN,
					A.TradingName,
					(CASE WHEN I.InstrumentTypeID = 554 THEN 'secondary' ELSE 'poeo' END) InstrumentType,
					dbo.ufn_GetSAPCustomerIDByInstrument(A.AccountablePartyID,I.InstrumentID, I.InstrumentTypeID) As SAPCustomerID, -- Michael(06/09/11) new coloumm
		           (case I.InstrumentTypeID when 817 then (case when APRP.Photo is null then 'upload' else 'replace' end)
		                         when 818 then (case when APRP.Photo is null then 'upload' else 'replace' end)
								 when 819 then (case when APRP.Photo is null then 'upload' else 'replace' end)
								 else '' end) as UploadDocumentName,
		(case I.InstrumentTypeID when 817 then isnull(DGDL.PrintIDFlag, 0)
		                         when 818 then isnull(PL.PrintIDFlag, 0)
								 when 819 then isnull(DGDL.PrintIDFlag, 0)
								 else null end)  as PrintIDFlag,
				   isnull(APRP.DateUpdated,  APRP.DateCreated) as DateOfPhoto
				FROM tblAccountableParty A
					LEFT OUTER JOIN tblAddress ADDR ON ADDR.AddressID = A.AddressID
					LEFT OUTER JOIN tblInstrumentAccountableParty IAP ON IAP.AccountablePartyID = A.AccountablePartyID
					LEFT OUTER JOIN tblInstrument I ON I.InstrumentID = IAP.InstrumentID
					LEFT OUTER JOIN tblClassification C ON C.ClassificationID = I.InstrumentTypeID
					LEFT OUTER JOIN tblNotice N ON N.InstrumentID = I.InstrumentID
					LEFT OUTER JOIN tblNoticeTemplate NT ON NT.NoticeTemplateID = N.NoticeTemplateID
					LEFT OUTER JOIN tblDECCWSection D ON D.DECCWSectionID = I. DECCWSectionID
					LEFT OUTER JOIN tblInstrumentLocation IL ON IL.InstrumentLocationID = (SELECT MIN(IL1.InstrumentLocationID) FROM tblInstrumentLocation IL1 
																						WHERE IL1.InstrumentID = I.InstrumentID)
					LEFT OUTER JOIN tblLocation L ON IL.LocationID = L.LocationID
					LEFT OUTER JOIN tblAddress ADDRL ON ADDRL.AddressID = L.AddressID
					LEFT OUTER JOIN tblInstrumentAccountableParty IAPR ON IAPR.InstrumentAccountablePartyID = (SELECT MIN(IAPR1.InstrumentAccountablePartyID)
																	FROM tblInstrumentAccountableParty IAPR1 WHERE IAPR1.InstrumentID = I.InstrumentID)
					LEFT OUTER JOIN tblAccountableParty APR ON APR.AccountablePartyID = IAPR.AccountablePartyID
					LEFT OUTER JOIN tblAccountablePartyPhoto APRP ON APR.AccountablePartyID = APRP.AccountablePartyID
			LEFT OUTER JOIN tblDGLicenceDriver DGDL ON I.InstrumentID = DGDL.InstrumentID	
			LEFT OUTER JOIN tblPesticideLicence PL ON I.InstrumentID = PL.InstrumentID
				WHERE
					(
						@FirstName IS NULL OR @FirstName = ''
						OR patindex(@FirstName, isnull(A.GivenName, '')) > 0					
					)
					AND (
						@LastName IS NULL OR @LastName = ''
						OR patindex(@LastName, isnull(A.Surname, '')) > 0
						)
					AND (
						@AccountablePartyNo IS NULL OR @AccountablePartyNo = 0
						OR (A.AccountablePartyID = @AccountablePartyNo)
						)
					AND (
						@PostalAddress IS NULL OR @PostalAddress = ''
						OR patindex(@PostalAddress, isnull((ADDR.[Address] + ', ' + ADDR.Suburb + ', ' + ADDR.Postcode + ', ' + ADDR.StateCode), '')) > 0
						)
					AND (
						@TradingName IS NULL OR @TradingName = ''
						OR patindex(@TradingName, isnull(A.TradingName, '')) > 0
						)
					AND (
						@ABN IS NULL OR @ABN = ''
						OR (A.ABN = @ABN)
						)
					AND (
						@RecordNo IS NULL OR @RecordNo = 0
						OR (I.InstrumentID = @RecordNo)
						)
					AND (
						@RecordType IS NULL OR @RecordType = 0
						OR (I.InstrumentTypeID = @RecordType)
						)
					AND (
						A.CompanyFlag = 0
						)
					AND -- PALMS V1.3
						(
						@ACN IS NULL OR @ACN = ''
						OR (A.ACN = @ACN)
						)
					--AND (
					--	@SubRecordType IS NULL OR @SubRecordType = 0
					--	OR ((@SubRecordType= 818 or @SubRecordType= 819) AND A.DateOfBirth is not null)--for DangerousGood Driver's licence only return DOB not null
					--	)
				ORDER BY A.AccountablePartyID
			END
		ELSE			
			IF (@NoOfRecords <= @NoOfRecordsRequired)
			  BEGIN
			    --Define a temp table to hold all return records
				Create Table #InstrumentResultRows
				(					 
					APNo int null,
					APName Varchar(200),
					PostalAddress Varchar(500),
					Recordno int null,
					RecordType Varchar(255), 
					Section Varchar(100), 					
					LGA varchar(1000),	
					Location Varchar(500),
					[StreetName] Varchar(200),
					Suburb Varchar(100), 
					ABN Varchar(14),
                    TradingName Varchar(500),
                    InstrumentType Varchar(100),  
                    SAPCustomerID int null,  					 									 				 
					RowCountTotal int null,
					DateOfBirth date null,
					UploadDocumentName Varchar(128),
					PrintIDFlag bit null,
					DateOfPhoto Datetime null
				)	
				Insert Into #InstrumentResultRows
				(
					APNo,
					APName,
					PostalAddress,
					Recordno,
					RecordType, 
					Section, 					
					LGA,	
					Location,
					[StreetName],
					Suburb, 
					ABN,
                    TradingName,
                    InstrumentType,  
                    SAPCustomerID,
					DateOfBirth,
					UploadDocumentName,
					PrintIDFlag,
					DateOfPhoto		 		
				)
												    
				SELECT DISTINCT  
					A.AccountablePartyID	APNo,
					(A.GivenName + (CASE isnull(A.MiddleName, '') WHEN '' THEN '' ELSE ' ' + A.MiddleName END) + ' ' + A.Surname)	APName,
					(case ADDR.OverseasAddressFlag 
					      when 1 then ADDR.[Address] + ', ' + ADDR.Suburb + (case isnull(ADDR.Postcode, '') when '' then '' else ', ' + ADDR.Postcode end) + (case isnull(ADDR.StateCode, '') when '' then '' else ', ' + ADDR.StateCode end) + ', ' + ADDR.Country
					      else ADDR.[Address] + ', ' + ADDR.Suburb + ', ' + ADDR.Postcode + ', ' + ADDR.StateCode
					 end) PostalAddress,
					I.InstrumentID Recordno,
					(CASE WHEN I.InstrumentTypeID = 554 THEN NT.TemplateName ELSE C.Name END) RecordType,
					D.Name	Section,
					dbo.ufn_GetLGAByLocation(L.LocationID) LGA,
					L.LocationName	Location,
					ADDRL.[Address]	[StreetName],
					ADDRL.Suburb,
					A.ABN,
					A.TradingName,
					(CASE 
					   WHEN I.InstrumentTypeID = 493 THEN 'poeo'
					   WHEN I.InstrumentTypeID = 554 THEN 'secondary' 
					   WHEN I.InstrumentTypeID = 750 THEN 'radiation'
					   WHEN I.InstrumentTypeID = 817 THEN 'dangerousgoods'
					   WHEN I.InstrumentTypeID = 818 THEN 'pesticide'
					   ELSE 'poeo' 
					 END) InstrumentType,
					dbo.ufn_GetSAPCustomerIDByInstrument(A.AccountablePartyID,I.InstrumentID, I.InstrumentTypeID) As SAPCustomerID, -- Michael(06/09/11) new coloumm
					A.DateOfBirth, --Anish (18/05/2014) new column
					(case I.InstrumentTypeID when 817 then (case when APRP.Photo is null then 'upload' else 'replace' end)
		                         when 818 then (case when APRP.Photo is null then 'upload' else 'replace' end)
								 when 819 then (case when APRP.Photo is null then 'upload' else 'replace' end)
								 else '' end) as UploadDocumentName,
		           (case I.InstrumentTypeID 
				                 when 817 then isnull(DGDL.PrintIDFlag, 0)
		                         when 818 then isnull(PL.PrintIDFlag, 0)
								 when 819 then isnull(DGDL.PrintIDFlag, 0)
								 else null end)  as PrintIDFlag,
                    isnull(APRP.DateUpdated,  APRP.DateCreated) as DateOfPhoto
				FROM tblAccountableParty A
					LEFT OUTER JOIN tblAddress ADDR ON ADDR.AddressID = A.AddressID
					LEFT OUTER JOIN tblInstrumentAccountableParty IAP ON IAP.AccountablePartyID = A.AccountablePartyID
					LEFT OUTER JOIN tblInstrument I ON I.InstrumentID = IAP.InstrumentID
					LEFT OUTER JOIN tblClassification C ON C.ClassificationID = I.InstrumentTypeID
					LEFT OUTER JOIN tblNotice N ON N.InstrumentID = I.InstrumentID
					LEFT OUTER JOIN tblNoticeTemplate NT ON NT.NoticeTemplateID = N.NoticeTemplateID
					LEFT OUTER JOIN tblDECCWSection D ON D.DECCWSectionID = I. DECCWSectionID
					LEFT OUTER JOIN tblInstrumentLocation IL ON IL.InstrumentLocationID = (SELECT MIN(IL1.InstrumentLocationID) FROM tblInstrumentLocation IL1 
																						WHERE IL1.InstrumentID = I.InstrumentID)
					LEFT OUTER JOIN tblLocation L ON IL.LocationID = L.LocationID
					LEFT OUTER JOIN tblAddress ADDRL ON ADDRL.AddressID = L.AddressID
					LEFT OUTER JOIN tblInstrumentAccountableParty IAPR ON IAPR.InstrumentAccountablePartyID = (SELECT MIN(IAPR1.InstrumentAccountablePartyID)
																	FROM tblInstrumentAccountableParty IAPR1 WHERE IAPR1.InstrumentID = I.InstrumentID)
					LEFT OUTER JOIN tblAccountableParty APR ON APR.AccountablePartyID = IAPR.AccountablePartyID
					LEFT OUTER JOIN tblAccountablePartyPhoto APRP ON APR.AccountablePartyID = APRP.AccountablePartyID
			LEFT OUTER JOIN tblDGLicenceDriver DGDL ON I.InstrumentID = DGDL.InstrumentID	
			LEFT OUTER JOIN tblPesticideLicence PL ON I.InstrumentID = PL.InstrumentID
				WHERE
					(
						@FirstName IS NULL OR @FirstName = ''
						OR patindex(@FirstName, isnull(A.GivenName, '')) > 0					
					)
					AND (
						@LastName IS NULL OR @LastName = ''
						OR patindex(@LastName, isnull(A.Surname, '')) > 0
						)
					AND (
						@AccountablePartyNo IS NULL OR @AccountablePartyNo = 0
						OR (A.AccountablePartyID = @AccountablePartyNo)
						)
					AND (
						@PostalAddress IS NULL OR @PostalAddress = ''
						OR patindex(@PostalAddress, isnull((ADDR.[Address] + ', ' + ADDR.Suburb + ', ' + ADDR.Postcode + ', ' + ADDR.StateCode), '')) > 0
						)
					AND (
						@TradingName IS NULL OR @TradingName = ''
						OR patindex(@TradingName, isnull(A.TradingName, '')) > 0
						)
					AND (
						@ABN IS NULL OR @ABN = ''
						OR (A.ABN = @ABN)
						)
					AND (
						@RecordNo IS NULL OR @RecordNo = 0
						OR (I.InstrumentID = @RecordNo)
						)
					AND (
						@RecordType IS NULL OR @RecordType = 0
						OR (I.InstrumentTypeID = @RecordType)
						)
					AND (
						A.CompanyFlag = 0
						)
					AND -- PALMS V1.3
						(
						@ACN IS NULL OR @ACN = ''
						OR (A.ACN = @ACN)
						)
					--AND (
					--	@SubRecordType IS NULL OR @SubRecordType = 0
					--	OR ((@SubRecordType= 818 or @SubRecordType= 819) AND A.DateOfBirth is not null)--for DangerousGood Driver's licence only return DOB not null
					--	)
				ORDER BY A.AccountablePartyID
				
				--Added in 31-02-2012 for returning the number of total rows		
				DECLARE @ActualCount INT
				SELECT @ActualCount = COUNT(APNo) from #InstrumentResultRows			
				UPDATE #InstrumentResultRows SET RowCountTotal = @ActualCount	
								
				SELECT TOP (@pageSize) *  FROM #InstrumentResultRows 
				WHERE APNo NOT IN  
				( SELECT TOP ((@pageNum - 1) * (@pageSize)) APNo FROM #InstrumentResultRows order by APNo )	
				order by APNo						
			  END		
			ELSE	
				SELECT 
					'0' as [APno], 
					'0' as [APname],
					'0' as [Postaladdress],
					'0' as [Recordno],
					'0' as [Recordtype], 
					'0' as [Section], 
					'0' as 'LGA', 
					'0' as 'Location', 
					'0' as [Streetname],
					'0' as [Suburb]		