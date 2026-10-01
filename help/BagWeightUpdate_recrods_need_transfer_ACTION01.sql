-----------------------------------------------------------------------------
declare @MaxIDReportingDB  bigint 

select TOP 1  @MaxIDReportingDB = [ID]
FROM [CUSSReportingDB_CDG].[dbo].[BagWeightUpdate]
order by ID desc

print '@MaxIDReportingDB = ' + cast(@MaxIDReportingDB as varchar)

-----------------------------------------------------------------------------
declare @MaxIDBagDropDB  bigint
SELECT TOP 1 @MaxIDBagDropDB = [ID]
FROM [CUSSBagDropDB_CDG].[dbo].[BagWeightUpdate]
order by ID desc
print '@MaxIDBagDropDB = ' + cast(@MaxIDBagDropDB as varchar)

------------------------------------------------------------------------------
declare @NoRecordsNeedInsert  bigint
select @NoRecordsNeedInsert = @MaxIDBagDropDB - @MaxIDReportingDB

print '@NoRecordsNeedInsert = ' + cast(@NoRecordsNeedInsert as varchar)


--771561
------------------------------------------------------------------------------