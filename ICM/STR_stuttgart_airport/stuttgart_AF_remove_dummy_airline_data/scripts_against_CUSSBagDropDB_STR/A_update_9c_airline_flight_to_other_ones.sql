--Notes: This script is dedicated for Stuttgart Airport CUSSBagDropDB_STR database re-assigning (distributing) those 9C dummy airline records to other 4 airlines: AF, KL, A3 and DE evenly
--       in table: Flight
--       It will loop through 15732 records from 9C and assign them to AF, KL, A3 and DE
--       In local test it takes 1 minute and 22 seconds

USE CUSSBagDropDB_STR
GO

DECLARE @IsTest bit = 0 --if against production please check this value to 0. Local run this process takes 2:22 minutes Date: 04-03-2021 Wednesday

DECLARE @MyTable TABLE
(
	SNo int IDENTITY(1,1), 
	FlightID int 
)  

if @IsTest = 1
begin
	DECLARE @tbFlight TABLE
	(
		[ID] [bigint] NOT NULL,
		[MarketingCarrier] [nvarchar](25) NOT NULL,
		[FlightNumber] [nvarchar](25) NOT NULL,
		[DepartureDate] [datetime] NOT NULL,
		[BoardPoint] [nvarchar](25) NULL,
		[OffPoint] [nvarchar](25) NULL
	)
	insert into @tbFlight
	SELECT * FROM [dbo].[Flight]  
	WHERE MarketingCarrier = '9C' 
	ORDER BY ID ASC
end

INSERT INTO @MyTable(FlightID)	    
SELECT ID FROM [dbo].[Flight]  
WHERE MarketingCarrier = '9C' 
ORDER BY ID ASC
 
declare @Cnt int
SELECT @Cnt = MIN(Sno) FROM @MyTable
	
declare @TempFlightID int
declare @InnerCnt int = 1 --we define this variable from 1 to 4 if it is reaching 4 we set its next number to be 1 again
 
WHILE (1=1)
BEGIN
   
SELECT @TempFlightID = FlightID FROM @MyTable
WHERE SNo = @Cnt
	    
IF @@ROWCOUNT = 0
	BREAK	 
		 
	if @IsTest = 1
	begin
			if exists(select * from @tbFlight where cast(ID as varchar) = cast(@TempFlightID as varchar))
			begin
				if @InnerCnt = 1
					Update @tbFlight set MarketingCarrier = 'AF' where cast(ID as varchar) = cast(@TempFlightID as varchar)  
				if @InnerCnt = 2
					Update @tbFlight set MarketingCarrier = 'KL' where cast(ID as varchar) = cast(@TempFlightID as varchar)
				if @InnerCnt = 3
					Update @tbFlight set MarketingCarrier = 'A3' where cast(ID as varchar) = cast(@TempFlightID as varchar)
				if @InnerCnt = 4
					Update @tbFlight set MarketingCarrier = 'DE' where cast(ID as varchar) = cast(@TempFlightID as varchar)
			end
	end
	else
	begin
			if exists(select * from Flight where cast(ID as varchar) = cast(@TempFlightID as varchar))
			begin
				if @InnerCnt = 1
					Update Flight set MarketingCarrier = 'AF' where cast(ID as varchar) = cast(@TempFlightID as varchar)  
				if @InnerCnt = 2
					Update Flight set MarketingCarrier = 'KL' where cast(ID as varchar) = cast(@TempFlightID as varchar)
				if @InnerCnt = 3
					Update Flight set MarketingCarrier = 'A3' where cast(ID as varchar) = cast(@TempFlightID as varchar)
				if @InnerCnt = 4
					Update Flight set MarketingCarrier = 'DE' where cast(ID as varchar) = cast(@TempFlightID as varchar)
			end
	end 
	 
	--print '@Cnt =' + cast(@Cnt as varchar)	
	--print '@InnerCnt =' + cast(@InnerCnt as varchar)	
	
	SELECT @InnerCnt = @InnerCnt + 1
	if @InnerCnt > 4
					select @InnerCnt = 1

	SELECT @Cnt = @Cnt + 1
END

if @InnerCnt = 1
begin
	if not exists(select * from @tbFlight where MarketingCarrier = '9C' )
	   print 'all 9C flight records have been assigned to AF, KL, A3 and DE evenly now 15732 rows affected'	
	else
	   print 'some 9C flight records could be assigned to AF, KL, A3 and DE evenly, please check it'

	select * from @tbFlight 
end

if @InnerCnt = 0
begin
	if not exists(select * from Flight where MarketingCarrier = '9C')
	   print 'all 9C flight records have been assigned to AF, KL, A3 and DE evenly now 15732 rows affected'	
	else
	   print 'some 9C flight records could be assigned to AF, KL, A3 and DE evenly, please check it'	   
end
