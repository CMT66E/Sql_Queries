declare @FromDateTime DateTime = '2021-09-01 12:00:00 AM'
declare @ToDateTime DateTime = '2021-09-01 11:59:59 PM'

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
  WHERE AbdType = 'KSK' and Terminal = '2' -- Terminal 2: 19598 
)
ORDER BY [SessionDuration]



SELECT  
       cast([LocalTime] as date) as LocalTimeFinal
      , count(ID) as DailyCount
FROM [CUSSReportingDB_NRT].[dbo].[CustomerSession]
Where LocalTime BETWEEN @FromDateTime AND @ToDateTime
AND 
AbdStationID in 
(
  SELECT ID
  FROM [CUSSReportingDB_NRT].[dbo].[AbdStation]
  WHERE AbdType = 'KSK' and Terminal = '2' -- Terminal 2: 19598 
)
GROUP BY cast([LocalTime] as date)
ORDER BY cast([LocalTime] as date)