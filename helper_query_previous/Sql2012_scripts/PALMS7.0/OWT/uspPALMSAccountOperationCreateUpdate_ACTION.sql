declare @InstrumentID        int
declare	@CustomerID              int
declare	@SiteID                  int
declare	@ContactID               int
declare	@TitleCodeID             int

declare	@Surname                 varchar(50)
declare	@Middlename              varchar(50)
declare	@GivenName               varchar(50)
declare	@OrganisationName        varchar(128)
declare	@Phone                   varchar(20)
declare	@Mobile                  varchar(20)
declare	@AfterHoursNumber        varchar(20)
declare	@Fax			         varchar(20)
declare	@Email                   varchar(128)
declare	@AddressID               int
	 
declare	@StreetAddress           varchar(100)
declare	@Suburb                  varchar(50)
declare	@PostCode                char(4)
declare	@StateCode               varchar(4)	 
declare	@ReturnAccountOperationID INT  

set @InstrumentID = 20556
set @CustomerID = 14106
set @SiteID = 22588
set @ContactID = 13710
set @TitleCodeID = 7
set @Surname = 'Sansom'
set @Middlename = ''
set @GivenName = 'Gavin'
set @OrganisationName = 'DP WORLD SYDNEY LIMITED'
set @Phone = '(02) 9394 0997'
set @Mobile = '0401 148597'
set @AfterHoursNumber = ''
set @Fax = '(02) 9394 0940' 
set @Email = ''
set @AddressID = 18417

