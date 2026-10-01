declare @xmlAccountableParty XML
declare @ABNExists int
declare @AddressExists int 
declare @AccountablePartyIDOut int 	

set @xmlAccountableParty = 
'
<DataAccountableParty>
  <ValidateIndividual>
    <FirstName>James</FirstName>
    <LastName>Bond</LastName>
    <Address>9 Diamond Road</Address>
    <Suburb>Burwood</Suburb>
    <Postcode>2134</Postcode>
    <StateCode>NSW</StateCode>
  </ValidateIndividual>
</DataAccountableParty>
'

Declare @AccountablePartyId int,
			@ABN varchar(14),
			@FirstName varchar(60),
			@LastName varchar(60),
			@Address varchar(100),
			@StateCode Char(3),
			@Postcode char(4),
			@Suburb Varchar(50)
			
	SELECT	@AccountablePartyID = xmlVals.rowvals.query('AccountablePartyId').value('.','INT'),
			@ABN = xmlVals.rowvals.query('ABN').value('.','VARCHAR(14)'),
			@FirstName = xmlVals.rowvals.query('FirstName').value('.','VARCHAR(60)'),
			@LastName = xmlVals.rowvals.query('LastName').value('.','VARCHAR(60)'),
			@Address = xmlVals.rowvals.query('Address').value('.','VARCHAR(100)'),
			@StateCode = xmlVals.rowvals.query('StateCode').value('.','VARCHAR(3)'),
			@Postcode = xmlVals.rowvals.query('Postcode').value('.','VARCHAR(4)'),
			@Suburb = xmlVals.rowvals.query('Suburb').value('.','VARCHAR(50)')								
	From @xmlAccountableParty.nodes('//DataAccountableParty/ValidateIndividual') as xmlVals(rowvals)



        IF(@AccountablePartyId IS NULL OR @AccountablePartyId = 0)
			Begin
				IF(@ABN IS NOT NULL AND @ABN<>'')
					Begin
						IF EXISTS(Select ABN from tblAccountableParty Where ABN = @ABN and CompanyFlag=1)
							Begin
								Set @ABNExists= 1;
								select @AccountablePartyIDOut = AccountablePartyID from tblAccountableParty Where ABN = @ABN and CompanyFlag=1
							End
						ELSE
							SET @ABNExists = 0;	
					End
				ELSE
					SET @ABNExists = 0;
				
				print '@AccountablePartyID='+ cast(@AccountablePartyID as varchar)
				print '@@FirstName='+ cast(@FirstName as varchar)
				print '@@LastName='+ cast(@LastName as varchar)
				print '@@Address='+ cast(@Address as varchar)
				print '@@Suburb='+ cast(@Suburb as varchar)
				print '@@StateCode='+ cast(@StateCode as varchar)
				print '@@Postcode='+ cast(@Postcode as varchar)

--Select AccountablePartyID from tblAccountableParty INNER JOIN tblAddress a ON
--										tblAccountableParty.AddressID = a.AddressID
--									Where GivenName = @FirstName AND
--											Surname = @LastName AND
--											a.[Address] = @Address AND
--											a.Suburb = @Suburb AND
--											a.StateCode = @StateCode AND
--											a.Postcode = @Postcode

				--IF((@FirstName IS NOT NULL AND @FirstName <>'') AND 
				--	@LastName IS NOT NULL AND @LastName <>'')
				--	BEGIN
				--		IF EXISTS(Select AccountablePartyID from tblAccountableParty INNER JOIN tblAddress a ON
				--						tblAccountableParty.AddressID = a.AddressID
				--					Where GivenName = @FirstName AND
				--							Surname = @LastName AND
				--							a.[Address] = @Address AND
				--							a.Suburb = @Suburb AND
				--							a.StateCode = @StateCode AND
				--							a.Postcode = @Postcode)
				--			Begin
				--				Set @AddressExists= 1;
				--				select @AccountablePartyIDOut = AccountablePartyID from tblAccountableParty INNER JOIN tblAddress a ON
				--						tblAccountableParty.AddressID = a.AddressID
				--				Where GivenName = @FirstName AND
				--						  Surname = @LastName AND
				--						  a.[Address] = @Address AND
				--						  a.Suburb = @Suburb AND
				--						  a.StateCode = @StateCode AND
				--						  a.Postcode = @Postcode
				--			End
				--		ELSE
				--			SET @AddressExists = 0;						
				--	END
				--ELSE
				--	SET @AddressExists =0;
			End	
		Else
			Begin
				IF(@ABN IS NOT NULL AND @ABN<>'')
					Begin
						IF EXISTS(Select ABN from tblAccountableParty Where ABN = @ABN AND AccountablePartyID <> @AccountablePartyId and CompanyFlag = 1)
							Begin
								Set @ABNExists= 1;
								select @AccountablePartyIDOut = AccountablePartyID from tblAccountableParty Where ABN = @ABN AND AccountablePartyID <> @AccountablePartyId and CompanyFlag = 1
							End	
						ELSE
							SET @ABNExists = 0;	
					END
				ELSE
					SET @ABNExists = 0;
					
				IF((@FirstName IS NOT NULL AND @FirstName <>'') AND 
					@LastName IS NOT NULL AND @LastName <>'')
					BEGIN	
						IF EXISTS(Select AccountablePartyID from tblAccountableParty INNER JOIN tblAddress a ON
										tblAccountableParty.AddressID = a.AddressID
									Where  AccountablePartyId <> @AccountablePartyId AND GivenName = @FirstName AND
											Surname = @LastName AND
											a.[Address] = @Address AND
											a.Suburb = @Suburb AND
											a.StateCode = @StateCode AND
											a.Postcode = @Postcode)
							Begin
								Set @AddressExists= 1;
								select @AccountablePartyIDOut = AccountablePartyID from tblAccountableParty INNER JOIN tblAddress a ON
										tblAccountableParty.AddressID = a.AddressID
								Where  AccountablePartyId <> @AccountablePartyId AND GivenName = @FirstName AND
											Surname = @LastName AND
											a.[Address] = @Address AND
											a.Suburb = @Suburb AND
											a.StateCode = @StateCode AND
											a.Postcode = @Postcode
							End
						ELSE
							SET @AddressExists = 0;	
					END
				ELSE
					SET @AddressExists =0;
			End	


print '@@ABNExists='+ cast(@ABNExists as varchar)
print '@@AddressExists='+ cast(@AddressExists as varchar)