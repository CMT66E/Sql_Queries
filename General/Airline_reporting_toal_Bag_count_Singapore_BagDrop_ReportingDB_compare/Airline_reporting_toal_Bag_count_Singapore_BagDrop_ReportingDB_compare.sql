SELECT  a.[ID]
      ,[BagID]
      ,[Weight]
      ,[UtcTime]
      ,[CustomerSessionID]
      ,[LocalTime]
      ,b.*
      ,c.*
  FROM [BagDropDB_SIN].[dbo].[BagWeightUpdate] a 
  inner join CustomerSession b on a.CustomerSessionID = b.ID
  inner join Flight c on b.FlightID = c.ID
  WHERE datepart(year, a.LocalTime) = 2026 and datepart(month, a.LocalTime) = 4 and c.MarketingCarrier = 'AK'


SELECT  a.[ID]
      ,[BagID]
      ,[Weight]
      ,[UtcTime]
      ,[CustomerSessionID]
      ,[LocalTime]
      ,b.*
      ,c.*
  FROM [ReportingDB_SIN].[dbo].[BagWeightUpdate] a 
  inner join CustomerSession b on a.CustomerSessionID = b.ID
  inner join Flight c on b.FlightID = c.ID
  WHERE datepart(year, a.LocalTime) = 2026 and datepart(month, a.LocalTime) = 4 and c.MarketingCarrier = 'AK'
