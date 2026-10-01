USE CUSSReportingDB_LHR
GO

--define the number of ApplicationSession records need to be transferred, because we don't need old ApplicationSession data so we only transfer 20 recrods
declare @RecoredsApplicationSessionNeedTransfer int = 100

--list current Max ApplicationSessionId from [CUSSBagDropDB_LHR] table ApplicationSession
SELECT        MAX(ApplicationSessionId) AS MaxApplicationSessionId_CUSSBagDropDB_LHR
FROM [CUSSBagDropDB_LHR].[dbo].ApplicationSession

--list current ID from [CUSSReportingDB_LHR] table ApplicationSessionUsage
SELECT        MAX(ID) AS MaxID_ApplicationSessionUsage_CUSSReportingDB_LHR
FROM  ApplicationSessionUsage

--list current ApplicationSessionUsageProcessID (ApplicationSessionId) from [CUSSReportingDB_LHR] table ApplicationSessionUsageProcess
SELECT        MAX(ApplicationSessionUsageProcessID) AS MaxApplicationSessionUsageProcessID_CUSSReportingDB_LHR
FROM  ApplicationSessionUsageProcess
----------------------------------------------------------------------------
declare @MaxApplicationSessionIdCUSSBagDropDB bigint, @MaxApplicationSessionUsageProcessIDCUSSReportingDB bigint, @ToBeProcessedCount bigint

--get current Max ApplicationSessionId from [CUSSBagDropDB_LHR] table ApplicationSession
SELECT        @MaxApplicationSessionIdCUSSBagDropDB = MAX(ApplicationSessionId) 
FROM [CUSSBagDropDB_LHR].[dbo].ApplicationSession

--get current ApplicationSessionUsageProcessID (ApplicationSessionId) from [CUSSReportingDB_LHR] table ApplicationSessionUsageProcess
SELECT    @MaxApplicationSessionUsageProcessIDCUSSReportingDB = MAX(ApplicationSessionUsageProcessID) 
FROM  ApplicationSessionUsageProcess


select @ToBeProcessedCount = cast(@MaxApplicationSessionIdCUSSBagDropDB - @MaxApplicationSessionUsageProcessIDCUSSReportingDB as varchar) 
print 'There are total: ' + cast(@ToBeProcessedCount as varchar) + ' records needed to be transferred'

--if the total records need to be transferred from [CUSSBagDropDB_LHR] table ApplicationSession to [CUSSReportingDB_LHR] greater than 0 then we do the rest of processes below
if @ToBeProcessedCount > 0
begin
		-- if we only process 100 records from [CUSSBagDropDB_LHR].[dbo].ApplicationSession
		-- so we use 9683414 - 100 = 9683314
		-- it means we need reset [CUSSReportingDB_LHR].[dbo].ApplicationSessionUsageProcess  MAX(ApplicationSessionUsageProcessID) value from 3652687 -> 9683314
		-- then we need set all ABDs current processed date to a few days earlier only 

		-- here we get the MAX ApplicationSessionId from CUSSBagDropDB and minute 100 so we only transfer 100 records from [CUSSBagDropDB_LHR].[dbo].ApplicationSession to [CUSSReportingDB_LHR].[dbo].ApplicationSessionUsageProcess
		-- to avoid the Cuss engine crash 

		declare @ApplicationSessionUsageProcessID_For_CUSSReportingDB bigint
		select TOP 1 @ApplicationSessionUsageProcessID_For_CUSSReportingDB = ApplicationSessionId from [CUSSBagDropDB_LHR].[dbo].ApplicationSession
		where ApplicationSessionId >= (@MaxApplicationSessionIdCUSSBagDropDB - @RecoredsApplicationSessionNeedTransfer)
		order by ApplicationSessionId 

		print 'ApplicationSessionUsageProcessID will be used to update CUSSReportingDB table ApplicationSessionUsageProcess = ' + cast(@ApplicationSessionUsageProcessID_For_CUSSReportingDB as varchar) + '.'

		declare @CurrentMaxApplicationSessionUsageProcessID  bigint
		select TOP 1 @CurrentMaxApplicationSessionUsageProcessID = ApplicationSessionUsageProcessID 
		from  ApplicationSessionUsageProcess order by ApplicationSessionUsageProcessID desc

		--This will set current max ApplicationSessionUsageProcessID to be a value 100 less than current [CUSSBagDropDB_LHR].[dbo].ApplicationSession
		--so we only transfer 100 records to avoid CUSS engine crash
		update  ApplicationSessionUsageProcess set ApplicationSessionUsageProcessID = @ApplicationSessionUsageProcessID_For_CUSSReportingDB
		where ApplicationSessionUsageProcessID = @CurrentMaxApplicationSessionUsageProcessID

		--Start reset each ABD station current processed data to be a date near today
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
		 
				  if (cast(cast(@TempABD_Reached_Date as date) as varchar) < '2022-06-12')
				  begin
					print '@TempABD_Reached_Date =' + cast(cast(@TempABD_Reached_Date as date) as varchar)
					update ApplicationSessionUsageProcess set [LocalStartTime] = '2022-06-09' where ApplicationSessionUsageProcessID = @TempApplicationSessionUsageProcessID
				  end
			
				  print '@TempApplicationSessionUsageProcessID =' + cast(@TempApplicationSessionUsageProcessID as varchar)
				  print '@TempABDStationID =' + cast(@TempABDStationID as varchar)
				  print '---------------------------------------------'
			end

		
		SELECT @Cnt = @Cnt + 1
		
		END
		--End reset each ABD station current processed data to be a date near today

		--Finally
		--also you need update this Processed data column in table ApplicationSessionUsageProcess
		update ApplicationSessionUsageProcess
		set Processed = 1 where ApplicationSessionUsageProcessID <> @ApplicationSessionUsageProcessID_For_CUSSReportingDB

end
else
   print 'There is 0 record needed to be transferred'