SELECT 
--     a.[ID]
--      ,[BagID]
--      ,[Weight]
--      ,[UtcTime]
--      ,[CustomerSessionID]
--      ,[LocalTime]
	  b.*
FROM [CUSSBagDropDB_JFK].[dbo].[BagWeightUpdate] a left outer join [CUSSBagDropDB_JFK].[dbo].CustomerSession b on a.CustomerSessionID = b.ID
WHERE DatePart(year, [LocalTime]) = 2021 and DatePart(month, [LocalTime]) = 6 and DatePart(day, [LocalTime]) = 9
and not BagID in 
(
select [BagID] from [CUSSReportingDB_JFK].[dbo].[BagWeightUpdate]
WHERE DatePart(year, [LocalTime]) = 2021 and DatePart(month, [LocalTime]) = 6 and DatePart(day, [LocalTime]) = 9
)
order by b.ID 


SELECT 
--     a.[ID]
--      ,[BagID]
--      ,[Weight]
--      ,[UtcTime]
--      ,[CustomerSessionID]
--      ,[LocalTime]
	 distinct  b.ID
FROM [CUSSBagDropDB_JFK].[dbo].[BagWeightUpdate] a left outer join [CUSSBagDropDB_JFK].[dbo].CustomerSession b on a.CustomerSessionID = b.ID
WHERE DatePart(year, [LocalTime]) = 2021 and DatePart(month, [LocalTime]) = 6 and DatePart(day, [LocalTime]) = 9
and not BagID in 
(
select [BagID] from [CUSSReportingDB_JFK].[dbo].[BagWeightUpdate]
WHERE DatePart(year, [LocalTime]) = 2021 and DatePart(month, [LocalTime]) = 6 and DatePart(day, [LocalTime]) = 9
)
order by b.ID 
--------------------------------------------------------------------------------------------------------------------------------------------------

SELECT a.[ID]
      ,[BagID]
      ,[Weight]
      ,[UtcTime]
      ,[CustomerSessionID]
      ,a.[LocalTime]
	  ,b.*
FROM [CUSSBagDropDB_JFK].[dbo].[BagWeightUpdate] a left outer join [CUSSReportingDB_JFK].[dbo].CustomerSession b on a.CustomerSessionID = b.ID
WHERE DatePart(year, a.[LocalTime]) = 2021 and DatePart(month, a.[LocalTime]) = 6 and DatePart(day, a.[LocalTime]) = 9
and not BagID in 
(
select [BagID] from [CUSSReportingDB_JFK].[dbo].[BagWeightUpdate]
WHERE DatePart(year, [LocalTime]) = 2021 and DatePart(month, [LocalTime]) = 6 and DatePart(day, [LocalTime]) = 9
)