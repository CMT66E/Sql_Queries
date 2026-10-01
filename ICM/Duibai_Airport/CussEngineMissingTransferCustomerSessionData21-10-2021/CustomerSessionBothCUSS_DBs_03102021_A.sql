/****** Script for SelectTopNRows command from SSMS  ******/
SELECT  a.[ID]
      ,[CustomerID]
      ,a.[AbdStationID]
      ,[CustomerLookupType]
      ,[PNR]
      ,[FlightID]
      ,[UtcCreationTime]
      ,[UtcCompletionTime]
      ,[LocalCreationTime]
      ,[LocalCompletionTime]
      ,[ApplicationSessionId]
	  ,b.*
  FROM [CUSSBagDropDB_DXB].[dbo].[CustomerSession] a INNER JOIN [CussReportingDB_DXB].[dbo].BagWeightUpdate  b ON a.ID = b.CustomerSessionID
   WHERE cast([LocalCreationTime] as date) = '2021-10-03'
 order by [LocalCreationTime] desc