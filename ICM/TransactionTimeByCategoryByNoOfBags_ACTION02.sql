declare @FromDateTime DateTime = '2022-09-01 00:00:00 AM'
declare @ToDateTime DateTime = '2022-09-30 11:59:59 PM'
declare @Terminal nvarchar(10) = '%'
declare @Airline nvarchar(25) = '%'
declare @Area nvarchar(10) = '%'
declare @SubArea nvarchar(10) = '%'
declare @ABDStationIDs varchar(400) = '0'
declare @ABDStationNames varchar(4000) = 'Display All ABDs'


IF OBJECT_ID('tempdb..#CustomerSessionNoOfBags') is not null
DROP TABLE [dbo].[#CustomerSessionNoOfBags]

IF OBJECT_ID('tempdb..#CustomerSessionTimeOnEachScreen') is not null
DROP TABLE [dbo].[#CustomerSessionTimeOnEachScreen]		

IF OBJECT_ID('tempdb..#FinalTab') is not null
DROP TABLE [dbo].[#FinalTab]	


          Declare @Fromdate Datetime,
          @ToDate  Datetime, 
          @Terminal_Local nvarchar(10),
          @Area_Local nvarchar(10),
          @SubArea_Local nvarchar(10),
          @ABDStationIDs_local varchar(400),
          @ABDStationNames_local varchar(4000),
          @Airline_local nvarchar(400)
           
		   IF (@Airline = '0' OR @Airline ='%' )
		    SELECT @Airline = COALESCE(@Airline+',' ,'') + Airline 
			FROM (SELECT DISTINCT MarketingCarrier as Airline FROM Flight) t
          -- Donot direcly use input variables
          SELECT @Fromdate =@FromDateTime, 
           @ToDate = @ToDateTime,
           @Area_Local = @Area,
           @SubArea_Local = @SubArea,
           @ABDStationIDs_local = @ABDStationIDs,
           @ABDStationNames_local = @ABDStationNames,
           @Terminal_Local= @Terminal,
           @Airline_local = @Airline
            
            
    SELECT CustomerSession.ID,CustomerSession.LocalTime, COUNT(BagWeightUpdate.ID) AS NumberOfBags
    INTO #CustomerSessionNoOfBags
            FROM CustomerSession with (nolock)
            JOIN BagWeightUpdate with (nolock)
            ON CustomerSession.ID = BagWeightUpdate.CustomerSessionID
            JOIN AbdStation  with (nolock)
            ON AbdStation.ID = CustomerSession.AbdStationID
            JOIN Flight F On F.ID = CustomerSession.FlightID
            WHERE        (CustomerSession.LocalTime  BETWEEN @Fromdate AND @ToDate)
                AND (AbdStation.Terminal LIKE @Terminal_Local)
                AND (ISNULL(AbdStation.Area,'') LIKE @Area_Local )
                AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea_Local )
                AND  (F.MarketingCarrier IN (SELECT Items 
				FROM  dbo.Split(@Airline_local, ',')))
                AND (@ABDStationIDs_local = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs_local) > 0)
        GROUP BY CustomerSession.ID,CustomerSession.LocalTime
 
 
        Select * INTO #CustomerSessionTimeOnEachScreen  from CustomerSessionTimeOnEachScreen
        WHere CustomerSessionID IN ( Select ID From #CustomerSessionNoOfBags)
 -----------------------------------------------------
 --select * from #CustomerSessionNoOfBags

 --    SELECT CustomerSessionNoOfBags.ID,CustomerSessionNoOfBags.LocalTime, NumberOfBagsMap.NoOfBagsGroupID,
	--    SUM(MachineTime / 1000) AS SumOfMachineTime, 
 --       SUM(PaxTime / 1000) AS SumOfPaxTime, 
	--	SUM(DcsTime / 1000) AS SumOfDcsTime, 
	--	SUM(BhsTime / 1000) AS SumOfBhsTime,
	--	SUM(CsaTime/1000) as SumofCsaTime
 --       INTO #FinalTab
 --   FROM
 --       #CustomerSessionNoOfBags CustomerSessionNoOfBags
 --   JOIN NumberOfBagsMap with (nolock)
 --   ON CustomerSessionNoOfBags.NumberOfBags = NumberOfBagsMap.NumberOfBags
 --   JOIN #CustomerSessionTimeOnEachScreen CustomerSessionTimeOnEachScreen with (nolock)
 --   ON CustomerSessionNoOfBags.ID = CustomerSessionTimeOnEachScreen.CustomerSessionID
 --   GROUP BY CustomerSessionNoOfBags.ID,CustomerSessionNoOfBags.LocalTime, NumberOfBagsMap.NoOfBagsGroupID 


 -----------------------------------------------------
    SELECT CustomerSessionNoOfBags.ID,CustomerSessionNoOfBags.LocalTime, NumberOfBagsMap.NoOfBagsGroupID,SUM(MachineTime / 1000) AS SumOfMachineTime, 
        SUM(PaxTime / 1000) AS SumOfPaxTime, SUM(DcsTime / 1000) AS SumOfDcsTime, SUM(BhsTime / 1000) AS SumOfBhsTime,Sum(CsaTime/1000) as SumofCsaTime
        INTO #FinalTab
    FROM
        #CustomerSessionNoOfBags CustomerSessionNoOfBags
    JOIN NumberOfBagsMap with (nolock)
    ON CustomerSessionNoOfBags.NumberOfBags = NumberOfBagsMap.NumberOfBags
    JOIN #CustomerSessionTimeOnEachScreen CustomerSessionTimeOnEachScreen with (nolock)
    ON CustomerSessionNoOfBags.ID = CustomerSessionTimeOnEachScreen.CustomerSessionID
    GROUP BY CustomerSessionNoOfBags.ID,CustomerSessionNoOfBags.LocalTime, NumberOfBagsMap.NoOfBagsGroupID   
 ------------------------------ 
 --select * from #FinalTab 
 ------------------------------
    SELECT @ABDStationNames_local AS AbdStationNames, NoOfBagsGroupID, AVG(SumOfMachineTime) AS AvgMachineTime, AVG(SumOfPaxTime) AS AvgPaxTime, 
    AVG(SumOfDcsTime) AS AvgDcsTime, AVG(SumOfBhsTime) AS AvgBhsTime, AVG(isnull(SumofCsaTime, 0)) as AvgCsaTime
    FROM
    #FinalTab
    GROUP BY NoOfBagsGroupID
    ORDER BY NoOfBagsGroupID
