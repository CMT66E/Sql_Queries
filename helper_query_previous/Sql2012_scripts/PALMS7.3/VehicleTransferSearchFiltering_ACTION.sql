select * from tblInstrumentAccountableParty where InstrumentID = 1537072 

--====================================================================================================================================================
select a.*, b.Description as PayloadTypeText from tblDGVehicle a left outer join tblClassification b on a.PayloadTypeID = b.ClassificationID  
where a.PayloadTypeID = 1404 and a.DGVehicleID not in (select DGVehicleID from tblDGLicenceVehicle)
update tblDGVehicle set ProhibitedVehiclesFlag=0 where DGVehicleID = 16335
--select a.*, b.Description as PayloadTypeText from tblDGVehicle a left outer join tblClassification b on a.PayloadTypeID = b.ClassificationID  
--where a.PayloadTypeID = 1405 and a.DGVehicleID not in (select DGVehicleID from tblDGLicenceVehicle)
--====================================================================================================================================================
select a.*, b.Description as PayloadTypeText from tblDGVehicle a left outer join tblClassification b on a.PayloadTypeID = b.ClassificationID  
where a.PayloadTypeID = 1406 and a.DGVehicleID not in (select DGVehicleID from tblDGLicenceVehicle)
update tblDGVehicle set ProhibitedVehiclesFlag=0 where DGVehicleID = 16319
--====================================================================================================================================================


--select * from tblClassification where ClassificationID = 1404

