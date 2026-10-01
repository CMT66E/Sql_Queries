select * from [CUSSBagDropDB_JFK].[dbo].[CustomerSession]
WHERE DatePart(year, [LocalCreationTime]) = 2021 and DatePart(month, [LocalCreationTime]) = 6 and DatePart(day, [LocalCreationTime]) = 9
order by ID

select * from [CUSSReportingDB_JFK_PURE].[dbo].[CustomerSession]
WHERE DatePart(year, [LocalTime]) = 2021 and DatePart(month, [LocalTime]) = 6 and DatePart(day, [LocalTime]) = 9
order by ID

select * from [CUSSReportingDB_JFK].[dbo].[CustomerSession]
WHERE DatePart(year, [LocalTime]) = 2021 and DatePart(month, [LocalTime]) = 6 and DatePart(day, [LocalTime]) = 9
order by ID