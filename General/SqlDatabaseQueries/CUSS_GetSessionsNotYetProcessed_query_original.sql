

SELECT        AbdStationID, AirlineId, ApplicationSessionUsageProcessID, CussApplicationId, CussSessionId, LocalEndTime, LocalStartTime, Processed, UTCEndTime, UTCStartTime
FROM            ApplicationSessionUsageProcess
WHERE        (Processed = 0)
ORDER BY LocalStartTime