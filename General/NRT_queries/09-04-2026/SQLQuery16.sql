  declare @FromDateTime DateTime = '2026/02/24 00:00:00 AM'

  SELECT TOP (1000) [ID]
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
  FROM [CUSSReportingDB_NRT_FEB2026].[dbo].[BagWeightUpdate]
  WHERE ID in 
  (
    8018198,
    8022647,
    8161440,
    8165002,
    7999967
  )

  select * from [CUSSReportingDB_NRT_FEB2026].[dbo].[CustomerSession]
  WHERE ID in
  (
    13628151,
    13660110,
    13915585
  ) 
  -----------------------------

  SELECT TOP (1000) a.[ID]
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
  FROM [CUSSReportingDB_NRT].[dbo].[BagWeightUpdate] a 
  inner join [CUSSReportingDB_NRT].[dbo].[CustomerSession] b on a.CustomerSessionID = b.ID
  inner join [CUSSReportingDB_NRT].[dbo].[Flight] c on b.FlightID = c.ID
  WHERE a.ID in 
  (
    8018198,
    8022647,
    8161440,
    8165002,
    7999967
  )


  select * from [CUSSReportingDB_NRT].[dbo].[CustomerSession] a
  inner join [CUSSReportingDB_NRT].[dbo].[BagWeightUpdate] b on a.ID = b.CustomerSessionID
  inner join [CUSSReportingDB_NRT].[dbo].[Flight] c on a.FlightID = c.ID
  WHERE a.ID in
  (
    13628151,
    13660110,
    13915585
  )


  select * from [CUSSReportingDB_NRT].[dbo].[CustomerSession] where ID = 13557527