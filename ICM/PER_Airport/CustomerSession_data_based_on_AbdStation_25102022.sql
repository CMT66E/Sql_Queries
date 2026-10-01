USE CUSSReportingDB_PER
GO
declare @ReportMonthFirstDay DateTime = '2022/09/01 00:00:00'

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
  FROM [CustomerSession] a
WHERE 
datepart(year, a.[LocalTime]) = datepart(year, @ReportMonthFirstDay) and datepart(month, a.[LocalTime]) = datepart(month, @ReportMonthFirstDay) 
and [UtcCreationTime] > [UtcCompletionTime]
and [AbdStationID] <> 117
order by a.SessionDuration asc

select * from AbdStation where ID in
(
SELECT [AbdStationID]
FROM [CustomerSession] a
WHERE 
datepart(year, a.[LocalTime]) = datepart(year, @ReportMonthFirstDay) and datepart(month, a.[LocalTime]) = datepart(month, @ReportMonthFirstDay) 
and [UtcCreationTime] > [UtcCompletionTime]
)

