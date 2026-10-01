--stored procedure: TotalBagsPerHour
declare @FromDateTime DateTime = '2019-06-19 00:00:00'
declare @ToDateTime DateTime = '2019-06-19 23:59:00'
declare @FlightNumber nvarchar(100)  = '%'
declare @BoardPass nvarchar(25) = '%'
declare @BagTagType nvarchar(25) = '%'
declare @Airline nvarchar(25) = ''
declare @Terminal nvarchar(10) = '%'
declare @Area nvarchar(10) = '%'
declare @SubArea nvarchar(10) = '%'
declare @ABDStationIDs varchar(400) = '0'
declare @ABDStationNames varchar(4000) = '%'

	SELECT     TimeSlotHourly.TimeSlotName, COUNT(*) AS Bags, @ABDStationNames AS ABDStations
	FROM         BagWeightUpdate INNER JOIN
						  TimeSlotHourly ON BagWeightUpdate.TimeSlotHourlyID = TimeSlotHourly.ID INNER JOIN
						  CustomerSession ON BagWeightUpdate.CustomerSessionID = CustomerSession.ID INNER JOIN
						  Flight ON CustomerSession.FlightID = Flight.ID INNER JOIN 
						  Bag ON BagWeightUpdate.BagID = Bag.ID INNER JOIN
						ABDStation ON ABDStation.ID = BagWeightUpdate.ABDStationID
	WHERE     (BagWeightUpdate.LocalTime BETWEEN @FromDateTime AND @ToDateTime) 
		AND (CAST(Flight.FlightNumber as nvarchar(100)) like @FlightNumber) 
		AND (CustomerSession.CustomerLookupType like @BoardPass) 
		AND (Bag.BagTagType like @BagTagType)
		AND (Flight.MarketingCarrier like @Airline)
		AND (AbdStation.Terminal LIKE @Terminal )
		AND (ISNULL(AbdStation.Area,'') LIKE @Area )
		AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
		AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
	GROUP BY TimeSlotHourly.ID, TimeSlotHourly.TimeSlotName
	ORDER BY TimeSlotHourly.ID, TimeSlotHourly.TimeSlotName