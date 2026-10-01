--This script is to check those records which its correspondent delete script will delete
--for example if first query below returned far more than 326 records
--you need stop executing the delete script because database data struction may have big changes

USE CUSSReportingDB_STR
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
	  ,c.*
FROM [dbo].[ScannedDocument] a 
inner join CustomerSession b on a.CustomerSessionID = b.ID
inner join Flight c on b.FlightID = c.ID
where c.MarketingCarrier = 'DE'
and 
a.localTime >= '2021-03-01'
and 
a.localTime <= '2021-03-31'
 
-------------------------------------------------------
 