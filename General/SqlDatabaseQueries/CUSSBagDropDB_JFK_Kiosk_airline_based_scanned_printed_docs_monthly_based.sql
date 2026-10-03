USE CUSSBagDropDB_JFK
GO

declare @ReportMonthFirstDay DateTime = '2026/02/01 00:00:00'
declare @ReportMonthEndDay DateTime = '2026/02/28 23:59:59'
declare @AbdType varchar(50) = 'KSK' --KSK or ABD

DECLARE @MyTable TABLE
(
SNo int IDENTITY(1,1), 
Airline varchar(50),
TotalSessions int
)  

DECLARE @MyFinalTable TABLE
(
SNo int IDENTITY(1,1), 
Airline varchar(50),
TotalScanned int,
TotalPrinted int,
BagTagPrinted int,
BoardingPassPrinted int,
TotalSessions int
) 

insert into @MyTable
select (case when b.[MarketingCarrier] = '' then 'Empty' else b.[MarketingCarrier] end) as Airline, count(a.ID) as TotalSessions
FROM [dbo].[CustomerSession] a 
LEFT OUTER JOIN Flight b on a.FlightID = b.ID
INNER JOIN AbdStation c on a.AbdStationID = c.ID
WHERE 
--datepart(year, a.[LocalTime]) = datepart(year, @ReportMonthFirstDay) and datepart(month, a.[LocalTime]) = datepart(month, @ReportMonthFirstDay) 
a.[LocalCreationTime] between @ReportMonthFirstDay and @ReportMonthEndDay
and c.AbdType = @AbdType --only grab records from KSK
group by b.[MarketingCarrier]
order by b.[MarketingCarrier]

select * from @MyTable

declare @Cnt int
SELECT @Cnt = MIN(Sno) FROM @MyTable
	
declare @TempROW_ID int
declare @TempAirline varchar(50)
declare @TempTotalSessions int

declare @TempTotalScanned int = 0
declare @TempTotalPrinted int = 0
declare @TempBagTagPrinted int = 0
declare @TempBoardingPassPrinted int  = 0

WHILE (1=1)
BEGIN
   
SELECT @TempROW_ID = SNo, @TempAirline = Airline, @TempTotalSessions = TotalSessions FROM @MyTable
WHERE SNo = @Cnt
	    
IF @@ROWCOUNT = 0
	BREAK
	print 'Curent Airline = ' + cast(@TempAirline as varchar)
	if exists(
				select Top 1 *
				FROM [dbo].[CustomerSession] a LEFT OUTER JOIN Flight b on a.FlightID = b.ID INNER JOIN AbdStation c on a.AbdStationID = c.ID
				WHERE 
				--datepart(year, a.[LocalTime]) = datepart(year, @ReportMonthFirstDay) and datepart(month, a.[LocalTime]) = datepart(month, @ReportMonthFirstDay)
				a.[LocalCreationTime] between @ReportMonthFirstDay and @ReportMonthEndDay
				and cast(b.[MarketingCarrier] as varchar) = cast(@TempAirline as varchar) and c.AbdType = @AbdType
	         )
	begin
		-- total scanned document CustomerSession
		SELECT @TempTotalScanned = count(a.[ID])			  
		  FROM [dbo].[ScannedDocument] a  
		  left outer join CustomerSession b on a.CustomerSessionID = b.ID
		  left outer join Flight c on b.FlightID = c.ID
		  inner join AbdStation d on b.AbdStationID = d.ID
		where 
		--datepart(year, b.[LocalTime]) = datepart(year, @ReportMonthFirstDay) and datepart(month, b.[LocalTime]) = datepart(month, @ReportMonthFirstDay) 
		b.[LocalCreationTime] between @ReportMonthFirstDay and @ReportMonthEndDay
		and c.[MarketingCarrier] = @TempAirline  and d.AbdType = @AbdType

		--records for total scanned document CustomerSession
		--Doc Types: 
		--0	BoardingPass
		--1	Passport
		--2	Magnetic Card
		--3	Bag Tag
		--4	Receipt

		SELECT @TempTotalPrinted= count(a.[ID])		   
		  FROM [dbo].[PrintDocument] a  
		  left outer join CustomerSession b on a.CustomerSessionID = b.ID
		  left outer join Flight c on b.FlightID = c.ID
		  inner join AbdStation d on b.AbdStationID = d.ID
		where 
		--datepart(year, b.[LocalTime]) = datepart(year, @ReportMonthFirstDay) and datepart(month, b.[LocalTime]) = datepart(month, @ReportMonthFirstDay)
		b.[LocalCreationTime] between @ReportMonthFirstDay and @ReportMonthEndDay
		and c.[MarketingCarrier] = @TempAirline  
		and d.AbdType = @AbdType

		-- Doc type = 3	Bag Tag total records
		SELECT @TempBagTagPrinted = count(a.[ID])	  
		  FROM [dbo].[PrintDocument] a  
		  left outer join CustomerSession b on a.CustomerSessionID = b.ID
		  left outer join Flight c on b.FlightID = c.ID
		  inner join AbdStation d on b.AbdStationID = d.ID
		where 
		--datepart(year, b.[LocalTime]) = datepart(year, @ReportMonthFirstDay) and datepart(month, b.[LocalTime]) = datepart(month, @ReportMonthFirstDay)
		b.[LocalCreationTime] between @ReportMonthFirstDay and @ReportMonthEndDay
		and c.[MarketingCarrier] = @TempAirline and a.DocType = 3  
		and d.AbdType = @AbdType

		-- Doc type = 0	BoardingPass total records
		SELECT @TempBoardingPassPrinted = count(a.[ID])			  
		  FROM [dbo].[PrintDocument] a  
		  left outer join CustomerSession b on a.CustomerSessionID = b.ID
		  left outer join Flight c on b.FlightID = c.ID
		  inner join AbdStation d on b.AbdStationID = d.ID
		where 
		--datepart(year, b.[LocalTime]) = datepart(year, @ReportMonthFirstDay) and datepart(month, b.[LocalTime]) =datepart(month, @ReportMonthFirstDay) 
		b.[LocalCreationTime] between @ReportMonthFirstDay and @ReportMonthEndDay
		and c.[MarketingCarrier] = @TempAirline and a.DocType = 0  
		and d.AbdType = @AbdType
	    
		if not exists(select * from @MyFinalTable where Airline = @TempAirline)
		begin
              insert into @MyFinalTable(
							Airline,
							TotalScanned,
							TotalPrinted,
							BagTagPrinted,
							BoardingPassPrinted,
							TotalSessions			  
			               ) values
						   (
							@TempAirline,
							@TempTotalScanned,
							@TempTotalPrinted,
							@TempBagTagPrinted,
							@TempBoardingPassPrinted,
							@TempTotalSessions							   
						   )
		end

		
	end

