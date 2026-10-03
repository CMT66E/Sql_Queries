--insert 2,276,230 rows needs 41:26 minutes
insert into [ReportingDB_NRT].[dbo].[CMOperationHistory]
(      
       [ID]
      ,[ABDStationID]
      ,[MessageType]
      ,[MessageSent]
      ,[MessageTime]
      ,[SessionID]
      ,[Result]
      ,[MessageSize]
      ,[TimeSlot5minID]
      ,[TimeSlot10minID]
      ,[TimeSlotHourlyID]
      ,[DayOfTheWeekID]
)
select         
       [ID]
      ,[ABDStationID]
      ,[MessageType]
      ,[MessageSent]
      ,[MessageTime]
      ,[SessionID]
      ,[Result]
      ,[MessageSize]
	  ,(select TOP (1) ID from [ReportingDB_SIN].[dbo].[TimeSlot5min] where cast(convert(varchar, cast([FromTime] as date)) + ' ' +  SUBSTRING(convert(varchar, [MessageSent], 108), 1,5) + ':00:000' as datetime) >= [FromTime] and cast(convert(varchar, cast([ToTime] as date)) + ' ' +  SUBSTRING(convert(varchar, [MessageSent], 108), 1,5) + ':00:000' as datetime) < [ToTime]) as [TimeSlot5minID]
      ,(select TOP (1) ID from [ReportingDB_SIN].[dbo].[TimeSlot10Min] where cast(convert(varchar, cast([FromTime] as date)) + ' ' +  SUBSTRING(convert(varchar, [MessageSent], 108), 1,5) + ':00:000' as datetime) >= [FromTime] and cast(convert(varchar, cast([ToTime] as date)) + ' ' +  SUBSTRING(convert(varchar, [MessageSent], 108), 1,5) + ':00:000' as datetime) < [ToTime]) as [TimeSlot10minID]
      ,(select TOP (1) ID from [ReportingDB_SIN].[dbo].[TimeSlotHourly] where cast(convert(varchar, cast([FromTime] as date)) + ' ' +  SUBSTRING(convert(varchar, [MessageSent], 108), 1,5) + ':00:000' as datetime) >= [FromTime] and cast(convert(varchar, cast([ToTime] as date)) + ' ' +  SUBSTRING(convert(varchar, [MessageSent], 108), 1,5) + ':00:000' as datetime) < [ToTime]) as [TimeSlotHourlyID]
      ,(select ID from [ReportingDB_SIN].[dbo].DayOfTheWeek where lower(DayOfTheWeek) = lower(DATENAME(WEEKDAY, [MessageSent]))) as [DayOfTheWeekID]
FROM [BagDropDB_NRT].[dbo].[CMOperationHistory]
where ID > (SELECT Max(ID) as temp
  FROM [ReportingDB_NRT].[dbo].[CMOperationHistory])