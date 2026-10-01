			SELECT 	  
					OWTAccountableParty.[InstrumentID]
					,OWTAccountableParty.[AccountablePartyID] 
					,(CASE WHEN b.CompanyFlag = 1 THEN b.OrganisationName ELSE isnull(b.GivenName, '') + case isnull(b.Middlename, '') when '' then '' else b.Middlename + ' ' end + isnull(b.Surname, '') END) as TradingName					 
					,(case isnull(ABN, '') when '' then 'n/a' else ABN end) as ACN_ARBN
					,(case isnull(b.[EffectiveDateTo], '') when '' then 1 else 0 end) as ActiveFlag
					,isnull((select [Address] from tblAddress where AddressID = CASE WHEN b.CompanyFlag = 1 THEN d.AddressID ELSE b.AddressID END), '') as StreetAddress
					,isnull((select isnull([Suburb], '') from tblAddress where AddressID = CASE WHEN b.CompanyFlag = 1 THEN d.AddressID ELSE b.AddressID END), '') as Suburb
					,isnull((select isnull([Postcode], '') from tblAddress where AddressID = CASE WHEN b.CompanyFlag = 1 THEN d.AddressID ELSE b.AddressID END), '') as Postcode
					,isnull((select isnull([StateCode], '') from tblAddress where AddressID = CASE WHEN b.CompanyFlag = 1 THEN d.AddressID ELSE b.AddressID END), '') as StateCode
					, 0 as OldAccountablePartyFlag
			FROM [dbo].[tblInstrumentAccountableParty] as OWTAccountableParty
			inner join tblAccountableParty b on OWTAccountableParty.AccountablePartyID = b.AccountablePartyID
			left outer join tblInstrumentContact c on OWTAccountableParty.InstrumentID = c.InstrumentID
			left outer join tblContact d on c.ContactID = d.ContactID
			WHERE OWTAccountableParty.InstrumentID = 6257 and c.PostalContactFlag = 1 and b.[EffectiveDateTo] is null