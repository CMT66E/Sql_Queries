/****** Script for SelectTopNRows command from SSMS  ******/
SELECT  [ID]
      ,[Date]
      ,[ABDStationID]
      ,[StateTimeSlotID]
      ,[ABDStateID]
      ,[MinutesInState]
	  --,cast([Date] as date) as DateSimple
  FROM [CussReportingDB_DXB].[dbo].[ABDAvailability]
  WHERE cast([Date] as date) = '2021-10-22' and StateTimeSlotID = 23
  order by ID desc

  update     [CussReportingDB_DXB].[dbo].[ABDAvailability] set [Date] = '2021-10-22', StateTimeSlotID = 24
  WHERE cast([Date] as date) = '2021-10-22' and StateTimeSlotID = 23