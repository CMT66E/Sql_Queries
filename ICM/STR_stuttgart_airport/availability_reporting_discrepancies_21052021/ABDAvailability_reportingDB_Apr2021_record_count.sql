/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [ID]
      ,[Date]
      ,[ABDStationID]
      ,[StateTimeSlotID]
      ,[ABDStateID]
      ,[MinutesInState]
  FROM [CUSSReportingDB_STR].[dbo].[ABDAvailability]
  WHERE DatePart(year, [Date]) = 2021 and DatePart(month, [Date]) = 4  -- March 2021 has 139500 records APRIL only has 91603 much less somehow
  and [ABDStationID] > 30
  order by [ABDStationID]

  SELECT [ABDStationID], count([ABDStationID]) as OccurrenceCount       
  FROM [CUSSReportingDB_STR].[dbo].[ABDAvailability]
  WHERE DatePart(year, [Date]) = 2021 and DatePart(month, [Date]) = 3 and ABDStateID = 3  -- 3 is In Error state
  group by [ABDStationID]


  SELECT [ABDStationID], count([ABDStationID]) as OccurrenceCount       
  FROM [CUSSReportingDB_STR].[dbo].[ABDAvailability]
  WHERE DatePart(year, [Date]) = 2021 and DatePart(month, [Date]) = 4 and ABDStateID = 3  -- 3 is In Error state
  group by [ABDStationID]


