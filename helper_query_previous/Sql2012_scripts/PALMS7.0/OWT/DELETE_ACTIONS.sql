select top 2 * from [Customer] 
where CustomerID > 13100  
order by DateCreated desc             --13100

select top 2 * from [Site] 
where SiteID > 22582
order by DateCreated desc             --22582

select * from [AccountOperation] 
where AccountOperationID > 22581
order by DateCreated desc             --22581

select top 3 * from [Individual] 
where IndividualID > 22565
order by DateCreated desc             --22565

select top 500 * from [OWTAccountOperationWasteCode]
where AccountOperationID in (select AccountOperationID from AccountOperation where AccountOperationID > 22581)
order by DateCreated desc             --AccountOperationID 22581

----------------DELETING TESTING DATA ROWS----------------------------------
--delete from [Site] where SiteID > 22582
--delete from [AccountOperation] where AccountOperationID > 22581

--delete from [Customer] where CustomerID > 13100  
--delete from [Individual] where IndividualID > 22565

--delete from [OWTAccountOperationWasteCode]
--where AccountOperationID in (select AccountOperationID from AccountOperation where AccountOperationID > 22581)
----------------END DELETING TESTING DATA ROWS----------------------------------
 
----select * from Customer
----where ACN_ARBN = '75 004 250 944'

select * from Customer where PALMSAccountablePartyID = 3419
select * from Site where PALMSLocationID = 3292
select * from AccountOperation where CustomerID = 9
select * from OWTAccountOperationWasteCode where AccountOperationID in (select AccountOperationID from AccountOperation where CustomerID = 9)
order by DateCreated desc
--delete from OWTAccountOperationWasteCode where AccountOperationID = 22629
--delete from [AccountOperation] where AccountOperationID = 22634


        SELECT
          AccountOperationID
        FROM AccountOperation
        WHERE AccountOperationPermit = CAST(6089 AS varchar(10))
        AND AccountOperationRoleTypeID = 289
        AND EffectiveDateTo IS NULL
 