declare @FromDateTime DateTime = '2023-01-01 00:00:00'
declare @ToDateTime DateTime = '2023-01-31 23:59:59'
declare @FlightNumber nvarchar(100)  = '%'
declare @BoardPass nvarchar(25) = '%'
declare @BagTagType nvarchar(25) = '%'
declare @Airline nvarchar(25) = '%'
declare @Terminal nvarchar(10) = '%'
declare @Area nvarchar(10) = '%'
declare @SubArea nvarchar(10) = '%'
declare @ABDStationIDs varchar(400) = '0'
declare @ABDStationNames varchar(4000) = '%'


	SELECT     DATEPART(YEAR, BagWeightUpdate.LocalTime) AS Year, DATEPART(MONTH, BagWeightUpdate.LocalTime) AS Month, DATEPART(DAY, BagWeightUpdate.LocalTime) AS Day, 
		@ABDStationNames AS ABDStations, SUM(BagWeightUpdate.Weight) AS TotalWeight, COUNT(BagWeightUpdate.LocalTime) AS Bags
	FROM         BagWeightUpdate INNER JOIN
				CustomerSession ON BagWeightUpdate.CustomerSessionID = CustomerSession.ID INNER JOIN
				Flight ON CustomerSession.FlightID = Flight.ID INNER JOIN 
				Bag ON BagWeightUpdate.BagID = Bag.ID INNER JOIN
			AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID
	WHERE     (CustomerSession.LocalTime BETWEEN @FromDateTime AND @ToDateTime) 
		AND (CAST(Flight.FlightNumber as nvarchar(100)) like @FlightNumber) 
		AND (CustomerSession.CustomerLookupType like @BoardPass) 
		AND (Bag.BagTagType like @BagTagType)
		AND (Flight.MarketingCarrier like @Airline)
		AND (AbdStation.Terminal LIKE @Terminal )
		AND (ISNULL(AbdStation.Area,'') LIKE @Area )
		AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
		AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
	GROUP BY DATEPART(YEAR, BagWeightUpdate.LocalTime), DATEPART(MONTH, BagWeightUpdate.LocalTime), DATEPART(DAY, BagWeightUpdate.LocalTime)
	ORDER BY DATEPART(YEAR, BagWeightUpdate.LocalTime), DATEPART(MONTH, BagWeightUpdate.LocalTime), DATEPART(DAY, BagWeightUpdate.LocalTime)
 

	--SELECT     DATEPART(YEAR, BagWeightUpdate.LocalTime) AS Year, DATEPART(MONTH, BagWeightUpdate.LocalTime) AS Month, DATEPART(DAY, BagWeightUpdate.LocalTime) AS Day, 
	--	@ABDStationNames AS ABDStations, *
	--FROM         BagWeightUpdate INNER JOIN
	--			CustomerSession ON BagWeightUpdate.CustomerSessionID = CustomerSession.ID INNER JOIN
	--			Flight ON CustomerSession.FlightID = Flight.ID INNER JOIN 
	--			Bag ON BagWeightUpdate.BagID = Bag.ID INNER JOIN
	--		AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID
	--WHERE     (CustomerSession.LocalTime BETWEEN @FromDateTime AND @ToDateTime) 

	--select * from BagDrop_SIN_ACTION.dbo.CustomerSession where DATEPART(YEAR, LocalCreationTime) = 2022 and DATEPART(MONTH, LocalCreationTime) = 03 and DATEPART(DAY, LocalCreationTime) = 27
	--select * from ReportingDB_SIN.dbo.CustomerSession where DATEPART(YEAR, LocalTime) = 2022 and DATEPART(MONTH, LocalTime) = 03 and DATEPART(DAY, LocalTime) = 27  --297 before running airline reporting engine
	--select * from ReportingDB_SIN.dbo.BagWeightUpdate where DATEPART(YEAR, LocalTime) = 2022 and DATEPART(MONTH, LocalTime) = 03 and DATEPART(DAY, LocalTime) = 27