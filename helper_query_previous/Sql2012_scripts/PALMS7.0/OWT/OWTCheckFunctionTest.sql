

select * 
from AccountOperation a 
inner join Customer b on a.CustomerID = b.CustomerID
inner join [Site] c on a.SiteID = c.SiteID 
where 
a.AccountOperationRoleTypeID = 288 
and 
a.EffectiveDateTo is null
and b.PALMSAccountablePartyID = 4722
and c.PALMSLocationID = 4299


declare @RecordType bit
select @RecordType = [dbo].[ufn_PALMSConsignorRecordExist](14106, 22588) 
print '@RecordType=' + cast(@RecordType as varchar)

select @RecordType = [dbo].[ufn_PALMSTransporterRecordExist](14106, 22588) 
print '@RecordType=' + cast(@RecordType as varchar)
  
select @RecordType = [dbo].[ufn_PALMSReceiverRecordExist](14106, 22588) 
print '@RecordType=' + cast(@RecordType as varchar)  


select CustomerID from Customer where PALMSAccountablePartyID = 4722