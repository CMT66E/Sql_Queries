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

--comments added by Eric He 01-10-2026 