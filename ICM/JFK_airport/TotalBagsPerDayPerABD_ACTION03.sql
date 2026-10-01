
declare @FromDateTime DateTime ='2021-06-01 00:00:10'
declare @ToDateTime DateTime ='2021-06-30 00:00:00'

declare @FlightNumber nvarchar(100)  = '%'
declare @BoardPass nvarchar(25) = '%'
declare @BagTagType nvarchar(25) = '%'
declare @Airline nvarchar(25) = '%'
declare @Terminal nvarchar(10) = '%'
declare @Area nvarchar(10) = '%'
declare @SubArea nvarchar(10) = '%'
declare @ABDStationIDs varchar(400) = '0'
declare @ABDStationNames varchar(4000) = '%'


SELECT     
DATEPART(YEAR, BagWeightUpdate.LocalTime) AS Year, 
DATEPART(MONTH, BagWeightUpdate.LocalTime) AS Month, 
DATEPART(DAY, BagWeightUpdate.LocalTime) AS Day, 
@ABDStationNames AS ABDStations, SUM(BagWeightUpdate.Weight) AS TotalWeight, 
COUNT(BagWeightUpdate.LocalTime) AS Bags

FROM BagWeightUpdate INNER JOIN
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