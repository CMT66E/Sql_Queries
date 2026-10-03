
--SP action: ThreeDScannerBagIssuePerABD

declare @FromDateTime DateTime = '2021/06/01 00:00:00'
declare @ToDateTime DateTime = '2021/06/01 23:59:59'    --- daily: 63  weekly: 131  monthly: 222
 
declare @Terminal nvarchar(10) = '%'
declare @Area nvarchar(10) = '%'
declare @SubArea nvarchar(10) = '%'
declare @ABDStationIDs varchar(400) = '0'
declare @ABDStationNames varchar(4000) = 'Display All ABDs'


SELECT  dbo.GetAbdName(AbdStation.Identifier,AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea) AS AbdStation, 
	FaultType.ID AS FaultTypeID, FaultType.ShortName,BagWeightUpdate.NumberOfAcceptedBags, SUM(ABDErrorLog.NumberOfErrors) as NumberOfErrors
INTO #Temp
FROM (SELECT ABDStationID,FaultTypeID,COUNT(ID) AS NumberOfErrors 
		FROM ABDErrorLog 
		WHERE LocalCreationTime BETWEEN @FromDateTime AND @ToDateTime
		GROUP BY ABDStationID,FaultTypeID) AS ABDErrorLog 
JOIN FaultType ON ABDErrorLog.FaultTypeID = FaultType.ID 
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

GROUP BY dbo.GetAbdName(AbdStation.Identifier,AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea), FaultType.ID,FaultType.ShortName,BagWeightUpdate.NumberOfAcceptedBags
ORDER BY dbo.GetAbdName(AbdStation.Identifier,AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea)

Select  AbdStation,ShortName,1 as FaultTypeID,SUM(NumberOfAcceptedBags)NumberOfAcceptedBags,SUM(NumberOfErrors) NumberOfErrors from #Temp
Group By AbdStation,ShortName
Order by AbdStation
