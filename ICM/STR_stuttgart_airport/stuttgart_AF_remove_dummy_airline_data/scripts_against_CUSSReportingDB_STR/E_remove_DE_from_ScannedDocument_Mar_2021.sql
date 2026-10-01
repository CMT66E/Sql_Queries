
USE CUSSReportingDB_STR
GO
-------------------------------------------------------

DELETE [dbo].[ScannedDocument]
FROM [dbo].[ScannedDocument] a
inner join CustomerSession b on a.CustomerSessionID = b.ID
inner join Flight c on b.FlightID = c.ID
where c.MarketingCarrier = 'DE'
and 
a.localTime >= '2021-03-01'
and 
a.localTime <= '2021-03-31'


SELECT distinct *
FROM [dbo].[ScannedDocument] a 
inner join CustomerSession b on a.CustomerSessionID = b.ID
inner join Flight c on b.FlightID = c.ID
where c.MarketingCarrier = 'DE'
and 
a.localTime >= '2021-03-01'
and 
a.localTime <= '2021-03-31'

 