SELECT        I.InstrumentID, 
(CASE I.InstrumentTypeID WHEN 817 THEN (CASE DGL.DGLicenceTypeID when 820 then 'Dangerous Goods Vehicle Licence' when 819 then 'DG Driver Licence' END)
                         WHEN 818 THEN (CASE isnull(A.CompanyFlag, 0) when 1 then 'Pesticide Company Licence' else 'Pesticide Licence' end) 
                         WHEN 819 THEN 'DG Driver Licence' END) as LicenceType,
(CASE I.InstrumentTypeID WHEN 817 THEN DGL.DGLicenceTypeID ELSE I.InstrumentTypeID END) as LicenceTypeID, 
(CASE WHEN A.CompanyFlag = 1 THEN A.OrganisationName ELSE A.GivenName + ' ' + A.Surname END) AS Name, 
APP.Photo, 
                         (CASE WHEN A.CompanyFlag = 1 THEN NULL ELSE (CASE WHEN I.InstrumentTypeID = 817 THEN CONVERT(VARCHAR(11), A.DateOfBirth, 106) 
                         WHEN I.InstrumentTypeID = 818 THEN CONVERT(VARCHAR(11), A.DateOfBirth, 106) ELSE NULL END) END) AS DateOfBirth, 
                         (CASE I.InstrumentTypeID WHEN 817 THEN DGDL.DriversLicenceNo WHEN 818 THEN NULL WHEN 819 THEN DGDL.DriversLicenceNo ELSE '' END) 
                         AS DriverLicence, (CASE I.InstrumentTypeID WHEN 817 THEN CONVERT(VARCHAR(11), DGL.ExpiryDate, 106) WHEN 818 THEN CONVERT(VARCHAR(11), 
                         PL.ExpiryDate, 106) WHEN 819 THEN CONVERT(VARCHAR(11), DGL.ExpiryDate, 106) ELSE '' END) AS ExpiryDate, 
                         (CASE I.InstrumentTypeID WHEN 817 THEN CONVERT(VARCHAR(11), I.DateIssued, 106) WHEN 818 THEN CONVERT(VARCHAR(11), I.DateIssued, 106) 
                         WHEN 819 THEN CONVERT(VARCHAR(11), I.DateIssued, 106) ELSE '' END) AS DateOfIssue, 
                         (CASE I.InstrumentTypeID WHEN 818 THEN [dbo].[ufn_GetPesticideLicenceClassTextAll](I.InstrumentID) 
                         WHEN 817 THEN DGDL.DriversLicenceClass WHEN 819 THEN DGDL.DriversLicenceClass ELSE '' END) AS LicenceClass, 
                         (CASE I.InstrumentTypeID WHEN 818 THEN [dbo].[ufn_GetPesticideLicenceClassText](I.InstrumentID, 1) 
                         WHEN 817 THEN DGDL.DriversLicenceClass WHEN 819 THEN DGDL.DriversLicenceClass ELSE '' END) AS LicenceClassLine1, 
                         (CASE I.InstrumentTypeID WHEN 818 THEN [dbo].[ufn_GetPesticideLicenceClassText](I.InstrumentID, 2) WHEN 817 THEN NULL WHEN 819 THEN NULL ELSE '' END) 
                         AS LicenceClassLine2, (CASE I.InstrumentTypeID WHEN 818 THEN [dbo].[ufn_GetPesticideLicenceClassText](I.InstrumentID, 3) WHEN 817 THEN NULL 
                         WHEN 819 THEN NULL ELSE '' END) AS LicenceClassLine3, (CASE I.InstrumentTypeID WHEN 818 THEN [dbo].[ufn_GetPesticideLicenceClassText](I.InstrumentID, 4) 
                         WHEN 817 THEN NULL WHEN 819 THEN NULL ELSE '' END) AS LicenceClassLine4, NULL AS ConditionsLine1, NULL AS ConditionsLine2, NULL 
                         AS ConditionsLine3, NULL AS ConditionsLine4
FROM            dbo.tblAccountableParty AS A LEFT OUTER JOIN
                         dbo.tblAddress AS ADDR ON ADDR.AddressID = A.AddressID LEFT OUTER JOIN
                         dbo.tblInstrumentAccountableParty AS IAP ON IAP.AccountablePartyID = A.AccountablePartyID LEFT OUTER JOIN
                         dbo.tblInstrument AS I ON I.InstrumentID = IAP.InstrumentID LEFT OUTER JOIN
                         dbo.tblClassification AS C ON C.ClassificationID = I.InstrumentTypeID LEFT OUTER JOIN
                         dbo.tblInstrumentAccountableParty AS IAPR ON IAPR.InstrumentAccountablePartyID =
                             (SELECT        MIN(InstrumentAccountablePartyID) AS Expr1
                               FROM            dbo.tblInstrumentAccountableParty AS IAPR1
                               WHERE        (InstrumentID = I.InstrumentID)) LEFT OUTER JOIN
                         dbo.tblAccountableParty AS APR ON APR.AccountablePartyID = IAPR.AccountablePartyID LEFT OUTER JOIN
                         dbo.tblAccountablePartyPhoto AS APRP ON APR.AccountablePartyID = APRP.AccountablePartyID LEFT OUTER JOIN
                         dbo.tblDGLicenceDriver AS DGDL ON I.InstrumentID = DGDL.InstrumentID LEFT OUTER JOIN
                         dbo.tblPesticideLicence AS PL ON I.InstrumentID = PL.InstrumentID LEFT OUTER JOIN
                         dbo.tblDGLicence AS DGL ON I.InstrumentID = DGL.InstrumentID LEFT OUTER JOIN
                         dbo.tblAccountablePartyPhoto AS APP ON A.AccountablePartyID = APP.AccountablePartyID
WHERE        (I.InstrumentTypeID IN (817, 818, 819)) AND (DGDL.PrintIDflag = 1 OR
                         PL.PrintIDflag = 1) AND (DGL.ExpiryDate IS NULL OR
                         PL.ExpiryDate IS NULL OR
                         DATEADD(week, 1, GETDATE()) <= DGL.ExpiryDate OR
                         DATEADD(week, 1, GETDATE()) <= PL.ExpiryDate) AND (IAPR.EffectiveDateTo IS NULL) AND (I.InstrumentStatusID = 755) AND (APP.Photo IS NOT NULL) AND 
                         (dbo.ufn_HasActiveVariation(I.InstrumentID) = 0) AND (dbo.ufn_HasActiveCorrection(I.InstrumentID) = 0)


select * from tblDGLicence a where InstrumentID = 5054687