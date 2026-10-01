
declare @LicenceNo int = 5061783 
declare @RadiationLicenceRRMID int = 1379 
--------------------------------------------------------------------------
--To Do: we check to make sure this @RadiationLicenceRRMID is binded with this @LicenceNo ???
if exists(
select a.RadiationLocationID from tblRadiationLocationRRM a 
where RadiationLocationID in (select RadiationLocationID from tblInstrumentRadiationLocation where InstrumentID =@LicenceNo) 
and a.RadiationLicenceRRMID = @RadiationLicenceRRMID )
BEGIN
--------------------------------------------------------------------------
  --select * from tblInstrumentRadiationLocation where InstrumentID =@LicenceNo

--1.declare table: @RADMMaterial
	DECLARE @RADMMaterial TABLE(
								RRMId INT,
								LocationId INT,
								Department NVARCHAR(200),
								WorkArea NVARCHAR(500),
								ExtendedLifeProofDoc NVARCHAR(500),
								RadiationLicenceRRMID INT,
								IsFromLicence BIT,
								LicenceNo INT 
							)
    insert into @RADMMaterial
	(
								RRMId,
								LocationId,
								Department,
								WorkArea,
								ExtendedLifeProofDoc,
								RadiationLicenceRRMID,
								IsFromLicence,
								LicenceNo 
	)
    select  
      (select RRMId from tblRadiationLicenceRRM where RadiationLicenceRRMID = @RadiationLicenceRRMID) as RRMId,
	  RADMMaterial.RadiationLocationID as LocationId,
	  (select TOP 1 [DepartmentName] from [tblRadiationDepartment] where RadiationLocationID in
             (select RadiationLocationID from tblInstrumentRadiationLocation where InstrumentID =@LicenceNo)) as Department,

	  (select TOP 1 WorkArea from tblRadiationLicenceRRM where RadiationLicenceRRMID = @RadiationLicenceRRMID) as WorkArea,
	  null as ExtendedLifeProofDoc,	  
	  @RadiationLicenceRRMID as RadiationLicenceRRMID,
	  1 as IsFromLicence,
	  @LicenceNo as LicenceNo
    from tblInstrumentRadiationLocation as RADMMaterial
    where InstrumentID =@LicenceNo

	--**************************************************************************************
    select * from @RADMMaterial
	--**************************************************************************************

--2. declare table: @RADMMaterialType
	DECLARE @RADMMaterialType TABLE(
								Id INT,								 
								Name NVARCHAR(500) 
							)
    insert into @RADMMaterialType
	select 
	 RRMTypeID as Id, 
	 (select RRMType from tblRRMType where RRMTypeID = (select RRMTypeID from tblRadiationLicenceRRM where RadiationLicenceRRMID = @RadiationLicenceRRMID)) as Name
	from tblRadiationLicenceRRM where RadiationLicenceRRMID = @RadiationLicenceRRMID

	--**************************************************************************************
    select * from @RADMMaterialType
	--**************************************************************************************

--3. declare table: @RADMPurpose
	DECLARE @RADMPurpose TABLE(
								Id INT,		
								MaterialTypeId INT,						 
								Name NVARCHAR(500) 
							)
    insert into @RADMPurpose
    select RRMPurposeID as Id, 
	       RRMTypeID as MaterialTypeId,
		   (select RRMPurpose from tblRRMPurpose where RRMPurposeID = tblRadiationLicenceRRM.RRMPurposeID and RRMTypeID = tblRadiationLicenceRRM.RRMTypeID) as Name
	from tblRadiationLicenceRRM where RadiationLicenceRRMID = @RadiationLicenceRRMID
	--**************************************************************************************
    select * from @RADMPurpose
	--**************************************************************************************

