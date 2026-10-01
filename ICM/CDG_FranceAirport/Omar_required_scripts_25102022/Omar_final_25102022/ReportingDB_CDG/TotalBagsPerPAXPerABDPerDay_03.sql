--Notes: Total bags per PAX per ABD per day
--Date: 25-Oct-2022
USE ReportingDB_CDG
GO	

declare @FromDateTime DateTime = '2022/07/31 00:00:00'
declare @ToDateTime DateTime = '2022/07/31 23:59:59'
declare @FlightNumber nvarchar(100)  = '%'
declare @BoardPass nvarchar(25) = '%'
declare @BagTagType nvarchar(25) = '%'
declare @Airline nvarchar(25) = '%'
declare @Terminal nvarchar(10) = '%'
declare @Area nvarchar(10) = '%'
declare @SubArea nvarchar(10) = '%'
declare @ABDStationIDs varchar(400) = '0'
declare @ABDStationNames varchar(4000) = 'Display All ABDs'


IF (@Airline = '0' OR @Airline ='%' )
SET @Airline = '%'
Select* into #temp from CustomerSession where LocalTime BETWEEN @FromDateTime AND @ToDateTime

IF @Airline = '%'
BEGIN
		SELECT     AbdStation.ID AS ABDStationID, dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea) AS AbdStationName, 
			SUM(BagWeightUpdate.Weight) AS TotalWeight, COUNT(BagWeightUpdate.LocalTime) AS Bags
		FROM         BagWeightUpdate INNER JOIN
								AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID INNER JOIN
								#temp CustomerSession ON BagWeightUpdate.CustomerSessionID = CustomerSession.ID INNER JOIN
								Flight ON CustomerSession.FlightID = Flight.ID INNER JOIN Bag ON BagWeightUpdate.BagID = Bag.ID
		WHERE     (CustomerSession.LocalTime BETWEEN @FromDateTime AND @ToDateTime) 
			AND (CAST(Flight.FlightNumber as nvarchar(100)) like @FlightNumber) 
			AND (CustomerSession.CustomerLookupType like @BoardPass) 
			AND (Bag.BagTagType like @BagTagType)
			---AND (Flight.MarketingCarrier like @Airline)
			AND (AbdStation.Terminal LIKE @Terminal )
			AND (ISNULL(AbdStation.Area,'') LIKE @Area )
			AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
			AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
	    
		GROUP BY AbdStation.ID,AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea
		ORDER BY dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea)

END
ELSE
BEGIN
		SELECT     AbdStation.ID AS ABDStationID, dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea) AS AbdStationName, 
			SUM(BagWeightUpdate.Weight) AS TotalWeight, COUNT(BagWeightUpdate.LocalTime) AS Bags
		FROM         BagWeightUpdate INNER JOIN
								AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID INNER JOIN
								#temp CustomerSession ON BagWeightUpdate.CustomerSessionID = CustomerSession.ID INNER JOIN
								Flight ON CustomerSession.FlightID = Flight.ID INNER JOIN Bag ON BagWeightUpdate.BagID = Bag.ID
		WHERE     (CustomerSession.LocalTime BETWEEN @FromDateTime AND @ToDateTime) 
			AND (CAST(Flight.FlightNumber as nvarchar(100)) like @FlightNumber) 
			AND (CustomerSession.CustomerLookupType like @BoardPass) 
			AND (Bag.BagTagType like @BagTagType)
			AND (Flight.MarketingCarrier IN (SELECT Items 
			FROM  dbo.Split(@Airline, ',')))
			AND (AbdStation.Terminal LIKE @Terminal )
			AND (ISNULL(AbdStation.Area,'') LIKE @Area )
			AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
			AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
	    
		GROUP BY AbdStation.ID,AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea
		ORDER BY dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea)
END