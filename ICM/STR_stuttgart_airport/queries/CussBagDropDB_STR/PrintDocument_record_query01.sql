SELECT a.[ID]
      ,[CustomerSessionID]
      ,[PrinterType]
      ,[DocType]
      ,[UtcdeliveryTime]      
	  ,b.*
	  ,c.*
FROM [dbo].[PrintDocument] a 
inner join CustomerSession b on a.CustomerSessionID = b.ID
inner join Flight c on b.FlightID = c.ID
where 
--c.MarketingCarrier = 'DE' and 
FlightNumber <> '8887' and 
a.localTime >= '2021-04-01' and 
a.localTime <= '2021-04-30'
order by c.MarketingCarrier