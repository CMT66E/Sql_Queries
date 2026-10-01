USE ReportingDB
GO
 
DECLARE @PatchVersion nvarchar(25) = '12.1i2'
 
-- Pre-rollback version check
DECLARE @CurrentVersion nvarchar(25)
EXEC dbo.GetCurrentVersion @CurrentVersion Output
 
Print 'Current DB version is: ' + @CurrentVersion
Print ''
 
If @CurrentVersion <> @PatchVersion Begin
    Print 'Rollback aborted because current database version is not ' + @PatchVersion + '.'
    --Return
    Raiserror ('Rollback aborted.',20, 10) With Log
End
 
 
Print 'BEGIN ROLLBACK'

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Split]'))
DROP FUNCTION [dbo].[Split]
GO

 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CustomerSessionsPerDay]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[CustomerSessionsPerDay]
GO
 
CREATE PROCEDURE [dbo].[CustomerSessionsPerDay]
	
	(
	@FromDateTime DateTime,
	@ToDateTime DateTime,
	@FlightNumber nvarchar(100),
	@BoardPass nvarchar(25),
	@Airline nvarchar(25),
	@Terminal nvarchar(10),
	@Area nvarchar(10),
	@SubArea nvarchar(10),
	@ABDStationIDs varchar(400),
	@ABDStationNames varchar(4000)
	)
		WITH RECOMPILE
AS

SELECT     DATEPART(YEAR, CustomerSession.LocalTime) AS Year, DATEPART(MONTH, CustomerSession.LocalTime) AS Month, 
	DATEPART(DAY, CustomerSession.LocalTime) AS Day, COUNT(CustomerSession.LocalTime) AS CustomerSessions, @ABDStationNames AS ABDStations
FROM         CustomerSession INNER JOIN
            Flight ON CustomerSession.FlightID = Flight.ID INNER JOIN
            ABDStation ON ABDStation.ID = CustomerSession.ABDStationID
WHERE     CustomerSession.LocalTime BETWEEN @FromDateTime AND @ToDateTime
	AND (CAST(Flight.FlightNumber as nvarchar(100)) LIKE @FlightNumber ) 
	AND (CustomerSession.CustomerLookupType LIKE @BoardPass ) 
	AND (Flight.MarketingCarrier LIKE @Airline )
	AND (AbdStation.Terminal LIKE @Terminal )
	AND (ISNULL(AbdStation.Area,'') LIKE @Area )
	AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
	AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
GROUP BY DATEPART(YEAR, CustomerSession.LocalTime), DATEPART(MONTH, CustomerSession.LocalTime), DATEPART(DAY, CustomerSession.LocalTime)
ORDER BY DATEPART(YEAR, CustomerSession.LocalTime), DATEPART(MONTH, CustomerSession.LocalTime), DATEPART(DAY, CustomerSession.LocalTime)
	
	
RETURN

GO 
 
Print 'Rolledback  SP CustomerSessionsPerDay'
GO
 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CustomerSessionsPerHour]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[CustomerSessionsPerHour]
GO

 
CREATE PROCEDURE [dbo].[CustomerSessionsPerHour]
(
	@FromDateTime DateTime,
	@ToDateTime DateTime,
	@FlightNumber nvarchar(100),
	@BoardPass nvarchar(25),
	@Airline nvarchar(25),
	@Terminal nvarchar(10),
	@Area nvarchar(10),
	@SubArea nvarchar(10),
	@ABDStationIDs varchar(400),
	@ABDStationNames varchar(4000)
	)
		WITH RECOMPILE
AS


SELECT     TimeSlotHourly.TimeSlotName, COUNT(*) AS CustomerSessions, @ABDStationNames AS ABDStations
FROM         CustomerSession INNER JOIN
              TimeSlotHourly ON CustomerSession.TimeSlotHourlyID = TimeSlotHourly.ID INNER JOIN
              Flight ON CustomerSession.FlightID = Flight.ID INNER JOIN
            ABDStation ON ABDStation.ID = CustomerSession.ABDStationID
WHERE     (CustomerSession.LocalTime BETWEEN @FromDateTime AND @ToDateTime) 
	AND (CAST(Flight.FlightNumber as nvarchar(100)) LIKE @FlightNumber) 
	AND (CustomerSession.CustomerLookupType LIKE @BoardPass) 
	AND (Flight.MarketingCarrier LIKE @Airline)
	AND (AbdStation.Terminal LIKE @Terminal)
	AND (ISNULL(AbdStation.Area,'') LIKE @Area )
	AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
	AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
GROUP BY TimeSlotHourly.ID,TimeSlotHourly.TimeSlotName
ORDER BY TimeSlotHourly.ID, TimeSlotHourly.TimeSlotName
RETURN

GO



 
Print 'Rolledback  SP CustomerSessionsPerHour'
GO
 
 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CustomerSessionsPerMinutes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[CustomerSessionsPerMinutes]
GO
 
CREATE PROCEDURE [dbo].[CustomerSessionsPerMinutes]
(
	@FromDateTime DateTime,
	@ToDateTime DateTime,
	@Minutes int, /* this can only be 5 or 10 munutes */
    @FlightNumber nvarchar(100),
	@BoardPass nvarchar(25),
	@Airline nvarchar(25),
	@Terminal nvarchar(10),
	@Area nvarchar(10),
	@SubArea nvarchar(10),
	@ABDStationIDs varchar(400),
	@ABDStationNames varchar(4000)
	)
	WITH RECOMPILE
AS



		if @Minutes = 5
		BEGIN
			SELECT     TimeSlot5min.TimeSlotName, COUNT(*) AS CustomerSessions, @ABDStationNames AS ABDStations
			FROM         CustomerSession INNER JOIN
					  TimeSlot5min ON CustomerSession.TimeSlot5minID = TimeSlot5min.ID INNER JOIN
					  Flight ON CustomerSession.FlightID = Flight.ID INNER JOIN
                      ABDStation ON ABDStation.ID = CustomerSession.ABDStationID
			WHERE     (CustomerSession.LocalTime BETWEEN @FromDateTime AND @ToDateTime) 
				AND (CAST(Flight.FlightNumber as nvarchar(100)) LIKE @FlightNumber) 
				AND (CustomerSession.CustomerLookupType like @BoardPass) 
				AND (Flight.MarketingCarrier LIKE @Airline)
				AND (AbdStation.Terminal LIKE @Terminal )
				AND (ISNULL(AbdStation.Area,'') LIKE @Area )
				AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
				AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
			GROUP BY TimeSlot5min.ID, TimeSlot5min.TimeSlotName
			ORDER BY TimeSlot5min.ID, TimeSlot5min.TimeSlotName
		END

		if @Minutes = 10
		BEGIN
			SELECT     TimeSlot10Min.TimeSlotName, COUNT(*) AS CustomerSessions, @ABDStationNames AS ABDStations
			FROM         CustomerSession INNER JOIN
					  TimeSlot10Min ON CustomerSession.TimeSlot10minID = TimeSlot10Min.ID INNER JOIN
					  Flight ON CustomerSession.FlightID = Flight.ID INNER JOIN
                      ABDStation ON ABDStation.ID = CustomerSession.ABDStationID
			WHERE     (CustomerSession.LocalTime BETWEEN @FromDateTime AND @ToDateTime) 
				AND (CAST(Flight.FlightNumber as nvarchar(100)) LIKE @FlightNumber) 
				AND (CustomerSession.CustomerLookupType LIKE @BoardPass) 
				AND (Flight.MarketingCarrier LIKE @Airline)
				AND (AbdStation.Terminal LIKE @Terminal )
				AND (ISNULL(AbdStation.Area,'') LIKE @Area )
				AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
				AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
			GROUP BY TimeSlot10Min.ID, TimeSlot10Min.TimeSlotName
			ORDER BY TimeSlot10Min.ID, TimeSlot10Min.TimeSlotName
		END

	RETURN


