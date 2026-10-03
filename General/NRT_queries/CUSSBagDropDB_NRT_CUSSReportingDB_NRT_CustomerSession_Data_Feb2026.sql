
declare @FromDateTime DateTime = '2026/02/24 00:00:00 AM'

--select * from 
--[CUSSBagDropDB_NRT].[dbo].[CustomerSession] a
--WHERE 
--DATEPART(year, a.LocalCreationTime) = DATEPART(year, @FromDateTime) and 
--DATEPART(month, a.LocalCreationTime) = DATEPART(month, @FromDateTime)  -- Feb: 451,674 Mar: 520,058

--select * from 
--[CUSSReportingDB_NRT].[dbo].[CustomerSession] a inner join [CUSSReportingDB_NRT].[dbo].[Flight] b on a.FlightID = b.ID
--WHERE 
--DATEPART(year, a.LocalTime) = DATEPART(year, @FromDateTime) and 
--DATEPART(month, a.LocalTime) = DATEPART(month, @FromDateTime)  --Feb: 442,500 short 9,174 records Mar: 509,883
--and DATEPART(day, a.LocalTime) = DATEPART(day, @FromDateTime)
--and b.MarketingCarrier = 'GK'  -- 3463

--select * from 
--[CUSSReportingDB_NRT_FEB2026].[dbo].[CustomerSession] a inner join [CUSSReportingDB_NRT_FEB2026].[dbo].[Flight] b on a.FlightID = b.ID
--WHERE 
--DATEPART(year, a.LocalTime) = DATEPART(year, @FromDateTime) and 
--DATEPART(month, a.LocalTime) = DATEPART(month, @FromDateTime) --451,668 short 6 records
--and DATEPART(day, a.LocalTime) = DATEPART(day, @FromDateTime)
--and b.MarketingCarrier = 'GK' -- 3632

---------------------------------------------------------------
--select * from 
--[CUSSReportingDB_NRT].[dbo].[BagWeightUpdate] a 
--inner join [CUSSReportingDB_NRT].[dbo].[CustomerSession] b on a.CustomerSessionID = b.ID
--inner join [CUSSReportingDB_NRT].[dbo].[Flight] c on b.FlightID = c.ID
--WHERE 
--DATEPART(year, a.LocalTime) = DATEPART(year, @FromDateTime) and 
--DATEPART(month, a.LocalTime) = DATEPART(month, @FromDateTime)  --Feb: 442,500 short 9,174 records Mar: 509,883
----and DATEPART(day, a.LocalTime) = DATEPART(day, @FromDateTime)
--and c.MarketingCarrier = 'GK'  -- 2290

--select * from 
--[CUSSReportingDB_NRT_FEB2026].[dbo].[BagWeightUpdate] a 
--inner join [CUSSReportingDB_NRT_FEB2026].[dbo].[CustomerSession] b on a.CustomerSessionID = b.ID
--inner join [CUSSReportingDB_NRT_FEB2026].[dbo].[Flight] c on b.FlightID = c.ID
--WHERE 
--DATEPART(year, a.LocalTime) = DATEPART(year, @FromDateTime) and 
--DATEPART(month, a.LocalTime) = DATEPART(month, @FromDateTime)  --Feb: 442,500 short 9,174 records Mar: 509,883
----and DATEPART(day, a.LocalTime) = DATEPART(day, @FromDateTime)
--and c.MarketingCarrier = 'GK'  -- 2393

---------------------------------------------------------------

