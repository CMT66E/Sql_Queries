    --This script will help to check how many records in [CussBagDropDB_DXB].[dbo].[CustomerSession] need to be transferred into [CUSSReportingDB_DXB].[dbo].[CustomerSession]
	--By default it is daily based on checking, it can be modified for monthly checking.
	--Main purpose: When CUSS engine may miss transferring some records to CUSSReportingDB_DXB database at CustomerSession table we use this to find out before we run script to make them up
	--Date: 28-10-2021 Eric He

	declare @UpdateMonthFirstDay datetime = '2021-10-02'

	select * from CussBagDropDB_DXB.dbo.CustomerSession -- 2525 records
	where datepart(year, UtcCreationTime) = datepart(year, @UpdateMonthFirstDay) and datepart(month, UtcCreationTime) = datepart(month, @UpdateMonthFirstDay) 
	and datepart(day, UtcCreationTime) = datepart(day, @UpdateMonthFirstDay)
	and not ID in 
	(
	select ID from CussReportingDB_DXB.dbo.CustomerSession where datepart(year, UtcCreationTime) = datepart(year, @UpdateMonthFirstDay) and datepart(month, UtcCreationTime) = datepart(month, @UpdateMonthFirstDay) 
	 and datepart(day, UtcCreationTime) = datepart(day, @UpdateMonthFirstDay)
	)
	and ID in
	(
		select CustomerSessionID from CussBagDropDB_DXB.dbo.BagWeightUpdate   
	)