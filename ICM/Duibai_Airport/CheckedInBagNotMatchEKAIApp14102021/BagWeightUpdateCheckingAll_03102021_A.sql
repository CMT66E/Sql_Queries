/****** Script for SelectTopNRows command from SSMS  ******/ --774350 -> 774375
SELECT a.[ID]
      ,[BagID]
      ,[Weight]
      ,[UtcTime]
      ,[CustomerSessionID]
      ,a.[LocalTime]
	  ,b.*
  FROM [CUSSBagDropDB_DXB].[dbo].[BagWeightUpdate] a inner join CustomerSession b on a.CustomerSessionID = b.ID
  WHERE cast(a.[LocalTime] as date) = '2021-10-03' and (a.ID >= 774350 and a.ID <= 774376)
  order by a.ID

SELECT [ID]
      ,[BagID]
      ,[Weight]
      ,[UtcTime]
      ,[CustomerSessionID]
      ,[LocalTime]
  FROM [CUSSBagDropDB_DXB].[dbo].[BagWeightUpdate]
  WHERE cast([LocalTime] as date) = '2021-10-03'  -- 4997 records
  order by ID

SELECT [ID]
      ,[BagID]
      ,[Weight]
      ,[UtcTime]
      ,[CustomerSessionID]
      ,[LocalTime]
  FROM [CussReportingDB_DXB].[dbo].[BagWeightUpdate]
  WHERE cast([LocalTime] as date) = '2021-10-03' -- 4835 records it shorts 162 records
    order by ID

  --missing rows
  SELECT [ID]
      ,[BagID]
      ,[Weight]
      ,[UtcTime]
      ,[CustomerSessionID]
      ,[LocalTime]
  FROM [CUSSBagDropDB_DXB].[dbo].[BagWeightUpdate]
  WHERE cast([LocalTime] as date) = '2021-10-03'  -- 4997 records
  and not ID in 
  (
SELECT [ID]
    FROM [CussReportingDB_DXB].[dbo].[BagWeightUpdate]
  WHERE cast([LocalTime] as date) = '2021-10-03' -- 4835 records it shorts 162 records
  )
    order by ID