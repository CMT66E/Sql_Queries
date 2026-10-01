declare  @LicenceNo INT= 13087
 
declare  @ContactXML XML = 
'
<DataContact>
  <tblAddress>
    <AddressID>137213</AddressID>
    <PrefixAddress />
    <Address>67 More Ave</Address>
    <Suburb>BURWOOD|2134|NSW</Suburb>
    <Postcode>0</Postcode>
    <StateCode />
    <CreatedBySystemUserID>1</CreatedBySystemUserID>
    <UpdatedBySystemUserID>1</UpdatedBySystemUserID>
    <OverseasAddressFlag>false</OverseasAddressFlag>
    <RowTimestamp>AAAAACpoRWM=</RowTimestamp>
  </tblAddress>
  <tblContact>
    <ContactID>101427</ContactID>
    <TitleID>0</TitleID>
    <Surname>BBBBBBBBBBBBBBB</Surname>
    <MiddleName />
    <GivenName>AAAAAAAAAAAAAAA</GivenName>
    <OrganisationName />
    <Position />
    <Phone />
    <Mobile />
    <AfterHoursNumber />
    <Fax />
    <Email>ww@gmail.com</Email>
    <Pager />
    <CreatedBySystemUserID>1</CreatedBySystemUserID>
    <UpdatedBySystemUserID>1</UpdatedBySystemUserID>
    <RowTimestamp>AAAAACpoRWQ=</RowTimestamp>
    <PostalContactFlag>false</PostalContactFlag>
    <EmailContactFlag>true</EmailContactFlag>
  </tblContact>
</DataContact>
'
declare  @Action VARCHAR(5) = 'U'

DECLARE @ContactID INT = 0
DECLARE @PostalContactFlag BIT = 0
	DECLARE @EmailContactFlag BIT = 0
	
		SELECT
		        @ContactID = xmlVals.rowvals.query('ContactID').value('.','int'),
    			@PostalContactFlag = xmlVals.rowvals.query('PostalContactFlag').value('.','bit'),
				@EmailContactFlag = xmlVals.rowvals.query('EmailContactFlag').value('.','bit')
			FROM @ContactXML.nodes('//DataContact/tblContact') as xmlVals(rowvals)

