
declare @UTC_LOCAL_HOURS int = 8 --Singapore is 8 hours earlier than UTC time so we set this value as 8. For Sydney time it should be 11

select top(10000) 

       [ID]
      ,[ABDStationID]
      ,[MessageType]
      ,[MessageSent]
      ,[MessageTime]
      ,[SessionID]
      ,[Result]
      ,[MessageSize]
      ,[AirlineCode]
	  ,(select TOP (1) ID from [ReportingDB_SIN].[dbo].[TimeSlot5min] where cast(convert(varchar, cast([FromTime] as date)) + ' ' +  SUBSTRING(convert(varchar, [MessageSent], 108), 1,5) + ':00:000' as datetime) >= [FromTime] and cast(convert(varchar, cast([ToTime] as date)) + ' ' +  SUBSTRING(convert(varchar, [MessageSent], 108), 1,5) + ':00:000' as datetime) < [ToTime]) as TempTimeSlot5minID
      ,(select TOP (1) ID from [ReportingDB_SIN].[dbo].[TimeSlot10Min] where cast(convert(varchar, cast([FromTime] as date)) + ' ' +  SUBSTRING(convert(varchar, [MessageSent], 108), 1,5) + ':00:000' as datetime) >= [FromTime] and cast(convert(varchar, cast([ToTime] as date)) + ' ' +  SUBSTRING(convert(varchar, [MessageSent], 108), 1,5) + ':00:000' as datetime) < [ToTime]) as TempTimeSlot10minID
      ,(select TOP (1) ID from [ReportingDB_SIN].[dbo].[TimeSlotHourly] where cast(convert(varchar, cast([FromTime] as date)) + ' ' +  SUBSTRING(convert(varchar, [MessageSent], 108), 1,5) + ':00:000' as datetime) >= [FromTime] and cast(convert(varchar, cast([ToTime] as date)) + ' ' +  SUBSTRING(convert(varchar, [MessageSent], 108), 1,5) + ':00:000' as datetime) < [ToTime]) as TempTimeSlotHourlyID
      ,(select ID from [ReportingDB_SIN].[dbo].DayOfTheWeek where lower(DayOfTheWeek) = lower(DATENAME(WEEKDAY, [MessageSent]))) as TempDayOfTheWeekID
FROM [BagDropDB_SIN].[dbo].[CMOperationHistory] a  
where DATEPART(year, MessageSent) = 2026 and DATEPART(month, MessageSent) = 3 and DATEPART(day, MessageSent) = 2
order by ID desc


--DECLARE @TempLocalTime datetime
--DECLARE @TempTimeSlot5minID int
--DECLARE @TempTimeSlot10minID int 
--DECLARE @TempTimeSlotHourlyID int 
--DECLARE @TempDayOfTheWeekID int 


--select @TempLocalTime = MessageSent FROM [BagDropDB_SIN].[dbo].[CMOperationHistory] where ID = 119672167

 

--select @TempTimeSlot5minID =  ID from [ReportingDB_SIN].[dbo].[TimeSlot5min] where 
--	cast(convert(varchar, cast([FromTime] as date)) + ' ' +  SUBSTRING(convert(varchar, @TempLocalTime, 108), 1,5) + ':00:000' as datetime) >= [FromTime]
--and 
--	cast(convert(varchar, cast([ToTime] as date)) + ' ' +  SUBSTRING(convert(varchar, @TempLocalTime, 108), 1,5) + ':00:000' as datetime) < [ToTime]

--select @TempTimeSlot10minID = ID from [ReportingDB_SIN].[dbo].[TimeSlot10Min] where 
--	cast(convert(varchar, cast([FromTime] as date)) + ' ' +  SUBSTRING(convert(varchar, @TempLocalTime, 108), 1,5) + ':00:000' as datetime) >= [FromTime]
--and 
--	cast(convert(varchar, cast([ToTime] as date)) + ' ' +  SUBSTRING(convert(varchar, @TempLocalTime, 108), 1,5) + ':00:000' as datetime) < [ToTime]

--select @TempTimeSlotHourlyID = ID from [ReportingDB_SIN].[dbo].[TimeSlotHourly] where 
--	cast(convert(varchar, cast([FromTime] as date)) + ' ' +  SUBSTRING(convert(varchar, @TempLocalTime, 108), 1,5) + ':00:000' as datetime) >= [FromTime]
--and 
--	cast(convert(varchar, cast([ToTime] as date)) + ' ' +  SUBSTRING(convert(varchar, @TempLocalTime, 108), 1,5) + ':00:000' as datetime) < [ToTime]


--select @TempDayOfTheWeekID = ID from [ReportingDB_SIN].[dbo].DayOfTheWeek where lower(DayOfTheWeek) = lower(DATENAME(WEEKDAY, @TempLocalTime))
 
----in c# CUSS Engine code Sunday has been set as 0 so we modified above to match this. Even though it should be 7 in table DayOfweek
----if @TempDayOfTheWeekID = 7
----   set @TempDayOfTheWeekID = 0

--print 'test TempLocalTime = ' + cast(@TempLocalTime as varchar)
--print 'test TempTimeSlot5minID = ' + cast(@TempTimeSlot5minID as varchar)
--print 'test TempTimeSlot10minID = ' + cast(@TempTimeSlot10minID as varchar)
--print 'test TimeSlotHourlyID = ' + cast(@TempTimeSlotHourlyID as varchar)
--print 'test @TempDayOfTheWeekID = ' + cast(@TempDayOfTheWeekID as varchar)
-----------------------------------------------------------------------------------------------------------------
select  top(10000) * from [ReportingDB_SIN].[dbo].[CMOperationHistory] where ID in 
(
select ID FROM [BagDropDB_SIN].[dbo].[CMOperationHistory] a  where DATEPART(year, MessageSent) = 2026 and DATEPART(month, MessageSent) = 3 and DATEPART(day, MessageSent) = 2
) 
order by ID desc