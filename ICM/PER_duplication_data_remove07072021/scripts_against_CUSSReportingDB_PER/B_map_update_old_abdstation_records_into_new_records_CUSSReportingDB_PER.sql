--This script is dedicated running against database: [CUSSReportingDB_PER]. It takes 50 seconds to run on local test, please wait till the exectuion completed. Date 12-07-2021
--The purpose of this script is to filter out all those old AbdStation records and map all their related records in tables: CustomerSession, ApplicationSessionUsage, ApplicationSessionUsageProcess, AbdStateHistory  
--to their correspondent new AbdStation IDs. so we can remove those old records from existing AbdStation table 


USE [CUSSReportingDB_PER]
GO

--we loop through the whole table of AbdStateHistory and map all those old AbdStationIDs to the new AbdStation records.
--The new AbdStation records for Kiosks are decided by this:
--  SELECT [ID]
--      ,[PortCode]
--      ,[Identifier]
--      ,[AbdType]
--      ,[Terminal]
--      ,[KioskName]
--      ,[Zone]
--      ,[Area]
--      ,[SubArea]
--FROM [AbdStation]
--where Terminal = 'PER1' and AbdType = 'KSK'  -- it contains 36 records ID range from 74 to 116


select * from AbdStateHistory where AbdStationID in (select [ID]  FROM [AbdStation]
where  Terminal <> 'PER1' and Area <> 'Z')  --it contains 

DECLARE @MyTableMap TABLE
(
AbdStationID int,
AbdStationID_MapTo int
) 

DECLARE @MyTable TABLE
(
SNo int IDENTITY(1,1), 
AbdStationID int
)    

INSERT INTO @MyTable(AbdStationID)	    
select distinct AbdStationID from AbdStateHistory where AbdStationID in (select [ID]  FROM [AbdStation]
where  Terminal <> 'PER1' and Area <> 'Z')


 
DECLARE @TempAbdStationID INT
DECLARE @TempAbdStationID_MapTo INT
DECLARE @TempAbdStationID_MapTo_Final INT
DECLARE @TempKioskName varchar(50)
DECLARE @TempArea varchar(10)


DECLARE @Cnt INT
SELECT @Cnt = MIN(Sno) FROM @MyTable
	
WHILE (1=1)
BEGIN
   
SELECT @TempAbdStationID = AbdStationID FROM @MyTable
WHERE SNo = @Cnt
	    
IF @@ROWCOUNT = 0
	BREAK

	select 
	   @TempAbdStationID_MapTo = ID,
	   @TempKioskName = KioskName,
	   @TempArea = Area	
	from AbdStation where  Terminal <> 'PER1' and [ID] = @TempAbdStationID
	
	--we find the mapped AbdStationID from correct KSK data rows
	  SELECT @TempAbdStationID_MapTo_Final =  isnull(Max([ID]), 0)       
      FROM [AbdStation]
      where Terminal = 'PER1' and AbdType = 'KSK' and (KioskName = @TempKioskName and Area = @TempArea)
 
      If @TempAbdStationID_MapTo_Final > 0 and not exists(select * from @MyTableMap where AbdStationID = @TempAbdStationID_MapTo and AbdStationID_MapTo = @TempAbdStationID_MapTo_Final)
	    insert into @MyTableMap(AbdStationID, AbdStationID_MapTo) values(@TempAbdStationID_MapTo, @TempAbdStationID_MapTo_Final)
		
SELECT @Cnt = @Cnt + 1		
END

select * from @MyTableMap
select * from ApplicationSessionUsage where AbdStationID in (select [AbdStationID] FROM @MyTableMap)

update a
set a.AbdStationId = b.AbdStationID_MapTo
from CustomerSession a inner join @MyTableMap b on a.AbdStationId = b.AbdStationID

update a
set a.AbdStationId = b.AbdStationID_MapTo
from ApplicationSessionUsage a inner join @MyTableMap b on a.AbdStationId = b.AbdStationID -- it should have 938 records to be updated


update a 
set a.AbdStationId = b.AbdStationID_MapTo
from ApplicationSessionUsageProcess a inner join @MyTableMap b on a.AbdStationId = b.AbdStationID


if not exists(select * from CustomerSession where AbdStationID in (select [AbdStationID] FROM @MyTableMap))
begin
    --Finally we update table: AbdStateHistory  
	update a 
	set a.AbdStationId = b.AbdStationID_MapTo
	from AbdStateHistory a inner join @MyTableMap b on a.AbdStationId = b.AbdStationID

	delete from [AbdStation]
	where  Terminal <> 'PER1' and Area <> 'Z'
end