declare @xmlSearchCriteria XML
set @xmlSearchCriteria = 
'
<DataSearch>
  <PrimarySearchCriteria>
    <LicenseType>493</LicenseType>
    <IsFilterByFee>false</IsFilterByFee>
    <ReferenceCode>7</ReferenceCode>
  </PrimarySearchCriteria>
</DataSearch>
'
declare @NoOfRecordsRequired int = 500
declare @MaxRecordsExport int = 5000
declare @ToExport BIT = 0
declare @pageSize int = 50
declare @pageNum int = 1

BEGIN TRY
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

					
		Select @ResponsibleOfficerID =dbo.ufn_GetSystemUserIDByLoginName(@ResponsibleOfficer)
		SET @ResponsibleOfficerID = ISNULL(@ResponsibleOfficerID, 0);
		
		DECLARE @HasFirstSearchCriteria BIT
		SELECT @HasFirstSearchCriteria = 0

		DECLARE @HasOnlineSearchCriteria BIT
		SELECT @HasOnlineSearchCriteria = 0

		IF (@LicenseStatus <> 3) -- if licence status in not issues working status is not considered
		 SET @WorkingStatus = 0;
		
		SET @APName = ISNULL(@APName, '');
		SET @TradingName = ISNULL(@TradingName, '');
		SET @Location = ISNULL(@Location, '');
		SET @Suburb = ISNULL(@Suburb, '');
		SET @StreetName = ISNULL(@StreetName, '');

		SET @OnlineApplicationNo = ISNULL(@OnlineApplicationNo, '')
		SET @ReferenceCode = ISNULL(@ReferenceCode, '')
		SET @OnlinePaymentTypeID = ISNULL(@OnlinePaymentTypeID, 0);

		--IF (@LicenseNo IS NOT NULL AND @LicenseNo != 0 )
		--    SELECT @HasFirstSearchCriteria = 1			
		
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

		IF (@OnlineApplicationNo IS NOT NULL AND @OnlineApplicationNo != '' )
			SELECT @HasOnlineSearchCriteria = 1
		IF (@ReferenceCode IS NOT NULL AND @ReferenceCode != '' )
			SELECT @HasOnlineSearchCriteria = 1		
		IF (@OnlinePaymentTypeID IS NOT NULL AND @OnlinePaymentTypeID != 0 )
		    SELECT @HasOnlineSearchCriteria = 1

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

		IF (@SectionId IS NOT NULL AND @SectionId != 0)
			SELECT @HasFirstSearchCriteria = 1  --added this line 26-05-2014 we mark thise section search onto the first search now
	    --End added line 10-01-2014	
		
		SET @APName = '%' + rtrim(ltrim(@APName)) + '%';		
		SET @TradingName = '%' + rtrim(ltrim(@TradingName)) + '%';
		SET @Location = '%' + rtrim(ltrim(@Location)) + '%';
		SET @Suburb = '%' + rtrim(ltrim(@Suburb)) + '%';
		SET @StreetName = '%' + rtrim(ltrim(@StreetName)) + '%';
		
		SET @OnlineApplicationNo = '%' + rtrim(ltrim(@OnlineApplicationNo)) + '%';		
		SET @ReferenceCode = '%' + rtrim(ltrim(@ReferenceCode)) + '%';		

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
		Create Table #InstrumentAllRowsTEMP 
		(
			InstrumentID int
		)

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
			RowCountTotal int null,
			WorkingStatus Varchar(100) null
		)
        Create Table #InstrumentResultRowsTEMP
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

		DECLARE @OnlineSearchTable Table(InstrumentID int)
		IF @HasOnlineSearchCriteria = 1
		BEGIN
		    insert into @OnlineSearchTable
			select 
			aon.InstrumentID 
			from tblOnlinePOEOApplication aon inner join tblOnlineApplicationCode bon on aon.OnlineApplicationCodeID = bon.OnlineApplicationCodeID 		
			where aon.InstrumentID is not null
			    AND 
			    (
				    @OnlineApplicationNo IS NULL OR @OnlineApplicationNo = ''OR
					  aon.POEOApplicationNumber like @OnlineApplicationNo
				)
				AND
				(
					@ReferenceCode IS NULL OR @ReferenceCode = '' OR
					bon.ApplicationCode like @ReferenceCode					 
				)	
				AND
				(
					@OnlinePaymentTypeID IS NULL OR @OnlinePaymentTypeID = 0
					OR (aon.PaymentTypeID = @OnlinePaymentTypeID)
				)    
		END

