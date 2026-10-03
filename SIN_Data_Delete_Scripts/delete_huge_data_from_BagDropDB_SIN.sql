USE BagDropDB_SIN152
GO

declare @DeleteDataBeforeThisDate datetime = '2022-08-31'; 
declare @BatchDeleteRecords int = 100; --spcifiy the number of records we will delete on this batch 

-- select TOP (@BatchDeleteRecords) * FROM [CustomerSession] where LocalCreationTime <  @DeleteDataBeforeThisDate
 

--select TOP (@BatchDeleteRecords) * from [PaperBoardPassLookup]
--where CustomerSessionID in
--(
--    SELECT distinct TOP (@BatchDeleteRecords) ID FROM [CustomerSession] where 
--     LocalCreationTime <  @DeleteDataBeforeThisDate  
--)

--select TOP (@BatchDeleteRecords) * from [CustomerSessionTimeOnEachScreen]
--where CustomerSessionID in
--(
--    SELECT distinct TOP (@BatchDeleteRecords) ID  FROM [CustomerSession] where LocalCreationTime <  @DeleteDataBeforeThisDate
--)

--select TOP (@BatchDeleteRecords) * from [BagWeightUpdate]
--where CustomerSessionID in
--(
--    SELECT TOP (@BatchDeleteRecords) ID FROM [CustomerSession] where LocalCreationTime <  @DeleteDataBeforeThisDate
--)


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
--delete from [BagWeightUpdate]
--where CustomerSessionID in
--(
--     SELECT distinct TOP (@BatchDeleteRecords) ID FROM [CustomerSession] where 
--     LocalCreationTime <  @DeleteDataBeforeThisDate   
--)

with CTE_Delete as (
select TOP (@BatchDeleteRecords) *
from [BagWeightUpdate]
where CustomerSessionID in (
   select TOP (@BatchDeleteRecords) ID from [CustomerSession] where LocalCreationTime <  @DeleteDataBeforeThisDate order by LocalCreationTime asc)
)
delete from CTE_Delete
print 'delete data from table: from [BagWeightUpdate] done';

-------------------we should delete this table at the lastest stage ----------------------------------------
with CTE_Delete as (
select TOP (@BatchDeleteRecords) *
from [AbdStation] 
where not ID in
(
select distinct [AbdStationID] FROM [CustomerSession]
) and not ID in (select distinct ABDStationID from CMOperationHistory)
)
delete from CTE_Delete
print 'delete data from table: [AbdStation] done';
-------------------

--delete from [CustomerSessionTimeOnEachScreen]
--where CustomerSessionID in
--(
--     SELECT distinct TOP (@BatchDeleteRecords) ID FROM [CustomerSession] where 
--     LocalCreationTime <  @DeleteDataBeforeThisDate   
--)

with CTE_Delete as (
select *
from [CustomerSessionTimeOnEachScreen]
where CustomerSessionID in (
   select TOP (@BatchDeleteRecords) ID from [CustomerSession] where LocalCreationTime <  @DeleteDataBeforeThisDate order by LocalCreationTime asc)
)
delete from CTE_Delete
print 'delete data from table: from [CustomerSessionTimeOnEachScreen] done';

-------------------
--delete from [PaperBoardPassLookup]
--where CustomerSessionID in
--(
--     SELECT distinct TOP (@BatchDeleteRecords) ID FROM [CustomerSession] where 
--     LocalCreationTime <  @DeleteDataBeforeThisDate  
--)

with CTE_Delete as (
select TOP (@BatchDeleteRecords) *
from [PaperBoardPassLookup]
where CustomerSessionID in (
   select TOP (@BatchDeleteRecords) ID from [CustomerSession] where LocalCreationTime <  @DeleteDataBeforeThisDate order by LocalCreationTime asc)
)
delete from CTE_Delete
print 'delete data from table: from [CustomerSessionTimeOnEachScreen] done';

-------------------
--delete from [CustomerSession] where LocalCreationTime <  @DeleteDataBeforeThisDate 

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