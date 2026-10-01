declare @FromDateTime DateTime = '2021-11-01 12:00:00 AM'
declare @ToDateTime DateTime = '2021-11-30 11:59:59 PM'

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
FROM [CUSSReportingDB_NRT].[dbo].[CustomerSession]
Where LocalTime BETWEEN @FromDateTime AND @ToDateTime
AND 
AbdStationID in 
(
  SELECT ID
  FROM [CUSSReportingDB_NRT].[dbo].[AbdStation]
  WHERE AbdType = 'KSK' and Terminal = '2' -- Terminal 2: 14673 
)
ORDER BY SessionDuration


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
FROM [CUSSReportingDB_NRT].[dbo].[CustomerSession]
Where LocalTime BETWEEN @FromDateTime AND @ToDateTime
AND 
AbdStationID in 
(
  SELECT ID
  FROM [CUSSReportingDB_NRT].[dbo].[AbdStation]
  WHERE AbdType = 'KSK' and Terminal = '2' -- Terminal 2 
)
AND
[SessionDuration] = 0 -- Terminal 2 with SessionDuration = 0 has 1699 records
ORDER BY SessionDuration


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
FROM [CUSSReportingDB_NRT].[dbo].[CustomerSession]
Where LocalTime BETWEEN @FromDateTime AND @ToDateTime
AND 
AbdStationID in 
(
  SELECT ID
  FROM [CUSSReportingDB_NRT].[dbo].[AbdStation]
  WHERE AbdType = 'KSK' and Terminal = '2' -- Terminal 2 
)
AND
[SessionDuration] > 0 and [SessionDuration] <= 40 -- Terminal 2 with SessionDuration > 0 and SessionDuration <= 40 has 10611 records
ORDER BY SessionDuration


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
FROM [CUSSReportingDB_NRT].[dbo].[CustomerSession]
Where LocalTime BETWEEN @FromDateTime AND @ToDateTime
AND 
AbdStationID in 
(
  SELECT ID
  FROM [CUSSReportingDB_NRT].[dbo].[AbdStation]
  WHERE AbdType = 'KSK' and Terminal = '2' -- Terminal 2 
)
AND
[SessionDuration] > 0 and [SessionDuration] >= 40 -- Terminal 2 and SessionDuration > 0 and SessionDuration >= 40 has 2364 records
ORDER BY SessionDuration