print '@ReferenceCode=' + @ReferenceCode
select * from @OnlineSearchTable

		--Insert only if at least 1 criteria is selected		
		IF (@HasFirstSearchCriteria	= 1) AND (@LicenseNo IS NULL OR @LicenseNo = 0) 
		BEGIN				
		        if @FilterCount > 0  --if temp table @StatusTable have records then search will be very fast
				begin
		            if isnull(@EnvironmentalManagementCategoryID, 0) = 0
					begin	
						print 'A' 				    
						Insert Into #InstrumentAllRowsTEMP
						(
							InstrumentID
						)
						SELECT 	 
							DISTINCT I.InstrumentID 
							FROM @StatusTable ST 
								INNER JOIN tblInstrument I ON ST.InstrumentID = I.InstrumentID
								LEFT OUTER JOIN tblClassification C 
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
 
								LEFT OUTER JOIN tblPOEOLicenceEnvironmentalRiskLevel ERL   ------------ PALMS V4.0							   
								ON ERL.InstrumentID = I.InstrumentID								
							
								LEFT OUTER JOIN dbo.tblInstrumentNotice ni 
									ON I.InstrumentID = ni.InstrumentID  
								LEFT OUTER JOIN	dbo.tblInstrument Z 
									ON Z.InstrumentID = ni.NoticeInstrumentID  
								LEFT OUTER JOIN dbo.tblNotice  N 
									ON N.InstrumentID = z.InstrumentID
								LEFT OUTER JOIN dbo.tblNoticeTemplate nt 
									ON N.NoticeTemplateID = nt.NoticeTemplateID	 
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
								--AND				-----------------  PALMS V4.0
								--(
								--	isnull(ERL.EnvironmentalRiskLevelID, 0) = (
								--	case isnull(@EnvironmentalRiskLevelID, 0) 
								--	when 0 then isnull(ERL.EnvironmentalRiskLevelID, 0) 
								--	else @EnvironmentalRiskLevelID 
								--	end)	 
								--)
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
								AND --V6.2
								(
									(@IsFilterByFee IS NULL OR @IsFilterByFee = 0 OR @IsFilterByFee = LFBA.PrimaryFlag) 
								)
								AND
								(
									@SectionId IS NULL OR @SectionId = 0
									OR (I.DECCWSectionID = @SectionId)
								)									 														
					end
					else				
					begin
						print 'B' 
						Insert Into #InstrumentAllRowsTEMP
						(
							InstrumentID
						)
						SELECT 	 
							DISTINCT I.InstrumentID 
							FROM @StatusTable ST 
								INNER JOIN tblInstrument I ON ST.InstrumentID = I.InstrumentID
								LEFT OUTER JOIN tblClassification C 								 
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
								LEFT OUTER JOIN tblPOEOLicenceEnvironmentalRiskLevel ERL   ------------ PALMS V4.0
									ON ERL.InstrumentID = I.InstrumentID	
								LEFT OUTER JOIN viewLatestPOEOLicenceEnvironmentalManagementCategory VPEM 
									ON I.InstrumentID = isnull(VPEM.POEOLicenceIntrumentID, 0)
								--LEFT OUTER JOIN dbo.tblInstrumentNotice ni 
								--			ON I.InstrumentID = ni.InstrumentID  
								--		left outer join	dbo.tblInstrument Z on Z.InstrumentID = ni.NoticeInstrumentID  
								--		LEFT OUTER JOIN dbo.tblNotice  N 
								--			ON N.InstrumentID = z.InstrumentID
								--		LEFT OUTER JOIN dbo.tblNoticeTemplate nt 
								--			ON N.NoticeTemplateID = nt.NoticeTemplateID	
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
									isnull(VPEM.EnvironmentalManagementCategoryID, 0) = 
									(
									case isnull(@EnvironmentalManagementCategoryID, 0) 
									when 0 then isnull(VPEM.EnvironmentalManagementCategoryID, 0) 
									else isnull(@EnvironmentalManagementCategoryID, 0)
									end
									)	 
								)								
								AND --V6.2
								(
									(@IsFilterByFee IS NULL OR @IsFilterByFee = 0 OR @IsFilterByFee = LFBA.PrimaryFlag) 
								)
								AND
								(
									@SectionId IS NULL OR @SectionId = 0
									OR (I.DECCWSectionID = @SectionId)
								)															   		
					end
				end
				else
				begin	
		            if isnull(@EnvironmentalManagementCategoryID, 0) = 0
					begin 
						print 'AA' 				    
						Insert Into #InstrumentAllRowsTEMP
						(
							InstrumentID
						)
						SELECT 	 
							DISTINCT I.InstrumentID 
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
 
								LEFT OUTER JOIN tblPOEOLicenceEnvironmentalRiskLevel ERL   ------------ PALMS V4.0							   
								ON ERL.InstrumentID = I.InstrumentID								
							
								LEFT OUTER JOIN dbo.tblInstrumentNotice ni 
									ON I.InstrumentID = ni.InstrumentID  
								LEFT OUTER JOIN	dbo.tblInstrument Z 
									ON Z.InstrumentID = ni.NoticeInstrumentID  
								LEFT OUTER JOIN dbo.tblNotice  N 
									ON N.InstrumentID = z.InstrumentID
								LEFT OUTER JOIN dbo.tblNoticeTemplate nt 
									ON N.NoticeTemplateID = nt.NoticeTemplateID									 
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
								--AND				-----------------  PALMS V4.0
								--(
								--	isnull(ERL.EnvironmentalRiskLevelID, 0) = (
								--	case isnull(@EnvironmentalRiskLevelID, 0) 
								--	when 0 then isnull(ERL.EnvironmentalRiskLevelID, 0) 
								--	else @EnvironmentalRiskLevelID 
								--	end)	 
								--)
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
								AND --V6.2
								(
									(@IsFilterByFee IS NULL OR @IsFilterByFee = 0 OR @IsFilterByFee = LFBA.PrimaryFlag) 
								)
								AND
								(
									@SectionId IS NULL OR @SectionId = 0
									OR (I.DECCWSectionID = @SectionId)
								)	
					end
					else				
					begin 
						print 'BB' 
						Insert Into #InstrumentAllRowsTEMP
						(
							InstrumentID
						)
						SELECT 	 
							DISTINCT I.InstrumentID 
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
								LEFT OUTER JOIN tblPOEOLicenceEnvironmentalRiskLevel ERL   ------------ PALMS V4.0
									ON ERL.InstrumentID = I.InstrumentID	
								LEFT OUTER JOIN viewLatestPOEOLicenceEnvironmentalManagementCategory VPEM 
									ON I.InstrumentID = isnull(VPEM.POEOLicenceIntrumentID, 0)
								--LEFT OUTER JOIN dbo.tblInstrumentNotice ni 
								--			ON I.InstrumentID = ni.InstrumentID  
								--		left outer join	dbo.tblInstrument Z on Z.InstrumentID = ni.NoticeInstrumentID  
								--		LEFT OUTER JOIN dbo.tblNotice  N 
								--			ON N.InstrumentID = z.InstrumentID
								--		LEFT OUTER JOIN dbo.tblNoticeTemplate nt 
								--			ON N.NoticeTemplateID = nt.NoticeTemplateID	 
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
									isnull(VPEM.EnvironmentalManagementCategoryID, 0) = 
									(
									case isnull(@EnvironmentalManagementCategoryID, 0) 
									when 0 then isnull(VPEM.EnvironmentalManagementCategoryID, 0) 
									else isnull(@EnvironmentalManagementCategoryID, 0)
									end
									)	 
								)								
								AND --V6.2
								(
									(@IsFilterByFee IS NULL OR @IsFilterByFee = 0 OR @IsFilterByFee = LFBA.PrimaryFlag) 
								)
								AND
								(
									@SectionId IS NULL OR @SectionId = 0
									OR (I.DECCWSectionID = @SectionId)
								)														   		
					end
				end

				--in order to improve the query efficiency we will not join those notice data tables if there is no request for @WorkingStatus search
				if @LicenseStatus is not null AND @LicenseStatus = 3 AND (@WorkingStatus is not null and @WorkingStatus > 0)
				begin
					insert into #InstrumentAllRows
			        select I.InstrumentID from #InstrumentAllRowsTEMP I
						LEFT OUTER JOIN dbo.tblInstrumentNotice ni 
							ON I.InstrumentID = ni.InstrumentID  
						LEFT OUTER JOIN	dbo.tblInstrument Z 
							ON Z.InstrumentID = ni.NoticeInstrumentID  
						LEFT OUTER JOIN dbo.tblNotice  N 
							ON N.InstrumentID = z.InstrumentID
						LEFT OUTER JOIN dbo.tblNoticeTemplate nt 
							ON N.NoticeTemplateID = nt.NoticeTemplateID	
					where nt.SystemTemplateFlag = 1 AND Z.InstrumentStatusID = 9 AND nt.NoticeTemplateID = @WorkingStatus
				end
				else
				begin			 									 
					insert into #InstrumentAllRows
			        select I.InstrumentID from #InstrumentAllRowsTEMP I
						LEFT OUTER JOIN dbo.tblInstrumentNotice ni 
							ON I.InstrumentID = ni.InstrumentID  
						LEFT OUTER JOIN	dbo.tblInstrument Z 
							ON Z.InstrumentID = ni.NoticeInstrumentID  
						LEFT OUTER JOIN dbo.tblNotice  N 
							ON N.InstrumentID = z.InstrumentID
						LEFT OUTER JOIN dbo.tblNoticeTemplate nt 
							ON N.NoticeTemplateID = nt.NoticeTemplateID	
					--where nt.SystemTemplateFlag = 1 AND Z.InstrumentStatusID = 9			   
				end
				
				if @HasOnlineSearchCriteria = 1
				  delete from #InstrumentAllRows where Not InstrumentID in (select InstrumentID from @OnlineSearchTable)

				----delete temp table here
				delete #InstrumentAllRowsTemp																
		END	
 
