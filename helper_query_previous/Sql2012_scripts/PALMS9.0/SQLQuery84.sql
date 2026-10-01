SELECT  COUNT(A.InstrumentID) 
	FROM tblDGLicence A LEFT OUTER JOIN tblInstrument B
	ON A.InstrumentID = B.InstrumentID
	WHERE 
	--A.DGLicenceTypeID = 819 
	--AND 
	--B.InstrumentStatusID = 755 
	--AND 
	A.InstrumentID = 5020559


	SELECT  B.EmailAddress FROM tblOnlineApplicationCode A INNER JOIN tblOnlineApplicant B
		ON A.OnlineApplicantID = B.OnlineApplicantID
	WHERE A.ApplicationCode = 'YAS987'

	SELECT *
	FROM tblInstrumentContact A INNER JOIN tblContact B
			ON A.ContactID = B.ContactID
	WHERE InstrumentID = 5050763 
	AND (B.Email IS NOT NULL AND B.Email = 'michael.wu@environment.nsw.gov.au') 
	AND A.EmailContactFlag = 1

	update tblInstrumentContact set EmailContactFlag = 1 where InstrumentContactID = 81116
	update tblContact set Email ='michael.wu@environment.nsw.gov.au' where ContactID = 70287
	update tblInstrument set InstrumentStatusID = 755 where InstrumentID =5050763 
	--------------------------------------
	SELECT A.InstrumentID
	FROM tblDGLicence A INNER JOIN tblInstrument B
	ON A.InstrumentID = B.InstrumentID
	WHERE 
	A.DGLicenceTypeID = 819 
	AND 
	B.InstrumentStatusID = 755 
	AND 
	A.InstrumentID = 5050763