/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [ID]
      ,[AbdStationID]
      ,[State]
      ,[UtcTime]
      ,[LocalTime]
  FROM [CUSSReportingDB_LHR].[dbo].[AbdStateHistory]
  order by ID desc

SELECT  

  DISTINCT  [AbdStationID], Max(ID)
       
  FROM [CUSSReportingDB_LHR].[dbo].[AbdStateHistory]
  group by  [AbdStationID], ID
  