--Notes: This script is dedicated for Perth Airport CUSSBagDropDB_PER database re-assigning (distributing) those 9C, 086, 160, 803 dummy airline records to other 4 airlines: CX, NZ, MH, SQ evenly
--       in table: Flight
--       It will loop through 160 records from 9C, 086, 160, 803 and assign them to CX, NZ, MH, SQ
--       In local test it takes few seconds

USE CUSSBagDropDB_PER
GO

DECLARE @IsTest bit = 0 --if against production please check this value to 0. Local run this process takes 0:01 minutes Date: 12-07-2021 Wednesday

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
	WHERE NOT [MarketingCarrier] in ('CX', 'NZ', 'MH', 'SQ')  --show 9C, 086, 160, 803
	ORDER BY ID ASC
end

INSERT INTO @MyTable(FlightID)	    
SELECT ID FROM [dbo].[Flight]  
WHERE NOT [MarketingCarrier] in ('CX', 'NZ', 'MH', 'SQ')  --show 9C, 086, 160, 803
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
					Update @tbFlight set MarketingCarrier = 'CX' where cast(ID as varchar) = cast(@TempFlightID as varchar)  
				if @InnerCnt = 2
					Update @tbFlight set MarketingCarrier = 'NZ' where cast(ID as varchar) = cast(@TempFlightID as varchar)
				if @InnerCnt = 3
					Update @tbFlight set MarketingCarrier = 'MH' where cast(ID as varchar) = cast(@TempFlightID as varchar)
				if @InnerCnt = 4
					Update @tbFlight set MarketingCarrier = 'SQ' where cast(ID as varchar) = cast(@TempFlightID as varchar)
			end
	end
	else
	begin
			if exists(select * from Flight where cast(ID as varchar) = cast(@TempFlightID as varchar))
			begin
				if @InnerCnt = 1
					Update Flight set MarketingCarrier = 'CX' where cast(ID as varchar) = cast(@TempFlightID as varchar)  
				if @InnerCnt = 2
					Update Flight set MarketingCarrier = 'NZ' where cast(ID as varchar) = cast(@TempFlightID as varchar)
				if @InnerCnt = 3
					Update Flight set MarketingCarrier = 'MH' where cast(ID as varchar) = cast(@TempFlightID as varchar)
				if @InnerCnt = 4
					Update Flight set MarketingCarrier = 'SQ' where cast(ID as varchar) = cast(@TempFlightID as varchar)
			end
	end 
	 
	--print '@Cnt =' + cast(@Cnt as varchar)	
	--print '@InnerCnt =' + cast(@InnerCnt as varchar)	
	
	SELECT @InnerCnt = @InnerCnt + 1
	if @InnerCnt > 4
					select @InnerCnt = 1

	SELECT @Cnt = @Cnt + 1
END

if @IsTest = 1
begin
	if not exists(select * from @tbFlight where [MarketingCarrier] in ('9C', '086', '160', '803') )
	   print 'all 9C, 086, 160, 803 flight records have been assigned to CX, NZ, MH, SQ evenly now 160 rows affected'	
	else
	   print 'some 9C, 086, 160, 803 flight records could be assigned to CX, NZ, MH, SQ evenly, please check it'

	select * from @tbFlight 
end

else

begin
	if not exists(select * from Flight where [MarketingCarrier] in ('9C', '086', '160', '803'))
	   print 'all 9C, 086, 160, 803 flight records have been assigned to CX, NZ, MH, SQ evenly now 160 rows affected'	
	else
	   print 'some 9C, 086, 160, 803 flight records could be assigned to CX, NZ, MH, SQ evenly, please check it'	   
end
