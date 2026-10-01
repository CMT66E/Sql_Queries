declare @POEOApplicationid int
set @POEOApplicationid = 1

select LicenceXML FROM tblOnlinePOEOApplication 
WHERE OnlinePOEOApplicationID = @POEOApplicationid

--SELECT LicenceXML.query('/POEOLicence/AppplicationPoint/NoisePoints/POEOLicenceNoisePoint'), LicenceXML.value('(/POEOLicence/AppplicationPoint/NoisePoints/POEOLicenceNoisePoint/Id)[1]','int')  
--FROM tblOnlinePOEOApplication 
--WHERE OnlinePOEOApplicationID = @POEOApplicationid
 