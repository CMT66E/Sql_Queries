USE [CUSSBagDropDB_PER]
GO

SELECT   [ID]
    ,[PortCode]
    ,[Identifier]
    ,[AbdType]
    ,[Terminal]
    ,[KioskName]
    ,[Zone]
    ,[Area]
    ,[SubArea]
FROM [AbdStation]
where AbdType = 'KSK' and ID = 113 and Area = 'K'

select * from AbdModeHistory where AbdStationID = 113
select * from AbdStateHistory where AbdStationID = 113
select * from AbdWayfinderStateHistory where AbdStationID = 113
select * from CussSession where AbdStationID = 113 
select * from CustomerSession where ApplicationSessionId in (select ApplicationSessionId from ApplicationSession where CussSessionId in (select CussSessionId from CussSession where AbdStationID = 113 ))
select * from ApplicationSession where CussSessionId in (select CussSessionId from CussSession where AbdStationID = 113 )

-------------------------------

USE [CUSSBagDropDB_PER]
GO

delete from AbdModeHistory where AbdStationID = 113
delete from AbdStateHistory where AbdStationID = 113           --total 6817 records will be deleted
delete from AbdWayfinderStateHistory where AbdStationID = 113  --total 6817 records will be deleted
delete from CustomerSession where ApplicationSessionId in (select ApplicationSessionId from ApplicationSession where CussSessionId in (select CussSessionId from CussSession where AbdStationID = 113 )) 
delete from ApplicationSession where CussSessionId in (select CussSessionId from CussSession where AbdStationID = 113 )
delete from CussSession where AbdStationID = 113               --total 4 records will be deleted
delete from [CUSSBagDropDB_PER].[dbo].[AbdStation]
where AbdType = 'KSK' and ID = 113 and Area = 'K'