Print 'Rolledback  SP CustomerSessionsPerMinutes'
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MostFrequentSessionEnd]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MostFrequentSessionEnd]

GO
 
CREATE PROCEDURE [dbo].[MostFrequentSessionEnd]
(
	@FromDateTime DateTime,
	@ToDateTime DateTime,
	@Terminal nvarchar(10),
	@Area nvarchar(10),
	@SubArea nvarchar(10),
	@ABDStationIDs varchar(400),
	@ABDStationNames varchar(4000)
	)
		WITH RECOMPILE
AS

	SELECT c.SessionEndReasonID,s.ShortName, COUNT(c.ID) AS NumberOfSession,
		@ABDStationNames AS ABDStations 
	FROM CustomerSession c
	JOIN SessionEndReason s
	ON s.ID = c.SessionEndReasonID
	LEFT JOIN ABDStation a
	ON a.ID = c.ABDStationID
	WHERE (c.LocalTime  BETWEEN @FromDateTime AND @ToDateTime)
		AND (a.Terminal LIKE @Terminal )
		AND (ISNULL(a.Area,'') LIKE @Area )
		AND (ISNULL(a.SubArea,'') LIKE @SubArea )
		AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(a.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
	GROUP BY c.SessionEndReasonID,s.ShortName
	ORDER BY COUNT(c.ID) DESC

GO
Print 'Rolledback  SP MostFrequentSessionEnd'
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MostFrequentSessionEndPerReasonPerScreen]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MostFrequentSessionEndPerReasonPerScreen]
GO
CREATE PROCEDURE [dbo].[MostFrequentSessionEndPerReasonPerScreen]
(
	@FromDateTime DateTime,
	@ToDateTime DateTime,
	@SessionEndReasonID int,
	@Terminal nvarchar(10),
	@Area nvarchar(10),
	@SubArea nvarchar(10),
	@ABDStationIDs varchar(400),
	@ABDStationNames varchar(4000)
	)
		WITH RECOMPILE
AS

	SELECT c.SessionEndReasonID,s.ShortName AS ActionName,c.SessionEndPageID,ISNULL(p.ShortName,' ') AS ScreenName, COUNT(c.ID) AS NumberOfSessions,
		@ABDStationNames AS ABDStations
	FROM CustomerSession c
	JOIN SessionEndReason s
	ON s.ID = c.SessionEndReasonID
	LEFT JOIN PageType p
	ON p.ID = c.SessionEndPageID
	LEFT JOIN AbdStation a
	ON a.ID = c.ABDStationID
	WHERE (c.LocalTime  BETWEEN @FromDateTime AND @ToDateTime)
		AND (@SessionEndReasonID = 0 OR c.SessionEndREasonID = @SessionEndReasonID )
		AND (a.Terminal LIKE @Terminal )
		AND (ISNULL(a.Area,'') LIKE @Area )
		AND (ISNULL(a.SubArea,'') LIKE @SubArea )
		AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(a.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
		AND C.SessionEndPageID <> -1 
	GROUP BY c.SessionEndReasonID,s.ShortName,c.SessionEndPageID,p.ShortName
	ORDER BY COUNT(c.ID) DESC,p.ShortName

GO

Print 'Rolledback  SP MostFrequentSessionEndPerReasonPerScreen'
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TotalBagsPerABD]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TotalBagsPerABD]
GO
CREATE PROCEDURE [dbo].[TotalBagsPerABD]
(
	@FromDateTime DateTime,
	@ToDateTime DateTime,
	@FlightNumber nvarchar(100),
    @BoardPass nvarchar(25),
    @BagTagType nvarchar(25),
    @Airline nvarchar(25),
    @Terminal nvarchar(10),
	@Area nvarchar(10),
	@SubArea nvarchar(10),
	@ABDStationIDs varchar(400),
	@ABDStationNames varchar(4000)
	)
		WITH RECOMPILE
AS

	Select* into #temp from CustomerSession where LocalTime BETWEEN @FromDateTime AND @ToDateTime

	SELECT     AbdStation.ID AS ABDStationID, dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea) AS AbdStationName, 
		SUM(BagWeightUpdate.Weight) AS TotalWeight, COUNT(BagWeightUpdate.LocalTime) AS Bags
	FROM         BagWeightUpdate INNER JOIN
						  AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID INNER JOIN
						  #temp CustomerSession ON BagWeightUpdate.CustomerSessionID = CustomerSession.ID INNER JOIN
						  Flight ON CustomerSession.FlightID = Flight.ID INNER JOIN Bag ON BagWeightUpdate.BagID = Bag.ID
	WHERE     (CustomerSession.LocalTime BETWEEN @FromDateTime AND @ToDateTime) 
		AND (CAST(Flight.FlightNumber as nvarchar(100)) like @FlightNumber) 
		AND (CustomerSession.CustomerLookupType like @BoardPass) 
		AND (Bag.BagTagType like @BagTagType)
		AND (Flight.MarketingCarrier like @Airline)
	    AND (AbdStation.Terminal LIKE @Terminal )
		AND (ISNULL(AbdStation.Area,'') LIKE @Area )
		AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
		AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
	    
	GROUP BY AbdStation.ID,AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea
	ORDER BY dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea)


	RETURN
GO
Print 'Rolledback  SP TotalBagsPerABD'
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TotalBagsPerDay]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TotalBagsPerDay]
GO
CREATE PROCEDURE [dbo].[TotalBagsPerDay]
(
	@FromDateTime DateTime,
	@ToDateTime DateTime,
	@FlightNumber nvarchar(100),
    @BoardPass nvarchar(25),
    @BagTagType nvarchar(25),
    @Airline nvarchar(25),
    @Terminal nvarchar(10),
	@Area nvarchar(10),
	@SubArea nvarchar(10),
	@ABDStationIDs varchar(400),
	@ABDStationNames varchar(4000)
	)
		WITH RECOMPILE
