select b.* from [CUSSBagDropDB_JFK].[dbo].[BagWeightUpdate] a inner join [CUSSBagDropDB_JFK].[dbo].CustomerSession b on a.CustomerSessionID = b.ID
WHERE DatePart(year, a.[LocalTime]) = 2021 and DatePart(month, a.[LocalTime]) = 6 and DatePart(day, a.[LocalTime]) = 17
and not a.ID in 
(
select ID from [CUSSReportingDB_JFK].[dbo].[BagWeightUpdate]
WHERE DatePart(year, [LocalTime]) = 2021 and DatePart(month, [LocalTime]) = 6 and DatePart(day, [LocalTime]) = 17
)

----------------------------------------------------------------------------------------
select * from [CUSSReportingDB_JFK].[dbo].CustomerSession where ID in
(
	select CustomerSessionID from [CUSSBagDropDB_JFK].[dbo].[BagWeightUpdate]
	WHERE DatePart(year, [LocalTime]) = 2021 and DatePart(month, [LocalTime]) = 6 and DatePart(day, [LocalTime]) = 20
	and NOT ID in 
	(
		select ID from [CUSSReportingDB_JFK].[dbo].[BagWeightUpdate]
		WHERE DatePart(year, [LocalTime]) = 2021 and DatePart(month, [LocalTime]) = 6 and DatePart(day, [LocalTime]) = 20
	)
)