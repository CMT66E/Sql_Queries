
--List all licence and account party with a record in WDS customer table
--all customer records which are linked with PALMS accountparty table
--select * 
--from 
--tblInstrumentAccountableParty a 
--inner join tblAccountableParty b ON a.AccountablePartyID = b.AccountablePartyID 
--inner join tblInstrument d ON a.InstrumentID = d.InstrumentID
--inner join OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=OWT_RW;PWD=rw2owT').WDS.dbo.Customer c 
--on b.AccountablePartyID  = c.PALMSAccountablePartyID
--WHERE d.InstrumentTypeID = 493

--select * from tblInstrumentLocation where InstrumentID = 10055

--Revoke Licence
select * from OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=OWT_RW;PWD=rw2owT').WDS.dbo.AccountOperation 
where cast(AccountOperationPermit as varchar) in 
(
	select cast(a.InstrumentID as varchar)
	from 
	tblInstrumentAccountableParty a 
	inner join tblAccountableParty b ON a.AccountablePartyID = b.AccountablePartyID 
	inner join tblInstrument d ON a.InstrumentID = d.InstrumentID
	inner join OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=OWT_RW;PWD=rw2owT').WDS.dbo.Customer c 
	on b.AccountablePartyID  = c.PALMSAccountablePartyID
	WHERE d.InstrumentTypeID = 493 and d.InstrumentStatusID = 4
)

select * from tblClassification where ClassificationDomainID = 1

-------------------------------------------------------------------------------------------------------------------------------------------------------
--POEO licence location data
select distinct
	OWTLocation.InstrumentID,
	OWTLocation.LocationID,
	(case isnull(b.LocationName, '') when '' then dbo.ufn_GetNameByAccountablePartyId(d.AccountablePartyID) + (case isnull(c.Suburb, '') when '' then '' else ' ' + c.Suburb end) else b.LocationName end) as SiteName,
	c.[Address]  as StreetAddress,
	c.[Suburb]  as Suburb,
	c.[Postcode]  as PostCode,
	c.[StateCode]  as StateCode 
from tblInstrumentLocation OWTLocation 
inner join tblLocation b on OWTLocation.LocationID = b.LocationID 
left outer join tblAddress c on b.AddressID = c.AddressID 
left outer join tblInstrumentAccountableParty d on OWTLocation.InstrumentID = 
(select top 1 d.InstrumentID from tblInstrumentAccountableParty where InstrumentID = OWTLocation.InstrumentID)
where OWTLocation.InstrumentID  = 12462 and b.PremisesFlag = 1


--Transporter location data
select distinct
	OWTLocation.InstrumentID,
	OWTLocation.TransporterLocationID as LocationID,
	(case isnull(b.LocationName, '') when '' then dbo.ufn_GetNameByAccountablePartyId(d.AccountablePartyID) + (case isnull(c.Suburb, '') when '' then '' else ' ' + c.Suburb end) else b.LocationName end) as SiteName,
	c.[Address]  as StreetAddress,
	c.[Suburb]  as Suburb,
	c.[Postcode]  as PostCode,
	c.[StateCode]  as StateCode 
from tblInstrumentTransporterLocation OWTLocation 
inner join tblTransporterLocation b on OWTLocation.TransporterLocationID = b.TransporterLocationID 
left outer join tblAddress c on b.AddressID = c.AddressID 
left outer join tblInstrumentAccountableParty d on OWTLocation.InstrumentID = 
(select top 1 d.InstrumentID from tblInstrumentAccountableParty where InstrumentID = OWTLocation.InstrumentID)
where OWTLocation.InstrumentID  = 12462 
--and b.PremisesFlag = 1
-------------------------------------------------------------------------------------------------------------------------------------------------------