AS


	SELECT     DATEPART(YEAR, BagWeightUpdate.LocalTime) AS Year, DATEPART(MONTH, BagWeightUpdate.LocalTime) AS Month, DATEPART(DAY, BagWeightUpdate.LocalTime) AS Day, 
		@ABDStationNames AS ABDStations, SUM(BagWeightUpdate.Weight) AS TotalWeight, COUNT(BagWeightUpdate.LocalTime) AS Bags
	FROM         BagWeightUpdate INNER JOIN
			  CustomerSession ON BagWeightUpdate.CustomerSessionID = CustomerSession.ID INNER JOIN
			  Flight ON CustomerSession.FlightID = Flight.ID INNER JOIN 
			  Bag ON BagWeightUpdate.BagID = Bag.ID INNER JOIN
			AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID
	WHERE     (BagWeightUpdate.LocalTime BETWEEN @FromDateTime AND @ToDateTime) 
		AND (CAST(Flight.FlightNumber as nvarchar(100)) like @FlightNumber) 
		AND (CustomerSession.CustomerLookupType like @BoardPass) 
		AND (Bag.BagTagType like @BagTagType)
		AND (Flight.MarketingCarrier like @Airline)
		AND (AbdStation.Terminal LIKE @Terminal )
		AND (ISNULL(AbdStation.Area,'') LIKE @Area )
		AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
		AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
	GROUP BY DATEPART(YEAR, BagWeightUpdate.LocalTime), DATEPART(MONTH, BagWeightUpdate.LocalTime), DATEPART(DAY, BagWeightUpdate.LocalTime)
	ORDER BY DATEPART(YEAR, BagWeightUpdate.LocalTime), DATEPART(MONTH, BagWeightUpdate.LocalTime), DATEPART(DAY, BagWeightUpdate.LocalTime)
	
	
	RETURN
GO
Print 'Rolledback  SP TotalBagsPerDay'
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TotalBagsPerHour]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TotalBagsPerHour]
GO
CREATE PROCEDURE [dbo].[TotalBagsPerHour]
(
	@FromDateTime DateTime,
	@ToDateTime DateTime,
	@FlightNumber nvarchar(100),
    @BoardPass nvarchar(25),
    @BagTagType nvarchar(25),
    @Airline nvarchar(25),
    @Terminal nvarchar(10),
	@Area nvarchar(10),
	@SubArea nvarchar(10),
	@ABDStationIDs varchar(400),
	@ABDStationNames varchar(4000)
	)
		WITH RECOMPILE
AS



	SELECT     TimeSlotHourly.TimeSlotName, @ABDStationNames AS ABDStations, COUNT(*) AS Bags
	FROM         BagWeightUpdate INNER JOIN
			  TimeSlotHourly ON BagWeightUpdate.TimeSlotHourlyID = TimeSlotHourly.ID INNER JOIN
			  CustomerSession ON BagWeightUpdate.CustomerSessionID = CustomerSession.ID INNER JOIN
			  Flight ON CustomerSession.FlightID = Flight.ID INNER JOIN 
			  Bag ON BagWeightUpdate.BagID = Bag.ID INNER JOIN
            ABDStation ON ABDStation.ID = BagWeightUpdate.ABDStationID
	WHERE     (BagWeightUpdate.LocalTime BETWEEN @FromDateTime AND @ToDateTime) 
		AND (CAST(Flight.FlightNumber as nvarchar(100)) like @FlightNumber) 
		AND (CustomerSession.CustomerLookupType like @BoardPass) 
		AND (Bag.BagTagType like @BagTagType)
		AND (Flight.MarketingCarrier like @Airline)
		AND (AbdStation.Terminal LIKE @Terminal )
		AND (ISNULL(AbdStation.Area,'') LIKE @Area )
		AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
		AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
	GROUP BY TimeSlotHourly.ID,TimeSlotHourly.TimeSlotName
	ORDER BY TimeSlotHourly.ID, TimeSlotHourly.TimeSlotName



RETURN
GO
Print 'Rolledback  SP TotalBagsPerHour'
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TotalBagsPerMinutes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TotalBagsPerMinutes]
GO
CREATE PROCEDURE [dbo].[TotalBagsPerMinutes]
(
	@FromDateTime DateTime,
	@ToDateTime DateTime,
	@Minutes int, /* this can only be 5 or 10 munutes */
	@FlightNumber nvarchar(100),
    @BoardPass nvarchar(25),
    @BagTagType nvarchar(25),
    @Airline nvarchar(25),
    @Terminal nvarchar(10),
	@Area nvarchar(10),
	@SubArea nvarchar(10),
	@ABDStationIDs varchar(400),
	@ABDStationNames varchar(4000)
	)
		WITH RECOMPILE
AS



		if @Minutes = 5
		BEGIN
			SELECT     TimeSlot5min.TimeSlotName, @ABDStationNames AS ABDStations, COUNT(*) AS Bags
			FROM         BagWeightUpdate INNER JOIN
								  TimeSlot5min ON BagWeightUpdate.TimeSlot5minID = TimeSlot5min.ID INNER JOIN
								  CustomerSession ON BagWeightUpdate.CustomerSessionID = CustomerSession.ID INNER JOIN
								  Flight ON CustomerSession.FlightID = Flight.ID INNER JOIN 
								  Bag ON BagWeightUpdate.BagID = Bag.ID INNER JOIN
									ABDStation ON ABDStation.ID = BagWeightUpdate.ABDStationID
			WHERE     (BagWeightUpdate.LocalTime BETWEEN @FromDateTime AND @ToDateTime) 
				AND (CAST(Flight.FlightNumber as nvarchar(100)) like @FlightNumber) 
				AND (CustomerSession.CustomerLookupType like @BoardPass) 
				AND (Bag.BagTagType like @BagTagType)
				AND (Flight.MarketingCarrier like @Airline)
				AND (AbdStation.Terminal LIKE @Terminal )
				AND (ISNULL(AbdStation.Area,'') LIKE @Area )
				AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
				AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
			GROUP BY TimeSlot5min.ID,TimeSlot5min.TimeSlotName
			ORDER BY TimeSlot5min.ID, TimeSlot5min.TimeSlotName
		END

		if @Minutes = 10
		BEGIN
			SELECT     TimeSlot10Min.TimeSlotName, @ABDStationNames AS ABDStations, COUNT(*) AS Bags
			FROM         BagWeightUpdate INNER JOIN
					  TimeSlot10Min ON BagWeightUpdate.TimeSlot10minID = TimeSlot10Min.ID INNER JOIN
					  CustomerSession ON BagWeightUpdate.CustomerSessionID = CustomerSession.ID INNER JOIN
					  Flight ON CustomerSession.FlightID = Flight.ID INNER JOIN 
					  Bag ON BagWeightUpdate.BagID = Bag.ID INNER JOIN
						ABDStation ON ABDStation.ID = BagWeightUpdate.ABDStationID
			WHERE     (BagWeightUpdate.LocalTime BETWEEN @FromDateTime AND @ToDateTime) 
					AND (CAST(Flight.FlightNumber as nvarchar(100)) like @FlightNumber) 
					AND (CustomerSession.CustomerLookupType like @BoardPass) 
					AND (Bag.BagTagType like @BagTagType)
					AND (Flight.MarketingCarrier like @Airline)
					AND (AbdStation.Terminal LIKE @Terminal )
					AND (ISNULL(AbdStation.Area,'') LIKE @Area )
					AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
					AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
			GROUP BY TimeSlot10Min.ID,TimeSlot10Min.TimeSlotName
			ORDER BY TimeSlot10Min.ID, TimeSlot10Min.TimeSlotName
		END

	RETURN
