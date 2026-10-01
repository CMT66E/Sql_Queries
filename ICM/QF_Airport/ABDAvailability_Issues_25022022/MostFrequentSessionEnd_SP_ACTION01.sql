declare   @FromDateTime DateTime = '2021/01/01 00:00:00'
declare   @ToDateTime DateTime = '2021/12/31 23:59:59'
declare   @Terminal nvarchar(10) = '%'
declare   @Airline nvarchar(10) = '%'
declare   @Area nvarchar(10) = '%'
declare   @SubArea nvarchar(10) = '%'
declare   @ABDStationIDs varchar(400) = '0'
declare   @ABDStationNames varchar(4000)  = '%'


IF (@Airline = '0' OR @Airline ='%' )
 SET @Airline = '%'

IF @Airline ='%'
	SELECT 
	c.SessionEndReasonID,
	s.ShortName, 
	COUNT(c.ID) AS NumberOfSession,
	@ABDStationNames AS ABDStations 

	FROM CustomerSession c
	JOIN Flight F On F.ID = C.FlightID
	JOIN SessionEndReason s
	ON s.ID = c.SessionEndReasonID
	LEFT JOIN ABDStation a
	ON a.ID = c.ABDStationID
	WHERE (c.LocalTime  BETWEEN @FromDateTime AND @ToDateTime)
		AND (a.Terminal LIKE @Terminal )
		AND (ISNULL(a.Area,'') LIKE @Area )
		AND (ISNULL(a.SubArea,'') LIKE @SubArea )
		AND  (F.MarketingCarrier like @Airline)
		AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(a.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
	GROUP BY c.SessionEndReasonID,s.ShortName
	ORDER BY COUNT(c.ID) DESC
ELSE
    SELECT c.SessionEndReasonID,s.ShortName, COUNT(c.ID) AS NumberOfSession,
		@ABDStationNames AS ABDStations 
	FROM CustomerSession c
	JOIN Flight F On F.ID = C.FlightID
	JOIN SessionEndReason s
	ON s.ID = c.SessionEndReasonID
	LEFT JOIN ABDStation a
	ON a.ID = c.ABDStationID
	WHERE (c.LocalTime  BETWEEN @FromDateTime AND @ToDateTime)
		AND (a.Terminal LIKE @Terminal )
		AND (ISNULL(a.Area,'') LIKE @Area )
		AND (ISNULL(a.SubArea,'') LIKE @SubArea )
		AND  (F.MarketingCarrier IN (SELECT Items 
				FROM  dbo.Split(@Airline, ',')))
		AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(a.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
	GROUP BY c.SessionEndReasonID,s.ShortName
	ORDER BY COUNT(c.ID) DESC