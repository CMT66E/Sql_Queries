USE CUSSReportingDB_STR
GO

declare @ReportMonthFirstDay DateTime = '2022/08/01 00:00:00'

DECLARE @IsTest bit = 0 --if against production please check this value to 0. Local run this process takes Date: 27-09-2021 Tuesday

DECLARE @MyTable TABLE
(
	SNo int IDENTITY(1,1), 
	[FlightID] bigint,
	[MarketingCarrier] [nvarchar](25)  NULL,
	[FlightNumber] [nvarchar](25)  NULL,
	[DepartureDate] [datetime]  NULL,
	[BoardPoint] [nvarchar](25) NULL,
	[OffPoint] [nvarchar](25) NULL	
)

if @IsTest = 1
begin
	DECLARE @tbFlight TABLE
	(
	    SNo int IDENTITY(1,1), 
		[ID] [bigint] NOT NULL,
		[MarketingCarrier] [nvarchar](25) NULL,
		[FlightNumber] [nvarchar](25) NULL,
		[DepartureDate] [datetime] NULL,
		[BoardPoint] [nvarchar](25) NULL,
		[OffPoint] [nvarchar](25) NULL
	)

	insert into @tbFlight
	select b.ID, b.MarketingCarrier, b.FlightNumber, b.DepartureDate, b.BoardPoint, b.OffPoint
	FROM [dbo].[CustomerSession] a 
	INNER JOIN Flight b on a.FlightID = b.ID
	LEFT OUTER JOIN AbdStation c on a.AbdStationID = c.ID
	WHERE 
	datepart(year, b.[DepartureDate]) = datepart(year, @ReportMonthFirstDay) 
	and datepart(month, b.[DepartureDate]) = datepart(month, @ReportMonthFirstDay) 	
  --and datepart(day, b.[DepartureDate]) = datepart(day, @ReportMonthFirstDay) 	
	and b.MarketingCarrier = 'DE'
	order by b.DepartureDate, a.LocalTime  
end

INSERT INTO @MyTable(
	[FlightID],
	[MarketingCarrier],
	[FlightNumber],
	[DepartureDate],
	[BoardPoint],
	[OffPoint]
)	    
select 
b.ID, 
b.MarketingCarrier, 
b.FlightNumber, 
b.DepartureDate, 
b.BoardPoint, 
b.OffPoint
FROM [dbo].[CustomerSession] a 
INNER JOIN Flight b on a.FlightID = b.ID
LEFT OUTER JOIN AbdStation c on a.AbdStationID = c.ID
WHERE 
datepart(year, b.[DepartureDate]) = datepart(year, @ReportMonthFirstDay) 
and datepart(month, b.[DepartureDate]) = datepart(month, @ReportMonthFirstDay) 
--and datepart(day, b.[DepartureDate]) = datepart(day, @ReportMonthFirstDay) 
and b.MarketingCarrier = 'DE'
order by b.DepartureDate, a.LocalTime  


declare @Cnt int
SELECT @Cnt = MIN(Sno) FROM @MyTable
	
declare @TempFlightID int
declare @TempMarketingCarrier nvarchar(25) 
declare @TempFlightNumber nvarchar(25) 
declare @TempDepartureDate datetime
declare @TempBoardPoint nvarchar(25)
declare @TempOffPoint nvarchar(25)

declare @TempFlightIDFinal int
declare @TempMarketingCarrierFinal nvarchar(25)
declare @TempFlightNumberFinal nvarchar(25)

declare @InnerCnt2 int = 0 

declare @InnerCnt int = 1 --we define this variable from 1 to 4 if it is reaching 4 we set its next number to be 1 again
 
WHILE (1=1)
BEGIN
   
SELECT 
@TempFlightID = FlightID,
@TempMarketingCarrier = MarketingCarrier,
@TempFlightNumber = FlightNumber,
@TempDepartureDate = DepartureDate,
@TempBoardPoint = BoardPoint,
@TempOffPoint = OffPoint
FROM @MyTable
WHERE SNo = @Cnt
	    
IF @@ROWCOUNT = 0
	BREAK

	      
		  --print '@TempFlightID =' + cast(@TempFlightID as varchar)	
		  --print '@TempFlightNumber =' + cast(@TempFlightNumber as varchar)	
		  --print '@TempDepartureDate AAAAAAAAAAA =' + cast(@TempDepartureDate as varchar)
		  --print '@TempBoardPoint =' + cast(@TempBoardPoint as varchar)
		  --print '@TempOffPoint =' + cast(@TempOffPoint as varchar)

		  --1. checking flight ID and DepartureDate if we can get flight ID from the groups other than 'DE'
		  if exists(select TOP 1 ID from Flight where DepartureDate = @TempDepartureDate and BoardPoint = @TempBoardPoint and OffPoint = @TempOffPoint order by ID desc)
		  begin
		      select TOP 1 @TempFlightIDFinal = ID 
			  from Flight 
			  where DepartureDate = @TempDepartureDate 
			  and BoardPoint = @TempBoardPoint 
			  and OffPoint = @TempOffPoint 
			  and MarketingCarrier <> 'DE'
			  and MarketingCarrier <> 'YY'
			  order by ID desc		      
			  
			  SELECT @TempMarketingCarrierFinal = [MarketingCarrier], @TempFlightNumberFinal = FlightNumber			  
			  FROM [Flight]
			  WHERE ID = @TempFlightIDFinal

			  print '@TempFlightID =' + cast(@TempFlightID as varchar)	
			  print '@TempFlightIDFinal =' + cast(@TempFlightIDFinal as varchar)
			  print '@TempMarketingCarrierFinal =' + cast(@TempMarketingCarrierFinal as varchar)
			  print '@TempFlightNumberFinal =' + cast(@TempFlightNumberFinal as varchar)

			  if @IsTest = 1
			  begin
				update @tbFlight set MarketingCarrier = isnull(@TempMarketingCarrierFinal, '') where ID = @TempFlightID
			  end
			  else
			  begin
			    -- we can not update the reord as below directly because
				-- Violation of UNIQUE KEY constraint 'UNIQ_Flight_MarketingCarrier_FlightNumber_DepartureDate'. Cannot insert duplicate key in object 'dbo.Flight'. The duplicate key value is (AF, 0, Aug  2 2022  4:00PM).
				-- update Flight set MarketingCarrier = isnull(@TempMarketingCarrierFinal, ''), FlightNumber = @TempFlightNumberFinal where ID = @TempFlightID and FlightNumber = @TempFlightNumber
				-- so we update CustomerSession table FlightID to the new flight final ID
				--update CustomerSession set FlightID = @TempFlightNumberFinal where FlightID = @TempFlightNumber
				update Flight set MarketingCarrier = isnull(@TempMarketingCarrierFinal, '') where ID = @TempFlightID and FlightNumber = @TempFlightNumber
			  end

			  set @InnerCnt2 = @InnerCnt2 + 1
		  end	
		  else
		  begin
		     -- we didnt' find anything on the first try
			 print 'XXXXXXXXXXXXXXXXXXXXXXXXXX flight ID ' + cast(@TempFlightID as varchar)	+' XXXXXXXXXXXXXXXXXXXXXXXX '
		  end
		
	SELECT @Cnt = @Cnt + 1
END

print '@Cnt =' + cast(@Cnt as varchar)	
print '@InnerCnt2 =' + cast(@InnerCnt2 as varchar)

select * from @MyTable

if @IsTest = 1
	select * from @tbFlight
else
    print 'Table Flight with total ' + cast(@InnerCnt2 as varchar) + ' records have been updated'