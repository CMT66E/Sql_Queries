declare @InstrumentID int = 5068285


 

SELECT DISTINCT STUFF(
     (SELECT DISTINCT ', ' + CAST(b.[Description] AS VARCHAR(500)) [text]
     FROM tblPesticideLicenceClass a inner join tblClassification b on a.LicenceClassID = b.ClassificationID  
     WHERE InstrumentID = t.InstrumentID and LicenceClassID > 0
     FOR XML PATH(''), TYPE)
    .value('.','NVARCHAR(MAX)'),1,2,' ') LicenceClass 
FROM tblPesticideLicenceClass t 
WHERE t.InstrumentID = @InstrumentID


SELECT t.InstrumentID, STUFF(
     (SELECT ', ' + CAST(LicenceClassID AS VARCHAR(20)) [text]
     FROM tblPesticideLicenceClass
     WHERE InstrumentID = t.InstrumentID and LicenceClassID > 0
     FOR XML PATH(''), TYPE)
    .value('.','NVARCHAR(MAX)'),1,2,' ') LicenceClassID
FROM tblPesticideLicenceClass t  
GROUP BY t.InstrumentID  


SELECT DISTINCT STUFF(
     (SELECT DISTINCT ', ' + CAST(LicenceClassID AS VARCHAR(20)) [text]
     FROM tblPesticideLicenceClass
     WHERE InstrumentID = t.InstrumentID and LicenceClassID > 0
     FOR XML PATH(''), TYPE)
    .value('.','NVARCHAR(MAX)'),1,2,' ') LicenceClassID
FROM tblPesticideLicenceClass t 
WHERE t.InstrumentID = @InstrumentID