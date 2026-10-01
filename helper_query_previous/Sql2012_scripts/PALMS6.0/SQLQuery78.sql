declare @xmlAccountableParty XML
declare @ContactID int  
declare @AccountablePartyID int 
declare @AddressID int 

set @xmlAccountableParty = 
'
<DataAccountableParty>
  <tblAddress>
    <AddressID>0</AddressID>
    <Address>9 Diamond Road</Address>
    <Suburb>Burwood</Suburb>
    <Postcode>2134</Postcode>
    <StateCode>NSW</StateCode>
    <CreatedBySystemUserID>1399</CreatedBySystemUserID>
    <UpdatedBySystemUserID>1399</UpdatedBySystemUserID>
    <OverseasAddressFlag>false</OverseasAddressFlag>
  </tblAddress>
  <tblAccountableParty>
    <AccountablePartyID>0</AccountablePartyID>
    <CompanyFlag>false</CompanyFlag>
    <ContactRoleFlag>false</ContactRoleFlag>
    <TitleID>0</TitleID>
    <Surname>Bond</Surname>
    <MiddleName>K</MiddleName>
    <GivenName>James</GivenName>
    <Position>CEO</Position>
    <Phone>0298789890</Phone>
    <Mobile>0402778899</Mobile>
    <Email>james@killing.com.au</Email>
    <CreatedBySystemUserID>1399</CreatedBySystemUserID>
    <UpdatedBySystemUserID>1399</UpdatedBySystemUserID>
  </tblAccountableParty>
