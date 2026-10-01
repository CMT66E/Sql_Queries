USE [ReportingDB_CDG]
GO

DECLARE @FromTime DATETIME, @ToTime DATETIME
SET @FromTime =  (Select Cast(convert (char(8),DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-1, 0),112) + ' 00:00:00.000' as datetime))

SET @ToTime =(Select cast(convert (char(8),DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1),112)+ ' 23:59:59.997' as datetime))

print '@FromTime = ' + cast(@FromTime as varchar)
print '@ToTime = ' + cast(@ToTime as varchar)


--EXEC TotalBagsPerHourPerDayPerABD_SSIS @FromTime, @ToTime,'AF'    --total 21115 records takes 00:10:31 -> after improved with creating non-clustered indexes 00:07:45 -> further improvement by remove GetAbdName function. It needs onlt 00:00:06 seconds

	--SELECT     DATEADD(dd, 0, DATEDIFF(dd, 0, BagWeightUpdate.LocalTime)) AS Date,
	--	(SELECT CASE WHEN ISNULL(AbdStation.Terminal,'') <> '' AND ISNULL(AbdStation.Area,'') <> '' AND ISNULL(AbdStation.SubArea,'') <> ''
	--						THEN (case when LEN(AbdStation.Terminal) > 1 then 'T' else 'T0' end) + AbdStation.Terminal + '_' + AbdStation.Area + '_' + AbdStation.SubArea + '_' + AbdStation.Identifier
	--					WHEN ISNULL(AbdStation.Terminal,'') <> '' AND ISNULL(AbdStation.Area,'') <> '' AND ISNULL(AbdStation.SubArea,'') = ''
	--						THEN (case when LEN(AbdStation.Terminal) > 1 then 'T' else 'T0' end) + AbdStation.Terminal + '_' + AbdStation.Area + '_' + AbdStation.Identifier
	--					WHEN ISNULL(AbdStation.Terminal,'') <> '' And (select Count(*) From abdstation Where  ABDType ='ABD' and Terminal <> AbdStation.Terminal) > 0
	--						THEN (case when LEN(AbdStation.Terminal) > 1 then 'T' else 'T0' end) + AbdStation.Terminal + '_'  + AbdStation.Identifier + '  '
	--					WHEN ISNULL(AbdStation.Terminal,'') ='' AND  ISNULL(AbdStation.Area,'') <> ''
	--						THEN AbdStation.Area+ '_'  + AbdStation.Identifier
	--					ELSE AbdStation.Identifier END)  AS AbdStationName,
		
	--	TimeSlotHourly.TimeSlotName, 
	--	COUNT(*) AS Bags
	--FROM         BagWeightUpdate INNER JOIN
	--					  AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID INNER JOIN
	--					  TimeSlotHourly ON BagWeightUpdate.TimeSlotHourlyID = TimeSlotHourly.ID INNER JOIN
	--					  CustomerSession ON BagWeightUpdate.CustomerSessionID = CustomerSession.ID INNER JOIN
	--					  Flight ON CustomerSession.FlightID = Flight.ID INNER JOIN 
	--					  Bag ON BagWeightUpdate.BagID = Bag.ID
	--WHERE     (BagWeightUpdate.LocalTime BETWEEN @FromTime AND @ToTime) AND Flight.MarketingCarrier='AF'
	--GROUP BY DATEADD(dd, 0, DATEDIFF(dd, 0, BagWeightUpdate.LocalTime)),AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea,TimeSlotHourly.ID,TimeSlotHourly.TimeSlotName
	--ORDER BY DATEADD(dd, 0, DATEDIFF(dd, 0, BagWeightUpdate.LocalTime)),
	--		(SELECT CASE WHEN ISNULL(AbdStation.Terminal,'') <> '' AND ISNULL(AbdStation.Area,'') <> '' AND ISNULL(AbdStation.SubArea,'') <> ''
	--						THEN (case when LEN(AbdStation.Terminal) > 1 then 'T' else 'T0' end) + AbdStation.Terminal + '_' + AbdStation.Area + '_' + AbdStation.SubArea + '_' + AbdStation.Identifier
	--					WHEN ISNULL(AbdStation.Terminal,'') <> '' AND ISNULL(AbdStation.Area,'') <> '' AND ISNULL(AbdStation.SubArea,'') = ''
	--						THEN (case when LEN(AbdStation.Terminal) > 1 then 'T' else 'T0' end) + AbdStation.Terminal + '_' + AbdStation.Area + '_' + AbdStation.Identifier
	--					WHEN ISNULL(AbdStation.Terminal,'') <> '' And (select Count(*) From abdstation Where  ABDType ='ABD' and Terminal <> AbdStation.Terminal) > 0
	--						THEN (case when LEN(AbdStation.Terminal) > 1 then 'T' else 'T0' end) + AbdStation.Terminal + '_'  + AbdStation.Identifier + '  '
	--					WHEN ISNULL(AbdStation.Terminal,'') ='' AND  ISNULL(AbdStation.Area,'') <> ''
	--						THEN AbdStation.Area+ '_'  + AbdStation.Identifier
	--					ELSE AbdStation.Identifier END), 
	--TimeSlotHourly.ID, TimeSlotHourly.TimeSlotName
