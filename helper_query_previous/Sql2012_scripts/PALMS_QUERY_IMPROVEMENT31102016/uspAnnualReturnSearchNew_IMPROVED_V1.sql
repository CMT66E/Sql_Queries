declare @xmlSearchCriteria XML
set @xmlSearchCriteria = 
'
<DataAnnualReturn>
  <SearchCriteria>
    <LicenseNo>0</LicenseNo>
    <ARNo>0</ARNo>
    <ArStatusID>0</ArStatusID>
    <ResponsibleOfficer />
    <APName>Hunter Water Corporation</APName>
    <Section>0</Section>
  </SearchCriteria>
</DataAnnualReturn>
'
declare @NoOfRecordsRequired int = 500
declare @MaxRecordsExport int = 5000
declare @ToExport BIT = 0
declare @pageSize int = 50
declare @pageNum int = 1

BEGIN TRY
		DECLARE @LicenseNo as int, @ARStatusID int, @ArNo as int, @ResponsibleOfficer as Varchar(120),
				@APName as Varchar(100), @StartDate as DateTime, @EndDate as DateTime, 
				@ReceivedDate as DateTime, @SectionId as VarChar(100),
				@StatusFromDate as DateTime, @StatusToDate as DateTime,
				@ResponsibleOfficerID as int
		
		SELECT 
			@LicenseNo = xmlVals.rowvals.value('(LicenseNo)[1]','INT'),
			@ARStatusID = xmlVals.rowvals.value('(ArStatusID)[1]','INT'),
			@ArNo = xmlVals.rowvals.value('(ARNo)[1]','INT'),			
			@ResponsibleOfficer = xmlVals.rowvals.value('(ResponsibleOfficer)[1]','VARCHAR(120)'),
			@APName = xmlVals.rowvals.value('(APName)[1]','VARCHAR(100)'),
			@SectionId = xmlVals.rowvals.value('(Section)[1]','VARCHAR(100)'),
			@StatusFromDate = xmlVals.rowvals.value('(StatusFromDate)[1]','DateTime'),
			@StatusToDate = xmlVals.rowvals.value('(StatusToDate)[1]','DateTime'),
			@StartDate = xmlVals.rowvals.value('(StartDate)[1]','DateTime'),
			@EndDate = xmlVals.rowvals.value('(EndDate)[1]','DateTime'),
			@ReceivedDate = xmlVals.rowvals.value('(ReceivedDate)[1]','DateTime')
		From @xmlSearchCriteria.nodes('//DataAnnualReturn/SearchCriteria') as xmlVals(rowvals)	
		
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
		    Insert into @APTable
		    (
			InstrumentID
		    )
		    Select AR.InstrumentID from tblInstrument I
		    JOIN tblInstrumentAccountableParty IAP ON I.InstrumentID = IAP.InstrumentID
		    JOIN tblAccountableParty AP ON IAP.AccountablePartyID = AP.AccountablePartyID
		    JOIN tblReportingPeriod RP ON RP.InstrumentID = I.InstrumentID
		    join tblAnnualReturn AR ON AR.ReportingPeriodID = RP.ReportingPeriodID
		    WHERE I.InstrumentTypeID =493 AND (@APName IS NOT NULL AND @APName <> '' AND
			patindex(@APName, isnull((Case When AP.CompanyFlag = 0 Then AP.GivenName + ' ' + AP.Surname Else AP.OrganisationName End), '')) > 0)
		End

		IF @StatusFromDate IS NOT NULL OR @StatusToDate IS NOT NULL
		Begin
		    SET @StatusFilterCount = 1
			Insert into @StatusTable
			(
				InstrumentID
			)
			Select aul.InstrumentID
				From 
					tblInstrumentAuditLog aul inner join tblAnnualReturn ar on aul.InstrumentID = ar.InstrumentID
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
						@LicenseNo IS NULL OR @LicenseNo = 0 
						OR
						aul.InstrumentID = @LicenseNo
					)
					AND 
					    aul.ChangedStatusFlag = 1
		End

		--here we put all InstrumentID into temp table: @StatusTable
		if exists(select InstrumentID from @APTable)
		begin    
			Insert into @StatusTable
			(
				InstrumentID
			)
			Select aul.InstrumentID From @APTable aul
	    end

