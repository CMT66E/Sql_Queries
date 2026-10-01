declare @xmlSearchCriteria XML =
'
<DataSearch>
  <SecondarySearchCriteria>
    <RecordStatus>11</RecordStatus>
    <APName>AMP</APName>
  </SecondarySearchCriteria>
</DataSearch>
'
declare @NoOfRecordsRequired int = 500
declare @MaxRecordsExport int = 5000
declare @ToExport BIT = 0
declare @pageSize INT = 50
declare @pageNum INT = 1

BEGIN TRY
		DECLARE 
			@RecordType as int, 
			@RecordNo as int, 
			@RecordStatus as int, 
			@ResponsibleOfficer as Varchar(120),
			@ResponsibleOfficerID as int,
			@PrimaryRecordNo as int,
			@APName as Varchar(100), 
			@SectionId as int,
			@StatusFromDate as DateTime, 
			@StatusToDate as DateTime, 			
			@TradingName as Varchar(100),
			@IsFromLicence as BIT,
			@InspectionDateFrom as DateTime,
			@InspectionDateTo as DateTime,
			@CompleteFromDate as DateTime,
			@CompleteToDate as DateTime;

		
		SELECT 
			@RecordNo = xmlVals.rowvals.value('(RecordNo)[1]','INT'),
			@RecordType = xmlVals.rowvals.value('(RecordType)[1]','INT'),
			@RecordStatus = xmlVals.rowvals.value('(RecordStatus)[1]','INT'),
			@TradingName = xmlVals.rowvals.value('(TradingName)[1]','VARCHAR(100)'),
			@ResponsibleOfficer = xmlVals.rowvals.value('(ResponsibleOfficer)[1]','VARCHAR(120)'),
			@PrimaryRecordNo = xmlVals.rowvals.value('(PrimaryRecordNo)[1]','INT'),
			@APName = xmlVals.rowvals.value('(APName)[1]','VARCHAR(100)'),
			@SectionId = xmlVals.rowvals.value('(SectionId)[1]','int'),
			@StatusFromDate = xmlVals.rowvals.value('(StatusFromDate)[1]','DateTime'),
			@StatusToDate = xmlVals.rowvals.value('(StatusToDate)[1]','DateTime'),
			@IsFromLicence = xmlVals.rowvals.value('(IsFromLicence)[1]','BIT'),
			@InspectionDateFrom = xmlVals.rowvals.value('(InspectionFromDate)[1]','DateTime'),
			@InspectionDateTo = xmlVals.rowvals.value('(InspectionToDate)[1]','DateTime'),
			@CompleteFromDate = xmlVals.rowvals.value('(CompleteFromDate)[1]','DateTime'),
			@CompleteToDate = xmlVals.rowvals.value('(CompleteToDate)[1]','DateTime')
		From @xmlSearchCriteria.nodes('//DataSearch/SecondarySearchCriteria') as xmlVals(rowvals)		
		
		
		Select @ResponsibleOfficerID =dbo.ufn_GetSystemUserIDByLoginName(@ResponsibleOfficer)
		SET @ResponsibleOfficerID = ISNULL(@ResponsibleOfficerID, 0);
		
		SET @APName = ISNULL(@APName, '');
		SET @APName = '%' + rtrim(ltrim(@APName)) + '%'	;		
		SET @TradingName = ISNULL(@TradingName, '');
		SET @TradingName = '%' + rtrim(ltrim(@TradingName)) + '%'	;		
		
		DECLARE @StatusTable Table(InstrumentID int)
		
		Declare  @StatusFilterCount int
		Set @StatusFilterCount = 0
		
		IF @StatusFromDate IS NOT NULL OR @StatusToDate IS NOT NULL
		Begin
			Set @StatusFilterCount = 1
				
			Insert into @StatusTable
			(
				InstrumentID
			)
			Select aul.InstrumentID
			From 
				tblInstrumentAuditLog aul
			Where
				(
					@StatusFromDate IS NULL OR @StatusFromDate = '' Or
					DATEDIFF(day, @StatusFromDate, aul.DateCreated) >= 0
				)
				AND
				(
					@StatusToDate IS NULL OR @StatusToDate = '' Or
					DATEDIFF(day, @StatusToDate, aul.DateCreated) <= 0
				)
				AND
				(
					@RecordNo IS NULL OR @RecordNo = 0 
					OR
					aul.InstrumentID = @RecordNo
				)
				AND aul.ChangedStatusFlag = 1
		End
		
		
		Declare @AccountableParty as Table
					(
						InstrumentId INT
					)
									
		Insert Into @AccountableParty
		(
			InstrumentId
		)
		Select 
			I.InstrumentID
		From tblInstrument I
			INNER JOIN 
			(SELECT InstrumentID From tblInstrument 
			WHERE InstrumentTypeID = 554 AND 
			InstrumentID NOT IN(Select NoticeInstrumentID From tblInstrumentNotice)) A
			ON A.InstrumentID = I.InstrumentID
			INNER JOIN tblInstrumentAccountableParty IAP ON
			IAP.InstrumentID = I.InstrumentID
			INNER JOIN tblAccountableParty AP ON
			IAP.AccountablePartyID = AP.AccountablePartyID
		Where I.InstrumentTypeID = 554				
		AND (@APName IS NULL OR @APName = '' OR
			((PATINDEX(@APName, isnull((CASE WHEN (AP.CompanyFlag = 0) THEN AP.GivenName + ' ' + AP.Surname ELSE
				AP.OrganisationName END), '')) > 0)))				
		AND
		(
			@TradingName IS NULL OR @TradingName = ''
			OR (PATINDEX(@TradingName, isnull(AP.TradingName, '')) > 0)
		)
				
		Insert INTO @AccountableParty
		(
			InstrumentId
		)
		Select 
			NI.NoticeInstrumentID
		From tblInstrumentNotice NI
		INNER JOIN tblInstrumentAccountableParty IAP ON
		IAP.InstrumentID =NI.InstrumentID
		INNER JOIN tblAccountableParty AP ON
			IAP.AccountablePartyID = AP.AccountablePartyID
		AND (@APName IS NULL OR @APName = '' OR
			((PATINDEX(@APName, isnull((CASE WHEN (AP.CompanyFlag = 0) THEN AP.GivenName + ' ' + AP.Surname ELSE
				AP.OrganisationName END), '')) > 0)))				
		AND
		(
			@TradingName IS NULL OR @TradingName = ''
			OR (PATINDEX(@TradingName, isnull(AP.TradingName, '')) > 0)
		)
			
			
		
		declare @InstrumentAllRows as Table
		(
			InstrumentID int
		)
						
		Insert Into @InstrumentAllRows
		(
			InstrumentID
		)							
		SELECT DISTINCT
			[I].InstrumentID	
		FROM 
			tblInstrument I				
			LEFT OUTER JOIN tblInstrumentNotice [IN]
				ON [IN].NoticeInstrumentID = I.InstrumentID
			LEFT OUTER JOIN tblNotice N
				ON [I].InstrumentID = N.InstrumentID
			INNER JOIN tblNoticeTemplate NT
				ON NT.NoticeTemplateID = N.NoticeTemplateID
			LEFT OUTER JOIN tblClassification C ON
				C.ClassificationID = I.InstrumentStatusID
			LEFT OUTER JOIN tblInstrumentAuditLog AL
				ON AL.InstrumentAuditLogID = 
					(Select MAX(AL1.InstrumentAuditLogID) FROM tblInstrumentAuditLog AL1
					Where I.InstrumentID = AL1.InstrumentID)
			LEFT OUTER JOIN tblDECCWSection DS
				ON DS.DECCWSectionID = I.DECCWSectionID
			LEFT OUTER JOIN @AccountableParty AP 
				ON AP.InstrumentId = [I].InstrumentID	
			
			LEFT OUTER JOIN tblInstrumentAccountableParty IAP ON
			IAP.InstrumentAccountablePartyID = (Select MIN(IAP1.InstrumentAccountablePartyID)
				FROM tblInstrumentAccountableParty IAP1 WHERE IAP1.InstrumentID = I.InstrumentID)
			LEFT OUTER JOIN tblAccountableParty APR ON IAP.AccountablePartyID = APR.AccountablePartyID	
									
			LEFT OUTER JOIN tblSystemUser U
				ON I.ResponsibleSystemUserID = U.SystemUserID
			LEFT OUTER JOIN tblInstrument PRI 
				ON PRI.InstrumentID = [IN].InstrumentID
			LEFT OUTER JOIN tblClassification C1
				ON PRI.InstrumentTypeID = C1.ClassificationID								
			WHERE NOT N.NoticeTemplateID IN (21, 22, 23, 24)
			    AND
				(
					NT.DocumentRequiredFlag <> 0
				)
				AND		
				(
					I.InstrumentTypeID = 554
				)
				AND
				(
					@ResponsibleOfficerID IS NULL OR @ResponsibleOfficerID = 0
					OR ([I].ResponsibleSystemUserID = @ResponsibleOfficerID)
				)
				AND
				(
					@RecordNo IS NULL OR @RecordNo = 0
					OR ([I].InstrumentID = @RecordNo)
				)
				AND
				(
					@RecordStatus IS NULL OR @RecordStatus = 0
					OR ([I].InstrumentStatusID = @RecordStatus)
				)
				AND
				(	
					@RecordType IS NULL OR @RecordType = 0
					OR ([NT].NoticeTemplateID = @RecordType)
				)
				AND
				(
					@PrimaryRecordNo IS NULL OR @PrimaryRecordNo =0
					OR ([IN].InstrumentID = @PrimaryRecordNo)
				)
				AND
				(
					@SectionId IS NULL OR @SectionId = 0
					OR ([I].DECCWSectionID = @SectionId)
				)
				AND
				(
					@IsFromLicence IS NULL 
					OR (NT.SystemTemplateFlag <> @IsFromLicence)
				)			 
				AND (@APName IS NULL OR @APName = '' OR
					((PATINDEX(@APName, isnull((CASE WHEN (APR.CompanyFlag IS NULL) THEN
				(CASE WHEN (APR.CompanyFlag = 0) THEN APR.GivenName + ' ' + APR.Surname ELSE
						APR.OrganisationName END) ELSE
					(CASE WHEN (APR.CompanyFlag = 0) THEN APR.GivenName + ' ' + APR.Surname ELSE
						APR.OrganisationName END) END), '')) > 0)))							
				AND
				(
					@TradingName IS NULL OR @TradingName = ''
					OR (PATINDEX(@TradingName, isnull(APR.TradingName, '')) > 0)
				)		
				AND		
				(
					@InspectionDateFrom IS NULL OR @InspectionDateFrom = '' Or
					DATEDIFF(day, @InspectionDateFrom, N.InspectionDate) >= 0
				)
				AND
				(
					@InspectionDateTo IS NULL OR @InspectionDateTo = '' Or
					DATEDIFF(day, @InspectionDateTo, N.InspectionDate) <= 0
				)
				AND		-- PALMS V6.2
				(
					@CompleteFromDate IS NULL OR @CompleteFromDate = '' Or
					DATEDIFF(day, @CompleteFromDate, I.DateIssued) >= 0
				)
				AND		-- PALMS V6.2
				(
					@CompleteToDate IS NULL OR @CompleteToDate = '' Or
					DATEDIFF(day, @CompleteToDate, I.DateIssued) <= 0
				)
								
			
		IF((Select COUNT(InstrumentID) from @InstrumentAllRows) = 0)
		Begin
			Insert @InstrumentAllRows
			(InstrumentID)Select 0	
		End
			
		declare @InstrumentResultRows as Table
		(
			RecordNo int null,
			RecordType Varchar(128) null,
			RecordStatus varchar(100),
			APName Varchar(200),
			TradingName Varchar(128),			
			StatusChangedDate DateTime,
			ResponsibleOfficer Varchar(120),
			Section Varchar(100),
			PrimaryRecordType Varchar(100),
			PrimaryRecordNo int,
			InspectionDate DateTime null,
			RowCountTotal int null,
			SystemTemplateFlag bit null,
			TemplateTypeID int null			
		)
		
		Insert Into @InstrumentResultRows
		(
			RecordNo,
			RecordType,
			RecordStatus,
	        APName,
			TradingName,			
			StatusChangedDate,
			ResponsibleOfficer,
			Section,
			PrimaryRecordType,
			PrimaryRecordNo,
			InspectionDate,
			SystemTemplateFlag,
			TemplateTypeID
		)
		SELECT Distinct
			[I].InstrumentID,
			NT.TemplateName,
			C.Name RecordStatus,
			(CASE WHEN (APRN.CompanyFlag IS NULL) THEN
				(CASE WHEN (APR.CompanyFlag = 0) THEN APR.GivenName + ' ' + APR.Surname ELSE
						APR.OrganisationName END) ELSE
					(CASE WHEN (APRN.CompanyFlag = 0) THEN APRN.GivenName + ' ' + APRN.Surname ELSE
						APRN.OrganisationName END) END) AS APNAME,
			(CASE WHEN (APRN.CompanyFlag IS NULL) THEN
				APR.TradingName ELSE
					APRN.TradingName END) AS TradingName,						 
			(CASE WHEN (AL.DateCreated IS NOT NULL) THEN AL.DateCreated
				ELSE I.DateIssued END)  AS StatusChangedDate,
			U.GivenName + ' ' + U.Surname,
			D.Name,
			C1.Name,
			[IN].InstrumentID,
			[N].InspectionDate,
			NT.SystemTemplateFlag,
			NT.NoticeTemplateID
		FROM 
			tblInstrument I				
			LEFT OUTER JOIN tblInstrumentNotice [IN]
				ON [IN].NoticeInstrumentID = I.InstrumentID
			LEFT OUTER JOIN tblNotice N
				ON [I].InstrumentID = N.InstrumentID
			INNER JOIN tblNoticeTemplate NT
				ON NT.NoticeTemplateID = N.NoticeTemplateID
			LEFT OUTER JOIN tblClassification C ON
				C.ClassificationID = I.InstrumentStatusID
			LEFT OUTER JOIN tblInstrumentAuditLog AL
				ON AL.InstrumentAuditLogID = (Select Max(AL1.InstrumentAuditLogID) from tblInstrumentAuditLog AL1 
					Where AL1.InstrumentID = I.InstrumentID AND al1.ChangedStatusFlag = 1)
			LEFT OUTER JOIN tblDECCWSection DS
				ON DS.DECCWSectionID = I.DECCWSectionID
			LEFT OUTER JOIN @AccountableParty AP 
				ON AP.InstrumentId = [I].InstrumentID
			LEFT OUTER JOIN tblInstrumentAccountableParty IAP ON
			IAP.InstrumentAccountablePartyID = (Select MIN(IAP1.InstrumentAccountablePartyID)
				FROM tblInstrumentAccountableParty IAP1 WHERE IAP1.InstrumentID = I.InstrumentID)
			LEFT OUTER JOIN tblAccountableParty APR ON IAP.AccountablePartyID = APR.AccountablePartyID			
			LEFT OUTER JOIN tblInstrumentAccountableParty IAPN ON
			IAPN.InstrumentAccountablePartyID = (Select MIN(IAPN1.InstrumentAccountablePartyID)
				FROM tblInstrumentAccountableParty IAPN1 WHERE IAPN1.InstrumentID = [IN].InstrumentID)
			LEFT OUTER JOIN tblAccountableParty APRN ON IAPN.AccountablePartyID = APRN.AccountablePartyID			
			LEFT OUTER JOIN tblSystemUser U
				ON I.ResponsibleSystemUserID = U.SystemUserID
			LEFT OUTER JOIN tblInstrument PRI 
				ON PRI.InstrumentID = [IN].InstrumentID
			LEFT OUTER JOIN tblClassification C1
				ON PRI.InstrumentTypeID = C1.ClassificationID
			LEFT OUTER JOIN tblDECCWSection D
				ON I.DECCWSectionID = D.DECCWSectionID
			WHERE NOT N.NoticeTemplateID IN (21, 22, 23, 24)
			    AND
				(
					NT.DocumentRequiredFlag <> 0
				)
				AND				
				(
					I.InstrumentTypeID = 554
				)
				AND
				(
					@ResponsibleOfficerID IS NULL OR @ResponsibleOfficerID = 0
					OR ([I].ResponsibleSystemUserID = @ResponsibleOfficerID)
				)
				AND
				(
					@RecordNo IS NULL OR @RecordNo = 0
					OR ([I].InstrumentID = @RecordNo)
				)
				AND
				(
					@RecordStatus IS NULL OR @RecordStatus = 0
					OR ([I].InstrumentStatusID = @RecordStatus)
				)
				AND
				(	
					@RecordType IS NULL OR @RecordType = 0
					OR ([NT].NoticeTemplateID = @RecordType)
				)
				AND
				(
					@PrimaryRecordNo IS NULL OR @PrimaryRecordNo =0
					OR ([IN].InstrumentID = @PrimaryRecordNo)
				)
				AND
				(
					@SectionId IS NULL OR @SectionId = 0
					OR ([I].DECCWSectionID = @SectionId)
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
					@IsFromLicence IS NULL 
					OR (NT.SystemTemplateFlag <> @IsFromLicence)
				)
				AND (@APName IS NULL OR @APName = '' OR
					((PATINDEX(@APName, isnull((CASE WHEN (APRN.CompanyFlag IS NULL) THEN
				(CASE WHEN (APR.CompanyFlag = 0) THEN APR.GivenName + ' ' + APR.Surname ELSE
						APR.OrganisationName END) ELSE
					(CASE WHEN (APRN.CompanyFlag = 0) THEN APRN.GivenName + ' ' + APRN.Surname ELSE
						APRN.OrganisationName END) END), '')) > 0)))								
				AND
				(
					@TradingName IS NULL OR @TradingName = ''
					OR (PATINDEX(@TradingName, isnull(APR.TradingName, '')) > 0)
					OR (PATINDEX(@TradingName, isnull(APRN.TradingName, '')) > 0)
				)
				AND		
				(
					@InspectionDateFrom IS NULL OR @InspectionDateFrom = '' Or
					DATEDIFF(day, @InspectionDateFrom, N.InspectionDate) >= 0
				)
				AND
				(
					@InspectionDateTo IS NULL OR @InspectionDateTo = '' Or
					DATEDIFF(day, @InspectionDateTo, N.InspectionDate) <= 0
				)
				AND		-- PALMS V6.2
				(
					@CompleteFromDate IS NULL OR @CompleteFromDate = '' Or
					DATEDIFF(day, @CompleteFromDate, I.DateIssued) >= 0
				)
				AND		-- PALMS V6.2
				(
					@CompleteToDate IS NULL OR @CompleteToDate = '' Or
					DATEDIFF(day, @CompleteToDate, I.DateIssued) <= 0
				)
							
					
			--Added in 31-02-2012 for returning the number of total rows		
			DECLARE @ActualCount INT
			SELECT @ActualCount = COUNT(RecordNo) from @InstrumentResultRows			
			UPDATE @InstrumentResultRows SET RowCountTotal = @ActualCount					
											 
			IF(@ToExport = 1)
				BEGIN
					Select TOP(@MaxRecordsExport) * from @InstrumentResultRows order by RecordNo
				END
			Else
				Begin
			    --If the return count is less than the limit such as 500 records in total then
			    --we get those records in batch such as every time we get 50 records
			    
					IF(@ActualCount <= @NoOfRecordsRequired)				
						SELECT TOP (@pageSize) *  FROM @InstrumentResultRows 
						WHERE RecordNo NOT IN  
						( SELECT TOP ((@pageNum - 1) * (@pageSize)) RecordNo FROM @InstrumentResultRows order by RecordNo )	
						order by RecordNo		
				    ELSE
					    Select 
						0 RecordNo, 
						0 RecordType, 
						0 RecordStatus					    									
				End
				
			delete @InstrumentResultRows
			delete @InstrumentAllRows
	END TRY

	BEGIN CATCH

		DECLARE @ErrorMessage VARCHAR(2000)
		SET @ErrorMessage = dbo.ufn_GetErrorText()
		--RAISERROR (@ErrorMessage , 16, 1)

	END CATCH