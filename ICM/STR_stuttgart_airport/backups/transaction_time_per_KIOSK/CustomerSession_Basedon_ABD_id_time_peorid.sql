/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [ID]
      ,[PortCode]
      ,[Identifier]
      ,[AbdType]
      ,[Terminal]
      ,[KioskName]
      ,[Zone]
      ,[Area]
      ,[SubArea]
  FROM [CUSSReportingDB_STR].[dbo].[AbdStation]

  declare     @FromDateTime DateTime = '2021-01-01 00:00:00'
  declare     @ToDateTime DateTime = '2021-01-31 23:59:59'
  select * from CustomerSession where AbdStationID = 19 and LocalTime BETWEEN @FromDateTime AND @ToDateTime