GO
Print 'Rolledback  SP TotalBagsPerMinutes'
GO
 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransactionTimeByCategoryByNoOfBags]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TransactionTimeByCategoryByNoOfBags]
GO
CREATE PROC [dbo].[TransactionTimeByCategoryByNoOfBags]

	@FromDateTime DateTime,
	@ToDateTime DateTime,
	@Terminal nvarchar(10),
	@Area nvarchar(10),
	@SubArea nvarchar(10),
	@ABDStationIDs varchar(400),
	@ABDStationNames varchar(4000)

AS

		  Declare @Fromdate Datetime,
	      @ToDate  Datetime, 
	      @Terminal_Local nvarchar(10),
	      @Area_Local nvarchar(10),
		  @SubArea_Local nvarchar(10),
		  @ABDStationIDs_local varchar(400),
		  @ABDStationNames_local varchar(4000)
		  
		  -- Donot direcly use input variables
		  SELECT @Fromdate =@FromDateTime, 
		   @ToDate = @ToDateTime,
		   @Area_Local = @Area,
		   @SubArea_Local = @SubArea,
		   @ABDStationIDs_local = @ABDStationIDs,
		   @ABDStationNames_local = @ABDStationNames,
		   @Terminal_Local= @Terminal
		   
		   
    SELECT CustomerSession.ID,CustomerSession.LocalTime, COUNT(BagWeightUpdate.ID) AS NumberOfBags
    INTO #CustomerSessionNoOfBags
			FROM CustomerSession with (nolock)
			JOIN BagWeightUpdate with (nolock)
			ON CustomerSession.ID = BagWeightUpdate.CustomerSessionID
			JOIN AbdStation  with (nolock)
			ON AbdStation.ID = CustomerSession.AbdStationID
			WHERE        (CustomerSession.LocalTime  BETWEEN @Fromdate AND @ToDate)
				AND (AbdStation.Terminal LIKE @Terminal_Local)
				AND (ISNULL(AbdStation.Area,'') LIKE @Area_Local )
				AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea_Local )
				AND (@ABDStationIDs_local = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs_local) > 0)
		GROUP BY CustomerSession.ID,CustomerSession.LocalTime


		Select * INTO #CustomerSessionTimeOnEachScreen  from CustomerSessionTimeOnEachScreen
		WHere CustomerSessionID IN ( Select ID From #CustomerSessionNoOfBags)

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
	 
	SELECT @ABDStationNames_local AS AbdStationNames, NoOfBagsGroupID, AVG(SumOfMachineTime) AS AvgMachineTime, AVG(SumOfPaxTime) AS AvgPaxTime, 
	AVG(SumOfDcsTime) AS AvgDcsTime, AVG(SumOfBhsTime) AS AvgBhsTime,AVG(SumofCsaTime) as AvgCsaTime
	FROM
	#FinalTab
	GROUP BY NoOfBagsGroupID
	ORDER BY NoOfBagsGroupID


GO
Print 'Rolledback  SP [TransactionTimeByCategoryByNoOfBags'
GO



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransactionTimeForNoOfBagsPerABD]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TransactionTimeForNoOfBagsPerABD]
GO
CREATE PROCEDURE [dbo].[TransactionTimeForNoOfBagsPerABD]
	
	(
	@FromDateTime DateTime,
	@ToDateTime DateTime,
	@FlightNumber nvarchar(100),
    @BoardPass nvarchar(25),
    @Airline nvarchar(25),
	@Terminal nvarchar(10),
	@Area nvarchar(10),
	@SubArea nvarchar(10),
	@ABDStationIDs varchar(400),
	@ABDStationNames varchar(4000)
	)
WITH RECOMPILE
AS
 Select * into #tempCusSession  from CustomerSession Where LocalTime BETWEEN @FromDateTime AND @ToDateTime
 
 SELECT     CustomerSession.ID, CustomerSession.CustomerID, CustomerSession.AbdStationID, CustomerSession.CustomerLookupType, CustomerSession.PNR, 
                      CustomerSession.UtcCreationTime, CustomerSession.FlightID, CustomerSession.TimeSlot5minID, CustomerSession.TimeSlot10minID, 
                      CustomerSession.TimeSlotHourlyID, CustomerSession.DayOfTheWeekID, CustomerSession.LocalTime, CustomerSession.UtcCompletionTime, 
                      CustomerSession.SessionDuration, COUNT(BagWeightUpdate.BagID) AS BagCount
INTO  #tempTab
FROM        #tempCusSession CustomerSession LEFT OUTER JOIN
                      BagWeightUpdate ON CustomerSession.ID = BagWeightUpdate.CustomerSessionID --AND BagWeightUpdate.UtcTime BETWEEN CustomerSession.UtcCreationTime AND CustomerSession.UtcCompletionTime

GROUP BY CustomerSession.ID, CustomerSession.CustomerID, CustomerSession.AbdStationID, CustomerSession.CustomerLookupType, CustomerSession.PNR, 
                      CustomerSession.UtcCreationTime, CustomerSession.FlightID, CustomerSession.TimeSlot5minID, CustomerSession.TimeSlot10minID, 
                      CustomerSession.TimeSlotHourlyID, CustomerSession.DayOfTheWeekID, CustomerSession.LocalTime, CustomerSession.UtcCompletionTime, 
                      CustomerSession.SessionDuration   
                      
           
SELECT     dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea) AS AbdStationName, NumberOfBagsMap.NoOfBagsGroupID, 
      AVG(TransactionTimeNoOfBags.BagCount) AS AvgBagCount, AVG(TransactionTimeNoOfBags.SessionDuration) AS AvgSessionDuration, 
      MIN(TransactionTimeNoOfBags.SessionDuration) AS MinSessionDuration, MAX(TransactionTimeNoOfBags.SessionDuration) AS MaxSessionDuration,
      COUNT(TransactionTimeNoOfBags.ID) AS NumberOfCustomerTransactions, SUM(TransactionTimeNoOfBags.BagCount) AS NumberOfBags
FROM         #tempTab AS TransactionTimeNoOfBags INNER JOIN
                      AbdStation ON TransactionTimeNoOfBags.AbdStationID = AbdStation.ID AND AbdStation.AbdType = 'ABD' INNER JOIN
                      Flight ON TransactionTimeNoOfBags.FlightID = Flight.ID INNER JOIN
                      NumberOfBagsMap ON TransactionTimeNoOfBags.BagCount = NumberOfBagsMap.NumberOfBags
WHERE     (CAST(Flight.FlightNumber AS nvarchar(100)) LIKE @FlightNumber) 
	AND (TransactionTimeNoOfBags.CustomerLookupType LIKE @BoardPass) 
	AND (Flight.MarketingCarrier LIKE @Airline)
	AND (AbdStation.Terminal LIKE @Terminal )
	AND (ISNULL(AbdStation.Area,'') LIKE @Area )
	AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
	AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
GROUP BY AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea, NumberOfBagsMap.NoOfBagsGroupID
ORDER BY dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea), NumberOfBagsMap.NoOfBagsGroupID
	