--/* comment out start 		

		SELECT @FirstSearchRows = COUNT(InstrumentID) FROM #InstrumentAllRows
		
		--Check if at least 1 criteria is selected in second search criteria
		DECLARE @HasSecondSearchCriteria BIT
		SELECT @HasSecondSearchCriteria = 0
		
		IF (@LicenseType IS NOT NULL AND @LicenseType != 0)
			SELECT @HasSecondSearchCriteria = 1  -- this will make the second part of search will be always called

		IF (@LicenseNo IS NOT NULL AND @LicenseNo != 0)
			SELECT @HasSecondSearchCriteria = 1

		IF (@LicenseStatus IS NOT NULL AND @LicenseStatus != 0)
			SELECT @HasSecondSearchCriteria = 1

		IF (@ResponsibleOfficerID IS NOT NULL AND @ResponsibleOfficerID != 0)
			SELECT @HasSecondSearchCriteria = 1

		IF (@FirstSearchRows > 0 OR @FilterCount > 0 )
			SELECT @HasSecondSearchCriteria = 1
		
		
		IF @HasSecondSearchCriteria = 1 AND (@LicenseNo IS NULL OR @LicenseNo = 0) AND @HasOnlineSearchCriteria = 0
		BEGIN
		    if @HasFirstSearchCriteria = 0  --if first part search had not been required
		    begin
		      print 'C action here' 
			  Insert Into #InstrumentResultRowsTEMP
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
				B.EnvironmentalManagementCategory as EnvironmentalManagementCategory,
				CASE WHEN vw.TemplateName IS NULL THEN '' ELSE ' - Pending ' + vw.TemplateName END AS WorkingStatus
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
						from tblPOEOLicenceFeeBasedActivity LFBA1 Where LFBA1.InstrumentID = I.InstrumentID AND (@IsFilterByFee IS NULL OR @IsFilterByFee = 0 OR @IsFilterByFee = LFBA1.PrimaryFlag) )
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
				Left outer Join	tblInstrumentAuditLog al 
					ON al.InstrumentAuditLogID = (Select Max(InstrumentAuditLogID) from tblInstrumentAuditLog al1 
						Where al1.InstrumentID = I.InstrumentID AND al1.ChangedStatusFlag = 1)
                LEFT OUTER JOIN viewLatestPOEOLicenceEnvironmentalManagementCategory B
						ON I.InstrumentID = B.POEOLicenceIntrumentID 
				LEFT OUTER JOIN viewLatestPOEOLicenceEnvironmentalRiskLevel F ON I.InstrumentID =F.InstrumentID										
				LEFT OUTER JOIN (SELECT ni.InstrumentID,nt.TemplateName, nt.NoticeTemplateID  FROM 
									dbo.tblInstrumentNotice ni
										INNER JOIN	dbo.tblInstrument Z on Z.InstrumentID = ni.NoticeInstrumentID  
										INNER JOIN dbo.tblNotice  N 
											ON N.InstrumentID = z.InstrumentID
										INNER JOIN  dbo.tblNoticeTemplate nt 
											ON N.NoticeTemplateID = nt.NoticeTemplateID					
										WHERE nt.SystemTemplateFlag = 1 AND Z.InstrumentStatusID = 9) vw 
						ON (vw.InstrumentID = I.InstrumentID)
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
					@FilterCount = 0
					OR
					(
						I.InstrumentID IN(Select InstrumentID from @StatusTable)
					)	
				)				
				--AND --V6.2
				--(
				--	 	(@WorkingStatus IS NULL OR @WorkingStatus = 0 OR  vw.NoticeTemplateID = @WorkingStatus)
				--)	
				AND --V6.2
				(
					(@IsFilterByFee IS NULL OR @IsFilterByFee = 0 OR @IsFilterByFee = LFBA.PrimaryFlag) 
				)
		    end
		    else
		    begin  --we need combine the first part search below
			  print 'D action here' 
			  Insert Into #InstrumentResultRowsTEMP
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
				B.EnvironmentalManagementCategory as EnvironmentalManagementCategory,
				CASE WHEN vw.TemplateName IS NULL THEN '' ELSE ' - Pending ' + vw.TemplateName END AS WorkingStatus
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
						from tblPOEOLicenceFeeBasedActivity LFBA1 Where LFBA1.InstrumentID = I.InstrumentID AND (@IsFilterByFee IS NULL OR @IsFilterByFee = 0 OR @IsFilterByFee = LFBA1.PrimaryFlag) )
				LEFT OUTER JOIN tblFeeBasedActivity FBA
					ON FBA.FeeBasedActivityID = LFBA.FeeBasedActivityID
				LEFT OUTER JOIN tblPOEOLicenceScheduledActivity LSA
					ON LSA.POEOLicenceScheduledActivityID = (Select Min(LSA1.POEOLicenceScheduledActivityID)
						from tblPOEOLicenceScheduledActivity LSA1 Where LSA1.InstrumentID = I.InstrumentID AND (@ScheduleActivityId IS NULL OR @ScheduleActivityId = 0 OR @ScheduleActivityId = LSA.ActivityGroupID))
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
						I.InstrumentID IN (Select isnull(InstrumentID, 0) from #InstrumentAllRows)
				)				
				--AND --V6.2
				--(
				-- 	(@WorkingStatus IS NULL OR @WorkingStatus = 0 OR vw.NoticeTemplateID = @WorkingStatus)
				--)
				AND --V6.2
				(
					(@IsFilterByFee IS NULL OR @IsFilterByFee = 0 OR @IsFilterByFee = LFBA.PrimaryFlag) 
				)
				AND
				(
				   @FeeBasedActID IS NULL OR @FeeBasedActID = 0
								OR (FBA.FeeBasedActivityID = @FeeBasedActID)
				)
				AND
				(
					@OnlineApplicationNo IS NULL OR @OnlineApplicationNo = ''
					OR (PATINDEX(@OnlineApplicationNo, isnull(aon.POEOApplicationNumber, '')) > 0)
				)
				AND
				(
					@ReferenceCode IS NULL OR @ReferenceCode = ''
					OR (PATINDEX(@ReferenceCode, isnull(bon.ApplicationCode, '')) > 0)
				)	
				AND
				(
					@OnlinePaymentTypeID IS NULL OR @OnlinePaymentTypeID = 0
					OR (aon.PaymentTypeID = @OnlinePaymentTypeID)
				)
		    end  

			--in order to improve the query efficiency we will not join those notice data tables if there is no request for @WorkingStatus search
			if @LicenseStatus is not null AND @LicenseStatus = 3 AND (@WorkingStatus is not null and @WorkingStatus > 0)
			begin 
			    print 'final action here A'				 
				insert into #InstrumentResultRows
			    select 
				I.InstrumentTypeID, 
				I.InstrumentID, 
				I.InstrumentStatusID, 
				I.InstrumentStatus,
				I.DateIssued,
				I.ResponsibleSystemUserID,
				I.ResponsibleOfficer,
				I.AccountablePartyID,
				I.AccountableParty,
				I.FeeBasedActivityID,
				I.FeeBasedActivity,
				I.POEOLicenseScheduledActivityID,
				I.ScheduleActivity,
				I.LBLFlag,
				I.LowRiskFlag,
				I.ReviewDueDate,
				I.AnniversaryDate,
				I.DECCWSectionID,
				I.Section,
				I.TradingName,
				I.LocationName,
				I.[Address],
				I.Suburb,
				I.Postcode,
				I.LocationID,
				I.StatusChangedDate,
				I.LGA,
				I.Catchment,
				I.Electorate,
				I.EnvironmentalRiskLevel,
				I.EnvironmentalManagementCategory,
				I.RowCountTotal,
				I.WorkingStatus 
				from #InstrumentResultRowsTEMP I
                INNER JOIN (SELECT ni.InstrumentID, nt.TemplateName, nt.NoticeTemplateID  FROM 
									dbo.tblInstrumentNotice ni
										inner join	dbo.tblInstrument Z on Z.InstrumentID = ni.NoticeInstrumentID  
										inner join dbo.tblNotice  N 
											ON N.InstrumentID = z.InstrumentID
										inner join  dbo.tblNoticeTemplate nt 
											ON N.NoticeTemplateID = nt.NoticeTemplateID					
										WHERE nt.SystemTemplateFlag = 1 AND Z.InstrumentStatusID = 9) vw 
						ON (vw.InstrumentID = I.InstrumentID)
				where  vw.NoticeTemplateID = @WorkingStatus
			end
			else
			begin
			    print 'final action here B'	
				insert into #InstrumentResultRows
                select 
				I.InstrumentTypeID, 
				I.InstrumentID, 
				I.InstrumentStatusID, 
				I.InstrumentStatus,
				I.DateIssued,
				I.ResponsibleSystemUserID,
				I.ResponsibleOfficer,
				I.AccountablePartyID,
				I.AccountableParty,
				I.FeeBasedActivityID,
				I.FeeBasedActivity,
				I.POEOLicenseScheduledActivityID,
				I.ScheduleActivity,
				I.LBLFlag,
				I.LowRiskFlag,
				I.ReviewDueDate,
				I.AnniversaryDate,
				I.DECCWSectionID,
				I.Section,
				I.TradingName,
				I.LocationName,
				I.[Address],
				I.Suburb,
				I.Postcode,
				I.LocationID,
				I.StatusChangedDate,
				I.LGA,
				I.Catchment,
				I.Electorate,
				I.EnvironmentalRiskLevel,
				I.EnvironmentalManagementCategory,
				I.RowCountTotal,
				I.WorkingStatus 
				from #InstrumentResultRowsTEMP I
                LEFT OUTER JOIN (SELECT ni.InstrumentID, nt.TemplateName, nt.NoticeTemplateID  FROM 
									dbo.tblInstrumentNotice ni
										inner join	dbo.tblInstrument Z on Z.InstrumentID = ni.NoticeInstrumentID  
										inner join dbo.tblNotice  N 
											ON N.InstrumentID = z.InstrumentID
										inner join  dbo.tblNoticeTemplate nt 
											ON N.NoticeTemplateID = nt.NoticeTemplateID					
										WHERE nt.SystemTemplateFlag = 1 AND Z.InstrumentStatusID = 9) vw 
						ON (vw.InstrumentID = I.InstrumentID)									   
			end
			 
			--delete temp table here
			delete #InstrumentResultRowsTEMP
		END
				
		IF @LicenseNo IS NOT NULL AND @LicenseNo != 0 --Quick get data when the end user is inputing Licence number
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
				EnvironmentalManagementCategory,
				WorkingStatus
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
				B.EnvironmentalManagementCategory as EnvironmentalManagementCategory,
				CASE WHEN vw.TemplateName IS NULL THEN '' ELSE ' - Pending ' + vw.TemplateName END AS WorkingStatus
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
						from tblPOEOLicenceFeeBasedActivity LFBA1 Where LFBA1.InstrumentID = I.InstrumentID AND (@IsFilterByFee IS NULL OR @IsFilterByFee = 0 OR @IsFilterByFee = LFBA1.PrimaryFlag) )
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
				Left outer Join	tblInstrumentAuditLog al 
					ON al.InstrumentAuditLogID = (Select Max(InstrumentAuditLogID) from tblInstrumentAuditLog al1 
						Where al1.InstrumentID = I.InstrumentID AND al1.ChangedStatusFlag = 1)
                LEFT OUTER JOIN viewLatestPOEOLicenceEnvironmentalManagementCategory B
						ON I.InstrumentID = B.POEOLicenceIntrumentID 
				LEFT OUTER JOIN viewLatestPOEOLicenceEnvironmentalRiskLevel F ON I.InstrumentID =F.InstrumentID									 
				LEFT OUTER JOIN (SELECT ni.InstrumentID,nt.TemplateName, nt.NoticeTemplateID  FROM 
									dbo.tblInstrumentNotice ni
										INNER JOIN	dbo.tblInstrument Z on Z.InstrumentID = ni.NoticeInstrumentID  
										INNER JOIN dbo.tblNotice  N 
											ON N.InstrumentID = z.InstrumentID
										INNER JOIN  dbo.tblNoticeTemplate nt 
											ON N.NoticeTemplateID = nt.NoticeTemplateID					
										WHERE nt.SystemTemplateFlag = 1 AND Z.InstrumentStatusID = 9) vw 
						ON (vw.InstrumentID = I.InstrumentID)
			WHERE 		
				(
					C.ClassificationDomainID = 35
				)				 		
				AND
				(
					 I.InstrumentID = @LicenseNo
				)				 
		END

		--added in 21-11-2016 for online data search purpose
		IF  @HasOnlineSearchCriteria = 1
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
				EnvironmentalManagementCategory,
				WorkingStatus
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
				B.EnvironmentalManagementCategory as EnvironmentalManagementCategory,
				CASE WHEN vw.TemplateName IS NULL THEN '' ELSE ' - Pending ' + vw.TemplateName END AS WorkingStatus
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
						from tblPOEOLicenceFeeBasedActivity LFBA1 Where LFBA1.InstrumentID = I.InstrumentID AND (@IsFilterByFee IS NULL OR @IsFilterByFee = 0 OR @IsFilterByFee = LFBA1.PrimaryFlag) )
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
				Left outer Join	tblInstrumentAuditLog al 
					ON al.InstrumentAuditLogID = (Select Max(InstrumentAuditLogID) from tblInstrumentAuditLog al1 
						Where al1.InstrumentID = I.InstrumentID AND al1.ChangedStatusFlag = 1)
                LEFT OUTER JOIN viewLatestPOEOLicenceEnvironmentalManagementCategory B
						ON I.InstrumentID = B.POEOLicenceIntrumentID 
				LEFT OUTER JOIN viewLatestPOEOLicenceEnvironmentalRiskLevel F ON I.InstrumentID =F.InstrumentID									 
				LEFT OUTER JOIN (SELECT ni.InstrumentID,nt.TemplateName, nt.NoticeTemplateID  FROM 
									dbo.tblInstrumentNotice ni
										INNER JOIN	dbo.tblInstrument Z on Z.InstrumentID = ni.NoticeInstrumentID  
										INNER JOIN dbo.tblNotice  N 
											ON N.InstrumentID = z.InstrumentID
										INNER JOIN  dbo.tblNoticeTemplate nt 
											ON N.NoticeTemplateID = nt.NoticeTemplateID					
										WHERE nt.SystemTemplateFlag = 1 AND Z.InstrumentStatusID = 9) vw 
						ON (vw.InstrumentID = I.InstrumentID)
				INNER JOIN tblOnlinePOEOApplication aon on I.InstrumentID = aon.InstrumentID
				INNER JOIN tblOnlineApplicationCode bon on aon.OnlineApplicationCodeID = bon.OnlineApplicationCodeID
			WHERE 		
				(
					C.ClassificationDomainID = 35
				)				 		
				AND
				(
					@OnlineApplicationNo IS NULL OR @OnlineApplicationNo = ''
					OR (PATINDEX(@OnlineApplicationNo, isnull(aon.POEOApplicationNumber, '')) > 0)
				)
				AND
				(
					@ReferenceCode IS NULL OR @ReferenceCode = ''
					OR (PATINDEX(@ReferenceCode, isnull(bon.ApplicationCode, '')) > 0)
				)	
				AND
				(
					@OnlinePaymentTypeID IS NULL OR @OnlinePaymentTypeID = 0
					OR (aon.PaymentTypeID = @OnlinePaymentTypeID)
				)	
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
 
--*/
		Drop Table #InstrumentResultRows
		Drop Table #InstrumentAllRows
	END TRY

	BEGIN CATCH

		DECLARE @ErrorMessage VARCHAR(2000)
		SET @ErrorMessage = dbo.ufn_GetErrorText()
		--RAISERROR (@ErrorMessage , 16, 1)

	END CATCH