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
  FROM [CUSSBagDropDB_DXB].[dbo].[CustomerSession]
  WHERE ID = 61

  select * from [CUSSBagDropDB_DXB].[dbo].ApplicationSession where ApplicationSessionId = 164

  select * from [CUSSBagDropDB_DXB].[dbo].CussSession where CussSessionId = 31