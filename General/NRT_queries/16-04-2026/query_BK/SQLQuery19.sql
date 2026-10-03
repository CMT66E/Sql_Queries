SELECT  [ROW_ID]
      ,[Date]
      ,[monthyear]
      ,[Year]
      ,[Month]
      ,[Day]
      ,[FlightArea]
      ,[MarketingCarrier]
      ,[TimeSlot5minID]
      ,[AbdStationID]
      ,[TotalWeight]
      ,[BagCount]
  FROM [study].[dbo].[BagsCountPerDayPerAirline]
  WHERE [monthyear] = '2026-02-01 00:00:00.000' and [MarketingCarrier] = 'NH'



  SELECT 
      [MarketingCarrier], 
      sum([BagCount]) as TotalCount
  FROM [study].[dbo].[BagsCountPerDayPerAirline]
  WHERE monthyear = '2026-02-01 00:00:00.000' and [MarketingCarrier] = 'NH'
  group by [MarketingCarrier]

