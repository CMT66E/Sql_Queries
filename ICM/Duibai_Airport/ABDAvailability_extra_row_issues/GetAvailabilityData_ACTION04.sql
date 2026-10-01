/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (10000) a.[ID]
      ,[Date]
      ,[ABDStationID]
      ,[StateTimeSlotID]
      ,[ABDStateID]
	  ,b.Identifier
	  ,b.KioskName
      ,[MinutesInState]
  FROM [CussReportingDB_DXB].[dbo].[ABDAvailability] a INNER JOIN AbdStation b ON a.ABDStationID = b.ID
  WHERE [Date] = '2021-01-28' and a.ABDStationID = 1107 and MinutesInState > 0
  order by [StateTimeSlotID]

  --25 * 60 = 1500

  /****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (10000) a.[ID]
      ,[Date]
      ,[ABDStationID]
      ,[StateTimeSlotID]
      ,[ABDStateID]
	  ,b.Identifier
	  ,b.KioskName
      ,[MinutesInState]
  FROM [CussReportingDB_DXB].[dbo].[ABDAvailability] a INNER JOIN AbdStation b ON a.ABDStationID = b.ID
  WHERE [Date] = '2021-01-28' and a.ABDStationID = 1038 and MinutesInState > 0
  order by [StateTimeSlotID]