select * from 
[CUSSReportingDB_NRT_FEB2026].[dbo].[BagWeightUpdate] a 
inner join [CUSSReportingDB_NRT_FEB2026].[dbo].[CustomerSession] b on a.CustomerSessionID = b.ID
inner join [CUSSReportingDB_NRT_FEB2026].[dbo].[Flight] c on b.FlightID = c.ID
WHERE 
DATEPART(year, a.LocalTime) = DATEPART(year, @FromDateTime) and 
DATEPART(month, a.LocalTime) = DATEPART(month, @FromDateTime)  --Feb: 442,500 short 9,174 records Mar: 509,883
and c.MarketingCarrier = 'GK'
and NOT a.ID in
(
	select a.ID from 
	[CUSSReportingDB_NRT].[dbo].[BagWeightUpdate] a 
	inner join [CUSSReportingDB_NRT].[dbo].[CustomerSession] b on a.CustomerSessionID = b.ID
	inner join [CUSSReportingDB_NRT].[dbo].[Flight] c on b.FlightID = c.ID
	WHERE 
	DATEPART(year, a.LocalTime) = DATEPART(year, @FromDateTime) and 
	DATEPART(month, a.LocalTime) = DATEPART(month, @FromDateTime)  --Feb: 442,500 short 9,174 records Mar: 509,883
	and c.MarketingCarrier = 'GK'
)


select * from [CUSSReportingDB_NRT].[dbo].[BagWeightUpdate] a 
--inner join [CUSSReportingDB_NRT].[dbo].[CustomerSession] b  on a.CustomerSessionID = b.ID 
where a.ID in
(
8048261,
7999976,
8150410,
8010296,
8141746,
7988256,
8010294,
7962690,
7980376,
7993618
)

select * from [CUSSReportingDB_NRT].[dbo].[BagWeightUpdate] where CustomerSessionID = 0

select * from [CUSSReportingDB_NRT].[dbo].[BagWeightUpdate] a inner join [CUSSReportingDB_NRT_FEB2026].[dbo].[BagWeightUpdate] b on a.ID = b.ID
where a.CustomerSessionID = 0
-------------------------------------------------------------------------------  
  SELECT t1.*, t2.*
  FROM [CUSSReportingDB_NRT].[dbo].[BagWeightUpdate] AS t1
  INNER JOIN [CUSSReportingDB_NRT_FEB2026].[dbo].[BagWeightUpdate] AS t2
  ON t1.ID = t2.ID
  WHERE t1.CustomerSessionID = 0


  UPDATE t1
  SET t1.[CustomerSessionID] = t2.CustomerSessionID
  FROM [CUSSReportingDB_NRT].[dbo].[BagWeightUpdate] AS t1
  INNER JOIN [CUSSReportingDB_NRT_FEB2026].[dbo].[BagWeightUpdate] AS t2
  ON t1.ID = t2.ID
  WHERE t1.CustomerSessionID = 0

-------------------------------------------------------------------------------
select distinct a.CustomerSessionID from 
[CUSSReportingDB_NRT_FEB2026].[dbo].[BagWeightUpdate] a 
inner join [CUSSReportingDB_NRT_FEB2026].[dbo].[CustomerSession] b on a.CustomerSessionID = b.ID
inner join [CUSSReportingDB_NRT_FEB2026].[dbo].[Flight] c on b.FlightID = c.ID
WHERE 
DATEPART(year, a.LocalTime) = DATEPART(year, @FromDateTime) and 
DATEPART(month, a.LocalTime) = DATEPART(month, @FromDateTime)  --Feb: 442,500 short 9,174 records Mar: 509,883
and c.MarketingCarrier = 'GK'
and NOT a.ID in
(
	select a.ID from 
	[CUSSReportingDB_NRT].[dbo].[BagWeightUpdate] a 
	inner join [CUSSReportingDB_NRT].[dbo].[CustomerSession] b on a.CustomerSessionID = b.ID
	inner join [CUSSReportingDB_NRT].[dbo].[Flight] c on b.FlightID = c.ID
	WHERE 
	DATEPART(year, a.LocalTime) = DATEPART(year, @FromDateTime) and 
	DATEPART(month, a.LocalTime) = DATEPART(month, @FromDateTime)  --Feb: 442,500 short 9,174 records Mar: 509,883
	and c.MarketingCarrier = 'GK'
)


