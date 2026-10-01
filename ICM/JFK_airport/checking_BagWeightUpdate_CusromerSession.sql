/****** Script for SelectTopNRows command from SSMS  ******/
SELECT a.[ID]
      ,[BagID]
      ,[Weight]
      ,[UtcTime]
      ,[CustomerSessionID]      
      ,a.[LocalTime] 
	  ,b.*
  FROM [CUSSBagDropDB_JFK].[dbo].[BagWeightUpdate] a LEFT OUTER JOIN [CustomerSession] b ON  a.CustomerSessionID = b.ID
  WHERE DatePart(year, a.[LocalTime]) = 2021 and DatePart(month, a.[LocalTime]) = 6 and DatePart(day, a.[LocalTime]) = 9
  order by b.[ID]
  --total 106 records - 9 records = 97 records
  --[CustomerSessionID] : 2521, 2516 missing
  ------

SELECT [ID]
      ,[BagID]
      ,[Weight]
      ,[UtcTime]
      ,[CustomerSessionID]
      ,[TimeSlot5minID]
      ,[TimeSlot10minID]
      ,[TimeSlotHourlyID]
      ,[DayOfTheWeekID]
      ,[LocalTime]
      ,[AbdStationID]
  FROM [CUSSReportingDB_JFK].[dbo].[BagWeightUpdate]
  WHERE DatePart(year, [LocalTime]) = 2021 and DatePart(month, [LocalTime]) = 6 and DatePart(day, [LocalTime]) = 9
  order by [BagID]

