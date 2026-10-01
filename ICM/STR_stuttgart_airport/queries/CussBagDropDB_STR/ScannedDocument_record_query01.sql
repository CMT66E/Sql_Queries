 

USE CUSSBagDropDB_STR
GO
-------------------------------------------------------
--total 326 records -------------------------------------
SELECT a.[ID]
      ,[CustomerSessionID]
      ,[ScannerType]
      ,[DocType]
      ,[UtcdeliveryTime]
      ,a.[localTime]
	  ,b.FlightID	 
	  ,c.MarketingCarrier
	  ,c.ID
	  ,c.FlightNumber
	  ,c.DepartureDate
	  ,c.BoardPoint
	  ,c.OffPoint
FROM [dbo].[ScannedDocument] a 
inner join CustomerSession b on a.CustomerSessionID = b.ID
inner join Flight c on b.FlightID = c.ID
where 
--c.MarketingCarrier = 'DE' and 
c.FlightNumber <> '8887' and
a.localTime >= '2021-04-01' and 
a.localTime <= '2021-04-30'
 
-------------------------------------------------------