RETURN
GO
Print 'Rolledback  SP TransactionTimeForNoOfBagsPerABD'
GO



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransactionTimePerDay]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TransactionTimePerDay]
GO
CREATE PROCEDURE [dbo].[TransactionTimePerDay]
	
	(
	@FromDateTime DateTime,
	@ToDateTime DateTime,
	@FlightNumber nvarchar(100),
    @BoardPass nvarchar(25),
    @BagTagType nvarchar(25),
    @Airline nvarchar(25),
    @Terminal nvarchar(10),
	@Area nvarchar(10),
	@SubArea nvarchar(10),
	@ABDStationIDs varchar(400),
	@ABDStationNames varchar(4000)
	)
WITH RECOMPILE
AS

SELECT     Bag.ID, Bag.BagTagType, tempt.ID AS CustomerSessionID, tempt.AbdStationID, tempt.CustomerLookupType, tempt.FlightID, tempt.CustomerID, tempt.PNR, 
                      bagt.TimeSlot5minID, bagt.TimeSlot10minID, bagt.TimeSlotHourlyID, bagt.DayOfTheWeekID, tempt.LocalTime, tempt.SessionDuration, tempt.BagCount, 
                      tempt.TransactionTime, tempt.UtcCreationTime, tempt.UtcCompletionTime
INTO  #tempTab
FROM         BagWeightUpdate AS bagt INNER JOIN
                          (SELECT     CustomerSession.ID, CustomerSession.CustomerID, CustomerSession.AbdStationID, CustomerSession.CustomerLookupType, CustomerSession.PNR, 
                      CustomerSession.UtcCreationTime, CustomerSession.FlightID, CustomerSession.TimeSlot5minID, CustomerSession.TimeSlot10minID, 
                      CustomerSession.TimeSlotHourlyID, CustomerSession.DayOfTheWeekID, CustomerSession.LocalTime, CustomerSession.UtcCompletionTime, 
                      CustomerSession.SessionDuration, COUNT(BagWeightUpdate.BagID) AS BagCount, CustomerSession.SessionDuration / COUNT(BagWeightUpdate.BagID) 
                      AS TransactionTime
FROM         CustomerSession INNER JOIN
                      BagWeightUpdate ON CustomerSession.ID = BagWeightUpdate.CustomerSessionID AND BagWeightUpdate.UtcTime BETWEEN CustomerSession.UtcCreationTime AND CustomerSession.UtcCompletionTime
WHERE CustomerSession.LocalTime BETWEEN @FromDateTime AND @ToDateTime
GROUP BY CustomerSession.ID, CustomerSession.CustomerID, CustomerSession.AbdStationID, CustomerSession.CustomerLookupType, CustomerSession.PNR, 
                      CustomerSession.UtcCreationTime, CustomerSession.FlightID, CustomerSession.TimeSlot5minID, CustomerSession.TimeSlot10minID, 
                      CustomerSession.TimeSlotHourlyID, CustomerSession.DayOfTheWeekID, CustomerSession.LocalTime, CustomerSession.UtcCompletionTime, 
                      CustomerSession.SessionDuration
) AS tempt ON bagt.CustomerSessionID = tempt.ID INNER JOIN
 Bag ON bagt.BagID = Bag.ID
 
 
SELECT     DATEPART(YEAR, TransactionTime.LocalTime) AS Year, DATEPART(MONTH, TransactionTime.LocalTime) 
                      AS Month, DATEPART(DAY, TransactionTime.LocalTime) AS Day, AVG(TransactionTime.TransactionTime) AS AvgTransactionTime, 
                      MIN(TransactionTime.TransactionTime) AS MinTransactionTime, MAX(TransactionTime.TransactionTime) AS MaxTransactionTime, @ABDStationNames AS ABDStations
FROM         #tempTab AS TransactionTime INNER JOIN
            Flight ON TransactionTime.FlightID = Flight.ID INNER JOIN
            ABDStation ON ABDStation.ID = TransactionTime.ABDStationID
WHERE     (TransactionTime.CustomerLookupType LIKE @BoardPass) 
	AND (TransactionTime.BagTagType LIKE @BagTagType) 
	AND (CAST(Flight.FlightNumber AS nvarchar(100)) LIKE @FlightNumber) 
	AND (Flight.MarketingCarrier LIKE @Airline)
	AND (AbdStation.Terminal LIKE @Terminal )
	AND (ISNULL(AbdStation.Area,'') LIKE @Area )
	AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
	AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
GROUP BY DATEPART(YEAR, TransactionTime.LocalTime), DATEPART(MONTH, TransactionTime.LocalTime), DATEPART(DAY, TransactionTime.LocalTime)
ORDER BY DATEPART(YEAR, TransactionTime.LocalTime), DATEPART(MONTH, TransactionTime.LocalTime), DATEPART(DAY, TransactionTime.LocalTime)

GO
Print 'Rolledback  SP TransactionTimePerDay'
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransactionTimePerHour]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TransactionTimePerHour]
GO
CREATE PROCEDURE [dbo].[TransactionTimePerHour]
(
	@FromDateTime DateTime,
	@ToDateTime DateTime,
	@FlightNumber nvarchar(100),
    @BoardPass nvarchar(25),
    @BagTagType nvarchar(25),
    @Airline nvarchar(25),
    @Terminal nvarchar(10),
	@Area nvarchar(10),
	@SubArea nvarchar(10),
	@ABDStationIDs varchar(400),
	@ABDStationNames varchar(4000)
	)
WITH RECOMPILE
AS

SELECT     Bag.ID, Bag.BagTagType, tempt.ID AS CustomerSessionID, tempt.AbdStationID, tempt.CustomerLookupType, tempt.FlightID, tempt.CustomerID, tempt.PNR, 
                      bagt.TimeSlot5minID, bagt.TimeSlot10minID, bagt.TimeSlotHourlyID, bagt.DayOfTheWeekID, bagt.LocalTime, tempt.SessionDuration, tempt.BagCount, 
                      tempt.TransactionTime, tempt.UtcCreationTime, tempt.UtcCompletionTime
INTO  #tempTab
FROM         BagWeightUpdate AS bagt INNER JOIN
                          (SELECT     CustomerSession.ID, CustomerSession.CustomerID, CustomerSession.AbdStationID, CustomerSession.CustomerLookupType, CustomerSession.PNR, 
                      CustomerSession.UtcCreationTime, CustomerSession.FlightID, CustomerSession.TimeSlot5minID, CustomerSession.TimeSlot10minID, 
                      CustomerSession.TimeSlotHourlyID, CustomerSession.DayOfTheWeekID, CustomerSession.LocalTime, CustomerSession.UtcCompletionTime, 
                      CustomerSession.SessionDuration, COUNT(BagWeightUpdate.BagID) AS BagCount, CustomerSession.SessionDuration / COUNT(BagWeightUpdate.BagID) 
                      AS TransactionTime
FROM         CustomerSession INNER JOIN
                      BagWeightUpdate ON CustomerSession.ID = BagWeightUpdate.CustomerSessionID AND BagWeightUpdate.UtcTime BETWEEN CustomerSession.UtcCreationTime AND CustomerSession.UtcCompletionTime
WHERE CustomerSession.LocalTime BETWEEN @FromDateTime AND @ToDateTime
GROUP BY CustomerSession.ID, CustomerSession.CustomerID, CustomerSession.AbdStationID, CustomerSession.CustomerLookupType, CustomerSession.PNR, 
                      CustomerSession.UtcCreationTime, CustomerSession.FlightID, CustomerSession.TimeSlot5minID, CustomerSession.TimeSlot10minID, 
                      CustomerSession.TimeSlotHourlyID, CustomerSession.DayOfTheWeekID, CustomerSession.LocalTime, CustomerSession.UtcCompletionTime, 
                      CustomerSession.SessionDuration
) AS tempt ON bagt.CustomerSessionID = tempt.ID INNER JOIN
 Bag ON bagt.BagID = Bag.ID
 
 
