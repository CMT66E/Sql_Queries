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
  FROM [study].[dbo].[BagWeightUpdate]


	DECLARE @MyTable TABLE
	(
	SNo int IDENTITY(1,1), 
	CustomerSessionID int
	)
    
  insert into @MyTable
  select distinct a.[CustomerSessionID] 
  FROM [study].[dbo].[BagWeightUpdate] a  

  select * from @MyTable


  select * from @MyTable a inner join [CUSSReportingDB_NRT_FEB2026].[dbo].[BagWeightUpdate] b on a.CustomerSessionID = b.CustomerSessionID


  declare @FromDateTime DateTime = '2026/02/24 00:00:00 AM'
  select b.ID from @MyTable a inner join [CUSSReportingDB_NRT_FEB2026].[dbo].[BagWeightUpdate] b on a.CustomerSessionID = b.CustomerSessionID
  where not b.ID in
  (  
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

  )