select distinct a.ID from 
[CUSSReportingDB_NRT_FEB2026].[dbo].[BagWeightUpdate] a 
inner join [CUSSReportingDB_NRT_FEB2026].[dbo].[CustomerSession] b on a.CustomerSessionID = b.ID
inner join [CUSSReportingDB_NRT_FEB2026].[dbo].[Flight] c on b.FlightID = c.ID
WHERE 
DATEPART(year, a.LocalTime) = DATEPART(year, @FromDateTime) and 
DATEPART(month, a.LocalTime) = DATEPART(month, @FromDateTime)  --Feb: 442,500 short 9,174 records Mar: 509,883
and c.MarketingCarrier = 'GK'
and NOT a.ID in
(
	select a.ID from 
	[CUSSReportingDB_NRT].[dbo].[BagWeightUpdate] a 
	inner join [CUSSReportingDB_NRT].[dbo].[CustomerSession] b on a.CustomerSessionID = b.ID
	inner join [CUSSReportingDB_NRT].[dbo].[Flight] c on b.FlightID = c.ID
	WHERE 
	DATEPART(year, a.LocalTime) = DATEPART(year, @FromDateTime) and 
	DATEPART(month, a.LocalTime) = DATEPART(month, @FromDateTime)  --Feb: 442,500 short 9,174 records Mar: 509,883
	and c.MarketingCarrier = 'GK'
)

-- below we are finding those [CUSSReportingDB_NRT_FEB2026].[dbo].[BagWeightUpdate] IDs belongs to GK but not existing in [CUSSReportingDB_NRT].[dbo].[BagWeightUpdate] IDs
select distinct a.ID from 
[CUSSReportingDB_NRT_FEB2026].[dbo].[BagWeightUpdate] a 
inner join [CUSSReportingDB_NRT_FEB2026].[dbo].[CustomerSession] b on a.CustomerSessionID = b.ID
inner join [CUSSReportingDB_NRT_FEB2026].[dbo].[Flight] c on b.FlightID = c.ID
WHERE 
DATEPART(year, a.LocalTime) = DATEPART(year, @FromDateTime) and 
DATEPART(month, a.LocalTime) = DATEPART(month, @FromDateTime)  --Feb: 442,500 short 9,174 records Mar: 509,883
and c.MarketingCarrier = 'GK'
and NOT a.ID in
(
	select a.ID from 
	[CUSSReportingDB_NRT].[dbo].[BagWeightUpdate] a 
	WHERE 
	DATEPART(year, a.LocalTime) = DATEPART(year, @FromDateTime) and 
	DATEPART(month, a.LocalTime) = DATEPART(month, @FromDateTime) 
)

-- below we are finding those [CUSSReportingDB_NRT_FEB2026].[dbo].[CustomerSession] CustomerSessionIDs belongs to GK but not existing in [CUSSReportingDB_NRT].[dbo].[CustomerSession] CustomerSessionIDsselect distinct a.CustomerSessionID from 
select distinct a.CustomerSessionID from 
[CUSSReportingDB_NRT_FEB2026].[dbo].[BagWeightUpdate] a 
inner join [CUSSReportingDB_NRT_FEB2026].[dbo].[CustomerSession] b on a.CustomerSessionID = b.ID
inner join [CUSSReportingDB_NRT_FEB2026].[dbo].[Flight] c on b.FlightID = c.ID
WHERE 
DATEPART(year, a.LocalTime) = DATEPART(year, @FromDateTime) and 
DATEPART(month, a.LocalTime) = DATEPART(month, @FromDateTime)  --Feb: 442,500 short 9,174 records Mar: 509,883
and c.MarketingCarrier = 'GK'
and NOT a.CustomerSessionID in
(
	select a.ID from 
	[CUSSReportingDB_NRT].[dbo].[CustomerSession] a 	 
	WHERE 
	DATEPART(year, a.LocalTime) = DATEPART(year, @FromDateTime) and 
	DATEPART(month, a.LocalTime) = DATEPART(month, @FromDateTime)   
)
