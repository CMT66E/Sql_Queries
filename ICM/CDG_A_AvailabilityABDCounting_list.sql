/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [ID]
      ,[Date]
      ,[ABDStationID]
      ,[StateTimeSlotID]
      ,[ABDStateID]
      ,[MinutesInState]
  FROM [ReportingDB_CDG].[dbo].[ABDAvailability]

  where datepart(year, ABDAvailability.Date) = 2022 
  --and datepart(month, ABDAvailability.Date) = 7


  select * from CUSSReportingDB_CDG.dbo.AbdStation where Terminal IN ('2E','2F','2G','W') and Area iN('Z04','Z05','Z06','Z05','Z06','Z01','H2A','H2B','H2C','H3B')
  order by Terminal, Area