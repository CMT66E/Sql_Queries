declare @FromDateTime datetime = '2018-03-01'
declare @ToDateTime datetime = '2018-12-28'
declare @BdsServertype INT = 0
declare @Terminal nvarchar(10)  = '%'
declare @Area nvarchar(10)  = '%'
declare @SubArea nvarchar(10)  = '%'
declare @ABDStationIDs varchar(400)  = '0'
declare @ABDStationNames varchar(4000)  = '%'

declare @rwCount int
Select @rwCount = count(AbdStationID) from BdsAbdMapping

If @BdsServertype = 0
BEGIN
    if @rwCount > 0
	begin
		SELECT MessageType, AVG(ISNULL(CONVERT(float, MessageTime) / 1000.0,0.0)) AS AvgMessageTime, AVG(ISNULL(CONVERT(float,MessageSize),0.0)) AS AvgMessageSize, 
			COUNT(CMOperationHistory.ID) AS NumberOfMessages, @ABDStationNames AS AbdStationNames
		FROM CMOperationHistory
		JOIN AbdStation
		ON CMOperationHistory.AbdStationID = AbdStation.ID
		WHERE MessageSent BETWEEN @FromDateTime AND @ToDateTime
			AND (AbdStation.Terminal LIKE @Terminal)
			AND (ISNULL(AbdStation.Area,'') LIKE @Area )
			AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
			AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
			AND ABDStation.ID In (Select AbdStationID from BdsAbdMapping)
		GROUP BY MessageType
	end
	else
	begin
		SELECT MessageType, AVG(ISNULL(CONVERT(float, MessageTime) / 1000.0,0.0)) AS AvgMessageTime, AVG(ISNULL(CONVERT(float,MessageSize),0.0)) AS AvgMessageSize, 
			COUNT(CMOperationHistory.ID) AS NumberOfMessages, @ABDStationNames AS AbdStationNames
		FROM CMOperationHistory
		JOIN AbdStation
		ON CMOperationHistory.AbdStationID = AbdStation.ID
		WHERE MessageSent BETWEEN @FromDateTime AND @ToDateTime
			AND (AbdStation.Terminal LIKE @Terminal)
			AND (ISNULL(AbdStation.Area,'') LIKE @Area )
			AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
			AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)			 
		GROUP BY MessageType
	end
END
ELSE
BEGIN
    if @rwCount > 0
	begin
		SELECT MessageType, AVG(ISNULL(CONVERT(float, MessageTime) / 1000.0,0.0)) AS AvgMessageTime, AVG(ISNULL(CONVERT(float,MessageSize),0.0)) AS AvgMessageSize, 
			COUNT(CMOperationHistory.ID) AS NumberOfMessages, @ABDStationNames AS AbdStationNames
		FROM CMOperationHistory
		JOIN AbdStation
		ON CMOperationHistory.AbdStationID = AbdStation.ID
		WHERE MessageSent BETWEEN @FromDateTime AND @ToDateTime
			AND (AbdStation.Terminal LIKE @Terminal)
			AND (ISNULL(AbdStation.Area,'') LIKE @Area )
			AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
			AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
			AND ABDStation.ID In (Select AbdStationID from BdsAbdMapping where BdsServerID =@BdsServertype)
		GROUP BY MessageType
	end
	else
	begin
		SELECT MessageType, AVG(ISNULL(CONVERT(float, MessageTime) / 1000.0,0.0)) AS AvgMessageTime, AVG(ISNULL(CONVERT(float,MessageSize),0.0)) AS AvgMessageSize, 
			COUNT(CMOperationHistory.ID) AS NumberOfMessages, @ABDStationNames AS AbdStationNames
		FROM CMOperationHistory
		JOIN AbdStation
		ON CMOperationHistory.AbdStationID = AbdStation.ID
		WHERE MessageSent BETWEEN @FromDateTime AND @ToDateTime
			AND (AbdStation.Terminal LIKE @Terminal)
			AND (ISNULL(AbdStation.Area,'') LIKE @Area )
			AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
			AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)			 
		GROUP BY MessageType
	end
END