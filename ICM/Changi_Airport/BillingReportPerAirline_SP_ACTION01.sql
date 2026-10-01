declare @Fromdate Datetime = '2026-05-01 00:00:00'
declare @Todate  Datetime = '2026-05-31 23:59:59'
declare @AirlineGroupID INT  = 2


		--Select @Fromdate ='2016-01-01 00:55:48.907',@Todate='2016-12-31 23:59:59.998',@AirlineGroupID=1

		Declare @TotalPaxcountCurrentMonth INT,@MaxPaxChargeband INT,@PaxChargeBand INT,@MaxValueDifference INT,@Paxcount INT,
		@PaxMovementBandId INT,@Rate Decimal(10,3),@TP INT,@PaxMovementBandFromdate Datetime, @MonthDiff INT ,
		@TotalPaxcountPrevMonth INT,@MaxRangeValue INT,@DiffValue INT,@TotalPaxcountProcessed INT,@BillingColumn NVARCHAR(20),
		@TotalPax INT, @TotalRate Decimal(10,3), @AvgRate Decimal(10,8),@Counter INT,@MarketingCarrier nvarchar(20)

		Declare @JoinDate Datetime ,@WithinFY  INT,@DiscountPercentage  Decimal(10,2),@FYStartDate Datetime ,@FYEndDate Datetime
	   
	    Declare @DiscountPrice Decimal(10,3),@NetTotal Decimal(10,3),@SubTotal Decimal(10,3)

		-- Select @Fromdate ='2017-05-01 00:00:00.000',@Todate='2017-05-30 23:59:59.998',@AirlineGroupID=3
	   
		IF OBJECT_ID('tempdb..##BillingReportTemplate') is not null
		DROP TABLE [dbo].[##BillingReportTemplate]

		IF OBJECT_ID('tempdb..##BillingReportPerAirline') is not null
		DROP TABLE [dbo].[##BillingReportPerAirline]

		Create table ##BillingReportTemplate
		(
		   ID  INT IDENTITY(1,1),
		   FYStartDate Datetime,
		   PaxInvoiced INT,
		   PaxMovementBand  NVARCHAR(50),
		   PaxCount INT,
		   Rate nvarchar(50) NULL,
		   SubTotal Decimal(10,3) NULL,
		   DiscountPercentage Decimal(10,2),
		   Discount Decimal(10,3),
		   NetTotal Decimal(10,3),
		)

		Create table ##BillingReportPerAirline
		(
		   ID  INT IDENTITY(1,1),
		   AirlineName nvarchar(50) NULL,
		   AirlineCode nvarchar(20) NULL,
		   PaxCount INT NULL,
		   AvgRate Decimal(10,3) NULL,
		   Total Decimal(10,3) NULL
		)

		Select @JoinDate=JoinDate From AirlineBillingData Where AirlineGroupID = @AirlineGroupID


		Set @WithinFY= 0

		IF( @JoinDate is Not null)
		BEGIN
			Select   @FYStartDate = Fromdate,@FYEndDate=Todate from BillingFYdata Where (@Fromdate Between Fromdate And Todate) And (@Todate Between Fromdate And Todate)
			IF (@JoinDate Between @FYStartDate And @FYEndDate) 
			 Select @WithinFY = 1  
		END
	

		IF(@WITHINFY=1)
		BEGIN
			SELECT @DiscountPercentage = Discount From AirlineDiscountChart Where MONTH(@JoinDate) Between Month(Fromdate) AND Month(Todate) 
		END
		ELSE
		BEGIN
			SET @DiscountPercentage = 0
		END
		
		
		
		SET @TotalPaxcountPrevMonth = 0

		--SET @TotalPaxcountCurrentMonth = 16000
		SET @MonthDiff = null
		---------------- Select the Total Pax movement band ------------------------------
		Select  @PaxMovementBandId= PaxMovementBandId , @PaxMovementBandFromdate = Fromdate from PaxMovementBandHistory Where (@Fromdate Between Fromdate And Todate) And (@Todate Between Fromdate And Todate)

		Select @BillingColumn = BandDescription from PaxMovementBand where ID = @PaxMovementBandId
		IF  @PaxMovementBandFromdate IS NOT NULL AND @Fromdate <= Getdate()
		BEGIN
			SELECT @MonthDiff =DATEDIFF(month, @PaxMovementBandFromdate
			, @Fromdate)
		
		END
		
		IF @MonthDiff = 0
		BEGIN
		--------- Get the  total Pax count For first Month Only-------------------
				Select @TotalPaxcountCurrentMonth=Count(DISTINCT C.ID)
				from CustomerSession C 
				JOIN  BagWeightUpdate B on B.CustomerSessionID = C.ID
				JOIN Flight F On C.FlightID = f.ID
				JOIN AirlineGroup  AG  On Ag.AirlineGroupID = F.AirlineGroupID  
				WHERE  c.LocalTime between @Fromdate and @Todate
				AND f.AirlineGroupID=@AirlineGroupID Group  by AG.AirlineGroupID
				
		

		END
		ELSE IF @MonthDiff > 0
		BEGIN
			--------- Get the  total Pax count -until current Month------------------
				Select @TotalPaxcountCurrentMonth=Count(DISTINCT C.ID)
				from CustomerSession C 
				JOIN  BagWeightUpdate B on B.CustomerSessionID = C.ID
				JOIN Flight F On C.FlightID = f.ID
				JOIN AirlineGroup  AG  On Ag.AirlineGroupID = F.AirlineGroupID  
				WHERE  c.LocalTime between @PaxMovementBandFromdate and @Todate
				AND f.AirlineGroupID=@AirlineGroupID Group  by AG.AirlineGroupID

				Select @TotalPaxcountPrevMonth=Count(DISTINCT C.ID)
				from CustomerSession C 
				JOIN  BagWeightUpdate B on B.CustomerSessionID = C.ID
				JOIN Flight F On C.FlightID = f.ID
				JOIN AirlineGroup  AG  On Ag.AirlineGroupID = F.AirlineGroupID  
				WHERE  c.LocalTime between @PaxMovementBandFromdate and Dateadd(ms,996,DateAdd(ss,59,DateAdd(Minute,-1,@Fromdate) ))
				AND f.AirlineGroupID=@AirlineGroupID Group  by AG.AirlineGroupID
		
		END


		--------Select maximum Pax charge band according to the total pax transaction---------------
		Select  @MaxPaxChargeband= ID from PaxchargeBand Where minRange<=@TotalPaxcountCurrentMonth And maxRange >=@TotalPaxcountCurrentMonth

		--------Select Min Pax charge band  ---------------
		IF @TotalPaxcountPrevMonth <> 0
		BEGIN
			Select  @PaxChargeBand= ID from PaxchargeBand Where minRange<=@TotalPaxcountPrevMonth And maxRange >=@TotalPaxcountPrevMonth
		END
		ELSE
		BEGIN
				Select @PaxChargeBand = MIN(ID) from PaxchargeBand
		END

		
		IF @PaxMovementBandId  IS NULL
		BEGIN
			SET @PaxMovementBandId = 0
		END

	
		Select @MaxValueDifference= maxRange,@MaxRangeValue=maxRange from PaxchargeBand Where ID=@PaxChargeBand

		SET @TotalPaxcountProcessed= @TotalPaxcountPrevMonth
		While @PaxChargeBand <= @MaxPaxChargeband AND @PaxMovementBandId <> 0 
		BEGIN
		 

		    IF((@TotalPaxcountPrevMonth + @MaxValueDifference) > @MaxRangeValue AND @TotalPaxcountCurrentMonth > @MaxRangeValue)
			BEGIN
					 SET @Paxcount = @MaxRangeValue - @TotalPaxcountPrevMonth
					 SET @TotalPaxcountPrevMonth = @TotalPaxcountPrevMonth + @Paxcount
					 --PRINT '1st'
					
			END
			ELSE IF ((@TotalPaxcountPrevMonth < @MaxRangeValue) AND (@TotalPaxcountCurrentMonth > @TotalPaxcountPrevMonth) AND @TotalPaxcountPrevMonth <> 0  )
			BEGIN
					 SET @DiffValue = @TotalPaxcountCurrentMonth- @TotalPaxcountPrevMonth

					 IF(@DiffValue > @MaxValueDifference)
						SET @Paxcount = @MaxValueDifference
					 ELSE
					   SET @Paxcount = @DiffValue

					 SET @TotalPaxcountPrevMonth = @TotalPaxcountPrevMonth + @Paxcount
					  --PRINT '2nd'
			END
			ELSE IF (@TotalPaxcountPrevMonth = 0 )
			BEGIN
					 IF( @TotalPaxcountCurrentMonth > @MaxValueDifference)
					   SET @Paxcount = @MaxValueDifference
					ELSE
					   SET @Paxcount = @TotalPaxcountCurrentMonth
					SET @TotalPaxcountPrevMonth = @Paxcount
					-- PRINT '3rd'
			END
		   
			 Select @Rate = Rate From PaxChargeMovementMapping Where PaxChargeBandID = @PaxChargeBand  and PaxMovementBandID =  @PaxMovementBandId
			
			IF @Paxcount > 0
			BEGIN
				SET @SubTotal = @Rate * @Paxcount
				SET @DiscountPrice = (@SubTotal * @DiscountPercentage)/100.00
				SET @NetTotal = @SubTotal - @DiscountPrice
				INSERT Into ##BillingReportTemplate values(@PaxMovementBandFromdate,@TotalPaxcountProcessed,@BillingColumn,@Paxcount,@Rate,@SubTotal,@DiscountPercentage,@DiscountPrice,@NetTotal)
			END
			
			SET  @MaxValueDifference = (Select maxRange from PaxchargeBand Where ID=@PaxChargeBand + 1) - ( Select maxRange from PaxchargeBand Where ID=@PaxChargeBand)
		 
			SET @PaxChargeBand = @PaxChargeBand + 1

			Select @MaxRangeValue=maxRange from PaxchargeBand Where ID=@PaxChargeBand

		END

		Select  @TotalPax = SUM(PaxCount),@TotalRate = SUM(NetTotal) from ##BillingReportTemplate

		--Select @TotalPax,@TotalRate

		Select @AvgRate =  @TotalRate/@TotalPax
		--Select @TotalPax,@TotalRate,@AvgRate


		INSERT INTO ##BillingReportPerAirline (AirlineName,AirlineCode) Select AirlineName,AirlineCode from AirlineGroupMapping Where AirlineGroupID= @AirlineGroupID


		SET @Counter = 1
		WHILE @Counter <= (select Count(*) From ##BillingReportPerAirline)
		BEGIN
				Select @MarketingCarrier = (select AirlineCode From ##BillingReportPerAirline Where ID = @Counter)
				Select @Paxcount= Count(DISTINCT  C.ID) 
				from CustomerSession C 
				JOIN  BagWeightUpdate B on B.CustomerSessionID = C.ID
				JOIN Flight F On C.FlightID = f.ID
				JOIN AirlineGroup  AG  On Ag.AirlineGroupID = F.AirlineGroupID  
				JOIN AirlineGroupMapping AGM On AGM.AirlineGroupID = AG.AirlineGroupID
				WHERE  c.LocalTime between @Fromdate and @Todate
				AND f.AirlineGroupID=@AirlineGroupID  and MarketingCarrier = @MarketingCarrier 

				PRINT @MarketingCarrier
				PRINT @Paxcount

				UPDATE ##BillingReportPerAirline 
					SET  PaxCount = @Paxcount,
						 AvgRate = ISNULL(@AvgRate,0),
						 Total = ISNULL(@Paxcount * @AvgRate,0)
				WHERE ID = @Counter

			SET @Counter = @Counter + 1
		END

		--Select * from ##BillingReportTemplate
		 Select ID,AirlineName,AirlineCode,PaxCount from ##BillingReportPerAirline		