/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [ID]
      ,[CustomerID]
      ,[AbdStationID]
      ,[CustomerLookupType]
      ,[PNR]
      ,[UtcCreationTime]
      ,[FlightID]
      ,[UtcCompletionTime]
      ,[LocalCreationTime]
      ,[LocalCompletionTime]
      ,[MachineTime]
      ,[PaxTime]
      ,[DcsTime]
      ,[BhsTime]
      ,[CsaTime]
      ,[NumberOfTubs]
      ,[IsReceiptPrinted]
 
	  ,cast(FLOOR(cast(DATEDIFF(MILLISECOND, [LocalCreationTime], [LocalCompletionTime]) as decimal(10, 0))/1000) as decimal(10,0))	as SessionDuration
  FROM [BagDropDB_QF_NEW].[dbo].[CustomerSession]
  order by ID desc