/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (10) [ID]
      ,[CustomerSessionID]
      ,[Carrier]
      ,[Number]
      ,[CmTierCode]
      ,[AirlinePriority]
      ,[Description]
      ,[DoNotPrintInReceipt]
  FROM [BagDrop_QF_New].[dbo].[FrequentFlyer]
  order by [ID] desc

SELECT TOP (10) [ID]
      ,[CustomerSessionID]
      ,[Carrier]
      ,[Number]
      ,[CmTierCode]
      ,[AirlinePriority]
      ,[Description]
      ,[DoNotPrintInReceipt]
  FROM [ReportingDB_QF_New].[dbo].[FrequentFlyer]
  order by [ID] desc