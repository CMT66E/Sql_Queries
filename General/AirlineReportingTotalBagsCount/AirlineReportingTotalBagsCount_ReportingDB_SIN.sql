		--Purpose: Fetch transaction records data from Perth airport application database ReportingDB_PER based on selected date range: FromDate and ToDate
		--         Each bag record has its own UBI number linked
		--Created date: 24-11-2022 
		USE ReportingDB_SIN
		GO

		declare @FromDate DateTime = '2026/04/01 00:00:00'
		declare @ToDate DateTime = '2026/04/30 23:59:59'
		declare @AbdType varchar(50) = 'ABD' --KSK or ABD -> 25718 --no need this line as we used BagWeightUpdate do the inner join and only ABD has records in BagWeightUpdate

		DROP TABLE IF EXISTS #tempCust
		DROP TABLE IF EXISTS #tempBagweight
		DROP TABLE IF EXISTS #tempBagweightSECOND
		 
		Select * into #tempCust From CustomerSession where LocalTime between @FromDate And @ToDate
		Select * into #tempBagweight from BagWeightUpdate where CustomerSessionId In ( Select ID from #tempCust)

		SELECT     bagt.BagID AS BagID,
				   tempt.ID AS CustomerSessionID, 
				   --CONVERT(varchar(30), tempt.LocalTime,103) + ' ' + LTRIM(RIGHT(CONVERT(CHAR(20),tempt.LocalTime, 22), 11)) As LocalTimeFormatted, --commented out this line as its datetime format in Excel can not be imported into SQL
				   tempt.LocalTime as LocalTime,
				   dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea) AS ABDStation, 
				   AbdStation.AbdType as AbdKiosk,
				   Cast(tempt.TransactionTime as Decimal(10,2))as 'TransactionTime',
				   Flight.MarketingCarrier,				   				   
				   Flight.FlightNumber,					  
				   tempt.PNR, 
				   tempt.SessionDuration,
				   1 as BagCount,
				   tempt.UtcCreationTime,
				   tempt.UtcCompletionTime,
				   bagt.Weight, 				 
				   CAST(CASE WHEN bagt.Weight < 23 THEN 'No' ELSE 'H' END AS CHAR) AS IsHeavyBag
				   ,bag.UBI
				   --,Flight.BoardPoint			   
				   into #tempBagweightSECOND
		FROM         #tempBagweight AS bagt INNER JOIN
								  (SELECT     CustomerSession.ID, CustomerSession.CustomerID, CustomerSession.AbdStationID, CustomerSession.CustomerLookupType, CustomerSession.PNR, 
														   CustomerSession.UtcCreationTime, CustomerSession.FlightID, CustomerSession.TimeSlot5minID, CustomerSession.TimeSlot10minID, 
														   CustomerSession.TimeSlotHourlyID, CustomerSession.DayOfTheWeekID, CustomerSession.LocalTime, CustomerSession.UtcCompletionTime, 
														   CustomerSession.SessionDuration, COUNT(BagWeightUpdate.BagID) AS BagCount, 
														   CustomerSession.SessionDuration / COUNT(BagWeightUpdate.BagID) AS TransactionTime
									FROM         #tempCust CustomerSession INNER JOIN
														  #tempBagweight  BagWeightUpdate ON CustomerSession.ID = BagWeightUpdate.CustomerSessionID
									GROUP BY CustomerSession.ID, CustomerSession.CustomerID, CustomerSession.AbdStationID, CustomerSession.CustomerLookupType, CustomerSession.PNR, 
														   CustomerSession.UtcCreationTime, CustomerSession.FlightID, CustomerSession.TimeSlot5minID, CustomerSession.TimeSlot10minID, 
														   CustomerSession.TimeSlotHourlyID, CustomerSession.DayOfTheWeekID, CustomerSession.LocalTime, CustomerSession.UtcCompletionTime, 
														   CustomerSession.SessionDuration
																HAVING      (CustomerSession.LocalTime >= @FromDate
															 ) AND CustomerSession.LocalTime <= @ToDate --AND CustomerSession.SessionDuration > 0
															   ) AS tempt ON bagt.CustomerSessionID = tempt.ID INNER JOIN
							  Bag ON bagt.BagID = Bag.ID INNER JOIN
							  Flight ON tempt.FlightID = Flight.ID INNER JOIN
							  AbdStation ON tempt.AbdStationID = AbdStation.ID
		where AbdStation.AbdType = @AbdType
		ORDER BY tempt.UtcCreationTime

		
		if exists(select UBI from #tempBagweightSECOND group by UBI
		having COUNT(UBI) > 1)
		begin
		    print 'Found duplicated UBIs so we delete them'

			DECLARE @tblTemp TABLE
			(
			SNo int IDENTITY(1,1), 
			CustomerSessionID BIGINT,
            UBI nvarchar(20) 
			)

			insert into @tblTemp(CustomerSessionID, UBI)
            select min(CustomerSessionID) as CustomerSessionID, UBI from #tempBagweightSECOND where UBI in 
			(
			select UBI from #tempBagweightSECOND group by UBI
		    having COUNT(UBI) > 1
			)
			group by UBI 
 

			DECLARE @TempUBI NVARCHAR(20)
			DECLARE @TempCustomerSessionID BIGINT
			DECLARE @Cnt INT
			SELECT @Cnt = MIN(Sno) FROM @tblTemp
	
			WHILE (1=1)
			BEGIN
   
			SELECT @TempUBI = UBI, @TempCustomerSessionID = CustomerSessionID FROM @tblTemp
			WHERE SNo = @Cnt
	    
			IF @@ROWCOUNT = 0
				BREAK
				if exists(select * from #tempBagweightSECOND where CustomerSessionID = @TempCustomerSessionID and UBI = @TempUBI)
				   delete from #tempBagweightSECOND where CustomerSessionID = @TempCustomerSessionID and UBI = @TempUBI
		 
			SELECT @Cnt = @Cnt + 1		
			END

			delete from @tblTemp
			print 'Duplicated UBIs total ' + cast(@Cnt-1  as varchar) + ' has been removed'
		end

		select 
		* 
		from #tempBagweightSECOND 

		select a.AbdKiosk + '_' + a.ABDStation as AbdName, count(a.BagID) as TotalBags  
		from #tempBagweightSECOND a
		group by a.AbdKiosk + '_' + a.ABDStation order by count(a.BagID)

		select cast(LocalTime as date) as MonthDay, count(BagID) as TotalBags from #tempBagweightSECOND group by cast(LocalTime as date) order by cast(LocalTime as date)
	    select MarketingCarrier, count(BagID) as TotalBags from #tempBagweightSECOND group by MarketingCarrier having count(BagID) > 10

 