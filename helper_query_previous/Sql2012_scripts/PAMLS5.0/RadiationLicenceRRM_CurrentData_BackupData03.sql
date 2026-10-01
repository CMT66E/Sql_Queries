    DECLARE @InstrumentID int
	set @InstrumentID = 5000067
 
    BEGIN TRY
    
	--BEGIN TRAN
     DECLARE @Cnt int
     DECLARE @PrimaryId int
     DECLARE @RtnVal int
    
		
	DECLARE @LicTypeID AS INT

	SELECT @LicTypeID = RadiationLicenceTypeID FROM tblRadiationLicence WHERE InstrumentID = @InstrumentID

	IF @LicTypeID = 794 or @LicTypeID = 795  ------ lience to use, accreditation
	BEGIN
		DELETE FROM tblRadiationLicenceAccreditationType
		WHERE InstrumentID=@InstrumentID
	
	
		INSERT INTO tblRadiationLicenceAccreditationType(InstrumentID,
													 AccreditationTypeID,
													 DateCreated,
													 CreatedBySystemUserID,
													 DateUpdated,
													 UpdatedBySystemUserID
													 )
		SELECT		InstrumentID,
					AccreditationTypeID,
					DateCreated,
					CreatedBySystemUserID,
					DateUpdated,
					UpdatedBySystemUserID
		FROM tblBURadiationLicenceAccreditationType
		WHERE InstrumentID=@InstrumentID
	
	
		DELETE FROM tblRadiationLicenceCondition
		WHERE InstrumentID=@InstrumentID

		INSERT INTO tblRadiationLicenceCondition(InstrumentID,
													 RadiationConditionID,
													 DateCreated,
													 CreatedBySystemUserID,
													 DateUpdated,
													 UpdatedBySystemUserID
													 )
		SELECT		InstrumentID,
					RadiationConditionID,
					DateCreated,
					CreatedBySystemUserID,
					DateUpdated,
					UpdatedBySystemUserID
		FROM tblBURadiationLicenceCondition
		WHERE InstrumentID=@InstrumentID
	

		DELETE FROM tblRadiationLicenceQualification
		WHERE InstrumentID=@InstrumentID

		INSERT INTO tblRadiationLicenceQualification(InstrumentID,
													 QualificationID,
													 DateCreated,
													 CreatedBySystemUserID,
													 DateUpdated,
													 UpdatedBySystemUserID
													 )
		SELECT		InstrumentID,
					QualificationID,
					DateCreated,
					CreatedBySystemUserID,
					DateUpdated,
					UpdatedBySystemUserID
		FROM tblBURadiationLicenceQualification
		WHERE InstrumentID=@InstrumentID
	
	
	
		DELETE FROM tblRadiationLicenceRadioactiveApparatus
		WHERE InstrumentID=@InstrumentID

		INSERT INTO tblRadiationLicenceRadioactiveApparatus(InstrumentID,
													 RadiationApparatuID,
													 MaximummA,
													 MaximumkVp,
													 PurposeOfUse,
													 DateCreated,
													 CreatedBySystemUserID,
													 DateUpdated,
													 UpdatedBySystemUserID
													 )
		SELECT		InstrumentID,
					 RadiationApparatuID,
					MaximummA,
					 MaximumkVp,
					PurposeOfUse,
					DateCreated,
					CreatedBySystemUserID,
					DateUpdated,
					UpdatedBySystemUserID
		FROM tblBURadiationLicenceRadioactiveApparatus
		WHERE InstrumentID=@InstrumentID
	

		DELETE FROM tblRadiationLicenceRadioactiveSubstances
		WHERE InstrumentID=@InstrumentID

		INSERT INTO tblRadiationLicenceRadioactiveSubstances(InstrumentID,
													 RadioactiveSubstanceTypeID,
													 MaxActivity,
													 MaxActivityUOMID,
													 RadionuclideID,
													 PurposeOfUse,
													 DateCreated,
													 CreatedBySystemUserID,
													 DateUpdated,
													 UpdatedBySystemUserID
													 )
		SELECT		InstrumentID,
					RadioactiveSubstanceTypeID,
					MaxActivity,
					MaxActivityUOMID,
					RadionuclideID,
					PurposeOfUse,
					DateCreated,
					CreatedBySystemUserID,
					DateUpdated,
					UpdatedBySystemUserID
		FROM tblBURadiationLicenceRadioactiveSubstances
		WHERE InstrumentID=@InstrumentID
	
	END	
	
	
	DECLARE @tblRRMCompIDs AS TABLE(RRMComponentID int)
	DECLARE @tblRadiationLicenceIDs AS Table(RadiationLicenceRRMID int)

	
    
	IF(@LicTypeID = 796) --Management licecne
		BEGIN
		    --First thing we need restore is: tblInstrumentRadiationLocation
			--for example there was 1 location record after variation starts we add another two location records
			--if we need restore data now then we only need based original 1 location record not total three
			--here we restore the data on table: tblInstrumentRadiationLocation
			--commented out the following as we need use table:tblInstrumentRadiationLocation which is from Wasif

			--UPDATE RL
			--SET LocationName = BRL.LocationName,
			--	AddressID = BRL.AddressID,
			--	AdditionalAddressInformation = BRL.AdditionalAddressInformation
			--FROM tblRadiationLocation RL
			--Join tblBURadiationLocation BRL ON RL.RadiationLocationID = BRL.RadiationLocationID

			--RESTORE TBLINSTRUMENTRADIATIONLOCATION		
            --handle those rows in backup table not in current tblInstrumentRadiationLocation
			--so we insert them into tblInstrumentRadiationLocation
			INSERT INTO tblInstrumentRadiationLocation(
					   [InstrumentID]
					  ,[RadiationLocationID]
					  ,[VariationPendingFlag]
					  ,[NewInstrumentID]
					  ,[Notes]
					  ,[EffectiveDateFrom]
					  ,[EffectiveDateTo]
					  ,[DateCreated]
					  ,[CreatedBySystemUserID]
					  ,[DateUpdated]
					  ,[UpdatedBySystemUserID]     	
			)
			SELECT 
					   [InstrumentID]
					  ,[RadiationLocationID]
					  ,[VariationPendingFlag]
					  ,[NewInstrumentID]
					  ,[Notes]
					  ,[EffectiveDateFrom]
					  ,[EffectiveDateTo]
					  ,[DateCreated]
					  ,[CreatedBySystemUserID]
					  ,[DateUpdated]
					  ,[UpdatedBySystemUserID]     				
			 FROM tblBUInstrumentRadiationLocation WHERE InstrumentID = @InstrumentID AND
			 NOT InstrumentRadiationLocationID IN (select InstrumentRadiationLocationID from tblInstrumentRadiationLocation where InstrumentID = @InstrumentID)

			 --handle those rows existing on backup and current tblInstrumentRadiationLocation
			 --we update all those relative data columns
			 UPDATE A
			 SET A.InstrumentID = B.InstrumentID,
				 A.RadiationLocationID = B.RadiationLocationID,
				 A.VariationPendingFlag = B.VariationPendingFlag,
				 A.NewInstrumentID = B.NewInstrumentID,
				 A.EffectiveDateFrom = B.EffectiveDateFrom,
				 A.Notes = B.Notes,
				 A.EffectiveDateTo= B.EffectiveDateTo,
				 A.DateCreated = B.DateCreated,
				 A.CreatedBySystemUserID = B.CreatedBySystemUserID,
				 A.DateUpdated = B.DateUpdated,
				 A.UpdatedBySystemUserID = B.UpdatedBySystemUserID
			 FROM tblInstrumentRadiationLocation A
			 Join tblBUInstrumentRadiationLocation B ON A.InstrumentRadiationLocationID = B.InstrumentRadiationLocationID
			 WHERE A.InstrumentID = @InstrumentID AND B.InstrumentID = @InstrumentID AND
			 A.InstrumentRadiationLocationID IN (select InstrumentRadiationLocationID from tblInstrumentRadiationLocation where InstrumentID = @InstrumentID)

			 --Remove all rows with InstrumentRadiationLocationID not in backup tblBUInstrumentRadiationLocation table
			 Delete from tblInstrumentRadiationLocation where InstrumentID = @InstrumentID and not InstrumentRadiationLocationID in (select InstrumentRadiationLocationID from tblBUInstrumentRadiationLocation where InstrumentID = @InstrumentID) 


			
			--AFTER BOAVE RESTORE PROCESS WE NOW HAVE THE ORIGINAL LOCATION RECORDS			 
			--we insert RRMComponentID into temp table variable: @tblRRMCompIDs AS TABLE(RRMComponentID int)

			INSERT INTO @tblRRMCompIDs
			SELECT RRMC.RRMComponentID FROM tblRRMComponent RRMC
			JOIN tblRadiationLicenceRRMComponent LRRMC ON RRMC.RRMComponentID = LRRMC.RRMComponentID
			JOIN tblRadiationLicenceRRM LIRRM ON LRRMC.RadiationLicenceRRMID = LIRRM.RadiationLicenceRRMID
			JOIN tblRadiationLocationRRM LORRM ON LIRRM.RadiationLicenceRRMID = LORRM.RadiationLicenceRRMID
			JOIN tblRadiationLocation RLO ON LORRM.RadiationLocationID = RLO.RadiationLocationID
			JOIN tblInstrumentRadiationLocation IRL ON RLO.RadiationLocationID = IRL.RadiationLocationID
			WHERE IRL.InstrumentID = @InstrumentID AND LRRMC.EffectiveDateTo IS NULL			

			--delete all records from table:tblRadiationLicenceRRMComponent 
			DELETE LRRMC FROM tblRadiationLicenceRRMComponent LRRMC
			JOIN tblRadiationLicenceRRM LIRRM ON LRRMC.RadiationLicenceRRMID = LIRRM.RadiationLicenceRRMID
			JOIN tblRadiationLocationRRM LORRM ON LIRRM.RadiationLicenceRRMID = LORRM.RadiationLicenceRRMID
			JOIN tblRadiationLocation RLO ON LORRM.RadiationLocationID = RLO.RadiationLocationID
			JOIN tblInstrumentRadiationLocation IRL ON RLO.RadiationLocationID = IRL.RadiationLocationID
			WHERE IRL.InstrumentID = @InstrumentID AND LRRMC.EffectiveDateTo IS NULL

			DELETE FROM tblRRMComponent 		
			WHERE RRMComponentID in(SELECT RRMComponentID FROM @tblRRMCompIDs)
			
			--insert all RadiationLicenceRRMID into temp table variable: @tblRadiationLicenceIDs AS Table(RadiationLicenceRRMID int)		
			INSERT INTO @tblRadiationLicenceIDs
			SELECT LIRRM.RadiationLicenceRRMID FROM tblRadiationLicenceRRM LIRRM
			JOIN tblRadiationLocationRRM LORRM ON LIRRM.RadiationLicenceRRMID = LORRM.RadiationLicenceRRMID
			JOIN tblRadiationLocation RLO ON LORRM.RadiationLocationID = RLO.RadiationLocationID
			JOIN tblInstrumentRadiationLocation IRL ON RLO.RadiationLocationID = IRL.RadiationLocationID
			WHERE IRL.InstrumentID = @InstrumentID AND LORRM.EffectiveDateTo IS NULL	
			
			delete LORRM FROM tblRadiationLocationRRM LORRM
							JOIN tblRadiationLocation RLO ON LORRM.RadiationLocationID = RLO.RadiationLocationID
							JOIN tblInstrumentRadiationLocation IRL ON RLO.RadiationLocationID = IRL.RadiationLocationID
							WHERE IRL.InstrumentID = @InstrumentID AND LORRM.EffectiveDateTo IS NULL		

			delete FROM tblRadiationLicenceRRM 
							WHERE RadiationLicenceRRMID IN (SELECT RadiationLicenceRRMID FROM @tblRadiationLicenceIDs)

			DECLARE @TempRadiationLocationRRM AS TABLE(
					[RadiationLocationRRMID] [int] IDENTITY(1,1) NOT NULL,
					[RadiationLocationID] [int] NOT NULL,
					[RadiationLicenceRRMID] [int] NOT NULL,
					[VariationPendingFlag] [bit] NOT NULL,
					[NewLocationID] [int] NULL,
					[Notes] [varchar](255) NULL,
					[InterstateOverseasRelocationFlag] [bit] NOT NULL,
					[Recipient] [varchar](150) NULL,
					[RecipientAddress] [varchar](255) NULL,
					[State] [varchar](3) NULL,
					[Country] [varchar](150) NULL,
					[ExportedDate] [smalldatetime] NULL,
					[EffectiveDateFrom] [smalldatetime] NOT NULL,
					[EffectiveDateTo] [smalldatetime] NULL,
					[DateCreated] [smalldatetime] NOT NULL,
					[CreatedBySystemUserID] [int] NOT NULL,
					[DateUpdated] [smalldatetime] NULL,
					[UpdatedBySystemUserID] [int] NULL)

			INSERT INTO @TempRadiationLocationRRM
			(
				[RadiationLocationID]
				,[RadiationLicenceRRMID]
				,[VariationPendingFlag]
				,[NewLocationID]
				,[Notes]
				,[InterstateOverseasRelocationFlag]	
				,[Recipient]
				,[RecipientAddress]
				,[State]
				,[Country]
				,[ExportedDate]
				,[EffectiveDateFrom]
				,[EffectiveDateTo]
				,[DateCreated]
				,[CreatedBySystemUserID]
				,[DateUpdated]
				,[UpdatedBySystemUserID]
			)
			SELECT	
					LORRM.RadiationLocationID,
					LORRM.[RadiationLicenceRRMID]
					,LORRM.[VariationPendingFlag]
					,LORRM.[NewLocationID]
					,LORRM.[Notes]
					,LORRM.[InterstateOverseasRelocationFlag]
					,LORRM.[Recipient]
					,LORRM.[RecipientAddress]
					,LORRM.[State]
					,LORRM.[Country]
					,LORRM.[ExportedDate]
					,LORRM.[EffectiveDateFrom]
					,LORRM.[EffectiveDateTo]
					,LORRM.[DateCreated]
					,LORRM.[CreatedBySystemUserID]
					,LORRM.[DateUpdated]
					,LORRM.[UpdatedBySystemUserID] FROM tblBURadiationLocationRRM LORRM
			JOIN tblBURadiationLocation RLO ON LORRM.RadiationLocationID = RLO.RadiationLocationID
			JOIN tblInstrumentRadiationLocation IRL ON RLO.RadiationLocationID = IRL.RadiationLocationID
			WHERE IRL.InstrumentID = @InstrumentID AND LORRM.EffectiveDateTo IS NULL		
		
			DECLARE @TempRadiationLicenceRRM AS TABLE(
						[RadiationLicenceRRMID] [int] IDENTITY(1,1) NOT NULL,
						[RadiationLicenceRRMID_BK] [int] NOT NULL,
						[RRMStatusID] [smallint] NOT NULL,
						[RRMTypeID] [smallint] NOT NULL,
						[RRMPurposeID] [smallint] NULL,
						[RRMID] [smallint] NULL,
						[WorkArea] [varchar](255) NULL,
						[RRMSecurityClassificationID] [smallint] NULL,
						[LaboratoryClassificationID] [smallint] NULL,
						[DateCreated] [smalldatetime] NOT NULL,
						[CreatedBySystemUserID] [int] NOT NULL,
						[DateUpdated] [smalldatetime] NULL,
						[UpdatedBySystemUserID] [int] NULL,
						[NewRadiationLicenceRRMID] [int] NULL)

			INSERT INTO @TempRadiationLicenceRRM
			(		
			     RadiationLicenceRRMID_BK
				,[RRMStatusID]
				,[RRMTypeID]
				,[RRMPurposeID]
				,[RRMID]
				,[WorkArea]
				,[RRMSecurityClassificationID]
				,[LaboratoryClassificationID]
				,[DateCreated]
				,[CreatedBySystemUserID]
				,[DateUpdated]
				,[UpdatedBySystemUserID]
			)
			SELECT 
			     LIRRM.RadiationLicenceRRMID 
			    ,LIRRM.[RRMStatusID]
				,LIRRM.[RRMTypeID]
				,LIRRM.[RRMPurposeID]
				,LIRRM.[RRMID]
				,LIRRM.[WorkArea]
				,LIRRM.[RRMSecurityClassificationID]
				,LIRRM.[LaboratoryClassificationID]
				,LIRRM.[DateCreated]
				,LIRRM.[CreatedBySystemUserID]
				,LIRRM.[DateUpdated]
				,LIRRM.[UpdatedBySystemUserID] FROM tblBURadiationLicenceRRM LIRRM
			JOIN tblBURadiationLocationRRM LORRM ON LIRRM.RadiationLicenceRRMID = LORRM.RadiationLicenceRRMID
			JOIN tblBURadiationLocation RLO ON LORRM.RadiationLocationID = RLO.RadiationLocationID
			JOIN tblInstrumentRadiationLocation IRL ON RLO.RadiationLocationID = IRL.RadiationLocationID
			WHERE IRL.InstrumentID = @InstrumentID AND LORRM.EffectiveDateTo IS NULL

			DECLARE @TempRadiationLicenceRRMComponent AS TABLE(
					[RadiationLicenceRRMComponentID] [int] IDENTITY(1,1) NOT NULL,
					[RadiationLicenceRRMID] [int] NULL,
					[RadiationLicenceRRMID_BK] [int] NULL,
					[RRMComponentID] [int] NOT NULL,
					[VariationPendingFlag] [bit] NOT NULL,
					[NewRadiationLicenceRRMID] [int] NULL,
					[Notes] [varchar](255) NULL,
					[InterstateOverseasRelocationFlag] [bit] NOT NULL,
					[Recipient] [varchar](150) NULL,
					[RecipientAddress] [varchar](255) NULL,
					[State] [varchar](3) NULL,
					[Country] [varchar](150) NULL,
					[ExportedDate] [smalldatetime] NULL,
					[EffectiveDateFrom] [smalldatetime] NOT NULL,
					[EffectiveDateTo] [smalldatetime] NULL,
					[DateCreated] [smalldatetime] NOT NULL,
					[CreatedBySystemUserID] [int] NOT NULL,
					[DateUpdated] [smalldatetime] NULL,
					[UpdatedBySystemUserID] [int] NULL)

			INSERT INTO @TempRadiationLicenceRRMComponent
			(	
				 LRRMC.[RadiationLicenceRRMID_BK]
				,LRRMC.[RRMComponentID]
				,[VariationPendingFlag]
				,[NewRadiationLicenceRRMID]
				,[Notes]
				,[InterstateOverseasRelocationFlag]
				,[Recipient]
				,[RecipientAddress]
				,[State]
				,[Country]
				,[ExportedDate]
				,[EffectiveDateFrom]
				,[EffectiveDateTo]
				,[DateCreated]
				,[CreatedBySystemUserID]
				,[DateUpdated]
				,[UpdatedBySystemUserID]
			)
			SELECT DISTINCT
				 LRRMC.[RadiationLicenceRRMID]
				,LRRMC.[RRMComponentID]
				,LRRMC.[VariationPendingFlag]
				,LRRMC.[NewRadiationLicenceRRMID]
				,LRRMC.[Notes]
				,LRRMC.[InterstateOverseasRelocationFlag]
				,LRRMC.[Recipient]
				,LRRMC.[RecipientAddress]
				,LRRMC.[State]
				,LRRMC.[Country]
				,LRRMC.[ExportedDate]
				,LRRMC.[EffectiveDateFrom]
				,LRRMC.[EffectiveDateTo]
				,LRRMC.[DateCreated]
				,LRRMC.[CreatedBySystemUserID]
				,LRRMC.[DateUpdated]
				,LRRMC.[UpdatedBySystemUserID] FROM tblBURadiationLicenceRRMComponent LRRMC
			JOIN tblBURadiationLicenceRRM LIRRM ON LRRMC.RadiationLicenceRRMID = LIRRM.RadiationLicenceRRMID
			JOIN tblBURadiationLocationRRM LORRM ON LIRRM.RadiationLicenceRRMID = LORRM.RadiationLicenceRRMID
			JOIN tblBURadiationLocation RLO ON LORRM.RadiationLocationID = RLO.RadiationLocationID
			JOIN tblInstrumentRadiationLocation IRL ON RLO.RadiationLocationID = IRL.RadiationLocationID
			WHERE IRL.InstrumentID = @InstrumentID AND LRRMC.EffectiveDateTo IS NULL

			DECLARE @TempRRMComponent AS TABLE(
					[RRMComponentID] [int] IDENTITY(1,1) NOT NULL,
					[ComponentStatusID] [smallint] NOT NULL,
					[RRMComponentTypeID] [smallint] NOT NULL,
					[AssayDate] [smalldatetime] NULL,
					[ManufacturerID] [smallint] NULL,
					[ModelNumber] [varchar](30) NULL,
					[SerialNumber] [varchar](30) NULL,
					[RadionuclideID] [int] NULL,
					[NominalActivity] [int] NULL,
					[WorkingLife] [smallint] NULL,
					[ExtendedWorkingLifeFlag] [bit] NOT NULL,
					[DateCreated] [smalldatetime] NOT NULL,
					[CreatedBySystemUserID] [int] NOT NULL,
					[DateUpdated] [smalldatetime] NULL,
					[UpdatedBySystemUserID] [int] NULL,
					[NewRRMComponentID] [int] NULL)


			INSERT INTO @TempRRMComponent
			(
				[ComponentStatusID],
				[RRMComponentTypeID],
				[AssayDate],
				[ManufacturerID],
				[ModelNumber],
				[SerialNumber],
				[RadionuclideID],
				[NominalActivity],
				[WorkingLife],
				[ExtendedWorkingLifeFlag],
				[DateCreated],
				[CreatedBySystemUserID],
				[DateUpdated],
				[UpdatedBySystemUserID]
			)
			SELECT DISTINCT RRMC.[ComponentStatusID]
					,RRMC.[RRMComponentTypeID]
					,RRMC.[AssayDate]
					,RRMC.[ManufacturerID]
					,RRMC.[ModelNumber]
					,RRMC.[SerialNumber]
					,RRMC.[RadionuclideID]
					,RRMC.[NominalActivity]
					,RRMC.[WorkingLife]
					,RRMC.[ExtendedWorkingLifeFlag]
					,RRMC.[DateCreated]
					,RRMC.[CreatedBySystemUserID]
					,RRMC.[DateUpdated]
					,RRMC.[UpdatedBySystemUserID] FROM tblBURRMComponent RRMC
			JOIN tblBURadiationLicenceRRMComponent LRRMC ON RRMC.RRMComponentID = LRRMC.RRMComponentID
			JOIN tblBURadiationLicenceRRM LIRRM ON LRRMC.RadiationLicenceRRMID = LIRRM.RadiationLicenceRRMID
			JOIN tblBURadiationLocationRRM LORRM ON LIRRM.RadiationLicenceRRMID = LORRM.RadiationLicenceRRMID
			JOIN tblBURadiationLocation RLO ON LORRM.RadiationLocationID = RLO.RadiationLocationID
			JOIN tblInstrumentRadiationLocation IRL ON RLO.RadiationLocationID = IRL.RadiationLocationID
			WHERE IRL.InstrumentID = @InstrumentID AND LRRMC.EffectiveDateTo IS NULL


			DECLARE @RowID AS INT = 0
			DECLARE @RadiationLicenceRRMID AS INT
			DECLARE @RadiationLicenceRRMID_BK AS INT
						
			--Insert tblRadiationLicenceRRM rows and update newly created ids in the temp table
			WHILE (SELECT COUNT(*) FROM @TempRadiationLicenceRRM WHERE NewRadiationLicenceRRMID IS NULL) > 0
			BEGIN
				Select Top 1 @RowID = RadiationLicenceRRMID, @RadiationLicenceRRMID_BK = RadiationLicenceRRMID_BK FROM @TempRadiationLicenceRRM WHERE NewRadiationLicenceRRMID IS NULL

				INSERT INTO [dbo].[tblRadiationLicenceRRM]
					([RRMStatusID]
					,[RRMTypeID]
					,[RRMPurposeID]
					,[RRMID]
					,[WorkArea]
					,[RRMSecurityClassificationID]
					,[LaboratoryClassificationID]
					,[DateCreated]
					,[CreatedBySystemUserID])
				SELECT 
					RRMStatusID,
					RRMTypeID,
					RRMPurposeID,
					RRMID,
					WorkArea,
					RRMSecurityClassificationID,
					LaboratoryClassificationID,
					GETDATE(),
					CreatedBySystemUserID									
				FROM @TempRadiationLicenceRRM
					WHERE RadiationLicenceRRMID = @RowID

				SET @RadiationLicenceRRMID= @@IDENTITY

