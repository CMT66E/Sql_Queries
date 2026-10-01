/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [ID]
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
  FROM [CUSSBagDropDB_DXB].[dbo].[CustomerSession]
  order by ID desc


  select * from  [CUSSBagDropDB_DXB].[dbo].[CustomerSession] where ID = 1248925

  select * from  [CUSSReportingDB_DXB].[dbo].[CustomerSession] where ID = 1248925




	SELECT DATEPART(WEEKDAY, '2021-10-11 05:30:51.867')
	SELECT DATEPART(WEEKDAY, '2021-10-12 05:30:51.867')
	SELECT DATEPART(WEEKDAY, '2021-10-13 05:30:51.867')
	SELECT DATEPART(WEEKDAY, '2021-10-14 05:30:51.867')
	SELECT DATEPART(WEEKDAY, '2021-10-15 05:30:51.867')
	SELECT DATEPART(WEEKDAY, '2021-10-16 05:30:51.867')
	SELECT DATEPART(WEEKDAY, '2021-10-17 05:30:51.867')

  SELECT DATEPART(WEEKDAY, '2021-10-14 05:30:51.867')

  select ID from [CUSSReportingDB_DXB].[dbo].DayOfTheWeek where lower(DayOfTheWeek) = lower(DATENAME(WEEKDAY, '2021-10-14 05:30:51.867'))

  SELECT DATENAME(WEEKDAY, '2021-10-14 05:30:51.867')

  SELECT cast(DATEPART(Hour, '2021-10-14 05:30:51.867') as varchar) + ':' + cast(DATEPART(MINUTE, '2021-10-14 05:30:51.867') as varchar)
  SELECT cast('2021-10-14 05:30:51.867' as time) [time]


declare @Existingdate datetime
Set @Existingdate= '2021-10-14 05:30:51.867'

--select cast(convert(varchar, cast('2011-02-22 04:45:00.000' as date)) +' ' +  convert(varchar, @Existingdate, 14) as datetime)

declare @Temp varchar(50)
select @Temp = CONVERT(varchar,@Existingdate,108)
--Select @Temp as [HH:MM]
Select SUBSTRING(@Temp, 1,5) as [HH:MM]

--Select CONVERT(varchar(20), convert(datetime, @Existingdate) , 114) as [HH:MM]

--Select SUBSTRING(CONVERT(varchar,@Existingdate,108), 1,5) as [HH:MM]





 select *, cast(convert(varchar, cast([FromTime] as date)) + ' ' +  SUBSTRING(convert(varchar, @Existingdate, 108), 1,5) + ':00:000' as datetime),
           cast(convert(varchar, cast([ToTime] as date)) + ' ' +  SUBSTRING(convert(varchar, @Existingdate, 108), 1,5) + ':00:000' as datetime), DATEDIFF(SECOND, [FromTime], [ToTime])
 from [CUSSReportingDB_DXB].[dbo].[TimeSlot5min]

 select ID from [CUSSReportingDB_DXB].[dbo].[TimeSlot5min] where 
   cast(convert(varchar, cast([FromTime] as date)) + ' ' +  SUBSTRING(convert(varchar, @Existingdate, 108), 1,5) + ':00:000' as datetime) >= [FromTime]
and 
   cast(convert(varchar, cast([ToTime] as date)) + ' ' +  SUBSTRING(convert(varchar, @Existingdate, 108), 1,5) + ':00:000' as datetime) < [ToTime]


