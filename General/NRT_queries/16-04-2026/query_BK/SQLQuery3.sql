SELECT TOP (1000) [ROW_ID]
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
   order by ROW_ID desc

   ------------

  SELECT 
      [MarketingCarrier], 
      sum([BagCount]) as TotalCount
  FROM [study].[dbo].[BagsCountPerDayPerAirline]
  WHERE monthyear = '2026-02-01 00:00:00.000' and [MarketingCarrier] = 'NH'
  group by [MarketingCarrier]


  SELECT 
      [MarketingCarrier], 
      sum([BagCount]) as TotalCount
  FROM [study].[dbo].[BagsCountPerDayPerAirline_FEB2026]
  WHERE monthyear = '2026-02-01 00:00:00.000'
  group by [MarketingCarrier]

  --SELECT
  --    [MarketingCarrier], 
  --    sum([BagCount]) as TotalCount
  --FROM [study].[dbo].[BagsCountPerDayPerAirline]
  --WHERE monthyear = '2026-03-01 00:00:00.000'
  --group by [MarketingCarrier]
