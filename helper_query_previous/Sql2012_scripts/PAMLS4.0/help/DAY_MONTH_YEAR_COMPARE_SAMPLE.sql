select * from tblBulkRadiationLicenceArchive
where CompletedDate is null

select * from tblBulkRadiationLicenceArchive
where InstrumentID = 5001179


select * from tblBulkRadiationLicenceArchive
where datepart(day, CompletedDate) = 7 and
datepart(month, CompletedDate) = 7 and 
datepart(year, CompletedDate) = 2016



select InstrumentID from tblBulkRadiationLicenceArchive
where datepart(day, CompletedDate) = 7 and
datepart(month, CompletedDate) = 7 and 
datepart(year, CompletedDate) = 2016

select * from [PALMSDocDB].[dbo].tblLicenceDocument
where datepart(day, DateCreated) = 7 and
datepart(month, DateCreated) = 7 and 
datepart(year, DateCreated) = 2016
and InstrumentID in 

(select InstrumentID from tblBulkRadiationLicenceArchive
where datepart(day, CompletedDate) = 7 and
datepart(month, CompletedDate) = 7 and 
datepart(year, CompletedDate) = 2016)

order by DateCreated desc

select * from tblRadiationLicenceVariation
WHERE InstrumentID in 

(select InstrumentID from tblBulkRadiationLicenceArchive
where datepart(day, CompletedDate) = 7 and
datepart(month, CompletedDate) = 7 and 
datepart(year, CompletedDate) = 2016)

and datepart(day, DateCreated) = 7 and
datepart(month, DateCreated) = 7 and 
datepart(year, DateCreated) = 2016


select distinct InstrumentID, count(InstrumentID) from tblRadiationLicenceVariation
WHERE InstrumentID in 

(select InstrumentID from tblBulkRadiationLicenceArchive
where datepart(day, CompletedDate) = 7 and
datepart(month, CompletedDate) = 7 and 
datepart(year, CompletedDate) = 2016)

and datepart(day, DateCreated) = 7 and
datepart(month, DateCreated) = 7 and 
datepart(year, DateCreated) = 2016 
group by InstrumentID
having count(InstrumentID) > 3
order by  count(InstrumentID)

select * from tblRadiationLicenceVariation where InstrumentID = 5000973

------------------------
--find radiation licence type
------------------------
select a.InstrumentID, a.ReasonForArchive, b.InstrumentID, c.RadiationLicenceTypeID
from tblBulkRadiationLicenceArchive a 
inner join tblInstrument b on a.InstrumentID = b.InstrumentID
inner join tblRadiationLicence c on b.InstrumentID = c.InstrumentID
 