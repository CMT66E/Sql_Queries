  declare @FromDateTime DateTime = '2026/02/24 00:00:00 AM'

  SELECT  [ID]
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
  FROM [ReportingDB_NRT_FEB2026].[dbo].[BagWeightUpdate]
  WHERE [CustomerSessionID] in 
  (
6389814
  )

  select * from [ReportingDB_NRT_FEB2026].[dbo].[CustomerSession]
  WHERE ID in
  (
6389814
  ) 
  -----------------------------

  SELECT  [ID]
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
  WHERE [CustomerSessionID] in 
  (
6389814
  )

  select * from [ReportingDB_NRT].[dbo].[CustomerSession]
  WHERE ID in
  (
6389814
  ) 
 

  SELECT 
       a.[ID]
      ,[BagID]
      ,[Weight]
      ,[UtcTime]
      ,[CustomerSessionID]
      ,a.[TimeSlot5minID]
      ,a.[TimeSlot10minID]
      ,a.[TimeSlotHourlyID]
      ,a.[DayOfTheWeekID]
      ,a.[LocalTime]
      ,a.[AbdStationID]
      ,b.*
      ,c.*
  FROM [ReportingDB_NRT].[dbo].[BagWeightUpdate] a 
  inner join [ReportingDB_NRT].[dbo].[CustomerSession] b on a.CustomerSessionID = b.ID
  inner join [ReportingDB_NRT].[dbo].[Flight] c on b.FlightID = c.ID
  WHERE a.[CustomerSessionID] in 
  (
6389814
  )
