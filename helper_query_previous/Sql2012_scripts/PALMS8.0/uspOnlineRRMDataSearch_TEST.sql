select a.*, b.*, c.*, d.* from tblInstrumentRadiationLocation a 
inner join tblRadiationLocation b on a.RadiationLocationID = b.RadiationLocationID
left outer join tblRadiationLocationRRM c on b.RadiationLocationID = c.RadiationLocationID
left outer join tblRadiationLicenceRRM d on c.RadiationLicenceRRMID = d.RadiationLicenceRRMID
left outer join tblRadiationLicenceRRMComponent e on d.RadiationLicenceRRMID = e.RadiationLicenceRRMID
left outer join tblRRMComponent f on e.RRMComponentID = f.RRMComponentID
where InstrumentID =5061783 and c.RadiationLicenceRRMID = 1379


select 
b.RadiationLocationID as LocationId, 
d.RRMID as RRMId,
f.ModelNumber as ModelNo,
f.SerialNumber as SerialNo,
cast(f.AssayDate as varchar) as AssayDate,
f.NominalActivity,
f.ExtendedWorkingLifeFlag as IsLifeExtended,
f.WorkingLife,
f.RRMComponentID as RRMComponentID,
0 as VariationPendingFlag,
0 as IsDisposed,
null as DisposalSupportDoc,
b.LocationName as LocationName,
f.RRMComponentID as ComponentId,
c.RadiationLicenceRRMID as RadiationLicenceRRMID,
0 as IsTransferred,
0 as IsEdited,
(select [description] from tblClassification where ClassificationID = f.ComponentStatusID) as [Status]
from tblInstrumentRadiationLocation a 
inner join tblRadiationLocation b on a.RadiationLocationID = b.RadiationLocationID
left outer join tblRadiationLocationRRM c on b.RadiationLocationID = c.RadiationLocationID
left outer join tblRadiationLicenceRRM d on c.RadiationLicenceRRMID = d.RadiationLicenceRRMID
left outer join tblRadiationLicenceRRMComponent e on d.RadiationLicenceRRMID = e.RadiationLicenceRRMID
left outer join tblRRMComponent f on e.RRMComponentID = f.RRMComponentID
where InstrumentID =5061783 and c.RadiationLicenceRRMID = 1379


select 
f.RRMComponentTypeID as Id,
g.RRMTypeID as MaterialTypeId,
g.RRMComponentType as Name
from tblInstrumentRadiationLocation a 
inner join tblRadiationLocation b on a.RadiationLocationID = b.RadiationLocationID
left outer join tblRadiationLocationRRM c on b.RadiationLocationID = c.RadiationLocationID
left outer join tblRadiationLicenceRRM d on c.RadiationLicenceRRMID = d.RadiationLicenceRRMID
left outer join tblRadiationLicenceRRMComponent e on d.RadiationLicenceRRMID = e.RadiationLicenceRRMID
left outer join tblRRMComponent f on e.RRMComponentID = f.RRMComponentID
left outer join tblRRMComponentType g on f.RRMComponentTypeID = g.RRMComponentTypeID
where InstrumentID =5061783 and c.RadiationLicenceRRMID = 1379


select 
f.RadionuclideID as Id, 
g.[Description] as Name
from tblInstrumentRadiationLocation a 
inner join tblRadiationLocation b on a.RadiationLocationID = b.RadiationLocationID
left outer join tblRadiationLocationRRM c on b.RadiationLocationID = c.RadiationLocationID
left outer join tblRadiationLicenceRRM d on c.RadiationLicenceRRMID = d.RadiationLicenceRRMID
left outer join tblRadiationLicenceRRMComponent e on d.RadiationLicenceRRMID = e.RadiationLicenceRRMID
left outer join tblRRMComponent f on e.RRMComponentID = f.RRMComponentID
left outer join tblRadionuclide g on f.RadionuclideID = g.RadionuclideID
where InstrumentID =5061783 and c.RadiationLicenceRRMID = 1379




select * from tblRadiationLocationRRM where RadiationLocationID in
(select RadiationLocationID from tblInstrumentRadiationLocation where InstrumentID =5061783 ) 

SELECT [RadiationDepartmentID]
      ,[RadiationLocationID]
      ,[DepartmentName]
      ,[EffectiveDateFrom]
      ,[EffectiveDateTo]
      ,[DateCreated]
      ,[CreatedBySystemUserID]
      ,[DateUpdated]
      ,[UpdatedBySystemUserID]
      ,[RowTimestamp]
      ,[RowID]
  FROM [tblRadiationDepartment]
where RadiationLocationID in
(select RadiationLocationID from tblInstrumentRadiationLocation where InstrumentID =5061783 ) 

select * from tblRadiationLicenceRRM where RadiationLicenceRRMID in (select RadiationLicenceRRMID from tblRadiationLocationRRM where RadiationLocationID in
(select RadiationLocationID from tblInstrumentRadiationLocation where InstrumentID =5061783 ) )


select TOP 1 [DepartmentName] from [tblRadiationDepartment] where RadiationLocationID in
(select RadiationLocationID from tblInstrumentRadiationLocation where InstrumentID =5061783 ) 


select RRMPurposeID, RRMTypeID,  * from tblRadiationLicenceRRM where RadiationLicenceRRMID = 1379
select RRMType from tblRRMType where RRMTypeID = (select RRMTypeID from tblRadiationLicenceRRM where RadiationLicenceRRMID = 1379)


select *, RRMPurpose from tblRRMPurpose where RRMPurposeID = 3 and RRMTypeID = 1

select *, RegulatedMaterial from tblRRM where RRMID = 3 and RRMTypeID = 1 and RRMPurposeID = 3

select *, LaboratoryClassificationID from tblRadiationLicenceRRM where RadiationLicenceRRMID = 1379

