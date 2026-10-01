declare @FromDateTime DateTime = '2023/01/01 00:00:00'
declare @ToDateTime DateTime = '2023/01/31 23:59:59'
declare @FlightNumber nvarchar(100)  = '%'
declare @BoardPass nvarchar(25) = '%'
declare @BagTagType nvarchar(25) = '%'
declare @Airline nvarchar(25) = '%'
declare @Terminal nvarchar(10) = 'WLG'
declare @Area nvarchar(10) = '%'
declare @SubArea nvarchar(10) = '%'
declare @ABDStationIDs varchar(400) = '0'
declare @ABDStationNames varchar(4000) = '%'

	IF (@Airline = '0' OR @Airline ='%' )
    SET @Airline = '%'

	IF @Airline = '%'
	BEGIN
		SELECT     DATEPART(YEAR, BagWeightUpdate.LocalTime) AS Year, 
		DATEPART(MONTH, BagWeightUpdate.LocalTime) AS Month, 
		DATEPART(DAY, BagWeightUpdate.LocalTime) AS Day, 
		@ABDStationNames AS ABDStations, 
		SUM(BagWeightUpdate.Weight) AS TotalWeight, 
		--COUNT(BagWeightUpdate.LocalTime) AS Bags,
			x.BagCount as Bags
		FROM         
				  CustomerSession  INNER JOIN BagWeightUpdate ON CustomerSession.ID = BagWeightUpdate.CustomerSessionID INNER JOIN
				  Flight ON CustomerSession.FlightID = Flight.ID INNER JOIN 
				  Bag ON BagWeightUpdate.BagID = Bag.ID INNER JOIN
				AbdStation ON CustomerSession.AbdStationID = AbdStation.ID
				INNER JOIN [STUDY_DB].[dbo].[WLG_JAN2023] x ON DATEPART(DAY, BagWeightUpdate.LocalTime) = x.ID
		WHERE     (CustomerSession.LocalCreationTime BETWEEN @FromDateTime AND @ToDateTime) 
			AND (CAST(Flight.FlightNumber as nvarchar(100)) like @FlightNumber) 
			AND (CustomerSession.CustomerLookupType like @BoardPass) 
			AND (Bag.BagTagType like @BagTagType)
			AND (Flight.MarketingCarrier like @Airline)
			AND (AbdStation.Terminal LIKE @Terminal )
			AND (ISNULL(AbdStation.Area,'') LIKE @Area )
			AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
			AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
		GROUP BY DATEPART(YEAR, BagWeightUpdate.LocalTime), DATEPART(MONTH, BagWeightUpdate.LocalTime), DATEPART(DAY, BagWeightUpdate.LocalTime), x.BagCount
		ORDER BY DATEPART(YEAR, BagWeightUpdate.LocalTime), DATEPART(MONTH, BagWeightUpdate.LocalTime), DATEPART(DAY, BagWeightUpdate.LocalTime)
	END
	ELSE
	BEGIN
	    print 'none'
		--SELECT     TimeSlotHourly.TimeSlotName, @ABDStationNames AS ABDStations, COUNT(*) AS Bags
		--FROM         BagWeightUpdate INNER JOIN
		--		  TimeSlotHourly ON BagWeightUpdate.TimeSlotHourlyID = TimeSlotHourly.ID INNER JOIN
		--		  CustomerSession ON BagWeightUpdate.CustomerSessionID = CustomerSession.ID INNER JOIN
		--		  Flight ON CustomerSession.FlightID = Flight.ID INNER JOIN 
		--		  Bag ON BagWeightUpdate.BagID = Bag.ID INNER JOIN
		--		ABDStation ON ABDStation.ID = BagWeightUpdate.ABDStationID
		--WHERE     (BagWeightUpdate.LocalTime BETWEEN @FromDateTime AND @ToDateTime) 
		--	AND (CAST(Flight.FlightNumber as nvarchar(100)) like @FlightNumber) 
		--	AND (CustomerSession.CustomerLookupType like @BoardPass) 
		--	AND (Bag.BagTagType like @BagTagType)
		--	AND (Flight.MarketingCarrier IN (SELECT Items 
		--		FROM  dbo.Split(@Airline, ',')))
		--	AND (AbdStation.Terminal LIKE @Terminal )
		--	AND (ISNULL(AbdStation.Area,'') LIKE @Area )
		--	AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
		--	AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
		--GROUP BY TimeSlotHourly.ID,TimeSlotHourly.TimeSlotName
		--ORDER BY TimeSlotHourly.ID, TimeSlotHourly.TimeSlotName
	END