SELECT     TimeSlotHourly.TimeSlotName, AVG(TransactionTime.TransactionTime) AS AvgTransactionTime, MIN(TransactionTime.TransactionTime) AS MinTransactionTime, 
                      MAX(TransactionTime.TransactionTime) AS MaxTransactionTime, @ABDStationNames AS ABDStations
FROM         #tempTab AS TransactionTime INNER JOIN
                      TimeSlotHourly ON TransactionTime.TimeSlotHourlyID = TimeSlotHourly.ID INNER JOIN
                      Flight ON TransactionTime.FlightID = Flight.ID INNER JOIN
                      ABDStation ON ABDStation.ID = TransactionTime.ABDStationID
WHERE     (CAST(Flight.FlightNumber AS nvarchar(100)) LIKE @FlightNumber) 
	AND (TransactionTime.CustomerLookupType LIKE @BoardPass) 
	AND (TransactionTime.BagTagType LIKE @BagTagType) 
	AND (Flight.MarketingCarrier LIKE @Airline)
	AND (AbdStation.Terminal LIKE @Terminal )
	AND (ISNULL(AbdStation.Area,'') LIKE @Area )
	AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
	AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
GROUP BY TimeSlotHourly.ID,TimeSlotHourly.TimeSlotName
ORDER BY TimeSlotHourly.ID, TimeSlotHourly.TimeSlotName

RETURN

GO
Print 'Rolledback  SP TransactionTimePerHour'
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransactionTimePerHourPerServer]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TransactionTimePerHourPerServer]
GO
CREATE PROCEDURE [dbo].[TransactionTimePerHourPerServer]
(
	@FromDateTime DateTime,
	@ToDateTime DateTime,
	@FlightNumber nvarchar(100),
    @BoardPass nvarchar(25),
    @BagTagType nvarchar(25),
    @Airline nvarchar(25),
    @Terminal nvarchar(10),
	@Area nvarchar(10),
	@SubArea nvarchar(10),
	@ABDStationIDs varchar(400),
	@ABDStationNames varchar(4000),
	@BdsServertype INT
	)
AS
BEGIN
		
			SELECT     Bag.ID, Bag.BagTagType, tempt.ID AS CustomerSessionID, tempt.AbdStationID, tempt.CustomerLookupType, tempt.FlightID, tempt.CustomerID, tempt.PNR, 
								  bagt.TimeSlot5minID, bagt.TimeSlot10minID, bagt.TimeSlotHourlyID, bagt.DayOfTheWeekID, bagt.LocalTime, tempt.SessionDuration, tempt.BagCount, 
								  tempt.TransactionTime, tempt.UtcCreationTime, tempt.UtcCompletionTime
			INTO  #tempTab
			FROM         BagWeightUpdate AS bagt INNER JOIN
									  (SELECT     CustomerSession.ID, CustomerSession.CustomerID, CustomerSession.AbdStationID, CustomerSession.CustomerLookupType, CustomerSession.PNR, 
								  CustomerSession.UtcCreationTime, CustomerSession.FlightID, CustomerSession.TimeSlot5minID, CustomerSession.TimeSlot10minID, 
								  CustomerSession.TimeSlotHourlyID, CustomerSession.DayOfTheWeekID, CustomerSession.LocalTime, CustomerSession.UtcCompletionTime, 
								  CustomerSession.SessionDuration, COUNT(BagWeightUpdate.BagID) AS BagCount, CustomerSession.SessionDuration / COUNT(BagWeightUpdate.BagID) 
								  AS TransactionTime
			FROM         CustomerSession INNER JOIN
								  BagWeightUpdate ON CustomerSession.ID = BagWeightUpdate.CustomerSessionID AND BagWeightUpdate.UtcTime BETWEEN CustomerSession.UtcCreationTime AND CustomerSession.UtcCompletionTime
			WHERE CustomerSession.LocalTime BETWEEN @FromDateTime AND @ToDateTime
			GROUP BY CustomerSession.ID, CustomerSession.CustomerID, CustomerSession.AbdStationID, CustomerSession.CustomerLookupType, CustomerSession.PNR, 
								  CustomerSession.UtcCreationTime, CustomerSession.FlightID, CustomerSession.TimeSlot5minID, CustomerSession.TimeSlot10minID, 
								  CustomerSession.TimeSlotHourlyID, CustomerSession.DayOfTheWeekID, CustomerSession.LocalTime, CustomerSession.UtcCompletionTime, 
								  CustomerSession.SessionDuration
			) AS tempt ON bagt.CustomerSessionID = tempt.ID INNER JOIN
			 Bag ON bagt.BagID = Bag.ID
 
 
		 If @BdsServertype = 0
		 BEGIN
		 
				SELECT     TimeSlotHourly.TimeSlotName, AVG(TransactionTime.TransactionTime) AS AvgTransactionTime, MIN(TransactionTime.TransactionTime) AS MinTransactionTime, 
									  MAX(TransactionTime.TransactionTime) AS MaxTransactionTime, @ABDStationNames AS ABDStations
				FROM         #tempTab AS TransactionTime INNER JOIN
									  TimeSlotHourly ON TransactionTime.TimeSlotHourlyID = TimeSlotHourly.ID INNER JOIN
									  Flight ON TransactionTime.FlightID = Flight.ID INNER JOIN
									  ABDStation ON ABDStation.ID = TransactionTime.ABDStationID
				WHERE     (CAST(Flight.FlightNumber AS nvarchar(100)) LIKE @FlightNumber) 
					AND (TransactionTime.CustomerLookupType LIKE @BoardPass) 
					AND (TransactionTime.BagTagType LIKE @BagTagType) 
					AND (Flight.MarketingCarrier LIKE @Airline)
					AND (AbdStation.Terminal LIKE @Terminal )
					AND (ISNULL(AbdStation.Area,'') LIKE @Area )
					AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
					AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
					AND ABDStation.ID In ( Select AbdStationID from BdsAbdMapping)
				GROUP BY TimeSlotHourly.ID,TimeSlotHourly.TimeSlotName
				ORDER BY TimeSlotHourly.ID, TimeSlotHourly.TimeSlotName
		END
		ELSE
		BEGIN
			SELECT     TimeSlotHourly.TimeSlotName, AVG(TransactionTime.TransactionTime) AS AvgTransactionTime, MIN(TransactionTime.TransactionTime) AS MinTransactionTime, 
									  MAX(TransactionTime.TransactionTime) AS MaxTransactionTime, @ABDStationNames AS ABDStations
				FROM         #tempTab AS TransactionTime INNER JOIN
									  TimeSlotHourly ON TransactionTime.TimeSlotHourlyID = TimeSlotHourly.ID INNER JOIN
									  Flight ON TransactionTime.FlightID = Flight.ID INNER JOIN
									  ABDStation ON ABDStation.ID = TransactionTime.ABDStationID
				WHERE     (CAST(Flight.FlightNumber AS nvarchar(100)) LIKE @FlightNumber) 
					AND (TransactionTime.CustomerLookupType LIKE @BoardPass) 
					AND (TransactionTime.BagTagType LIKE @BagTagType) 
					AND (Flight.MarketingCarrier LIKE @Airline)
					AND (AbdStation.Terminal LIKE @Terminal )
					AND (ISNULL(AbdStation.Area,'') LIKE @Area )
					AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
					AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
					AND ABDStation.ID In ( Select AbdStationID from BdsAbdMapping where BdsServerID =@BdsServertype)
				GROUP BY TimeSlotHourly.ID,TimeSlotHourly.TimeSlotName
				ORDER BY TimeSlotHourly.ID, TimeSlotHourly.TimeSlotName
		END
