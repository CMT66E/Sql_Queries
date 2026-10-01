    select distinct LicenceClassID, b.[Description] from [tblPesticideLicenceClass] a inner join tblClassification b
    on a.LicenceClassID = b.ClassificationID
    where LicenceClassID > 0
	and
		InstrumentID = 5071593 

select InstrumentID, count(*) from [tblPesticideLicenceClass]
group by InstrumentID
order by count(*) desc


COALESCE(@LicenceClass+', ' ,'') + (case isnull(v.ClassName, '') when '' then '' else '' + isnull(v.ClassName, '') end)


    select distinct b.[Description] + ' ' + b.[Description] from [tblPesticideLicenceClass] a inner join tblClassification b
    on a.LicenceClassID = b.ClassificationID
    where LicenceClassID > 0
	and
		InstrumentID = 5071593 


declare @InstrumentID int = 5071593

SELECT DISTINCT STUFF(
     (SELECT DISTINCT ', ' + CAST(b.[Description] AS VARCHAR(500)) [text]
     FROM tblPesticideLicenceClass a inner join tblClassification b on a.LicenceClassID = b.ClassificationID  
     WHERE InstrumentID = t.InstrumentID and LicenceClassID > 0
     FOR XML PATH(''), TYPE)
    .value('.','NVARCHAR(MAX)'),1,2,' ') LicenceClass 
FROM tblPesticideLicenceClass t 
WHERE t.InstrumentID = @InstrumentID
 