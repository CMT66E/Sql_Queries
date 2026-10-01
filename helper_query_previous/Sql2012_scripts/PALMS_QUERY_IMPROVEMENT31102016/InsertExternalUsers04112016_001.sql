




select * from vwProfile
select * from tblOnlineUserAccess

select a.ProfileID from vwProfile a 
left outer join tblOnlineUserAccess b on a.ProfileID = b.ProfileID
left outer join tblAccountableParty c on b.AccountablePartyID = c.AccountablePartyID 
left outer join tblInstrumentAccountableParty d on c.AccountablePartyID = d.AccountablePartyID
 

select * from vwProfile a 
left outer join tblOnlineUserAccess b on a.ProfileID = b.ProfileID
left outer join tblAccountableParty c on b.AccountablePartyID = c.AccountablePartyID 
left outer join tblInstrumentAccountableParty d on c.AccountablePartyID = d.AccountablePartyID