print '@RadiationLicenceRRMID =' + cast (@RadiationLicenceRRMID as varchar)

				UPDATE @TempRadiationLicenceRRM								
				SET NewRadiationLicenceRRMID = @RadiationLicenceRRMID
				WHERE RadiationLicenceRRMID = @RowID

				--here we need update the temp table: @TempRadiationLocationRRM column:RadiationLicenceRRMID
				--because we will need this table to update real table: tblRadiationLocationRRM later
				UPDATE @TempRadiationLocationRRM								
				SET RadiationLicenceRRMID = @RadiationLicenceRRMID
				WHERE RadiationLocationRRMID = @RowID	 

				--UPDATE @TempRadiationLicenceRRMComponent.RadiationLicenceRRMID
				UPDATE @TempRadiationLicenceRRMComponent
				SET RadiationLicenceRRMID = @RadiationLicenceRRMID
				WHERE [RadiationLicenceRRMID_BK] = @RadiationLicenceRRMID_BK
			END
						
select * from @TempRadiationLicenceRRMComponent

			--Insert tblRadiationLocationRRM rows
			INSERT INTO [dbo].[tblRadiationLocationRRM]
				([RadiationLocationID]
				,[RadiationLicenceRRMID]
				,[VariationPendingFlag]
				,[Notes]
				,[InterstateOverseasRelocationFlag]
				,[EffectiveDateFrom]
				,[DateCreated]
				,[CreatedBySystemUserID])
			SELECT 
				LO.RadiationLocationID,
				LI.RadiationLicenceRRMID,
				LO.VariationPendingFlag,
				LO.Notes,
				LO.InterstateOverseasRelocationFlag,
				GETDATE(),
				GETDATE(),
				LO.CreatedBySystemUserID							
			FROM @TempRadiationLocationRRM LO
			INNER JOIN tblRadiationLicenceRRM LI ON LO.RadiationLicenceRRMID = LI.RadiationLicenceRRMID
			WHERE LI.RadiationLicenceRRMID > 0

			SET @RowID = 0
			DECLARE @RRMComponentID AS INT						
			WHILE (SELECT COUNT(*) FROM @TempRRMComponent WHERE NewRRMComponentID IS NULL) > 0
			BEGIN
				Select Top 1 @RowID = RRMComponentID FROM @TempRRMComponent WHERE NewRRMComponentID IS NULL

				INSERT INTO [dbo].[tblRRMComponent]
					([ComponentStatusID]
					,[RRMComponentTypeID]
					,[AssayDate]
					,[ManufacturerID]
					,[ModelNumber]
					,[SerialNumber]
					,[RadionuclideID]
					,[NominalActivity]
					,[WorkingLife]
					,[ExtendedWorkingLifeFlag]
					,[DateCreated]
					,[CreatedBySystemUserID])
				SELECT 
					ComponentStatusID,
					RRMComponentTypeID,
					AssayDate,
					ManufacturerID,
					ModelNumber,
					SerialNumber,
					RadionuclideID,
					NominalActivity,
					WorkingLife,
					ExtendedWorkingLifeFlag,
					GETDATE(),
					CreatedBySystemUserID									
				FROM @TempRRMComponent
					WHERE RRMComponentID = @RowID

				SET @RRMComponentID = @@IDENTITY

