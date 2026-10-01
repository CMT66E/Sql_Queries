select * from Customer where PALMSAccountablePartyID = 88530

select SiteID from Site where SiteName = 'TIPICA Site1' and ActiveFlag = 1
select SiteID from Site where PALMSLocationID = 1000014 and ActiveFlag = 1


select * 
from AccountOperation a 
inner join Customer b on a.CustomerID = b.CustomerID
inner join [Site] c on a.SiteID = c.SiteID 
where 
a.AccountOperationRoleTypeID = 290  
and 
a.EffectiveDateTo is null
and b.CustomerID = 15227
and c.SiteID = 23703


      select AccountOperationID as TransporterAccountOperationID
      FROM AccountOperation
      WHERE AccountOperationPermit = CAST(20979 AS varchar(10))
      AND AccountOperationRoleTypeID = 290
      AND EffectiveDateTo IS NULL

		SELECT 23747 as AccountOperationID, B.OWTWasteCodeID
		FROM OWTWasteCode A INNER JOIN OWTWasteCode B ON A.Code = B.Code

select * from AccountOperation
      WHERE AccountOperationPermit = CAST(20979 AS varchar(10))

	  select * from Individual where AccountOperationID in (23750, 23751)


select * from AccountOperation 
where WasteCodeUpdateOffFlag = 1
order by DateCreated desc
 