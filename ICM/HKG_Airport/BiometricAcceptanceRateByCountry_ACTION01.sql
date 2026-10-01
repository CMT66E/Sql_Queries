declare @FromDateTime DateTime = '2021/07/18 00:00:00'
declare @ToDateTime DateTime = '2021/07/25 23:59:59'
declare @PassportType char(1) = '%'
declare @Terminal nvarchar(10) = '%'
declare @Area nvarchar(10) = '%'
declare @SubArea nvarchar(10) = '%'
declare @ABDStationIDs varchar(400) = '0'
declare @ABDStationNames varchar(4000) = '%';
 
	WITH BiometricAcceptanceRateByCountry AS
(
	SELECT PassportInfo.Issuer, COUNT(PassportInfo.ID) AS NumberOfPassportScans,
		COUNT(SuccessfulScans.ID) AS NumberOfPassportSuccessfulScans, @ABDStationNames AS ABDStations,
		ROW_NUMBER() OVER (ORDER BY COUNT(PassportInfo.ID) DESC) AS RowNumber
	FROM PassportInfo
	LEFT JOIN PassportInfo AS SuccessfulScans 
	ON SuccessfulScans.ID = PassportInfo.ID AND SuccessfulScans.IsVerifiedSucessfully = 1
	JOIN AbdStation ON PassportInfo.AbdStationID = AbdStation.ID
	WHERE     PassportInfo.LocalCreationTime BETWEEN @FromDateTime AND @ToDateTime
		AND (@PassportType = '%' OR CAST(PassportInfo.IsRFIDPhoto AS char(1)) = @PassportType)
		AND (AbdStation.Terminal LIKE @Terminal )
		AND (ISNULL(AbdStation.Area,'') LIKE @Area )
		AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
		AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
	GROUP BY PassportInfo.Issuer
	
)

SELECT RowNumber,(case Issuer when '' then 'XXX' else Issuer end) as Issuer, ROUND(CONVERT(float,NumberOfPassportSuccessfulScans) * 100.0 / CONVERT(float,NumberOfPassportScans),2) AS SucessfulScanRate, 
	NumberOfPassportScans, NumberOfPassportSuccessfulScans, ABDStations
FROM BiometricAcceptanceRateByCountry
WHERE RowNumber <= 10

UNION

SELECT 11,'Others', ROUND(CONVERT(float,SUM(NumberOfPassportSuccessfulScans)) * 100.0 / CONVERT(float,SUM(NumberOfPassportScans)),2), 
	SUM(NumberOfPassportScans), SUM(NumberOfPassportSuccessfulScans), ABDStations
FROM BiometricAcceptanceRateByCountry
WHERE RowNumber > 10
GROUP BY ABDStations