print '@RRMComponentID =' + cast (@RRMComponentID as varchar)

				UPDATE @TempRRMComponent
				SET NewRRMComponentID = @RRMComponentID
				WHERE RRMComponentID = @RowID

				UPDATE @TempRadiationLicenceRRMComponent
				SET RRMComponentID = @RRMComponentID
				WHERE RadiationLicenceRRMComponentID = @RowID
			END

			SELECT 
				LI.RadiationLicenceRRMID,
				RRM.RRMComponentID,
				LI.VariationPendingFlag,
				LI.Notes,
				LI.InterstateOverseasRelocationFlag,
				GETDATE(),
				GETDATE(),
				LI.CreatedBySystemUserID							
			FROM @TempRadiationLicenceRRMComponent LI
			INNER JOIN tblRRMComponent RRM ON LI.RRMComponentID = RRM.RRMComponentID
			WHERE RRM.RRMComponentID > 0

			INSERT INTO [dbo].[tblRadiationLicenceRRMComponent]
				([RadiationLicenceRRMID]
				,[RRMComponentID]
				,[VariationPendingFlag]
				,[Notes]
				,[InterstateOverseasRelocationFlag]
				,[EffectiveDateFrom]
				,[DateCreated]
				,[CreatedBySystemUserID])
			SELECT 
				LI.RadiationLicenceRRMID,
				RRM.RRMComponentID,
				LI.VariationPendingFlag,
				LI.Notes,
				LI.InterstateOverseasRelocationFlag,
				GETDATE(),
				GETDATE(),
				LI.CreatedBySystemUserID							
			FROM @TempRadiationLicenceRRMComponent LI
			INNER JOIN tblRRMComponent RRM ON LI.RRMComponentID = RRM.RRMComponentID
			WHERE RRM.RRMComponentID > 0	

			UPDATE RL
			SET LocationName = BRL.LocationName,
				AddressID = BRL.AddressID,
				AdditionalAddressInformation = BRL.AdditionalAddressInformation
			FROM tblRadiationLocation RL
			Join tblBURadiationLocation BRL ON RL.RadiationLocationID = BRL.RadiationLocationID

			--At the end we delete location data from backup table
			--delete those backup data from table: tblBUInstrumentRadiationLocation
			 DELETE FROM tblBUInstrumentRadiationLocation			 
			 WHERE InstrumentID = @InstrumentID

		END

    --Once the restore is complete need to clean up the data from back up tables
    Exec @RtnVal = uspDeleteBackUpRadiationLicenceData @InstrumentID
    IF @RtnVal < 0 RAISERROR ('Problem Deleting BackUp InstrumentData uspDeleteBackUpInstrumentData' , 16, 1) 
    
    --COMMIT TRAN
    
	END TRY
	BEGIN CATCH
	
		--ROLLBACK TRAN
		
		DECLARE @ErrorMessage VARCHAR(2000)
		
		SET @ErrorMessage = dbo.ufn_GetErrorText()
		
		RAISERROR (@ErrorMessage , 16, 1)
	
	END CATCH
	 
