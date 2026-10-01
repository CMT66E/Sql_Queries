USE [PALMSDB]
GO
/****** Object:  StoredProcedure [dbo].[uspSecondaryRecordSearchNew]    Script Date: 26/07/2017 10:33:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Wasif Modified by Eric He in 31-01-2012
-- Create date: 26/10/2010
-- Description:	Search secondary record types
-- Update: By Duminda A on 1st May 2015 to add Completed Date filter for V6.2
-- =============================================

ALTER PROCEDURE [dbo].[uspSecondaryRecordSearchNew] 
(	
	@xmlSearchCriteria XML,
	@NoOfRecordsRequired int,
	@MaxRecordsExport int,
	@ToExport BIT = 0,
	@pageSize int,
	@pageNum int
)
AS
BEGIN
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
			@CompleteToDate as DateTime,
			@IsFromeConnect as BIT;

		
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
			@CompleteToDate = xmlVals.rowvals.value('(CompleteToDate)[1]','DateTime'),
			@IsFromeConnect = xmlVals.rowvals.value('(IsFromeConnect)[1]','BIT')
		From @xmlSearchCriteria.nodes('//DataSearch/SecondarySearchCriteria') as xmlVals(rowvals)		
		
		
		if @IsFromeConnect is not null
		begin
		  if @IsFromeConnect = 1 
		    print '@IsFromeConnect true = ' + cast(@IsFromeConnect as varchar)
		  if @IsFromeConnect = 0 
		    print '@IsFromeConnect false = ' + cast(@IsFromeConnect as varchar)		  
		end
		else
		   set @IsFromeConnect = null 

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
			
		if isnull(@RecordNo, 0) = 0
		begin 									
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
		end	
			
		
		declare @InstrumentAllRows as Table
		(
			InstrumentID int
		)
			
		IF @RecordNo IS NOT NULL AND @RecordNo != 0
		BEGIN
			Insert Into @InstrumentAllRows
			(
				InstrumentID
			)							
			SELECT DISTINCT
				[I].InstrumentID	
			FROM 
				tblInstrument I		
			WHERE I.InstrumentID = @RecordNo								 
		END
		ELSE
		BEGIN						
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
			LEFT OUTER JOIN tblOnlineLicenceChangeApplication OLC ON [IN].NoticeInstrumentID = OLC.NoticeInstrumentID								
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
				AND 				
			    (
				   [N].InstrumentID =
			                        (CASE isnull(@IsFromeConnect, '') when '' then [N].InstrumentID
								                          when 1 then OLC.NoticeInstrumentID
								                          when 0 then [N].InstrumentID													               
								   END)	
				)
    --            AND 
				--[IN].NoticeInstrumentID IN
			 --                       (CASE isnull(@IsFromeConnect, '') when '' then [IN].NoticeInstrumentID
				--				                        when 1 then (select MIN(NoticeInstrumentID) from tblOnlineLicenceChangeApplication where not NoticeInstrumentID is null and NoticeInstrumentID = [IN].NoticeInstrumentID)
				--				                        when 0 then 
				--										  (select NoticeInstrumentID from tblInstrumentNotice where NoticeInstrumentID = [IN].NoticeInstrumentID and not NoticeInstrumentID in (select NoticeInstrumentID from tblOnlineLicenceChangeApplication where not NoticeInstrumentID is null))
				--				   END)	
		END						
			
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
			TemplateTypeID int null,
			NoticeInstrumentID int null				
		)
		
		IF @RecordNo IS NOT NULL AND @RecordNo != 0  --in case the user input the secondary record number we quickly get results
		BEGIN
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
						Where AL1.InstrumentID = I.InstrumentID AND al1.ChangedStatusFlag = 1 AND AL1.InstrumentID = @RecordNo)
				LEFT OUTER JOIN tblDECCWSection DS
					ON DS.DECCWSectionID = I.DECCWSectionID
				LEFT OUTER JOIN @AccountableParty AP 
					ON AP.InstrumentId = [I].InstrumentID
				LEFT OUTER JOIN tblInstrumentAccountableParty IAP ON
				IAP.InstrumentAccountablePartyID = (Select MIN(IAP1.InstrumentAccountablePartyID)
					FROM tblInstrumentAccountableParty IAP1 WHERE IAP1.InstrumentID = @RecordNo)
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
				WHERE  
					 I.InstrumentID = @RecordNo
		END
		ELSE
		BEGIN
		    IF ( (Select COUNT(InstrumentID) from @InstrumentAllRows) <= @NoOfRecordsRequired AND @ToExport = 0)
			begin
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
			LEFT OUTER JOIN tblOnlineLicenceChangeApplication OLC ON [IN].NoticeInstrumentID = OLC.NoticeInstrumentID	  
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
						I.InstrumentID IN (Select InstrumentID from @StatusTable)					
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
				AND 				
			    (
				   [N].InstrumentID =
			                        (CASE isnull(@IsFromeConnect, '') when '' then [N].InstrumentID
								                          when 1 then OLC.NoticeInstrumentID
								                          when 0 then [N].InstrumentID													               
								   END)	
				)				 
			end
		END					


        If @IsFromeConnect is not null --here we handle the eConnect application search criteria in caseu the end users is searching on this condition        
		begin
			  declare @FilterResultRows as Table
			  (
			   NoticeInstrumentID int null
			  )

			  insert into @FilterResultRows
              select a.NoticeInstrumentID
			  from tblOnlineLicenceChangeApplication a left outer join @InstrumentResultRows [IN] on a.NoticeInstrumentID = [IN].NoticeInstrumentID 
							where not a.NoticeInstrumentID is null
	 
		      if @IsFromeConnect = 0
		         delete from @InstrumentResultRows where NoticeInstrumentID in (select NoticeInstrumentID from @FilterResultRows)
		end 	

								
		--Added in 31-02-2012 for returning the number of total rows 			
		DECLARE @ActualCount INT	
		If ((Select COUNT(InstrumentID) from @InstrumentAllRows) > @NoOfRecordsRequired AND @ToExport = 0)
		begin
				select @ActualCount = COUNT(InstrumentID) from @InstrumentAllRows
				UPDATE @InstrumentResultRows SET RowCountTotal = @ActualCount	
		end
		else
		begin
				select @ActualCount = COUNT(RecordNo) from @InstrumentResultRows					
				UPDATE @InstrumentResultRows SET RowCountTotal = @ActualCount	
		end			
				
											 
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
END


