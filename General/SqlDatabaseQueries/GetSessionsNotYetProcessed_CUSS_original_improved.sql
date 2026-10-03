SELECT [ApplicationSessionUsageProcessID]
      ,[LocalStartTime]
      ,[UTCStartTime]
      ,[LocalEndTime]
      ,[UTCEndTime]
      ,[AbdStationID]
      ,[CussSessionId]
      ,[CussApplicationId]
      ,[AirlineId]
      ,[Processed]
  FROM [CUSSReportingDB_NRT].[dbo].[ApplicationSessionUsageProcess]
  WHERE DATEDIFF(day, [LocalEndTime], getdate()) < 60


SELECT        AbdStationID, AirlineId, ApplicationSessionUsageProcessID, CussApplicationId, CussSessionId, LocalEndTime, LocalStartTime, Processed, UTCEndTime, UTCStartTime
FROM            ApplicationSessionUsageProcess
WHERE        DATEDIFF(day, [LocalEndTime], getdate()) < 60 and (Processed = 0)
ORDER BY LocalStartTime

