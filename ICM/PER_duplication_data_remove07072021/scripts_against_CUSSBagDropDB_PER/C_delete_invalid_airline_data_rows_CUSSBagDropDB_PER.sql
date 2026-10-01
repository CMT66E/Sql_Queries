USE [CUSSBagDropDB_PER]
GO
--Remove invalid Airline data: Airlines with names as digital numbers such as: 086, 160, 803

SELECT [AirlineId]
      ,[Name]
      ,[Description]
FROM [Airline]
WHERE [AirlineId]  in (1, 2, 6)

select * from [ApplicationSession] where [AirlineId]  in (1, 2, 6)  -- it has 492 records

delete from [CustomerSession] where [ApplicationSessionId]  in (select ApplicationSessionId from [ApplicationSession] where [AirlineId]  in (1, 2, 6))
delete from [ApplicationSession] where [AirlineId]  in (1, 2, 6)
delete from [Airline] where [AirlineId]  in (1, 2, 6)

 