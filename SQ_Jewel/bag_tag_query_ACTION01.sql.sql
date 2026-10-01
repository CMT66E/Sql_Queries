
	declare @FromDateTime datetime = N'2019/01/01 00:00:00'
	declare @ToDateTime datetime = N'2019/01/01 23:59:59'
	declare @Terminal nvarchar(10) = N'%'
	declare @Area nvarchar(10) = N'%'
	declare @SubArea nvarchar(10) = N'%'
	declare @ABDStationIDs nvarchar(400) = N'%'
	declare @ABDStationNames nvarchar(4000) = N'%'

	declare @TotalBagAccepted int = 0
 
	declare @FlightNumber nvarchar(100) = N'%'
    declare @BoardPass nvarchar(25) = N'%'
    declare @BagTagType nvarchar(25) = N'%'
    declare @Airline nvarchar(25) = N'%'

	SELECT     
	DATEPART(YEAR, BagWeightUpdate.LocalTime) AS Year, 
	DATEPART(MONTH, BagWeightUpdate.LocalTime) AS Month, 
	DATEPART(DAY, BagWeightUpdate.LocalTime) AS Day, 
	AbdStation.*, 
	--SUM(BagWeightUpdate.Weight) AS TotalWeight, 
	--COUNT(BagWeightUpdate.LocalTime) AS Bags
	BagWeightUpdate.Weight AS TotalWeight, 
	BagWeightUpdate.LocalTime AS LocalTime,
	Bag.UBI,
	Flight.MarketingCarrier + Flight.FlightNumber as FlightNo,
	Flight.BoardPoint + ' - ' + Flight.OffPoint as FlightRoute,
	Flight.DepartureDate
	FROM         BagWeightUpdate INNER JOIN
			  CustomerSession ON BagWeightUpdate.CustomerSessionID = CustomerSession.ID INNER JOIN
			  Flight ON CustomerSession.FlightID = Flight.ID INNER JOIN 
			  Bag ON BagWeightUpdate.BagID = Bag.ID INNER JOIN
			AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID
	WHERE     (BagWeightUpdate.LocalTime BETWEEN @FromDateTime AND @ToDateTime) 
		AND (CAST(Flight.FlightNumber as nvarchar(100)) like @FlightNumber) 
		AND (CustomerSession.CustomerLookupType like @BoardPass) 
		AND (Bag.BagTagType like @BagTagType)
		AND (Flight.MarketingCarrier like @Airline)
		AND (AbdStation.Terminal LIKE @Terminal )
		AND (ISNULL(AbdStation.Area,'') LIKE @Area )
		AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
	--AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
	--GROUP BY DATEPART(YEAR, BagWeightUpdate.LocalTime), DATEPART(MONTH, BagWeightUpdate.LocalTime), DATEPART(DAY, BagWeightUpdate.LocalTime)
	--ORDER BY DATEPART(YEAR, BagWeightUpdate.LocalTime), DATEPART(MONTH, BagWeightUpdate.LocalTime), DATEPART(DAY, BagWeightUpdate.LocalTime)
 