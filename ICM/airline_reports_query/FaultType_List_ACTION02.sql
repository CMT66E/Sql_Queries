	SELECT  

	FaultType.ID AS FaultTypeID, 
	FaultType.ShortName, 
	COUNT(ABDErrorLog.ID) as NumberOfErrors, 
	'%' AS ABDStations	
		  
	FROM ABDErrorLog 
		JOIN FaultType ON ABDErrorLog.FaultTypeID = FaultType.ID 
		JOIN AbdStation ON ABDErrorLog.AbdStationID = AbdStation.ID
	WHERE        (ABDErrorLog.LocalCreationTime BETWEEN '2019/02/01' AND '2019/02/28')
	 
		--AND FaultType.ID IN (SELECT ID
		--						FROM FaultType
		--					WHERE [Description] like '%excess%')

	GROUP BY FaultType.ID,FaultType.ShortName
	ORDER BY COUNT(ABDErrorLog.ID) DESC