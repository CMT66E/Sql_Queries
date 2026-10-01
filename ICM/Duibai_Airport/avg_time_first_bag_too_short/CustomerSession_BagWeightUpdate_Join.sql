
SELECT [CustomerSession].[ID]
      ,[CustomerID]
      ,[CustomerSession].[AbdStationID]
      ,[CustomerLookupType]
      ,[PNR]
      ,[UtcCreationTime]
      ,[FlightID]
      ,[CustomerSession].[TimeSlot5minID]
      ,[CustomerSession].[TimeSlot10minID]
      ,[CustomerSession].[TimeSlotHourlyID]
      ,[CustomerSession].[DayOfTheWeekID]
      ,[CustomerSession].[LocalTime]
      ,[UtcCompletionTime]
      ,[SessionDuration]
	  ,DateDiff(ss, [UtcCreationTime], [UtcCompletionTime]) as TIMEUSEDSECONDS
	  ,DateDiff(ss, BagWeightUpdate.[UtcTime], [CustomerSession].[UtcCompletionTime]) as TIMEUSEDSECONDS_EACHBAG
	  ,BagWeightUpdate.*
  FROM [dbo].[CustomerSession]
  inner join BagWeightUpdate on [CustomerSession].ID = BagWeightUpdate.[CustomerSessionID]
  WHERE [CustomerSession].[ID] = 25977    --- 25977 three bags checked in  -- 25978 two bags checked in -- 25980 with proper PNR
  order by [CustomerSession].ID desc

  SELECT [CustomerSession].[ID]
      ,[CustomerID]
      ,[CustomerSession].[AbdStationID]
      ,[CustomerLookupType]
      ,[PNR]
      ,[UtcCreationTime]
      ,[FlightID]
      ,[CustomerSession].[TimeSlot5minID]
      ,[CustomerSession].[TimeSlot10minID]
      ,[CustomerSession].[TimeSlotHourlyID]
      ,[CustomerSession].[DayOfTheWeekID]
      ,[CustomerSession].[LocalTime]
      ,[UtcCompletionTime]
      ,[SessionDuration]
	  ,DateDiff(ss, [UtcCreationTime], [UtcCompletionTime]) as TIMEUSEDSECONDS
	  ,DateDiff(ss, BagWeightUpdate.[UtcTime], [CustomerSession].[UtcCompletionTime]) as TIMEUSEDSECONDS_EACHBAG
	  ,BagWeightUpdate.*
  FROM [dbo].[CustomerSession]
  inner join BagWeightUpdate on [CustomerSession].ID = BagWeightUpdate.[CustomerSessionID]
  WHERE [CustomerSession].[ID] = 25978    --- 25977 three bags checked in  -- 25978 two bags checked in -- 25980 with proper PNR
  order by [CustomerSession].ID desc


    SELECT [CustomerSession].[ID]
      ,[CustomerID]
      ,[CustomerSession].[AbdStationID]
      ,[CustomerLookupType]
      ,[PNR]
      ,[UtcCreationTime]
      ,[FlightID]
      ,[CustomerSession].[TimeSlot5minID]
      ,[CustomerSession].[TimeSlot10minID]
      ,[CustomerSession].[TimeSlotHourlyID]
      ,[CustomerSession].[DayOfTheWeekID]
      ,[CustomerSession].[LocalTime]
      ,[UtcCompletionTime]
      ,[SessionDuration]
	  ,DateDiff(ss, [UtcCreationTime], [UtcCompletionTime]) as TIMEUSEDSECONDS
	  ,DateDiff(ss, BagWeightUpdate.[UtcTime], [CustomerSession].[UtcCompletionTime]) as TIMEUSEDSECONDS_EACHBAG
	  ,BagWeightUpdate.*
  FROM [dbo].[CustomerSession]
  inner join BagWeightUpdate on [CustomerSession].ID = BagWeightUpdate.[CustomerSessionID]
  WHERE [CustomerSession].[ID] = 25980    --- 25977 three bags checked in  -- 25978 two bags checked in -- 25980 with proper PNR
  order by [CustomerSession].ID desc