select * from tblClassification where ClassificationDomainID = 84  -- 816 -> 755 for 5061783 changed on 06-11-2017
select * from tblClassification where ClassificationID = 816

exec [dbo].[uspOnlineRRMDataSearch] 5061783, 1379
--------------------------------------------------------------------------------------------------
select * from tblRadiationLicenceRRM where RadiationLicenceRRMID in (21486, 21488)
--------------------------------------------------------------------------------------------------
/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [RadiationLicenceRRMComponentID]
      ,[RadiationLicenceRRMID]
      ,[RRMComponentID]
      ,[VariationPendingFlag]
      ,[NewRadiationLicenceRRMID]
      ,[Notes]
      ,[InterstateOverseasRelocationFlag]
      ,[Recipient]
      ,[RecipientAddress]
      ,[State]
      ,[Country]
      ,[ExportedDate]
      ,[EffectiveDateFrom]
      ,[EffectiveDateTo]
      ,[DateCreated]
      ,[CreatedBySystemUserID]
      ,[DateUpdated]
      ,[UpdatedBySystemUserID]
      ,[RowTimestamp]
      ,[ROW_ID]
FROM [PALMSDB].[dbo].[tblRadiationLicenceRRMComponent]
------------------------------------------------------------------------------------------- 
select * from tblClassification where ClassificationDomainID = 92
------------------------------------------------------------------------------------------- 
select a.*, b.*, c.*, d.* from tblInstrumentRadiationLocation a 
inner join tblRadiationLocation b on a.RadiationLocationID = b.RadiationLocationID
left outer join tblRadiationLocationRRM c on b.RadiationLocationID = c.RadiationLocationID
left outer join tblRadiationLicenceRRM d on c.RadiationLicenceRRMID = d.RadiationLicenceRRMID
left outer join tblRadiationLicenceRRMComponent e on d.RadiationLicenceRRMID = e.RadiationLicenceRRMID
left outer join tblRRMComponent f on e.RRMComponentID = f.RRMComponentID
where c.RadiationLicenceRRMID in (select RadiationLicenceRRMID from tblRadiationLocationRRM where RadiationLocationID in (1282, 10455))
------------------------------------------------------------------------------------------- 

select * from tblRadiationLocationRRM where RadiationLocationID in (1282, 10455)
and RadiationLicenceRRMID in (21486, 21488)

select * from tblOnlineLicenceChangeApplication where OnlineLicenceChangeApplicationID =1392 
-------------------------------------------------------------------------------------------
SELECT *
FROM tblRRMComponent rrmc 
join tblRadiationLicenceRRMComponent lirrmc on rrmc.RRMComponentID = lirrmc.RRMComponentID
join tblRadiationLicenceRRM lirrm on lirrmc.RadiationLicenceRRMID = lirrm.RadiationLicenceRRMID
join tblRadiationLocationRRM lorrm on lirrm.RadiationLicenceRRMID = lorrm.RadiationLicenceRRMID
join tblRadiationLocation lo on lorrm.RadiationLocationID = lo.RadiationLocationID
join tblInstrumentRadiationLocation irl on lo.RadiationLocationID = irl.RadiationLocationID
WHERE lo.RadiationLocationID = 9453 and lirrm.RadiationLicenceRRMID = 8332 
-------------------------------------------------------------------------------------------
select * 
			   FROM tblRRMComponent rrmc 
			   join tblRadiationLicenceRRMComponent lirrmc on rrmc.RRMComponentID = lirrmc.RRMComponentID
			   join tblRadiationLicenceRRM lirrm on lirrmc.RadiationLicenceRRMID = lirrm.RadiationLicenceRRMID
			   join tblRadiationLocationRRM lorrm on lirrm.RadiationLicenceRRMID = lorrm.RadiationLicenceRRMID
			   join tblRadiationLocation lo on lorrm.RadiationLocationID = lo.RadiationLocationID
			   join tblInstrumentRadiationLocation irl on lo.RadiationLocationID = irl.RadiationLocationID
			   WHERE lo.RadiationLocationID = 9453 and lirrm.RadiationLicenceRRMID = 8332 
-------------------------------------------------------------------------------------------
select * 
			   FROM tblRadiationLicenceRRM lirrm
			   join tblRadiationLocationRRM lorrm on lirrm.RadiationLicenceRRMID = lorrm.RadiationLicenceRRMID
			   join tblRadiationLocation lo on lorrm.RadiationLocationID = lo.RadiationLocationID
			   join tblInstrumentRadiationLocation irl on lo.RadiationLocationID = irl.RadiationLocationID
			   WHERE lo.RadiationLocationID = 9453 and lirrm.RadiationLicenceRRMID = 8332 
-------------------------------------------------------------------------------------------
select * 
			   FROM tblRadiationLicenceRRM lirrm 
			   join tblRadiationLocationRRM lorrm on lirrm.RadiationLicenceRRMID = lorrm.RadiationLicenceRRMID
			   join tblRadiationLocation lo on lorrm.RadiationLocationID = lo.RadiationLocationID
			   join tblInstrumentRadiationLocation irl on lo.RadiationLocationID = irl.RadiationLocationID
			   WHERE lo.RadiationLocationID = 9453 and lirrm.RadiationLicenceRRMID = 8332 
-------------------------------------------------------------------------------------------

select * from tblClassification where ClassificationDomainID =92
---------------------------
select TOP 10 * from [tblRadiationLicenceRRM] order by DateCreated desc
select TOP 10 * from [tblRadiationLocationRRM] order by DateCreated desc
select TOP 10 * from [tblRRMComponent] order by DateCreated desc
select TOP 10 * from [tblRadiationLicenceRRMComponent] order by DateCreated desc
---------------------------