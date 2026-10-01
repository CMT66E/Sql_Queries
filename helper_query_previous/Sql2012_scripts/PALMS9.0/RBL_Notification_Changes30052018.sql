	declare @StartDate SMALLDATETIME = '2011-06-01'
	declare @EndDate SMALLDATETIME = '2018-05-29'

	SELECT a.InstrumentID AS NoticeID
	   ,a.DateCreated AS BatchDate
	   ,a.BatchPrintFlag
	   ,b.InstrumentID AS LicenceNo
	    ,CASE 
		WHEN d.CompanyFlag =0 THEN d.GivenName + ' ' + d.Surname
		WHEN d.CompanyFlag =1 THEN d.OrganisationName 
		END AS AcctParty
		,h.GivenName + ' ' + h.Surname AS ResponsibleOfficer

		,(case when g.LogDescription is null then [dbo].[ufn_GetLicenceEmailAddress](b.InstrumentID, 0) else g.LogDescription end) as EmailAddress
	 
		,DATEDIFF(day, k.DateIssued, getdate()) as DaysAfterAnniv		
		,(case when g.LogDescription is null then 0 else 1 end)  as IsEmailed  

		,a.NoticeTemplateID
		,k.DateIssued
	FROM tblNotice a 
	INNER JOIN tblInstrumentNotice b ON a.InstrumentID = b.NoticeInstrumentID 
	INNER JOIN tblInstrumentAccountableParty c ON b.InstrumentID = c.InstrumentID 
	INNER JOIN tblAccountableParty d ON c.AccountablePartyID = d.AccountablePartyID 
	INNER JOIN tblInstrument e ON b.InstrumentID = e.InstrumentID 
	INNER JOIN tblSystemUser h ON h.SystemUserID = e.ResponsibleSystemUserID 
	INNER JOIN tblInstrument f ON a.InstrumentID = f.InstrumentID
	LEFT OUTER JOIN tblBatchEmailCommunicationLog g on b.InstrumentID = g.[PrimaryRecordID]
	LEFT OUTER JOIN tblInstrument k ON b.InstrumentID = k.InstrumentID
	WHERE DATEDIFF(DAY,@StartDate,a.DateCreated)>=0
	AND DATEDIFF(DAY,@EndDate,a.DateCreated)<=0  
	AND a.NoticeTemplateID = 703 AND f.InstrumentStatusID = 11
	AND c.InstrumentAccountablePartyID IN
		( SELECT TOP 1 InstrumentAccountablePartyID 
		  FROM tblInstrumentAccountableParty 
		  WHERE instrumentID = c.InstrumentID 
		  ORDER BY InstrumentAccountablePartyID )	 
	ORDER BY b.InstrumentID
	---------------------------------------------------------------
	--SELECT a.InstrumentID AS NoticeID
	--   ,a.DateCreated AS BatchDate
	--   ,a.BatchPrintFlag
	--   ,b.InstrumentID AS LicenceNo
	--    ,CASE 
	--	WHEN d.CompanyFlag =0 THEN d.GivenName + ' ' + d.Surname
	--	WHEN d.CompanyFlag =1 THEN d.OrganisationName 
	--	END AS AcctParty
	--	,h.GivenName + ' ' + h.Surname AS ResponsibleOfficer
	--	,g.[PrimaryRecordID]
	--	,g.LogDescription
		 
	--FROM tblNotice a 
	--INNER JOIN tblInstrumentNotice b ON a.InstrumentID = b.NoticeInstrumentID 
	--INNER JOIN tblInstrumentAccountableParty c ON b.InstrumentID = c.InstrumentID 
	--INNER JOIN tblAccountableParty d ON c.AccountablePartyID = d.AccountablePartyID 
	--INNER JOIN tblInstrument e ON b.InstrumentID = e.InstrumentID 
	--INNER JOIN tblSystemUser h ON h.SystemUserID = e.ResponsibleSystemUserID 
	--INNER JOIN tblInstrument f ON a.InstrumentID = f.InstrumentID
	--LEFT OUTER JOIN tblBatchEmailCommunicationLog g on a.InstrumentID = g.[PrimaryRecordID]
	--WHERE DATEDIFF(DAY,@StartDate,a.DateCreated)>=0
	--AND DATEDIFF(DAY,@EndDate,a.DateCreated)<=0  
	--AND a.NoticeTemplateID = 703 AND f.InstrumentStatusID = 11
	--AND c.InstrumentAccountablePartyID IN
	--	( SELECT TOP 1 InstrumentAccountablePartyID 
	--	  FROM tblInstrumentAccountableParty 
	--	  WHERE instrumentID = c.InstrumentID 
	--	  ORDER BY InstrumentAccountablePartyID )
	 
	--ORDER BY b.InstrumentID


