--This script will help to check how many records in [CUSSBagDropDB].[dbo].[CustomerSession] in CDG airport need to be transferred into [CUSSBagDropDB].[dbo].[CustomerSession]
--Date: 06-03-2022 Eric He
--copy data from 
--   [CUSSBagDropDB].[dbo].[CustomerSession]
--to 
--   [CUSSReportingDB].[dbo].[CustomerSession]
-----------------------------------------------------------------------------
declare @MaxIDReportingDB  bigint 

select TOP 1  @MaxIDReportingDB = [ID]
FROM [CUSSReportingDB_CDG].[dbo].[CustomerSession]
order by ID desc

print '@MaxIDReportingDB = ' + cast(@MaxIDReportingDB as varchar)


-----------------------------------------------------------------------------
declare @MaxIDBagDropDB  bigint
SELECT TOP 1 @MaxIDBagDropDB = [ID]
FROM [CUSSBagDropDB_CDG].[dbo].[CustomerSession]
order by ID desc
print '@MaxIDBagDropDB = ' + cast(@MaxIDBagDropDB as varchar)

------------------------------------------------------------------------------
declare @NoRecordsNeedInsert  bigint
select @NoRecordsNeedInsert = @MaxIDBagDropDB - @MaxIDReportingDB

print '@NoRecordsNeedInsert = ' + cast(@NoRecordsNeedInsert as varchar)


-- total records will be more than 826,560 rows

------------------------------------------------------------------------------

