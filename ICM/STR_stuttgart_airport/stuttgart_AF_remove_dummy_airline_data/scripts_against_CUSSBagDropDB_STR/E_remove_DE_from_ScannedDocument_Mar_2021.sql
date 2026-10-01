USE CUSSBagDropDB_STR
GO
-------------------------------------------------------
DELETE [dbo].[ScannedDocument]
FROM [dbo].[ScannedDocument] a
inner join CustomerSession b on a.CustomerSessionID = b.ID
inner join Flight c on b.FlightID = c.ID
where c.MarketingCarrier = 'DE'
and 
localTime >= '2021-03-01'
and 
localTime <= '2021-03-31'
 