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
declare @pageSize int = 50
declare @pageNum int = 1

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
				@DGRegoNumber as Varchar(100),
				@DGVINNumber Varchar(100)		
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
			@DGRegoNumber = xmlVals.rowvals.value('(DGRegoNumber)[1]','VARCHAR(100)'),
			@DGVINNumber = xmlVals.rowvals.value('(DGVINNumber)[1]','VARCHAR(100)')
		From @xmlSearchCriteria.nodes('//DataPRSearch/PrimarySearchCriteria') as xmlVals(rowvals)		
				
 
		DECLARE @FirstSearchRows INT = 0
		DECLARE @HasDateSearchCriteria BIT  --using this flag to check if the user is using LastUpdated and Licence expiry date from to search
		SET @HasDateSearchCriteria = 0

		DECLARE @HasFirstSearchCriteria BIT
		SELECT @HasFirstSearchCriteria = 0
		
		SET @APName = ISNULL(@APName, '');
		SET @TradingName = ISNULL(@TradingName, '');		 
		SET @Suburb = ISNULL(@Suburb, '');
	  
		IF (@Suburb IS NOT NULL AND @Suburb != '' )
			SELECT @HasFirstSearchCriteria = 1		 
		IF (@Postcode IS NOT NULL AND @Postcode != '' )
			SELECT @HasFirstSearchCriteria = 1
		IF (@TradingName IS NOT NULL AND @TradingName != '' )
			SELECT @HasFirstSearchCriteria = 1
		IF (@APName IS NOT NULL AND @APName != '' )
			SELECT @HasFirstSearchCriteria = 1
			 
		--Added the following line by Eric He 10-01-2014
		--Risk management search criteria two of them have been added into this search so we need set them as well
	 
		IF (@RadiationLicenceTypeID IS NOT NULL AND @RadiationLicenceTypeID !=0 )
			SELECT @HasFirstSearchCriteria = 1 
					 
		IF (@ExpiryDateFrom IS NOT NULL)
			SELECT @HasFirstSearchCriteria = 1

		IF (@ExpiryDateTo IS NOT NULL)
			SELECT @HasFirstSearchCriteria = 1

		IF (@DGLicenceNo IS NOT NULL)
			SELECT @HasFirstSearchCriteria = 1
		IF (@DGVehicleID IS NOT NULL AND @DGVehicleID !=0 )
			SELECT @HasFirstSearchCriteria = 1
		IF (@DGRegoNumber IS NOT NULL)
			SELECT @HasFirstSearchCriteria = 1
		IF (@DGVINNumber IS NOT NULL)
			SELECT @HasFirstSearchCriteria = 1

		SET @APName = '%' + rtrim(ltrim(@APName)) + '%';	
		
		if 	@TradingName is not null and @TradingName <> ''
			SET @TradingName = '%' + rtrim(ltrim(@TradingName)) + '%';
	 
		if @DGRegoNumber is not null and @DGRegoNumber <> ''
		    SET @DGRegoNumber = rtrim(ltrim(@DGRegoNumber));
 
		DECLARE @StatusTable Table(InstrumentID int)
				
		DECLARE @StatusTableA Table(InstrumentID int)
		DECLARE @StatusTableB Table(InstrumentID int)
		
		IF @StatusFromDate IS NOT NULL OR @StatusToDate IS NOT NULL
		Begin
			Set @HasDateSearchCriteria = 1
				
			Insert into @StatusTableA
			(
				InstrumentID
			)
			Select aul.InstrumentID
				From 
					tblDGLicence aul
				Where
					(
						@StatusFromDate IS NULL Or
						DATEDIFF(day, @StatusFromDate, aul.ExpiryDate) >= 0
					)
					AND
					(
						@StatusToDate IS NULL OR
						DATEDIFF(day, @StatusToDate, aul.ExpiryDate) <= 0
					)
					AND
					(
						@LicenseNo IS NULL OR @LicenseNo = 0 
						OR
						aul.InstrumentID = @LicenseNo
					)						 
		End
		
		 
		IF @LicenseReviewFrom IS NOT NULL OR @LicenseReviewTo IS NOT NULL
		Begin
			    Set @HasDateSearchCriteria = 1
			 
				Insert into @StatusTableB
				(
					InstrumentID
				)
				Select pl.InstrumentID
				From 
					tblDGLicence pl
				Where
				(
					@LicenseReviewFrom IS NULL Or
					Convert(varchar(10), CONVERT(date, @LicenseReviewFrom, 103), 103) = dbo.ufn_PRGetDGLIssuedDate(pl.InstrumentID)
				)
				AND
				(
					@LicenseReviewTo IS NULL OR						 
					Convert(varchar(10), CONVERT(date, @LicenseReviewTo, 103), 103) = dbo.ufn_PRGetDGLIssuedDate(pl.InstrumentID)
				) 				 
		End
			
		if (select count(*) from @StatusTableA) > 0 and (select count(*) from @StatusTableB) > 0
		begin
        insert into @StatusTable
		select A.InstrumentID from @StatusTableA A inner join @StatusTableB B on A.InstrumentID = B.InstrumentID
		end
		else
		begin
		   insert into @StatusTable
		   select InstrumentID from @StatusTableA
		   insert into @StatusTable
		   select InstrumentID from @StatusTableB
		end
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
		        FROM tblTransporterLicence RL 
		        INNER JOIN tblInstrument I ON RL.InstrumentID = I.InstrumentID		 		 
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
				WHERE 		
					(
						I.InstrumentTypeID = 1417
					)
					AND
					(
						I.InstrumentStatusID in (755, 757, 758, 797, 816)
					) 	
					AND
					(
						@LicenseStatus IS NULL OR @LicenseStatus = 0
						OR (I.InstrumentStatusID = @LicenseStatus)
					)								
					AND
					(
						@TradingName IS NULL OR @TradingName = ''
						OR patindex(@TradingName, isnull(AP.TradingName, '')) > 0
					)
					AND
					(
						@APName IS NULL OR @APName = ''
						OR patindex(@APName, ISNULL(AP.OrganisationName, '')) > 0
					)					
					AND				-----------------   PALMS V5.0
					(
						@RadiationLicenceTypeID IS NULL OR @RadiationLicenceTypeID = 0
						OR (RL.LicenceTypeID = @RadiationLicenceTypeID)
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
						@DGRegoNumber IS NULL OR @DGRegoNumber = ''
						OR @DGRegoNumber = ISNULL(b.RegistrationNumber, '')					 
					)						
		END	
					
		SELECT @FirstSearchRows = COUNT(InstrumentID) FROM #InstrumentAllRows
		
		--Check if at least 1 criteria is selected in second search criteria
		DECLARE @HasSecondSearchCriteria BIT
		SELECT @HasSecondSearchCriteria = 0
		
		IF (@LicenseNo IS NOT NULL AND @LicenseNo != 0)
			SELECT @HasSecondSearchCriteria = 1
		IF (@LicenseStatus IS NOT NULL AND @LicenseStatus != 0)
			SELECT @HasSecondSearchCriteria = 1
		IF (@ResponsibleOfficerID IS NOT NULL AND @ResponsibleOfficerID != 0)
			SELECT @HasSecondSearchCriteria = 1
	 
		IF (@FirstSearchRows > 0 OR @FilterCount > 0 )
			SELECT @HasSecondSearchCriteria = 1
		
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
			RadiationLicenceExpiryDate Date null,
			LastUpdated varchar(50) null,
			DGLicenceTypeID int null 
		)
		IF @HasSecondSearchCriteria = 1  -- if there is Last Updated and Licence Expiry date search then this flag will be set as 1
		BEGIN			
			IF @HasDateSearchCriteria = 0 
			begin
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
				RadiationLicenceExpiryDate,
				LastUpdated,
				DGLicenceTypeID
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
				RadiationLicType.[Name],
				RL.ExpiryDate,
				[dbo].[ufn_PRGetDGLIssuedDate](I.InstrumentID) as LastUpdated,
				RL.LicenceTypeID as DGLicenceTypeID
		 FROM tblTransporterLicence RL 
		        INNER JOIN tblInstrument I ON RL.InstrumentID = I.InstrumentID		 		 
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
			WHERE 		
				(
					I.InstrumentTypeID = 1417
				)	
				AND
				(
					I.InstrumentStatusID in (755,757,758,797,816)
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
					@FilterCount = 0
					OR
					(
						I.InstrumentID IN (Select InstrumentID from @StatusTable)
					)	 
				)
			    AND
				(	
					@FirstSearchRows = 0 OR
						I.InstrumentID IN (Select isnull(InstrumentID, 0) from #InstrumentAllRows)
				)
				AND				-----------------   PALMS V5.0
				(
					@RadiationLicenceTypeID IS NULL OR @RadiationLicenceTypeID = 0
					OR (RL.LicenceTypeID = @RadiationLicenceTypeID)
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
					@DGRegoNumber IS NULL OR @DGRegoNumber = ''
						OR @DGRegoNumber = ISNULL(b.RegistrationNumber, '') 
				)				 
			end
			else
			begin
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
				RadiationLicenceExpiryDate,
				LastUpdated,
				DGLicenceTypeID
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
				RadiationLicType.[Name],
				RL.ExpiryDate,
				[dbo].[ufn_PRGetDGLIssuedDate](I.InstrumentID) as LastUpdated,
				RL.LicenceTypeID as DGLicenceTypeID
		 FROM tblTransporterLicence RL 
		        INNER JOIN tblInstrument I ON RL.InstrumentID = I.InstrumentID		 		 
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
			WHERE 		
				(
					I.InstrumentTypeID = 1417
				)	
				AND
				(
					I.InstrumentStatusID in (755,757,758,797,816)
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
						I.InstrumentID IN (Select InstrumentID from @StatusTable)					  
				)
			    AND
				(	
					@FirstSearchRows = 0 OR
						I.InstrumentID IN (Select isnull(InstrumentID, 0) from #InstrumentAllRows)
				)
				AND				-----------------   PALMS V5.0
				(
					@RadiationLicenceTypeID IS NULL OR @RadiationLicenceTypeID = 0
					OR (RL.LicenceTypeID = @RadiationLicenceTypeID)
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
					@DGRegoNumber IS NULL OR @DGRegoNumber = ''
						OR @DGRegoNumber = ISNULL(b.RegistrationNumber, '')
						--OR patindex(@DGRegoNumber, ISNULL(b.RegistrationNumber, '')) > 0
				)					 
			end				
		END
		DECLARE @ActualCount INT
	    SELECT @ActualCount = COUNT(InstrumentID) from #InstrumentResultRows
		
		UPDATE #InstrumentResultRows SET RowCountTotal = @ActualCount
		
		 
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