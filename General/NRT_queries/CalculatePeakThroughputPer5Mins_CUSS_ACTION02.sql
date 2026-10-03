
declare @FromDate datetime = '2026-06-01 00:00:00'
declare @ToDateTime datetime ='2026-06-30 23:59:59'
declare @Terminal nvarchar(10) = '%'
declare @Area nvarchar(10) = '%'
declare @SubArea nvarchar(10) ='%'
declare @ABDStationIDs varchar(400) = ',150,158,164,151,159,160,157,161,162,163,167,166,165,153,147,148,149,152,154,155,144,145,156,146,'  --'144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167'
declare @ABDStationNames varchar(4000) = 'T3_L_S_ABD_001,T3_L_S_ABD_002,T3_L_S_ABD_003,T3_L_S_ABD_004,T3_L_S_ABD_005,T3_L_S_ABD_006,T3_L_S_ABD_007,T3_L_S_ABD_008,T3_L_S_ABD_009,T3_L_S_ABD_010,T3_L_S_ABD_011,T3_L_S_ABD_012,T3_L_S_ABD_013,T3_L_S_ABD_014,T3_L_S_ABD_015,T3_L_S_ABD_016,T3_L_S_ABD_017,T3_L_S_ABD_018,T3_L_S_ABD_019,T3_L_S_ABD_020,T3_L_S_ABD_021,T3_L_S_ABD_022,T3_L_S_ABD_023,T3_L_S_ABD_024'

DROP TABLE IF EXISTS #tempNumberOfBagsAt5MinsIntervals
-----------------------------------------------------------

;WITH DayIntervals AS
(
	SELECT @FromDate AS Date
	UNION ALL
	SELECT DATEADD(DAY, 1, Date) AS Date
	FROM DayIntervals 
	WHERE DATEADD(DAY, 1, Date) <= @ToDateTime
)

--Caculate number of bags checked in per 5 mins
SELECT DayIntervals.Date, 
	DATEADD(HOUR,DATEPART(HOUR,TimeSlot5min.FromTime),DATEADD(MINUTE,DATEPART(MINUTE,TimeSlot5min.FromTime),DATEADD(SECOND,DATEPART(SECOND,TimeSlot5min.FromTime),DayIntervals.Date))) AS FromTime,
	TimeSlot5min.ToTime,
	TimeSlot5min.TimeSlotName, 
	COUNT(BagWeightUpdate.ID) AS NumberOfBags
	INTO #tempNumberOfBagsAt5MinsIntervals
FROM DayIntervals
CROSS JOIN TimeSlot5min
JOIN BagWeightUpdate
ON CONVERT(DATE, BagWeightUpdate.LocalTime) = DayIntervals.Date 
	AND BagWeightUpdate.TimeSlot5minID = TimeSlot5min.ID
JOIN AbdStation
ON AbdStation.ID = BagWeightUpdate.AbdStationID
	AND (AbdStation.Terminal LIKE @Terminal)
	AND (ISNULL(AbdStation.Area,'') LIKE @Area )
	AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
	AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
GROUP BY DayIntervals.Date, TimeSlot5min.FromTime,TimeSlot5min.ToTime,TimeSlot5min.TimeSlotName
OPTION (MAXRECURSION 0)

select * from #tempNumberOfBagsAt5MinsIntervals -- June 2026:  2,368 records | May 2026: 5,872 records

--Calculate Peak Throughput Per 5 Mins
SELECT #tempNumberOfBagsAt5MinsIntervals.* 
FROM #tempNumberOfBagsAt5MinsIntervals
JOIN 
	(
		SELECT Date,MAX(NumberOfBags) AS MaxNumberOfBags
		FROM #tempNumberOfBagsAt5MinsIntervals
		GROUP BY Date
	) A
ON #tempNumberOfBagsAt5MinsIntervals.Date = A.Date AND NumberOfBags = MaxNumberOfBags
ORDER BY Date,FromTime
OPTION (MAXRECURSION 0)
