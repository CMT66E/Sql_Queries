
declare @FromDateTime datetime = N'2020/12/02 00:00:00'
declare @ToDateTime datetime = N'2020/12/02 23:59:59'
declare @Terminal varchar(50) = N'%'
declare @Area varchar(50) = N'%'
declare @SubArea varchar(50) = N'%'
declare @ABDStationIDs varchar(50) = N'0'
declare @ABDStationNames varchar(50) = N'%'
declare @TotalBagAccepted int = 0

	DECLARE @TotalTubsUsed INT = 0
	DECLARE @TotalCustomerSessionTubUsed INT = 0
	DECLARE @TotalCustomerSessionNoTubUsed INT = 0

	DECLARE @Temp TABLE
	(
	  ID INT,
	  NumberOfTubs INT
	)

	INSERT INTO @Temp
	SELECT CustomerSession.ID, CustomerSession.NumberOfTubs
	FROM BagWeightUpdate
	JOIN CustomerSession ON BagWeightUpdate.CustomerSessionID = CustomerSession.ID 
	JOIN AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID 
	WHERE 
	BagWeightUpdate.LocalTime BETWEEN @FromDateTime AND @ToDateTime
	AND isnull(NumberOfTubs, 0) > 0
	AND (AbdStation.Terminal LIKE @Terminal )
	AND (ISNULL(AbdStation.Area,'') LIKE @Area )
	AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
	AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
	GROUP by CustomerSession.ID, CustomerSession.NumberOfTubs

	select @TotalTubsUsed = sum(NumberOfTubs) from @Temp

	--select * from @Temp
	-----------------------------------------------------------------------------------------------------------------------------
	delete from @Temp
	INSERT INTO @Temp
	SELECT CustomerSession.ID, CustomerSession.NumberOfTubs
	FROM BagWeightUpdate
	JOIN CustomerSession ON BagWeightUpdate.CustomerSessionID = CustomerSession.ID 
	JOIN AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID 
	WHERE 
	BagWeightUpdate.LocalTime BETWEEN @FromDateTime AND @ToDateTime
	AND (isnull(NumberOfTubs, 0) > 0 OR isnull(NumberOfTubs, 0) = 0)
	AND (AbdStation.Terminal LIKE @Terminal )
	AND (ISNULL(AbdStation.Area,'') LIKE @Area )
	AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
	AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
	GROUP by CustomerSession.ID, CustomerSession.NumberOfTubs
 
	select @TotalCustomerSessionTubUsed = count(*) from @Temp
	where NumberOfTubs > 0

	 
	select @TotalCustomerSessionNoTubUsed = count(*) from @Temp
	where NumberOfTubs = 0

	select * from @Temp
	-----------------------------------------------------------------------------------------------------------------------------
	SELECT  
	230 AS RecordTypeID, 
	'Total Tubs Used' as ShortName, 
	cast(isnull(@TotalTubsUsed, 0) as int) as TotalTubsUsed, 
	@ABDStationNames AS ABDStations	
	UNION
	SELECT  
	231 AS RecordTypeID, 
	'Total CustomerSessions Used Tubs' as ShortName, 
	cast(isnull(@TotalCustomerSessionTubUsed, 0) as int) as TotalCustomerSessionTubUsed, 
	@ABDStationNames AS ABDStations	
	UNION
	SELECT  
	232 AS RecordTypeID, 
	'Total CustomerSessions No Tubs' as ShortName, 
	cast(isnull(@TotalCustomerSessionNoTubUsed, 0) as int) as TotalCustomerSessionCountNoTubsUsed, 
	@ABDStationNames AS ABDStations	
	-----------------------------------------------------------------------------------------------------------------------------
	SET @TotalBagAccepted = (
							SELECT COUNT(BagWeightUpdate.ID) 
							FROM BagWeightUpdate
							JOIN CustomerSession ON BagWeightUpdate.CustomerSessionID = CustomerSession.ID 
							JOIN AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID						 
							WHERE BagWeightUpdate.LocalTime BETWEEN @FromDateTime AND @ToDateTime
							AND (AbdStation.Terminal LIKE @Terminal )
							AND (ISNULL(AbdStation.Area,'') LIKE @Area )
							AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
							AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
							)
	print '@TotalBagAccepted =' + cast(@TotalBagAccepted as varchar)

