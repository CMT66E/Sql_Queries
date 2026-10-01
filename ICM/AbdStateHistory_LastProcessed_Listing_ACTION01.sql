/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [ID]
      ,[Date]
      ,[ABDStationID]
      ,[StateTimeSlotID]
      ,[ABDStateID]
      ,[MinutesInState]
  FROM [CUSSReportingDB_LHR].[dbo].[ABDAvailability]
  order by ID desc

  SELECT ISNULL(MAX(ID),0) AS LastProcessedID, AbdStationID FROM dbo.AbdStateHistory
  group by AbdStationID 