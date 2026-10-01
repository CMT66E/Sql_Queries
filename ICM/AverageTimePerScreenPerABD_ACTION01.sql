--SP: AverageTimePerScreenPerABD in ACTION
declare @FromDateTime DateTime = '2021-06-22 00:00:00'
declare @ToDateTime DateTime = '2021-06-22 11:59:59'

	SELECT  AbdStation.ID AS ABDStationID, dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea) AS AbdStationName,
		p.ShortName, ROUND(AVG(c.Duration) / 1000,2) as AvgDuration,COUNT(p.ID) AS NumberOfTimesDisplayed
						  
	FROM         CustomerSessionTimeOnEachScreen c INNER JOIN
						  PageType p ON c.PageTypeID = p.ID INNER JOIN
						  CustomerSession cust ON c.CustomerSessionID = cust.ID INNER JOIN
						  AbdStation ON cust.AbdStationID = AbdStation.ID
	WHERE        (cust.LocalTime  BETWEEN @FromDateTime AND @ToDateTime)
	GROUP BY AbdStation.ID,dbo.GetAbdName(AbdStation.Identifier,AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea),p.ShortName
	ORDER BY dbo.GetAbdName(AbdStation.Identifier,AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea),p.ShortName DESC
