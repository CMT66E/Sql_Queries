USE ReportingDB_QF_New
GO

declare @DeleteDataBeforeThisDate datetime = '2022-08-31' 

--delete from [CMOperationHistory]
--where [MessageSent] <  @DeleteDataBeforeThisDate
--print 'delete data from table: [CMOperationHistory] done'

delete from QBagTagReadLog
where [LocalLogTime] <  @DeleteDataBeforeThisDate
print 'delete data from table: [QBagTagReadLog] done'
delete from QBagTagReadSuccessData
where not QBagTagReadLogID in (select ID from QBagTagReadLog where [LocalLogTime] <  @DeleteDataBeforeThisDate)
print 'delete data from table: [QBagTagReadSuccessData] done'

delete from QBagTagWriteLog
where [LocalLogTime] <  @DeleteDataBeforeThisDate
print 'delete data from table: [QBagTagReadLog] done'
delete from QBagTagWriteSuccessData
where not QBagTagWriteLogID in (select ID from QBagTagWriteLog where [LocalLogTime] <  @DeleteDataBeforeThisDate)
print 'delete data from table: [QBagTagReadSuccessData] done'


delete from [PaperTagReadLog]
where [LocalLogTime] <  @DeleteDataBeforeThisDate
print 'delete data from table: [CMOperationHistory] done'

delete from [PaperTagReadSuccessData]
where not PaperTagReadLogID in (select ID from [PaperTagReadLog])
print 'delete data from table: [PaperTagReadSuccessData] done'

delete from [PaperTagReadSuccessData]
where not PaperTagReadLogID in (select ID from [PaperTagReadLog])
print 'delete data from table: [PaperTagReadSuccessData] done'

delete from [CustomerSessionTimeOnEachScreen]
where CustomerSessionID in
(
    SELECT ID FROM [CustomerSession] where LocalTime < @DeleteDataBeforeThisDate   
)

DELETE FROM [ABDErrorLog]
where [LocalCreationTime] < @DeleteDataBeforeThisDate
print 'delete data from table: [ABDErrorLog] done'

DELETE FROM [ABDAvailability]
where [Date] <  @DeleteDataBeforeThisDate
print 'delete data from table: [ABDAvailability] done'

delete from [CMOperationHistory]
where [MessageSent] <  @DeleteDataBeforeThisDate
print 'delete data from table: [CMOperationHistory] done'

delete from [PaperTagReadLog]
where [LocalLogTime] < @DeleteDataBeforeThisDate
print 'delete data from table: [PaperTagReadLog] done'

------------------- major delete actions as below ---------------------
delete from [BagWeightUpdate]
where CustomerSessionID in
(
    SELECT ID FROM [CustomerSession] where LocalTime < @DeleteDataBeforeThisDate
)
print 'delete data from table: [BagWeightUpdate] done'

delete from [CustomerSessionTimeOnEachScreen]
where CustomerSessionID in
(
    SELECT ID FROM [CustomerSession] where LocalTime < @DeleteDataBeforeThisDate   
)
print 'delete data from table: [CustomerSessionTimeOnEachScreen] done'

delete from [CustomerSession] where LocalTime < @DeleteDataBeforeThisDate
print 'delete data from table: [CustomerSession] done'

delete from [Flight] where [DepartureDate] <  @DeleteDataBeforeThisDate
print 'delete data from table: [Flight] done'

delete from Bag where NOT ID in
(
SELECT distinct [BagID]    
FROM [ReportingDB_QF_New].[dbo].[BagWeightUpdate]
where LocalTime >= @DeleteDataBeforeThisDate
)
print 'delete data from table: [Bag] done'


delete from [ExcessDetailsLog] 
WHERE [CustomerSessionID] NOT in 
(
select ID from CustomerSession where LocalTime >= @DeleteDataBeforeThisDate
)
print 'delete data from table: [ExcessDetailsLog] done'


delete from [FrequentFlyer] where not [CustomerSessionID] in
(
SELECT ID FROM [CustomerSession] where LocalTime < @DeleteDataBeforeThisDate   
)
print 'delete data from table: [FrequentFlyer] done'