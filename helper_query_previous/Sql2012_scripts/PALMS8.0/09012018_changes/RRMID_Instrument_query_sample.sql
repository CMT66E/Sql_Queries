--select * from tblRadiationLocationRRM where RadiationLicenceRRMID = 3684
--select * from tblRadiationLicenceRRMComponent  where RadiationLicenceRRMID = 3684

select b.RadiationLicenceRRMID, irl.instrumentiD, * from tblRadiationLocationRRM loc 
left outer join tblRadiationLicenceRRM b on loc.RadiationLicenceRRMID = b.RadiationLicenceRRMID
left outer join tblInstrumentRadiationLocation irl on irl.RadiationLocationID = loc.RadiationLocationID
where b.RadiationLicenceRRMID = 3755
--where irl.InstrumentID = 5062780

select loc.RadiationLocationRRMID, loc.RadiationLicenceRRMID from tblRadiationLocationRRM loc 
left outer join tblRadiationLicenceRRM b on loc.RadiationLicenceRRMID = b.RadiationLicenceRRMID
left outer join tblInstrumentRadiationLocation irl on irl.RadiationLocationID = loc.RadiationLocationID
where irl.InstrumentID <> 5062780 and loc.RadiationLicenceRRMID in (select b.RadiationLicenceRRMID from tblRadiationLocationRRM loc 
left outer join tblRadiationLicenceRRM b on loc.RadiationLicenceRRMID = b.RadiationLicenceRRMID
left outer join tblInstrumentRadiationLocation irl on irl.RadiationLocationID = loc.RadiationLocationID
where irl.InstrumentID = 5062780)

select * from tblOnlineRADApplication where InstrumentID in (select irl.instrumentiD from tblRadiationLocationRRM loc 
left outer join tblRadiationLicenceRRM b on loc.RadiationLicenceRRMID = b.RadiationLicenceRRMID
left outer join tblInstrumentRadiationLocation irl on irl.RadiationLocationID = loc.RadiationLocationID
where b.RadiationLicenceRRMID = 3684)

select *, ApplicationStatusID from tblOnlineRADApplication where InstrumentID = 5069364 and ApplicationStatusID = 1128

declare @InstrumentID int = 5069364
select loc.RadiationLocationRRMID from tblRadiationLocationRRM loc 
						left outer join tblRadiationLicenceRRM b on loc.RadiationLicenceRRMID = b.RadiationLicenceRRMID
						left outer join tblInstrumentRadiationLocation irl on irl.RadiationLocationID = loc.RadiationLocationID
						where irl.InstrumentID <> @InstrumentID and loc.RadiationLicenceRRMID in (select b.RadiationLicenceRRMID from tblRadiationLocationRRM loc 
						left outer join tblRadiationLicenceRRM b on loc.RadiationLicenceRRMID = b.RadiationLicenceRRMID
						left outer join tblInstrumentRadiationLocation irl on irl.RadiationLocationID = loc.RadiationLocationID
						where irl.InstrumentID = @InstrumentID)

select loc.RadiationLocationRRMID from tblRadiationLocationRRM loc 
						left outer join tblRadiationLicenceRRM b on loc.RadiationLicenceRRMID = b.RadiationLicenceRRMID
						left outer join tblInstrumentRadiationLocation irl on irl.RadiationLocationID = loc.RadiationLocationID
						where irl.InstrumentID <> @InstrumentID and loc.RadiationLicenceRRMID in (select b.RadiationLicenceRRMID from tblRadiationLocationRRM loc 
						left outer join tblRadiationLicenceRRM b on loc.RadiationLicenceRRMID = b.RadiationLicenceRRMID
						left outer join tblInstrumentRadiationLocation irl on irl.RadiationLocationID = loc.RadiationLocationID
						where irl.InstrumentID = @InstrumentID)
