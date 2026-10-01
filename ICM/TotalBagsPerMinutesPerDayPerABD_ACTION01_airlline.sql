--SP: TotalBagsPerMinutesPerDayPerABD action query

declare 	@FromDateTime DateTime ='2021-01-01'
declare 	@ToDateTime DateTime ='2021-01-31'
declare 	@Minutes int = 10       /* this can only be 5 or 10 munutes */

if @Minutes = 5
BEGIN
	SELECT     DATEADD(dd, 0, DATEDIFF(dd, 0, BagWeightUpdate.LocalTime)) AS Date, 
		dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal, AbdStation.Area, AbdStation.SubArea, AbdStation.AbdType) AS AbdStationName,TimeSlot5min.TimeSlotName, COUNT(*) AS Bags
	FROM         BagWeightUpdate INNER JOIN
							AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID INNER JOIN
							TimeSlot5min ON BagWeightUpdate.TimeSlot5minID = TimeSlot5min.ID INNER JOIN
							CustomerSession ON BagWeightUpdate.CustomerSessionID = CustomerSession.ID INNER JOIN
							Flight ON CustomerSession.FlightID = Flight.ID	INNER JOIN 
							Bag ON BagWeightUpdate.BagID = Bag.ID
								
	WHERE     (BagWeightUpdate.LocalTime BETWEEN @FromDateTime AND @ToDateTime) 
	GROUP BY DATEADD(dd, 0, DATEDIFF(dd, 0, BagWeightUpdate.LocalTime)),AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea, AbdStation.AbdType,TimeSlot5min.ID,TimeSlot5min.TimeSlotName
	ORDER BY DATEADD(dd, 0, DATEDIFF(dd, 0, BagWeightUpdate.LocalTime)), dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea, AbdStation.AbdType), TimeSlot5min.ID, TimeSlot5min.TimeSlotName
END

if @Minutes = 10
BEGIN
	SELECT     DATEADD(dd, 0, DATEDIFF(dd, 0, BagWeightUpdate.LocalTime)) AS Date,
		dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea, AbdStation.AbdType) AS AbdStationName, TimeSlot10Min.TimeSlotName, COUNT(*) AS Bags
	FROM         BagWeightUpdate INNER JOIN
							AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID INNER JOIN
							TimeSlot10Min ON BagWeightUpdate.TimeSlot10minID = TimeSlot10Min.ID INNER JOIN
							CustomerSession ON BagWeightUpdate.CustomerSessionID = CustomerSession.ID INNER JOIN
							Flight ON CustomerSession.FlightID = Flight.ID INNER JOIN 
							Bag ON BagWeightUpdate.BagID = Bag.ID
	WHERE     (BagWeightUpdate.LocalTime BETWEEN @FromDateTime AND @ToDateTime) 
	GROUP BY DATEADD(dd, 0, DATEDIFF(dd, 0, BagWeightUpdate.LocalTime)),AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea, AbdStation.AbdType, TimeSlot10Min.ID,TimeSlot10Min.TimeSlotName
	ORDER BY DATEADD(dd, 0, DATEDIFF(dd, 0, BagWeightUpdate.LocalTime)),dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea, AbdStation.AbdType), TimeSlot10Min.ID, TimeSlot10Min.TimeSlotName
END
