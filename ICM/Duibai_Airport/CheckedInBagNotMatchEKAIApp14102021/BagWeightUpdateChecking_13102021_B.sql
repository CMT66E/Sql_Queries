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
  FROM [CUSSBagDropDB_DXB].[dbo].[CustomerSession]
   WHERE cast([LocalCreationTime] as date) = '2021-10-13' and (ID >= 1242740 and ID <= 1242813)


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
  FROM [CUSSBagDropDB_DXB].[dbo].[CustomerSession]
   WHERE cast([LocalCreationTime] as date) = '2021-10-13' --7021

SELECT [ID]
      ,[CustomerID]
      ,[AbdStationID]
      ,[CustomerLookupType]
      ,[PNR]
      ,[FlightID]
      ,[UtcCreationTime]
      ,[UtcCompletionTime]
      ,[LocalTime]      
  FROM [CUSSReportingDB_DXB].[dbo].[CustomerSession]
   WHERE cast([LocalTime] as date) = '2021-10-13'   --6435  it shorts 586 records


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
  FROM [CUSSBagDropDB_DXB].[dbo].[CustomerSession]
   WHERE cast([LocalCreationTime] as date) = '2021-10-13' and [ID] not in
   (
   SELECT [ID]
  FROM [CUSSReportingDB_DXB].[dbo].[CustomerSession]
   WHERE cast([LocalTime] as date) = '2021-10-13'    
   )
   order by [ID]