--Notes: Average Passenger Transaction time per ABD per Bag
--Date: 25-Oct-2022
USE ReportingDB_CDG
GO	

declare @FromDateTime DateTime = '2022/07/31 00:00:00'
declare @ToDateTime DateTime = '2022/07/31 23:59:59'
declare @FlightNumber nvarchar(100)  = '%'
declare @BoardPass nvarchar(25) = '%'
declare @BagTagType nvarchar(25) = '%'
declare @Airline nvarchar(25) = '%'
declare @Terminal nvarchar(10) = '%'
declare @Area nvarchar(10) = '%'
declare @SubArea nvarchar(10) = '%'
declare @ABDStationIDs varchar(400) = '0'
declare @ABDStationNames varchar(4000) = 'Display All ABDs'


IF OBJECT_ID('tempdb..##tempCusSession') is not null
		DROP TABLE [dbo].[##tempCusSession]

IF OBJECT_ID('tempdb..##temp') is not null
		DROP TABLE [dbo].[##temp]		
Select * into ##tempCusSession  from CustomerSession Where LocalTime BETWEEN @FromDateTime AND @ToDateTime
 
SELECT     CustomerSession.ID, CustomerSession.CustomerID, CustomerSession.AbdStationID, CustomerSession.CustomerLookupType, CustomerSession.PNR, 
						CustomerSession.UtcCreationTime, CustomerSession.FlightID, CustomerSession.TimeSlot5minID, CustomerSession.TimeSlot10minID, 
						CustomerSession.TimeSlotHourlyID, CustomerSession.DayOfTheWeekID, CustomerSession.LocalTime, CustomerSession.UtcCompletionTime, 
						CustomerSession.SessionDuration, COUNT(BagWeightUpdate.BagID) AS BagCount
						INTO ##temp
FROM       ##tempCusSession  CustomerSession LEFT OUTER JOIN
						BagWeightUpdate ON CustomerSession.ID = BagWeightUpdate.CustomerSessionID
GROUP BY CustomerSession.ID, CustomerSession.CustomerID, CustomerSession.AbdStationID, CustomerSession.CustomerLookupType, CustomerSession.PNR, 
						CustomerSession.UtcCreationTime, CustomerSession.FlightID, CustomerSession.TimeSlot5minID, CustomerSession.TimeSlot10minID, 
						CustomerSession.TimeSlotHourlyID, CustomerSession.DayOfTheWeekID, CustomerSession.LocalTime, CustomerSession.UtcCompletionTime, 
						CustomerSession.SessionDuration


declare @TransactionTimeNoOfBags table 
(
[AbdStationName]  varchar(50),
[NoOfBagsGroupID]  int,
[AvgBagCount]  int,
[AvgSessionDuration] float,
[MinSessionDuration] float,
[MaxSessionDuration] float,
[NumberOfCustomerTransactions] bigint, 
[NumberOfBags] int
)

insert into @TransactionTimeNoOfBags
SELECT     
dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea) AS AbdStationName, 
NumberOfBagsMap.NoOfBagsGroupID, 
AVG(TransactionTimeNoOfBags.BagCount) AS AvgBagCount, 
AVG(TransactionTimeNoOfBags.SessionDuration) AS AvgSessionDuration, 
MIN(TransactionTimeNoOfBags.SessionDuration) AS MinSessionDuration, 
MAX(TransactionTimeNoOfBags.SessionDuration) AS MaxSessionDuration,
COUNT(TransactionTimeNoOfBags.ID) AS NumberOfCustomerTransactions, 
SUM(TransactionTimeNoOfBags.BagCount) AS NumberOfBags

FROM  ##temp  AS TransactionTimeNoOfBags INNER JOIN
						AbdStation ON TransactionTimeNoOfBags.AbdStationID = AbdStation.ID INNER JOIN
						Flight ON TransactionTimeNoOfBags.FlightID = Flight.ID INNER JOIN
						NumberOfBagsMap ON TransactionTimeNoOfBags.BagCount = NumberOfBagsMap.NumberOfBags
WHERE     (CAST(Flight.FlightNumber AS nvarchar(100)) LIKE @FlightNumber) 
	AND (TransactionTimeNoOfBags.CustomerLookupType LIKE @BoardPass) 
	AND (Flight.MarketingCarrier LIKE @Airline)
	AND (AbdStation.Terminal LIKE @Terminal)
	AND (ISNULL(AbdStation.Area,'') LIKE @Area )		
	AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea ) 
	AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
GROUP BY AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.AbdType,AbdStation.SubArea, NumberOfBagsMap.NoOfBagsGroupID
ORDER BY dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea), NumberOfBagsMap.NoOfBagsGroupID
 

