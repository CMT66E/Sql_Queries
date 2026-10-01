declare @DailyRun  bit = 1                           --default it as daily run mode if it is 1, if its value is 0 then it is monthly running mode
declare @UpdateMonthFirstDay datetime = '2018-03-22' --If @DailyRun = 1, you may set this date as the first day of your specified month


SELECT [ID]
      ,[CustomerID]
      ,[AbdStationID]
      ,[CustomerLookupType]
      ,[PNR]
      ,[UtcCreationTime]
      ,[FlightID]
      ,[TimeSlot5minID]
      ,[TimeSlot10minID]
      ,[TimeSlotHourlyID]
      ,[DayOfTheWeekID]
      ,[LocalTime]
      ,[UtcCompletionTime]
      ,[SessionDuration]
  FROM [CUSSReportingDB].[dbo].[CustomerSession]
  where datepart(year, UtcCreationTime) = datepart(year, @UpdateMonthFirstDay) 
	and datepart(month, UtcCreationTime) = datepart(month, @UpdateMonthFirstDay) 
	and datepart(day, UtcCreationTime) = case @DailyRun when 1 then datepart(day, @UpdateMonthFirstDay) else datepart(day, UtcCreationTime) end

--before run scripts it has 1075 then there are 5289 will be inserted
--finally in total it will has 6364 records. It looks good after applying scripts