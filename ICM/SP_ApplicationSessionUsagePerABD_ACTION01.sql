declare @FromDateTime DateTime ='2020-11-27 00:00:00'
declare @ToDateTime DateTime ='2020-11-27 23:59:59'

declare @FlightNumber nvarchar(100)  = '%'
declare @BoardPass nvarchar(25) = '%'
declare @CUSSApplicationID int = '0'
declare @Airline nvarchar(25) = '%'
declare @Terminal nvarchar(10) = '%'
declare @Area nvarchar(10) = '%'
declare @SubArea nvarchar(10) = '%'
declare @ABDStationIDs varchar(400) = '0'
declare @ABDStationNames varchar(4000) = '%'


SELECT     dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal, AbdStation.Area,AbdStation.SubArea,AbdStation.AbdType) AS AbdStationName, 
	ApplicationSessionUsage.AirlineID, Airlines.Airline,  
	ApplicationSessionUsage.CussApplicationID, CussApplications.Application AS CussApplication,
	SUM(ApplicationSessionUsage.MinutesInState) AS MinutesInState
FROM         ApplicationSessionUsage INNER JOIN
                      Airlines ON ApplicationSessionUsage.AirlineID = Airlines.ID INNER JOIN
                      AbdStation ON ApplicationSessionUsage.ABDStationID = AbdStation.ID INNER JOIN 
                      CussApplications ON ApplicationSessionUsage.CussApplicationID = CussApplications.CussApplicationID
WHERE     (ApplicationSessionUsage.Date BETWEEN @FromDateTime AND @ToDateTime) 
	AND (Airlines.Airline LIKE @Airline)
	--AND (@CUSSApplicationID = 0 OR ApplicationSessionUsage.CussApplicationID = @CUSSApplicationID)
	AND (AbdStation.Terminal LIKE @Terminal)
	AND (ISNULL(AbdStation.Area,'') LIKE @Area )		
	AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea ) 
	AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
GROUP BY AbdStation.Identifier, AbdStation.Terminal, AbdStation.Area,AbdStation.SubArea,AbdStation.AbdType, Airlines.Airline,ApplicationSessionUsage.AirlineID, ApplicationSessionUsage.CussApplicationID, CussApplications.Application
ORDER BY dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal, AbdStation.Area,AbdStation.SubArea,AbdStation.AbdType), Airlines.Airline, CussApplications.Application