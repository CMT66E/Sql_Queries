		SELECT app.OnlineTLApplicationID as OnlineTLApplicationId, 
			app.TLApplicationNumber ,
			app.OnlineApplicationCodeID AS OnlineApplicationCodeId,
			code.ApplicationCode,
			app.ApplicationStatusId,
			app.PaymentTypeID AS PaymentTypeId,
			convert(decimal(12,2),app.AdminFee) AS AdminFee,
			app.CreditCardPaymentDate,
			app.CreditCardPaymentReceiptNo,
			--app.UploadedSignatureDocument AS UploadedSignatureDocument,
			app.ElectronicSignatureSubmittedFlag,
			app.LicenceXML, 
			app.DateCreated ,
			app.DateUpdated ,
			app.ReasonForStatusChanged,
			app.CreditCardPaymentConfirmedFlag,
		    app.DateStatusChanged,
			app.RowTimestamp
			FROM tblOnlineApplicationCode code   
			left outer join tblOnlineTLApplication app ON (code.OnlineApplicationCodeID = app.OnlineApplicationCodeID) 
			WHERE DATALENGTH(app.LicenceXML) > 0


			SELECT *
			FROM tblOnlineApplicationCode code   
			left outer join tblOnlineTLApplication app ON (code.OnlineApplicationCodeID = app.OnlineApplicationCodeID) 
			WHERE DATALENGTH(app.LicenceXML) > 0 and app.OnlineTLApplicationID = 297

			select top 10 * from tblPesticideLicence order by DateCreated desc

			--with applicationCode = 'FJD972' OnlineTLApplicationID = 297
			declare @InstrumentID int = 5068246
			select * from tblPesticideLicence where InstrumentID = @InstrumentID
			select * from tblInstrument where InstrumentID = @InstrumentID 
			select * from tblInstrumentAccountableParty where InstrumentID = @InstrumentID 
			select * from tblAccountableParty where AccountablePartyID = (select AccountablePartyID from tblInstrumentAccountableParty where InstrumentID = @InstrumentID)
			select * from tblRadiationLicenceFitAndProper where InstrumentID = @InstrumentID 
			select * from tblPesticideLicenceClass WHERE InstrumentID = @InstrumentID

			select * from tblInstrumentContact where InstrumentID = @InstrumentID
			select * from tblContact where ContactID in (select ContactID from tblInstrumentContact where InstrumentID = @InstrumentID)
			select * from tblAddress where AddressID in (select AddressID from tblContact where ContactID in (select ContactID from tblInstrumentContact where InstrumentID = @InstrumentID))