SELECT @Cnt = @Cnt + 1
		
END

--Finally we display all results below
--select * from @MyFinalTable

--We do further processing because some airlines have been marked as 5, 6, 086 etc. we need know which airline they belong to
DECLARE @MyTableTemp TABLE
(
SNo int IDENTITY(1,1), 
Airline varchar(50) 
)  
insert into @MyTableTemp(Airline)
select Airline from @MyFinalTable where ISNUMERIC(Airline) = 1 

declare @TempAirline2 varchar(50)
declare @TempFlightNumber2 varchar(50) = ''
declare @TempBoardPoint2 varchar(50)
declare @TempOffPoint2 varchar(50)

declare @TempFinalAirline2 varchar(50)

DECLARE @Cnt2 INT
SELECT @Cnt2 = MIN(Sno) FROM @MyTable
	
WHILE (1=1)
BEGIN
   
SELECT @TempAirline2 = Airline FROM @MyTableTemp
WHERE SNo = @Cnt2
	    
IF @@ROWCOUNT = 0
	BREAK
	if exists
	(
		select TOP 1 b.ID
		FROM [dbo].[CustomerSession] a 
		LEFT OUTER JOIN Flight b on a.FlightID = b.ID
		INNER JOIN AbdStation c on a.AbdStationID = c.ID
		WHERE 
		datepart(year, a.[LocalCreationTime]) = datepart(year, @ReportMonthFirstDay) and datepart(month, a.[LocalCreationTime]) = datepart(month, @ReportMonthFirstDay) 
		and c.AbdType = @AbdType
		and b.[MarketingCarrier] = @TempAirline2
	)
	begin
	    select TOP 1 @TempFlightNumber2 = b.FlightNumber, @TempBoardPoint2 = b.BoardPoint, @TempOffPoint2 = b.OffPoint
		FROM [dbo].[CustomerSession] a 
		LEFT OUTER JOIN Flight b on a.FlightID = b.ID
		INNER JOIN AbdStation c on a.AbdStationID = c.ID
		WHERE 
		datepart(year, a.[LocalCreationTime]) = datepart(year, @ReportMonthFirstDay) and datepart(month, a.[LocalCreationTime]) = datepart(month, @ReportMonthFirstDay) 
		and c.AbdType = @AbdType
		and b.[MarketingCarrier] = @TempAirline2

		print 'Curent @TempAirline2 Further Process = ' + cast(@TempAirline2 as varchar)
		print 'Curent @TempFlightNumber2 Further Process = ' + cast(@TempFlightNumber2 as varchar)
		print 'Curent @TempBoardPoint2 Further Process = ' + cast(@TempBoardPoint2 as varchar)
		print 'Curent @TempOffPoint2 Further Process = ' + cast(@TempOffPoint2 as varchar)

		select  TOP 1 @TempFinalAirline2 = b.MarketingCarrier
		FROM [dbo].[CustomerSession] a 
		LEFT OUTER JOIN Flight b on a.FlightID = b.ID
		INNER JOIN AbdStation c on a.AbdStationID = c.ID
		WHERE 
		datepart(year, a.[LocalCreationTime]) = datepart(year, @ReportMonthFirstDay) and datepart(month, a.[LocalCreationTime]) = datepart(month, @ReportMonthFirstDay) 
		and c.AbdType = @AbdType
		and ISNUMERIC(b.[MarketingCarrier]) = 0
		and b.FlightNumber = @TempFlightNumber2 and b.BoardPoint = @TempBoardPoint2 and b.OffPoint = @TempOffPoint2
		and b.[MarketingCarrier] <> 'YY'

		

		if @TempFinalAirline2 <> ''
		begin
		  update @MyFinalTable set Airline = @TempFinalAirline2 where Airline = @TempAirline2
		  set @TempFinalAirline2 = ''
		end
	end
		
SELECT @Cnt2 = @Cnt2 + 1		
END

--select * from @MyFinalTable

select 
Airline,
sum(TotalScanned) as TotalScanned,
sum(TotalPrinted) as TotalPrinted,
sum(BagTagPrinted) as BagTagPrinted,
sum(BoardingPassPrinted) as BoardingPassPrinted,
sum(TotalSessions) as TotalSessions  
from @MyFinalTable
group by Airline

