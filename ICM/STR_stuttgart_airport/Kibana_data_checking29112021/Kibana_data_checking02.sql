/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [ID]
      ,[CustomerID]
      ,[AbdStationID]
      ,[CustomerLookupType]
      ,[PNR]
      ,[FlightID]
      ,[UtcCreationTime]
      ,[UtcCompletionTime]
      ,[LocalCreationTime]
      ,[LocalCompletionTime]
      ,[ApplicationSessionId]
  FROM [CUSSBagDropDB_STR].[dbo].[CustomerSession]
  WHERE datepart(year, [UtcCreationTime]) = 2021 and datepart(month, [UtcCreationTime]) = 10  
  order by ID desc

  select * from CUSSReportingDB_STR.[dbo].[CustomerSession] 
  WHERE 
  datepart(year, [UtcCreationTime]) = 2021 and 
  datepart(month, [UtcCreationTime]) = 10 
  and 
  SessionDuration <3
  order by ID desc