declare @FromTime datetime = '2019-01-03'
declare @ToTime datetime = '2019-01-09'
declare @MessageType varchar(100) = '%'
declare @Terminal nvarchar(10) = '%'
declare @Area nvarchar(10) = '%'
declare @SubArea nvarchar(10) = '%'
declare @ABDStationIDs varchar(400) = '0'
declare @ABDStationNames varchar(4000) = '%'

;WITH ResponseTimeIntervals AS
(
	SELECT 0 AS FromMilliseconds, 1000 AS ToMilliseconds, '0000 - 1000 ms' AS TimeIntervalName
	UNION ALL
	SELECT 1001 AS FromMilliseconds, 2000 AS ToMilliseconds, '1001 - 2000 ms'
	UNION ALL
	SELECT 2001 AS FromMilliseconds, 3000 AS ToMilliseconds, '2001 - 3000 ms'
	UNION ALL
	SELECT 3001 AS FromMilliseconds, 4000 AS ToMilliseconds, '3001 - 4000 ms'
	UNION ALL
	SELECT 4001 AS FromMilliseconds, 5000 AS ToMilliseconds, '4001 - 5000 ms'
	UNION ALL
	SELECT 5001 AS FromMilliseconds, 6000 AS ToMilliseconds, '5001 - 6000 ms'
	UNION ALL
	SELECT 6001 AS FromMilliseconds, 7000 AS ToMilliseconds, '6001 - 7000 ms'
	UNION ALL
	SELECT 7001 AS FromMilliseconds, 9999999 AS ToMilliseconds, '> than 7000 ms'
)
SELECT ResponseTimeIntervals.TimeIntervalName, COUNT(CMOperationHistory.ID) NumberOfDCSMsgs,
	AVG(CMOperationHistory.MessageTime) AS AverageMessageTime, STDEV(CMOperationHistory.MessageTime) AS StandardDeviationMessageTime,
	MAX(CMOperationHistory.MessageTime) AS MaxMessageTime, MIN(CMOperationHistory.MessageTime) AS MinMessageTime
FROM CMOperationHistory
JOIN ResponseTimeIntervals
ON CMOperationHistory.MessageTime BETWEEN ResponseTimeIntervals.FromMilliseconds AND ResponseTimeIntervals.ToMilliseconds
INNER JOIN AbdStation ON CMOperationHistory.ABDStationID = AbdStation.ID
WHERE CMOperationHistory.MessageSent BETWEEN @FromTime AND @ToTime
	AND MessageType LIKE @MessageType
    AND (AbdStation.Terminal LIKE @Terminal )
    AND (ISNULL(AbdStation.Area,'') LIKE @Area )
    AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
    AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)

GROUP BY ResponseTimeIntervals.TimeIntervalName,ResponseTimeIntervals.FromMilliseconds
ORDER BY ResponseTimeIntervals.FromMilliseconds


select * from AbdStation where ID = 382954
select * from CMOperationHistory a inner join AbdStation b on a.ABDStationID = b.ID