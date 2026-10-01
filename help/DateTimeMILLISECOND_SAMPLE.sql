/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [ID]
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
  FROM [CussReportingDB_DXB].[dbo].[CustomerSession]
  order by [ID] desc

  select  cast(cast(DATEDIFF(MILLISECOND, '2021-10-14 05:30:51.867', '2021-10-14 05:32:59.100') as decimal(10, 2))/1000 as decimal(10,3)) as DurationInSeconds
  select  cast(DATEDIFF(MILLISECOND, '2021-10-14 05:30:51.867', '2021-10-14 05:32:59.100')/1000 AS decimal(7,2)) as DurationInSeconds