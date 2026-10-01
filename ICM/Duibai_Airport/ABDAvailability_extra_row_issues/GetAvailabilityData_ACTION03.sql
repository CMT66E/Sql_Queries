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
  WHERE [Date] = '2021-02-03' and a.ABDStationID = 1107 and MinutesInState > 0
  order by [ID]

  select count(*) from [CussReportingDB_DXB].[dbo].[ABDAvailability] a INNER JOIN AbdStation b ON a.ABDStationID = b.ID
  WHERE [Date] = '2021-02-03' and a.ABDStationID = 1107 and MinutesInState > 0
   
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
WHERE [Date] = '2021-02-03' and a.ABDStationID = 1038 and MinutesInState > 0
order by [StateTimeSlotID]

select count(*) from [CussReportingDB_DXB].[dbo].[ABDAvailability] a INNER JOIN AbdStation b ON a.ABDStationID = b.ID
WHERE [Date] = '2021-02-03' and a.ABDStationID = 1038 and MinutesInState > 0