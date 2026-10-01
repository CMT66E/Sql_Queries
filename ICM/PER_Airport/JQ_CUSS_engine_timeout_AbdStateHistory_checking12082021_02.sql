USE CUSSReportingDB_PER
GO
declare @ReportMonthFirstDay DateTime = '2022/08/01 00:00:00'

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
  FROM [CUSSReportingDB_PER].[dbo].[CustomerSession] a
WHERE 
datepart(year, a.[LocalTime]) = datepart(year, @ReportMonthFirstDay) and datepart(month, a.[LocalTime]) = datepart(month, @ReportMonthFirstDay) 
and [UtcCreationTime] > [UtcCompletionTime]
order by a.SessionDuration asc