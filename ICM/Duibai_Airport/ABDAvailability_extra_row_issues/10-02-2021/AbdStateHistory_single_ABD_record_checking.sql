/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [ID]
      ,[AbdStationID]
      ,[State]
      ,[UtcTime]
      ,[LocalTime]
  FROM [CUSSBagDropDB_DXB].[dbo].[AbdStateHistory]
  WHERE [AbdStationID] = 1107 and cast(LocalTime as Date) = '2021-01-28'
  order by [LocalTime] desc