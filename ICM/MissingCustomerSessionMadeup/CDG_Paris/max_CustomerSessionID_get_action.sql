--copy data from 
--   [CUSSBagDropDB_CDG].[dbo].[CustomerSession]
--to 
--   [CUSSReportingDB_CDG].[dbo].[CustomerSession]

-----------------------------------------------------------------------------
declare @MaxIDReportingDB  bigint 

select TOP 1  @MaxIDReportingDB = [ID]
FROM [CUSSReportingDB_CDG].[dbo].[CustomerSession]
order by ID desc

print '@MaxIDReportingDB = ' + cast(@MaxIDReportingDB as varchar)

--select * from [CUSSBagDropDB_CDG].[dbo].[CustomerSession]
--where ID > @MaxIDReportingDB

select TOP 1 *
FROM [CUSSReportingDB_CDG].[dbo].[CustomerSession] order by ID desc