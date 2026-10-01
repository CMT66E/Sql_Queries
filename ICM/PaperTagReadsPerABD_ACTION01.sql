

declare @FromDateTime DateTime = '2021/10/02 00:00:00'
declare @ToDateTime DateTime = '2021/10/02 23:59:59'
declare @CLVShortName nvarchar(100)  = '%'
declare @Terminal nvarchar(10) = '%'
declare @Area nvarchar(10) = '%'
declare @SubArea nvarchar(10) = '%'
declare @ABDStationIDs varchar(400) = '0'
declare @ABDStationNames varchar(4000) = 'Display All ABDs'


SELECT     PaperTagReadLog.PaperTagReadStepID, COUNT(PaperTagReadLog.ID) AS PaperTagReads,
		dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea,AbdStation.AbdType) AS AbdStationName,
		PaperTagReadStep.Heading, PaperTagReadStep.Description
FROM        PaperTagReadLog
INNER JOIN AbdStation ON PaperTagReadLog.AbdStationID = AbdStation.ID 
INNER JOIN PaperTagReadStep ON PaperTagReadLog.PaperTagReadStepID = PaperTagReadStep.ID AND PaperTagReadLog.WasReadSuccessful = 1
LEFT JOIN PaperTagReadScanner ON PaperTagReadScanner.PaperTagReadLogID = PaperTagReadLog.ID
LEFT JOIN ClvScannerType ON ClvScannerType.ID = PaperTagReadScanner.ClvScannerTypeID
						  
WHERE     (PaperTagReadLog.LocalLogTime BETWEEN @FromDateTime AND @ToDateTime)
	AND (ClvScannerType.ShortName LIKE @CLVShortName)
	AND (AbdStation.Terminal LIKE @Terminal )
	 AND (ISNULL(AbdStation.Area,'') LIKE @Area )
	 AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
	 AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
GROUP BY AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea,AbdStation.AbdType, PaperTagReadLog.PaperTagReadStepID,  PaperTagReadStep.Heading,PaperTagReadStep.Description
ORDER BY dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea,AbdStation.AbdType),PaperTagReadStep.Heading

DECLARE @MyTable TABLE
	(
	PaperTagReadStepID bigint, 
	PaperTagReads int,
	AbdStationName nvarchar(50),
	Heading nvarchar(50),
	Description nvarchar(100)
	)  

insert into @MyTable
SELECT     PaperTagReadLog.PaperTagReadStepID, COUNT(PaperTagReadLog.ID) AS PaperTagReads,
		dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea,AbdStation.AbdType) AS AbdStationName,
		PaperTagReadStep.Heading, PaperTagReadStep.Description 
FROM        PaperTagReadLog
INNER JOIN AbdStation ON PaperTagReadLog.AbdStationID = AbdStation.ID 
INNER JOIN PaperTagReadStep ON PaperTagReadLog.PaperTagReadStepID = PaperTagReadStep.ID AND PaperTagReadLog.WasReadSuccessful = 1
LEFT JOIN PaperTagReadScanner ON PaperTagReadScanner.PaperTagReadLogID = PaperTagReadLog.ID
LEFT JOIN ClvScannerType ON ClvScannerType.ID = PaperTagReadScanner.ClvScannerTypeID
						  
WHERE     (PaperTagReadLog.LocalLogTime BETWEEN @FromDateTime AND @ToDateTime)
	AND (ClvScannerType.ShortName LIKE @CLVShortName)
	AND (AbdStation.Terminal LIKE @Terminal )
	 AND (ISNULL(AbdStation.Area,'') LIKE @Area )
	 AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
	 AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
GROUP BY AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea,AbdStation.AbdType, PaperTagReadLog.PaperTagReadStepID,  PaperTagReadStep.Heading,PaperTagReadStep.Description
ORDER BY dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea,AbdStation.AbdType),PaperTagReadStep.Heading

select 
	PaperTagReadStepID, 
	sum(PaperTagReads) as PaperTagReads,
	AbdStationName,
	Heading,
	Description 
from @MyTable
group by PaperTagReadStepID, AbdStationName, Heading, Description 