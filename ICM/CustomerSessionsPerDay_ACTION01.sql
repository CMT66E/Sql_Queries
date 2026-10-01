declare @FromDateTime DateTime ='2022-03-07 00:00:00'
declare @ToDateTime DateTime ='2022-03-07 23:59:59'

declare @FlightNumber nvarchar(100)  = '%'
declare @BoardPass nvarchar(25) = '%'
 
declare @Airline nvarchar(25) = '%'
declare @Terminal nvarchar(10) = '%'
declare @Area nvarchar(10) = '%'
declare @SubArea nvarchar(10) = '%'
declare @ABDStationIDs varchar(400) = '0'
declare @ABDStationNames varchar(4000) = '%'
 
---------------------
 
---------------------

SELECT  DATEPART(YEAR, CustomerSession.LocalTime) AS Year, DATEPART(MONTH, CustomerSession.LocalTime) AS Month, 
	DATEPART(DAY, CustomerSession.LocalTime) AS Day , COUNT(CustomerSession.LocalTime) AS CustomerSessions, @ABDStationNames AS ABDStation
FROM         CustomerSession INNER JOIN
            Flight ON CustomerSession.FlightID = Flight.ID INNER JOIN
            ABDStation ON ABDStation.ID = CustomerSession.ABDStationID
WHERE     CustomerSession.LocalTime BETWEEN @FromDateTime AND @ToDateTime 
	AND (CAST(Flight.FlightNumber as nvarchar(100)) like @FlightNumber) 
	AND (CustomerSession.CustomerLookupType like @BoardPass) 
	AND (Flight.MarketingCarrier like @Airline)
	AND (AbdStation.Terminal LIKE @Terminal )
	AND (ISNULL(AbdStation.Area,'') LIKE @Area )
	AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
	AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
GROUP BY DATEPART(YEAR, CustomerSession.LocalTime), DATEPART(MONTH, CustomerSession.LocalTime), DATEPART(DAY, CustomerSession.LocalTime)
ORDER BY DATEPART(YEAR, CustomerSession.LocalTime), DATEPART(MONTH, CustomerSession.LocalTime), DATEPART(DAY, CustomerSession.LocalTime)

select * from CussReportingDB_QF.dbo.CustomerSession where datepart(year, UtcCreationTime) = datepart(year, @FromDateTime) and datepart(month, UtcCreationTime) = datepart(month, @FromDateTime) 
 and datepart(day, UtcCreationTime) = datepart(day, @FromDateTime)