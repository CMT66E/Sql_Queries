/****** Script for SelectTopNRows command from SSMS  ******/
  --SELECT TOP (1000) [ID]
  --    ,[Date]
  --    ,[ABDStationID]
  --    ,[StateTimeSlotID]
  --    ,[ABDStateID]
  --    ,[MinutesInState]
  --FROM [ReportingDB].[dbo].[ABDAvailability]


  SELECT 
      [ABDStationID], max([Date]) as ProcessedDateRecordedByDB     
  FROM [ReportingDB].[dbo].[ABDAvailability]
  group by  [ABDStationID]
 