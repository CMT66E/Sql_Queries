		declare @FromDateTime datetime = N'2019/10/08 00:00:00'
		declare @ToDateTime datetime = N'2019/10/14 23:59:59'
		declare @Terminal nvarchar(10) = N'%'
		declare @Area nvarchar(10) = N'%'
		declare @SubArea nvarchar(10) = N'%'
		declare @ABDStationIDs nvarchar(400) = N'0'
		declare @ABDStationNames nvarchar(4000) = N'%'
		declare @SessionEndReasonID int = 0
        declare @Airline nvarchar(100) = ',EK,'

 
		declare @TempTbl TABLE
        (
          airline_code nvarchar(10) 
        )

		insert into @TempTbl
		select rtrim(ltrim(Items)) from  dbo.Split(@Airline, ',')
        
		Declare @TotalAirlineCount INT = 0

		if CHARINDEX(',', @Airline) > 0
		  select @TotalAirlineCount = count(*) from @TempTbl

	 print '@TotalAirlineCount =' + cast(@TotalAirlineCount as varchar)
	 select * from  @TempTbl

	If @TotalAirlineCount > 0  --airline filter is required
	begin
		SELECT  p.ShortName, ROUND(AVG(c.Duration) / 1000,2) as AvgDuration,COUNT(p.ID) AS NumberOfTimesDisplayed
			, @ABDStationNames AS ABDStations, ROUND(AVG(c.MachineTime) / 1000,2) as AvgMachineTime
			, ROUND(AVG(c.PaxTime) / 1000,2) as AvgPaxTime, ROUND(AVG(c.DcsTime) / 1000,2) as AvgDcsTime
			, ROUND(AVG(c.BhsTime) / 1000,2) as AvgBhsTime
			, ROUND(AVG(c.CsaTime ) / 1000,2) as AvgCSATime
		FROM         CustomerSessionTimeOnEachScreen c INNER JOIN
					  PageType p ON c.PageTypeID = p.ID INNER JOIN
					  CustomerSession cust ON c.CustomerSessionID = cust.ID INNER JOIN
					  Flight ON cust.FlightID = Flight.ID INNER JOIN 
					  ABDStation ON ABDStation.ID = cust.ABDStationID
		WHERE        (cust.LocalTime  BETWEEN @FromDateTime AND @ToDateTime)
			AND (AbdStation.Terminal LIKE @Terminal)
			AND (ISNULL(AbdStation.Area,'') LIKE @Area )
			AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
			AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
			AND Flight.MarketingCarrier IN (select airline_code from @TempTbl)
		GROUP BY p.ShortName
		ORDER BY COUNT(p.ID) DESC
	end
	else
		begin
		SELECT  p.ShortName, ROUND(AVG(c.Duration) / 1000,2) as AvgDuration,COUNT(p.ID) AS NumberOfTimesDisplayed
			, @ABDStationNames AS ABDStations, ROUND(AVG(c.MachineTime) / 1000,2) as AvgMachineTime
			, ROUND(AVG(c.PaxTime) / 1000,2) as AvgPaxTime, ROUND(AVG(c.DcsTime) / 1000,2) as AvgDcsTime
			, ROUND(AVG(c.BhsTime) / 1000,2) as AvgBhsTime
			, ROUND(AVG(c.CsaTime ) / 1000,2) as AvgCSATime
		FROM         CustomerSessionTimeOnEachScreen c INNER JOIN
					  PageType p ON c.PageTypeID = p.ID INNER JOIN
					  CustomerSession cust ON c.CustomerSessionID = cust.ID INNER JOIN
					  Flight ON cust.FlightID = Flight.ID INNER JOIN 
					  ABDStation ON ABDStation.ID = cust.ABDStationID
		WHERE        (cust.LocalTime  BETWEEN @FromDateTime AND @ToDateTime)
			AND (AbdStation.Terminal LIKE @Terminal)
			AND (ISNULL(AbdStation.Area,'') LIKE @Area )
			AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
			AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)			  
		GROUP BY p.ShortName
		ORDER BY COUNT(p.ID) DESC
	end