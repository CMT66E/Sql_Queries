declare	@xmlSearchCriteria XML
declare @NoOfRecordsRequired int
declare @MaxRecordsExport int
declare @ToExport BIT = 0
declare @pageSize int
declare @pageNum int	
	
set @xmlSearchCriteria = 
'
<DataRiskAssessment>
  <SearchCriteria>
    <LicenceNo>0</LicenceNo>
    <RANo>0</RANo>
    <RAStatusID>0</RAStatusID>
    <AssessmentTypeID>695</AssessmentTypeID>
    <ResponsibleOfficer />
    <APName />
    <SectionID>0</SectionID>
    <StartDate>2010-10-09T00:00:00+11:00</StartDate>
  </SearchCriteria>
</DataRiskAssessment>
'
set @NoOfRecordsRequired = 500
set @MaxRecordsExport = 5000
set @ToExport = 0
set @pageSize= 50
set @pageNum = 1

	
		DECLARE @LicenseNo as int, @RAStatusID int, @RANo as int, @ResponsibleOfficer as Varchar(120),
				@APName as Varchar(100), @StartDate as DateTime, @EndDate as DateTime, 
				@ReceivedDate as DateTime, @SectionId as VarChar(100),
				@StatusFromDate as DateTime, @StatusToDate as DateTime,
				@ResponsibleOfficerID as int,
				@AssessmentTypeID int, @EnvironmentalManagementCategoryID int,
				@OverallRegulatoryPriorityID int, @FeeBasedActivityID int
		
		SELECT 
			@LicenseNo = xmlVals.rowvals.value('(LicenceNo)[1]','INT'),
			@RAStatusID = xmlVals.rowvals.value('(RAStatusID)[1]','INT'),
			@AssessmentTypeID = xmlVals.rowvals.value('(AssessmentTypeID)[1]','INT'),
			@EnvironmentalManagementCategoryID = xmlVals.rowvals.value('(EnvironmentalManagementCategoryID)[1]','INT'),
			@OverallRegulatoryPriorityID = xmlVals.rowvals.value('(OverallRegulatoryPriorityID)[1]','INT'),
			@FeeBasedActivityID = xmlVals.rowvals.value('(FeeBasedActivityID)[1]','INT'),
			@RANo = xmlVals.rowvals.value('(RANo)[1]','INT'),			
			@ResponsibleOfficer = xmlVals.rowvals.value('(ResponsibleOfficer)[1]','VARCHAR(120)'),
			@APName = xmlVals.rowvals.value('(APName)[1]','VARCHAR(100)'),
			@SectionId = xmlVals.rowvals.value('(SectionID)[1]','INT'),
			@StartDate = xmlVals.rowvals.value('(StartDate)[1]','DateTime'),
			@EndDate = xmlVals.rowvals.value('(EndDate)[1]','DateTime')
		
		From @xmlSearchCriteria.nodes('//DataRiskAssessment/SearchCriteria') as xmlVals(rowvals)	
		
		
		print '@StartDate=' + cast(@StartDate as varchar(20))  
		
		IF(@ResponsibleOfficer IS NOT NULL AND LTRIM(RTRIM(@ResponsibleOfficer)) <>'')
			Select @ResponsibleOfficerID =dbo.ufn_GetSystemUserIDByLoginName(@ResponsibleOfficer)
		
		--sb:22/06/2011: below is just to make sure if front end is passing inactive user then assign dummy value to responsible office
		IF(@ResponsibleOfficer IS NOT NULL AND LTRIM(RTRIM(@ResponsibleOfficer)) <>'' AND (@ResponsibleOfficerID IS NULL OR @ResponsibleOfficerID = 0))
			SET @ResponsibleOfficerID = -1
		
		SET @APName = ISNULL(@APName, '');
		
		DECLARE @StatusTable Table(InstrumentID int)
		
		DECLARE @APTable Table(InstrumentID int)
		
		Declare @StatusFilterCount int
		SET @StatusFilterCount = 0

					 --(CASE WHEN AP.CompanyFlag = 0 THEN
					 --        	AP.GivenName + ' ' + AP.Surname ELSE AP.OrganisationName END) AS APName
					         			
		IF (@APName IS NOT NULL AND @APName <> '')
		   Begin
			
			SET @APName = '%' + rtrim(ltrim(@APName)) + '%'			
		      INSERT INTO @APTable
		      (
				InstrumentID
		      )
		      Select RA.InstrumentID from tblInstrument I
		       JOIN tblRiskAssessment RA ON RA.POEOLicenceIntrumentID = I.InstrumentID
		      JOIN tblInstrumentAccountableParty IAP ON I.InstrumentID = IAP.InstrumentID
		      JOIN tblAccountableParty AP ON IAP.AccountablePartyID = AP.AccountablePartyID
		      WHERE (@APName IS NOT NULL AND @APName <> '' AND
			  patindex(@APName, isnull((Case When AP.CompanyFlag = 0 Then AP.GivenName + ' ' + AP.Surname Else AP.OrganisationName End), '')) > 0)
		   End

		--IF @StatusFromDate IS NOT NULL OR @StatusToDate IS NOT NULL
		--	Begin
		--	SET @StatusFilterCount = 1
		--		Insert into @StatusTable
		--		(
		--			InstrumentID
		--		)
		--		Select aul.InstrumentID
		--			From 
		--				tblInstrumentAuditLog aul
		--			Where
		--				(
		--					@StatusFromDate IS NULL OR @StatusFromDate = '' Or
		--					DATEDIFF(day, @StatusFromDate, aul.DateCreated) >= 0
		--				)
		--				AND
		--				(
		--					@StatusToDate IS NULL OR @StatusToDate = '' Or
		--					DATEDIFF(day, @StatusToDate, aul.DateCreated) <= 0
		--				)
		--				AND
		--				(
		--					@LicenseNo IS NULL OR @LicenseNo = 0 
		--					OR
		--					aul.InstrumentID = @LicenseNo
		--				)
		--				AND aul.ChangedStatusFlag = 1
		--	End
		
		DECLARE @NoOfRecords as int		
		--SELECT * FROM @APTable
		Select  
				@NoOfRecords = Count(Distinct RA.InstrumentID)
			From
		tblRiskAssessment RA
		Inner Join 
			tblInstrument i ON RA.InstrumentID = i.InstrumentID
		Left Outer Join
			tblClassification c ON c.ClassificationID = i.InstrumentStatusID
		Left Outer Join 
			tblSystemUser u ON i.ResponsibleSystemUserID = u.SystemUserID
		Left Outer Join 
			tblDECCWSection S On S.DECCWSectionID = i.DECCWSectionID
		LEFT OUTER JOIN
			viewEMAssessmentPeriod EMAP ON RA.InstrumentID = EMAP.InstrumentID	
	Where
		(
			@RANo IS NULL OR @RANo =0
			OR (RA.InstrumentID = @RANo)
		)	
		AND
		(
			@RAStatusID IS NULL OR @RAStatusID = 0
			OR (i.InstrumentStatusID = @RAStatusID)
		)
		AND
		(
			@AssessmentTypeID IS NULL OR @AssessmentTypeID = 0
			OR (RA.RiskAssessmentTypeID = @AssessmentTypeID)
		)
		AND
		(
			@EnvironmentalManagementCategoryID IS NULL OR @EnvironmentalManagementCategoryID = 0
			OR (RA.EnvironmentalManagementCategoryID = @EnvironmentalManagementCategoryID)
		)
		AND
		(
			@OverallRegulatoryPriorityID IS NULL OR @OverallRegulatoryPriorityID = 0
			OR (RA.OverallRegulatoryPriorityID = @OverallRegulatoryPriorityID)
		)
		AND
		(
			@ResponsibleOfficerID IS NULL OR @ResponsibleOfficerID =0
			OR (i.ResponsibleSystemUserID = @ResponsibleOfficerID)
		)
		AND
		(
			@LicenseNo IS NULL OR @LicenseNo = 0
			OR (RA.POEOLicenceIntrumentID = @LicenseNo)
		)
		AND
		(
			@StartDate IS NULL OR @StartDate ='' OR
			DATEDIFF(day, @StartDate, EMAP.StartDate) >= 0
		)
		AND
		(
			@EndDate IS NULL OR @EndDate ='' OR
			DATEDIFF(day, EMAP.EndDate, @EndDate ) >= 0
		)
		AND
		(
			@SectionId IS NULL OR @SectionId = 0
			OR (I.DECCWSectionID = @SectionId)
		)
		AND
		(				
			@StatusFilterCount = 0
			OR RA.InstrumentID IN (Select InstrumentID from @StatusTable)
		)
		AND
		(				
			@APName IS NULL OR @APName ='' OR
			RA.InstrumentID IN (Select InstrumentID from @APTable)
		)
		--AND
		--(	
			
		--	ar.InstrumentID IN(Select InstrumentID from @InstrumentAllRows)
		--)
		--Print @NoOfRecords
		--Print @NoOfRecordsRequired

		--if search goes here we count the number of return rows greater than @NoOfRecordsRequired we need stop search
		IF(@NoOfRecords > @NoOfRecordsRequired AND @ToExport = 0)
		Begin
						SELECT 
							'0' as LicenseNo, 
							'0' as ARNo,
							'0' as ResponsibleOfficer,
							'0' as APName,
							'0' as Section, 
							'0' as [Status],
							'0' as LicenseType,
							'0' as ReportingPeriodID	
					 
					return
		End

        --Added in 31-01-2012 create a temp table to hold all search records
		Create Table #InstrumentResultRows
		(
			LicenseNo int null,
			RANo int null,
			RAType VARCHAR(50),
			ResponsibleOfficer varchar(120),
			APName Varchar(200),
			CreatedDate Datetime,
			StartDate DateTime,			
			EndDate DateTime,
			Section Varchar(100), 
			InstrumentStatus Varchar(255), 
			AssessmentResult  VARCHAR(255),
			RiskAssessmentTypeID INT,
			RowCountTotal int null
		)
		
		IF(@NoOfRecords > 0)
			Begin
						Insert Into #InstrumentResultRows
						(
							LicenseNo,
							RANo,
							RAType,
							ResponsibleOfficer,
							APName,
							CreatedDate,
							StartDate,			
							EndDate,
							Section, 
							InstrumentStatus,
							AssessmentResult,
							RiskAssessmentTypeID
															 		
						)											
						Select Distinct 
						    --TOP(CASE WHEN @ToExport = 1 THEN @MaxRecordsExport ELSE @NoOfRecordsRequired END)
							RA.POEOLicenceIntrumentID LicenseNo,
							RA.InstrumentID ARNo,
							W.Description As RAType,
							u.GivenName + ' ' + u.Surname ResponsibleOfficer,
							dbo.ufn_GetInstrumentFirstAccountableParty(RA.POEOLicenceIntrumentID) AS APName,
							RA.DateCreated,
							EMAP.StartDate,
							EMAP.EndDate,
							S.Name Section,
							c.Name InstrumentStatus,
							AssessmentResult = 
							CASE
							  WHEN RA.RiskAssessmentTypeID = 694 THEN X.Description
							  ELSE Y.Description  
							  END,
							 RA.RiskAssessmentTypeID 
						
						From
							tblRiskAssessment RA
							Inner Join 
								tblInstrument i ON RA.InstrumentID = i.InstrumentID
							INNER JOIN tblClassification W ON RA.RiskAssessmentTypeID = W.ClassificationID	
							LEFT OUTER JOIN tblClassification X ON RA.OverallRegulatoryPriorityID = X.ClassificationID
							LEFT OUTER JOIN tblClassification Y ON RA.EnvironmentalManagementCategoryID = Y.ClassificationID
							Left Outer Join
								viewInstrumentLocationAnnualReturn vwLoc ON vwLoc.InstrumentID = RA.POEOLicenceIntrumentID 
							Left Outer Join
								tblClassification c ON c.ClassificationID = i.InstrumentStatusID
							Left Outer Join 
								tblSystemUser u ON i.ResponsibleSystemUserID = u.SystemUserID
							Left Outer Join 
								tblDECCWSection S On S.DECCWSectionID = i.DECCWSectionID
							LEFT OUTER JOIN
								viewEMAssessmentPeriod EMAP ON RA.InstrumentID = EMAP.InstrumentID
							LEFT OUTER JOIN 
								tblPOEOLicenceFeeBasedActivity F ON RA.POEOLicenceIntrumentID = F.InstrumentID
							LEFT OUTER JOIN
								tblFeeBasedActivity FA ON F.FeeBasedActivityID = FA.FeeBasedActivityID				
						Where
							(
								@RANo IS NULL OR @RANo =0
								OR (RA.InstrumentID = @RANo)
							)	
							AND
							(
								@RAStatusID IS NULL OR @RAStatusID = 0
								OR (i.InstrumentStatusID = @RAStatusID)
							)
							AND
							(
								@AssessmentTypeID IS NULL OR @AssessmentTypeID = 0
								OR (RA.RiskAssessmentTypeID = @AssessmentTypeID)
							)
							AND
							(
								@EnvironmentalManagementCategoryID IS NULL OR @EnvironmentalManagementCategoryID = 0
								OR (RA.EnvironmentalManagementCategoryID = @EnvironmentalManagementCategoryID)
							)
							AND
							(
								@OverallRegulatoryPriorityID IS NULL OR @OverallRegulatoryPriorityID = 0
								OR (RA.OverallRegulatoryPriorityID = @OverallRegulatoryPriorityID)
							)
								AND
							(
								@FeeBasedActivityID IS NULL OR @FeeBasedActivityID = 0
								OR (FA.FeeBasedActivityID = @FeeBasedActivityID)
							)
							AND
							(
								@ResponsibleOfficerID IS NULL OR @ResponsibleOfficerID =0
								OR (i.ResponsibleSystemUserID = @ResponsibleOfficerID)
							)
							AND
							(
								@LicenseNo IS NULL OR @LicenseNo = 0
								OR (RA.POEOLicenceIntrumentID = @LicenseNo)
							)
							AND
							(
								@StartDate IS NULL OR @StartDate ='' OR
								DATEDIFF(day, @StartDate, EMAP.StartDate) > 0
							)
							AND
							(
								@EndDate IS NULL OR @EndDate ='' OR
								DATEDIFF(day, EMAP.EndDate, @EndDate ) >= 0
							)
							AND
							(
								@SectionId IS NULL OR @SectionId = 0
								OR (i.DECCWSectionID = @SectionId)
							)
							AND
							(				
								@StatusFilterCount = 0
								OR RA.InstrumentID IN (Select InstrumentID from @StatusTable)
							)
							AND
							(				
								@APName IS NULL OR @APName ='' OR
								RA.InstrumentID IN (Select InstrumentID from @APTable)
							)

			End
		--Else
		--    Begin
		--				Insert Into #InstrumentResultRows
		--				(
		--					LicenseNo,
		--					RANo,
		--					ResponsibleOfficer,
		--					APName,
		--					ReceivedDate,
		--					StartDate,			
		--					EndDate,
		--					Section, 
		--					[Status], 
		--					[StatusChangedDate],
		--					LicenseType,
		--					ReportingPeriodID 						 		
		--				)		        
		--	           Select Distinct 
		--	                --TOP(CASE WHEN @ToExport = 1 THEN @MaxRecordsExport ELSE @NoOfRecordsRequired END)
		--					rp.InstrumentID LicenseNo, 			
		--					ar.InstrumentID ARNo,
		--					u.GivenName + ' ' + u.Surname ResponsibleOfficer,
		--					(Case When vwAP.CompanyFlag = 0 Then vwAP.GivenName + ' ' + vwAP.Surname Else vwAP.OrganisationName End) APName,
		--					ar.ReceivedDate,
		--					rp.StartDate,
		--					rp.EndDate,
		--					S.Name Section,
		--					c.Name [Status],					
		--					al.DateCreated [StatusChangedDate],
		--					i.InstrumentTypeID LicenseType,
		--					ar.ReportingPeriodID
		--				From
		--					tblAnnualReturn ar 
		--					Inner Join
		--						tblReportingPeriod rp ON ar.ReportingPeriodID = rp.ReportingPeriodID
		--					Inner Join 
		--						tblInstrument iar ON ar.InstrumentID = iar.InstrumentID
		--					LEFT OUTER JOIN tblInstrumentAccountableParty IAP
		--						ON IAP.AccountablePartyID = (Select MIN(IAP1.AccountablePartyID) from tblInstrumentAccountableParty IAP1
		--											Where IAP1.InstrumentID = rp.InstrumentID)
		--					--LEFT OUTER JOIN viewInstrumentAccountablePartyAnnualReturn vwAP
		--					--	ON vwAP.AccountablePartyID = IAP.AccountablePartyID
		--					left outer join tblAccountableParty vwAP ON vwAP.AccountablePartyID = IAP.AccountablePartyID
		--					Left Outer Join
		--						viewInstrumentLocationAnnualReturn vwLoc ON vwLoc.InstrumentID = ar.InstrumentID
		--					Left Outer Join
		--						tblClassification c ON c.ClassificationID = iar.InstrumentStatusID
		--					Left Outer Join 
		--						tblSystemUser u ON iar.ResponsibleSystemUserID = u.SystemUserID
		--					Left outer Join
		--						tblInstrumentAuditLog al ON al.InstrumentAuditLogID = 
		--						(Select Max(InstrumentAuditLogID) from tblInstrumentAuditLog al1 Where al1.InstrumentID = ar.InstrumentID AND al1.ChangedStatusFlag = 1)					
		--					Left Outer Join
		--						tblInstrument i ON i.InstrumentID = rp.InstrumentID
		--					Left Outer Join 
		--						tblDECCWSection S On S.DECCWSectionID = iar.DECCWSectionID
		--				Where iar.InstrumentID = -1	
		--	End		
				
				
			--Added in 31-02-2012 for returning the number of total rows		
			DECLARE @ActualCount INT
			SELECT @ActualCount = COUNT(RANo) from #InstrumentResultRows			
			UPDATE #InstrumentResultRows SET RowCountTotal = @ActualCount					
								
			--IF(NOT(Select COUNT(RecordNo) from #InstrumentResultRows) > @NoOfRecordsRequired OR @ToExport = 1)
			IF(@ToExport = 1)
				BEGIN
					Select TOP(@MaxRecordsExport) * from #InstrumentResultRows order by StartDate
				END
			Else
				Begin	
				    IF(@ActualCount <= @NoOfRecordsRequired)		
						SELECT TOP (@pageSize) *  FROM #InstrumentResultRows
						WHERE RANo NOT IN  
						( SELECT TOP ((@pageNum - 1) * (@pageSize)) RANo FROM #InstrumentResultRows order by RANo )	
						 order by StartDate
					ELSE
						SELECT 
							'0' as LicenseNo, 
							'0' as ARNo,
							'0' as ResponsibleOfficer,
							'0' as APName,
							'0' as Section, 
							'0' as [Status],
							'0' as LicenseType,
							'0' as ReportingPeriodID																				
				End
				
			Drop Table #InstrumentResultRows				