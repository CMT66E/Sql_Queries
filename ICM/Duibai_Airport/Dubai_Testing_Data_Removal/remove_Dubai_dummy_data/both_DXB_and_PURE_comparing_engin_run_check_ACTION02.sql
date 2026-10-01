/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [ID]
      ,[Date]
      ,[ABDStationID]
      ,[AirlineID]
      ,[CussApplicationID]
      ,[MinutesInState]
  FROM [CussReportingDB_DXB_PURE].[dbo].[ApplicationSessionUsage]
  --WHERE [ABDStationID] = 1038 and [Date] = '2021-01-28'
  order by [Date] desc
------------------------------------------------------------------------------------------------------------------------------------------
select count(*) FROM [CussReportingDB_DXB].[dbo].[ApplicationSessionUsage]
select count(*) FROM [CussReportingDB_DXB].[dbo].[ApplicationSessionUsageProcess]
select count(*) FROM [CussReportingDB_DXB].[dbo].[ABDAvailability]

select count(*) FROM [CussReportingDB_DXB_PURE].[dbo].[ApplicationSessionUsage]
select count(*) FROM [CussReportingDB_DXB_PURE].[dbo].[ApplicationSessionUsageProcess]
select count(*) FROM [CussReportingDB_DXB_PURE].[dbo].[ABDAvailability]

select * from [CussReportingDB_DXB].[dbo].[ABDAvailability] WHERE [ABDStationID] = 1038 and [Date] = '2021-02-20' order by Date desc
select * from [CussReportingDB_DXB].[dbo].[ABDAvailability] WHERE [ABDStationID] = 1038 and [Date] = '2021-02-21' order by Date desc
select * from [CussReportingDB_DXB].[dbo].[ABDAvailability] WHERE [ABDStationID] = 1038 and [Date] = '2021-02-22' order by Date desc

select * from [CussReportingDB_DXB_PURE].[dbo].[ABDAvailability] WHERE [ABDStationID] = 26 and [Date] = '2021-02-20' order by Date desc
select * from [CussReportingDB_DXB_PURE].[dbo].[ABDAvailability] WHERE [ABDStationID] = 26 and [Date] = '2021-02-21' order by Date desc
select * from [CussReportingDB_DXB_PURE].[dbo].[ABDAvailability] WHERE [ABDStationID] = 26 and [Date] = '2021-02-22' order by Date desc
------------------------------------------------------------------------------------------------------------------------------------------
select count(*) FROM [CUSSReportingDB_AMM].[dbo].[ApplicationSessionUsage]
select count(*) FROM [CUSSReportingDB_AMM].[dbo].[ApplicationSessionUsageProcess]
select count(*) FROM [CUSSReportingDB_AMM].[dbo].[ABDAvailability]

select * from [CUSSReportingDB_AMM].[dbo].[ABDAvailability] WHERE [ABDStationID] = 8 and [Date] = '2021-02-19'
select * from [CUSSReportingDB_AMM].[dbo].[ABDAvailability] WHERE [ABDStationID] = 8 and [Date] = '2021-02-20' order by Date desc
------------------------------------------------------------------------------------------------------------------------------------------
--checking other databases
select * from [CUSSReportingDB_STR_PURE].[dbo].[ABDAvailability] WHERE [ABDStationID] = 8 and [Date] = '2021-02-20' order by Date desc
select * from [CUSSReportingDB_STR_PURE].[dbo].[ABDAvailability] WHERE [ABDStationID] = 8 and [Date] = '2021-02-21' order by Date desc
select * from [CUSSReportingDB_STR_PURE].[dbo].[ABDAvailability] WHERE [ABDStationID] = 8 and [Date] = '2021-02-22' order by Date desc
select * from [CUSSReportingDB_STR_PURE].[dbo].[ABDAvailability] WHERE [ABDStationID] = 8 and [Date] = '2021-02-23' order by Date desc

select * from [CUSSReportingDB_AMM].[dbo].[ABDAvailability] WHERE [ABDStationID] = 8 and [Date] = '2021-02-20' order by Date desc
select * from [CUSSReportingDB_AMM].[dbo].[ABDAvailability] WHERE [ABDStationID] = 8 and [Date] = '2021-02-21' order by Date desc
select * from [CUSSReportingDB_AMM].[dbo].[ABDAvailability] WHERE [ABDStationID] = 8 and [Date] = '2021-02-22' order by Date desc
select * from [CUSSReportingDB_AMM].[dbo].[ABDAvailability] WHERE [ABDStationID] = 8 and [Date] = '2021-02-23' order by Date desc
-----------------------------------------------------------checking flights on Dubai airport CUSSReportingDB_DXB-----------------------------------------
   SELECT TOP (1000) [ID]
      ,[MarketingCarrier]
      ,[FlightNumber]
      ,[DepartureDate]
      ,[BoardPoint]
      ,[OffPoint]
   FROM [CussReportingDB_DXB].[dbo].[Flight]
   where MarketingCarrier not in ('EK', 'FZ') 


   SELECT  [MarketingCarrier], count(*)
   FROM [CussReportingDB_DXB].[dbo].[Flight]
   group by [MarketingCarrier]