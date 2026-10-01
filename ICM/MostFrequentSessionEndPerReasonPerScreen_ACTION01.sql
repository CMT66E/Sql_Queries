USE ReportingDB_NRT
GO 

declare @FromDateTime DateTime = '2022/11/01 00:00:00'
declare @ToDateTime DateTime = '2022/11/30 23:59:59'

declare @FlightNumber nvarchar(100)  = '%'
declare @SessionEndReasonID int = 0

declare @Terminal nvarchar(10) = '%'
declare @Airline nvarchar(25) = '%'

declare @Area nvarchar(10) = '%'
declare @SubArea nvarchar(10) = '%'
declare @ABDStationIDs varchar(400) = '0'
declare @ABDStationNames varchar(4000) = 'Display All ABDs'


	IF (@Airline = '0' OR @Airline ='%' )
    SET @Airline = '%'

	IF @Airline = '%'
	BEGIN
		SELECT c.SessionEndReasonID,s.ShortName AS ActionName,c.SessionEndPageID,ISNULL(p.ShortName,' ') AS ScreenName, COUNT(c.ID) AS NumberOfSessions,
			@ABDStationNames AS ABDStations
		FROM CustomerSession c
		JOIN Flight F On F.ID = C.FlightID
		JOIN SessionEndReason s
		ON s.ID = c.SessionEndReasonID
		LEFT JOIN PageType p
		ON p.ID = c.SessionEndPageID
		LEFT JOIN AbdStation a
		ON a.ID = c.ABDStationID
		WHERE (c.LocalTime  BETWEEN @FromDateTime AND @ToDateTime)
			AND (@SessionEndReasonID = 0 OR c.SessionEndREasonID = @SessionEndReasonID )
			AND (a.Terminal LIKE @Terminal )
			AND (ISNULL(a.Area,'') LIKE @Area )
			AND (ISNULL(a.SubArea,'') LIKE @SubArea )
			AND  (F.MarketingCarrier like @Airline)
			AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(a.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
			AND C.SessionEndPageID <> -1 
		GROUP BY c.SessionEndReasonID,s.ShortName,c.SessionEndPageID,p.ShortName
		ORDER BY COUNT(c.ID) DESC,p.ShortName
	END
	ELSE
	BEGIN
		SELECT c.SessionEndReasonID,s.ShortName AS ActionName,c.SessionEndPageID,ISNULL(p.ShortName,' ') AS ScreenName, COUNT(c.ID) AS NumberOfSessions,
			@ABDStationNames AS ABDStations
		FROM CustomerSession c
		JOIN Flight F On F.ID = C.FlightID
		JOIN SessionEndReason s
		ON s.ID = c.SessionEndReasonID
		LEFT JOIN PageType p
		ON p.ID = c.SessionEndPageID
		LEFT JOIN AbdStation a
		ON a.ID = c.ABDStationID
		WHERE (c.LocalTime  BETWEEN @FromDateTime AND @ToDateTime)
			AND (@SessionEndReasonID = 0 OR c.SessionEndREasonID = @SessionEndReasonID )
			AND (a.Terminal LIKE @Terminal )
			AND (ISNULL(a.Area,'') LIKE @Area )
			AND (ISNULL(a.SubArea,'') LIKE @SubArea )
			AND  (F.MarketingCarrier IN (SELECT Items 
				FROM  dbo.Split(@Airline, ',')))
			AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(a.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
			AND C.SessionEndPageID <> -1 
		GROUP BY c.SessionEndReasonID,s.ShortName,c.SessionEndPageID,p.ShortName
		ORDER BY COUNT(c.ID) DESC,p.ShortName
	END