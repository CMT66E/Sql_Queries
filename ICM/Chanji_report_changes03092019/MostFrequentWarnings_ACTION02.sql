		declare @FromDateTime datetime = N'2019/01/01 00:00:00'
		declare @ToDateTime datetime = N'2019/01/31 23:59:59'
		declare @Terminal nvarchar(10) = N'%'
		declare @Area nvarchar(10) = N'%'
		declare @SubArea nvarchar(10) = N'%'
		declare @ABDStationIDs nvarchar(400) = N'0'
		declare @ABDStationNames nvarchar(4000) = N' Display All ABDs'
		declare @SessionEndReasonID int = 0
        declare @Airline nvarchar(100) = ',QF,'


	declare @tblFinal TABLE
    (
        ShortName nvarchar(100),
		NumberOfErrors int,
		ABDStations nvarchar(200),
		TotalBagsProcessed int,
		MarketingCarrier nvarchar(10)
    )
	--2. declare @TotalBags INT
	Declare @TotalBags INT

	IF (@Airline = '0' OR @Airline ='' )
    SET @Airline = '%'
	
	IF @Airline = '%'
	BEGIN
		 SELECT @TotalBags=ISNULL(SUM(BagCounts),0) From (
				SELECT     COUNT(BagWeightUpdate.LocalTime)as BagCounts
					FROM         BagWeightUpdate INNER JOIN
							  CustomerSession ON BagWeightUpdate.CustomerSessionID = CustomerSession.ID INNER JOIN
							  Flight ON CustomerSession.FlightID = Flight.ID INNER JOIN 
							  Bag ON BagWeightUpdate.BagID = Bag.ID INNER JOIN
							AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID
					WHERE     (BagWeightUpdate.LocalTime BETWEEN @FromDateTime AND @ToDateTime)
						AND (AbdStation.Terminal LIKE @Terminal )
						AND (ISNULL(AbdStation.Area,'') LIKE @Area )
						AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
						AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
					GROUP BY DATEPART(YEAR, BagWeightUpdate.LocalTime), DATEPART(MONTH, BagWeightUpdate.LocalTime), DATEPART(DAY, BagWeightUpdate.LocalTime)
		)Z

		insert into @tblFinal
		SELECT  FaultType.ShortName, COUNT(ABDErrorLog.ID) as NumberOfErrors,
			@ABDStationNames AS ABDStations,@TotalBags AS TotalBagsProcessed, '' as MarketingCarrier						  
		FROM         ABDErrorLog INNER JOIN
					  FaultType ON ABDErrorLog.FaultTypeID = FaultType.ID LEFT OUTER JOIN
					  AbdStation ON ABDErrorLog.AbdStationID = AbdStation.ID
		WHERE        (ABDErrorLog.LocalCreationTime  BETWEEN @FromDateTime AND @ToDateTime)
			AND (AbdStation.Terminal LIKE @Terminal )
			AND (ISNULL(AbdStation.Area,'') LIKE @Area )
			AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
			AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
		GROUP BY FaultType.ShortName
		ORDER BY COUNT(ABDErrorLog.ID) DESC

		select ShortName, NumberOfErrors, ABDStations, TotalBagsProcessed from @tblFinal
	END
	ELSE
	BEGIN
		declare @TempTbl TABLE
        (
          airline_code nvarchar(10) 
        )
		insert into @TempTbl
		select rtrim(ltrim(Items)) from  dbo.Split(@Airline, ',')
  
		 SELECT @TotalBags=ISNULL(SUM(BagCounts),0) From (
				SELECT     COUNT(BagWeightUpdate.LocalTime)as BagCounts
					FROM         BagWeightUpdate INNER JOIN
							  CustomerSession ON BagWeightUpdate.CustomerSessionID = CustomerSession.ID INNER JOIN
							  Flight ON CustomerSession.FlightID = Flight.ID INNER JOIN 
							  Bag ON BagWeightUpdate.BagID = Bag.ID INNER JOIN
							AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID
					WHERE     (BagWeightUpdate.LocalTime BETWEEN @FromDateTime AND @ToDateTime)
						AND (AbdStation.Terminal LIKE @Terminal )
						AND (ISNULL(AbdStation.Area,'') LIKE @Area )
						AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
						AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
					GROUP BY DATEPART(YEAR, BagWeightUpdate.LocalTime), DATEPART(MONTH, BagWeightUpdate.LocalTime), DATEPART(DAY, BagWeightUpdate.LocalTime)
		)Z


	    declare @TempStationIdTbl TABLE
        (
          ABDStationID int       
        )

		insert into @TempStationIdTbl
		SELECT  distinct  CustomerSession.AbdStationID
			FROM         BagWeightUpdate INNER JOIN
						CustomerSession ON BagWeightUpdate.CustomerSessionID = CustomerSession.ID INNER JOIN
						Flight ON CustomerSession.FlightID = Flight.ID INNER JOIN 
						Bag ON BagWeightUpdate.BagID = Bag.ID INNER JOIN
					AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID
			WHERE     (BagWeightUpdate.LocalTime BETWEEN @FromDateTime AND @ToDateTime)
				AND (AbdStation.Terminal LIKE @Terminal )
				AND (ISNULL(AbdStation.Area,'') LIKE @Area )
				AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
				AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
				AND Flight.MarketingCarrier IN (select airline_code from @TempTbl)

		SELECT  FaultType.ShortName, COUNT(ABDErrorLog.ID) as NumberOfErrors,
			@ABDStationNames AS ABDStations, @TotalBags AS TotalBagsProcessed 						  
		FROM         ABDErrorLog INNER JOIN
					  FaultType ON ABDErrorLog.FaultTypeID = FaultType.ID LEFT OUTER JOIN
					  AbdStation ON ABDErrorLog.AbdStationID = AbdStation.ID  
		WHERE  (ABDErrorLog.LocalCreationTime  BETWEEN @FromDateTime AND @ToDateTime)		   
			AND (AbdStation.Terminal LIKE @Terminal )
			AND (ISNULL(AbdStation.Area,'') LIKE @Area )
			AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
			AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)		
			AND ABDErrorLog.AbdStationID in (select ABDStationID from @TempStationIdTbl)
		GROUP BY FaultType.ShortName  
		ORDER BY COUNT(ABDErrorLog.ID) DESC
	END

	RETURN