END

GO
Print 'Rolledback  SP TransactionTimePerHourPerServer'
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransactionTimePerMinutes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TransactionTimePerMinutes]
GO

CREATE PROCEDURE [dbo].[TransactionTimePerMinutes]
(
	@FromDateTime DateTime,
	@ToDateTime DateTime,
	@Minutes int, /* this can only be 5 or 10 munutes */
	@FlightNumber nvarchar(100),
    @BoardPass nvarchar(25),
    @BagTagType nvarchar(25),
    @Airline nvarchar(25),
    @Terminal nvarchar(10),
	@Area nvarchar(10),
	@SubArea nvarchar(10),
	@ABDStationIDs varchar(400),
	@ABDStationNames varchar(4000)
	)
WITH RECOMPILE
AS

SELECT     Bag.ID, Bag.BagTagType, tempt.ID AS CustomerSessionID, tempt.AbdStationID, tempt.CustomerLookupType, tempt.FlightID, tempt.CustomerID, tempt.PNR, 
                      bagt.TimeSlot5minID, bagt.TimeSlot10minID, bagt.TimeSlotHourlyID, bagt.DayOfTheWeekID, bagt.LocalTime, tempt.SessionDuration, tempt.BagCount, 
                      tempt.TransactionTime, tempt.UtcCreationTime, tempt.UtcCompletionTime
INTO  #tempTab
FROM         BagWeightUpdate AS bagt INNER JOIN
                          (SELECT     CustomerSession.ID, CustomerSession.CustomerID, CustomerSession.AbdStationID, CustomerSession.CustomerLookupType, CustomerSession.PNR, 
                      CustomerSession.UtcCreationTime, CustomerSession.FlightID, CustomerSession.TimeSlot5minID, CustomerSession.TimeSlot10minID, 
                      CustomerSession.TimeSlotHourlyID, CustomerSession.DayOfTheWeekID, CustomerSession.LocalTime, CustomerSession.UtcCompletionTime, 
                      CustomerSession.SessionDuration, COUNT(BagWeightUpdate.BagID) AS BagCount, CustomerSession.SessionDuration / COUNT(BagWeightUpdate.BagID) 
                      AS TransactionTime
FROM         CustomerSession INNER JOIN
                      BagWeightUpdate ON CustomerSession.ID = BagWeightUpdate.CustomerSessionID AND BagWeightUpdate.UtcTime BETWEEN CustomerSession.UtcCreationTime AND CustomerSession.UtcCompletionTime
WHERE CustomerSession.LocalTime BETWEEN @FromDateTime AND @ToDateTime
GROUP BY CustomerSession.ID, CustomerSession.CustomerID, CustomerSession.AbdStationID, CustomerSession.CustomerLookupType, CustomerSession.PNR, 
                      CustomerSession.UtcCreationTime, CustomerSession.FlightID, CustomerSession.TimeSlot5minID, CustomerSession.TimeSlot10minID, 
                      CustomerSession.TimeSlotHourlyID, CustomerSession.DayOfTheWeekID, CustomerSession.LocalTime, CustomerSession.UtcCompletionTime, 
                      CustomerSession.SessionDuration
) AS tempt ON bagt.CustomerSessionID = tempt.ID INNER JOIN
 Bag ON bagt.BagID = Bag.ID
 
IF @Minutes = 5
BEGIN
SELECT     TimeSlot5min.TimeSlotName, AVG(TransactionTime.TransactionTime) AS AvgTransactionTime, MIN(TransactionTime.TransactionTime) AS MinTransactionTime, 
                      MAX(TransactionTime.TransactionTime) AS MaxTransactionTime, @ABDStationNames AS ABDStations
FROM         #tempTab AS TransactionTime INNER JOIN
                      TimeSlot5min ON TransactionTime.TimeSlot5minID = TimeSlot5min.ID INNER JOIN
                      Flight ON TransactionTime.FlightID = Flight.ID INNER JOIN
                      ABDStation ON ABDStation.ID = TransactionTime.ABDStationID
WHERE     (CAST(Flight.FlightNumber AS nvarchar(100)) LIKE @FlightNumber) 
	AND (TransactionTime.CustomerLookupType LIKE @BoardPass) 
	AND (TransactionTime.BagTagType LIKE @BagTagType) 
	AND (Flight.MarketingCarrier LIKE @Airline)
	AND (AbdStation.Terminal LIKE @Terminal )
	AND (ISNULL(AbdStation.Area,'') LIKE @Area )
	AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
	AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
GROUP BY TimeSlot5min.ID,TimeSlot5min.TimeSlotName
ORDER BY TimeSlot5min.ID, TimeSlot5min.TimeSlotName
END

ELSE IF @Minutes = 10
BEGIN
SELECT     TimeSlot10Min.TimeSlotName, AVG(TransactionTime.TransactionTime) AS AvgTransactionTime, MIN(TransactionTime.TransactionTime) AS MinTransactionTime, 
                      MAX(TransactionTime.TransactionTime) AS MaxTransactionTime, @ABDStationNames AS ABDStations
FROM         #tempTab AS TransactionTime INNER JOIN
                      TimeSlot10Min ON TransactionTime.TimeSlot10minID = TimeSlot10Min.ID INNER JOIN
                      Flight ON TransactionTime.FlightID = Flight.ID INNER JOIN
                      ABDStation ON ABDStation.ID = TransactionTime.ABDStationID
WHERE     (CAST(Flight.FlightNumber AS nvarchar(100)) LIKE @FlightNumber)
	AND (TransactionTime.CustomerLookupType LIKE @BoardPass) 
	AND (TransactionTime.BagTagType LIKE @BagTagType) 
	AND (Flight.MarketingCarrier LIKE @Airline)
	AND (AbdStation.Terminal LIKE @Terminal )
	AND (ISNULL(AbdStation.Area,'') LIKE @Area )
	AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
	AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
