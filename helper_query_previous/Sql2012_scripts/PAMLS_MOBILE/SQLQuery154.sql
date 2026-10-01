	declare @AccountablePartyID INT
	declare @AccountablePartyName varchar(200)
	declare @ABN varchar(50)
	declare @TradingName varchar(200)
	
	set @AccountablePartyID = 0
	set @AccountablePartyName = 'BLUESCOPE STEEL'
	set @ABN = ''
	set @TradingName = ''

	SELECT DISTINCT
		b.[AccountablePartyID],		  
		b.[CompanyFlag],
		b.[OrganisationName],
		b.[TradingName],
		b.[ABN],
		b.[CompanyWebsite],
		b.[ContactRoleFlag],
		b.[TitleID],
		b.[Surname],
		b.[Middlename],
		b.[GivenName],
		b.[Position],
		b.[AddressID],
		b.[Phone],
		b.[Mobile],
		b.[AfterHoursNumber],
		b.[Fax],
		b.[Email],
		b.[Pager],
		b.[EffectiveDateFrom],
		b.[EffectiveDateTo],
		b.[DateCreated],
		b.[CreatedBySystemUserID],
		b.[DateUpdated],
		b.[UpdatedBySystemUserID],
		b.[RowTimestamp],
		b.[ACN],
		b.[DateOfBirth]			  
    from
	dbo.tblInstrumentAccountableParty  a 
	left outer join tblAccountableParty b on a.AccountablePartyID= b.AccountablePartyID
	left outer join tblInstrument c on a.InstrumentID = c.InstrumentID 		 
	left outer join tblPOEOLicenceFeeBasedActivity AS FeeBasedActivity ON c.InstrumentID = FeeBasedActivity.InstrumentID
	left outer join tblFeeBasedActivity FBA ON FBA.FeeBasedActivityID = FeeBasedActivity.FeeBasedActivityID
	left outer join tblFeeBasedActivityScale FeeScale ON FBA.FeeBasedActivityID = FeeScale.FeeBasedActivityID AND FeeBasedActivity.FeeBasedActivityScaleID = FeeScale.FeeBasedActivityScaleID
where     c.InstrumentTypeID = 493        --poeo licence type only
	and c.InstrumentStatusID = 3    --issued
	and FBA.PremisesFlag = 1        --premise flaghas to be true
	and b.AccountablePartyID = (case @AccountablePartyID when 0 then b.AccountablePartyID else @AccountablePartyID end)
	and isnull(b.[ABN], '') like (case @ABN when '' then isnull(b.[ABN], '') else '%' + @ABN + '%' end)
	and isnull(b.[TradingName], '') like (case @TradingName when '' then isnull(b.[TradingName], '') else '%' + @TradingName + '%' end)
	and ((b.OrganisationName like '%' + @AccountablePartyName + '%') OR
	(Rtrim(Ltrim(isnull(b.GivenName, '') + ' ' + (case isnull(b.Middlename, '') when '' then '' else b.Middlename + ' ' end) + isnull(b.Surname, '')))) like '%' + @AccountablePartyName + '%')
