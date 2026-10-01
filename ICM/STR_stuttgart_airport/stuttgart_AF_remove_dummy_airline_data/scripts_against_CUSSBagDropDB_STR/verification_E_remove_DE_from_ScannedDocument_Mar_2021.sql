--This script is to check those records which its correspondent delete script will delete
--for example if first query below returned far more than 326 records
--you need stop executing the delete script because database data struction may have big changes

--total 326 records -------------------------------------  
SELECT a.[ID]
      ,[CustomerSessionID]
      ,[ScannerType]
      ,[DocType]
      ,[UtcdeliveryTime]
      ,[localTime]
	  ,b.FlightID
	  ,c.MarketingCarrier
FROM [dbo].[ScannedDocument] a 
inner join CustomerSession b on a.CustomerSessionID = b.ID
inner join Flight c on b.FlightID = c.ID
where c.MarketingCarrier = 'DE'
and 
localTime >= '2021-03-01'
and 
localTime <= '2021-03-31'