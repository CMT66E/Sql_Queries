---------------------------PALMSDB----------------------------------------------------------

select * from [PALMSDB].[dbo].tblInstrument where InstrumentID = 6689
select * from [PALMSDB].[dbo].tblInstrumentAccountableParty where InstrumentID = 6689
select * from [PALMSDB].[dbo].tblAccountableParty where AccountablePartyID = 2279
select * from [PALMSDB].[dbo].tblInstrumentLocation where InstrumentID = 6689
select * from [PALMSDB].[dbo].tblLocation where LocationID = 926
select * from [PALMSDB].[dbo].tblAddress where AddressID = 990

---------------------------WDS----------------------------------------------------------
select NSWLicenceFlag, * from AccountOperation where AccountOPerationPermit = '6689'
select * from Customer where CustomerID = 1638
select * from site where SiteID = 1423