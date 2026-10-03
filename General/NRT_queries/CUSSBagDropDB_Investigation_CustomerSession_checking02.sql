SELECT  a.[ID]
      ,[BagID]
      ,[Weight]
      ,[UtcTime]
      ,[CustomerSessionID]
      ,[LocalTime]
      ,b.*
  FROM [CUSSBagDropDB_NRT].[dbo].[BagWeightUpdate] a left outer join [CUSSBagDropDB_NRT].[dbo].[CustomerSession] b on a.CustomerSessionID = b.ID
 WHERE DATEPART(year, LocalTime) = 2026 and DATEPART(month, LocalTime) = 6 --June 9,982 but May 67,221 Apr 62,119, Mar 76,497,  Feb 66,529, Jan 67,768
  and b.[AbdStationID] in
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
