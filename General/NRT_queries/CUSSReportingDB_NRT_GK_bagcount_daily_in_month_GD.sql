  SELECT 
       cast(a.[LocalTime] as date) as [LocalDateTime], count(a.[ID]) as TotalBags
  FROM [CUSSReportingDB_NRT].[dbo].[BagWeightUpdate] a inner join CustomerSession b on a.[CustomerSessionID] = b.ID
  inner join Flight c on b.FlightID = c.ID
  WHERE DATEPART(year, a.LocalTime) = 2026 and DATEPART(month, a.LocalTime) = 6 --June 9,982 but May 67,221 Apr 62,119, Mar 76,497,  Feb 66,529, Jan 67,768
  and c.MarketingCarrier = 'GK'
  group by  cast(a.[LocalTime] as date)
  order by  cast(a.[LocalTime] as date)