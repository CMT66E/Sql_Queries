select A.*, B.InstrumentTypeID from tblInstrumentAccountableParty A 
inner join tblRiskAssessment C ON A.InstrumentID = C.POEOLicenceIntrumentID 
left outer join tblInstrument B ON C.InstrumentID = B.InstrumentID 

select C.* from tblInstrumentLocation A inner join tblRiskAssessment B
ON A.InstrumentID = B.POEOLicenceIntrumentID inner join tblLocation C on A.LocationID = C.LocationID


select * from tblClassification where ClassificationDomainID = 48