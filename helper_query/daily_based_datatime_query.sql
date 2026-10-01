	SELECT 
	sum(isnull(ExcessDetailsLog.TotalExcessValue, 0)) as TotalAmountExcessByPieces
	FROM BagWeightUpdate
	JOIN AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID
	INNER JOIN ExcessDetailsLog ON BagWeightUpdate.CustomerSessionID = ExcessDetailsLog.CustomerSessionID
	WHERE  
	IsExcessByPieces = 1 AND 
	BagWeightUpdate.LocalTime BETWEEN '2019/02/27 00:00:00' AND '2019/02/27 23:59:59'

	SELECT 
	sum(isnull(ExcessDetailsLog.TotalExcessValue, 0)) as TotalAmountExcessByPieces
	FROM BagWeightUpdate
	JOIN AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID
	INNER JOIN ExcessDetailsLog ON BagWeightUpdate.CustomerSessionID = ExcessDetailsLog.CustomerSessionID
	WHERE  
	IsExcessByPieces = 1 AND 
	BagWeightUpdate.LocalTime BETWEEN '2019/02/28 00:00:00' AND '2019/02/28 23:59:59'

	SELECT 
	sum(isnull(ExcessDetailsLog.TotalExcessValue, 0)) as TotalAmountExcessByPieces
	FROM BagWeightUpdate
	JOIN AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID
	INNER JOIN ExcessDetailsLog ON BagWeightUpdate.CustomerSessionID = ExcessDetailsLog.CustomerSessionID
	WHERE  
	IsExcessByPieces = 1 AND 
	BagWeightUpdate.LocalTime BETWEEN '2019/03/04 00:00:00' AND '2019/03/04 23:59:59'
 