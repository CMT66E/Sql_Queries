/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [ID]
      ,[MarketingCarrier]
      ,[FlightNumber]
      ,[DepartureDate]
      ,[BoardPoint]
      ,[OffPoint]
	  ,cast([DepartureDate] as time) as TimeOnly
	  ,convert(char(5), [DepartureDate], 108) as TimeSimple
  FROM [BagDropDB_PER].[dbo].[Flight]
where 
cast([DepartureDate] as time) <> '00:00:00.0000000'
--cast([DepartureDate] as time) ='00:00:00.0000000'
--MarketingCarrier in ('NZ', 'EK', 'CX')

--support_CX_PER done
--support_NZ_PER
--support_EK_PER done