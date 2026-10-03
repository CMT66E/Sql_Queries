USE CUSSReportingDB_NRT_FEB2026 
GO

declare @FromDateTime DateTime = '2026/02/01 00:00:00 AM'
declare @ToDateTime DateTime = '2026/02/28 11:59:59 PM'
declare @FlightNumber nvarchar(100)  = '%'
declare @BoardPass nvarchar(25) = '%'
declare @BagTagType nvarchar(25) = '%'
declare @Airline nvarchar(25) = 'NQ'
declare @Terminal nvarchar(10) = '%'
declare @Area nvarchar(10) = '%'
declare @SubArea nvarchar(10) = '%'
--declare @ABDStationIDs varchar(400) = ',23842,23850,33949,35402,35418,35492,35808,35810,'
declare @ABDStationIDs varchar(400) ='0'
declare @ABDStationNames varchar(4000) = '%'

--SP: TotalBagsPerDay

SELECT     *
FROM         BagWeightUpdate INNER JOIN
			CustomerSession ON BagWeightUpdate.CustomerSessionID = CustomerSession.ID INNER JOIN
			Flight ON CustomerSession.FlightID = Flight.ID INNER JOIN 
			Bag ON BagWeightUpdate.BagID = Bag.ID INNER JOIN
		AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID
WHERE     (CustomerSession.LocalTime BETWEEN @FromDateTime AND @ToDateTime) 
	AND (CAST(Flight.FlightNumber as nvarchar(100)) like @FlightNumber) 
	AND (CustomerSession.CustomerLookupType like @BoardPass) 
	AND (Bag.BagTagType like @BagTagType)
	AND (Flight.MarketingCarrier IN (SELECT Items FROM  dbo.Split(@Airline, ',')))
	AND (AbdStation.Terminal LIKE @Terminal )
	AND (ISNULL(AbdStation.Area,'') LIKE @Area )
	AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
	AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
 