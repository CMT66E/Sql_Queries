
declare @FromDateTime datetime = N'2020/11/25 00:00:00'
declare @ToDateTime datetime = N'2020/11/30 23:59:59'
declare @Terminal varchar(50) = N'%'
declare @Area varchar(50) = N'%'
declare @SubArea varchar(50) = N'%'
declare @ABDStationIDs varchar(50) = N'0'
declare @ABDStationNames varchar(50) = N'%'
declare @TotalBagAccepted int = 0


	DECLARE @TotalPrintBagReceipt INT = 0
	DECLARE @TotalNotPrintBagReceipt INT = 0

	DECLARE @Temp TABLE
	(
	  ID INT,
	  IsReceiptPrinted BIT
	)

	INSERT INTO @Temp
	SELECT CustomerSession.ID, CustomerSession.IsReceiptPrinted
	FROM BagWeightUpdate
	JOIN CustomerSession ON BagWeightUpdate.CustomerSessionID = CustomerSession.ID 
	JOIN AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID 
	WHERE 
	BagWeightUpdate.LocalTime BETWEEN @FromDateTime AND @ToDateTime
	AND (IsReceiptPrinted = 1 OR IsReceiptPrinted = 0)
	AND (AbdStation.Terminal LIKE @Terminal )
	AND (ISNULL(AbdStation.Area,'') LIKE @Area )
	AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
	AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
	GROUP by CustomerSession.ID, CustomerSession.IsReceiptPrinted

	select @TotalPrintBagReceipt = Count(ID) from @Temp where IsReceiptPrinted = 1
	select @TotalNotPrintBagReceipt = count(ID) from @Temp where IsReceiptPrinted = 0
	-----------------------------------------------------------------------------------------------------------------------------
	 
	SELECT  
	230 AS RecordTypeID, 
	'Total Bag Receipt Printed' as ShortName, 
	cast(isnull(@TotalPrintBagReceipt, 0) as int) as TotalPrintBagReceipt, 
	@ABDStationNames AS ABDStations	
	UNION
	SELECT  
	231 AS RecordTypeID, 
	'Total Bag Receipt Not Printed' as ShortName, 
	cast(isnull(@TotalNotPrintBagReceipt, 0) as int) as TotalNotPrintBagReceipt, 
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

print '@TotalBagAccepted = ' + cast(@TotalBagAccepted as varchar)

SELECT BagWeightUpdate.*, CustomerSession.*, AbdStation.*
FROM BagWeightUpdate
JOIN CustomerSession ON BagWeightUpdate.CustomerSessionID = CustomerSession.ID 
JOIN AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID						 
WHERE BagWeightUpdate.LocalTime BETWEEN @FromDateTime AND @ToDateTime
AND (AbdStation.Terminal LIKE @Terminal )
AND (ISNULL(AbdStation.Area,'') LIKE @Area )
AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)