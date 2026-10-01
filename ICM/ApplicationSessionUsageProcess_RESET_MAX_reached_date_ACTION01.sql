--checking script here to find currently reached MAX processed date
update ApplicationSessionUsageProcess
set Processed = 1 where Processed = 0

select AbdStationID, max(LocalStartTime) as MaxReachedDate 
from ApplicationSessionUsageProcess 
group by AbdStationID 
order by AbdStationID

select * from ApplicationSessionUsageProcess
order by 1 desc

select AbdStationID, max(LocalStartTime) as MaxReachedDate 
from ApplicationSessionUsageProcess 
group by AbdStationID 
order by MaxReachedDate
---------------------------------------------------------------------------------------
SELECT        MAX(ApplicationSessionId) AS LastID
FROM [CUSSBagDropDB_LHR].[dbo].ApplicationSession

SELECT        MAX(ApplicationSessionUsageProcessID) AS LastID
FROM [CUSSReportingDB_LHR].[dbo].ApplicationSessionUsageProcess
----------------------------------------------------------------------------
declare @MaxApplicationSessionId bigint, @MaxApplicationSessionUsageProcessID bigint

SELECT        @MaxApplicationSessionId = MAX(ApplicationSessionId) 
FROM [CUSSBagDropDB_LHR].[dbo].ApplicationSession

SELECT    @MaxApplicationSessionUsageProcessID =    MAX(ApplicationSessionUsageProcessID) 
FROM [CUSSReportingDB_LHR].[dbo].ApplicationSessionUsageProcess

print 'There are total: ' + cast(@MaxApplicationSessionId - @MaxApplicationSessionUsageProcessID as varchar) + ' records needed to be transferred'
select cast(@MaxApplicationSessionId - @MaxApplicationSessionUsageProcessID as varchar) as ToBeProcessedCount

-- we only process 100 records from [CUSSBagDropDB_LHR].[dbo].ApplicationSession
-- so we use 9683414 - 100 = 9683314
-- it means we need reset [CUSSReportingDB_LHR].[dbo].ApplicationSessionUsageProcess  MAX(ApplicationSessionUsageProcessID) value from 3652687 -> 9683314
--then we need set all ABDs current processed date to a few days earlier only 

--also you need update this Processed data column in table ApplicationSessionUsageProcess
update ApplicationSessionUsageProcess
set Processed = 1 where Processed = 0
---------------------------------------------------------------------------------------
select count(*) from ApplicationSessionUsageProcess

select AbdStationID, max(LocalStartTime) as MaxReachedDate 
from ApplicationSessionUsageProcess 
group by AbdStationID 
order by MaxReachedDate
---------------------------------------------------------------------------------------

DECLARE @MyTable TABLE
	(
	SNo int IDENTITY(1,1), 
	ABDStationID int,
	ABD_Reached_Date datetime
	)    
INSERT INTO @MyTable(ABDStationID, ABD_Reached_Date)	    
select AbdStationID, max(LocalStartTime) as ABD_Reached_Date 
from ApplicationSessionUsageProcess 
group by AbdStationID 
order by ABD_Reached_Date
--select * from @MyTable
	
declare @Cnt int
SELECT @Cnt = MIN(Sno) FROM @MyTable
	
declare @TempABDStationID int
declare @TempABD_Reached_Date datetime

declare @TempApplicationSessionUsageProcessID int

WHILE (1=1)
BEGIN
   
SELECT @TempABDStationID = ABDStationID, @TempABD_Reached_Date = ABD_Reached_Date FROM @MyTable
WHERE SNo = @Cnt
	    
IF @@ROWCOUNT = 0
	BREAK

	if exists(select ApplicationSessionUsageProcessID from ApplicationSessionUsageProcess where cast(ABDStationID as varchar) = cast(@TempABDStationID as varchar) and [LocalStartTime] = @TempABD_Reached_Date)
	begin
	      select @TempApplicationSessionUsageProcessID = ApplicationSessionUsageProcessID from ApplicationSessionUsageProcess where cast(ABDStationID as varchar) = cast(@TempABDStationID as varchar) and [LocalStartTime] = @TempABD_Reached_Date
		  print '@Cnt =' + cast(@Cnt as varchar)
		 
		  if (cast(cast(@TempABD_Reached_Date as date) as varchar) < '2022-05-31')
		  begin
			print '@TempABD_Reached_Date =' + cast(cast(@TempABD_Reached_Date as date) as varchar)
			update ApplicationSessionUsageProcess set [LocalStartTime] = '2022-05-31' where ApplicationSessionUsageProcessID = @TempApplicationSessionUsageProcessID
		  end
			
		  print '@TempApplicationSessionUsageProcessID =' + cast(@TempApplicationSessionUsageProcessID as varchar)
		  print '@TempABDStationID =' + cast(@TempABDStationID as varchar)
		  print '---------------------------------------------'
	end

		
SELECT @Cnt = @Cnt + 1
		
END