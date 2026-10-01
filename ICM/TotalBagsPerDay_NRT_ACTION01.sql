declare @FromDateTime DateTime = '2022/01/01 00:00:00 AM'
declare @ToDateTime DateTime = '2022/01/07 11:59:59 PM'
declare @FlightNumber nvarchar(100)  = '%'
declare @BoardPass nvarchar(25) = '%'
declare @BagTagType nvarchar(25) = '%'
declare @Airline nvarchar(25) = '%'
declare @Terminal nvarchar(10) = '%'
declare @Area nvarchar(10) = '%'
declare @SubArea nvarchar(10) = '%'
declare @ABDStationIDs varchar(400) = ',103,80,101,79,104,81,102,82,109,83,105,84,106,86,107,85,'
declare @ABDStationNames varchar(4000) = 'NRT3_L_ABD_001,NRT3_L_ABD_001,NRT3_L_ABD_002,NRT3_L_ABD_002,NRT3_L_ABD_003,NRT3_L_ABD_003,NRT3_L_ABD_004,NRT3_L_ABD_004,NRT3_L_ABD_005,NRT3_L_ABD_005,NRT3_L_ABD_006,NRT3_L_ABD_006,NRT3_L_ABD_007,NRT3_L_ABD_007,NRT3_L_ABD_008,NRT3_L_ABD_008'

--SP: TotalBagsPerDay

	SELECT     DATEPART(YEAR, BagWeightUpdate.LocalTime) AS Year, DATEPART(MONTH, BagWeightUpdate.LocalTime) AS Month, DATEPART(DAY, BagWeightUpdate.LocalTime) AS Day, 
		@ABDStationNames AS ABDStations, SUM(BagWeightUpdate.Weight) AS TotalWeight, COUNT(BagWeightUpdate.LocalTime) AS Bags
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
		AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
	GROUP BY DATEPART(YEAR, BagWeightUpdate.LocalTime), DATEPART(MONTH, BagWeightUpdate.LocalTime), DATEPART(DAY, BagWeightUpdate.LocalTime)
	ORDER BY DATEPART(YEAR, BagWeightUpdate.LocalTime), DATEPART(MONTH, BagWeightUpdate.LocalTime), DATEPART(DAY, BagWeightUpdate.LocalTime)