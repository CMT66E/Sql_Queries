USE ReportingDB_NRT  --2890
GO


declare @FromDateTime DateTime = '2026/02/01 00:00:00 AM'
declare @ToDateTime DateTime = '2026/02/28 11:59:59 PM'
declare @FlightNumber nvarchar(100)  = '%'
declare @BoardPass nvarchar(25) = '%'
declare @BagTagType nvarchar(25) = '%'
declare @Airline nvarchar(25) = 'ZE'
declare @Terminal nvarchar(10) = '%'
declare @Area nvarchar(10) = '%'
declare @SubArea nvarchar(10) = '%'
--declare @ABDStationIDs varchar(400) = ',23842,23850,33949,35402,35418,35492,35808,35810,'
declare @ABDStationIDs varchar(400) ='0'
declare @ABDStationNames varchar(4000) = '%'

--SP: TotalBagsPerDay
DROP TABLE IF EXISTS #TempA
DROP TABLE IF EXISTS #TempB

SELECT     DATEPART(YEAR, BagWeightUpdate.LocalTime) AS Year, DATEPART(MONTH, BagWeightUpdate.LocalTime) AS Month, DATEPART(DAY, BagWeightUpdate.LocalTime) AS Day, 
	@ABDStationNames AS ABDStations, SUM(BagWeightUpdate.Weight) AS TotalWeight, COUNT(BagWeightUpdate.LocalTime) AS Bags INTO #TempA
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
GROUP BY DATEPART(YEAR, BagWeightUpdate.LocalTime), DATEPART(MONTH, BagWeightUpdate.LocalTime), DATEPART(DAY, BagWeightUpdate.LocalTime)
ORDER BY DATEPART(YEAR, BagWeightUpdate.LocalTime), DATEPART(MONTH, BagWeightUpdate.LocalTime), DATEPART(DAY, BagWeightUpdate.LocalTime)

-----------------------------------------------------------------------------------------------------------------------------

USE ReportingDB_NRT_FEB2026 -- 2965
GO


declare @FromDateTime DateTime = '2026/02/01 00:00:00 AM'
declare @ToDateTime DateTime = '2026/02/28 11:59:59 PM'
declare @FlightNumber nvarchar(100)  = '%'
declare @BoardPass nvarchar(25) = '%'
declare @BagTagType nvarchar(25) = '%'
declare @Airline nvarchar(25) = 'ZE'
declare @Terminal nvarchar(10) = '%'
declare @Area nvarchar(10) = '%'
declare @SubArea nvarchar(10) = '%'
--declare @ABDStationIDs varchar(400) = ',23842,23850,33949,35402,35418,35492,35808,35810,'
declare @ABDStationIDs varchar(400) ='0'
declare @ABDStationNames varchar(4000) = '%'

--SP: TotalBagsPerDay

SELECT     DATEPART(YEAR, BagWeightUpdate.LocalTime) AS Year, DATEPART(MONTH, BagWeightUpdate.LocalTime) AS Month, DATEPART(DAY, BagWeightUpdate.LocalTime) AS Day, 
	@ABDStationNames AS ABDStations, SUM(BagWeightUpdate.Weight) AS TotalWeight, COUNT(BagWeightUpdate.LocalTime) AS Bags  INTO #TempB
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
GROUP BY DATEPART(YEAR, BagWeightUpdate.LocalTime), DATEPART(MONTH, BagWeightUpdate.LocalTime), DATEPART(DAY, BagWeightUpdate.LocalTime)
ORDER BY DATEPART(YEAR, BagWeightUpdate.LocalTime), DATEPART(MONTH, BagWeightUpdate.LocalTime), DATEPART(DAY, BagWeightUpdate.LocalTime)


select * from #TempA order by [Day]
select SUM(Bags) as TotalA from  #TempA 


select * from #TempB order by [Day]
select SUM(Bags) as TotalB from  #TempB  