USE ReportingDB_SIN
GO

declare @DeleteDataBeforeThisDate datetime = '2022-08-31'; 
declare @BatchDeleteRecords int = 1000000; --spcifiy the number of records we will delete on this batch

--delete from [CMOperationHistory]
--where [MessageSent] <  @DeleteDataBeforeThisDate
--print 'delete data from table: [CMOperationHistory] done'

--delete TOP (@BatchDeleteRecords) from QBagTagReadLog
--where [LocalLogTime] <  @DeleteDataBeforeThisDate 

------

with CTE_Delete as (
select TOP (@BatchDeleteRecords) *
from QBagTagReadLog order by [LocalLogTime] asc
)
delete from CTE_Delete
print 'delete data from table: [QBagTagReadLog] done';
------
--delete from QBagTagReadSuccessData
--where not QBagTagReadLogID in (select TOP (@BatchDeleteRecords) ID from QBagTagReadLog where [LocalLogTime] <  @DeleteDataBeforeThisDate order by [LocalLogTime] asc)
--print 'delete data from table: [QBagTagReadSuccessData] done'

with CTE_Delete as (
select TOP (@BatchDeleteRecords) *
from QBagTagReadSuccessData 
where not QBagTagReadLogID in (select TOP (@BatchDeleteRecords) ID from QBagTagReadLog where [LocalLogTime] <  @DeleteDataBeforeThisDate order by [LocalLogTime] asc)
)
delete from CTE_Delete
print 'delete data from table: [QBagTagReadSuccessData] done';
----

------
--delete from QBagTagWriteLog
--where [LocalLogTime] <  @DeleteDataBeforeThisDate
--print 'delete data from table: [QBagTagReadLog] done'

with CTE_Delete as (
select TOP (@BatchDeleteRecords) *
from QBagTagWriteLog 
where [LocalLogTime] <  @DeleteDataBeforeThisDate order by [LocalLogTime] asc)
delete from CTE_Delete
print 'delete data from table: [QBagTagReadLog] done';
------
--delete from QBagTagWriteSuccessData
--where not QBagTagWriteLogID in (select ID from QBagTagWriteLog where [LocalLogTime] <  @DeleteDataBeforeThisDate)
--print 'delete data from table: [QBagTagReadSuccessData] done'

with CTE_Delete as (
select TOP (@BatchDeleteRecords) *
from QBagTagWriteSuccessData 
where not QBagTagWriteLogID in (select TOP (@BatchDeleteRecords) ID from QBagTagWriteLog where [LocalLogTime] <  @DeleteDataBeforeThisDate order by [LocalLogTime] asc)
)
delete from CTE_Delete
print 'delete data from table: [QBagTagReadSuccessData] done';
------

--delete from [PaperTagReadLog]
--where [LocalLogTime] <  @DeleteDataBeforeThisDate
--print 'delete data from table: [CMOperationHistory] done'

with CTE_Delete as (
select TOP (@BatchDeleteRecords) *
from [PaperTagReadLog] 
where [LocalLogTime] <  @DeleteDataBeforeThisDate order by [LocalLogTime] asc
)
delete from CTE_Delete
print 'delete data from table: [PaperTagReadLog] done';

------

--delete from [PaperTagReadSuccessData]
--where not PaperTagReadLogID in (select ID from [PaperTagReadLog])
--print 'delete data from table: [PaperTagReadSuccessData] done'

with CTE_Delete as (
select TOP (@BatchDeleteRecords) *
from [PaperTagReadSuccessData] 
where not PaperTagReadLogID in (select TOP (@BatchDeleteRecords) ID from [PaperTagReadLog] where [LocalLogTime] <  @DeleteDataBeforeThisDate order by [LocalLogTime] asc)
)
delete from CTE_Delete
print 'delete data from table: [PaperTagReadSuccessData] done';
------

--delete from [PaperTagReadSuccessData]
--where not PaperTagReadLogID in (select ID from [PaperTagReadLog])
--print 'delete data from table: [PaperTagReadSuccessData] done'

with CTE_Delete as (
select TOP (@BatchDeleteRecords) *
from [PaperTagReadSuccessData] 
where not PaperTagReadLogID in (select TOP (@BatchDeleteRecords) ID from [PaperTagReadLog] where [LocalLogTime] <  @DeleteDataBeforeThisDate order by [LocalLogTime] asc)
)
delete from CTE_Delete
print 'delete data from table: [PaperTagReadSuccessData] done';
------

delete TOP (@BatchDeleteRecords) from [CustomerSessionTimeOnEachScreen]
where CustomerSessionID in
(
    SELECT TOP (@BatchDeleteRecords) ID FROM [CustomerSession] where LocalTime < @DeleteDataBeforeThisDate order by LocalTime asc   
)
print 'delete data from table: [CustomerSession]] done';
------

--DELETE FROM [ABDErrorLog]
--where [LocalCreationTime] < @DeleteDataBeforeThisDate
--print 'delete data from table: [ABDErrorLog] done'

with CTE_Delete as (
select TOP (@BatchDeleteRecords) *
from [ABDErrorLog] 
where [LocalCreationTime] < @DeleteDataBeforeThisDate order by [LocalCreationTime] asc
)
delete from CTE_Delete
print 'delete data from table: [ABDErrorLog] done';
------

--DELETE FROM [ABDAvailability]
--where [Date] <  @DeleteDataBeforeThisDate
--print 'delete data from table: [ABDAvailability] done'

with CTE_Delete as (
select TOP (@BatchDeleteRecords) *
from [ABDAvailability] 
where [Date] < @DeleteDataBeforeThisDate order by [Date] asc
)
delete from CTE_Delete
print 'delete data from table: [ABDAvailability] done';
------

