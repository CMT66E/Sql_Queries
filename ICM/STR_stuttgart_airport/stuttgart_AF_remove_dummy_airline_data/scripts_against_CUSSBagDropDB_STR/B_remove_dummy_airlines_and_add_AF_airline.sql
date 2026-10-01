

USE CUSSBagDropDB_STR
GO


--step 1. Insert AF into airline table
if not exists(select * from dbo.Airline where [name] = 'AF' or [Description] = 'AF')
	insert into dbo.Airline ([Name], [Description]) values ('AF', 'AF')

--step 2. Delete dummy airlines: we delete 6X and KLM airline rows as they have no records in Flight table at all
if not exists(select * from Flight where MarketingCarrier in ('6X', 'KLM', 'EW"'))
    delete from dbo.Airline where [name] in ('6X', 'KLM', 'EW"') or [Description]  in ('6X', 'KLM', 'EW"') 