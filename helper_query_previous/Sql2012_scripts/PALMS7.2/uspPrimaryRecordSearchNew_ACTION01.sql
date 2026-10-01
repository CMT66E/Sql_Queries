declare @xmlSearchCriteria XML
set @xmlSearchCriteria = 
'
<DataSearch>
  <PrimarySearchCriteria>
    <LicenseType>493</LicenseType>
    <APName></APName>
    <IsFilterByFee>false</IsFilterByFee>
    <OnlineApplicationNo>POEOA</OnlineApplicationNo>
  </PrimarySearchCriteria>
</DataSearch>
'
declare @NoOfRecordsRequired int = 500
declare @MaxRecordsExport int = 5000
declare @ToExport BIT = 0
declare @pageSize int = 50
declare @pageNum int = 1

DECLARE @LicenseNo as int, @LicenseType as int, @LicenseStatus as int, @ResponsibleOfficer as Varchar(120),
				@APName as Varchar(100), @SectionId as int,@LicenseReviewFrom as DateTime, @LicenseReviewTo as DateTime,
				@StatusFromDate as DateTime, @StatusToDate as DateTime, @LBL as bit, @LowRisk as bit, @FeeBasedActID as int,
				@ScheduleActivityId as int,@LGAID as int, @CatchmentID as int, @ElectorateID as int,@ResponsibleOfficerID as int,
				@Suburb as Varchar(100),@Location as Varchar(100),@TradingName as Varchar(100), @Postcode as int,
				@AnniversaryFrom as DateTime, @AnniversaryTo as DateTime, @StreetName as Varchar(100),@FirstSearchRows as int,
				@FilterCount as int, @EnvironmentalRiskLevelID as int, @EnvironmentalManagementCategoryID as INT, @WorkingStatus INT, @IsFilterByFee BIT,
				
				@OnlineApplicationNo as Varchar(50),
				@ReferenceCode as Varchar(50),
				@OnlinePaymentTypeID int;
		
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
			@WorkingStatus = xmlVals.rowvals.value('(WorkingStatus)[1]','INT'),----------- PALMS V6.2
			@IsFilterByFee = xmlVals.rowvals.value('(IsFilterByFee)[1]','BIT'),----------- PALMS V6.2
			@OnlineApplicationNo = xmlVals.rowvals.value('(OnlineApplicationNo)[1]','VARCHAR(50)'),----------- PALMS V7.2
			@ReferenceCode = xmlVals.rowvals.value('(ReferenceCode)[1]','VARCHAR(50)'),----------- PALMS V7.2
			@OnlinePaymentTypeID = xmlVals.rowvals.value('(OnlinePaymentTypeID)[1]','INT')----------- PALMS V7.2
		From @xmlSearchCriteria.nodes('//DataSearch/PrimarySearchCriteria') as xmlVals(rowvals)			
		
		
		Declare @ResultRowsCount Table
		(	
		  InstrumentID int null 										
		)

		DECLARE @strPrefixA nvarchar(100)
		SET @strPrefixA = N'SELECT DISTINCT I.InstrumentID ' 

		DECLARE @strPrefixB nvarchar(MAX)
		SET @strPrefixB = N'
			SELECT DISTINCT	
				I.InstrumentTypeID, 
				I.InstrumentID, 
				I.InstrumentStatusID, 						
				C2.Name,
				I.DateIssued,
				I.ResponsibleSystemUserID,
				U.GivenName + '' '' + U.Surname ResponsibleOfficer,
				IAP.AccountablePartyID,
				(CASE WHEN AP.CompanyFlag = 1 THEN AP.OrganisationName ELSE AP.GivenName + '' '' + AP.Surname END) AccountableParty,
				LFBA.FeeBasedActivityID,
				FBA.Name FeeBasedActivity,
				LSA.POEOLicenceScheduledActivityID,
				AG.Name ScheduleActivity,
				P.LBLFlag,
				(CASE P.LowRiskFlag WHEN 1 THEN ''Yes'' WHEN 0 THEN ''No'' ELSE ''N\A'' END) LowRiskFlag,
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
				B.EnvironmentalManagementCategory as EnvironmentalManagementCategory,
				CASE WHEN vw.TemplateName IS NULL THEN '''' ELSE '' - Pending '' + vw.TemplateName END AS WorkingStatus '		 
		
		DECLARE @strSearchCriteria nvarchar(MAX)
		SELECT @strSearchCriteria = N'						 
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

				LEFT OUTER JOIN viewInstrumentAccountableParty AP
					ON IAP.AccountablePartyID = AP.AccountablePartyID 
				LEFT OUTER JOIN tblAccountableParty APP
					ON IAP.AccountablePartyID = APP.AccountablePartyID

				LEFT OUTER JOIN tblPOEOLicenceFeeBasedActivity LFBA
				    ON LFBA.InstrumentID = I.InstrumentID and LFBA.FeeBasedActivityID = (select MIN(FeeBasedActivityID) from tblPOEOLicenceFeeBasedActivity LFBA1 where LFBA1.InstrumentID = I.InstrumentID)

				LEFT OUTER JOIN tblFeeBasedActivity FBA
					ON FBA.FeeBasedActivityID = LFBA.FeeBasedActivityID

				LEFT OUTER JOIN tblPOEOLicenceScheduledActivity LSA
				    ON LSA.InstrumentID = I.InstrumentID  and LSA.ActivityGroupID = (select MIN(ActivityGroupID) from tblPOEOLicenceScheduledActivity LSA1 where LSA1.InstrumentID = I.InstrumentID)
				
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
				Left outer Join	tblInstrumentAuditLog al 
					ON al.InstrumentAuditLogID = (Select Max(InstrumentAuditLogID) from tblInstrumentAuditLog al1 
						Where al1.InstrumentID = I.InstrumentID AND al1.ChangedStatusFlag = 1)
                LEFT OUTER JOIN viewLatestPOEOLicenceEnvironmentalManagementCategory B
						ON I.InstrumentID = B.POEOLicenceIntrumentID 
				LEFT OUTER JOIN viewLatestPOEOLicenceEnvironmentalRiskLevel F ON I.InstrumentID =F.InstrumentID										
				LEFT OUTER JOIN (SELECT ni.InstrumentID, nt.TemplateName, nt.NoticeTemplateID  FROM 
									dbo.tblInstrumentNotice ni
										inner join	dbo.tblInstrument Z on Z.InstrumentID = ni.NoticeInstrumentID  
										inner JOIN dbo.tblNotice  N 
											ON N.InstrumentID = z.InstrumentID
										inner JOIN  dbo.tblNoticeTemplate nt 
											ON N.NoticeTemplateID = nt.NoticeTemplateID					
										WHERE nt.SystemTemplateFlag = 1 AND Z.InstrumentStatusID = 9) vw 
						ON (vw.InstrumentID = I.InstrumentID)
								LEFT OUTER JOIN tblOnlinePOEOApplication aon on I.InstrumentID = aon.InstrumentID
								LEFT OUTER JOIN tblOnlineApplicationCode bon on aon.OnlineApplicationCodeID = bon.OnlineApplicationCodeID
			WHERE 		
				(
					C.ClassificationDomainID = 35
				)
				AND
				(
					I.InstrumentTypeID = 493
				) '


		IF (@LicenseStatus <> 3) -- if licence status in not issues working status is not considered
		 SET @WorkingStatus = 0

		DECLARE @whereClause0 AS nvarchar(MAX)                        
		SET  @whereClause0 = N''

		IF NOT @LicenseNo IS NULL AND @LicenseNo > 0
		BEGIN
			SET @whereClause0 = @whereClause0 +  ' AND I.InstrumentID = ' + convert(varchar, @LicenseNo)
		END 

		IF @LicenseType > 0
		BEGIN
			SET @whereClause0 = @whereClause0 +  ' AND I.InstrumentTypeID = ' + convert(varchar, @LicenseType)
		END 
		ELSE
		BEGIN
		    SET @whereClause0 = @whereClause0 +  ' AND I.InstrumentTypeID = ' + convert(varchar, 493)
		END

		IF @LicenseStatus > 0
		BEGIN
			SET @whereClause0 = @whereClause0 +  ' AND I.InstrumentStatusID = ' + convert(varchar, @LicenseStatus)
		END 

		IF @LicenseReviewFrom IS NOT NULL and Len(@LicenseReviewFrom) > 0
		BEGIN
				SET @whereClause0 = @whereClause0 +  ' AND DATEDIFF(day, ' + @LicenseReviewFrom + ', P.ReviewDueDate) >= 0'
		END	

		IF @LicenseReviewTo IS NOT NULL and Len(@LicenseReviewTo) > 0
		BEGIN
				SET @whereClause0 = @whereClause0 +  ' AND DATEDIFF(day, ' + @LicenseReviewTo + ', P.ReviewDueDate) <= 0'
		END	
	 
	    IF NOT @LBL is null 
		BEGIN
				SET @whereClause0 = @whereClause0 +  ' AND cast(P.LBLFlag as varchar) = ' + convert(varchar, @LBL)
		END	

	    IF NOT @LowRisk is null 
		BEGIN
				SET @whereClause0 = @whereClause0 +  ' AND cast(P.LowRiskFlag as vrchar) = ' + convert(varchar, @LowRisk)
		END	

		IF NOT @APName is null and len(@APName) > 0
		BEGIN
		    SET @whereClause0 = @whereClause0 +' AND AP.APName  like ''%' + convert(varchar, @APName) + '%'' ' 
		END

		-- mroe and more here

		IF NOT @OnlineApplicationNo is null and len(@OnlineApplicationNo) > 0
		BEGIN
			SET @whereClause0 = @whereClause0 + ' AND aon.POEOApplicationNumber like ''%' + convert(varchar, @OnlineApplicationNo) + '%'' ' 
		END

		IF NOT @ReferenceCode is null and len(@ReferenceCode) > 0
		BEGIN
			SET @whereClause0 = @whereClause0 + ' AND bon.ApplicationCode like ''%' + convert(varchar, @ReferenceCode) + '%'' ' 
		END

		IF NOT @OnlinePaymentTypeID IS NULL AND @OnlinePaymentTypeID > 0
		BEGIN
		    SET @whereClause0 = @whereClause0 +  ' AND aon.PaymentTypeID = ' + convert(varchar, @OnlinePaymentTypeID)
		END

		DECLARE @strSearchCriteriaFinal nvarchar(MAX)
		set @strSearchCriteriaFinal = @strPrefixA + @strSearchCriteria + @whereClause0 
		
		--we do row count insert here
		Insert Into @ResultRowsCount 
		(
			InstrumentID
		)			
		EXEC sp_executesql @strSearchCriteriaFinal	

		DECLARE @NoOfRecords as int	
		SELECT @NoOfRecords=isnull(COUNT(InstrumentID), 0) from @ResultRowsCount

		select * from @ResultRowsCount

		set @strSearchCriteriaFinal = @strPrefixB + @strSearchCriteria + @whereClause0 
		
		print '@strPrefixB=' + @strPrefixB
		print '@strSearchCriteria=' + @strSearchCriteria
		print '@whereClause0=' + @whereClause0

        declare @InstrumentResultRows table
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
			RowCountTotal int null,
			WorkingStatus Varchar(100) null
		)

		Insert Into @InstrumentResultRows
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
			EnvironmentalManagementCategory,
			WorkingStatus
		)				 				 
		EXEC sp_executesql @strSearchCriteriaFinal;	

		--IF(@ToExport = 0)
		--BEGIN
		--    IF (@NoOfRecords <= @NoOfRecordsRequired)
		--	BEGIN
		--			SELECT TOP (@pageSize) *  FROM @InstrumentResultRows 
		--			WHERE InstrumentID NOT IN  
		--			( SELECT TOP ((@pageNum - 1) * (@pageSize)) InstrumentID FROM @InstrumentResultRows order by InstrumentID )	
		--			 order by InstrumentID				    
		--	END
		--	ELSE
		--	BEGIN
		--		SELECT 
		--			'0' as [APno], 
		--			'0' as [APname],
		--			'0' as [Postaladdress],
		--			'0' as [Recordno],
		--			'0' as [Recordtype], 
		--			'0' as [Section], 					 
		--			'0' as [Streetname],
		--			'0' as [Suburb]	
		--	END
		--END

select * from @InstrumentResultRows