-----------------------------------------------------------------------------------------------------------------------------
--All issued RM licences have email contact already in total: 0 
-----------------------------------------------------------------------------------------------------------------------------
select a.InstrumentID, c.ContactID, d.* 
from tblRadiationLicence a
inner join tblInstrument b on a.InstrumentID = b.InstrumentID
left outer join tblInstrumentContact c on b.InstrumentID = c.InstrumentID
left outer join tblContact d on c.ContactID = d.ContactID 
where a.RadiationLicenceTypeID = 796 
and b.InstrumentStatusID = 755
and c.EmailContactFlag = 1 
and isnull(d.Email, '') = ''
 
-----------------------------------------------------------------------------------------------------------------------------
--All issued RM licences have no email contact at all total: 1435 
-----------------------------------------------------------------------------------------------------------------------------
select a.InstrumentID, c.ContactID, c.EmailContactFlag, d.* 
from tblRadiationLicence a
inner join tblInstrument b on a.InstrumentID = b.InstrumentID
left outer join tblInstrumentContact c on b.InstrumentID = c.InstrumentID
left outer join tblContact d on c.ContactID = d.ContactID 
where a.RadiationLicenceTypeID = 796 
and b.InstrumentStatusID = 755
and c.EmailContactFlag = 0
and 
not a.InstrumentID in 
					(select distinct a.InstrumentID  
					from tblRadiationLicence a
					inner join tblInstrument b on a.InstrumentID = b.InstrumentID
					left outer join tblInstrumentContact c on b.InstrumentID = c.InstrumentID
					left outer join tblContact d on c.ContactID = d.ContactID 
					where a.RadiationLicenceTypeID = 796 
					and b.InstrumentStatusID = 755
					and c.EmailContactFlag = 1)
-----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------