--This script is to check those records which its correspondent delete script will delete
--for example if first query below returned far more than 4 records
--or second query returned far more than 11 records you need stop executing the delete script because database data struction may have big changes

USE CUSSBagDropDB_STR
GO
-------------------------------------------------------
--total 4 records -------------------------------------
SELECT TOP (1000) a.[ID]
      ,[CustomerSessionID]
      ,[PrinterType]
      ,[DocType]
      ,[UtcdeliveryTime]
      ,[localTime]
	  ,b.FlightID
	  --,b.*
	  ,c.MarketingCarrier
	  ,c.*
FROM [dbo].[PrintDocument] a 
inner join CustomerSession b on a.CustomerSessionID = b.ID
inner join Flight c on b.FlightID = c.ID
where c.MarketingCarrier = 'DE'
and 
localTime >= '2021-01-01'
and 
localTime <= '2021-01-31'

-------------------------------------------------------
--total 11 records -------------------------------------  
SELECT TOP (1000) a.[ID]
      ,[CustomerSessionID]
      ,[PrinterType]
      ,[DocType]
      ,[UtcdeliveryTime]
      ,[localTime]
	  ,b.FlightID
	  ,c.MarketingCarrier
FROM [dbo].[PrintDocument] a 
inner join CustomerSession b on a.CustomerSessionID = b.ID
inner join Flight c on b.FlightID = c.ID
where c.MarketingCarrier = 'DE'
and 
localTime >= '2021-02-01'
and 
localTime <= '2021-02-28'

-------------------------------------------------------
 