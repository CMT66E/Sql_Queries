 
		declare @FromDateTime datetime = N'2019/08/01 00:00:00'
		declare @ToDateTime datetime = N'2019/08/31 23:59:59'
		declare @Terminal varchar(50) = N'%'
		declare @Area varchar(50) = N'%'
		declare @SubArea varchar(50) = N'%'
		declare @ABDStationIDs varchar(50) = N'0'
		declare @ABDStationNames varchar(50) = N'%'
		declare @TotalBagAccepted int = 0

	DECLARE @TotalAmountExcessByPieces MONEY = 0

	SELECT 
	@TotalAmountExcessByPieces = sum(isnull(ExcessDetailsLog.TotalExcessValue, 0)) 
	FROM BagWeightUpdate
	JOIN AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID
	INNER JOIN ExcessDetailsLog ON BagWeightUpdate.CustomerSessionID = ExcessDetailsLog.CustomerSessionID
	WHERE  
	IsExcessByPieces = 1 AND 
	BagWeightUpdate.LocalTime BETWEEN @FromDateTime AND @ToDateTime
	AND (AbdStation.Terminal LIKE @Terminal )
	AND (ISNULL(AbdStation.Area,'') LIKE @Area )
	AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
	AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)

	DECLARE @TotalAmountExcessByWeight MONEY = 0
	SELECT 
	@TotalAmountExcessByWeight = sum(isnull(ExcessDetailsLog.TotalExcessValue, 0)) 
	FROM BagWeightUpdate
	JOIN AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID
	INNER JOIN ExcessDetailsLog ON BagWeightUpdate.CustomerSessionID = ExcessDetailsLog.CustomerSessionID
	WHERE  
	IsExcessByPieces = 0 AND 
	BagWeightUpdate.LocalTime BETWEEN @FromDateTime AND @ToDateTime
	AND (AbdStation.Terminal LIKE @Terminal )
	AND (ISNULL(AbdStation.Area,'') LIKE @Area )
	AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
	AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)

	SELECT  
	230 AS FaultTypeID, 
	'By Pieces' as ShortName, 
	cast(isnull(@TotalAmountExcessByPieces, 0) as int) as TotalExcessAmount, 
	@ABDStationNames AS ABDStations	
	UNION
	SELECT  
	231 AS FaultTypeID, 
	'By Weight' as ShortName, 
	cast(isnull(@TotalAmountExcessByWeight, 0) as int) as TotalExcessAmount, 
	@ABDStationNames AS ABDStations	

 
	SET @TotalBagAccepted = (SELECT COUNT(BagWeightUpdate.ID) 
								FROM BagWeightUpdate
								JOIN AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID
								INNER JOIN ExcessDetailsLog ON BagWeightUpdate.CustomerSessionID = ExcessDetailsLog.CustomerSessionID
								WHERE BagWeightUpdate.LocalTime BETWEEN @FromDateTime AND @ToDateTime
									AND (AbdStation.Terminal LIKE @Terminal )
									AND (ISNULL(AbdStation.Area,'') LIKE @Area )
									AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
									AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0))

  print '@TotalBagAccepted =' + cast(@TotalBagAccepted as varchar)
