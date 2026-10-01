
--SELECT top (100) *
--  FROM [CUSSReportingDB_HKG].[dbo].[ApplicationSessionUsage]
--  order by [ID] desc

--select TOP (100) * 
--FROM [CUSSReportingDB_HKG].[dbo].[ApplicationSessionUsageProcess]
--order by ApplicationSessionUsageProcessID desc

-----------------------------------------------------------------------------------------
--SELECT top (100) *
--  FROM [CUSSReportingDB_HKG].[dbo].[ApplicationSessionUsage]
--  order by [ID] desc

--select ABDStationID, max([Date]) as MaxReachedDate
--  FROM [CUSSReportingDB_HKG].[dbo].[ApplicationSessionUsage]
--group by ABDStationID 
--order by MaxReachedDate

--SELECT count(*) as TotalCount
--  FROM [CUSSReportingDB_HKG].[dbo].[ApplicationSessionUsage]
---------------------------------------------------------------------------------------
select count(*) as ApplicationSessionUsageProcessCount from [CUSSReportingDB_LHR].[dbo].ApplicationSessionUsageProcess

select AbdStationID, max(LocalStartTime) as MaxReachedDate 
from [CUSSReportingDB_LHR].[dbo].ApplicationSessionUsageProcess 
group by AbdStationID 
order by MaxReachedDate
---------------------------------------------------------------------------------------

select top 100 * from ApplicationSessionUsageProcess order by ApplicationSessionUsageProcessID desc

SELECT        MAX(ApplicationSessionUsageProcessID) AS LastID
FROM            [CUSSReportingDB_LHR].[dbo].ApplicationSessionUsageProcess
---------------------------------------------------------------------------------------
SELECT        ApplicationSession.ApplicationSessionId, ApplicationSession.LocalStartTime, ApplicationSession.UTCStartTime, ApplicationSession.LocalEndTime, ApplicationSession.UTCEndTime, ApplicationSession.CussSessionId, 
                         ApplicationSession.CussApplicationId, ApplicationSession.AirlineId, CussSession.AbdStationId
FROM            [CUSSBagDropDB_LHR].[dbo].ApplicationSession INNER JOIN
                         [CUSSBagDropDB_LHR].[dbo].CussSession ON ApplicationSession.CussSessionId = CussSession.CussSessionId
--WHERE        (ApplicationSession.ApplicationSessionId > 169568)  --need to process 131 records from [CUSSBagDropDB_HKG] 
order by ApplicationSession.ApplicationSessionId desc
----------------------------------------------------------------------------------------

SELECT        AbdStationID, AirlineId, ApplicationSessionUsageProcessID, CussApplicationId, CussSessionId, LocalEndTime, LocalStartTime, Processed, UTCEndTime, UTCStartTime
FROM            ApplicationSessionUsageProcess
WHERE        (Processed = 0)
-----------------------------------------------------------------------------------------
SELECT        ApplicationSession.ApplicationSessionId, ApplicationSession.LocalStartTime, ApplicationSession.UTCStartTime, ApplicationSession.LocalEndTime, ApplicationSession.UTCEndTime, ApplicationSession.CussSessionId, 
                         ApplicationSession.CussApplicationId, ApplicationSession.AirlineId, CussSession.AbdStationId
FROM            [CUSSBagDropDB_LHR].[dbo].ApplicationSession INNER JOIN
                         [CUSSBagDropDB_LHR].[dbo].CussSession ON ApplicationSession.CussSessionId = CussSession.CussSessionId
WHERE        (ApplicationSession.ApplicationSessionId > 9683414)