--4. declare table @RADMEquipment
	DECLARE @RADMEquipment TABLE(
								Id INT,		
								MaterialTypeId INT,
								PurposeId INT,						 
								Name NVARCHAR(500) 
							)

	insert into @RADMEquipment 
	select 
	  RRMID as Id,
	  RRMTypeID as MaterialTypeId,
	  RRMPurposeID as PurposeId,
	(select RegulatedMaterial from tblRRM where RRMID = tblRadiationLicenceRRM.RRMID and RRMTypeID = tblRadiationLicenceRRM.RRMTypeID 
	        and RRMPurposeID = tblRadiationLicenceRRM.RRMPurposeID) as Name
	from tblRadiationLicenceRRM where RadiationLicenceRRMID = @RadiationLicenceRRMID

	--**************************************************************************************
    select * from @RADMEquipment
	--**************************************************************************************

--5. declare table @RADMLabClassification
	DECLARE @RADMLabClassification TABLE(
								Id INT NULL,								 
								Name NVARCHAR(500) NULL
							)
    insert into @RADMLabClassification
	select 
		a.LaboratoryClassificationID as Id, 
		b.[description] as Name
	from tblRadiationLicenceRRM a inner join tblClassification b on a.LaboratoryClassificationID = b.ClassificationID 
	where RadiationLicenceRRMID = @RadiationLicenceRRMID

	--**************************************************************************************
    select * from @RADMLabClassification
	--**************************************************************************************

--6. declare table @RADMMaterialComponent
	DECLARE @RADMMaterialComponent TABLE(
								LocationId INT,
								RRMId INT,
								ModelNo NVARCHAR(50),
								SerialNo NVARCHAR(100),
								AssayDate NVARCHAR(50),
								NominalActivity decimal,
								IsLifeExtended BIT,
								WorkingLife INT,
								RRMComponentID INT,
								VariationPendingFlag BIT,
								IsDisposed BIT,
								DisposalSupportDoc NVARCHAR(100),  
								LocationName NVARCHAR(100), 
								ComponentId INT,
								RadiationLicenceRRMID INT,
								IsTransferred BIT,
								IsEdited BIT,
								[Status] NVARCHAR(50) 
							)
	insert into @RADMMaterialComponent	 
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
	where InstrumentID =@LicenceNo and c.RadiationLicenceRRMID = @RadiationLicenceRRMID

	--**************************************************************************************
    select * from @RADMMaterialComponent
	--**************************************************************************************

--8. declare table @RADMComponentType
	DECLARE @RADMComponentType TABLE(
								Id INT,		
								MaterialTypeId INT,						 
								Name NVARCHAR(500) 
							)
    insert into @RADMComponentType
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
	where InstrumentID =@LicenceNo and c.RadiationLicenceRRMID = @RadiationLicenceRRMID
	--**************************************************************************************
    select * from @RADMComponentType
	--**************************************************************************************

--9. declare table @RADMManufacturer
	DECLARE @RADMManufacturer TABLE(
								Id INT,								 
								Name NVARCHAR(500) 
							)
    insert into @RADMManufacturer
	select 
	f.ManufacturerID as Id, 
	g.ManufacturerName as Name
	from tblInstrumentRadiationLocation a 
	inner join tblRadiationLocation b on a.RadiationLocationID = b.RadiationLocationID
	left outer join tblRadiationLocationRRM c on b.RadiationLocationID = c.RadiationLocationID
	left outer join tblRadiationLicenceRRM d on c.RadiationLicenceRRMID = d.RadiationLicenceRRMID
	left outer join tblRadiationLicenceRRMComponent e on d.RadiationLicenceRRMID = e.RadiationLicenceRRMID
	left outer join tblRRMComponent f on e.RRMComponentID = f.RRMComponentID
	left outer join tblManufacturer g on f.ManufacturerID = g.ManufacturerID
	where InstrumentID =@LicenceNo and c.RadiationLicenceRRMID = @RadiationLicenceRRMID
	--**************************************************************************************
    select * from @RADMManufacturer
	--**************************************************************************************

--10. declare table @RADMRadionuclide
	DECLARE @RADMRadionuclide TABLE(
								Id INT,								 
								Name NVARCHAR(500) 
							)
    insert into @RADMRadionuclide
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
	where InstrumentID =@LicenceNo and c.RadiationLicenceRRMID = @RadiationLicenceRRMID
	--**************************************************************************************
    select * from @RADMRadionuclide
	--**************************************************************************************
END