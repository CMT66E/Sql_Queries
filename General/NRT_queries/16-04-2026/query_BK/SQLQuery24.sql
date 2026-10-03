SELECT [Date]
      ,[monthyear]
      ,[Year]
      ,[Month]
      ,[Day]
      ,[FlightArea]
      ,[MarketingCarrier]
      ,a.[TimeSlot5minID]
      ,a.[AbdStationID]
      ,[TotalWeight]
      ,[BagWeightUpdateID]
      ,[BagCount]
      ,b.*
  FROM [study].[dbo].[BagsCountPerDayPerAirline_NH] a inner join ReportingDB_NRT.dbo.BagWeightUpdate b on a.BagWeightUpdateID = b.ID


  select * from ReportingDB_NRT.dbo.Bag where ID in
  (
      --10438 records
      select distinct a.BagID from ReportingDB_NRT_FEB2026.dbo.BagWeightUpdate a inner join ReportingDB_NRT_FEB2026.dbo.CustomerSession b on a.CustomerSessionID =b.ID
      where a.ID in
      (
          select [BagWeightUpdateID] 
          from [study].[dbo].BagsCountPerDayPerAirline_NH_FEB2026
          where not [BagWeightUpdateID] in
          (
           select [BagWeightUpdateID] FROM [study].[dbo].[BagsCountPerDayPerAirline_NH]
          )
      )
  )

  select * from ReportingDB_NRT.dbo.Flight where ID in
  (
      --10443 records
      select  FlightID from ReportingDB_NRT_FEB2026.dbo.BagWeightUpdate a inner join ReportingDB_NRT_FEB2026.dbo.CustomerSession b on a.CustomerSessionID =b.ID
      where a.ID in
      (
          select [BagWeightUpdateID] 
          from [study].[dbo].BagsCountPerDayPerAirline_NH_FEB2026
          where not [BagWeightUpdateID] in
          (
           select [BagWeightUpdateID] FROM [study].[dbo].[BagsCountPerDayPerAirline_NH]
          )
      )
  )




  select * from ReportingDB_NRT_FEB2026.dbo.BagWeightUpdate a inner join ReportingDB_NRT_FEB2026.dbo.CustomerSession b on a.CustomerSessionID =b.ID
  where a.ID in
  (
      select [BagWeightUpdateID] 
      from [study].[dbo].BagsCountPerDayPerAirline_NH_FEB2026
      where not [BagWeightUpdateID] in
      (
       select [BagWeightUpdateID] FROM [study].[dbo].[BagsCountPerDayPerAirline_NH]
      )
  )

  select [BagWeightUpdateID] 
  from [study].[dbo].BagsCountPerDayPerAirline_NH_FEB2026
  where not [BagWeightUpdateID] in
  (
   select [BagWeightUpdateID] FROM [study].[dbo].[BagsCountPerDayPerAirline_NH]
  )


  select a.*, b.*
  from [study].[dbo].BagsCountPerDayPerAirline_NH_FEB2026 a inner join ReportingDB_NRT.dbo.BagWeightUpdate b on a.BagWeightUpdateID = b.ID
  where not a.[BagWeightUpdateID] in
  (
   select [BagWeightUpdateID] FROM [study].[dbo].[BagsCountPerDayPerAirline_NH]
  )

  select a.*, b.*
  from [study].[dbo].BagsCountPerDayPerAirline_NH_FEB2026 a inner join ReportingDB_NRT.dbo.BagWeightUpdate b on a.BagWeightUpdateID = b.ID
  where not a.[BagWeightUpdateID] in
  (
   select [BagWeightUpdateID] FROM [study].[dbo].[BagsCountPerDayPerAirline_NH]
  )