print '@PostalContactFlag=' + cast(@PostalContactFlag as varchar)
print '@EmailContactFlag=' + cast(@EmailContactFlag as varchar)

	BEGIN TRY
		BEGIN TRAN A

		SELECT
		    @ContactID = xmlVals.rowvals.query('ContactID').value('.','int'),
    		@PostalContactFlag = xmlVals.rowvals.query('PostalContactFlag').value('.','bit'),
			@EmailContactFlag = xmlVals.rowvals.query('EmailContactFlag').value('.','bit')
		FROM @ContactXML.nodes('//DataContact/tblContact') as xmlVals(rowvals)


		IF @Action = 'U'
		BEGIN
		     EXEC [dbo].[uspContactService_UpdateContact] @ContactXML

			 update tblInstrumentContact
			 set EmailContactFlag = @EmailContactFlag
			 where InstrumentID = @LicenceNo and ContactID = @ContactID 
		END

	
		IF @Action = 'A'
		BEGIN
		 DECLARE @Result INT
		 EXEC [dbo].[uspContactService_AddContact] @ContactXML, @Result output 

		 IF @Result > 0
		 BEGIN
				

				INSERT INTO tblInstrumentContact(
									 InstrumentID,
									 ContactID,
									 PostalContactFlag,
									 EmailContactFlag,
									 DateCreated,
									 CreatedBySystemUserID)
					SELECT 			 @LicenceNo,
									 @Result,
									 @PostalContactFlag,
									 @EmailContactFlag,
									 GetDate(),
									 1

		 END
		END

		IF @Action = 'D'
		BEGIN
			

			SELECT
    			@ContactId = xmlVals.rowvals.query('ContactID').value('.','int')
			FROM @ContactXML.nodes('//DataContact/tblContact') as xmlVals(rowvals)


			--IF NOT Exists(Select InstrumentID from tblInstrumentContact 
			--			Where ContactID = @ContactID and InstrumentID <> @LicenceNo )
			--	Begin
			--		Delete from tblContact Where ContactID = @ContactID
					
			--	End

			DELETE FROM tblInstrumentContact WHERE InstrumentID = @LicenceNo and ContactID = @ContactID
		END

	


	--	---------- extract data from xml parameter

	--	SELECT  
	--			@ContactID = p.value('(./Id)[1]','int'),
	--			@TitleId = p.value('(./TitleId)[1]','int'),
	--			@GivenName = p.value('(./GivenName)[1]','varchar(60)'),
	--			@Surname = p.value('(./Surname)[1]','varchar(60)'),
	--			@MiddleName = p.value('(./MiddleName)[1]','varchar(60)'),
	--			@OrganizationName = p.value('(./OrganizationName)[1]','varchar(60)'),
	--			@Position = p.value('(./Position)[1]','varchar(128)'),
	--			@Address = p.value('(./Address)[1]','varchar(128)'),
	--			@Suburb = p.value('(./Suburb)[1]','varchar(50)'),
	--			@StateCode = p.value('(./State)[1]','varchar(20)'),
	--			@Postcode = cast(p.value('(./Postcode)[1]','int') as varchar(10)),
	--			@Phone = p.value('(./Phone)[1]','varchar(20)'),
	--			@AfterHoursNumber = p.value('(./AfterHoursNumber)[1]','varchar(20)'), 
	--			@Mobile = p.value('(./Mobile)[1]','varchar(20)'),
	--			@EmailAddress = p.value('(./Email)[1]','varchar(128)'),
	--			@Fax = p.value('(./Fax)[1]','varchar(20)'),
	--			@Pager = p.value('(./Pager)[1]','varchar(20)'),				 
	--			@OverseasAddressFlag = p.value('(./IsOverseasAddr)[1]','bit'),				
	--			@PrefixAddress = p.value('(./Prefix)[1]','varchar(100)'),
	--			@Country = p.value('(./Country)[1]','varchar(100)'),
	--			@PostalContactFlag = p.value('(./PostalContactFlag)[1]','bit'),
	--			@EmailContactFlag = p.value('(./EmailContactFlag)[1]','bit'),
	--			@Action =  p.value('(./Action)[1]','varchar(10)')
	--	FROM @ContactXML.nodes('/VarContact') t(p)


	--	--IF @Action = 'U'
	--	--BEGIN
			
	--	--END










		/*



		--There are two situations we need to handle
		--1 add new contact which @ContactID = 0
		--2 update existing contact which @ContactID > 0
		IF @ContactID = 0
		BEGIN
		   --adding new contact
		   --1. insert into tblAddress

		   --2. insert into tblContact
		   print  'need to do'
		   --3. insert into tblInstrumentContact
		END 

		IF @ContactID > 0
		BEGIN
		   --update existing contact
		   declare @TempAddressID int = 0
		   select @TempAddressID = AddressID from tblContact where ContactID = @ContactID

		   --1. update tblAddress
		   update tblAddress set 
		   [Address] = @Address,
		   Suburb = @Suburb,
		   Postcode = @Postcode,
		   StateCode = @StateCode,
		   OverseasAddressFlag = @OverseasAddressFlag,
		   Country = @Country,
		   PrefixAddress = @PrefixAddress,
		   DateUpdated = getdate(),
		   UpdatedBySystemUserID = 1
		   where AddressID = @TempAddressID
		   --2. update tblContact
		   update tblContact set 
		   TitleID = @TitleId,
		   Surname = @Surname,
		   GivenName = @GivenName,
		   MiddleName = @MiddleName,
		   OrganisationName = @OrganizationName,
		   Position = @Position,
		   Phone = @Phone,
		   Mobile = @Mobile,
		   AfterHoursNumber = @AfterHoursNumber,
		   Fax = @Fax,
		   Email = @EmailAddress,
		   Pager = @Pager

		   where ContactID = @ContactID and AddressID = @TempAddressID
		   --3. update tblInstrumentContact
		   update tblInstrumentContact set 
		   PostalContactFlag = @PostalContactFlag,
		   EmailContactFlag = @EmailContactFlag,
		   DateUpdated = getdate(),
		   UpdatedBySystemUserID = 1
		   where InstrumentID =  @LicenceNo and ContactID = @ContactID
		END 

		IF @PostalContactFlag = 1 --we only allow one postal contact under the same licence
		BEGIN
		    --if the end user set this contact to be postal contact then we should remove existing postal contact  before we set this up
			SELECT	@PostalContactID = A.ContactID
			FROM tblInstrumentContact A INNER JOIN tblContact B
				ON A.ContactID = B.ContactID INNER JOIN tblAddress C
				ON B.AddressID = C.AddressID 
			WHERE InstrumentID = @LicenceNo AND  A.PostalContactFlag = 1
		END

		SELECT	@EmailContactID = A.ContactID
		FROM tblInstrumentContact A INNER JOIN tblContact B
			ON A.ContactID = B.ContactID INNER JOIN tblAddress C
			ON B.AddressID = C.AddressID 
		WHERE InstrumentID = @LicenceNo AND  A.EmailContactFlag = 1

		SELECT	@AddressID = B.AddressID
		FROM tblInstrumentContact A INNER JOIN tblContact B
			ON A.ContactID = B.ContactID INNER JOIN tblAddress C
			ON B.AddressID = C.AddressID 
		WHERE InstrumentID = @LicenceNo AND  A.PostalContactFlag = 1
 

		BEGIN TRAN A
		
		----------------------update address and contact tables------------------
		UPDATE tblAddress
		SET Address = @Address,
			Suburb = @Suburb,
			StateCode = @StateCode,
			Postcode = cast(@Postcode as varchar(10)),
			OverseasAddressFlag = @OverseasAddressFlag,
			PrefixAddress = @PrefixAddress,
			Country=@Country
		WHERE AddressID = @AddressID

		UPDATE tblContact
		SET Phone = @Phone
		WHERE ContactID = @PostalContactID
		
		UPDATE tblContact
		SET Email = @EmailAddress
		WHERE ContactID = @EmailContactID

		
		-------------- update accountable party ------------------
		SELECT @AddressID = 0
		SELECT	@AddressID = B.AddressID
		FROM tblInstrumentAccountableParty A INNER JOIN tblAccountableParty B
			ON A.AccountablePartyID = B.AccountablePartyID INNER JOIN tblAddress C
			ON B.AddressID = C.AddressID 
		WHERE InstrumentID = @LicenceNo

		IF @AddressID > 0
		BEGIN
			UPDATE tblAddress
			SET [Address] = @Address,
				Suburb = @Suburb,
				StateCode = @StateCode,
				Postcode = cast(@Postcode as varchar(10)),
				OverseasAddressFlag = @OverseasAddressFlag,
				PrefixAddress = @PrefixAddress,
				Country=@Country
			WHERE AddressID = @AddressID
		END

		DECLARE @AccountablePartyID INT

		SELECT	@AccountablePartyID = A.AccountablePartyID
		FROM tblInstrumentAccountableParty A INNER JOIN tblAccountableParty B
			ON A.AccountablePartyID = B.AccountablePartyID
		WHERE A.InstrumentID = @LicenceNo 

		UPDATE tblAccountableParty
		SET Email = @EmailAddress,
			Phone = @Phone
		WHERE AccountablePartyID = @AccountablePartyID
		
		select @ret as Temp
		----------------------------------------------------
		 
		 */

		COMMIT TRAN A
		
	END TRY
	BEGIN CATCH
		DECLARE @ErrorMessage VARCHAR(2000)	
		ROLLBACK TRAN A	
		SET @ErrorMessage = dbo.ufnGetErrorText()	
		RAISERROR (@ErrorMessage , 16, 1)
	END CATCH    