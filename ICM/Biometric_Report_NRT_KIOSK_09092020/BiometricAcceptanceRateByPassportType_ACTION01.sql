declare @FromDateTime DateTime = '2018/02/01 00:00:00'
declare @ToDateTime DateTime = '2018/02/28 23:59:59'
declare @PassportType char(1) = '%'
declare @Terminal nvarchar(10) = '%'
declare @Area nvarchar(10) = '%'
declare @SubArea nvarchar(10) = '%'
declare @ABDStationIDs varchar(400) = '0'
declare @ABDStationNames varchar(4000) = '%';


SELECT PassportInfo.IsRFIDPhoto AS IsEPassport, 
	COUNT(PassportInfo.ID) AS NumberOfPassportScans,
	COUNT(SuccessfulScans.ID) AS NumberOfPassportSuccessfulScans,
	ROUND(CONVERT(float,COUNT(SuccessfulScans.ID)) * 100.0 / CONVERT(float,COUNT(PassportInfo.ID)),2) AS SucessfulScanRate,
	@ABDStationNames AS ABDStations
FROM PassportInfo
LEFT JOIN PassportInfo AS SuccessfulScans 
ON SuccessfulScans.ID = PassportInfo.ID AND SuccessfulScans.IsVerifiedSucessfully = 1
JOIN AbdStation ON PassportInfo.AbdStationID = AbdStation.ID
WHERE     PassportInfo.LocalCreationTime BETWEEN @FromDateTime AND @ToDateTime
	AND (AbdStation.Terminal LIKE @Terminal )
	AND (ISNULL(AbdStation.Area,'') LIKE @Area )
	AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
	AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
GROUP BY PassportInfo.IsRFIDPhoto

SELECT PassportInfo.IsRFIDPhoto AS IsEPassport, 
	PassportInfo.ID,
	SuccessfulScans.ID AS NumberOfPassportSuccessfulScans,

	@ABDStationNames AS ABDStations
FROM PassportInfo
LEFT JOIN PassportInfo AS SuccessfulScans 
ON SuccessfulScans.ID = PassportInfo.ID AND SuccessfulScans.IsVerifiedSucessfully = 1
JOIN AbdStation ON PassportInfo.AbdStationID = AbdStation.ID
WHERE     PassportInfo.LocalCreationTime BETWEEN @FromDateTime AND @ToDateTime
 
