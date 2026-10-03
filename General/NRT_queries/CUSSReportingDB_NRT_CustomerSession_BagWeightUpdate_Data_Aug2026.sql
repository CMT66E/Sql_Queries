declare @UpdateMonthFirstDay datetime = '2026-07-01'

SELECT [ID]
      ,[CustomerID]
      ,[AbdStationID]
      ,[CustomerLookupType]
      ,[PNR]
      ,[UtcCreationTime]
      ,[FlightID]
      ,[TimeSlot5minID]
      ,[TimeSlot10minID]
      ,[TimeSlotHourlyID]
      ,[DayOfTheWeekID]
      ,[LocalTime]
      ,[UtcCompletionTime]
      ,[SessionDuration]
  FROM [CUSSReportingDB_NRT].[dbo].[CustomerSession] -- 372,584 -AUG2026 | 430,115 -JUL2026
  WHERE DATEPART(year,  [LocalTime]) = DATEPART(year, @UpdateMonthFirstDay) and DATEPART(month,  [LocalTime]) = DATEPART(month, @UpdateMonthFirstDay)
  order by ID desc



SELECT [ID]
      ,[BagID]
      ,[Weight]
      ,[UtcTime]
      ,[CustomerSessionID]
      ,[TimeSlot5minID]
      ,[TimeSlot10minID]
      ,[TimeSlotHourlyID]
      ,[DayOfTheWeekID]
      ,[LocalTime]
      ,[AbdStationID]
  FROM [CUSSReportingDB_NRT].[dbo].[BagWeightUpdate] -- 5,676 -AUG2026 | 297,999 -JUL2026
  WHERE DATEPART(year,  [LocalTime]) = DATEPART(year, @UpdateMonthFirstDay) and DATEPART(month,  [LocalTime]) = DATEPART(month, @UpdateMonthFirstDay)
  order by ID desc