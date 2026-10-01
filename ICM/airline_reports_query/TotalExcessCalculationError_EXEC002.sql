		declare @FromDateTime datetime = N'2019/05/09 00:00:00'
		declare @ToDateTime datetime = N'2019/05/12 23:59:59'
		declare @Terminal nvarchar(10) = N'%'
		declare @Area nvarchar(10) = N'%'
		declare @SubArea nvarchar(10) = N'%'
		declare @ABDStationIDs nvarchar(400) = N'0'
		declare @ABDStationNames nvarchar(4000) = N'%'
		declare @TotalBagAccepted int

			SET @TotalBagAccepted = (SELECT COUNT(BagWeightUpdate.ID) 
								FROM BagWeightUpdate
								JOIN AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID
								WHERE BagWeightUpdate.LocalTime BETWEEN @FromDateTime AND @ToDateTime
									AND (AbdStation.Terminal LIKE @Terminal )
									AND (ISNULL(AbdStation.Area,'') LIKE @Area )
									AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
									AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0))

	SELECT 

	FaultType.ID AS FaultTypeID, 
	FaultType.ShortName, 
	COUNT(ABDErrorLog.ID) as NumberOfErrors, 	
	@ABDStationNames AS ABDStations	
		  
	FROM ABDErrorLog 
		JOIN FaultType ON ABDErrorLog.FaultTypeID = FaultType.ID 
		JOIN AbdStation ON ABDErrorLog.AbdStationID = AbdStation.ID
	WHERE        (ABDErrorLog.LocalCreationTime BETWEEN @FromDateTime AND @ToDateTime)
		AND (AbdStation.Terminal LIKE @Terminal )
		AND (ISNULL(AbdStation.Area,'') LIKE @Area )
		AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
		AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
		AND FaultType.ID IN (SELECT ID
								FROM FaultType
							WHERE lower([Description]) like '%excess%' and lower([Description]) <> 'excessbagdetected')

	GROUP BY FaultType.ID,FaultType.ShortName
	ORDER BY COUNT(ABDErrorLog.ID) DESC