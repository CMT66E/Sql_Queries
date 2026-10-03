SELECT  
       [ID]
      ,[CustomerID]
      ,[AbdStationID]
      ,[CustomerLookupType]
      ,[PNR]
      ,[FlightID]
      ,[UtcCreationTime]
      ,[UtcCompletionTime]
      ,[LocalCreationTime]
      ,[LocalCompletionTime]
      ,[ApplicationSessionId]
      --,isnull(cast(cast(DATEDIFF(MILLISECOND, [LocalCreationTime], [LocalCompletionTime]) as decimal(10, 2))/1000 as decimal(10,2)), 0.00) as SessionDurationCalculation
      ,DATEDIFF(second, [LocalCreationTime], [LocalCompletionTime]) as SessionDuration
      FROM [CUSSBagDropDB_NRT].[dbo].[CustomerSession]
WHERE DATEPART(year, LocalCreationTime) = 2026 and DATEPART(month, LocalCreationTime) = 6 -- June 2026: 87,113 | May 2026: 101,643 | April 2026: 93,331
and [AbdStationID] in
  (
144,
145,
146,
147,
148,
149,
150,
151,
152,
153,
154,
155,
156,
157,
158,
159,
160,
161,
162,
163,
164,
165,
166,
167
  ) 
  and DATEDIFF(second, [LocalCreationTime], [LocalCompletionTime]) > 20
---------------------------------

--SELECT *
--  FROM [CUSSBagDropDB_NRT].[dbo].[BagWeightUpdate]
--WHERE DATEPART(year, LocalTime) = 2026 and DATEPART(month, LocalTime) = 6


select * 
  FROM [CUSSReportingDB_NRT].[dbo].[BagWeightUpdate]
WHERE DATEPART(year, LocalTime) = 2026 and DATEPART(month, LocalTime) = 6 and 
 [AbdStationID] in
  (
144,
145,
146,
147,
148,
149,
150,
151,
152,
153,
154,
155,
156,
157,
158,
159,
160,
161,
162,
163,
164,
165,
166,
167
  ) 

  --15397019, 15397040, 15397056, 15397069, 15397079