--select [AbdStationName], 
--[NoOfBagsGroupID], 
--sum([AvgBagCount]) as [AvgBagCount],
--avg(isnull([AvgSessionDuration], 0)) as AvgSessionDuration,
--min(isnull([MinSessionDuration], 0)) as MinSessionDuration,
--max(isnull([MaxSessionDuration], 0)) as MaxSessionDuration,
--sum(isnull([NumberOfCustomerTransactions], 0)) as NumberOfCustomerTransactions, 
--sum([NumberOfBags]) as [NumberOfBags]
--from @TransactionTimeNoOfBags
--group by [AbdStationName], [NoOfBagsGroupID] 
-----------------------------------------------------------------------------
--select 
--[AbdStationName], 
--NoOfBagsGroupID, 
--avg(isnull([AvgSessionDuration], 0)) as AvgSessionDuration 
--from @TransactionTimeNoOfBags 
--group by [AbdStationName], NoOfBagsGroupID 

DECLARE @MyTable TABLE
(
SNo int IDENTITY(1,1), 
AbdStationName varchar(50),
NoOfBagsGroupID int,
AvgSessionDuration decimal(10, 2)
) 


DECLARE @MyFinalTable TABLE
(
SNo int IDENTITY(1,1), 
ABD varchar(50),
[0] decimal(10, 2),
[1] decimal(10, 2),
[2] decimal(10, 2),
[3] decimal(10, 2),
[4 - 200] decimal(10, 2)
)  

INSERT INTO @MyTable(AbdStationName, NoOfBagsGroupID, AvgSessionDuration)	    
select 
AbdStationName, 
NoOfBagsGroupID, 
avg(isnull([AvgSessionDuration], 0)) as AvgSessionDuration 
from @TransactionTimeNoOfBags 
group by [AbdStationName], NoOfBagsGroupID 
--order by NoOfBagsGroupID, AvgSessionDuration 

--select * from @MyTable
	
declare @Cnt int
SELECT @Cnt = MIN(Sno) FROM @MyTable
	
declare @TempAbdStationName varchar(50)
declare @TempNoOfBagsGroupID int
declare @TempAvgSessionDuration decimal(10, 2)

declare @TempZero decimal(10, 2)
declare @TempOne decimal(10, 2)
declare @TempTwo decimal(10, 2)
declare @TempThree decimal(10, 2)
declare @TempOverFour decimal(10, 2)

WHILE (1=1)
BEGIN
   
SELECT 
@TempAbdStationName = AbdStationName, 
@TempNoOfBagsGroupID = NoOfBagsGroupID,
@TempAvgSessionDuration = AvgSessionDuration
FROM @MyTable
WHERE SNo = @Cnt
	    
IF @@ROWCOUNT = 0
	BREAK

	set @TempZero = 0
	set @TempOne = 0
	set @TempTwo = 0
	set @TempThree = 0
	set @TempOverFour = 0

	if @TempNoOfBagsGroupID = 1 
	    set @TempZero = @TempAvgSessionDuration
	if @TempNoOfBagsGroupID = 2 
	    set @TempOne = @TempAvgSessionDuration
	if @TempNoOfBagsGroupID = 3 
	    set @TempTwo = @TempAvgSessionDuration
	if @TempNoOfBagsGroupID = 4 
	    set @TempThree = @TempAvgSessionDuration
	if @TempNoOfBagsGroupID = 5 
	    set @TempOverFour = @TempAvgSessionDuration
 

	if not exists(select ABD from @MyFinalTable where cast(ABD as varchar) = cast(@TempAbdStationName as varchar))
	begin
		--print 'addressID =' + cast(@TempAddressID as varchar)
		--print '@TempROW_ID =' + cast(@TempROW_ID as varchar)
		--print '---------------------------------------------'
		insert into @MyFinalTable(ABD, [0], [1], [2], [3], [4 - 200]) values(@TempAbdStationName, @TempZero, @TempOne, @TempTwo, @TempThree, @TempOverFour)
	     
	end
	else
	begin
		if @TempNoOfBagsGroupID = 1 
			update @MyFinalTable set [0] = @TempAvgSessionDuration where cast(ABD as varchar) = cast(@TempAbdStationName as varchar)
		if @TempNoOfBagsGroupID = 2 
			update @MyFinalTable set [1] = @TempAvgSessionDuration where cast(ABD as varchar) = cast(@TempAbdStationName as varchar)
		if @TempNoOfBagsGroupID = 3 
			update @MyFinalTable set [2] = @TempAvgSessionDuration where cast(ABD as varchar) = cast(@TempAbdStationName as varchar)
		if @TempNoOfBagsGroupID = 4 
			update @MyFinalTable set [3] = @TempAvgSessionDuration where cast(ABD as varchar) = cast(@TempAbdStationName as varchar)		
		if @TempNoOfBagsGroupID = 5 
			update @MyFinalTable set [4 - 200] = @TempAvgSessionDuration where cast(ABD as varchar) = cast(@TempAbdStationName as varchar)
	end

	--UPDATE tblContact SET
	--	AddressID = @TempAddressID,		 
	--WHERE ROW_ID = @TempROW_ID
		
SELECT @Cnt = @Cnt + 1
END

select ABD, [0], [1], [2], [3], [4 - 200] from @MyFinalTable
		