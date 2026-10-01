/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [ID]
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
  FROM [CUSSBagDropDB].[dbo].[CustomerSession]
  WHERE [ApplicationSessionId] = 591695

SELECT TOP 100 [ApplicationSessionId], count(*) as ApplicationSessionCount
  FROM [CUSSBagDropDB].[dbo].[CustomerSession]
  group by [ApplicationSessionId]

SELECT TOP (1000) 
       [ApplicationSessionId]
      ,[LocalStartTime]
      ,[UTCStartTime]
      ,[LocalEndTime]
      ,[UTCEndTime]
      ,[CussSessionId]
      ,[CussApplicationId]
      ,[AirlineId]
  FROM [CUSSBagDropDB].[dbo].[ApplicationSession]
  WHERE [ApplicationSessionId] = 591695

  SELECT TOP (1000) [CussSessionId]
      ,[LocalStartTime]
      ,[UTCStartTime]
      ,[LocalEndTime]
      ,[UTCEndTime]
      ,[AbdStationId]
  FROM [CUSSBagDropDB].[dbo].[CussSession]
  WHERE  [CussSessionId] = 11289

