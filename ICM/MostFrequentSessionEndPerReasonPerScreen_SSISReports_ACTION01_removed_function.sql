USE ReportingDB_CDG
Go

-- MostFrequentSessionEndPerReasonPerScreen_SSISReports
declare @FromDateTime DateTime = '2022/10/01 00:00:00'
declare @ToDateTime DateTime = '2022/10/31 23:59:59'
declare @Airline Nvarchar(20) = 'AF'

	SELECT 
	--dbo.GetAbdName(a.Identifier, a.Terminal,a.Area,a.SubArea) AS AbdStationName,

(SELECT CASE WHEN ISNULL(a.Terminal,'') <> '' AND ISNULL(a.Area,'') <> '' AND ISNULL(a.SubArea,'') <> ''
							THEN (case when LEN(a.Terminal) > 1 then 'T' else 'T0' end) + a.Terminal + '_' + a.Area + '_' + a.SubArea + '_' + a.Identifier
						WHEN ISNULL(a.Terminal,'') <> '' AND ISNULL(a.Area,'') <> '' AND ISNULL(a.SubArea,'') = ''
							THEN (case when LEN(a.Terminal) > 1 then 'T' else 'T0' end) + a.Terminal + '_' + a.Area + '_' + a.Identifier
						WHEN ISNULL(a.Terminal,'') <> '' And (select Count(*) From abdstation Where  ABDType ='ABD' and Terminal <> a.Terminal) > 0
							THEN (case when LEN(a.Terminal) > 1 then 'T' else 'T0' end) + a.Terminal + '_'  + a.Identifier + '  '
						WHEN ISNULL(a.Terminal,'') ='' AND  ISNULL(a.Area,'') <> ''
							THEN a.Area+ '_'  + a.Identifier
						ELSE a.Identifier END) AS AbdStationName,

	ISNULL(p.ShortName,' ') AS ScreenName,
	s.ShortName AS ActionName, 
	COUNT(c.ID) AS NumberOfSessions
		
	FROM CustomerSession c
	JOIN SessionEndReason s
	ON s.ID = c.SessionEndReasonID
	JOIN Flight F ON F.ID = C.FlightID
	LEFT JOIN PageType p
	ON p.ID = c.SessionEndPageID
	LEFT JOIN AbdStation a
	ON a.ID = c.ABDStationID
	WHERE (c.LocalTime  BETWEEN @FromDateTime AND @ToDateTime)
		AND  F.MarketingCarrier LIKE @Airline
		AND C.SessionEndPageID <> -1 
	GROUP BY c.SessionEndReasonID,s.ShortName,c.SessionEndPageID,p.ShortName,a.Identifier, a.Terminal,a.Area,a.SubArea
	ORDER BY dbo.GetAbdName(a.Identifier, a.Terminal,a.Area,a.SubArea),COUNT(c.ID) DESC,p.ShortName
