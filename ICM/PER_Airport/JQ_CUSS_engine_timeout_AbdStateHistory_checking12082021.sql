/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [ID]
      ,[AbdStationID]
      ,[State]
      ,[UtcTime]
      ,[LocalTime]
  FROM [CUSSBagDropDB_JQ].[dbo].[AbdStateHistory]
  where AbdStationID = 1
  order by ID desc

select count(*) FROM [CUSSBagDropDB_JQ].[dbo].[AbdStateHistory] --3540012

SELECT TOP (1000) [ID]
      ,[AbdStationID]
      ,[State]
      ,[UtcTime]
      ,[LocalTime]
  FROM [CUSSReportingDB_JQ].[dbo].[AbdStateHistory]
  where AbdStationID = 1
  order by ID desc

select count(*) FROM [CUSSReportingDB_JQ].[dbo].[AbdStateHistory] --19144
  --3120071