SELECT        MAX(ApplicationSessionId) AS LastID
FROM [CUSSBagDropDB_LHR].[dbo].ApplicationSession

SELECT        MAX(ApplicationSessionUsageProcessID) AS LastID
FROM [CUSSReportingDB_LHR].[dbo].ApplicationSessionUsageProcess
----------------------------------------------------------------------------
declare @MaxApplicationSessionIdCUSSBagDropDB bigint, @MaxApplicationSessionUsageProcessIDCUSSReportingDB bigint

SELECT        @MaxApplicationSessionIdCUSSBagDropDB = MAX(ApplicationSessionId) 
FROM [CUSSBagDropDB_LHR].[dbo].ApplicationSession

SELECT    @MaxApplicationSessionUsageProcessIDCUSSReportingDB =    MAX(ApplicationSessionUsageProcessID) 
FROM [CUSSReportingDB_LHR].[dbo].ApplicationSessionUsageProcess

print 'There are total: ' + cast(@MaxApplicationSessionIdCUSSBagDropDB - @MaxApplicationSessionUsageProcessIDCUSSReportingDB as varchar) + ' records needed to be transferred'
select cast(@MaxApplicationSessionIdCUSSBagDropDB - @MaxApplicationSessionUsageProcessIDCUSSReportingDB as varchar) as ToBeProcessedCount

-- we only process 100 records from [CUSSBagDropDB_LHR].[dbo].ApplicationSession
-- so we use 9683414 - 100 = 9683314
-- it means we need reset [CUSSReportingDB_LHR].[dbo].ApplicationSessionUsageProcess  MAX(ApplicationSessionUsageProcessID) value from 3652687 -> 9683314
--then we need set all ABDs current processed date to a few days earlier only 

--Access data from DB: [CUSSBagDropDB]
SELECT TOP (1000) *
  FROM [CUSSBagDropDB_LHR].[dbo].ApplicationSession
  order by 1 desc

--Access data from DB: [CUSSReportingDB_LHR]
SELECT TOP (1000) [ID]
      ,[Date]
      ,[ABDStationID]
      ,[AirlineID]
      ,[CussApplicationID]
      ,[MinutesInState]
  FROM [CUSSReportingDB_LHR].[dbo].[ApplicationSessionUsage]
  order by ID desc
-----------------------------------------------------------------
SELECT TOP (1000) [ApplicationSessionUsageProcessID]
      ,[LocalStartTime]
      ,[UTCStartTime]
      ,[LocalEndTime]
      ,[UTCEndTime]
      ,[AbdStationID]
      ,[CussSessionId]
      ,[CussApplicationId]
      ,[AirlineId]
      ,[Processed]
  FROM [CUSSReportingDB_LHR].[dbo].[ApplicationSessionUsageProcess]
  order by [ApplicationSessionUsageProcessID] desc