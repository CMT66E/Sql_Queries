	declare @ABDStationIDs int  = 0
	declare @FromDateTime datetime = '2019-02-01'
	declare @ToDateTime datetime = '2019-02-28'
	declare @Terminal varchar(50) = '%'
	declare @Area varchar(50) = '%'
	declare @SubArea varchar(50) = '%'


	SELECT  
	FaultType.ID AS FaultTypeID, 
	FaultType.ShortName, 
	COUNT(ABDErrorLog.ID) as NumberOfErrors, 	
	'' AS ABDStations	
		  
	FROM ABDErrorLog 
		JOIN FaultType ON ABDErrorLog.FaultTypeID = FaultType.ID 
		JOIN AbdStation ON ABDErrorLog.AbdStationID = AbdStation.ID
	WHERE        (ABDErrorLog.LocalCreationTime BETWEEN @FromDateTime AND @ToDateTime)
		AND (AbdStation.Terminal LIKE @Terminal )
		AND (ISNULL(AbdStation.Area,'') LIKE @Area )
		AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
		AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
		AND FaultType.ID IN (
							 SELECT ID
							 FROM FaultType
							 WHERE lower([Description]) like '%excess%' and lower([Description]) <> 'excessbagdetected'
							)

	GROUP BY FaultType.ID,FaultType.ShortName
	ORDER BY COUNT(ABDErrorLog.ID) DESC