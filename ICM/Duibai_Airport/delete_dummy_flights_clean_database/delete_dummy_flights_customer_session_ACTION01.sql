/****** Script for SelectTopNRows command from SSMS  ******/
SELECT  MarketingCarrier, COUNT(MarketingCarrier) as NumberOfOccurrences
FROM [dbo].[Flight]   
GROUP BY MarketingCarrier
--HAVING COUNT(MarketingCarrier) < 10
order by COUNT(MarketingCarrier)

SELECT  ID, MarketingCarrier, COUNT(MarketingCarrier) as NumberOfOccurrences
FROM [dbo].[Flight]   
GROUP BY ID, MarketingCarrier
HAVING MarketingCarrier = '9C'
order by COUNT(MarketingCarrier)

select * from [dbo].[Flight]   
where MarketingCarrier = '9C'

--select a.*, b.MarketingCarrier from CustomerSession a INNER JOIN [Flight] b on a.FlightID = b.ID
--where b.MarketingCarrier in 
--(
--	SELECT MarketingCarrier
--	FROM [CussReportingDB_DXB].[dbo].[Flight]   
--	GROUP BY MarketingCarrier
--	HAVING COUNT(MarketingCarrier) < 10	 
--)

------------------------------------------------------------------------------------------------------------

--delete from [CussReportingDB_DXB].[dbo].[CustomerSession]
--where FlightID in
--(
--	select b.ID from CustomerSession a INNER JOIN [Flight] b on a.FlightID = b.ID
--	where b.MarketingCarrier in 
--	(
--		SELECT MarketingCarrier
--		FROM [CussReportingDB_DXB].[dbo].[Flight]   
--		GROUP BY MarketingCarrier
--		HAVING COUNT(MarketingCarrier) < 10	 
--	)
--)

--delete from [CussReportingDB_DXB].[dbo].[Flight]   
--where MarketingCarrier in
--(
--	SELECT MarketingCarrier
--	FROM [CussReportingDB_DXB].[dbo].[Flight]   
--	GROUP BY MarketingCarrier
--	HAVING COUNT(MarketingCarrier) < 10	
--)

------------------------------------------------------------------------------------------------------------
  --SELECT [ID]
  --    ,[Date]
  --    ,[ABDStationID]
  --    ,[AirlineID]
  --    ,[CussApplicationID]
  --    ,[MinutesInState]
  --FROM [CussReportingDB_DXB].[dbo].[ApplicationSessionUsage]
  --WHERE [AirlineID] <> 1

  --delete from [CussReportingDB_DXB].[dbo].[ApplicationSessionUsage]
  --WHERE [AirlineID] <> 1

  --SELECT *
  --FROM [CussReportingDB_DXB].[dbo].[ApplicationSessionUsageProcess]
  --WHERE [AirlineID] <> 1

------------------------------------------------------------------------------------------------------------
