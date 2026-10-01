declare @xmlSearchCriteria XML
declare @NoOfRecordsRequired int
declare @MaxRecordsExport int
declare @ToExport BIT
declare @pageSize int
declare @pageNum int
declare @OldLicenceNumber varchar(30)
set @OldLicenceNumber = ''

set @xmlSearchCriteria = 
'
<DataSearch>
  <PrimarySearchCriteria>
    <LicenseType>750</LicenseType> 
	<Section>7</Section>    
  </PrimarySearchCriteria>
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
				@FilterCount as int, @EnvironmentalRiskLevelID as int, @EnvironmentalManagementCategoryID as int,
				@RadiationLicenceTypeID as int, @ExpiryDateFrom as DateTime, @ExpiryDateTo as DateTime, @AccreditationTypeID as int,
				@LicenceDurationID as int, @LicenceConditionID as int, @LicenceActivityID as int, @RRMTypeID as int,
				@RRMID as int
		 
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
			@EnvironmentalManagementCategoryID = xmlVals.rowvals.value('(EnvironmentalManagementCategoryID)[1]','INT'),
			@RadiationLicenceTypeID = xmlVals.rowvals.value('(RadiationLicenceTypeID)[1]','INT'),   ------------ PALMS V5.0
			@ExpiryDateFrom = xmlVals.rowvals.value('(ExpiryDateFrom)[1]','DateTime'),
			@ExpiryDateTo = xmlVals.rowvals.value('(ExpiryDateTo)[1]','DateTime'),
			@AccreditationTypeID = xmlVals.rowvals.value('(AccreditationTypeID)[1]','INT'),
			@LicenceDurationID = xmlVals.rowvals.value('(LicenceDurationID)[1]','INT'),
			@LicenceConditionID = xmlVals.rowvals.value('(LicenceConditionID)[1]','INT'),
			@LicenceActivityID = xmlVals.rowvals.value('(LicenceActivityID)[1]','INT'),
			@RRMTypeID = xmlVals.rowvals.value('(RRMTypeID)[1]','INT'),
			@RRMID = xmlVals.rowvals.value('(RRMID)[1]','INT')
		From @xmlSearchCriteria.nodes('//DataSearch/PrimarySearchCriteria') as xmlVals(rowvals)		
				
		Select @ResponsibleOfficerID =dbo.ufn_GetSystemUserIDByLoginName(@ResponsibleOfficer)
		SET @ResponsibleOfficerID = ISNULL(@ResponsibleOfficerID, 0);
		
		print '@ResponsibleOfficerID=' + cast(@ResponsibleOfficerID as varchar)

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
		
		IF (@RadiationLicenceTypeID IS NOT NULL AND @RadiationLicenceTypeID !=0 )
			SELECT @HasFirstSearchCriteria = 1 

		IF (@LicenseStatus IS NOT NULL AND @LicenseStatus != 0)
			SELECT @HasFirstSearchCriteria = 1
 
		IF (@ResponsibleOfficerID IS NOT NULL AND @ResponsibleOfficerID != 0)
			SELECT @HasFirstSearchCriteria = 1

		IF (@SectionId IS NOT NULL AND @SectionId !=0 )
			SELECT @HasFirstSearchCriteria = 1 

		IF (@LicenceDurationID IS NOT NULL AND @LicenceDurationID !=0 )
			SELECT @HasFirstSearchCriteria = 1 

		IF (@LicenceConditionID IS NOT NULL AND @LicenceConditionID !=0 )
			SELECT @HasFirstSearchCriteria = 1 

		IF (@LicenceActivityID IS NOT NULL AND @LicenceActivityID !=0 )
			SELECT @HasFirstSearchCriteria = 1

		IF (@RRMTypeID IS NOT NULL AND @RRMTypeID !=0 )
			SELECT @HasFirstSearchCriteria = 1 

		IF (@RRMID IS NOT NULL AND @RRMID !=0 )
			SELECT @HasFirstSearchCriteria = 1

		IF (@ExpiryDateFrom IS NOT NULL)
			SELECT @HasFirstSearchCriteria = 1

		IF (@ExpiryDateTo IS NOT NULL)
			SELECT @HasFirstSearchCriteria = 1


 
		SET @Location = '%' + rtrim(ltrim(@Location)) + '%'; 
		SET @Suburb = '%' + rtrim(ltrim(@Suburb)) + '%'; 
		SET @StreetName = '%' + rtrim(ltrim(@StreetName)) + '%';
	
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
		IF (@HasFirstSearchCriteria	= 1 AND LEN(@OldLicenceNumber) = 0) AND (@LicenseNo IS NULL OR @LicenseNo = 0)
		BEGIN
		    
		    --Search Accountableparty name
		    IF @APName IS NOT NULL AND @APName != '' 
			begin
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
						LEFT OUTER JOIN tblSystemUser U
							ON U.SystemUserID = I.ResponsibleSystemUserID
						LEFT OUTER JOIN tblInstrumentAccountableParty IAP
							ON IAP.InstrumentID = I.InstrumentID
						LEFT OUTER JOIN viewInstrumentAccountableParty AP
							ON IAP.AccountablePartyID = AP.AccountablePartyID
						LEFT OUTER JOIN tblDECCWSection DS
							ON DS.DECCWSectionID = I.DECCWSectionID						
						LEFT OUTER JOIN tblRadiationLicence RL              ------------------PALMS V5.0
							ON I.InstrumentID = RL.InstrumentID					 
					WHERE 		
						(
							C.ClassificationDomainID = 35
						)
						AND 
						(
							I.InstrumentID = RL.InstrumentID 
						)
						AND
						(
							I.InstrumentTypeID = @LicenseType
						)					 					 
						AND
						(						  
							AP.APName like '%' + (case isnull(@APName, '') when '' then AP.APName else  @APName end) + '%'
						)					 			 				 					
			end	 

		    IF  (@TradingName IS NOT NULL AND @TradingName != '')
			begin
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
						LEFT OUTER JOIN tblSystemUser U
							ON U.SystemUserID = I.ResponsibleSystemUserID
						LEFT OUTER JOIN tblInstrumentAccountableParty IAP
							ON IAP.InstrumentID = I.InstrumentID
						LEFT OUTER JOIN viewInstrumentAccountableParty AP
							ON IAP.AccountablePartyID = AP.AccountablePartyID
						LEFT OUTER JOIN tblDECCWSection DS
							ON DS.DECCWSectionID = I.DECCWSectionID						
						LEFT OUTER JOIN tblRadiationLicence RL              ------------------PALMS V5.0
							ON I.InstrumentID = RL.InstrumentID					 
					WHERE 		
						(
							C.ClassificationDomainID = 35
						)
						AND 
						(
							I.InstrumentID = RL.InstrumentID 
						)
						AND
						(
							I.InstrumentTypeID = @LicenseType
						)					 					 						 
						AND
						(
						    AP.TradingName like '%' + (case isnull(@TradingName, '') when '' then AP.TradingName else  @TradingName end) + '%'							 
						)					 				 					
			end	 

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
					LEFT OUTER JOIN tblSystemUser U
						ON U.SystemUserID = I.ResponsibleSystemUserID					 
					LEFT OUTER JOIN tblDECCWSection DS
						ON DS.DECCWSectionID = I.DECCWSectionID						
					LEFT OUTER JOIN tblRadiationLicence RL              ------------------PALMS V5.0
						ON I.InstrumentID = RL.InstrumentID
					LEFT OUTER JOIN tblRadiationLicenceCondition RLC
						ON RL.InstrumentID = RLC.InstrumentID
					LEFT OUTER JOIN tblRadiationCondition RC
						ON RLC.RadiationConditionID = RC.RadiationConditionID
					LEFT OUTER JOIN tblInstrumentRadiationLocation IRLOC
						ON RL.InstrumentID = IRLOC.InstrumentID AND IRLOC.VariationPendingFlag = 0 AND IRLOC.EffectiveDateTo IS NULL
					LEFT OUTER JOIN tblRadiationLocation RLOC 
						ON IRLOC.RadiationLocationID = RLOC.RadiationLocationID
					LEFT OUTER JOIN tblAddress A
						ON 	A.AddressID = RLOC.AddressID
					LEFT OUTER JOIN tblRadiationLocationRRM RLRRM 
						ON RLOC.RadiationLocationID = RLRRM.RadiationLocationID
					LEFT OUTER JOIN tblRadiationLicenceRRM RLIRRM 
						ON RLRRM.RadiationLicenceRRMID = RLIRRM.RadiationLicenceRRMID
					LEFT OUTER JOIN tblRadiationLicenceAccreditationType RLAT
						ON RL.InstrumentID = RLAT.InstrumentID
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
					  RL.InstrumentID = (case isnull(@APName, '') when '' then RL.InstrumentID else (select top 1 TPX.InstrumentID from #InstrumentAllRows TPX where RL.InstrumentID = TPX.InstrumentID) end)					
					)
					AND 
					(
					  RL.InstrumentID = (case isnull(@TradingName, '') when '' then RL.InstrumentID else (select top 1 TPX.InstrumentID from #InstrumentAllRows TPX where RL.InstrumentID = TPX.InstrumentID) end)					
					)															
					AND
					(
						@Suburb IS NULL OR @Suburb = ''
						OR (PATINDEX(@Suburb, isnull(A.Suburb, '')) > 0)
					)
					AND
					(
						@LicenseStatus IS NULL OR @LicenseStatus = 0
						OR (I.InstrumentStatusID = @LicenseStatus)
					)				 
					AND
					(
						@Location IS NULL OR @Location = ''
						OR patindex(@Location, isnull(RLOC.LocationName, '')) > 0
					)
					AND
					(
						@Postcode IS NULL OR @Postcode = ''
						OR (A.Postcode = @Postcode)
					) 
					AND
					(
						@StreetName IS NULL OR @StreetName = ''
						OR patindex(@StreetName, isnull(A.[Address], '')) > 0
					)
					AND				-----------------   PALMS V5.0
					(
						@RadiationLicenceTypeID IS NULL OR @RadiationLicenceTypeID = 0
						OR (RL.RadiationLicenceTypeID = @RadiationLicenceTypeID)
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
						@ExpiryDateFrom IS NULL Or
						DATEDIFF(day, @ExpiryDateFrom, RL.ExpiryDate) >= 0
					)
					AND
					(
						@ExpiryDateTo IS NULL OR
						DATEDIFF(day, @ExpiryDateTo, RL.ExpiryDate) <= 0
					)
					AND
					(
						@AccreditationTypeID IS NULL OR @AccreditationTypeID = 0
						OR (RLAT.AccreditationTypeID = @AccreditationTypeID)
					)
					AND
					(
						@LicenceDurationID IS NULL OR @LicenceDurationID = 0
						OR (RL.LicencetoUseDurationID = @LicenceDurationID)
					)
					AND
					(
						@LicenceConditionID IS NULL OR @LicenceConditionID = 0
						OR (RLC.RadiationConditionID = @LicenceConditionID)
					)
					AND
					(
						@LicenceActivityID IS NULL OR @LicenceActivityID = 0
						OR (RL.ManagementLicenceActivityandDurationID = @LicenceActivityID)
					)
					AND
					(
						@RRMTypeID IS NULL OR @RRMTypeID = 0
						OR (RLIRRM.RRMTypeID = @RRMTypeID)
					)
					AND
					(
						@RRMID IS NULL OR @RRMID = 0
						OR (RLIRRM.RRMID = @RRMID)
					)								
		END	
					
        SELECT @FirstSearchRows = COUNT(InstrumentID) FROM #InstrumentAllRows

 select * from #InstrumentAllRows
 

		--Check if at least 1 criteria is selected in second search criteria
		DECLARE @HasSecondSearchCriteria BIT
		SELECT @HasSecondSearchCriteria = 0
		
		IF (@LicenseNo IS NOT NULL AND @LicenseNo != 0)
			SELECT @HasSecondSearchCriteria = 1 

		IF (@Suburb IS NOT NULL AND @Suburb != '') --here @Suburb is holding the OldLicenceNumber search value
			SELECT @HasSecondSearchCriteria = 1

		IF (@LicenseStatus IS NOT NULL AND @LicenseStatus != 0)
			SELECT @HasSecondSearchCriteria = 1

		IF (@ResponsibleOfficerID IS NOT NULL AND @ResponsibleOfficerID != 0)
			SELECT @HasSecondSearchCriteria = 1

		IF (@SectionId IS NOT NULL AND @SectionId != 0)
			SELECT @HasSecondSearchCriteria = 1
	
		IF (@FirstSearchRows > 0 OR @FilterCount > 0 )
			SELECT @HasSecondSearchCriteria = 1
		
 
 

		DECLARE @JoinFirstSearch BIT
		SELECT @JoinFirstSearch = 0
		if (@LicenseType IS NOT NULL AND @LicenseType != 0) OR
		   (@APName IS NOT NULL AND @APName != '') OR
		   (@RadiationLicenceTypeID IS NOT NULL AND @RadiationLicenceTypeID != 0) OR 
		   (@ExpiryDateFrom IS NOT NULL OR @ExpiryDateTo IS NOT NULL)
		    set @JoinFirstSearch = 1

 

		Create Table #InstrumentResultRows
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
			RadiationLicenceExpiryDate DateTime null,
		)


 



		--here we handle the old licence number search we directly get this single row and return
		IF LEN(@OldLicenceNumber) > 0 OR (@LicenseNo IS NOT NULL AND @LicenseNo != 0)
		BEGIN
	 
		    declare @CurrentInstrumentID int
			if LEN(@OldLicenceNumber) > 0
			   select @CurrentInstrumentID = isnull(InstrumentID, 0) from tblRadiationLicence where OldLicenceNumber = @OldLicenceNumber
			else
			   set @CurrentInstrumentID = cast(@LicenseNo as varchar)

			Insert Into #InstrumentResultRows
			(
				InstrumentTypeID, 
				InstrumentType,
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
				EnvironmentalManagementCategory,
				RadiationLicenceType,
				RadiationLicenceExpiryDate
			)
			SELECT DISTINCT	
				I.InstrumentTypeID, 
				C.[Name] InstrumentType,
				I.InstrumentID, 
				I.InstrumentStatusID, 						
				C2.Name,
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
				I.DECCWSectionID,
				DS.Name Section,
				AP.TradingName,
				RLOC.LocationName AS LocationName,
				A.Address,
				A.Suburb,
				A.Postcode,
				RLOC.RadiationLocationID LocationID,
				al.DateCreated [StatusChangedDate],
				'',
				isnull(RL.OldLicenceNumber, '') as Catchment,
				'',
				NULL,				
				NULL,
				RadiationLicType.[Name],
				RL.ExpiryDate
		 FROM tblClassification C 
				INNER JOIN tblInstrument I 
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
				LEFT OUTER JOIN tblDECCWSection DS
					ON DS.DECCWSectionID = I.DECCWSectionID
				Left outer Join	tblInstrumentAuditLog al 
					ON al.InstrumentAuditLogID = (Select Max(InstrumentAuditLogID) from tblInstrumentAuditLog al1 
						Where al1.InstrumentID = I.InstrumentID AND al1.ChangedStatusFlag = 1)
                LEFT OUTER JOIN tblRadiationLicence RL              ------------------PALMS V5.0
					ON I.InstrumentID = RL.InstrumentID
				LEFT OUTER JOIN tblRadiationLicenceCondition RLC
					ON RL.InstrumentID = RLC.InstrumentID
				LEFT OUTER JOIN tblRadiationCondition RC
					ON RLC.RadiationConditionID = RC.RadiationConditionID
				LEFT OUTER JOIN tblInstrumentRadiationLocation IRLOC
					ON RL.InstrumentID = IRLOC.InstrumentID AND IRLOC.VariationPendingFlag = 0 AND IRLOC.EffectiveDateTo IS NULL
					AND IRLOC.InstrumentRadiationLocationID = (Select MIN(IRLOC1.InstrumentRadiationLocationID) from tblInstrumentRadiationLocation IRLOC1
										Where IRLOC1.InstrumentID = I.InstrumentID)
				LEFT OUTER JOIN tblRadiationLocation RLOC 
					ON IRLOC.RadiationLocationID = RLOC.RadiationLocationID
				LEFT OUTER JOIN tblAddress A
					ON 	A.AddressID = RLOC.AddressID	
				LEFT OUTER JOIN tblRadiationLocationRRM RLRRM 
					ON RLOC.RadiationLocationID = RLRRM.RadiationLocationID
				LEFT OUTER JOIN tblRadiationLicenceRRM RLIRRM 
					ON RLRRM.RadiationLicenceRRMID = RLIRRM.RadiationLicenceRRMID
				LEFT OUTER JOIN tblRadiationLicenceAccreditationType RLAT
					ON RL.InstrumentID = RLAT.InstrumentID
				LEFT OUTER JOIN tblClassification RadiationLicType
					ON RL.RadiationLicenceTypeID = RadiationLicType.ClassificationID
				LEFT OUTER JOIN tblAddress ARLOC
				ON 	ARLOC.AddressID = RLOC.AddressID
			WHERE 		
				(
					C.ClassificationDomainID = 35
				)					
				AND
				(
				  I.InstrumentID = @CurrentInstrumentID
				)					 
		END


		DECLARE @ActualCount INT

		IF @FirstSearchRows <= @NoOfRecordsRequired 
		BEGIN
			IF (@HasSecondSearchCriteria = 1 AND LEN(@OldLicenceNumber) = 0 AND (@LicenseNo IS NULL OR @LicenseNo = 0)) 
			BEGIN			
				Insert Into #InstrumentResultRows
				(
					InstrumentTypeID, 
					InstrumentType,
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
					EnvironmentalManagementCategory,
					RadiationLicenceType,
					RadiationLicenceExpiryDate
				)
				SELECT DISTINCT	
					I.InstrumentTypeID, 
					C.[Name] InstrumentType,
					I.InstrumentID, 
					I.InstrumentStatusID, 						
					C2.Name,
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
					I.DECCWSectionID,
					DS.Name Section,
					AP.TradingName,
					RLOC.LocationName AS LocationName,
					A.Address,
					A.Suburb,
					A.Postcode,
					RLOC.RadiationLocationID LocationID,
					al.DateCreated [StatusChangedDate],
					'',
					isnull(RL.OldLicenceNumber, '') as Catchment,
					'',
					NULL,				
					NULL,
					RadiationLicType.[Name],
					RL.ExpiryDate
			 FROM tblClassification C 
					INNER JOIN tblInstrument I 
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
					LEFT OUTER JOIN tblDECCWSection DS
						ON DS.DECCWSectionID = I.DECCWSectionID
					Left outer Join	tblInstrumentAuditLog al 
						ON al.InstrumentAuditLogID = (Select Max(InstrumentAuditLogID) from tblInstrumentAuditLog al1 
							Where al1.InstrumentID = I.InstrumentID AND al1.ChangedStatusFlag = 1)
					LEFT OUTER JOIN tblRadiationLicence RL              ------------------PALMS V5.0
							ON I.InstrumentID = RL.InstrumentID
						LEFT OUTER JOIN tblRadiationLicenceCondition RLC
							ON RL.InstrumentID = RLC.InstrumentID
						LEFT OUTER JOIN tblRadiationCondition RC
							ON RLC.RadiationConditionID = RC.RadiationConditionID
						LEFT OUTER JOIN tblInstrumentRadiationLocation IRLOC
							ON RL.InstrumentID = IRLOC.InstrumentID AND IRLOC.VariationPendingFlag = 0 AND IRLOC.EffectiveDateTo IS NULL
							AND IRLOC.InstrumentRadiationLocationID = (Select MIN(IRLOC1.InstrumentRadiationLocationID) from tblInstrumentRadiationLocation IRLOC1
												Where IRLOC1.InstrumentID = I.InstrumentID)
						LEFT OUTER JOIN tblRadiationLocation RLOC 
							ON IRLOC.RadiationLocationID = RLOC.RadiationLocationID
						LEFT OUTER JOIN tblAddress A
							ON 	A.AddressID = RLOC.AddressID	
						LEFT OUTER JOIN tblRadiationLocationRRM RLRRM 
							ON RLOC.RadiationLocationID = RLRRM.RadiationLocationID
						LEFT OUTER JOIN tblRadiationLicenceRRM RLIRRM 
							ON RLRRM.RadiationLicenceRRMID = RLIRRM.RadiationLicenceRRMID
						LEFT OUTER JOIN tblRadiationLicenceAccreditationType RLAT
							ON RL.InstrumentID = RLAT.InstrumentID
						LEFT OUTER JOIN tblClassification RadiationLicType
							ON RL.RadiationLicenceTypeID = RadiationLicType.ClassificationID
						LEFT OUTER JOIN tblAddress ARLOC
						ON 	ARLOC.AddressID = RLOC.AddressID
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
						@Suburb IS NULL OR @Suburb = ''
						OR (PATINDEX(@Suburb, isnull(A.Suburb, '')) > 0)
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
							I.InstrumentID IN (Select InstrumentID from @StatusTable)
						)	
					)
					AND
					(						 
						I.InstrumentID = case @JoinFirstSearch when 0 then RL.InstrumentID else (Select distinct TOP 1 isnull(InstrumentID, 0) from #InstrumentAllRows T where T.InstrumentID = I.InstrumentID ) end 
					)
					AND				-----------------   PALMS V5.0
					(
						@RadiationLicenceTypeID IS NULL OR @RadiationLicenceTypeID = 0
						OR (RL.RadiationLicenceTypeID = @RadiationLicenceTypeID)
					)
					AND
					(
						@ExpiryDateFrom IS NULL Or
						DATEDIFF(day, @ExpiryDateFrom, RL.ExpiryDate) >= 0
					)
					AND
					(
						@ExpiryDateTo IS NULL OR
						DATEDIFF(day, @ExpiryDateTo, RL.ExpiryDate) <= 0
					)
					AND
					(
						@AccreditationTypeID IS NULL OR @AccreditationTypeID = 0
						OR (RLAT.AccreditationTypeID = @AccreditationTypeID)
					)
					AND
					(
						@LicenceDurationID IS NULL OR @LicenceDurationID = 0
						OR (RL.LicencetoUseDurationID = @LicenceDurationID)
					)
					AND
					(
						@LicenceConditionID IS NULL OR @LicenceConditionID = 0
						OR (RLC.RadiationConditionID = @LicenceConditionID)
					)
					AND
					(
						@LicenceActivityID IS NULL OR @LicenceActivityID = 0
						OR (RL.ManagementLicenceActivityandDurationID = @LicenceActivityID)
					)
					AND
					(
						@RRMTypeID IS NULL OR @RRMTypeID = 0
						OR (RLIRRM.RRMTypeID = @RRMTypeID)
					)
					AND
					(
						@RRMID IS NULL OR @RRMID = 0
						OR (RLIRRM.RRMID = @RRMID)
					)
			END

			SELECT @ActualCount = COUNT(InstrumentID) from #InstrumentResultRows
		END
		ELSE
		BEGIN
	 
		    SELECT @ActualCount = @FirstSearchRows
		END

 

		IF(@ToExport = 1)
			Begin
				Select TOP(CASE WHEN @ToExport = 1 THEN @MaxRecordsExport ELSE @NoOfRecordsRequired END) * from #InstrumentResultRows order by InstrumentID
			End
		Else
			Begin								
				--If the return count is less than the limit such as 500 records in total then
				--we get those records in batch such as every time we get 50 records
				
				UPDATE #InstrumentResultRows SET RowCountTotal = @ActualCount
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

	 