set @StreetAddress = 'PO Box 192'
set @Suburb = 'MATRAVILLE'
set @PostCode = '2036'
set @StateCode = 'NSW'
set @ReturnAccountOperationID = 0


            DECLARE @CreatedBySystemUserID int = 1 
			DECLARE @ResponsibleSystemUserID int
			DECLARE @ReturnIndividualID int 
			DECLARE @AccountOperationRoleTypeID int

			--BEGIN TRANSACTION
			
			declare @StreetAddressSite varchar(100)
			declare @SuburbSite varchar(50)
			declare @PostcodeSite char(4)
			declare @StateCodeSite varchar(4)
			select @StreetAddressSite = isnull(StreetAddress, ''),
				    @SuburbSite = isnull(Suburb, ''),
					@PostcodeSite = isnull(Postcode, ''),
					@StateCodeSite = isnull(StateCode, '')
			from [Site] where SiteID = @SiteID 


			declare @RecordType1 bit
			select  @RecordType1 = [dbo].[ufn_PALMSConsignorRecordExist](@CustomerID, @SiteID) 
			if @RecordType1 = 0 -- Create consignor record in AccountOperation AccountOperationRoleTypeID=288
			begin
			  --insert action
			  --1. Insert into AccountOperation: Consignor----------------------------
			      SET @AccountOperationRoleTypeID = 288
				  INSERT INTO
				  dbo.AccountOperation
				  (
					CustomerID,
					SiteID,
					AccountOperationPermit,
					AccountOperationRoleTypeID,
					RegionCode,
					MaximumWasteTonnesPerYear,
					EmergencyContactPhoneNumber,
					ConsignmentAuthorisationCreateFlag,
					EffectiveDateFrom,
					EffectiveDateTo,
					DateCreated,
					CreatedBySystemUserID,
					CreatedIPAddress,
					DateUpdated,
					UpdatedBySystemUserID,
					UpdatedIPAddress,
					NSWLicenceFlag,
					ApprovalMultipleWasteCAFlag
				  )
				  select 
			        @CustomerID as CustomerID,
					@SiteID as SiteID,
					cast(@InstrumentID as varchar) as AccountOperationPermit,
					@AccountOperationRoleTypeID as AccountOperationRoleTypeID,
					null as RegionCode,
					null as MaximumWasteTonnesPerYear,
					(case isnull(@AfterHoursNumber,  '') when '' then (case isnull(@Phone, '') when '' then (case isnull(@Mobile, '') when '' then '(00) 0000 0000' else @Mobile end) else @Phone end) else @AfterHoursNumber end) as EmergencyContactPhoneNumber,
					0 as ConsignmentAuthorisationCreateFlag,
					getdate() as EffectiveDateFrom,
					null as EffectiveDateTo,
					getdate() as DateCreated,
					@CreatedBySystemUserID as CreatedBySystemUserID,
					'' as CreatedIPAddress,
					getdate() as DateUpdated,
					1 as UpdatedBySystemUserID,
					'' as UpdatedIPAddress,
					1 as NSWLicenceFlag,
					0 as ApprovalMultipleWasteCAFlag

			      select @ReturnAccountOperationID = @@IDENTITY
			 
			  --2. Insert into Individual: Consignor----------------------------------		
			  IF NOT EXISTS(SELECT IndividualID from Individual where AccountOperationID = @ReturnAccountOperationID)
			  BEGIN		  				  
				  INSERT INTO
				  dbo.Individual
				  (
					AccountOperationID,
					TitleCode,
					GivenName,
					Surname,
					PhoneNumber,
					MobileNumber,
					FaxNumber,
					EmailAddress,
					StreetAddress,
					Suburb,
					Postcode,
					StateCode,
					DateCreated,
					CreatedBySystemUserID,
					CreatedIPAddress,
					DateUpdated,
					UpdatedBySystemUserID,
					UpdatedIPAddress
				  )
			     select 
				    @ReturnAccountOperationID as AccountOperationID,
					cast(@TitleCodeID as varchar) as TitleCode,
					(case @GivenName when null then '-' when '' then '-' else @GivenName end) as GivenName,
					(case @Surname when null then 'not provided' when '' then 'not provided' else @Surname end) as Surname,
					(case isnull(@Phone, '') when '' then (case isnull(@Mobile, '') when '' then '(00) 0000 0000' else @Mobile end) else @Phone end) as PhoneNumber,
					(case isnull(@Mobile,  '') when '' then null else @Mobile end) as MobileNumber,
					(case isnull(@Fax,  '') when '' then null else @Fax end) as FaxNumber,
					(case isnull(@Email,  '') when '' then null else @Email end) as EmailAddress,
					(case isnull(@StreetAddress,  '') when '' then @StreetAddressSite else @StreetAddress end) as StreetAddress,
					(case isnull(@Suburb,  '') when '' then @SuburbSite else @Suburb end) as Suburb,
					(case isnull(@PostCode,  '') when '' then @PostCodeSite else @PostCode end) as PostCode,
					(case isnull(@StateCode,  '') when '' then @StateCodeSite else @StateCode end) as StateCode,
					getdate(),
					1,
					'',
					getdate() as DateUpdated,
					1 as UpdatedBySystemUserID,
					''
				  select @ReturnIndividualID = @@IDENTITY
			  END
			end
			else
			begin
			  --update action
			  update AccountOperation set AccountOperationPermit = cast(@InstrumentID as varchar), NSWLicenceFlag = 1
			  where AccountOperationRoleTypeID = 288 and SiteID = @SiteID and CustomerID = @CustomerID  
			end

			declare @RecordType2 bit
			select  @RecordType2 = [dbo].[ufn_PALMSTransporterRecordExist](@CustomerID, @SiteID)  
			if @RecordType2 = 0 -- Create transporter record in AccountOperation
			begin
			  --insert action
			      --1. Insert into AccountOperation: Transporter----------------------------
			      set @AccountOperationRoleTypeID = 290
				  INSERT INTO
				  dbo.AccountOperation
				  (
					CustomerID,
					SiteID,
					AccountOperationPermit,
					AccountOperationRoleTypeID,
					RegionCode,
					MaximumWasteTonnesPerYear,
					EmergencyContactPhoneNumber,
					ConsignmentAuthorisationCreateFlag,
					EffectiveDateFrom,
					EffectiveDateTo,
					DateCreated,
					CreatedBySystemUserID,
					CreatedIPAddress,
					DateUpdated,
					UpdatedBySystemUserID,
					UpdatedIPAddress,
					NSWLicenceFlag,
					ApprovalMultipleWasteCAFlag
				  )
				  select 
			        @CustomerID as CustomerID,
					@SiteID as SiteID,
					cast(@InstrumentID as varchar) as AccountOperationPermit,
					@AccountOperationRoleTypeID as AccountOperationRoleTypeID,
					null as RegionCode,
					null as MaximumWasteTonnesPerYear,
					(case isnull(@AfterHoursNumber,  '') when '' then (case isnull(@Phone, '') when '' then (case isnull(@Mobile, '') when '' then '(00) 0000 0000' else @Mobile end) else @Phone end) else @AfterHoursNumber end) as EmergencyContactPhoneNumber,
					0 as ConsignmentAuthorisationCreateFlag,
					getdate() as EffectiveDateFrom,
					null as EffectiveDateTo,
					getdate() as DateCreated,
					@CreatedBySystemUserID as CreatedBySystemUserID,
					'' as CreatedIPAddress,
					getdate() as DateUpdated,
					1 as UpdatedBySystemUserID,
					'' as UpdatedIPAddress,
					1 as NSWLicenceFlag,
					0 as ApprovalMultipleWasteCAFlag
			      select ReturnAccountOperationID = @@IDENTITY

				  --2. Insert into Individual: Transporter----------------------------------
				  IF NOT EXISTS(SELECT IndividualID from Individual where AccountOperationID = @ReturnAccountOperationID)
				  BEGIN				  				  				  
					  INSERT INTO
					  dbo.Individual
					  (
						AccountOperationID,
						TitleCode,
						GivenName,
						Surname,
						PhoneNumber,
						MobileNumber,
						FaxNumber,
						EmailAddress,
						StreetAddress,
						Suburb,
						Postcode,
						StateCode,
						DateCreated,
						CreatedBySystemUserID,
						CreatedIPAddress,
						DateUpdated,
						UpdatedBySystemUserID,
						UpdatedIPAddress
					  )
					 select 
						@ReturnAccountOperationID as AccountOperationID,
						cast(@TitleCodeID as varchar) as TitleCode,
						(case @GivenName when null then '-' when '' then '-' else @GivenName end) as GivenName,
						(case @Surname when null then 'not provided' when '' then 'not provided' else @Surname end) as Surname,
						(case isnull(@Phone, '') when '' then (case isnull(@Mobile, '') when '' then '(00) 0000 0000' else @Mobile end) else @Phone end) as PhoneNumber,
						(case isnull(@Mobile,  '') when '' then null else @Mobile end) as MobileNumber,
						(case isnull(@Fax,  '') when '' then null else @Fax end) as FaxNumber,
						(case isnull(@Email,  '') when '' then null else @Email end) as EmailAddress,
						(case isnull(@StreetAddress,  '') when '' then @StreetAddressSite else @StreetAddress end) as StreetAddress,
						(case isnull(@Suburb,  '') when '' then @SuburbSite else @Suburb end) as Suburb,
						(case isnull(@PostCode,  '') when '' then @PostCodeSite else @PostCode end) as PostCode,
						(case isnull(@StateCode,  '') when '' then @StateCodeSite else @StateCode end) as StateCode,
						getdate(),
						1,
						'',
						getdate() as DateUpdated,
						1 as UpdatedBySystemUserID,
						''
					  select @ReturnIndividualID = @@IDENTITY
				  END
			end
			else
			begin
			  --update action
			  update AccountOperation set AccountOperationPermit = cast(@InstrumentID as varchar), NSWLicenceFlag = 1
			  where AccountOperationRoleTypeID = 290 and SiteID = @SiteID and CustomerID = @CustomerID  
			end

			declare @RecordType3 bit
			select  @RecordType3 = [dbo].[ufn_PALMSReceiverRecordExist](@CustomerID, @SiteID)  
			if @RecordType3 = 0 -- Create receiver record in AccountOperation
			begin
			  --insert action
			      --1. Insert into AccountOperation: Receiver----------------------------
			      set @AccountOperationRoleTypeID = 289
				  INSERT INTO
				  dbo.AccountOperation
				  (
					CustomerID,
					SiteID,
					AccountOperationPermit,
					AccountOperationRoleTypeID,
					RegionCode,
					MaximumWasteTonnesPerYear,
					EmergencyContactPhoneNumber,
					ConsignmentAuthorisationCreateFlag,
					EffectiveDateFrom,
					EffectiveDateTo,
					DateCreated,
					CreatedBySystemUserID,
					CreatedIPAddress,
					DateUpdated,
					UpdatedBySystemUserID,
					UpdatedIPAddress,
					NSWLicenceFlag,
					ApprovalMultipleWasteCAFlag
				  )
				  select 
			        @CustomerID as CustomerID,
					@SiteID as SiteID,
					cast(@InstrumentID as varchar) as AccountOperationPermit,
					@AccountOperationRoleTypeID as AccountOperationRoleTypeID,
					null as RegionCode,
					null as MaximumWasteTonnesPerYear,
					(case isnull(@AfterHoursNumber,  '') when '' then (case isnull(@Phone, '') when '' then (case isnull(@Mobile, '') when '' then '(00) 0000 0000' else @Mobile end) else @Phone end) else @AfterHoursNumber end) as EmergencyContactPhoneNumber,
					0 as ConsignmentAuthorisationCreateFlag,
					getdate() as EffectiveDateFrom,
					null as EffectiveDateTo,
					getdate() as DateCreated,
					@CreatedBySystemUserID as CreatedBySystemUserID,
					'' as CreatedIPAddress,
					getdate() as DateUpdated,
					1 as UpdatedBySystemUserID,
					'' as UpdatedIPAddress,
					1 as NSWLicenceFlag,
					0 as ApprovalMultipleWasteCAFlag
			      select ReturnAccountOperationID = @@IDENTITY

				  --2. Insert into Individual: Receiver----------------------------------	
				  IF NOT EXISTS(SELECT IndividualID from Individual where AccountOperationID = @ReturnAccountOperationID)
				  BEGIN				  			  				  
					  INSERT INTO
					  dbo.Individual
					  (
						AccountOperationID,
						TitleCode,
						GivenName,
						Surname,
						PhoneNumber,
						MobileNumber,
						FaxNumber,
						EmailAddress,
						StreetAddress,
						Suburb,
						Postcode,
						StateCode,
						DateCreated,
						CreatedBySystemUserID,
						CreatedIPAddress,
						DateUpdated,
						UpdatedBySystemUserID,
						UpdatedIPAddress
					  )
					 select 
						@ReturnAccountOperationID as AccountOperationID,
						cast(@TitleCodeID as varchar) as TitleCode,
						(case @GivenName when null then '-' when '' then '-' else @GivenName end) as GivenName,
						(case @Surname when null then 'not provided' when '' then 'not provided' else @Surname end) as Surname,
						(case isnull(@Phone, '') when '' then (case isnull(@Mobile, '') when '' then '(00) 0000 0000' else @Mobile end) else @Phone end) as PhoneNumber,
						(case isnull(@Mobile,  '') when '' then null else @Mobile end) as MobileNumber,
						(case isnull(@Fax,  '') when '' then null else @Fax end) as FaxNumber,
						(case isnull(@Email,  '') when '' then null else @Email end) as EmailAddress,
						(case isnull(@StreetAddress,  '') when '' then @StreetAddressSite else @StreetAddress end) as StreetAddress,
						(case isnull(@Suburb,  '') when '' then @SuburbSite else @Suburb end) as Suburb,
						(case isnull(@PostCode,  '') when '' then @PostCodeSite else @PostCode end) as PostCode,
						(case isnull(@StateCode,  '') when '' then @StateCodeSite else @StateCode end) as StateCode,
						getdate(),
						1,
						'',
						getdate() as DateUpdated,
						1 as UpdatedBySystemUserID,
						''
					  select @ReturnIndividualID = @@IDENTITY
				  END
			end
			else
			begin
			  --update action
			  update AccountOperation set AccountOperationPermit = cast(@InstrumentID as varchar), NSWLicenceFlag = 1
			  where AccountOperationRoleTypeID = 289 and SiteID = @SiteID and CustomerID = @CustomerID  
			end
			 					 			 
			--COMMIT TRANSACTION 

