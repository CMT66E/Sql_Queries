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