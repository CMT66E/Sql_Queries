    --This script will help to check how many records in [CussBagDropDB].[dbo].[CustomerSession] need to be transferred into [CUSSReportingDB].[dbo].[CustomerSession]
	--By default it is daily based on checking, it can be modified for monthly checking.
	--Main purpose: When CUSS engine may miss transferring some records to CUSSReportingDB_CDG database at CustomerSession table we use this to find out before we run script to make them up
	--Date: 14-03-2022 Eric He

	declare @DailyRun  bit = 0                           --default it as daily run mode if it is 1, if its value is 0 then it is monthly running mode
	declare @UpdateMonthFirstDay datetime = '2021-11-01' --If @DailyRun = 1, you may set this date as the first day of your specified month
	
	declare @NoRecordsNeedInsert bigint

	select @NoRecordsNeedInsert = count(ID) from CussBagDropDB.dbo.CustomerSession -- 2525 records
	where datepart(year, UtcCreationTime) = datepart(year, @UpdateMonthFirstDay) 
	and datepart(month, UtcCreationTime) = datepart(month, @UpdateMonthFirstDay) 
	and datepart(day, UtcCreationTime) = case @DailyRun when 1 then datepart(day, @UpdateMonthFirstDay) else datepart(day, UtcCreationTime) end
	and not ID in 
	(
	select ID from CussReportingDB.dbo.CustomerSession where 
	     datepart(year, UtcCreationTime) = datepart(year, @UpdateMonthFirstDay) 
	     and datepart(month, UtcCreationTime) = datepart(month, @UpdateMonthFirstDay) 
	     and datepart(day, UtcCreationTime) = case @DailyRun when 1 then datepart(day, @UpdateMonthFirstDay) else datepart(day, UtcCreationTime) end
	)
	 
	if @DailyRun = 1 
	   print 'In this day ' + cast(cast(@UpdateMonthFirstDay as date) as varchar(50)) + ', there are total ' + cast(@NoRecordsNeedInsert as varchar) + ' records need to be transferred'
	else
	begin
	    declare @UpdateMonthText  varchar(50)
		select @UpdateMonthText = cast(datepart(year, @UpdateMonthFirstDay) as varchar)  + '-' + cast(datepart(month, @UpdateMonthFirstDay) as varchar) 
		print 'In this month ' + @UpdateMonthText + ', there are total ' + cast(@NoRecordsNeedInsert as varchar) + ' records need to be transferred'
	end