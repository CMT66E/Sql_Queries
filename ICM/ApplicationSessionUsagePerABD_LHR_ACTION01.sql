declare @FromDateTime DateTime = '2022-03-01 00:00:00'
declare @ToDateTime DateTime = '2022-03-07 23:59:59'
declare @Airline nvarchar(50) = '%'
declare @CUSSApplicationID int = 0

SELECT     dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal, AbdStation.Area,AbdStation.SubArea) AS AbdStationName, 
	ApplicationSessionUsage.AirlineID, Airlines.Airline,  
	ApplicationSessionUsage.CussApplicationID, CussApplications.Application AS CussApplication,
	SUM(ApplicationSessionUsage.MinutesInState) AS MinutesInState
FROM         ApplicationSessionUsage INNER JOIN
                      Airlines ON ApplicationSessionUsage.AirlineID = Airlines.ID INNER JOIN
                      AbdStation ON ApplicationSessionUsage.ABDStationID = AbdStation.ID INNER JOIN 
                      CussApplications ON ApplicationSessionUsage.CussApplicationID = CussApplications.CussApplicationID
WHERE     (ApplicationSessionUsage.Date BETWEEN @FromDateTime AND @ToDateTime) 
	AND (Airlines.Airline LIKE @Airline)
	AND (@CUSSApplicationID = 0 OR ApplicationSessionUsage.CussApplicationID = @CUSSApplicationID)
GROUP BY AbdStation.Identifier, AbdStation.Terminal, AbdStation.Area,AbdStation.SubArea, Airlines.Airline,ApplicationSessionUsage.AirlineID, ApplicationSessionUsage.CussApplicationID, CussApplications.Application
ORDER BY dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal, AbdStation.Area,AbdStation.SubArea), Airlines.Airline, CussApplications.Application