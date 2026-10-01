/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [ID]
      ,[Date]
      ,[ABDStationID]
      ,[StateTimeSlotID]
      ,[ABDStateID]
      ,[MinutesInState]
  FROM [CUSSReportingDB_DXB].[dbo].[ABDAvailability]
  WHERE DatePart(year, [Date]) = 2021 and DatePart(month, [Date]) = 10 and DatePart(day, [Date]) = 13  
  order by ID desc

  update [CUSSReportingDB_DXB].[dbo].[ABDAvailability] set [Date] = '2021-11-17'
  WHERE DatePart(year, [Date]) = 2021 and DatePart(month, [Date]) = 10 and DatePart(day, [Date]) = 13 