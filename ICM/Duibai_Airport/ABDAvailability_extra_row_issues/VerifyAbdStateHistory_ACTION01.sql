/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [ID]
      ,[AbdStationID]
      ,[State]
      ,[UtcTime]
      ,[LocalTime]
  FROM [CUSSReportingDB_STR].[dbo].[AbdStateHistory]
  WHERE [AbdStationID] = 1 
  and cast(LocalTime as date) = '2021-02-07'
  order by LocalTime desc

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [ID]
      ,[AbdStationID]
      ,[State]
      ,[UtcTime]
      ,[LocalTime]
  FROM [CUSSReportingDB_STR].[dbo].[AbdStateHistory]
  WHERE [AbdStationID] = 24 
  and cast(LocalTime as date) = '2021-02-07'
  order by LocalTime desc