</DataAccountableParty>
'

        DECLARE @isContact as BIT = 0	
		
		SET @isContact = (SELECT xmlVals.rowvals.query('ContactRoleFlag').value('.','BIT') From @xmlAccountableParty.nodes('//DataAccountableParty/tblAccountableParty') as xmlVals(rowvals))
		BEGIN TRAN
			Insert Into dbo.tblAddress
			(
				[Address],
				Suburb,
				Postcode,
				StateCode,
				CreatedBySystemUserID,
				DateCreated,
				PrefixAddress,
				Country,
				OverseasAddressFlag
			)
			SELECT 
				xmlVals.rowvals.value('(Address)[1]','VARCHAR(100)'), 
				xmlVals.rowvals.value('(Suburb)[1]','VARCHAR(50)'), 
				xmlVals.rowvals.value('(Postcode)[1]','VARCHAR(10)'),
				xmlVals.rowvals.value('(StateCode)[1]','VARCHAR(20)'), 
				xmlVals.rowvals.value('(CreatedBySystemUserID)[1]','INT'),
				GETDATE(),
				xmlVals.rowvals.value('(PrefixAddress)[1]','VARCHAR(100)') as PrefixAddress, 
				xmlVals.rowvals.value('(Country)[1]','VARCHAR(100)') as Country, 
				xmlVals.rowvals.value('(OverseasAddressFlag)[1]','BIT') as OverseasAddressFlag
				From @xmlAccountableParty.nodes('//DataAccountableParty/tblAddress') as xmlVals(rowvals)
				
			SET @AddressId = @@IDENTITY
					
			Insert Into dbo.tblAccountableParty
				(
					CompanyFlag,
					ContactRoleFlag,
					TradingName,
					TitleID,
					GivenName,
					MiddleName,
					Surname,
					AddressID,
					Position,
					Phone,
					Mobile,
					AfterHoursNumber,
					Fax,
					Email,
					Pager,
					ABN,
					ACN,
					DateOfBirth,
					CreatedBySystemUserID,
					DateCreated,
					EffectiveDateFrom
				)			
				SELECT
					xmlVals.rowvals.value('(CompanyFlag)[1]','BIT'), 
					xmlVals.rowvals.query('ContactRoleFlag').value('.','BIT'), 
					xmlVals.rowvals.value('(TradingName)[1]','VARCHAR(128)'),
					xmlVals.rowvals.value('(TitleID)[1]','INT'), 
					xmlVals.rowvals.value('(GivenName)[1]','VARCHAR(60)'), 
					xmlVals.rowvals.value('(MiddleName)[1]','VARCHAR(60)'), 
					xmlVals.rowvals.value('(Surname)[1]','VARCHAR(60)'), 
					@AddressID,
					xmlVals.rowvals.value('(Position)[1]','VARCHAR(128)'),
					xmlVals.rowvals.value('(Phone)[1]','VARCHAR(20)'), 
					xmlVals.rowvals.value('(Mobile)[1]','VARCHAR(20)'), 
					xmlVals.rowvals.value('(AfterHoursNumber)[1]','VARCHAR(20)'), 
					xmlVals.rowvals.value('(Fax)[1]','VARCHAR(20)'), 
					xmlVals.rowvals.value('(Email)[1]','VARCHAR(128)'), 
					xmlVals.rowvals.value('(Pager)[1]','VARCHAR(20)'), 
					xmlVals.rowvals.value('(ABN)[1]','VARCHAR(14)'), 
					xmlVals.rowvals.value('(ACN)[1]','VARCHAR(20)'), 
					DATEADD(day,1,xmlVals.rowvals.value('(DateOfBirth)[1]','date')), 
					xmlVals.rowvals.value('(CreatedBySystemUserID)[1]','int'),
					GETDATE(),
					GETDATE()
					From @xmlAccountableParty.nodes('//DataAccountableParty/tblAccountableParty') as xmlVals(rowvals)
			
			Set @AccountablePartyID = @@IDENTITY	
			
			--The following lines added by Eric He 25-10-2011 we need write log into newly created table: tblAccountablePartyAuditLog						
			Declare @CreatedBySystemUserID INT = 0
			SET	@CreatedBySystemUserID = (Select xmlVals.rowvals.value('(CreatedBySystemUserID)[1]','INT') From @xmlAccountableParty.nodes('//DataAccountableParty/tblAccountableParty') as xmlVals(rowvals))
		    			
			Declare @NewUserName Varchar(400)			
			Select @NewUserName = (Surname + ' ' + GivenName + N' (' + [Login] + N')')
			From tblSystemUser
			Where [SystemUserID] = @CreatedBySystemUserID	
			
			DECLARE @AuditLogMsg varchar(400)
			DECLARE @AuditLogMsgDesc varchar(400)	
			SELECT @AuditLogMsg = 'Record creation'				
			SELECT @AuditLogMsgDesc = N' Accountable party created by ' +@NewUserName +'.'
			
			DECLARE @RtnVal int			
			SELECT @RtnVal = 0
			EXEC @RtnVal = uspAccountablePartyAuditLogInsert @AccountablePartyID,@AuditLogMsg,@AuditLogMsgDesc,@CreatedBySystemUserID,null				 
			--End of start line 61				
			
			
			IF(@isContact = 1)
				Begin
					Declare @ContactAddressID AS INT
					
					Insert Into dbo.tblAddress
					(
						[Address],
						Suburb,
						Postcode,
						StateCode,
						CreatedBySystemUserID,
						DateCreated,
						PrefixAddress,
						Country,
						OverseasAddressFlag
					)
					SELECT 
						xmlVals.rowvals.value('(Address)[1]','VARCHAR(100)'), 
						xmlVals.rowvals.value('(Suburb)[1]','VARCHAR(50)'), 
						xmlVals.rowvals.value('(Postcode)[1]','VARCHAR(4)'),
						xmlVals.rowvals.value('(StateCode)[1]','VARCHAR(3)'), 
						xmlVals.rowvals.value('(CreatedBySystemUserID)[1]','INT'),
						GETDATE(),
						xmlVals.rowvals.value('(PrefixAddress)[1]','VARCHAR(100)') as PrefixAddress, 
						xmlVals.rowvals.value('(Country)[1]','VARCHAR(100)') as Country, 
						xmlVals.rowvals.value('(OverseasAddressFlag)[1]','BIT') as OverseasAddressFlag
					From @xmlAccountableParty.nodes('//DataAccountableParty/tblAddress') as xmlVals(rowvals)
						
					SET @ContactAddressID = @@IDENTITY
					
					Insert into tblContact
					(
						TitleID,
						GivenName,
						MiddleName,
						Surname,
						OrganisationName,
						Position,
						AddressID,
						Phone,
						Mobile,
						AfterHoursNumber,
						Fax,
						Email,
						Pager,
						EffectiveDateFrom,
						DateCreated,
						CreatedBySystemUserID
					)						
					SELECT
						xmlVals.rowvals.value('(TitleID)[1]','INT'), 
						xmlVals.rowvals.value('(GivenName)[1]','VARCHAR(60)'), 
						xmlVals.rowvals.value('(MiddleName)[1]','VARCHAR(60)'), 
						xmlVals.rowvals.value('(Surname)[1]','VARCHAR(60)'), 
						xmlVals.rowvals.value('(TradingName)[1]','VARCHAR(128)'),
						xmlVals.rowvals.value('(Position)[1]','VARCHAR(128)'),
						@ContactAddressID,							
						xmlVals.rowvals.value('(Phone)[1]','VARCHAR(20)'), 
						xmlVals.rowvals.value('(Mobile)[1]','VARCHAR(20)'), 
						xmlVals.rowvals.value('(AfterHoursNumber)[1]','VARCHAR(20)'), 
						xmlVals.rowvals.value('(Fax)[1]','VARCHAR(20)'), 
						xmlVals.rowvals.value('(Email)[1]','VARCHAR(128)'), 
						xmlVals.rowvals.value('(Pager)[1]','VARCHAR(20)'),
						GETDATE(),
						GETDATE(),
						xmlVals.rowvals.value('(CreatedBySystemUserID)[1]','int')
						From @xmlAccountableParty.nodes('//DataAccountableParty/tblContact') as xmlVals(rowvals)
			
						Set @ContactId = @@IDENTITY
					End
				ELSE
					Set @ContactId = 0


select @ContactID as ContactID
select @AccountablePartyID as AccountablePartyID 
select @AddressID as AddressID