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
  WHERE AbdType = 'KSK' and Terminal = '1' -- Terminal 1: 2250 
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
  WHERE AbdType = 'KSK' and Terminal = '1' -- Terminal 1  
)
AND
[SessionDuration] = 0 -- Terminal 1 with SessionDuration = 0 conditions there are only 3 records
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
  WHERE AbdType = 'KSK' and Terminal = '1' -- Terminal 1 
)
AND
[SessionDuration] > 0 and [SessionDuration] <= 40 -- Terminal 1 and SessionDuration > 0 and SessionDuration <= 40 only has 412 records
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
  WHERE AbdType = 'KSK' and Terminal = '1' -- Terminal 1 
)
AND
[SessionDuration] > 0 and [SessionDuration] >= 40 -- Terminal 1 and SessionDuration > 0 and SessionDuration >= 40 has 1832 records
ORDER BY SessionDuration
