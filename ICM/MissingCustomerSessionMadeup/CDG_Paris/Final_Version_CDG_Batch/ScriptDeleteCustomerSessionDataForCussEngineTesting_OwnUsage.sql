 
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
  FROM [CUSSReportingDB_CDG].[dbo].[CustomerSession]
  WHERE ID >= 23894884
  order by ID desc

  delete from [CUSSReportingDB_CDG].[dbo].[CustomerSession]
  WHERE ID >= 23894884