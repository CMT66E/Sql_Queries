    --This script will help to check how many records in [CussBagDropDB_DXB].[dbo].[BagWeightUpdate] need to be transferred into [CUSSReportingDB_DXB].[dbo].[BagWeightUpdate]
	--By default it is daily based on checking, it can be modified for daily checking.
	--Main purpose: When CUSS engine may miss transferring some records to CUSSReportingDB_DXB database BagWeightUpdate table we use this to find out before we run script to make them up
	--Date: 28-10-2021 Eric He

    declare @UpdateMonthFirstDay datetime = '2021-10-02'

	SELECT *
	  FROM [CussBagDropDB_DXB].[dbo].[BagWeightUpdate]
	WHERE 
	datepart(year, UtcTime) = datepart(year, @UpdateMonthFirstDay) and datepart(month, UtcTime) = datepart(month, @UpdateMonthFirstDay) 
	  and datepart(day, UtcTime) = datepart(day, @UpdateMonthFirstDay)
	AND NOT ID in 
	(
	  select ID from  [CUSSReportingDB_DXB].[dbo].[BagWeightUpdate] WHERE datepart(year, UtcTime) = datepart(year, @UpdateMonthFirstDay) and datepart(month, UtcTime) = datepart(month, @UpdateMonthFirstDay) 
	  and datepart(day, UtcTime) = datepart(day, @UpdateMonthFirstDay)
	)
	order by ID desc
 