GROUP BY TimeSlot10Min.ID,TimeSlot10Min.TimeSlotName
ORDER BY TimeSlot10Min.ID, TimeSlot10Min.TimeSlotName
END

GO
Print 'Rolledback  SP TransactionTimePerMinutes'
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransactionTimePerMunites]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TransactionTimePerMunites]
GO

CREATE PROCEDURE [dbo].[TransactionTimePerMunites]
(
	@pFromDateTime DateTime,
	@pToDateTime DateTime,
	@pMinutes int, /* this can only be 5 or 10 munutes */
	@pFlightNumber nvarchar(100),
    @pBoardPass nvarchar(25),
    @pBagTagType nvarchar(25),
    @pAirline nvarchar(25),
    @Terminal nvarchar(10),
	@Zone nvarchar(10)
	)
WITH RECOMPILE
AS
DECLARE
	@FromDateTime DateTime,
	@ToDateTime DateTime,
	@Minutes int, /* this can only be 5 or 10 munutes */
	@FlightNumber nvarchar(100),
    @BoardPass nvarchar(25),
    @BagTagType nvarchar(25),
    @Airline nvarchar(25)

SET @FromDateTime = @pFromDateTime
SET @ToDateTime = @pToDateTime
SET @Minutes = @pMinutes
SET @FlightNumber = @pFlightNumber
SET @BoardPass = @pBoardPass
SET @BagTagType = @pBagTagType
SET @Airline = @pAirline


SELECT     Bag.ID, Bag.BagTagType, tempt.ID AS CustomerSessionID, tempt.AbdStationID, tempt.CustomerLookupType, tempt.FlightID, tempt.CustomerID, tempt.PNR, 
                      bagt.TimeSlot5minID, bagt.TimeSlot10minID, bagt.TimeSlotHourlyID, bagt.DayOfTheWeekID, bagt.LocalTime, tempt.SessionDuration, tempt.BagCount, 
                      tempt.TransactionTime, tempt.UtcCreationTime, tempt.UtcCompletionTime
INTO  #tempTab
FROM         BagWeightUpdate AS bagt INNER JOIN
                          (SELECT     CustomerSession.ID, CustomerSession.CustomerID, CustomerSession.AbdStationID, CustomerSession.CustomerLookupType, CustomerSession.PNR, 
                      CustomerSession.UtcCreationTime, CustomerSession.FlightID, CustomerSession.TimeSlot5minID, CustomerSession.TimeSlot10minID, 
                      CustomerSession.TimeSlotHourlyID, CustomerSession.DayOfTheWeekID, CustomerSession.LocalTime, CustomerSession.UtcCompletionTime, 
                      CustomerSession.SessionDuration, COUNT(BagWeightUpdate.BagID) AS BagCount, CustomerSession.SessionDuration / COUNT(BagWeightUpdate.BagID) 
                      AS TransactionTime
FROM         CustomerSession INNER JOIN
                      BagWeightUpdate ON CustomerSession.ID = BagWeightUpdate.CustomerSessionID AND BagWeightUpdate.UtcTime BETWEEN CustomerSession.UtcCreationTime AND CustomerSession.UtcCompletionTime
WHERE CustomerSession.LocalTime BETWEEN @FromDateTime AND @ToDateTime
GROUP BY CustomerSession.ID, CustomerSession.CustomerID, CustomerSession.AbdStationID, CustomerSession.CustomerLookupType, CustomerSession.PNR, 
                      CustomerSession.UtcCreationTime, CustomerSession.FlightID, CustomerSession.TimeSlot5minID, CustomerSession.TimeSlot10minID, 
                      CustomerSession.TimeSlotHourlyID, CustomerSession.DayOfTheWeekID, CustomerSession.LocalTime, CustomerSession.UtcCompletionTime, 
                      CustomerSession.SessionDuration
) AS tempt ON bagt.CustomerSessionID = tempt.ID INNER JOIN
Bag ON bagt.BagID = Bag.ID

IF @MINUTES = 5
BEGIN
SELECT     TimeSlot5min.TimeSlotName, AVG(TransactionTime.TransactionTime) AS AvgTransactionTime, MIN(TransactionTime.TransactionTime) AS MinTransactionTime, 
                      MAX(TransactionTime.TransactionTime) AS MaxTransactionTime, 'All' AS ABDStation
FROM        #tempTab AS TransactionTime INNER JOIN
                      TimeSlot5min ON TransactionTime.TimeSlot5minID = TimeSlot5min.ID INNER JOIN
                      Flight ON TransactionTime.FlightID = Flight.ID INNER JOIN
                      ABDStation ON ABDStation.ID = TransactionTime.ABDStationID
WHERE     (CAST(Flight.FlightNumber AS nvarchar(100)) LIKE @FlightNumber) 
	AND (TransactionTime.CustomerLookupType LIKE @BoardPass) 
	AND (TransactionTime.BagTagType LIKE @BagTagType) 
	AND (Flight.MarketingCarrier LIKE @Airline)
	AND (AbdStation.Terminal = @Terminal OR @Terminal = '%')
	AND (AbdStation.Identifier LIKE @Zone + '%' OR @Zone = '%')
GROUP BY TimeSlot5min.ID, TimeSlot5min.TimeSlotName
ORDER BY TimeSlot5min.ID, TimeSlot5min.TimeSlotName
END

IF @MINUTES = 10
BEGIN
SELECT     TimeSlot10Min.TimeSlotName, AVG(TransactionTime.TransactionTime) AS AvgTransactionTime, MIN(TransactionTime.TransactionTime) AS MinTransactionTime, 
                      MAX(TransactionTime.TransactionTime) AS MaxTransactionTime, 'All' AS ABDStation
FROM         #tempTab AS TransactionTime INNER JOIN
                      TimeSlot10Min ON TransactionTime.TimeSlot10minID = TimeSlot10Min.ID INNER JOIN
                      Flight ON TransactionTime.FlightID = Flight.ID INNER JOIN
                      ABDStation ON ABDStation.ID = TransactionTime.ABDStationID
WHERE     (CAST(Flight.FlightNumber AS nvarchar(100)) LIKE @FlightNumber)
	AND (TransactionTime.CustomerLookupType LIKE @BoardPass) 
	AND (TransactionTime.BagTagType LIKE @BagTagType) 
	AND (Flight.MarketingCarrier LIKE @Airline)
	AND (AbdStation.Terminal = @Terminal OR @Terminal = '%')
	AND (AbdStation.Identifier LIKE @Zone + '%' OR @Zone = '%')
GROUP BY TimeSlot10Min.ID, TimeSlot10Min.TimeSlotName
ORDER BY TimeSlot10Min.ID, TimeSlot10Min.TimeSlotName
END

GO


GO
Print 'Rolledback  SP TransactionTimePerMunites'
GO


Print 'END ROLLBACK'
 
 
Declare @PatchVersion nvarchar(25) = '12.1i2'
 
-- Post-rollback removal of patch version deployment record
Exec dbo.RemoveVersionDeployment @PatchVersion
Print 'Removed DB version deployment for: ' + @PatchVersion
GO