USE BagDropDB_CDG
GO	

declare @FromDateTime DateTime = '2022/07/01 00:00:00'
declare @ToDateTime DateTime = '2022/07/31 23:59:59'
 
--------------------
DECLARE @MyTable TABLE
(
SNo int IDENTITY(1,1), 
CustomerID bigint,
GivenName varchar(50),
Surname varchar(50),
MarketingCarrier varchar(20),
FlightNumber varchar(20),
CustomerSessionID bigint
) 
--------------------
insert into @MyTable(CustomerID, GivenName, Surname, MarketingCarrier, FlightNumber, CustomerSessionID)
SELECT   
       a.CustomerID as CustomerID
	  ,Customer.GivenName as GivenName
	  ,Customer.Surname as Surname
	  ,b.MarketingCarrier
	  ,b.FlightNumber
	  ,a.ID as CustomerSessionID
FROM [CustomerSession] a 
inner join AbdStation  on a.AbdStationID = AbdStation.ID
inner join Flight b on a.FlightID = b.ID
inner join Customer ON a.CustomerID = Customer.ID
WHERE DATEPART(year, LocalCreationTime) = DATEPART(year, @FromDateTime) and DATEPART(month, LocalCreationTime) = DATEPART(month, @FromDateTime) and DATEPART(day, LocalCreationTime) = DATEPART(day, @FromDateTime)

 

SELECT   
       CustomerID 
	  ,GivenName
	  ,Surname
	  ,MarketingCarrier
	  ,FlightNumber
	  ,count(CustomerSessionID) as PassengerCount
FROM @MyTable
GROUP BY CustomerID 
	  ,GivenName
	  ,Surname, MarketingCarrier, FlightNumber
 