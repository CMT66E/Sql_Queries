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
  FROM [ReportingDB_NRT].[dbo].[BagWeightUpdate]
  WHERE datepart(year, [LocalTime]) = 2026 and datepart(month, [LocalTime]) = 2 and datepart(day, [LocalTime]) in (18)
  and [AbdStationID] in
  (
    SELECT ID
    FROM [ReportingDB_NRT].[dbo].[AbdStation]
    WHERE [Terminal] ='3' and [Area] = 'N' and [SubArea] = 'C'
  )
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
  FROM [ReportingDB_NRT].[dbo].[BagWeightUpdate]
  WHERE datepart(year, [LocalTime]) = 2026 and datepart(month, [LocalTime]) = 2 and datepart(day, [LocalTime]) in (19, 20, 21, 22, 23, 24, 25, 26, 27, 28)
  and [AbdStationID] in
  (
    SELECT ID
    FROM [ReportingDB_NRT].[dbo].[AbdStation]
    WHERE [Terminal] ='3' and [Area] = 'N' and [SubArea] = 'C'
  )
  order by ID desc