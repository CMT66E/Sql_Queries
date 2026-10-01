/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [AirlineGroupID]
      ,[GroupName]
      ,[GroupDescription]
  FROM [ReportingDB_SIN].[dbo].[AirlineGroup]

SELECT TOP (1000) [AGMID]
      ,[AirlineGroupID]
      ,[AirlineCode]
      ,[AirlineName]
  FROM [ReportingDB_SIN].[dbo].[AirlineGroupMapping]