--Notes: Number of passengers per airline per flight per ABD per day
--data columns selected is based on my understanding
--Date: 25-Oct-2022

USE ReportingDB_CDG
GO	

declare @FromDateTime DateTime = '2022/07/01 00:00:00'
declare @ToDateTime DateTime = '2022/07/31 23:59:59'
 
--------------------
DECLARE @MyTable TABLE
(
SNo int IDENTITY(1,1), 
Identifier varchar(50),
Terminal varchar(10),
Area varchar(10),
SubArea varchar(10),
MarketingCarrier varchar(50),
FlightNumber varchar(50),
CustomerSessionID bigint
) 
--------------------
insert into @MyTable(Identifier, Terminal, Area, SubArea, MarketingCarrier, FlightNumber, CustomerSessionID)
SELECT   
       AbdStation.Identifier, 
	   AbdStation.Terminal,
	   AbdStation.Area,
	   AbdStation.SubArea
	  ,b.MarketingCarrier
	  ,b.FlightNumber
	  ,a.ID as CustomerSessionID
FROM [CustomerSession] a 
inner join AbdStation  on a.AbdStationID = AbdStation.ID
inner join Flight b on a.FlightID = b.ID
WHERE DATEPART(year, LocalTime) = DATEPART(year, @FromDateTime) and DATEPART(month, LocalTime) = DATEPART(month, @FromDateTime) and DATEPART(day, LocalTime) = DATEPART(day, @FromDateTime)

 

SELECT   
       
	   (SELECT CASE WHEN ISNULL(Terminal,'') <> '' AND ISNULL(Area,'') <> '' AND ISNULL(SubArea,'') <> ''
							THEN (case when LEN(Terminal) > 1 THEN 'T' ELSE 'T0' END) + Terminal + '_' + Area + '_' + SubArea + '_' + Identifier
						WHEN ISNULL(Terminal,'') <> '' AND ISNULL(Area,'') <> '' AND ISNULL(SubArea,'') = ''
							THEN (case when LEN(Terminal) > 1 THEN 'T' ELSE 'T0' END) + Terminal + '_' + Area + '_' + Identifier
						WHEN ISNULL(Terminal,'') <> ''
							THEN (case when LEN(Terminal) > 1 THEN 'T' ELSE 'T0' END) + Terminal + '_'  + Identifier + '  '
						WHEN ISNULL(Terminal,'') ='' AND  ISNULL(Area,'') <> ''
							THEN Area+ '_'  + Identifier
						ELSE Identifier END)  AS AbdStationName

	  ,MarketingCarrier
	  ,FlightNumber
	  ,count(CustomerSessionID) as PassengerCount
FROM @MyTable
GROUP BY (CASE WHEN ISNULL(Terminal,'') <> '' AND ISNULL(Area,'') <> '' AND ISNULL(SubArea,'') <> ''
							THEN (case when LEN(Terminal) > 1 THEN 'T' ELSE 'T0' END) + Terminal + '_' + Area + '_' + SubArea + '_' + Identifier
						WHEN ISNULL(Terminal,'') <> '' AND ISNULL(Area,'') <> '' AND ISNULL(SubArea,'') = ''
							THEN (case when LEN(Terminal) > 1 THEN 'T' ELSE 'T0' END) + Terminal + '_' + Area + '_' + Identifier
						WHEN ISNULL(Terminal,'') <> '' 
							THEN (case when LEN(Terminal) > 1 THEN 'T' ELSE 'T0' END) + Terminal + '_'  + Identifier + '  '
						WHEN ISNULL(Terminal,'') ='' AND  ISNULL(Area,'') <> ''
							THEN Area+ '_'  + Identifier
						ELSE Identifier END), MarketingCarrier, FlightNumber
 