declare @xmlSearchCriteria XML
set @xmlSearchCriteria = 
'
<DataPRSearch>
  <PrimarySearchCriteria>   
    <DGRegoNumber>BMW</DGRegoNumber>
  </PrimarySearchCriteria>
</DataPRSearch>
'

		DECLARE 
		@LicenseType as int,
		@LicenseNo as int, 
		@LicenseStatus as int, 
		@RadiationLicenceTypeID as int,

		@APName as Varchar(100), 
		@TradingName AS VARCHAR(128),	
		@DGRegoNumber as Varchar(100),  --old licence number		
			 
		@LicenseReviewTo as DateTime,  --date issued
		@StatusFromDate as DateTime,
		@StatusToDate as DateTime
		 
		SELECT 
			@LicenseNo = xmlVals.rowvals.value('(LicenseNo)[1]','INT'),
			@LicenseType = xmlVals.rowvals.value('(LicenseType)[1]','INT'),
			@LicenseStatus = xmlVals.rowvals.value('(LicenseStatus)[1]','INT'),			 			 
			@LicenseReviewTo = xmlVals.rowvals.value('(LicenseReviewTo)[1]','datetimeoffset'),			 
			@APName = xmlVals.rowvals.value('(APName)[1]','VARCHAR(100)'),	
			@TradingName = xmlVals.rowvals.value('(APName)[1]','VARCHAR(128)'),			 
			@StatusFromDate = xmlVals.rowvals.value('(StatusFromDate)[1]','datetimeoffset'),
			@StatusToDate = xmlVals.rowvals.value('(StatusToDate)[1]','datetimeoffset'),		 
			@RadiationLicenceTypeID = xmlVals.rowvals.value('(RadiationLicenceTypeID)[1]','INT'),   ------------ PALMS V5.0			 
			@DGRegoNumber = xmlVals.rowvals.value('(DGRegoNumber)[1]','VARCHAR(100)')		 
		From @xmlSearchCriteria.nodes('//DataPRSearch/PrimarySearchCriteria') as xmlVals(rowvals)	

		SET @LicenseType = ISNULL(@LicenseType, 0);	
		SET @LicenseNo = ISNULL(@LicenseNo, 0)
		SET @LicenseStatus = ISNULL(@LicenseStatus, 0)
		SET @RadiationLicenceTypeID = ISNULL(@RadiationLicenceTypeID, 0) --Pesticide licence class ID

		SET @APName = ISNULL(@APName, '');		 
		SET @TradingName = ISNULL(@TradingName, '');		 			
		SET @DGRegoNumber = ISNULL(@DGRegoNumber, '');
		
		DECLARE @strSearchCriteria nvarchar(MAX)

		Declare @ResultRowsSearch Table	 (InstrumentID int null)

		SELECT @strSearchCriteria =N'		
		SELECT DISTINCT I.InstrumentID 
		FROM   tblPesticideLicence RL 
		        LEFT OUTER JOIN tblInstrument I ON RL.InstrumentID = I.InstrumentID
				LEFT OUTER JOIN tblPesticideLicenceClass PC ON RL.InstrumentID = PC.InstrumentID
		        LEFT OUTER JOIN tblClassification C ON C.ClassificationID = I.InstrumentTypeID
				LEFT OUTER JOIN tblClassification C2 ON C2.ClassificationID = I.InstrumentStatusID
				LEFT OUTER JOIN tblSystemUser U ON U.SystemUserID = I.ResponsibleSystemUserID
				LEFT OUTER JOIN tblInstrumentAccountableParty IAP ON IAP.InstrumentID = I.InstrumentID
				LEFT OUTER JOIN tblAccountableParty AP ON AP.AccountablePartyID = IAP.AccountablePartyID			            					 					 										
		WHERE 		
				(
					C.ClassificationDomainID = 35
				)	
				AND PC.PesticideLicenceClassID > 0 '

		DECLARE @whereClause0 AS nvarchar(MAX)                        
		SET  @whereClause0 = N''

		IF @LicenseNo > 0
		BEGIN
			SET @whereClause0 = @whereClause0 +  ' AND RL.InstrumentID = ' + convert(varchar, @LicenseNo)
		END 

		IF @LicenseType > 0
		BEGIN
		    SET @whereClause0 = @whereClause0 +  ' AND I.InstrumentTypeID = ' + convert(varchar, @LicenseType)
		END

		IF @LicenseStatus > 0
		BEGIN
		    SET @whereClause0 = @whereClause0 +  ' AND I.InstrumentStatusID = ' + convert(varchar, @LicenseStatus)
		END
		
		IF @RadiationLicenceTypeID > 0
		BEGIN
		    SET @whereClause0 = @whereClause0 +  ' AND PC.LicenceClassID = ' + convert(varchar, @RadiationLicenceTypeID)
		END
		
		IF @APName IS NOT NULL and LEN(@APName) > 0
		BEGIN
			SET @whereClause0 = @whereClause0 +  ' AND (AP.OrganisationName like ''%' + convert(varchar, @APName) + '%''' + ' OR AP.TradingName like ''%' + convert(varchar, @APName) + '%''' + ' OR AP.GivenName like ''%' + convert(varchar, @APName) + '%'''+ ' OR AP.Surname like ''%' + convert(varchar, @APName) + '%'')'
		END		
		 
		IF @DGRegoNumber IS NOT NULL and LEN(@APName) > 0
		BEGIN
		   SET @whereClause0 = @whereClause0 +  ' AND RL.OldLicenceNumber  like ''%' + convert(varchar, @DGRegoNumber) + '%''' 
		END

		IF @LicenseReviewTo IS NOT NULL and LEN(@LicenseReviewTo) > 0
		BEGIN
		   SET @whereClause0 = @whereClause0 +  ' AND Convert(varchar(10), CONVERT(date, I.DateIssued, 103), 103) = ''' + Convert(varchar(10), CONVERT(date, @LicenseReviewTo, 103), 103)  + ''''
		END

		IF @StatusFromDate IS NOT NULL and LEN(@StatusFromDate) > 0
		BEGIN
		   SET @whereClause0 = @whereClause0 +  ' AND DATEDIFF(day, ''' + Convert(varchar(10), CONVERT(date, @StatusFromDate, 101), 101)+ ''', RL.ExpiryDate) >= 0 '
		END

		IF @StatusToDate IS NOT NULL and LEN(@StatusToDate) > 0
		BEGIN
		   SET @whereClause0 = @whereClause0 +  ' AND DATEDIFF(day, ''' + Convert(varchar(10), CONVERT(date, @StatusToDate, 101), 101)+ ''', RL.ExpiryDate) <= 0 '
		END

		set @strSearchCriteria = @strSearchCriteria + @whereClause0 

        Insert Into @ResultRowsSearch 		 
		EXEC sp_executesql @strSearchCriteria;	
		
		print '@whereClause0 =' + @whereClause0
		print '@DGRegoNumber =' + @DGRegoNumber

		select * from @ResultRowsSearch
		DECLARE @NoOfRecords as int	
		SELECT @NoOfRecords=isnull(COUNT(InstrumentID), 0) from @ResultRowsSearch	
		  
		Declare @ResultRowsFinal Table
		(	
			InstrumentTypeID int null, 
			InstrumentType VARCHAR(100) null,
			InstrumentID int null, 
			InstrumentStatusID int null, 
			InstrumentStatus Varchar(100) null,
			DateIssued DateTime null,
			ResponsibleSystemUserID int null,
			ResponsibleOfficer Varchar(128) null,
			AccountablePartyID int null,
			AccountableParty varchar(128) null,

			FeeBasedActivityID int null,
			FeeBasedActivity Varchar(128) null,
			POEOLicenseScheduledActivityID int null,
			ScheduleActivity Varchar(128),
			LBLFlag BIT null,
			LowRiskFlag Varchar(10),
			ReviewDueDate DateTime null,
			AnniversaryDate DateTime null,
			DECCWSectionID int null,
			Section varchar(128) null,

			TradingName varchar(128) null,
			LocationName varchar(128) null,
			[Address] varchar(100) null,
			Suburb varchar(60) null,
			Postcode varchar(4) null,
			LocationID int null,
			StatusChangedDate DateTime,
			LGA Varchar(100),
			Catchment Varchar(100),
			Electorate Varchar(100),

			EnvironmentalRiskLevel Varchar(50),
			EnvironmentalManagementCategory Varchar(50),
			RowCountTotal int null,
			RadiationLicenceType VARCHAR(200) null,
			RadiationLicenceExpiryDate Date null,
			LastUpdated varchar(50) null,
			DGLicenceTypeID int null 												
		)
						     
        insert into @ResultRowsFinal
		SELECT DISTINCT 
		I.InstrumentTypeID, 
		C.[Name] InstrumentType,
		I.InstrumentID, 
		I.InstrumentStatusID, 				 										
		C2.Name as InstrumentStatus,
		I.DateIssued,
		I.ResponsibleSystemUserID,
		U.GivenName + ' ' + U.Surname ResponsibleOfficer,
		IAP.AccountablePartyID,
		(CASE WHEN AP.CompanyFlag = 1 THEN AP.OrganisationName ELSE AP.GivenName + ' ' + AP.Surname END) AccountableParty,
		-1,
		'',
		-1,
		'',
		0,
		0,
		NULL,
		NULL,
		0 as DECCWSectionID,
		'' as Section,

		AP.TradingName,
		null as LocationName,
		null as Address,
		null as Suburb,
		null as Postcode,
		0 as LocationID,
		I.DateCreated [StatusChangedDate],
		'',
		'',
		'',
		NULL,				
		NULL,
		@NoOfRecords as RowCountTotal,
		'' as [Name],
		RL.ExpiryDate,
		[dbo].[ufn_PRGetDGLIssuedDate](I.InstrumentID) as LastUpdated,				 
		0 as DGLicenceTypeID
		FROM  @ResultRowsSearch A INNER JOIN tblPesticideLicence RL ON A.InstrumentID = RL.InstrumentID 
		        LEFT OUTER JOIN tblInstrument I ON RL.InstrumentID = I.InstrumentID
				LEFT OUTER JOIN tblPesticideLicenceClass PC ON RL.InstrumentID = PC.InstrumentID
		        LEFT OUTER JOIN tblClassification C ON C.ClassificationID = I.InstrumentTypeID
				LEFT OUTER JOIN tblClassification C2 ON C2.ClassificationID = I.InstrumentStatusID
				LEFT OUTER JOIN tblSystemUser U ON U.SystemUserID = I.ResponsibleSystemUserID
				LEFT OUTER JOIN tblInstrumentAccountableParty IAP ON IAP.InstrumentID = I.InstrumentID
				LEFT OUTER JOIN tblAccountableParty AP ON AP.AccountablePartyID = IAP.AccountablePartyID			            					 					 										
		 


		

        select * from @ResultRowsFinal