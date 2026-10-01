

	declare @FromDateTime DateTime = '2018-03-01'
	declare @ToDateTime DateTime = '2018-03-31'

DROP TABLE IF EXISTS #TemptabPerDayNoofBagsPerABD

		SELECT     CustomerSession.ID, CustomerSession.CustomerID, CustomerSession.AbdStationID, CustomerSession.CustomerLookupType, CustomerSession.PNR, 
							  CustomerSession.UtcCreationTime, CustomerSession.FlightID, CustomerSession.TimeSlot5minID, CustomerSession.TimeSlot10minID, 
							  CustomerSession.TimeSlotHourlyID, CustomerSession.DayOfTheWeekID, CustomerSession.LocalTime, CustomerSession.UtcCompletionTime, 
							  CustomerSession.SessionDuration, COUNT(BagWeightUpdate.BagID) AS BagCount
		INTO #TemptabPerDayNoofBagsPerABD
		FROM         CustomerSession LEFT OUTER JOIN
							  BagWeightUpdate ON CustomerSession.ID = BagWeightUpdate.CustomerSessionID
		WHERE CustomerSession.LocalTime BETWEEN @FromDateTime AND @ToDateTime
		GROUP BY CustomerSession.ID, CustomerSession.CustomerID, CustomerSession.AbdStationID, CustomerSession.CustomerLookupType, CustomerSession.PNR, 
							  CustomerSession.UtcCreationTime, CustomerSession.FlightID, CustomerSession.TimeSlot5minID, CustomerSession.TimeSlot10minID, 
							  CustomerSession.TimeSlotHourlyID, CustomerSession.DayOfTheWeekID, CustomerSession.LocalTime, CustomerSession.UtcCompletionTime, 
							  CustomerSession.SessionDuration   

select * from #TemptabPerDayNoofBagsPerABD
select SUM(BagCount) as BagCount from #TemptabPerDayNoofBagsPerABD 

 select SUM(BagCount) as BagCount from #TemptabPerDayNoofBagsPerABD  
 select SUM(BagCount) as BagCount from #TemptabPerDayNoofBagsPerABD 
 select SUM(BagCount) as BagCount from #TemptabPerDayNoofBagsPerABD 
 select SUM(BagCount) as BagCount from #TemptabPerDayNoofBagsPerABD 
 select SUM(BagCount) as BagCount from #TemptabPerDayNoofBagsPerABD 

			declare @TempTbl TABLE
			(
			  Year varchar(10),
			  Month varchar(10),
			  Day varchar(10),
			  AvgSessionDuration float,
			  AvgBagCount int,
			  MinSessionDuration float,
			  MaxSessionDuration float,
			  ABDStations varchar(100),
			  NoOfBagsGroupID int,
			  BagCount int
			)

		INSERT INTO @TempTbl
		SELECT     DATEPART(YEAR, TransactionTimeNoOfBags.LocalTime) AS Year, 
		DATEPART(MONTH, TransactionTimeNoOfBags.LocalTime) 
							  AS Month, DATEPART(DAY, TransactionTimeNoOfBags.LocalTime) AS Day, 
							  AVG(TransactionTimeNoOfBags.SessionDuration) AS AvgSessionDuration, 
							  AVG(TransactionTimeNoOfBags.BagCount) as AvgBagCount, 
							  MIN(TransactionTimeNoOfBags.SessionDuration) AS MinSessionDuration, 
							  MAX(TransactionTimeNoOfBags.SessionDuration) AS MaxSessionDuration, 
							  dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea,AbdStation.AbdType) AS ABDStation, 
							  NumberOfBagsMap.NoOfBagsGroupID,
							  BagCount
		FROM          #TemptabPerDayNoofBagsPerABD as TransactionTimeNoOfBags INNER JOIN
							  AbdStation ON TransactionTimeNoOfBags.AbdStationID = AbdStation.ID INNER JOIN
							  Flight ON TransactionTimeNoOfBags.FlightID = Flight.ID INNER JOIN
							  NumberOfBagsMap ON TransactionTimeNoOfBags.BagCount = NumberOfBagsMap.NumberOfBags

        --WHERE DATEPART(YEAR, TransactionTimeNoOfBags.LocalTime) = '2018' and DATEPART(MONTH, TransactionTimeNoOfBags.LocalTime) = '3' and DATEPART(DAY, TransactionTimeNoOfBags.LocalTime) = '18'

		GROUP BY DATEPART(YEAR, TransactionTimeNoOfBags.LocalTime), DATEPART(MONTH, TransactionTimeNoOfBags.LocalTime), DATEPART(DAY, TransactionTimeNoOfBags.LocalTime), 
			AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea,AbdStation.AbdType,NumberOfBagsMap.NoOfBagsGroupID, BagCount
		ORDER BY 
		DATEPART(YEAR, TransactionTimeNoOfBags.LocalTime), DATEPART(MONTH, TransactionTimeNoOfBags.LocalTime), DATEPART(DAY, TransactionTimeNoOfBags.LocalTime),
		dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea,AbdStation.AbdType),NumberOfBagsMap.NoOfBagsGroupID

		SELECT * FROM @TempTbl

        SELECT  
		Year + '-' + Month + '-' + Day as YYYYMMDD,
			  AVG(AvgSessionDuration) as AvgSessionDuration,
			  SUM(AvgBagCount) as AvgBagCount,

			  AVG(MinSessionDuration) as MinSessionDuration,
			  AVG(MaxSessionDuration) as MaxSessionDuration,
			  (AVG(MinSessionDuration) + AVG(MaxSessionDuration))/2 as AVGSessionDuration,
			  ABDStations,
			  NoOfBagsGroupID, SUM(BagCount)  
		FROM @TempTbl
		WHERE ABDStations = 'T1_C_ABD_007' and AvgBagCount = 0
		GROUP BY Year + '-' + Month + '-' + Day, ABDStations, NoOfBagsGroupID
		ORDER BY ABDStations, NoOfBagsGroupID



        SELECT  
		      AvgBagCount,
			  AVG(AvgSessionDuration) as AvgSessionDuration,
			   SUM(BagCount)  ,
			  ABDStations 
			  
		FROM @TempTbl
		WHERE AvgBagCount = 0
		GROUP BY ABDStations, AvgBagCount 

        SELECT  
		      AvgBagCount,
			  AVG(AvgSessionDuration) as AvgSessionDuration,
			    SUM(BagCount)  ,
			  ABDStations 
			  
		FROM @TempTbl
		WHERE AvgBagCount = 1
		GROUP BY ABDStations, AvgBagCount 

        SELECT  
		      AvgBagCount,
			  AVG(AvgSessionDuration) as AvgSessionDuration,
			    SUM(BagCount)  ,
			  ABDStations 
			  
		FROM @TempTbl
		WHERE AvgBagCount = 2
		GROUP BY ABDStations, AvgBagCount 

        SELECT  
		      AvgBagCount,
			  AVG(AvgSessionDuration) as AvgSessionDuration,
			    SUM(BagCount)  ,
			  ABDStations 
			  
		FROM @TempTbl
		WHERE AvgBagCount = 3
		GROUP BY ABDStations, AvgBagCount 

        SELECT  
		       
			    SUM(BagCount)   
			  
		FROM @TempTbl
		 
		 