  select a.*, b.*, d.MarketingCarrier
  from PrintDocument a 
  inner join CustomerSession b on a.CustomerSessionID = b.ID 
  inner join AbdStation c on b.AbdStationID = c.ID
  inner join Flight d on b.FlightID = d.ID
 where 
  datepart(year, b.UtcCreationTime) = 2021 
and datepart(month, b.UtcCreationTime) = 10 
and d.MarketingCarrier in ('EW')
and b.SessionDuration > 3


select * from CustomerSession where ID = 112454
-----------------------------------------------------------------------------------------------------------------
--  select a.*, b.*, c.MarketingCarrier
--  from CustomerSession a 
--  inner join AbdStation b on a.AbdStationID = b.ID
--  inner join Flight c on a.FlightID = c.ID
--  where a.ID
--   in 
--   (
--SELECT  
--    [CustomerSessionID] 
--  FROM [dbo].[PrintDocument]
--   )
--and datepart(year, a.[UtcCreationTime]) = 2021 
--and datepart(month, a.[UtcCreationTime]) = 10 
--and c.MarketingCarrier in ('DE')

--and c.MarketingCarrier in ('EW')
--and c.MarketingCarrier in ('DE', 'EW')

-----------------------------------------------------------------------------------------------------------------
--  select a.*, b.* from CustomerSession a inner join AbdStation b on a.AbdStationID = b.ID
--  where a.ID
--   in 
--   (
--  SELECT  
--    [CustomerSessionID] 
--  FROM [dbo].[ScannedDocument]
--   )
--and datepart(year, a.[UtcCreationTime]) = 2021 
--and datepart(month, a.[UtcCreationTime]) = 10 