---------------------------------------------------------------------------------------------------------------------------------
--EXEC TransactionTimeForNoOfBagsPerABD_SSISReportMonthly @FromTime,@ToTime,'AF' --It needs onlt 00:00:09 seconds
---------------------------------------------------------------------------------------------------------------------------------
--EXEC TotalBagsPerMinutesPerABDPerAirline @FromTime ,@ToTime,10,'AF' --total 7067 records takes 00:02:44 -> It needs only 5 seconds 00:00:05

 --       declare @Minutes  int = 5
	--	declare @Airline varchar(10) = 'AF'

	--	if @Minutes = 5
	--	BEGIN
	--		SELECT     
	--				(SELECT CASE WHEN ISNULL(AbdStation.Terminal,'') <> '' AND ISNULL(AbdStation.Area,'') <> '' AND ISNULL(AbdStation.SubArea,'') <> ''
	--						THEN (case when LEN(AbdStation.Terminal) > 1 then 'T' else 'T0' end) + AbdStation.Terminal + '_' + AbdStation.Area + '_' + AbdStation.SubArea + '_' + AbdStation.Identifier
	--					WHEN ISNULL(AbdStation.Terminal,'') <> '' AND ISNULL(AbdStation.Area,'') <> '' AND ISNULL(AbdStation.SubArea,'') = ''
	--						THEN (case when LEN(AbdStation.Terminal) > 1 then 'T' else 'T0' end) + AbdStation.Terminal + '_' + AbdStation.Area + '_' + AbdStation.Identifier
	--					WHEN ISNULL(AbdStation.Terminal,'') <> '' And (select Count(*) From abdstation Where  ABDType ='ABD' and Terminal <> AbdStation.Terminal) > 0
	--						THEN (case when LEN(AbdStation.Terminal) > 1 then 'T' else 'T0' end) + AbdStation.Terminal + '_'  + AbdStation.Identifier + '  '
	--					WHEN ISNULL(AbdStation.Terminal,'') ='' AND  ISNULL(AbdStation.Area,'') <> ''
	--						THEN AbdStation.Area+ '_'  + AbdStation.Identifier
	--					ELSE AbdStation.Identifier END)  AS AbdStationName,	
	--		TimeSlot5min.TimeSlotName, COUNT(*) AS Bags
	--		FROM         BagWeightUpdate INNER JOIN
	--							  AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID INNER JOIN
	--							  TimeSlot5min ON BagWeightUpdate.TimeSlot5minID = TimeSlot5min.ID INNER JOIN
	--							  CustomerSession ON BagWeightUpdate.CustomerSessionID = CustomerSession.ID INNER JOIN
	--							  Flight ON CustomerSession.FlightID = Flight.ID INNER JOIN 
	--					          Bag ON BagWeightUpdate.BagID = Bag.ID
								
	--		WHERE     (BagWeightUpdate.LocalTime BETWEEN @FromTime AND @ToTime) and Flight.MarketingCarrier = @Airline
	--		GROUP BY AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea,TimeSlot5min.ID,TimeSlot5min.TimeSlotName
	--		ORDER BY 
	--		  (SELECT CASE WHEN ISNULL(AbdStation.Terminal,'') <> '' AND ISNULL(AbdStation.Area,'') <> '' AND ISNULL(AbdStation.SubArea,'') <> ''
	--						THEN (case when LEN(AbdStation.Terminal) > 1 then 'T' else 'T0' end) + AbdStation.Terminal + '_' + AbdStation.Area + '_' + AbdStation.SubArea + '_' + AbdStation.Identifier
	--					WHEN ISNULL(AbdStation.Terminal,'') <> '' AND ISNULL(AbdStation.Area,'') <> '' AND ISNULL(AbdStation.SubArea,'') = ''
	--						THEN (case when LEN(AbdStation.Terminal) > 1 then 'T' else 'T0' end) + AbdStation.Terminal + '_' + AbdStation.Area + '_' + AbdStation.Identifier
	--					WHEN ISNULL(AbdStation.Terminal,'') <> '' And (select Count(*) From abdstation Where  ABDType ='ABD' and Terminal <> AbdStation.Terminal) > 0
	--						THEN (case when LEN(AbdStation.Terminal) > 1 then 'T' else 'T0' end) + AbdStation.Terminal + '_'  + AbdStation.Identifier + '  '
	--					WHEN ISNULL(AbdStation.Terminal,'') ='' AND  ISNULL(AbdStation.Area,'') <> ''
	--						THEN AbdStation.Area+ '_'  + AbdStation.Identifier
	--					ELSE AbdStation.Identifier END), 
	--		TimeSlot5min.ID, TimeSlot5min.TimeSlotName
	--	END

	--	if @Minutes = 10
	--	BEGIN
	--		SELECT     
	--				(SELECT CASE WHEN ISNULL(AbdStation.Terminal,'') <> '' AND ISNULL(AbdStation.Area,'') <> '' AND ISNULL(AbdStation.SubArea,'') <> ''
	--						THEN (case when LEN(AbdStation.Terminal) > 1 then 'T' else 'T0' end) + AbdStation.Terminal + '_' + AbdStation.Area + '_' + AbdStation.SubArea + '_' + AbdStation.Identifier
	--					WHEN ISNULL(AbdStation.Terminal,'') <> '' AND ISNULL(AbdStation.Area,'') <> '' AND ISNULL(AbdStation.SubArea,'') = ''
	--						THEN (case when LEN(AbdStation.Terminal) > 1 then 'T' else 'T0' end) + AbdStation.Terminal + '_' + AbdStation.Area + '_' + AbdStation.Identifier
	--					WHEN ISNULL(AbdStation.Terminal,'') <> '' And (select Count(*) From abdstation Where  ABDType ='ABD' and Terminal <> AbdStation.Terminal) > 0
	--						THEN (case when LEN(AbdStation.Terminal) > 1 then 'T' else 'T0' end) + AbdStation.Terminal + '_'  + AbdStation.Identifier + '  '
	--					WHEN ISNULL(AbdStation.Terminal,'') ='' AND  ISNULL(AbdStation.Area,'') <> ''
	--						THEN AbdStation.Area+ '_'  + AbdStation.Identifier
	--					ELSE AbdStation.Identifier END)  AS AbdStationName,	
	--		           TimeSlot10min.TimeSlotName, 
	--		            COUNT(*) AS Bags
	--		FROM         BagWeightUpdate INNER JOIN
	--							  AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID INNER JOIN
	--							  TimeSlot10min ON BagWeightUpdate.TimeSlot10minID = TimeSlot10min.ID INNER JOIN
	--							  CustomerSession ON BagWeightUpdate.CustomerSessionID = CustomerSession.ID INNER JOIN
	--							  Flight ON CustomerSession.FlightID = Flight.ID INNER JOIN 
	--					          Bag ON BagWeightUpdate.BagID = Bag.ID
								
	--		WHERE     (BagWeightUpdate.LocalTime BETWEEN @FromTime AND @ToTime) and Flight.MarketingCarrier = @Airline
	--		GROUP BY AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea,TimeSlot10min.ID,TimeSlot10min.TimeSlotName
	--		ORDER BY 
	--		  (SELECT CASE WHEN ISNULL(AbdStation.Terminal,'') <> '' AND ISNULL(AbdStation.Area,'') <> '' AND ISNULL(AbdStation.SubArea,'') <> ''
	--						THEN (case when LEN(AbdStation.Terminal) > 1 then 'T' else 'T0' end) + AbdStation.Terminal + '_' + AbdStation.Area + '_' + AbdStation.SubArea + '_' + AbdStation.Identifier
	--					WHEN ISNULL(AbdStation.Terminal,'') <> '' AND ISNULL(AbdStation.Area,'') <> '' AND ISNULL(AbdStation.SubArea,'') = ''
	--						THEN (case when LEN(AbdStation.Terminal) > 1 then 'T' else 'T0' end) + AbdStation.Terminal + '_' + AbdStation.Area + '_' + AbdStation.Identifier
	--					WHEN ISNULL(AbdStation.Terminal,'') <> '' And (select Count(*) From abdstation Where  ABDType ='ABD' and Terminal <> AbdStation.Terminal) > 0
	--						THEN (case when LEN(AbdStation.Terminal) > 1 then 'T' else 'T0' end) + AbdStation.Terminal + '_'  + AbdStation.Identifier + '  '
	--					WHEN ISNULL(AbdStation.Terminal,'') ='' AND  ISNULL(AbdStation.Area,'') <> ''
	--						THEN AbdStation.Area+ '_'  + AbdStation.Identifier
	--					ELSE AbdStation.Identifier END), 
	--		TimeSlot10min.ID, 
	--		TimeSlot10min.TimeSlotName
	--	END