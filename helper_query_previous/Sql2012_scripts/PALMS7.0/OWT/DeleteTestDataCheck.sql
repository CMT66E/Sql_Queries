
select top 10 * from [Customer] where CustomerID > = 13100 order by DateCreated desc                --13100
select top 10 * from [Site] where SiteID >= 22582 order by DateCreated desc                         --22582
select top 10 * from [AccountOperation] where AccountOperationID >= 22581 order by DateCreated desc --22581
select top 10 * from [Individual] where IndividualID >= 22565 order by DateCreated desc             --22565

--GRANT EXECUTE ON [dbo].[uspPALMSAccountOperationCreateUpdate] TO OWTReadWriteRole
--GRANT EXECUTE ON [dbo].[uspPALMSCustomerCreateUpdate] TO OWTReadWriteRole
--GRANT EXECUTE ON [dbo].[uspPALMSSiteCreateUpdate] TO OWTReadWriteRole