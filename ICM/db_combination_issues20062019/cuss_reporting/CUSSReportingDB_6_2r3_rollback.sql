USE [CUSSReportingDB]
GO
 
DECLARE @PatchVersion nvarchar(25) = '6.2r3'
 
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
 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ApplicationSessionUsagePerABD]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ApplicationSessionUsagePerABD]
GO
CREATE PROCEDURE [dbo].[ApplicationSessionUsagePerABD]
(
	@FromDateTime DateTime,
	@ToDateTime DateTime,
	@Airline nvarchar(50),
	@CUSSApplicationID int
	)
		WITH RECOMPILE
AS


SELECT     dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal, AbdStation.Area,AbdStation.SubArea) AS AbdStationName, 
	ApplicationSessionUsage.AirlineID, Airlines.Airline,  
	ApplicationSessionUsage.CussApplicationID, CussApplications.Application AS CussApplication,
	SUM(ApplicationSessionUsage.MinutesInState) AS MinutesInState
FROM         ApplicationSessionUsage INNER JOIN
                      Airlines ON ApplicationSessionUsage.AirlineID = Airlines.ID INNER JOIN
                      AbdStation ON ApplicationSessionUsage.ABDStationID = AbdStation.ID INNER JOIN 
                      CussApplications ON ApplicationSessionUsage.CussApplicationID = CussApplications.CussApplicationID
WHERE     (ApplicationSessionUsage.Date BETWEEN @FromDateTime AND @ToDateTime) 
	AND (Airlines.Airline LIKE @Airline)
	AND (@CUSSApplicationID = 0 OR ApplicationSessionUsage.CussApplicationID = @CUSSApplicationID)
GROUP BY AbdStation.Identifier, AbdStation.Terminal, AbdStation.Area,AbdStation.SubArea, Airlines.Airline,ApplicationSessionUsage.AirlineID, ApplicationSessionUsage.CussApplicationID, CussApplications.Application
ORDER BY dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal, AbdStation.Area,AbdStation.SubArea), Airlines.Airline, CussApplications.Application
GO
PRINT 'Dropped and Reverse Procedure ApplicationSessionUsagePerABD'
 
 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransactionTimeForNoOfBagsPerABD]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TransactionTimeForNoOfBagsPerABD]
GO
CREATE PROCEDURE [dbo].[TransactionTimeForNoOfBagsPerABD]
	
	(
	@FromDateTime DateTime,
	@ToDateTime DateTime,
	@FlightNumber nvarchar(100),
    @BoardPass nvarchar(25),
    @Airline nvarchar(25)
	)
WITH RECOMPILE
AS
BEGIN
IF OBJECT_ID('tempdb..##tempCusSession') is not null
		DROP TABLE [dbo].[##tempCusSession]

IF OBJECT_ID('tempdb..##temp') is not null
		DROP TABLE [dbo].[##temp]		
Select * into ##tempCusSession  from CustomerSession Where LocalTime BETWEEN @FromDateTime AND @ToDateTime

SELECT     CustomerSession.ID, CustomerSession.CustomerID, CustomerSession.AbdStationID, CustomerSession.CustomerLookupType, CustomerSession.PNR, 
                      CustomerSession.UtcCreationTime, CustomerSession.FlightID, CustomerSession.TimeSlot5minID, CustomerSession.TimeSlot10minID, 
                      CustomerSession.TimeSlotHourlyID, CustomerSession.DayOfTheWeekID, CustomerSession.LocalTime, CustomerSession.UtcCompletionTime, 
                      CustomerSession.SessionDuration, COUNT(BagWeightUpdate.BagID) AS BagCount
                      INTO ##temp
FROM       ##tempCusSession  CustomerSession LEFT OUTER JOIN
                      BagWeightUpdate ON CustomerSession.ID = BagWeightUpdate.CustomerSessionID
GROUP BY CustomerSession.ID, CustomerSession.CustomerID, CustomerSession.AbdStationID, CustomerSession.CustomerLookupType, CustomerSession.PNR, 
                      CustomerSession.UtcCreationTime, CustomerSession.FlightID, CustomerSession.TimeSlot5minID, CustomerSession.TimeSlot10minID, 
                      CustomerSession.TimeSlotHourlyID, CustomerSession.DayOfTheWeekID, CustomerSession.LocalTime, CustomerSession.UtcCompletionTime, 
                      CustomerSession.SessionDuration


SELECT     dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea) AS AbdStationName, NumberOfBagsMap.NoOfBagsGroupID, 
      AVG(TransactionTimeNoOfBags.BagCount) AS AvgBagCount, AVG(TransactionTimeNoOfBags.SessionDuration) AS AvgSessionDuration, 
      MIN(TransactionTimeNoOfBags.SessionDuration) AS MinSessionDuration, MAX(TransactionTimeNoOfBags.SessionDuration) AS MaxSessionDuration,
	  COUNT(TransactionTimeNoOfBags.ID) AS NumberOfCustomerTransactions, SUM(TransactionTimeNoOfBags.BagCount) AS NumberOfBags
FROM        ##temp  AS TransactionTimeNoOfBags INNER JOIN
                      AbdStation ON TransactionTimeNoOfBags.AbdStationID = AbdStation.ID INNER JOIN
                      Flight ON TransactionTimeNoOfBags.FlightID = Flight.ID INNER JOIN
                      NumberOfBagsMap ON TransactionTimeNoOfBags.BagCount = NumberOfBagsMap.NumberOfBags
WHERE     (CAST(Flight.FlightNumber AS nvarchar(100)) LIKE @FlightNumber) 
	AND (TransactionTimeNoOfBags.CustomerLookupType LIKE @BoardPass) 
	AND (Flight.MarketingCarrier LIKE @Airline)
GROUP BY AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea, NumberOfBagsMap.NoOfBagsGroupID
ORDER BY dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea), NumberOfBagsMap.NoOfBagsGroupID
	
END
GO
PRINT 'Dropped and Reverse Procedure TransactionTimeForNoOfBagsPerABD'


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
    @Airline nvarchar(25)
	)
		WITH RECOMPILE
AS



	SELECT     AbdStation.ID AS ABDStationID, dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea) AS AbdStationName, 
		SUM(BagWeightUpdate.Weight) AS TotalWeight, COUNT(BagWeightUpdate.LocalTime) AS Bags
	FROM         BagWeightUpdate INNER JOIN
						  AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID INNER JOIN
						  CustomerSession ON BagWeightUpdate.CustomerSessionID = CustomerSession.ID INNER JOIN
						  Flight ON CustomerSession.FlightID = Flight.ID INNER JOIN Bag ON BagWeightUpdate.BagID = Bag.ID
	WHERE     (BagWeightUpdate.LocalTime BETWEEN @FromDateTime AND @ToDateTime) 
		AND (CAST(Flight.FlightNumber as nvarchar(100)) like @FlightNumber) 
		AND (CustomerSession.CustomerLookupType like @BoardPass) 
		AND (Bag.BagTagType like @BagTagType)
		AND (Flight.MarketingCarrier like @Airline)
	
	GROUP BY AbdStation.ID,AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea
	ORDER BY dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea)


	RETURN  
GO
PRINT 'Dropped and Reverse Procedure TotalBagsPerABD'


Print 'END ROLLBACK'
 
Declare @PatchVersion nvarchar(25) = '6.2r3'
 
-- Post-rollback removal of patch version deployment record
Exec dbo.RemoveVersionDeployment @PatchVersion
Print 'Removed DB version deployment for: ' + @PatchVersion
GO