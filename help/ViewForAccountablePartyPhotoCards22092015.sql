        SELECT 
		I.InstrumentID,		
		(CASE WHEN A.CompanyFlag = 1 THEN A.OrganisationName ELSE A.GivenName + ' ' + A.Surname END) as Name,
		APP.Photo,
		(CASE WHEN A.CompanyFlag = 1 THEN null ELSE (CASE WHEN I.InstrumentTypeID = 817 then CONVERT(VARCHAR(11), A.DateOfBirth,106) WHEN I.InstrumentTypeID = 818 then CONVERT(VARCHAR(11), A.DateOfBirth,106) ELSE null END) END) as DateOfBirth, 
		(case I.InstrumentTypeID when 817 then DGDL.DriversLicenceNo
		                         when 818 then null
								 when 819 then DGDL.DriversLicenceNo
								 else '' end) as DriverLicence,
								 
		(case I.InstrumentTypeID when 817 then CONVERT(VARCHAR(11), DGL.ExpiryDate, 106)
		                         when 818 then CONVERT(VARCHAR(11), PL.ExpiryDate, 106)
								 when 819 then CONVERT(VARCHAR(11), DGL.ExpiryDate, 106)
								 else '' end) as ExpiryDate,											         							 
		(case I.InstrumentTypeID when 817 then CONVERT(VARCHAR(11), I.DateIssued, 106)
		                         when 818 then CONVERT(VARCHAR(11), I.DateIssued, 106)
								 when 819 then CONVERT(VARCHAR(11), I.DateIssued, 106)
								 else '' end) as DateOfIssue,
        
		(case I.InstrumentTypeID when 818 then [dbo].[ufn_GetPesticideLicenceClassTextAll](I.InstrumentID)  
		                         when 817 then DGDL.DriversLicenceClass
								 when 819 then DGDL.DriversLicenceClass
								 else '' end) as LicenceClass,

		(case I.InstrumentTypeID when 818 then [dbo].[ufn_GetPesticideLicenceClassText](I.InstrumentID, 1)  
		                         when 817 then DGDL.DriversLicenceClass
								 when 819 then DGDL.DriversLicenceClass
								 else '' end) as LicenceClassLine1,

		(case I.InstrumentTypeID when 818 then [dbo].[ufn_GetPesticideLicenceClassText](I.InstrumentID, 2)  
		                         when 817 then null
								 when 819 then null
								 else '' end) as LicenceClassLine2,
							
		(case I.InstrumentTypeID when 818 then [dbo].[ufn_GetPesticideLicenceClassText](I.InstrumentID, 3)  
		                         when 817 then null
								 when 819 then null
								 else '' end) as LicenceClassLine3,
								 
		(case I.InstrumentTypeID when 818 then [dbo].[ufn_GetPesticideLicenceClassText](I.InstrumentID, 4)  
		                         when 817 then null
								 when 819 then null
								 else '' end) as LicenceClassLine4,								 										 								  		
		 null as ConditionsLine1,
		 null as ConditionsLine2,
		 null as ConditionsLine3,
		 null as ConditionsLine4
		FROM tblAccountableParty A
			LEFT OUTER JOIN tblAddress ADDR ON ADDR.AddressID = A.AddressID
			LEFT OUTER JOIN tblInstrumentAccountableParty IAP ON IAP.AccountablePartyID = A.AccountablePartyID
			LEFT OUTER JOIN tblInstrument I ON I.InstrumentID = IAP.InstrumentID
			LEFT OUTER JOIN tblClassification C ON C.ClassificationID = I.InstrumentTypeID			 
			LEFT OUTER JOIN tblInstrumentAccountableParty IAPR ON IAPR.InstrumentAccountablePartyID = (SELECT MIN(IAPR1.InstrumentAccountablePartyID)
															FROM tblInstrumentAccountableParty IAPR1 WHERE IAPR1.InstrumentID = I.InstrumentID)
			LEFT OUTER JOIN tblAccountableParty APR ON APR.AccountablePartyID = IAPR.AccountablePartyID
			LEFT OUTER JOIN tblAccountablePartyPhoto APRP ON APR.AccountablePartyID = APRP.AccountablePartyID
			LEFT OUTER JOIN tblDGLicenceDriver DGDL ON I.InstrumentID = DGDL.InstrumentID	
			LEFT OUTER JOIN tblPesticideLicence PL ON I.InstrumentID = PL.InstrumentID	
			LEFT OUTER JOIN tblDGLicence DGL ON I.InstrumentID = DGL.InstrumentID	
			LEFT OUTER JOIN tblAccountablePartyPhoto APP ON A.AccountablePartyID = APP.AccountablePartyID	 
		WHERE I.InstrumentTypeID in (817, 818, 819)
		and (DGDL.PrintIDFlag = 1 OR PL.PrintIDFlag = 1)
		and (DGL.ExpiryDate is null OR PL.ExpiryDate is null or dateadd(week, 1, getdate()) <= DGL.ExpiryDate OR dateadd(week, 1, getdate()) <= PL.ExpiryDate)
		and IAPR.EffectiveDateTo is null
		and I.InstrumentStatusID = 755 
		and APP.Photo is not  null
		and dbo.ufn_HasActiveVariation(I.InstrumentID) = 0
		and dbo.ufn_HasActiveCorrection(I.InstrumentID) = 0