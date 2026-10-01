------------------------------------------------------------------Data remove in PALMS for transportation location etc---------------------------------------------------------------------
delete from tblInstrumentTransporterLocation where TransporterLocationID in (select TransporterLocationID from tblTransporterLocation)
 
delete from tblTransporterLocation where AddressID in (select [AddressID] from tblAddress where cast(ROW_ID as varchar) in (select cast([AddressID] as varchar) FROM [OWT_tblAddress_BK]))  

delete from tblAddress where cast(ROW_ID as varchar) in (select cast([AddressID] as varchar) FROM [PALMSDB].[dbo].[OWT_tblAddress_BK])

----------------------------------------------------------------------------------------------------------------------------------------------

--select * from tblInstrumentTransporterLocation where TransporterLocationID in (select TransporterLocationID from tblTransporterLocation)
--select * from tblTransporterLocation where AddressID in (select [AddressID] from tblAddress where cast(ROW_ID as varchar) in (select cast([AddressID] as varchar) FROM [OWT_tblAddress_BK]))  
--select * from tblAddress where cast(ROW_ID as varchar) in (select cast([AddressID] as varchar) FROM [OWT_tblAddress_BK])