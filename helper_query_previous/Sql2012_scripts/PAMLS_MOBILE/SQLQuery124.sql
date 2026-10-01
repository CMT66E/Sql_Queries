select  
a.InstrumentID, count(*)
	
from
dbo.tblInstrumentAccountableParty  a 
left outer join tblAccountableParty b on a.AccountablePartyID= b.AccountablePartyID
left outer join tblInstrument c on a.InstrumentID = c.InstrumentID 
		 
where c.InstrumentTypeID = 493 
and c.InstrumentStatusID = 3
group by a.instrumentid
having count(*) > 1
order by count(*) desc

----------------------------------------------

select  
a.AccountablePartyID, count(*)
	
from
dbo.tblInstrumentAccountableParty  a 
left outer join tblAccountableParty b on a.AccountablePartyID= b.AccountablePartyID
left outer join tblInstrument c on a.InstrumentID = c.InstrumentID 
		 
where c.InstrumentTypeID = 493 
and c.InstrumentStatusID = 3
group by a.AccountablePartyID
having count(*) > 1
order by count(*) desc