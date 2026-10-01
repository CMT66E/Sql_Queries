select * 
			  from AccountOperation a 
				inner join Customer b on a.CustomerID = b.CustomerID
				inner join [Site] c on a.SiteID = c.SiteID 
			  where 
				AccountOperationPermit = cast(6089 as varchar) 
			    and
				a.AccountOperationRoleTypeID = 289  
				--and 
				--a.EffectiveDateTo is null
				--and b.CustomerID = 562
				--and c.SiteID = 1251

--select * from Customer where TradingName like '%BLACKTOWN CUSTOM%'
--select * from [Site] where SiteName = 'ERS AUSTRALIA PTY LIMITED'

select * from [Site] where SiteID = 1342
select * from AccountOperation where AccountOperationPermit = cast(6089 as varchar) 
			    and
				(AccountOperationRoleTypeID = 288 and AccountOperationRoleTypeID = 289) 

select * from AccountOperation where  (CustomerID IN (1034, 2151))
and AccountOperationPermit = cast(6089 as varchar) 

select * from Customer where PALMSAccountablePartyID in (5049, 5063)  -- old: 5049 and new: 5063
                                                            --CostomerID old: 1034 and new: 2151

select top 50 * from [OWTAccountOperationWasteCode]
where AccountOperationID = 22645
order by DateCreated desc 

select AccountOperationID from AccountOperation where AccountOperationRoleTypeID = 288 and AccountOperationPermit = cast(6089 as varchar) and CustomerID = 1034  
select AccountOperationID from AccountOperation where AccountOperationRoleTypeID = 288 and AccountOperationPermit = cast(6089 as varchar) and CustomerID = 2151  

        SELECT
           AccountOperationID
        FROM AccountOperation
        WHERE AccountOperationPermit = CAST(6089 AS varchar(10))
        AND AccountOperationRoleTypeID = 289
        AND EffectiveDateTo IS NULL


select top 500 * from [OWTAccountOperationWasteCode]
where  AccountOperationID = 22650
--order by DateCreated desc  

select AccountOperationID from AccountOperation where CustomerID = 2151 and AccountOperationPermit = cast(6089 as varchar) and AccountOperationRoleTypeID = 289    

--delete from [OWTAccountOperationWasteCode]
-- where AccountOperationID = 4448

 --update AccountOperation set EffectiveDateTo = getdate() where AccountOperationID = 4448

--delete from AccountOperation
-- where AccountOperationID = 4448