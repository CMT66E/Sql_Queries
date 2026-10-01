
declare @FromDateTime DateTime = '2021/05/01 00:00:00'
declare @ToDateTime DateTime = '2021/05/31 23:59:59'
declare @FlightNumber nvarchar(100)  = '%'
 
declare @Airline nvarchar(25) = '%'
declare @Terminal nvarchar(10) = '%'
declare @Area nvarchar(10) = '%'
declare @SubArea nvarchar(10) = '%'
declare @ABDStationIDs varchar(400) = '0'
declare @ABDStationNames varchar(4000) = '%'

DROP TABLE IF EXISTS #CustomerSession--add this line for SSMS script running environment

Select * into #CustomerSession From CustomerSession c Where c.LocalTime BETWEEN @FromDateTime and @ToDateTime

Select dt.DocumentDescription, Count(sc.Id) DocScanned  from #CustomerSession c
Left Join ScannedDocument sc
on c.ID = sc.CustomerSessionID 
join ScannerType st on sc.ScannerType = st.ScannerTypeId
join DocumentType dt on dt.DocTypeId = sc.DocType
join AbdStation a on a.ID = c.AbdStationID
Join Flight F on f.id = c.FlightID
Where
c.LocalTime between @FromDateTime and @ToDateTime
AND (CAST(f.FlightNumber AS nvarchar(100)) LIKE @FlightNumber) 
AND (f.MarketingCarrier LIKE @Airline)
AND (a.Terminal LIKE @Terminal )
AND (ISNULL(a.Area,'') LIKE @Area )
AND (ISNULL(a.SubArea,'') LIKE @SubArea )
AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(a.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
Group by dt.DocumentDescription
