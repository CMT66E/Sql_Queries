
USE [CUSSBagDropDB_NRT]
GO

DECLARE @MyTable TABLE
(
SNo int IDENTITY(1,1), 
AbdStationID int
) 

insert into @MyTable(AbdStationID)
SELECT   [ID]
FROM [AbdStation]
where ID in
(
12,
13,
11,
14,
15,
17,
16,
18,
19,
101,
103,
102,
104,
109,
105,
106,
107
)
--select AbdStationID from @MyTable

--select * from AbdModeHistory where AbdStationID in (select AbdStationID from @MyTable)
--select * from AbdStateHistory where AbdStationID in (select AbdStationID from @MyTable)          --total 6817 records will be deleted
--select * from AbdWayfinderStateHistory where AbdStationID in (select AbdStationID from @MyTable)  --total 6817 records will be deleted
--select * from CustomerSession where ApplicationSessionId in (select ApplicationSessionId from ApplicationSession where CussSessionId in (select CussSessionId from CussSession where AbdStationID in (select AbdStationID from @MyTable) )) 
--select * from ApplicationSession where CussSessionId in (select CussSessionId from CussSession where AbdStationID in (select AbdStationID from @MyTable))
--select * from CussSession where AbdStationID in (select AbdStationID from @MyTable)               --total 4 records will be deleted
--select * from [CUSSBagDropDB_PER].[dbo].[AbdStation]
--where ID in (select AbdStationID from @MyTable)

----------------------------------------------------------

delete from AbdModeHistory where AbdStationID in (select AbdStationID from @MyTable)           --total 0 record will be deleted
delete from AbdStateHistory where AbdStationID in (select AbdStationID from @MyTable)          --total 864120 records will be deleted
delete from AbdWayfinderStateHistory where AbdStationID in (select AbdStationID from @MyTable)  --total 864458 records will be deleted
delete from CustomerSession where ApplicationSessionId in (select ApplicationSessionId from ApplicationSession where CussSessionId in (select CussSessionId from CussSession where AbdStationID in (select AbdStationID from @MyTable) )) 
delete from ApplicationSession where CussSessionId in (select CussSessionId from CussSession where AbdStationID in (select AbdStationID from @MyTable))
delete from CussSession where AbdStationID in (select AbdStationID from @MyTable)               --total 4 records will be deleted
delete from [AbdStation] where ID in (select AbdStationID from @MyTable)