--select a.*, b.* from @StatusTable a inner join tblInstrument b on a.InstrumentID = b.InstrumentID

        DECLARE @FilterCount int = 0
        SELECT @FilterCount = COUNT(*) FROM @StatusTable

		DECLARE @NoOfRecords as int	
		
		if @FilterCount > 0
		begin
		        print 'counting A'
				Select  
						@NoOfRecords = Count(Distinct ar.InstrumentID)
				From @StatusTable ST 
				inner join 
				    tblAnnualReturn ar ON ST.InstrumentID = ar.InstrumentID				  
				Inner Join
					tblReportingPeriod rp ON ar.ReportingPeriodID = rp.ReportingPeriodID
				Inner Join 
					tblInstrument iar ON ar.InstrumentID = iar.InstrumentID
				Left Outer Join
					viewInstrumentLocationAnnualReturn vwLoc ON vwLoc.InstrumentID = ar.InstrumentID
				Left Outer Join
					tblClassification c ON c.ClassificationID = iar.InstrumentStatusID
				Left Outer Join 
					tblSystemUser u ON iar.ResponsibleSystemUserID = u.SystemUserID
				Left outer Join
					tblInstrumentAuditLog al ON al.InstrumentAuditLogID = 
					(Select Max(InstrumentAuditLogID) from tblInstrumentAuditLog al1 Where al1.InstrumentID = ar.InstrumentID AND al1.ChangedStatusFlag = 1)		
				Left Outer Join
					tblInstrument i ON i.InstrumentID = rp.InstrumentID
				Left Outer Join 
					tblDECCWSection S On S.DECCWSectionID = iar.DECCWSectionID
				Where
				(
					@ArNo IS NULL OR @ArNo =0
					OR (ar.InstrumentID = @ArNo)
				)	
				AND
				(
					@ARStatusID IS NULL OR @ARStatusID = 0
					OR (iar.InstrumentStatusID = @ARStatusID)
				)
				AND
				(
					@ResponsibleOfficerID IS NULL OR @ResponsibleOfficerID =0
					OR (iar.ResponsibleSystemUserID = @ResponsibleOfficerID)
				)
				AND
				(
					@LicenseNo IS NULL OR @LicenseNo = 0
					OR (rp.InstrumentID = @LicenseNo)
				)
				AND
				(
					@StartDate IS NULL OR @StartDate ='' OR
					DATEDIFF(day, @StartDate, rp.StartDate) = 0
				)
				AND
				(
					@EndDate IS NULL OR @EndDate ='' OR
					DATEDIFF(day, @EndDate, rp.EndDate) = 0
				)
				AND
				(
					@ReceivedDate IS NULL OR @ReceivedDate ='' OR
					DATEDIFF(day, @ReceivedDate, ar.ReceivedDate) = 0
				)
				AND
				(
					@SectionId IS NULL OR @SectionId = 0
					OR (iar.DECCWSectionID = @SectionId)
				)
				--AND
				--(				
				--	@APName IS NULL OR @APName ='' OR
				--	ar.InstrumentID IN (Select InstrumentID from @APTable)
				--)
		end
		else
		begin		
		        print 'counting B'	 
				Select  
						@NoOfRecords = Count(Distinct ar.InstrumentID)
				From
				tblAnnualReturn ar 
				Inner Join
					tblReportingPeriod rp ON ar.ReportingPeriodID = rp.ReportingPeriodID
				Inner Join 
					tblInstrument iar ON ar.InstrumentID = iar.InstrumentID
				Left Outer Join
					viewInstrumentLocationAnnualReturn vwLoc ON vwLoc.InstrumentID = ar.InstrumentID
				Left Outer Join
					tblClassification c ON c.ClassificationID = iar.InstrumentStatusID
				Left Outer Join 
					tblSystemUser u ON iar.ResponsibleSystemUserID = u.SystemUserID
				Left outer Join
					tblInstrumentAuditLog al ON al.InstrumentAuditLogID = 
					(Select Max(InstrumentAuditLogID) from tblInstrumentAuditLog al1 Where al1.InstrumentID = ar.InstrumentID AND al1.ChangedStatusFlag = 1)		
				Left Outer Join
					tblInstrument i ON i.InstrumentID = rp.InstrumentID
				Left Outer Join 
					tblDECCWSection S On S.DECCWSectionID = iar.DECCWSectionID
				Where
				(
					@ArNo IS NULL OR @ArNo =0
					OR (ar.InstrumentID = @ArNo)
				)	
				AND
				(
					@ARStatusID IS NULL OR @ARStatusID = 0
					OR (iar.InstrumentStatusID = @ARStatusID)
				)
				AND
				(
					@ResponsibleOfficerID IS NULL OR @ResponsibleOfficerID =0
					OR (iar.ResponsibleSystemUserID = @ResponsibleOfficerID)
				)
				AND
				(
					@LicenseNo IS NULL OR @LicenseNo = 0
					OR (rp.InstrumentID = @LicenseNo)
				)
				AND
				(
					@StartDate IS NULL OR @StartDate ='' OR
					DATEDIFF(day, @StartDate, rp.StartDate) = 0
				)
				AND
				(
					@EndDate IS NULL OR @EndDate ='' OR
					DATEDIFF(day, @EndDate, rp.EndDate) = 0
				)
				AND
				(
					@ReceivedDate IS NULL OR @ReceivedDate ='' OR
					DATEDIFF(day, @ReceivedDate, ar.ReceivedDate) = 0
				)
				AND
				(
					@SectionId IS NULL OR @SectionId = 0
					OR (iar.DECCWSectionID = @SectionId)
				)
				--AND
				--(				
				--	@APName IS NULL OR @APName ='' OR
				--	ar.InstrumentID IN (Select InstrumentID from @APTable)
				--)
	    end

		Print '@NoOfRecords =' + cast(@NoOfRecords as varchar)
		Print '@NoOfRecordsRequired = ' + cast(@NoOfRecordsRequired as varchar)

 
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
			ARNo int null,
			ResponsibleOfficer varchar(120),
			APName Varchar(200),
			ReceivedDate DateTime,
			StartDate DateTime,			
			EndDate DateTime,
			Section Varchar(100), 
			[Status] Varchar(255), 
			[StatusChangedDate] DateTime,
			LicenseType int null,
			ReportingPeriodID int null,						 
			RowCountTotal int null
		)
		
		IF(@NoOfRecords > 0)
			Begin
			       if @FilterCount > 0
				   begin
                        print 'action A'
						Insert Into #InstrumentResultRows
						(
							LicenseNo,
							ARNo,
							ResponsibleOfficer,
							APName,
							ReceivedDate,
							StartDate,			
							EndDate,
							Section, 
							[Status], 
							[StatusChangedDate],
							LicenseType,
							ReportingPeriodID 						 		
						)											
						Select Distinct 						    
							rp.InstrumentID LicenseNo,
							ar.InstrumentID ARNo,
							u.GivenName + ' ' + u.Surname ResponsibleOfficer,
							dbo.ufn_GetInstrumentFirstAccountableParty(rp.InstrumentID) AS APName,
							ar.ReceivedDate,
							rp.StartDate,
							rp.EndDate,
							S.Name Section,
							c.Name [Status],					
							al.DateCreated [StatusChangedDate],
							i.InstrumentTypeID LicenseType,
							ar.ReportingPeriodID
						From @StatusTable ST  
						    inner join 
							tblAnnualReturn ar ON ST.InstrumentID = ar.InstrumentID
							Inner Join
								tblReportingPeriod rp ON ar.ReportingPeriodID = rp.ReportingPeriodID
							Inner Join 
								tblInstrument iar ON ar.InstrumentID = iar.InstrumentID
							Left Outer Join
								viewInstrumentLocationAnnualReturn vwLoc ON vwLoc.InstrumentID = ar.InstrumentID
							Left Outer Join
								tblClassification c ON c.ClassificationID = iar.InstrumentStatusID
							Left Outer Join 
								tblSystemUser u ON iar.ResponsibleSystemUserID = u.SystemUserID
							Left outer Join
								tblInstrumentAuditLog al ON al.InstrumentAuditLogID = 
								(Select Max(InstrumentAuditLogID) from tblInstrumentAuditLog al1 Where al1.InstrumentID = ar.InstrumentID AND al1.ChangedStatusFlag = 1)					
							Left Outer Join
								tblInstrument i ON i.InstrumentID = rp.InstrumentID
							Left Outer Join 
								tblDECCWSection S On S.DECCWSectionID = iar.DECCWSectionID
						Where
						    
							(
								@ArNo IS NULL OR @ArNo =0
								OR (ar.InstrumentID = @ArNo)
							)	
							AND
							(
								@ARStatusID IS NULL OR @ARStatusID = 0
								OR (iar.InstrumentStatusID = @ARStatusID)
							)
							AND
							(
								@ResponsibleOfficerID IS NULL OR @ResponsibleOfficerID =0
								OR (iar.ResponsibleSystemUserID = @ResponsibleOfficerID)
							)
							AND
							(
								@LicenseNo IS NULL OR @LicenseNo = 0
								OR (rp.InstrumentID = @LicenseNo)
							)
							AND
							(
								@StartDate IS NULL OR @StartDate ='' OR
								DATEDIFF(day, @StartDate, rp.StartDate) = 0
							)
							AND
							(
								@EndDate IS NULL OR @EndDate ='' OR
								DATEDIFF(day, @EndDate, rp.EndDate) = 0
							)
							AND
							(
								@ReceivedDate IS NULL OR @ReceivedDate ='' OR
								DATEDIFF(day, @ReceivedDate, ar.ReceivedDate) = 0
							)
							AND
							(
								@SectionId IS NULL OR @SectionId = 0
								OR (iar.DECCWSectionID = @SectionId)
							)
							--we don't need the following conditions as we used table: @StatusTable
							--AND
							--(				
							--	@StatusFilterCount = 0
							--	OR ar.InstrumentID IN (Select InstrumentID from @StatusTable)
							--)
							--AND
							--(				
							--	@APName IS NULL OR @APName ='' OR
							--	ar.InstrumentID IN (Select InstrumentID from @APTable)
							--)
				   end
				   else
				   begin
			            print 'action AA'
						Insert Into #InstrumentResultRows
						(
							LicenseNo,
							ARNo,
							ResponsibleOfficer,
							APName,
							ReceivedDate,
							StartDate,			
							EndDate,
							Section, 
							[Status], 
							[StatusChangedDate],
							LicenseType,
							ReportingPeriodID 						 		
						)											
						Select Distinct 						    
							rp.InstrumentID LicenseNo,
							ar.InstrumentID ARNo,
							u.GivenName + ' ' + u.Surname ResponsibleOfficer,
							dbo.ufn_GetInstrumentFirstAccountableParty(rp.InstrumentID) AS APName,
							ar.ReceivedDate,
							rp.StartDate,
							rp.EndDate,
							S.Name Section,
							c.Name [Status],					
							al.DateCreated [StatusChangedDate],
							i.InstrumentTypeID LicenseType,
							ar.ReportingPeriodID
						From
							tblAnnualReturn ar 
							Inner Join
								tblReportingPeriod rp ON ar.ReportingPeriodID = rp.ReportingPeriodID
							Inner Join 
								tblInstrument iar ON ar.InstrumentID = iar.InstrumentID
							Left Outer Join
								viewInstrumentLocationAnnualReturn vwLoc ON vwLoc.InstrumentID = ar.InstrumentID
							Left Outer Join
								tblClassification c ON c.ClassificationID = iar.InstrumentStatusID
							Left Outer Join 
								tblSystemUser u ON iar.ResponsibleSystemUserID = u.SystemUserID
							Left outer Join
								tblInstrumentAuditLog al ON al.InstrumentAuditLogID = 
								(Select Max(InstrumentAuditLogID) from tblInstrumentAuditLog al1 Where al1.InstrumentID = ar.InstrumentID AND al1.ChangedStatusFlag = 1)					
							Left Outer Join
								tblInstrument i ON i.InstrumentID = rp.InstrumentID
							Left Outer Join 
								tblDECCWSection S On S.DECCWSectionID = iar.DECCWSectionID
						Where
							(
								@ArNo IS NULL OR @ArNo =0
								OR (ar.InstrumentID = @ArNo)
							)	
							AND
							(
								@ARStatusID IS NULL OR @ARStatusID = 0
								OR (iar.InstrumentStatusID = @ARStatusID)
							)
							AND
							(
								@ResponsibleOfficerID IS NULL OR @ResponsibleOfficerID =0
								OR (iar.ResponsibleSystemUserID = @ResponsibleOfficerID)
							)
							AND
							(
								@LicenseNo IS NULL OR @LicenseNo = 0
								OR (rp.InstrumentID = @LicenseNo)
							)
							AND
							(
								@StartDate IS NULL OR @StartDate ='' OR
								DATEDIFF(day, @StartDate, rp.StartDate) = 0
							)
							AND
							(
								@EndDate IS NULL OR @EndDate ='' OR
								DATEDIFF(day, @EndDate, rp.EndDate) = 0
							)
							AND
							(
								@ReceivedDate IS NULL OR @ReceivedDate ='' OR
								DATEDIFF(day, @ReceivedDate, ar.ReceivedDate) = 0
							)
							AND
							(
								@SectionId IS NULL OR @SectionId = 0
								OR (iar.DECCWSectionID = @SectionId)
							)
							AND
							(				
								@StatusFilterCount = 0
								OR ar.InstrumentID IN (Select InstrumentID from @StatusTable)
							)
							AND
							(				
								@APName IS NULL OR @APName ='' OR
								ar.InstrumentID IN (Select InstrumentID from @APTable)
							)
				   end
			End
		Else
		    Begin
			            print 'action B'
						Insert Into #InstrumentResultRows
						(
							LicenseNo,
							ARNo,
							ResponsibleOfficer,
							APName,
							ReceivedDate,
							StartDate,			
							EndDate,
							Section, 
							[Status], 
							[StatusChangedDate],
							LicenseType,
							ReportingPeriodID 						 		
						)		        
			           Select Distinct 
			                --TOP(CASE WHEN @ToExport = 1 THEN @MaxRecordsExport ELSE @NoOfRecordsRequired END)
							rp.InstrumentID LicenseNo, 			
							ar.InstrumentID ARNo,
							u.GivenName + ' ' + u.Surname ResponsibleOfficer,
							(Case When vwAP.CompanyFlag = 0 Then vwAP.GivenName + ' ' + vwAP.Surname Else vwAP.OrganisationName End) APName,
							ar.ReceivedDate,
							rp.StartDate,
							rp.EndDate,
							S.Name Section,
							c.Name [Status],					
							al.DateCreated [StatusChangedDate],
							i.InstrumentTypeID LicenseType,
							ar.ReportingPeriodID
						From
							tblAnnualReturn ar 
							Inner Join
								tblReportingPeriod rp ON ar.ReportingPeriodID = rp.ReportingPeriodID
							Inner Join 
								tblInstrument iar ON ar.InstrumentID = iar.InstrumentID
							LEFT OUTER JOIN tblInstrumentAccountableParty IAP
								ON IAP.AccountablePartyID = (Select MIN(IAP1.AccountablePartyID) from tblInstrumentAccountableParty IAP1
													Where IAP1.InstrumentID = rp.InstrumentID)
							--LEFT OUTER JOIN viewInstrumentAccountablePartyAnnualReturn vwAP
							--	ON vwAP.AccountablePartyID = IAP.AccountablePartyID
							left outer join tblAccountableParty vwAP ON vwAP.AccountablePartyID = IAP.AccountablePartyID
							Left Outer Join
								viewInstrumentLocationAnnualReturn vwLoc ON vwLoc.InstrumentID = ar.InstrumentID
							Left Outer Join
								tblClassification c ON c.ClassificationID = iar.InstrumentStatusID
							Left Outer Join 
								tblSystemUser u ON iar.ResponsibleSystemUserID = u.SystemUserID
							Left outer Join
								tblInstrumentAuditLog al ON al.InstrumentAuditLogID = 
								(Select Max(InstrumentAuditLogID) from tblInstrumentAuditLog al1 Where al1.InstrumentID = ar.InstrumentID AND al1.ChangedStatusFlag = 1)					
							Left Outer Join
								tblInstrument i ON i.InstrumentID = rp.InstrumentID
							Left Outer Join 
								tblDECCWSection S On S.DECCWSectionID = iar.DECCWSectionID
						Where iar.InstrumentID = -1	
			End		
				
				
			--Added in 31-02-2012 for returning the number of total rows		
			DECLARE @ActualCount INT
			SELECT @ActualCount = COUNT(ARNo) from #InstrumentResultRows			
			UPDATE #InstrumentResultRows SET RowCountTotal = @ActualCount					
								
			--IF(NOT(Select COUNT(RecordNo) from #InstrumentResultRows) > @NoOfRecordsRequired OR @ToExport = 1)
			IF(@ToExport = 1)
				BEGIN
					Select TOP(@MaxRecordsExport) * from #InstrumentResultRows order by ARNo
				END
			Else
				Begin	
				    IF(@ActualCount <= @NoOfRecordsRequired)		
						SELECT TOP (@pageSize) *  FROM #InstrumentResultRows 
						WHERE ARNo NOT IN  
						( SELECT TOP ((@pageNum - 1) * (@pageSize)) ARNo FROM #InstrumentResultRows order by ARNo )	
						order by ARNo	
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
			
 					
	END TRY

	BEGIN CATCH

		DECLARE @ErrorMessage VARCHAR(2000)
		SET @ErrorMessage = dbo.ufn_GetErrorText()
		RAISERROR (@ErrorMessage , 16, 1)

	END CATCH