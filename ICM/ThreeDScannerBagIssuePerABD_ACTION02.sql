
--SP action: ThreeDScannerBagIssuePerABD

declare @FromDateTime DateTime = '2026/02/01 00:00:00'
declare @ToDateTime DateTime = '2026/02/28 23:59:59'    --- daily: 63  weekly: 131  monthly: 222
 
declare @Terminal nvarchar(10) = '%'
declare @Area nvarchar(10) = '%'
declare @SubArea nvarchar(10) = '%'
declare @ABDStationIDs varchar(400) = '0'
declare @ABDStationNames varchar(4000) = 'Display All ABDs'

DROP TABLE IF EXISTS #Temp;
DROP TABLE IF EXISTS #TempAbdStation;

select 	ID,
                   (SELECT CASE WHEN ISNULL(AbdStation.Terminal,'') <> '' AND ISNULL(AbdStation.Area,'') <> '' AND ISNULL(AbdStation.SubArea,'') <> ''
						THEN (case when LEN(AbdStation.Terminal) > 1 then 'T' else 'T0' end) + AbdStation.Terminal + '_' + AbdStation.Area + '_' + AbdStation.SubArea + '_' + AbdStation.Identifier
					WHEN ISNULL(AbdStation.Terminal,'') <> '' AND ISNULL(AbdStation.Area,'') <> '' AND ISNULL(AbdStation.SubArea,'') = ''
						THEN (case when LEN(AbdStation.Terminal) > 1 then 'T' else 'T0' end) + AbdStation.Terminal + '_' + AbdStation.Area + '_' + AbdStation.Identifier
					WHEN ISNULL(AbdStation.Terminal,'') <> '' And (select Count(*) From abdstation Where  (ABDType ='ABD' or ABDType ='BDS') and Terminal <> @Terminal) > 0
						THEN (case when LEN(AbdStation.Terminal) > 1 then 'T' else 'T0' end) + AbdStation.Terminal + '_'  + AbdStation.Identifier + '  '
					WHEN ISNULL(AbdStation.Terminal,'') ='' AND  ISNULL(AbdStation.Area,'') <> ''
						THEN AbdStation.Area+ '_'  + AbdStation.Identifier
					ELSE AbdStation.Identifier END) AS AbdStation
into #TempAbdStation
from ABDStation


SELECT  
    #TempAbdStation.AbdStation AS AbdStation,
	FaultType.ID AS FaultTypeID, 
	FaultType.ShortName,
	BagWeightUpdate.NumberOfAcceptedBags, 
	SUM(ABDErrorLog.NumberOfErrors) as NumberOfErrors
INTO #Temp
FROM (SELECT ABDStationID,FaultTypeID,COUNT(ID) AS NumberOfErrors 
		FROM ABDErrorLog 
		WHERE LocalCreationTime BETWEEN @FromDateTime AND @ToDateTime
		GROUP BY ABDStationID,FaultTypeID) AS ABDErrorLog 
JOIN FaultType ON ABDErrorLog.FaultTypeID = FaultType.ID 
JOIN #TempAbdStation on ABDErrorLog.AbdStationID = #TempAbdStation.ID
JOIN AbdStation ON ABDErrorLog.AbdStationID = AbdStation.ID  
JOIN (SELECT AbdStationID, COUNT(ID) AS NumberOfAcceptedBags 
		FROM BagWeightUpdate 
		WHERE LocalTime BETWEEN @FromDateTime AND @ToDateTime
		GROUP BY AbdStationID) AS BagWeightUpdate 
	ON BagWeightUpdate.AbdStationID = AbdStation.ID
WHERE FaultType.ID IN ( SELECT ID FROM FaultType 
						WHERE ShortName IN ('OverMaxNumberOf3DReScan',
											'ThreeDScannerFault',
											'BagOversizedBy3D',
											'BagUndersizedBy3D',
											'BagWithStraps',
											'BagIrregular',
											'BagInKeepOutArea',
											'MultiBagScan',
											'UprightBagScan'))

	AND (AbdStation.Terminal LIKE @Terminal )
	AND (ISNULL(AbdStation.Area,'') LIKE @Area )
	AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
	AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)

GROUP BY #TempAbdStation.AbdStation, 
FaultType.ID,FaultType.ShortName,BagWeightUpdate.NumberOfAcceptedBags
ORDER BY #TempAbdStation.AbdStation

Select  AbdStation,ShortName,1 as FaultTypeID,SUM(NumberOfAcceptedBags)NumberOfAcceptedBags,SUM(NumberOfErrors) NumberOfErrors from #Temp
Group By AbdStation,ShortName
Order by AbdStation
