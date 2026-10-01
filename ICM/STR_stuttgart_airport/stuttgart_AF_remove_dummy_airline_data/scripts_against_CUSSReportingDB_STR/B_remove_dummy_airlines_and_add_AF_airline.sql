

USE CUSSReportingDB_STR
GO


--step 1. Insert AF into airline table
if not exists(select * from dbo.Airlines where [Airline] = 'AF' and [AirlineDescription] = 'AF') and (select max(ID) from dbo.Airlines) = 8
	insert into dbo.Airlines ([ID], [Airline], [ColorR], [ColorB], [ColorG], [AirlineHeading], [AirlineDescription], [GridColumnWidth]) values (9, 'AF', 0, 0, 255, 'AF', 'AF', 80)

--step 2. Delete dummy airlines: we delete 6X and KLM airline rows as they have no records in Flight table at all
if not exists(select * from FLight where MarketingCarrier in ('6X', 'KLM', 'EW"', '9C'))
    delete from dbo.Airlines where [Airline] in ('6X', 'KLM', 'EW"', '9C') or [AirlineDescription] in ('6X', 'KLM', 'EW"', '9C') 