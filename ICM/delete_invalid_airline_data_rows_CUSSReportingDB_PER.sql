USE [CUSSReportingDB_PER]
GO
--Remove invalid Airline data: Airlines with names as digital numbers such as: 086, 160, 803

SELECT [ID]
      ,[Airline]
      ,[AirlineDescription]
FROM [Airlines]
WHERE [ID]  in (1, 2, 6)

select * from [ApplicationSessionUsage] where [AirlineId]  in (1, 2, 6)  -- it has 492 records

delete from [CustomerSession] where FlightID  in (select ID from [Flight] WHERE [MarketingCarrier] in ('086', '106', '803'))
delete from [ApplicationSessionUsage] where [AirlineId]  in (1, 2, 6)
delete from [ApplicationSessionUsageProcess] where [AirlineId]  in (1, 2, 6)
delete from [Airlines] where [ID]  in (1, 2, 6)


select * from [ApplicationSession] where [AirlineId]  in (1, 2, 6)  -- it has 492 records

delete from [CustomerSession] where [ApplicationSessionId]  in (select ApplicationSessionId from [ApplicationSession] where [AirlineId]  in (1, 2, 6))
delete from [ApplicationSession] where [AirlineId]  in (1, 2, 6)
delete from [Airline] where [AirlineId]  in (1, 2, 6)


delete from AbdModeHistory where AbdStationID = 113
delete from AbdStateHistory where AbdStationID = 113           --total 6817 records will be deleted
delete from AbdWayfinderStateHistory where AbdStationID = 113  --total 6817 records will be deleted
delete from CustomerSession where ApplicationSessionId in (select ApplicationSessionId from ApplicationSession where CussSessionId in (select CussSessionId from CussSession where AbdStationID = 113 )) 
delete from ApplicationSession where CussSessionId in (select CussSessionId from CussSession where AbdStationID = 113 )
delete from CussSession where AbdStationID = 113               --total 4 records will be deleted
delete from [CUSSBagDropDB_PER].[dbo].[AbdStation]
where AbdType = 'KSK' and ID = 113 and Area = 'K'