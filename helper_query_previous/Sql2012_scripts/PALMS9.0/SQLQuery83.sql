
	declare @LicenceNo INT = 5050763
	declare @ApplicationCode VARCHAR(6) = 'YAS987'

DECLARE @rowCountMatch INT = 0;
	DECLARE @CompletedCount INT = 0;
	DECLARE @rowCountValidLicence INT = 0;
	DECLARE @appExists INT=0;
	DECLARE @EmailAddress VARCHAR(128);
	DECLARE @OnlineApplicationCodeID INT
	DECLARE @CheckResult INT=0

	SELECT @OnlineApplicationCodeID =OnlineApplicationCodeID  
	FROM tblOnlineApplicationCode 
	WHERE ApplicationCode = @ApplicationCode

	SELECT @EmailAddress = B.EmailAddress FROM tblOnlineApplicationCode A INNER JOIN tblOnlineApplicant B
		ON A.OnlineApplicantID = B.OnlineApplicantID
	WHERE A.ApplicationCode = @ApplicationCode



	SELECT @CompletedCount = COUNT(OnlineRADContactUpdateApplicationID)
	FROM tblOnlineRADContactUpdateApplication
	WHERE LicenceNumber = @LicenceNo AND OnlineApplicationCodeID = @OnlineApplicationCodeID

	SELECT @rowCountValidLicence = COUNT(A.InstrumentID) 
	FROM tblDGLicence A INNER JOIN tblInstrument B
	ON A.InstrumentID = B.InstrumentID
	WHERE A.DGLicenceTypeID = 819 AND B.InstrumentStatusID = 755 AND A.InstrumentID = @LicenceNo -- here: 819 -> Dangerous Goods Driver Licence


	SELECT @rowCountMatch = COUNT(a.ContactID) 
	FROM tblInstrumentContact A INNER JOIN tblContact B
			ON A.ContactID = B.ContactID
	WHERE InstrumentID = @LicenceNo AND (B.Email IS NOT NULL AND B.Email = @EmailAddress) AND A.EmailContactFlag = 1

	
	IF @CompletedCount > 0
	BEGIN
		SELECT @CheckResult = 2
	END
	ELSE
	BEGIN
		IF @rowCountValidLicence  = 0
		BEGIN
			SELECT @CheckResult = 3
		END
		
		IF @rowCountValidLicence > 0 AND @rowCountMatch > 0
		BEGIN
			SELECT @CheckResult = 1
		END
				
		print cast(@rowCountMatch as varchar(10))

		IF @rowCountValidLicence  > 0 AND @rowCountMatch = 0
		BEGIN
			SELECT @CheckResult = -1
		END

	END
	
	
		
		
	SELECT @CheckResult;
