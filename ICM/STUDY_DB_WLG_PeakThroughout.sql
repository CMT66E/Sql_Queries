/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [Date]
      ,[FromTime]
      ,[ToTime]
	  ,substring([TimeSlotName], 13, 5) as [TimeSlotName]
      ,[NumberOfBags]
  FROM [STUDY_DB].[dbo].[WLG_PeakThroughout]

SELECT [Date]
      ,[FromTime]
      ,[ToTime]
	  ,substring([TimeSlotName], 13, 5) as [TimeSlotName]
      ,[NumberOfBags]
  FROM [STUDY_DB].[dbo].[WLG_PeakThroughout]


  update  [STUDY_DB].[dbo].[WLG_PeakThroughout] set  DATEPART(YEAR, [Date]) = 2023
  where DATEPART(YEAR, [Date]) = 2022