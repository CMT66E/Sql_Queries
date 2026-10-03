USE BagDropDB_SIN152
GO

declare @DeleteDataBeforeThisDate datetime = '2022-08-31'; --spcifiy the date which all records older than this date will be deleted by this script 
declare @BatchDeleteRecords int = 10000; --spcifiy the number of records we will delete on this batch 


--------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
with CTE_Delete as (
select TOP (@BatchDeleteRecords) * from [ABDErrorLog]
where [LocalCreationTime] <  @DeleteDataBeforeThisDate and ABDStationID in (select distinct TOP (@BatchDeleteRecords) [AbdStationID] FROM [CustomerSession] where LocalCreationTime < @DeleteDataBeforeThisDate)  
order by [LocalCreationTime] asc
)
delete from CTE_Delete
print 'delete data from table: [ABDErrorLog] done';

----------------
with CTE_Delete as (
select TOP (@BatchDeleteRecords) * from [AbdStateHistory]
where [LocalTime] <  @DeleteDataBeforeThisDate  order by [LocalTime] asc
)
delete from CTE_Delete
print 'delete data from table: from [AbdStateHistory] done';
----------------
with CTE_Delete as (
select TOP (@BatchDeleteRecords) *
from [CMOperationHistory] 
where [MessageSent] < @DeleteDataBeforeThisDate order by [MessageSent] asc
)
delete from CTE_Delete
print 'delete data from table: [CMOperationHistory] done';
----------------
----------------
with CTE_Delete as (
select TOP (@BatchDeleteRecords) *
from [HeavyTagInjectionLog] 
where [LocalLogTime] < @DeleteDataBeforeThisDate order by [LocalLogTime] asc
)
delete from CTE_Delete
print 'delete data from table: [HeavyTagInjectionLog] done';
----------------
with CTE_Delete as (
select TOP (@BatchDeleteRecords) *
from [HeavyTagPrintLog] 
where [LocalLogTime] < @DeleteDataBeforeThisDate order by [LocalLogTime] asc
)
delete from CTE_Delete
print 'delete data from table: [HeavyTagPrintLog] done';
----------------
with CTE_Delete as (
select TOP (@BatchDeleteRecords) *
from [PaperTagReadLog] 
where [LocalLogTime] < @DeleteDataBeforeThisDate order by [LocalLogTime] asc
)
delete from CTE_Delete
print 'delete data from table: [PaperTagReadLog] done';
----------------if necessary please delete them at the last---------------- 
--with CTE_Delete as (
--select TOP (@BatchDeleteRecords) *
--from [PaperTagReadStep] 
--where [LocalCreateTime] < @DeleteDataBeforeThisDate order by [LocalCreateTime] asc
--)
--delete from CTE_Delete
--print 'delete data from table: [PaperTagReadStep] done';
----------------
with CTE_Delete as (
select TOP (@BatchDeleteRecords) *
from [QBagTagReadLog] 
where [LocalLogTime] < @DeleteDataBeforeThisDate order by [LocalLogTime] asc
)
delete from CTE_Delete
print 'delete data from table: [QBagTagReadLog] done';
----------------
----------------
with CTE_Delete as (
select TOP (@BatchDeleteRecords) *
from [CustomerSessionTimeOnEachScreen] 
where CustomerSessionID in
(
select TOP (@BatchDeleteRecords) ID FROM [CustomerSession] where LocalCreationTime < @DeleteDataBeforeThisDate order by LocalCreationTime asc)
)
delete from CTE_Delete
print 'delete data from table: [CustomerSessionTimeOnEachScreen] done';
----------------

with CTE_Delete as (
select TOP (@BatchDeleteRecords) *
from [BagWeightUpdate]
where CustomerSessionID in (
   select TOP (@BatchDeleteRecords) ID from [CustomerSession] where LocalCreationTime <  @DeleteDataBeforeThisDate order by LocalCreationTime asc)
)
delete from CTE_Delete
print 'delete data from table: from [BagWeightUpdate] done';

-------------------we should delete this table at the lastest stage if necessary ----------------------------------------
--with CTE_Delete as (
--select TOP (@BatchDeleteRecords) *
--from [AbdStation] 
--where not ID in
--(
--select distinct [AbdStationID] FROM [CustomerSession]
--) and not ID in (select distinct ABDStationID from CMOperationHistory)
--)
--delete from CTE_Delete
--print 'delete data from table: [AbdStation] done';
-------------------

with CTE_Delete as (
select *
from [CustomerSessionTimeOnEachScreen]
where CustomerSessionID in (
   select TOP (@BatchDeleteRecords) ID from [CustomerSession] where LocalCreationTime <  @DeleteDataBeforeThisDate order by LocalCreationTime asc)
)
delete from CTE_Delete
print 'delete data from table: from [CustomerSessionTimeOnEachScreen] done';

-------------------

with CTE_Delete as (
select TOP (@BatchDeleteRecords) *
from [PaperBoardPassLookup]
where CustomerSessionID in (
   select TOP (@BatchDeleteRecords) ID from [CustomerSession] where LocalCreationTime <  @DeleteDataBeforeThisDate order by LocalCreationTime asc)
)
delete from CTE_Delete
print 'delete data from table: from [CustomerSessionTimeOnEachScreen] done';

-------------------

with CTE_Delete as (
select TOP (@BatchDeleteRecords) *
from [CustomerSession]
where LocalCreationTime <  @DeleteDataBeforeThisDate  order by LocalCreationTime asc
)
delete from CTE_Delete
print 'delete data from table: from [CustomerSession] done';
-------------------

with CTE_Delete as (
select TOP (@BatchDeleteRecords) *
from [Customer]
where not ID in (
   select distinct CustomerID from [CustomerSession]
)
)
delete from CTE_Delete
print 'delete data from table: from [Customer] done';
-------------------