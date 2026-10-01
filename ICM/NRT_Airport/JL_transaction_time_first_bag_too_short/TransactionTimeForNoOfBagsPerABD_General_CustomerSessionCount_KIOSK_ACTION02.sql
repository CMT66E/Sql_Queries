declare @FromDateTime DateTime = '2021-12-01 12:00:00 AM'
declare @ToDateTime DateTime = '2021-12-07 11:59:59 PM'

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
  WHERE AbdType = 'KSK' and Terminal = '2' -- Terminal 2: 19598  |||| Terminal 1: 3156
)
ORDER BY SessionDuration
