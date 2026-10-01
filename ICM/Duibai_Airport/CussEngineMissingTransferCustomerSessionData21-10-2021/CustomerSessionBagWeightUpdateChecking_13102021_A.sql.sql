SELECT a.[ID]
      ,[BagID]
      ,[Weight]
      ,[UtcTime]
      ,[CustomerSessionID]
      ,a.[LocalTime]
	  ,b.*
  FROM [CUSSBagDropDB_DXB].[dbo].[BagWeightUpdate] a left outer join CustomerSession b on a.CustomerSessionID = b.ID
  WHERE cast(a.[LocalTime] as date) = '2021-10-03' and (a.ID >= 774350 and a.ID <= 774379)
  order by a.ID