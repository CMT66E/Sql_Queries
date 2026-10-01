select * from [WDS].[dbo].[AccountOperation] where AccountOperationPermit = cast(20701 as varchar)
select * from [WDS].[dbo].[Customer] where CustomerID = 6750
select * from [WDS].[dbo].[Customer] where PALMSAccountablePartyID = 5692
select * from [WDS].[dbo].[Site] where SiteID in (7455, 22636)


select * from tblInstrumentAccountableParty where InstrumentID = 20701
select * from tblAccountableParty where AccountablePartyID = 5692
select * from tblInstrumentLocation where InstrumentID = 20701 
select * from tblLocation where LocationID = 7455