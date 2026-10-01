	select app.OnlineLicenceChangeApplicationID,
			app.AppNumber,
			app.ApplicationTypeID as ApplicationTypeId,
			app.AccountablePartyID as AccountablePartyId,
			app.NoticeInstrumentID as InstrumentId,
			app.AppXML,
			app.ElectronicSignatureSubmittedFlag,
			app.SignatureUploadedFlag,
			app.SignatureUploadedFileName,
			isnull(com.OrganisationName, com.GivenName+' '+com.Surname) as AccountableParty,
			p.Email as CreatorEmail,
			p.LastName as CreatorLastName,
			p.FirstName as CreatorFirstName,
			app.DateCreated,
			app.DateUpdated,
			app.ApplicationStatusID as ApplicationStatusId,
			app.DocumentUploadedFlag
	from tblOnlineLicenceChangeApplication app
			left outer join tblAccountableParty com on com.AccountablePartyID=app.AccountablePartyID
			left outer join vwProfile p on p.ProfileID=app.CreatedBySystemUserID
	where  app.ApplicationStatusID = 1703 AND (app.DocumentUploadedFlag = 0 or app.DocumentUploadedFlag is null) and app.ApplicationTypeID=1704 and app.NoticeInstrumentID  IS NOT NULL

	select * from tblOnlineLicenceChangeApplication where OnlineLicenceChangeApplicationID = 32

	select * from tblClassification where ClassificationID in (1701, 1702, 1703, 1704, 1705)


	select * from tblInstrumentCommunication where InstrumentID = 1536614

	select top 100 * from tblInstrumentCommunication  
	where UploadDocumentName is not null
	order by DateCreated desc