declare @StartDate datetime
declare @EndDate datetime

set @StartDate = '2014-09-01'
set @EndDate = '2014-09-05'

declare @LicenceTypeID int
set @LicenceTypeID = 0

declare @ExpiryStartDate datetime
declare @ExpiryEndDate datetime
set @ExpiryStartDate = '2014-10-21'
set @ExpiryEndDate = '2014-10-22'

	SELECT a.RadiationLicenceRenewalID as ReportingPeriodID 
		,a.DateCreated AS BatchDate
		,a.InstrumentID AS LicenceNo
		,CASE 
		WHEN d.CompanyFlag =0 THEN d.GivenName + ' ' + d.Surname
		WHEN d.CompanyFlag =1 THEN d.OrganisationName 
		END AS AcctParty
		,a.BatchPrintFlag
		,e.GivenName + ' ' + e.Surname AS ResponsibleOfficer
		,b.InstrumentTypeID
		,[dbo].[ufn_GetRadiationDGandPesticideLicenceTypeText](a.InstrumentID, b.InstrumentTypeID) as TypeText
		,[dbo].[ufn_GetRadiationDGandPesticideLicenceTypeID](a.InstrumentID, b.InstrumentTypeID) as LicenceTypeID
		,[dbo].[ufn_GetRadiationDGandPesticideLicenceExpiryDate](a.InstrumentID, b.InstrumentTypeID) as ExpiryDate
	FROM tblRadiationLicenceRenewal a
	INNER JOIN tblInstrument b ON a.InstrumentID = b.InstrumentID 
	INNER JOIN tblInstrumentAccountableParty c ON a.InstrumentID = c.InstrumentID 
	INNER JOIN tblAccountableParty d ON c.AccountablePartyID = d.AccountablePartyID 
	INNER JOIN tblSystemUser e ON b.ResponsibleSystemUserID = e.SystemUserID 
	INNER JOIN PALMSDocDB.dbo.tblRadiationLicenceRenewDocument va on a.RadiationLicenceRenewalID = va.RadiationLicenceRenewalID 
	WHERE DATEDIFF(DAY,@StartDate,a.DateCreated)>=0
	AND DATEDIFF(DAY,@EndDate,a.DateCreated)<=0  
	--AND a.UpdatedBySystemUserID = 2--Batch process	
	--AND va.CreatedBySystemUserID = 2
	AND c.InstrumentAccountablePartyID = 
		(SELECT TOP(1) InstrumentAccountablePartyID
		FROM tblInstrumentAccountableParty 
		WHERE InstrumentID = b.InstrumentID ORDER BY 1 DESC)
    AND NOT EXISTS (select * from tblInstrumentContact where InstrumentID = a.InstrumentID and EmailContactFlag = 1)
	AND [dbo].[ufn_GetRadiationDGandPesticideLicenceTypeID](a.InstrumentID, b.InstrumentTypeID) = CASE ISNULL(@LicenceTypeID, 0) WHEN 0 THEN [dbo].[ufn_GetRadiationDGandPesticideLicenceTypeID](a.InstrumentID, b.InstrumentTypeID) ELSE @LicenceTypeID  END
	AND DATEDIFF(DAY, isnull(@ExpiryStartDate, [dbo].[ufn_GetRadiationDGandPesticideLicenceExpiryDate](a.InstrumentID, b.InstrumentTypeID)), [dbo].[ufn_GetRadiationDGandPesticideLicenceExpiryDate](a.InstrumentID, b.InstrumentTypeID))>=0
	AND DATEDIFF(DAY, isnull(@ExpiryEndDate, [dbo].[ufn_GetRadiationDGandPesticideLicenceExpiryDate](a.InstrumentID, b.InstrumentTypeID)), [dbo].[ufn_GetRadiationDGandPesticideLicenceExpiryDate](a.InstrumentID, b.InstrumentTypeID))<=0  
	Order by a.InstrumentID