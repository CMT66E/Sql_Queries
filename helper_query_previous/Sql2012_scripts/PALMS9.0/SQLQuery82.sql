select b.ApplicationCode, a.LicenceNumber, a.* from tblOnlineRADContactUpdateApplication a 
inner join tblOnlineApplicationCode b on a.OnlineApplicationCodeID = b.OnlineApplicationCodeID
inner join tblDGLicence d on a.LicenceNumber = d.InstrumentID
inner join tblInstrument e on d.InstrumentID = e.InstrumentID
where e.InstrumentTypeId = 817

select b.ApplicationCode, a.LicenceNumber, a.* from tblOnlineRADContactUpdateApplication a 
inner join tblOnlineApplicationCode b on a.OnlineApplicationCodeID = b.OnlineApplicationCodeID
inner join tblRadiationLicence d on a.LicenceNumber = d.InstrumentID
 


select b.ApplicationCode, a.LicenceNumber, a.* from tblOnlineRADContactUpdateApplication a 
inner join tblOnlineApplicationCode b on a.OnlineApplicationCodeID = b.OnlineApplicationCodeID 
where a.LicenceNumber = 5050763 and b.ApplicationCode = 'YAS987'
delete from tblOnlineRADContactUpdateApplication where OnlineRADContactUpdateApplicationID = 104