	declare @xmlSearchCriteria XML
	declare @NoOfRecordsRequired int
	declare @MaxRecordsExport int
	declare @ToExport BIT
	declare @pageSize int
	declare @pageNum int
	
    --<LGAID>156</LGAID>
	--<LowRisk>false</LowRisk>
	--<EnvironmentalRiskLevelID>714</EnvironmentalRiskLevelID>
    --<EnvironmentalManagementCategoryID>709</EnvironmentalManagementCategoryID>
    --<EnvironmentalRiskLevelID>715</EnvironmentalRiskLevelID>  --Level 3
    
	set @xmlSearchCriteria = 
	'
	<DataSearch>\r\n  
	<PrimarySearchCriteria>\r\n    
	<LBL>true</LBL>
	</PrimarySearchCriteria>\r\n
	</DataSearch>
	'

	set @NoOfRecordsRequired = 500
	set @MaxRecordsExport = 5000
	set @ToExport = 0
	set @pageSize = 50
	set @pageNum = 1

		DECLARE @LicenseNo as int, @LicenseType as int, @LicenseStatus as int, @ResponsibleOfficer as Varchar(120),
				@APName as Varchar(100), @SectionId as int,@LicenseReviewFrom as DateTime, @LicenseReviewTo as DateTime,
				@StatusFromDate as DateTime, @StatusToDate as DateTime, @LBL as bit, @LowRisk as bit, @FeeBasedActID as int,
				@ScheduleActivityId as int,@LGAID as int, @CatchmentID as int, @ElectorateID as int,@ResponsibleOfficerID as int,
				@Suburb as Varchar(100),@Location as Varchar(100),@TradingName as Varchar(100), @Postcode as int,
				@AnniversaryFrom as DateTime, @AnniversaryTo as DateTime, @StreetName as Varchar(100),@FirstSearchRows as int,
				@FilterCount as int, @EnvironmentalRiskLevelID as int, @EnvironmentalManagementCategoryID as int
		
		SELECT 
			@LicenseNo = xmlVals.rowvals.value('(LicenseNo)[1]','INT'),
			@LicenseType = xmlVals.rowvals.value('(LicenseType)[1]','INT'),
			@LicenseStatus = xmlVals.rowvals.value('(LicenseStatus)[1]','INT'),
			@LicenseReviewFrom = xmlVals.rowvals.value('(LicenseReviewFrom)[1]','DateTime'),
			@LicenseReviewTo = xmlVals.rowvals.value('(LicenseReviewTo)[1]','DateTime'),
			@LBL = xmlVals.rowvals.value('(LBL)[1]','BIT'),
			@LowRisk = xmlVals.rowvals.value('(LowRisk)[1]','Bit'),
			@FeeBasedActID = xmlVals.rowvals.value('(FeeBasedActID)[1]','INT'),
			@ScheduleActivityId = xmlVals.rowvals.value('(ScheduleActivityId)[1]','INT'),
			@LGAID = xmlVals.rowvals.value('(LGAID)[1]','INT'),
			@CatchmentID = xmlVals.rowvals.value('(CatchmentID)[1]','INT'),
			@ElectorateID = xmlVals.rowvals.value('(ElectorateID)[1]','INT'),
			@Suburb = xmlVals.rowvals.value('(Suburb)[1]','VARCHAR(100)'),
			@StreetName = xmlVals.rowvals.value('(StreetName)[1]','VARCHAR(100)'),
			@Location = xmlVals.rowvals.value('(Location)[1]','VARCHAR(100)'),
			@TradingName = xmlVals.rowvals.value('(TradingName)[1]','VARCHAR(100)'),
			@Postcode = xmlVals.rowvals.value('(Postcode)[1]','INT'),
			@ResponsibleOfficer = xmlVals.rowvals.value('(ResponsibleOfficer)[1]','VARCHAR(120)'),
			@APName = xmlVals.rowvals.value('(APName)[1]','VARCHAR(100)'),
			@SectionId = xmlVals.rowvals.value('(Section)[1]','VARCHAR(100)'),
			@StatusFromDate = xmlVals.rowvals.value('(StatusFromDate)[1]','DateTime'),
			@StatusToDate = xmlVals.rowvals.value('(StatusToDate)[1]','DateTime'),
			@AnniversaryFrom = xmlVals.rowvals.value('(AnniversaryFrom)[1]','DateTime'),
			@AnniversaryTo = xmlVals.rowvals.value('(AnniversaryTo)[1]','DateTime'),
			@EnvironmentalRiskLevelID = xmlVals.rowvals.value('(EnvironmentalRiskLevelID)[1]','INT'),   ------------ PALMS V4.0
			@EnvironmentalManagementCategoryID = xmlVals.rowvals.value('(EnvironmentalManagementCategoryID)[1]','INT')
		From @xmlSearchCriteria.nodes('//DataSearch/PrimarySearchCriteria') as xmlVals(rowvals)		
				
		Select @ResponsibleOfficerID =dbo.ufn_GetSystemUserIDByLoginName(@ResponsibleOfficer)
		SET @ResponsibleOfficerID = ISNULL(@ResponsibleOfficerID, 0);
		
		DECLARE @HasFirstSearchCriteria BIT
		SELECT @HasFirstSearchCriteria = 0
		
		SET @APName = ISNULL(@APName, '');
		SET @TradingName = ISNULL(@TradingName, '');
		SET @Location = ISNULL(@Location, '');
		SET @Suburb = ISNULL(@Suburb, '');
		SET @StreetName = ISNULL(@StreetName, '');
		

		IF (@FeeBasedActID IS NOT NULL AND @FeeBasedActID != 0 )
		    SELECT @HasFirstSearchCriteria = 1
		IF (@ScheduleActivityId IS NOT NULL AND @ScheduleActivityId != 0 )
			SELECT @HasFirstSearchCriteria = 1
			
		IF (@LGAID IS NOT NULL AND @LGAID != 0 )
			SELECT @HasFirstSearchCriteria = 1
		IF (@CatchmentID IS NOT NULL AND @CatchmentID !=0 )
			SELECT @HasFirstSearchCriteria = 1
			
		IF (@ElectorateID IS NOT NULL AND @ElectorateID !=0 )
			SELECT @HasFirstSearchCriteria = 1
		IF (@Suburb IS NOT NULL AND @Suburb != '' )
			SELECT @HasFirstSearchCriteria = 1
		IF (@Location IS NOT NULL AND @Location != '' )
			SELECT @HasFirstSearchCriteria = 1
		IF (@Postcode IS NOT NULL AND @Postcode != '' )
			SELECT @HasFirstSearchCriteria = 1
		IF (@TradingName IS NOT NULL AND @TradingName != '' )
			SELECT @HasFirstSearchCriteria = 1
		IF (@APName IS NOT NULL AND @APName != '' )
			SELECT @HasFirstSearchCriteria = 1
		IF (@StreetName IS NOT NULL AND @StreetName != '' )
			SELECT @HasFirstSearchCriteria = 1
		
		--Added the following line by Eric He 10-01-2014
		--Risk management search criteria two of them have been added into this search so we need set them as well
		IF (@LBL IS NOT NULL)
		    SELECT @HasFirstSearchCriteria = 1
		IF (@LowRisk IS NOT NULL)
		    SELECT @HasFirstSearchCriteria = 1
		    		
		IF (@EnvironmentalRiskLevelID IS NOT NULL AND @EnvironmentalRiskLevelID !=0 )
			SELECT @HasFirstSearchCriteria = 1 
		IF (@EnvironmentalManagementCategoryID IS NOT NULL AND @EnvironmentalManagementCategoryID !=0 )
			SELECT @HasFirstSearchCriteria = 1	
	    --End added line 10-01-2014	
		
		SET @APName = '%' + rtrim(ltrim(@APName)) + '%';		
		SET @TradingName = '%' + rtrim(ltrim(@TradingName)) + '%';
		SET @Location = '%' + rtrim(ltrim(@Location)) + '%';
		SET @Suburb = '%' + rtrim(ltrim(@Suburb)) + '%';
		SET @StreetName = '%' + rtrim(ltrim(@StreetName)) + '%';
		
		SET @LicenseType = 493 --SB: Hardcoded to POEO Licence bcoz of performance problem as PALMS only supports POEO no point to include all types
		
		DECLARE @StatusTable Table(InstrumentID int)
				
		--SB: Had a performance problem when including dates in select statements, so separated date searches and included in table @StatusTable
		
		IF @StatusFromDate IS NOT NULL OR @StatusToDate IS NOT NULL
			Begin
				--Set @StatusFilterCount = 1
				
				Insert into @StatusTable
				(
					InstrumentID
				)
				Select aul.InstrumentID
					From 
						tblInstrumentAuditLog aul
					Where
						(
							@StatusFromDate IS NULL Or
							DATEDIFF(day, @StatusFromDate, aul.DateCreated) >= 0
						)
						AND
						(
							@StatusToDate IS NULL OR
							DATEDIFF(day, @StatusToDate, aul.DateCreated) <= 0
						)
						AND
						(
							@LicenseNo IS NULL OR @LicenseNo = 0 
							OR
							aul.InstrumentID = @LicenseNo
						)
						AND aul.ChangedStatusFlag = 1
			End
		
		IF @LicenseReviewFrom IS NOT NULL OR @LicenseReviewTo IS NOT NULL
			Begin
			
				Insert into @StatusTable
				(
					InstrumentID
				)
				Select pl.InstrumentID
					From 
						tblPOEOLicence pl
					Where
						(
							@LicenseReviewFrom IS NULL Or
							DATEDIFF(day, @LicenseReviewFrom, pl.ReviewDueDate) >= 0
						)
						AND
						(
							@LicenseReviewTo IS NULL OR
							DATEDIFF(day, @LicenseReviewTo, pl.ReviewDueDate) <= 0
						)
						
			End
			
		IF @AnniversaryFrom IS NOT NULL OR @AnniversaryTo IS NOT NULL
		  Begin			
				Insert into @StatusTable
				(
					InstrumentID
				)
				Select pl.InstrumentID
					From 
						tblPOEOLicence pl
					Where
						(
							@AnniversaryFrom IS NULL Or
							DATEDIFF(day, @AnniversaryFrom, pl.AnniversaryDate) >= 0
						)
						AND
						(
							@AnniversaryTo IS NULL OR
							DATEDIFF(day, @AnniversaryTo, pl.AnniversaryDate) <= 0
						)						
		  End
        
		  --here we check the risk level search situation
		IF @EnvironmentalRiskLevelID IS NOT NULL and @EnvironmentalRiskLevelID > 0
		Begin
			
				Insert into @StatusTable
				(
					InstrumentID
				)
				Select pl.InstrumentID
					From 
						tblPOEOLicence pl inner join viewLatestPOEOLicenceEnvironmentalRiskLevel b
						on pl.InstrumentID = b.InstrumentID 
					Where
						b.EnvironmentalRiskLevelID = @EnvironmentalRiskLevelID
		End	        
        
		SELECT @FilterCount = COUNT(*) FROM @StatusTable
        
		Create Table #InstrumentAllRows 
		(
			InstrumentID int
		)
		--Insert only if at least 1 criteria is selected		
		IF (@HasFirstSearchCriteria	= 1)
		BEGIN
			Insert Into #InstrumentAllRows
			(
				InstrumentID
			)
			SELECT 	DISTINCT
				I.InstrumentID
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
					LEFT OUTER JOIN viewLatestPOEOLicenceEnvironmentalRiskLevel ERL   ------------ PALMS V4.0
						ON ERL.InstrumentID = I.InstrumentID
					LEFT OUTER JOIN viewLatestPOEOLicenceEnvironmentalManagementCategory VPEM ON I.InstrumentID = VPEM.POEOLicenceIntrumentID 	
				WHERE 		
					(
						C.ClassificationDomainID = 35
					)
					AND
					(
						I.InstrumentTypeID = @LicenseType
					)
 			
					AND
					(
						@FeeBasedActID IS NULL OR @FeeBasedActID = 0
						OR (FBA.FeeBasedActivityID = @FeeBasedActID)
					)
					AND
					(
						@ScheduleActivityId IS NULL OR @ScheduleActivityId = 0
						OR (LSA.ActivityGroupID = @ScheduleActivityId)
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
						@ElectorateID IS NULL OR @ElectorateID =0
						OR (LTE.ElectorateID =@ElectorateID)
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
					and
					(
						@TradingName IS NULL OR @TradingName = ''
						OR patindex(@TradingName, isnull(AP.TradingName, '')) > 0
					)
					AND
					(
						@APName IS NULL OR @APName = ''
						OR patindex(@APName, ISNULL(AP.APName, '')) > 0
					)
					AND
					(
						@StreetName IS NULL OR @StreetName = ''
						OR patindex(@StreetName, isnull(A.[Address], '')) > 0
					)
					AND				-----------------  PALMS V4.0
					(
					    isnull(ERL.EnvironmentalRiskLevelID, 0) = (case isnull(@EnvironmentalRiskLevelID, 0) when 0 then isnull(ERL.EnvironmentalRiskLevelID, 0) else @EnvironmentalRiskLevelID end)	 
					)
					AND
					(	
						@LowRisk IS NULL OR
						P.LowRiskFlag = @LowRisk
					)
					AND
					(
						@LBL IS NULL OR
						P.LBLFlag = @LBL
					)	
					AND				-----------------  PALMS V4.0
					(
					    isnull(VPEM.EnvironmentalManagementCategoryID, 0) = (case isnull(@EnvironmentalManagementCategoryID, 0) when 0 then isnull(VPEM.EnvironmentalManagementCategoryID, 0) else @EnvironmentalManagementCategoryID end)	 
					)									
		END	
					
		SELECT @FirstSearchRows = COUNT(InstrumentID) FROM #InstrumentAllRows
		
		--IF((Select COUNT(InstrumentID) from #InstrumentAllRows) = 0)
		--	Begin
		--		Insert #InstrumentAllRows
		--		(InstrumentID)Select 0	
		--	End
		
		-- start test lines ----
		--select A.*, B.*, C.EnvironmentalRiskLevelID, C.EnvironmentalRiskLevel 
		--from #InstrumentAllRows A LEFT OUTER JOIN viewLatestPOEOLicenceEnvironmentalManagementCategory B
		--ON A.InstrumentID = B.POEOLicenceIntrumentID LEFT OUTER JOIN viewLatestPOEOLicenceEnvironmentalRiskLevel C ON A.InstrumentID =C.InstrumentID
		--WHERE B.InstrumentID > 0
		-- end test lines ----
		
		--Check if at least 1 criteria is selected in second search criteria
		DECLARE @HasSecondSearchCriteria BIT
		SELECT @HasSecondSearchCriteria = 0
		
		IF (@LicenseNo IS NOT NULL AND @LicenseNo != 0)
			SELECT @HasSecondSearchCriteria = 1
		IF (@LicenseStatus IS NOT NULL AND @LicenseStatus != 0)
			SELECT @HasSecondSearchCriteria = 1
		IF (@ResponsibleOfficerID IS NOT NULL AND @ResponsibleOfficerID != 0)
			SELECT @HasSecondSearchCriteria = 1
		IF (@SectionId IS NOT NULL AND @SectionId != 0)
			SELECT @HasSecondSearchCriteria = 1
 
		
		IF (@FirstSearchRows > 0 OR @FilterCount > 0 )
			SELECT @HasSecondSearchCriteria = 1
			
		Create Table #InstrumentResultRows
		(
			InstrumentTypeID int null, 
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
			RowCountTotal int null
		)
		IF @HasSecondSearchCriteria = 1
		BEGIN
			Insert Into #InstrumentResultRows
			(
				InstrumentTypeID, 
				InstrumentID, 
				InstrumentStatusID, 
				InstrumentStatus,
				DateIssued,
				ResponsibleSystemUserID,
				ResponsibleOfficer,
				AccountablePartyID,
				AccountableParty,
				FeeBasedActivityID,
				FeeBasedActivity,
				POEOLicenseScheduledActivityID,
				ScheduleActivity,
				LBLFlag,
				LowRiskFlag,
				ReviewDueDate,
				AnniversaryDate,
				DECCWSectionID,
				Section,
				TradingName,
				LocationName,
				[Address],
				Suburb,
				Postcode,
				LocationID,
				StatusChangedDate,
				LGA,
				Catchment,
				Electorate,
				EnvironmentalRiskLevel,
				EnvironmentalManagementCategory
			)
			SELECT DISTINCT	
				I.InstrumentTypeID, 
				I.InstrumentID, 
				I.InstrumentStatusID, 						
				C2.Name,
				I.DateIssued,
				I.ResponsibleSystemUserID,
				U.GivenName + ' ' + U.Surname ResponsibleOfficer,
				IAP.AccountablePartyID,
				(CASE WHEN AP.CompanyFlag = 1 THEN AP.OrganisationName ELSE AP.GivenName + ' ' + AP.Surname END) AccountableParty,
				LFBA.FeeBasedActivityID,
				FBA.Name FeeBasedActivity,
				LSA.POEOLicenceScheduledActivityID,
				AG.Name ScheduleActivity,
				P.LBLFlag,
				(CASE P.LowRiskFlag WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE 'N\A' END) LowRiskFlag,
				P.ReviewDueDate,
				P.AnniversaryDate,
				I.DECCWSectionID,
				DS.Name Section,
				AP.TradingName,
				L.LocationName,
				A.[Address],
				A.Suburb,
				A.Postcode,
				L.LocationID,
				al.DateCreated [StatusChangedDate],
				VL.NAME LGA,
				VC.NAME Catchment,
				VE.ELECTORATE_NAME Electorate,
				F.EnvironmentalRiskLevel as EnvironmentalRiskLevel,				
				B.EnvironmentalManagementCategory as EnvironmentalManagementCategory
			 
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
					ON IAP.InstrumentAccountablePartyID = (Select MIN(IAP1.InstrumentAccountablePartyID) from tblInstrumentAccountableParty IAP1
											Where IAP1.InstrumentID = I.InstrumentID)
				LEFT OUTER JOIN tblAccountableParty AP
					ON IAP.AccountablePartyID = AP.AccountablePartyID
				LEFT OUTER JOIN tblPOEOLicenceFeeBasedActivity LFBA
					ON LFBA.POEOLicenceFeeBasedActivityID = (Select Min(LFBA1.POEOLicenceFeeBasedActivityID)
						from tblPOEOLicenceFeeBasedActivity LFBA1 Where LFBA1.InstrumentID = I.InstrumentID)
				LEFT OUTER JOIN tblFeeBasedActivity FBA
					ON FBA.FeeBasedActivityID = LFBA.FeeBasedActivityID
				LEFT OUTER JOIN tblPOEOLicenceScheduledActivity LSA
					ON LSA.POEOLicenceScheduledActivityID = (Select Min(LSA1.POEOLicenceScheduledActivityID)
						from tblPOEOLicenceScheduledActivity LSA1 Where LSA1.InstrumentID = I.InstrumentID)
				LEFT OUTER JOIN tblActivityGroup AG
					ON LSA.ActivityGroupID = AG.ActivityGroupID
				LEFT OUTER JOIN tblDECCWSection DS
					ON DS.DECCWSectionID = I.DECCWSectionID
				LEFT OUTER JOIN tblInstrumentLocation IL
					ON IL.InstrumentLocationID = (Select MIN(IL1.InstrumentLocationID) from tblInstrumentLocation IL1
										Where IL1.InstrumentID = I.InstrumentID)
				LEFT OUTER JOIN tblLocation L
					ON IL.LocationID = L.LocationID
				LEFT OUTER JOIN tblLandTitle LT
						ON LT.LandTitleID = (Select MIN(LT1.LandTitleID) from tblLandTitle LT1
										Where LT1.LocationID = L.LocationID)
				LEFT OUTER JOIN tblLandTitleElectorate LTE
					ON LTE.LandTitleElectorateID = (Select MIN(LTE1.LandTitleElectorateID) From tblLandTitleElectorate LTE1
													Where LTE1.LandTitleID = LT.LandTitleID)
				LEFT OUTER JOIN viewElectorate VE
					ON LTE.ElectorateID = VE.ELECTORATE_ID	
				LEFT OUTER JOIN	tblLandTitleLGA LTL 
					ON LTL.LandTitleLGAID = (Select MIN(LTL1.LandTitleLGAID) From tblLandTitleLGA LTL1
											Where LTL1.LandTitleID = LT.LandTitleID)
				LEFT OUTER JOIN viewLGA VL
					ON VL.LGAID = LTL.LGAID
				LEFT OUTER JOIN tblLandTitleCatchment LTC
					ON LTC.LandTitleCatchmentID = (Select MIN(LTC1.LandTitleCatchmentID) from tblLandTitleCatchment LTC1
												Where LTC1.LandTitleID = LT.LandTitleID)
				LEFT OUTER JOIN viewCatchment VC
					ON LTC.CatchmentID = VC.CATCHMENT_ID
				LEFT OUTER JOIN tblAddress A
					ON 	A.AddressID = L.AddressID							
				LEFT OUTER JOIN	tblInstrumentAuditLog al 
					ON al.InstrumentAuditLogID = (Select Max(InstrumentAuditLogID) from tblInstrumentAuditLog al1 
						Where al1.InstrumentID = I.InstrumentID AND al1.ChangedStatusFlag = 1)
						
                LEFT OUTER JOIN viewLatestPOEOLicenceEnvironmentalManagementCategory B
						ON I.InstrumentID = B.POEOLicenceIntrumentID 
				LEFT OUTER JOIN viewLatestPOEOLicenceEnvironmentalRiskLevel F ON I.InstrumentID =F.InstrumentID
			 
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
					@ResponsibleOfficerID IS NULL OR @ResponsibleOfficerID = 0
					OR (I.ResponsibleSystemUserID = @ResponsibleOfficerID)
				)			
				AND
				(
					@SectionId IS NULL OR @SectionId = 0
					OR (I.DECCWSectionID = @SectionId)
				)
				
				AND
				(
					@FilterCount = 0
					OR
					(
						I.InstrumentID IN(Select InstrumentID from @StatusTable)
					)	
				)				
				AND
				(	
					@FirstSearchRows = 0 OR
						I.InstrumentID IN (Select isnull(InstrumentID, 0) from #InstrumentAllRows)
				)			 
		END
				
		DECLARE @ActualCount INT
	    SELECT @ActualCount = COUNT(InstrumentID) from #InstrumentResultRows
		
		UPDATE #InstrumentResultRows SET RowCountTotal = @ActualCount
		
		--IF(@ActualCount <= @NoOfRecordsRequired OR @ToExport = 1)
		IF(@ToExport = 1)
			BEGIN
				Select TOP(CASE WHEN @ToExport = 1 THEN @MaxRecordsExport ELSE @NoOfRecordsRequired END) * from #InstrumentResultRows order by InstrumentID
			END
		Else
			Begin
			    --If the return count is less than the limit such as 500 records in total then
			    --we get those records in batch such as every time we get 50 records
			    
                IF(@ActualCount <= @NoOfRecordsRequired)
					SELECT TOP (@pageSize) *  FROM #InstrumentResultRows 
					WHERE InstrumentID NOT IN  
					( SELECT TOP ((@pageNum - 1) * (@pageSize)) InstrumentID FROM #InstrumentResultRows order by InstrumentID )	
					 order by InstrumentID	
                ElSE 
				    Select 
					0 InstrumentTypeID, 
					0 InstrumentID, 
					0 InstrumentStatusID, 
					0 InstrumentStatus,
					0 ResponsibleSystemUserID	                 		                												                
			End
	
		Drop Table #InstrumentResultRows
		Drop Table #InstrumentAllRows