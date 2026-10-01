declare @FromDateTime datetime = '2018-03-01'
declare @ToDateTime datetime = '2018-12-28'
declare @BDSServerType INT = 0
declare @Terminal nvarchar(10) = '%'
declare @Area nvarchar(10) = '%'
declare @SubArea nvarchar(10) = '%'
declare @ABDStationIDs varchar(400) = '0'
declare @ABDStationNames varchar(4000) = '%'


SELECT isnull(BdsServerID, 0) as BdsServerID, isnull(ServerName, 'xxx') as ServerName, ROUND(AVG(ISNULL(CONVERT(float, MessageTime) / 1000.00,0.0)),2)  AS AvgMessageTime, ROUND(AVG(ISNULL(CONVERT(float,MessageSize),0.0)),2) AS AvgMessageSize, 
	COUNT(CMOperationHistory.ID) AS NumberOfMessages
FROM CMOperationHistory
JOIN AbdStation
ON CMOperationHistory.AbdStationID = AbdStation.ID
LEFT OUTER JOIN BdsAbdMapping 
ON  BdsAbdMapping.AbdStationID = AbdStation.ID
LEFT OUTER JOIN BDSServerType 
ON BDSServerType.ID = BdsServerID
WHERE MessageSent BETWEEN @FromDateTime AND @ToDateTime
AND (AbdStation.Terminal LIKE @Terminal )
AND (ISNULL(AbdStation.Area,'') LIKE @Area )
AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
GROUP BY BdsAbdMapping.BdsServerID,servername