--delete from [CMOperationHistory]
--where [MessageSent] <  @DeleteDataBeforeThisDate
--print 'delete data from table: [CMOperationHistory] done'

with CTE_Delete as (
select TOP (@BatchDeleteRecords) *
from [CMOperationHistory] 
where [MessageSent] < @DeleteDataBeforeThisDate order by [MessageSent] asc
)
delete from CTE_Delete
print 'delete data from table: [CMOperationHistory] done';
------

--delete from [PaperTagReadLog]
--where [LocalLogTime] < @DeleteDataBeforeThisDate
--print 'delete data from table: [PaperTagReadLog] done'


with CTE_Delete as (
select TOP (@BatchDeleteRecords) *
from [PaperTagReadLog] 
where [LocalLogTime] < @DeleteDataBeforeThisDate order by [LocalLogTime] asc
)
delete from CTE_Delete
print 'delete data from table: [PaperTagReadLog] done';

------------------- major delete actions as below ---------------------
with CTE_Delete as (
select TOP (@BatchDeleteRecords) *
from [AbdStation] 
where ID in
(
select distinct TOP (@BatchDeleteRecords) [AbdStationID] FROM [CustomerSession] where LocalTime < @DeleteDataBeforeThisDate)
)
delete from CTE_Delete
print 'delete data from table: [AbdStation] done';
-------------------

--delete from [BagWeightUpdate]
--where CustomerSessionID in
--(
--    SELECT ID FROM [CustomerSession] where LocalTime < @DeleteDataBeforeThisDate
--)
--print 'delete data from table: [BagWeightUpdate] done'

with CTE_Delete as (
select TOP (@BatchDeleteRecords) *
from [BagWeightUpdate] 
where CustomerSessionID in
(
select TOP (@BatchDeleteRecords) ID FROM [CustomerSession] where LocalTime < @DeleteDataBeforeThisDate order by LocalTime asc)
)
delete from CTE_Delete
print 'delete data from table: [BagWeightUpdate] done';

------------------- 
--delete from [CustomerSessionTimeOnEachScreen]
--where CustomerSessionID in
--(
--    SELECT ID FROM [CustomerSession] where LocalTime < @DeleteDataBeforeThisDate   
--)
--print 'delete data from table: [CustomerSessionTimeOnEachScreen] done'

with CTE_Delete as (
select TOP (@BatchDeleteRecords) *
from [CustomerSessionTimeOnEachScreen] 
where CustomerSessionID in
(
select TOP (@BatchDeleteRecords) ID FROM [CustomerSession] where LocalTime < @DeleteDataBeforeThisDate order by LocalTime asc)
)
delete from CTE_Delete
print 'delete data from table: [CustomerSessionTimeOnEachScreen] done';
------------------- 

--delete from [CustomerSession] where LocalTime < @DeleteDataBeforeThisDate
--print 'delete data from table: [CustomerSession] done'


with CTE_Delete as (
select TOP (@BatchDeleteRecords) *
from [CustomerSession] 
where LocalTime < @DeleteDataBeforeThisDate order by LocalTime asc
)
delete from CTE_Delete
print 'delete data from table: [CustomerSession] done';
------------------- 

--delete from [Flight] where [DepartureDate] <  @DeleteDataBeforeThisDate
--print 'delete data from table: [Flight] done'

with CTE_Delete as (
select TOP (@BatchDeleteRecords) *
from [Flight] 
where [DepartureDate] < @DeleteDataBeforeThisDate order by [DepartureDate] asc
)
delete from CTE_Delete
print 'delete data from table: [Flight] done';
------------------- 
--delete from Bag where NOT ID in
--(
--SELECT distinct [BagID]    
--FROM [BagWeightUpdate]
--where LocalTime >= @DeleteDataBeforeThisDate
--)
--print 'delete data from table: [Bag] done'


with CTE_Delete as (
select TOP (@BatchDeleteRecords) *
from Bag 
where  NOT ID in
(
SELECT distinct TOP (@BatchDeleteRecords) [BagID]    
FROM [BagWeightUpdate]
where LocalTime >= @DeleteDataBeforeThisDate 
)
)
delete from CTE_Delete
print 'delete data from table: [Bag] done';
------------------- 

--delete from [ExcessDetailsLog] 
--WHERE [CustomerSessionID] NOT in 
--(
--select ID from CustomerSession where LocalTime >= @DeleteDataBeforeThisDate
--)
--print 'delete data from table: [ExcessDetailsLog] done'

with CTE_Delete as (
select TOP (@BatchDeleteRecords) *
from [ExcessDetailsLog] 
where CustomerSessionID in
(
select TOP (@BatchDeleteRecords) ID FROM [CustomerSession] where LocalTime < @DeleteDataBeforeThisDate order by LocalTime asc)
)
delete from CTE_Delete
print 'delete data from table: [ExcessDetailsLog] done';
------------------- 

--delete from [FrequentFlyer] where not [CustomerSessionID] in
--(
--SELECT ID FROM [CustomerSession] where LocalTime < @DeleteDataBeforeThisDate   
--)
--print 'delete data from table: [FrequentFlyer] done'


with CTE_Delete as (
select TOP (@BatchDeleteRecords) *
from [FrequentFlyer] 
where not [CustomerSessionID] in
(
SELECT TOP (@BatchDeleteRecords) ID FROM [CustomerSession] where LocalTime < @DeleteDataBeforeThisDate order by LocalTime asc 
)
)
delete from CTE_Delete
print 'delete data from table: [FrequentFlyer] done';