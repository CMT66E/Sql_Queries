

	declare @FromDateTime DateTime = '2019/10/22'
	declare @ToDateTime DateTime = '2019/10/23'
	declare @FlightNumber nvarchar(100) = '%'
    declare @BoardPass nvarchar(25) = '%'
    declare @BagTagType nvarchar(25) = '%'
    declare @Airline nvarchar(25) ='TR'
    declare @Terminal nvarchar(10) = '%'
	declare @Area nvarchar(10) = '%'
	declare @SubArea nvarchar(10) = '%'
	declare @ABDStationIDs varchar(400) = '0'
	declare @ABDStationNames varchar(4000) ='%'


    IF (@Airline = '0' OR @Airline ='%' )
    SET @Airline = '%'

	IF @Airline = '%'
	BEGIN
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
	END
	ELSE
	BEGIN
			--SELECT     DATEPART(YEAR, BagWeightUpdate.LocalTime) AS Year, DATEPART(MONTH, BagWeightUpdate.LocalTime) AS Month, DATEPART(DAY, BagWeightUpdate.LocalTime) AS Day, 
			--	@ABDStationNames AS ABDStations, SUM(BagWeightUpdate.Weight) AS TotalWeight, COUNT(BagWeightUpdate.LocalTime) AS Bags
			--FROM         BagWeightUpdate INNER JOIN
			--		  CustomerSession ON BagWeightUpdate.CustomerSessionID = CustomerSession.ID INNER JOIN
			--		  Flight ON CustomerSession.FlightID = Flight.ID INNER JOIN 
			--		  Bag ON BagWeightUpdate.BagID = Bag.ID INNER JOIN
			--		AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID
			--WHERE     (BagWeightUpdate.LocalTime BETWEEN @FromDateTime AND @ToDateTime) 
			--	AND (CAST(Flight.FlightNumber as nvarchar(100)) like @FlightNumber) 
			--	AND (CustomerSession.CustomerLookupType like @BoardPass) 
			--	AND (Bag.BagTagType like @BagTagType)
			--	AND (Flight.MarketingCarrier IN (SELECT Items 
			--	FROM  dbo.Split(@Airline, ',')))
			--	AND (AbdStation.Terminal LIKE @Terminal )
			--	AND (ISNULL(AbdStation.Area,'') LIKE @Area )
			--	AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
			--	AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
			--GROUP BY DATEPART(YEAR, BagWeightUpdate.LocalTime), DATEPART(MONTH, BagWeightUpdate.LocalTime), DATEPART(DAY, BagWeightUpdate.LocalTime)
			--ORDER BY DATEPART(YEAR, BagWeightUpdate.LocalTime), DATEPART(MONTH, BagWeightUpdate.LocalTime), DATEPART(DAY, BagWeightUpdate.LocalTime)

			--------------------------------------------------------------------------------------------------------------------------------------------
DECLARE @Count_ByDay TABLE
(
  ABDStationID int,
  BagWeightUpdate_LocalTime datetime
)


			SELECT  AbdStation.ID, 
			dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea) AS AbdStationName, 
			    DATEPART(YEAR, BagWeightUpdate.LocalTime) AS Year, 
				DATEPART(MONTH, BagWeightUpdate.LocalTime) AS Month, 
				DATEPART(DAY, BagWeightUpdate.LocalTime) AS Day, 
				@ABDStationNames AS ABDStations, BagWeightUpdate.Weight AS TotalWeight, 
				BagWeightUpdate.LocalTime AS Bags_WeightUpdate_LocalTime,
				CustomerSession.LocalTime AS CustomerSession_LocalTime
			FROM      BagWeightUpdate INNER JOIN
					  CustomerSession ON BagWeightUpdate.CustomerSessionID = CustomerSession.ID INNER JOIN
					  Flight ON CustomerSession.FlightID = Flight.ID INNER JOIN 
					  Bag ON BagWeightUpdate.BagID = Bag.ID INNER JOIN
					AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID
			WHERE     (BagWeightUpdate.LocalTime BETWEEN @FromDateTime AND @ToDateTime) 
				AND (CAST(Flight.FlightNumber as nvarchar(100)) like @FlightNumber) 
				AND (CustomerSession.CustomerLookupType like @BoardPass) 
				AND (Bag.BagTagType like @BagTagType)
				AND (Flight.MarketingCarrier IN ('TR'))
            order by BagWeightUpdate.LocalTime desc


DECLARE @Count_ByABD TABLE
(
  ABDStationID int,
  BagWeightUpdate_LocalTime datetime
)

        --------------------------------------------------------------------------------------------------------------------------------------------
		IF (@Airline = '0' OR @Airline ='%' )
		SET @Airline = '%'

		DROP TABLE IF EXISTS #Temp
		Select * into #temp from CustomerSession where LocalTime BETWEEN @FromDateTime AND @ToDateTime
	 
	
		SELECT     AbdStation.ID AS ABDStationID, 
		    dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea) AS AbdStationName, 
			BagWeightUpdate.Weight AS TotalWeight, 
			BagWeightUpdate.LocalTime AS BagWeightUpdate_LocalTime,
			CustomerSession.LocalTime AS CustomerSession_LocalTime
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
			order by BagWeightUpdate.LocalTime desc

			
			--select * from @Count_ByDay
			--select * from @Count_ByABD
		    --select * from @Count_ByDay a left outer join @Count_ByABD b on a.BagWeightUpdate_LocalTime <> b.BagWeightUpdate_LocalTime

			--select * from @Count_ByDay a  where a.BagWeightUpdate_LocalTime <> (select BagWeightUpdate_LocalTime from @Count_ByABD)
	END



	    
			--GROUP BY AbdStation.ID,AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea
			--ORDER BY dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea)
 

