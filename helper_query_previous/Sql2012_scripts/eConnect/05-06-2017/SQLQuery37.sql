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
			app.ApplicationStatusID as ApplicationStatusId
	from tblOnlineLicenceChangeApplication app
			left outer join tblAccountableParty com on com.AccountablePartyID=app.AccountablePartyID
			left outer join vwProfile p on p.ProfileID=app.CreatedBySystemUserID
	where  app.ApplicationStatusID = 1703 AND (app.DocumentUploadedFlag = 0 or app.DocumentUploadedFlag is null) and app.ApplicationTypeID=1704 and app.NoticeInstrumentID  IS NOT NULL


		select * from tblClassification where ClassificationID in (1400, 1600, 1700)
		select * from tblClassification where ClassificationDomainID = 128


		select * from tblOnlineLicenceChangeApplication where OnlineLicenceChangeApplicationid = 32

		select * from tblInstrumentCommunication where InstrumentID = 1536614


		--s.jpg|EC4d54f8a9-11cc-|EC4d54f8a9-11cc-


		--SignatureLinkClickedReachPage.jpg|EC4d54f8a9-11cc-4e40-8f18-9d8ae681ccd7.jpg