declare @FromDateTime DateTime = '2018/02/01 00:00:00'
declare @ToDateTime DateTime = '2018/02/28 23:59:59'
declare @PassportType char(1) = '%'
declare @Terminal nvarchar(10) = '%'
declare @Area nvarchar(10) = '%'
declare @SubArea nvarchar(10) = '%'
declare @ABDStationIDs varchar(400) = '0'
declare @ABDStationNames varchar(4000) = '%';



WITH AgeSections AS
(
	SELECT 1 AS ID, '<14' AS AgeSection, 0 AS FromAge, 13 AS ToAge
	UNION ALL
	SELECT 2,'14-18',14,18
	UNION ALL
	SELECT 3,'19-25',19,25
	UNION ALL
	SELECT 3,'26-34',26,34
	UNION ALL
	SELECT 3,'35-44',35,44
	UNION ALL
	SELECT 3,'45-54',45,54
	UNION ALL
	SELECT 3,'55-64',55,64
	UNION ALL
	SELECT 4,'65+',65,200
)

SELECT AgeSections.ID, AgeSections.AgeSection AS PaxAge, COUNT(PassportInfo.ID) AS NumberOfPassportScans,
	COUNT(SuccessfulScans.ID) AS NumberOfPassportSuccessfulScans,
	ROUND(CONVERT(float,COUNT(SuccessfulScans.ID)) * 100.0 / CONVERT(float,COUNT(PassportInfo.ID)),2) AS SucessfulScanRate,
	@ABDStationNames AS ABDStations
FROM PassportInfo
LEFT JOIN PassportInfo AS SuccessfulScans 
ON SuccessfulScans.ID = PassportInfo.ID AND SuccessfulScans.IsVerifiedSucessfully = 1
JOIN AbdStation 
ON PassportInfo.AbdStationID = AbdStation.ID
JOIN AgeSections
ON DATEDIFF(hour,PassportInfo.DOB,GETDATE())/8766 BETWEEN AgeSections.FromAge AND AgeSections.ToAge
WHERE     PassportInfo.LocalCreationTime BETWEEN @FromDateTime AND @ToDateTime
	AND (@PassportType = '%' OR CAST(PassportInfo.IsRFIDPhoto AS char(1)) = @PassportType)
	AND (AbdStation.Terminal LIKE @Terminal )
	AND (ISNULL(AbdStation.Area,'') LIKE @Area )
	AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
	AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
GROUP BY AgeSections.ID, AgeSections.AgeSection
ORDER BY AgeSections.ID