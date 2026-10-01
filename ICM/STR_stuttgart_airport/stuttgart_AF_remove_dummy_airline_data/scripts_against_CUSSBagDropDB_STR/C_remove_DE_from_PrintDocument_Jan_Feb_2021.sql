
USE CUSSBagDropDB_STR
GO
-------------------------------------------------------
DELETE [dbo].[PrintDocument]
FROM [dbo].[PrintDocument] a
inner join CustomerSession b on a.CustomerSessionID = b.ID
inner join Flight c on b.FlightID = c.ID
where c.MarketingCarrier = 'DE'
and 
localTime >= '2021-01-01'
and 
localTime <= '2021-01-31'

SELECT distinct *
FROM [dbo].[PrintDocument] a 
inner join CustomerSession b on a.CustomerSessionID = b.ID
inner join Flight c on b.FlightID = c.ID
where c.MarketingCarrier = 'DE'
and 
localTime >= '2021-01-01'
and 
localTime <= '2021-01-31'

-------------------------------------------------------
 
DELETE [dbo].[PrintDocument]
FROM [dbo].[PrintDocument] a
inner join CustomerSession b on a.CustomerSessionID = b.ID
inner join Flight c on b.FlightID = c.ID
where c.MarketingCarrier = 'DE'
and 
localTime >= '2021-02-01'
and 
localTime <= '2021-02-28'

SELECT *
FROM [dbo].[PrintDocument] a 
inner join CustomerSession b on a.CustomerSessionID = b.ID
inner join Flight c on b.FlightID = c.ID
where c.MarketingCarrier = 'DE'
and 
localTime >= '2021-02-01'
and 
localTime <= '2021-02-28'
-------------------------------------------------------