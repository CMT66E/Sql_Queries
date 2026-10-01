declare @inInstrumentID INT = 5068399  
declare @inLicenceTypeID INT = 1402
declare @inPairedFlag INT = 1
declare @inCurrentUserID INT = 1399
declare @outPairedLicenceNo VARCHAR(50) = ''

 
declare @IsAdd bit = 0
	declare @Temp varchar(50) = ''
	SET NOCOUNT ON;

    --1. we update transporter licence type id. DangerousGoodVehicleLicence = 1401 and TrackableWasteTransportLicence = 1402
	--   if it is paired licence then we set the primary one to be TWT: 1402

	-- consider variation situation we removed and InstrumentStatusID = 752 condition. 752 submitted status
	if exists(select InstrumentID from tblInstrument where InstrumentTypeID = 1417 and InstrumentID = @inInstrumentID) 
	begin
		update tblTransporterLicence set LicenceTypeID = (case @inPairedFlag when 0 then @inLicenceTypeID else 1402 end), PrimaryTransporterLicenceFlag = 1
		where  InstrumentID = @inInstrumentID
       
	    --we have to pair this transporter licence based on current licence number: @inInstrumentID
	    if @inPairedFlag = 1 and exists(select PairedInstrumentID from tblTransporterLicence where InstrumentID = @inInstrumentID and isnull(PairedInstrumentID, 0) = 0)  
		begin
		    DECLARE @ResponsibleUserLogin VARCHAR(100)
		    DECLARE @InstrumentID INT = 0
		    DECLARE @tblInstrument tblInstrumentType
		    DECLARE @RtnVal INT = 0

            INSERT INTO @tblInstrument(InstrumentID,
							   InstrumentTypeID,
							   InstrumentStatusID,
							   ResponsibleSystemUserID,
							   ResponsibleUserLogin,
							   DECCWSectionID,
							   IssuedBySystemUserID,
							   DateIssued,
							   DisplayFlag,
							   CreatedBySystemUserID,
							   UpdatedBySystemUserID,
							   RowTimestamp)
		   SELECT              -1 as InstrumentID,
							   InstrumentTypeID,
							   InstrumentStatusID,
							   ResponsibleSystemUserID,
							   (select [Login] from tblSystemUser where SystemUserID = CreatedBySystemUserID) as ResponsibleUserLogin,
							   DECCWSectionID,
							   IssuedBySystemUserID,
							   DateIssued,
							   DisplayFlag,
							   CreatedBySystemUserID,
							   UpdatedBySystemUserID,
							   RowTimestamp
            FROM tblInstrument WHERE InstrumentID = @inInstrumentID		
						 	
			Exec @InstrumentID = uspSaveInstrument @tblInstrument

			--print '@InstrumentID =' + cast(@InstrumentID as varchar)

		    update tblTransporterLicence set PairedInstrumentID = @InstrumentID
		    where  InstrumentID = @inInstrumentID
			
			---------------------------------------------------------------------------------------------------		
            INSERT INTO tblTransporterLicence
			(
			   [InstrumentID]
			  ,[LicenceTypeID]
			  ,[TrackableWasteTransportTypeID]
			  ,[DateApplicationReceived]
			  ,[DateApplicationCompleted]
			  ,[AdminFee]
			  ,[LicenceDurationID]
			  ,[ExpiryDate]
			  ,[ReviewDueDate]
			  ,[ConsentForECFlag]
			  ,[Notes]
			  ,[TRIMNumber]
			  ,[PairedInstrumentID]
			  ,[PrimaryTransporterLicenceFlag]
			  ,[OldLicenceNumber]
			  ,[RenewalNoticeSentDate]
			  ,[PendingVariationAlertSentDate]
			  ,[DateCreated]
			  ,[CreatedBySystemUserID]
			  ,[DateUpdated]
			  ,[UpdatedBySystemUserID]     
			)
			Select		  @InstrumentID,
			              1401 as LicenceTypeID,
						  TrackableWasteTransportTypeID,
						  dateadd(day, -1, DateApplicationReceived),						  
						  dateadd(day, -1, DateApplicationCompleted),
						  AdminFee, 
						  [LicenceDurationID], 
						  [ExpiryDate], 
						  [ReviewDueDate], 
						  [ConsentForECFlag], 
						  [Notes], 
						  [TRIMNumber], 
						  null as [PairedInstrumentID], 
						  0 as [PrimaryTransporterLicenceFlag], 
						  [OldLicenceNumber], 
						  [RenewalNoticeSentDate], 
						  [PendingVariationAlertSentDate], 
						  getdate() as [DateCreated], 
						  @inCurrentUserID as [CreatedBySystemUserID], 
						  null as [DateUpdated], 
						  null as [UpdatedBySystemUserID]     			   
			From tblTransporterLicence
			WHERE InstrumentID = @inInstrumentID

			SELECT @RtnVal = 0
			EXEC @RtnVal = uspAuditLogInsert @InstrumentID,'Transporter Licence created (paired)','Transporter Licence created and Assigned its parent licence status', @inCurrentUserID, @inCurrentUserID, 1
			
			DECLARE @tblAccountableParty tblInstrumentAccountablePartyType
			DECLARE @tblContact tblInstrumentContactType 
			DECLARE @tblTransporterLocation tblTransporterLocationTypeNew
			DECLARE @tblDGLicenceVehicle tblDGLicenceVehicleType			
								   	
			DECLARE @AppCompleteDate DateTime
			SELECT @AppCompleteDate = DateApplicationCompleted From tblTransporterLicence where InstrumentID = @InstrumentID						
									
		    ---------------------------------------------------------------------------------------------------
			--Insert/Update Accountable Party records
	        INSERT INTO @tblAccountableParty(InstrumentAccountablePartyID,
									 InstrumentID,
									 AccountablePartyID,
									 LandownerFlag,
									 DescriptionOfRelationship,
									 EffectiveDateFrom,
									 EffectiveDateTo,
									 CreatedBySystemUserID,
									 UpdatedBySystemUserID,
									 RowTimestamp,
									 Action)
			SELECT -1 as InstrumentAccountablePartyID,
									 InstrumentID,
									 AccountablePartyID,
									 LandownerFlag,
									 DescriptionOfRelationship,
									 EffectiveDateFrom,
									 EffectiveDateTo,
									 CreatedBySystemUserID,
									 UpdatedBySystemUserID,
									 RowTimestamp,
									 'I' as Action
            FROM tblInstrumentAccountableParty WHERE InstrumentID = @inInstrumentID


			SELECT @RtnVal =0
			Exec @RtnVal = uspLinkAccountableParties @tblAccountableParty, @InstrumentID
			IF @RtnVal <> 0 RAISERROR ('Problem saving uspLinkAccountableParty' , 16, 1) 
	
	        ---------------------------------------------------------------------------------------------------
			--Insert/Update Contact records
	        INSERT INTO @tblContact(InstrumentContactID,
							InstrumentID,
							ContactID,
							PostalContactFlag,
							EmailContactFlag,
							CreatedBySystemUserID,
							UpdatedBySystemUserID,
							RowTimestamp,
							Action)
            SELECT -1 as InstrumentContactID,
							InstrumentID,
							ContactID,
							PostalContactFlag,
							EmailContactFlag,
							CreatedBySystemUserID,
							UpdatedBySystemUserID,
							RowTimestamp,
							'I' as Action
		    FROM tblInstrumentContact WHERE InstrumentID = @inInstrumentID

			SELECT @RtnVal =0
			Exec @RtnVal = uspLinkContacts @tblContact, @InstrumentID
			IF @RtnVal <> 0 RAISERROR ('Problem saving uspLinkContacts' , 16, 1) 
			---------------------------------------------------------------------------------------------------
			--clean all existing rows if there are any
			delete from @tblDGLicenceVehicle

            INSERT INTO @tblDGLicenceVehicle(
					 [DGLicenceVehicleID]
					,[InstrumentID]
					,[DGVehicleID]
					,[VariationPendingFlag]
					,[NewDGLicenceID]
					,[Notes]
					,[EffectiveDateFrom]
					,[EffectiveDateTo]
					,[DateCreated]
					,[CreatedBySystemUserID]
					,[DateUpdated]
					,[UpdatedBySystemUserID]
					,[Action])
            SELECT   -1 as [DGLicenceVehicleID]
					,@InstrumentID as [InstrumentID]
					,[DGVehicleID]
					,[VariationPendingFlag]
					,[NewDGLicenceID]
					,[Notes]
					,[EffectiveDateFrom]
					,[EffectiveDateTo]
					,[DateCreated]
					,[CreatedBySystemUserID]
					,[DateUpdated]
					,[UpdatedBySystemUserID]
					,'I' as [Action]
			FROM tblDGLicenceVehicle WHERE InstrumentID = @inInstrumentID 		     
			AND tblDGLicenceVehicle.EffectiveDateFrom < GETDATE()
			AND tblDGLicenceVehicle.EffectiveDateTo is null

			--Insert/Update DGLicenceVehicle records

			print '@InstrumentID='+ cast(@InstrumentID as varchar(50))

			select * from @tblDGLicenceVehicle

			SELECT @RtnVal =0
			Exec @RtnVal = uspLinkDGVehicle @tblDGLicenceVehicle, @InstrumentID
			IF @RtnVal <> 0 RAISERROR ('Problem saving uspLinkDGVehicle' , 16, 1) 
		
	        ---------------------------------------------------------------------------------------------------
	        INSERT INTO @tblTransporterLocation(
                             InstrumentTransporterLocationID,
							 InstrumentID,
							 TransporterLocationID,
							 LocationName,
							 [Address],
							 IsRiskZone,
							 CreatedBySystemUserID,
							 UpdatedBySystemUserID,
							 RowTimestamp,
							 Action)
            SELECT           -1 as InstrumentTransporterLocationID,
							 @InstrumentID as InstrumentID,
							 a.TransporterLocationID,
							 (select LocationName from tblTransporterLocation where TransporterLocationID = a.TransporterLocationID),
							 (select AddressID from tblTransporterLocation where TransporterLocationID = a.TransporterLocationID),
							 0 as IsRiskZone,
							 CreatedBySystemUserID,
							 UpdatedBySystemUserID,
							 RowTimestamp,
							 'I' as Action
            FROM tblInstrumentTransporterLocation a WHERE a.InstrumentID = @inInstrumentID 


			SELECT @RtnVal =0
			Exec @RtnVal = uspLinkTransporterLocations @tblTransporterLocation, @InstrumentID
			IF @RtnVal <> 0 RAISERROR ('Problem saving uspLinkDGVehicleTransportationLocations' , 16, 1) 
       
	        ---------------------------------------------------------------------------------------------------

            INSERT INTO tblDGLicenceeFitAndProper(       
												   InstrumentID
												  ,FitAndProperQuestionID
												  ,FitAndProperAnswerFlag
												  ,Justification
												  ,DateCreated
												  ,CreatedBySystemUserID											  
												)
			SELECT 	@InstrumentID,
					FitAndProperQuestionID,
					FitAndProperAnswerFlag,
					Justification,
					GetDate(),						  
					CreatedBySystemUserID						    
			FROM tblDGLicenceeFitAndProper WHERE InstrumentID =  @inInstrumentID   
			
			---------------------------------------------------------------------------------------------------

			DECLARE @InstrumentTypeID int -- 750: radiation licence; 817: Dangerous Goods Licence; 818: Pesticide Licence 
			select @InstrumentTypeID = InstrumentTypeID from tblInstrument where InstrumentID = @InstrumentID
			DECLARE @EventIdTemp int = 0
		 
			if @InstrumentTypeID = 750 --radiation licence	  
			   set @EventIdTemp = 14  --/SB:Event ID 14 is to start clock in tblEvent for Radiation License Clock
			else if @InstrumentTypeID = 817 --Dangerous Goods Licence
			   set @EventIdTemp = 17
			else if @InstrumentTypeID = 818 --Pesticide Licence            
			   set @EventIdTemp = 19
			else if  @InstrumentTypeID = 1417 --Transporter Licence            
			   set @EventIdTemp = 22

			--SB:Create clock if Instrument status is Draft

			IF (EXISTS(SELECT * FROM tblInstrument WHERE InstrumentID = @InstrumentID AND InstrumentStatusID = 751) AND @AppCompleteDate IS NOT NULL)
   			BEGIN
   					SELECT @RtnVal = 0
					EXEC @RtnVal = uspInstrument_Clock_Create @InstrumentID, @EventIdTemp, 0, @inCurrentUserID, @AppCompleteDate 
			END			 
		
			--FINALLY WE RETURN	  
			select @outPairedLicenceNo = cast(@InstrumentID as varchar(50)) 
		end	 
    
	   select 1
	end 