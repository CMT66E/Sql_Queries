SELECT TOP (1000) a.[ID]
      ,[BagID]
      ,[Weight]
      ,[UtcTime]
      ,[CustomerSessionID]
      ,a.[TimeSlot5minID]
      ,a.[TimeSlot10minID]
      ,a.[TimeSlotHourlyID]
      ,a.[DayOfTheWeekID]
      ,a.[LocalTime]
      ,a.[AbdStationID]
  FROM [CUSSReportingDB_NRT].[dbo].[BagWeightUpdate] a inner join CustomerSession b on a.CustomerSessionID = b.ID
  WHERE a.CustomerSessionID in 
  (
13886159,
13886146,
13887239,
13887239,
13887241
  )

select *
from [CUSSReportingDB_NRT].[dbo].[CustomerSession]
WHERE ID in 
(
13581189,
13640610,
13600026,
13873091
)

