
USE [CUSSReportingDB]
GO
 
DECLARE @ExpectedPreviousVersion nvarchar(25) = '6.2r1'
DECLARE @PatchVersion nvarchar(25) = '6.2r2'
 
-- Pre-patch version check
Declare @CurrentVersion nvarchar(25)
Exec dbo.GetCurrentVersion @CurrentVersion Output
 
Print 'Current DB version is: ' + @CurrentVersion
Print ''
 
If @CurrentVersion <> @ExpectedPreviousVersion AND @CurrentVersion <> @PatchVersion Begin
    Print 'Patching aborted because current database version is not ' + @ExpectedPreviousVersion + ' or ' + @PatchVersion + '.'
    Raiserror ('Patch aborted.',20, 10) With Log
    Return
End
 
 
Print 'BEGIN PATCHING'

----- Add table SLAAvailabilityPerZone
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SLAAvailabilityPerZone]') AND type in (N'U'))
DROP TABLE [dbo].[SLAAvailabilityPerZone]
GO

CREATE TABLE [dbo].[SLAAvailabilityPerZone](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Date] [datetime] NULL,
	[TimeSlotHourlyID] [int] NULL,
	[SLASevStateID] [int] NULL,
	[MinutesInState] [float] NULL,
	[Zone] [nvarchar](20) NULL,
 CONSTRAINT [PK_SLAAvailabilityPerZone] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
Print 'Created table SLAAvailabilityPerZone.'


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SLARequirementsPerZone]') AND type in (N'U'))
DROP TABLE [dbo].[SLARequirementsPerZone]
GO

CREATE TABLE [dbo].[SLARequirementsPerZone](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[PortID] [int] NULL,
	[SLASevStateID] [int] NULL,
	[TimeSlotHourlyID] [int] NULL,
	[FromInError] [int] NULL,
	[ToInError] [int] NULL,
	[Zone] [nvarchar](20) NULL,
 CONSTRAINT [PK_SLARequirementsPerZone] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
Print 'Created table SLARequirementsPerZone.'


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransferSLAAvailabilityUptoDatePerZone]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TransferSLAAvailabilityUptoDatePerZone]
GO
Create PROC [dbo].[TransferSLAAvailabilityUptoDatePerZone]
(
	@PortID int,
	@GranularSeconds int,
	@Zone Nvarchar(20)

)
AS	
BEGIN 
				---Select @PortID =2,@GranularSeconds=5,@Zone='C'

			DECLARE @DateProcessTo DATETIME
			DECLARE @DateProcessFrom DATETIME
			DECLARE @DateToProcess DATETIME

			IF EXISTS(SELECT 1 FROM SLAAvailabilityPerZone where Zone =@Zone)
				SET @DateProcessFrom = (SELECT MAX(Date) FROM SLAAvailabilityPerZone where Zone =@Zone)
			ELSE 
				SET @DateProcessFrom = (SELECT MIN(LocalTime) FROM CUSSBagDropDB.dbo.AbdStateHistory) 	

			SET @DateToProcess = (SELECT DATEADD(dd, 0, DATEDIFF(dd, 0, @DateProcessFrom)))

			SET @DateProcessTo = (SELECT TOP 1 DATEADD(HOUR, DATEDIFF(HOUR, 0, LocalTime), 0) FROM CUSSBagDropDB.dbo.AbdStateHistory ORDER BY ID DESC)

			--IF DATEDIFF(DAY, @DateToProcess, @DateProcessTo) > 1
			--	SET @DateProcessTo = DATEADD(DAY, 1, @DateToProcess)


			IF OBJECT_ID('tempdb..#tempHourIntervals') is not null
					DROP TABLE [dbo].[#tempHourIntervals]		
		
			IF OBJECT_ID('tempdb..#tempIntervals') is not null
					DROP TABLE [dbo].[#tempIntervals]

			PRINT 'Start to clean up fault entries'	
			---------------------------------------------------------------------------------------------------------------	
			--Delete faulty entries in 	SLAAvailability
			DECLARE @ReadyToStart bit
			SET @ReadyToStart = 0

			DECLARE @NumberOfLastEntries int
			DECLARE @LastTimeSlotID int
			DECLARE @DateOfLastEntry datetime
			DECLARE @NumberOfSLARequirements int
			DECLARE @LastProcessedHour int

			WHILE @ReadyToStart = 0
			BEGIN
				IF EXISTS(SELECT TOP 1 * FROM [SLAAvailabilityPerZone] Where Zone=@Zone)
				BEGIN
					SET @NumberOfLastEntries = (SELECT TOP 1 COUNT(*)       
												FROM [SLAAvailabilityPerZone] 
												Where  Zone=@Zone
												GROUP BY [Date], [TimeSlotHourlyID]
												ORDER BY [Date] DESC, [TimeSlotHourlyID] DESC)

						PRINT '@@@NumberOfLastEntries'
					PRINT 	@NumberOfLastEntries

					SET @LastTimeSlotID = (SELECT TOP 1 TimeSlotHourlyID       
													FROM [SLAAvailabilityPerZone] 
													Where  Zone=@Zone
													GROUP BY [Date], [TimeSlotHourlyID]
													ORDER BY [Date] DESC, [TimeSlotHourlyID] DESC)			
										
					PRINT '@@LastTimeSlotID'
					PRINT 	@LastTimeSlotID
					SET @DateOfLastEntry = (SELECT TOP 1 [Date]       
													FROM [SLAAvailabilityPerZone] 
													Where  Zone=@Zone
													GROUP BY [Date], [TimeSlotHourlyID]
													ORDER BY [Date] DESC, [TimeSlotHourlyID] DESC)														

					PRINT '@DateOfLastEntry'
					PRINT 	@DateOfLastEntry
					SET @NumberOfSLARequirements = (SELECT     COUNT(*) AS NumberOfEntries
														FROM         SLARequirementsPerZone
														WHERE     (PortID = @PortID) AND (TimeSlotHourlyID = @LastTimeSlotID) AND  Zone=@Zone)	
					PRINT '@@NumberOfSLARequirements'
					PRINT 	@NumberOfSLARequirements
	   						
					IF @NumberOfLastEntries <> @NumberOfSLARequirements		
						DELETE FROM SLAAvailabilityPerZone
						WHERE        (TimeSlotHourlyID = @LastTimeSlotID) AND (Date = @DateOfLastEntry)	AND  Zone=@Zone
					ELSE
					BEGIN
						SET @LastProcessedHour = (SELECT CONVERT(int, TimeSlotName) FROM TimeSlotHourly WHERE ID = @LastTimeSlotID)
						SET @DateToProcess = DATEADD(HOUR, @LastProcessedHour + 1, @DateOfLastEntry)
						SET @ReadyToStart = 1
					END

					PRINT '@LastProcessedHour'
					PRINT @LastProcessedHour

					PRINT '@DateToProcess'
					PRINT @DateToProcess

				END
				ELSE
					SET @ReadyToStart = 1
			END

			PRINT 'Finish cleaning up fault entries'

			---------------------------------------------------------------------------------------------------------------	
			-- Populate SLA Availability
			PRINT 'Start to populate SLA Availability'

			----populate all 1 hour intervals need to be calculated							
			;WITH HourIntervals AS
			(
				SELECT DATEADD(DAY, DATEDIFF(DAY, 0, @DateToProcess), 0) AS Date, 
					@DateToProcess AS FromHour, 
					DATEADD(HOUR, 1, @DateToProcess) AS ToHour
				WHERE DATEADD(HOUR, 1, @DateToProcess) <= @DateProcessTo
				UNION ALL
				SELECT DATEADD(DAY, DATEDIFF(DAY, 0, ToHour), 0) AS Date,
						ToHour AS FromHour, 
						DATEADD(HOUR, 1, ToHour) AS ToHour
				FROM HourIntervals 
				WHERE DATEADD(HOUR, 1, ToHour) <= @DateProcessTo
			)


			SELECT tmpHourIntervals.Date, TimeSlotHourly.ID AS TimeSlotHourlyID, tmpHourIntervals.FromHour, tmpHourIntervals.ToHour ,SLARequirements.SLASevStateID, 
				SLARequirements.FromInError, SLARequirements.ToInError INTO #tempHourIntervals
			FROM (SELECT * 
					FROM HourIntervals ) tmpHourIntervals
			JOIN TimeSlotHourly
			ON DATEPART(HOUR, TimeSlotHourly.FromTime) = DATEPART(HOUR, tmpHourIntervals.FromHour)
				AND (DATEPART(HOUR, TimeSlotHourly.ToTime) = DATEPART(HOUR, tmpHourIntervals.ToHour)
					OR DATEPART(HOUR, DATEADD(SECOND, 1, TimeSlotHourly.ToTime)) = DATEPART(HOUR, tmpHourIntervals.ToHour))
			JOIN SLARequirementsPerZone  SLARequirements
			ON SLARequirements.TimeSlotHourlyID = TimeSlotHourly.ID	
			WHERE   SLARequirements.Zone=@Zone
			--ORDER BY tmpHourIntervals.Date,TimeSlotHourly.ID	
			OPTION (MAXRECURSION 0)	

			---Select * from #tempHourIntervals

			--populate all 5 seconds intervals need to be calculated							
			;WITH Intervals AS
			(
				SELECT DATEADD(DAY, DATEDIFF(DAY, 0, @DateToProcess), 0) AS Date, 
					@DateToProcess AS FromHour, 
					DATEADD(HOUR, 1, @DateToProcess) AS ToHour, 
					DATEADD(DAY, -7, DATEADD(SECOND, @GranularSeconds, @DateToProcess)) AS FromInterval, 
					DATEADD(SECOND, @GranularSeconds, @DateToProcess) AS ToInterval
				WHERE DATEADD(HOUR, 1, @DateToProcess) <= @DateProcessTo
				UNION ALL
				SELECT DATEADD(DAY, DATEDIFF(DAY, 0, ToInterval), 0) AS Date,
						DATEADD(HOUR, DATEDIFF(HOUR, 0, ToInterval), 0) AS FromHour, 
						DATEADD(HOUR, 1, DATEADD(HOUR, DATEDIFF(HOUR, 0, ToInterval), 0)) AS ToHour,
						DATEADD(DAY, -7, DATEADD(SECOND, @GranularSeconds, ToInterval)) AS FromInterval, 
						DATEADD(SECOND, @GranularSeconds, ToInterval) AS ToInterval
				FROM Intervals 
				WHERE DATEADD(SECOND, @GranularSeconds, ToInterval) <= @DateProcessTo
			)


			SELECT tmpIntervals.Date,TimeSlotHourly.ID AS TimeSlotHourlyID, tmpIntervals.FromHour, tmpIntervals.ToHour, 
				tmpIntervals.FromInterval, tmpIntervals.ToInterval INTO #tempIntervals
			FROM (SELECT * 
					FROM Intervals ) tmpIntervals
			JOIN TimeSlotHourly
			ON DATEPART(HOUR, TimeSlotHourly.FromTime) = DATEPART(HOUR, tmpIntervals.FromHour)
				AND (DATEPART(HOUR, TimeSlotHourly.ToTime) = DATEPART(HOUR, tmpIntervals.ToHour)
					OR DATEPART(HOUR, DATEADD(SECOND, 1, TimeSlotHourly.ToTime)) = DATEPART(HOUR, tmpIntervals.ToHour))
			--ORDER BY tmpIntervals.Date,TimeSlotHourly.ID, ToInterval		
			OPTION (MAXRECURSION 0)	

			--Select * from #tempIntervals order by date, TimeSlotHourlyID

			--------- query SLA Availability
			INSERT INTO SLAAvailabilityPerZone (Date, TimeSlotHourlyID, SLASevStateID, MinutesInState,Zone)
			SELECT #tempHourIntervals.Date, #tempHourIntervals.TimeSlotHourlyID, #tempHourIntervals.SLASevStateID, 
				CONVERT(float, COUNT (NumberOfABDsInErrorState) * @GranularSeconds) / 60 AS MinutesInState,@Zone
			FROM #tempHourIntervals
			LEFT JOIN (SELECT Date, TimeSlotHourlyID, FromInterval, ToInterval, SUM(LatestABDsState.IsLatestABDStateInError) AS NumberOfABDsInErrorState
					----INTO #TempTest
						FROM (SELECT #tempIntervals.Date, #tempIntervals.TimeSlotHourlyID, #tempIntervals.FromInterval, #tempIntervals.ToInterval,
									CASE WHEN MAX(AbdStateHistoryLog.ID) = MAX(AbdErrorStateHistoryLog.ID) THEN 1 
									ELSE 0 END AS IsLatestABDStateInError
								FROM AbdStation
								CROSS JOIN #tempIntervals
								LEFT JOIN CUSSBagDropDB.dbo.AbdStateHistory AbdStateHistoryLog
								ON AbdStateHistoryLog.AbdStationID = AbdStation.ID
									AND AbdStateHistoryLog.LocalTime >= #tempIntervals.FromInterval 
									AND AbdStateHistoryLog.LocalTime < #tempIntervals.ToInterval
								LEFT JOIN CUSSBagDropDB.dbo.AbdStateHistory AbdErrorStateHistoryLog 
								ON AbdErrorStateHistoryLog.State = 'InError' AND AbdStateHistoryLog.ID = AbdErrorStateHistoryLog.ID
								WHERE AbdStation.Area =@Zone AND AbdStation.AbdType ='ABD'
								GROUP BY #tempIntervals.Date, #tempIntervals.TimeSlotHourlyID,#tempIntervals.FromInterval, #tempIntervals.ToInterval, AbdStation.ID ) AS LatestABDsState		
						GROUP BY Date, TimeSlotHourlyID, FromInterval, ToInterval	)	AS NumberOfABDsInErrorStateAtIntervals															
			ON #tempHourIntervals.Date = NumberOfABDsInErrorStateAtIntervals.Date
				AND #tempHourIntervals.TimeSlotHourlyID = NumberOfABDsInErrorStateAtIntervals.TimeSlotHourlyID
				AND NumberOfABDsInErrorState BETWEEN #tempHourIntervals.FromInError AND #tempHourIntervals.ToInError
			GROUP BY #tempHourIntervals.Date, #tempHourIntervals.TimeSlotHourlyID, #tempHourIntervals.SLASevStateID
			ORDER BY #tempHourIntervals.Date, #tempHourIntervals.TimeSlotHourlyID, #tempHourIntervals.SLASevStateID
					
			-- Drop temporary tables
			DROP TABLE  #tempHourIntervals																  
			DROP TABLE  #tempIntervals

END
GO
Print 'Created Procedure TransferSLAAvailabilityUptoDatePerZone'

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SLAAvailabilityPerDayPerZone]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SLAAvailabilityPerDayPerZone]
GO
CREATE PROCEDURE [dbo].[SLAAvailabilityPerDayPerZone]
(
    @FromDateTime DateTime,
	@ToDateTime DateTime,
	@Zone nvarchar(20)
	)
AS
BEGIN
    IF (@Zone <>'%')
	BEGIN
		SELECT     SLAAvailabilityPerZone.Date, SLASevStates.ID AS SLASevStateID, SLASevStates.SevStateName, SUM(SLAAvailabilityPerZone.MinutesInState) AS MinutesInState,SLAAvailabilityPerZone.Zone 
                      
		FROM        SLAAvailabilityPerZone   INNER JOIN
							  SLASevStates ON SLAAvailabilityPerZone.SLASevStateID = SLASevStates.ID
		WHERE        (SLAAvailabilityPerZone.Date BETWEEN @FromDateTime AND @ToDateTime) AND ISNULL(SLAAvailabilityPerZone.Zone,'') LIKE @Zone
		GROUP BY SLAAvailabilityPerZone.Date, 	SLASevStates.ID, SLASevStates.SevStateName,SLAAvailabilityPerZone.Zone 
		ORDER BY SLAAvailabilityPerZone.Date
    END
	ELSE
	BEGIN
		SELECT     SLAAvailabilityPerZone.Date, SLASevStates.ID AS SLASevStateID, SLASevStates.SevStateName, SUM(SLAAvailabilityPerZone.MinutesInState) AS MinutesInState,SLAAvailabilityPerZone.Zone 
                      
		FROM        SLAAvailabilityPerZone   INNER JOIN
							  SLASevStates ON SLAAvailabilityPerZone.SLASevStateID = SLASevStates.ID
		WHERE        (SLAAvailabilityPerZone.Date BETWEEN @FromDateTime AND @ToDateTime) 
		GROUP BY SLAAvailabilityPerZone.Date, 	SLASevStates.ID, SLASevStates.SevStateName,SLAAvailabilityPerZone.Zone 
		ORDER BY SLAAvailabilityPerZone.Date
	END

END
GO
Print 'Created Procedure SLAAvailabilityPerDayPerZone'

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SLAAvailabilityPerHourPerZone]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SLAAvailabilityPerHourPerZone]
GO
CREATE PROCEDURE [dbo].[SLAAvailabilityPerHourPerZone]
(
	@Date DateTime,
	@Zone nvarchar(20)
	)
	
AS
BEGIN

    IF (@Zone <> '%')
	BEGIN
		SELECT     SLAAvailabilityPerZone.Date, SLAAvailabilityPerZone.SLASevStateID, SLASevStates.SevStateName, TimeSlotHourly.TimeSlotName, SLAAvailabilityPerZone.TimeSlotHourlyID, SLAAvailabilityPerZone.MinutesInState,SLAAvailabilityPerZone.Zone
                      
		FROM         SLAAvailabilityPerZone INNER JOIN
							  TimeSlotHourly ON SLAAvailabilityPerZone.TimeSlotHourlyID = TimeSlotHourly.ID INNER JOIN
							  SLASevStates ON SLAAvailabilityPerZone.SLASevStateID = SLASevStates.ID
		WHERE     (SLAAvailabilityPerZone.Date = @Date) AND SLAAvailabilityPerZone.Zone = @Zone
		ORDER BY SLASevStates.SevStateName, TimeSlotHourly.ID, TimeSlotHourly.TimeSlotName
    END
	ELSE
	BEGIN

		SELECT     SLAAvailabilityPerZone.Date, SLAAvailabilityPerZone.SLASevStateID, SLASevStates.SevStateName, TimeSlotHourly.TimeSlotName, SLAAvailabilityPerZone.TimeSlotHourlyID, SLAAvailabilityPerZone.MinutesInState,SLAAvailabilityPerZone.Zone
                      
		FROM         SLAAvailabilityPerZone INNER JOIN
							  TimeSlotHourly ON SLAAvailabilityPerZone.TimeSlotHourlyID = TimeSlotHourly.ID INNER JOIN
							  SLASevStates ON SLAAvailabilityPerZone.SLASevStateID = SLASevStates.ID
		WHERE     (SLAAvailabilityPerZone.Date = @Date) 
		ORDER BY SLASevStates.SevStateName, TimeSlotHourly.ID, TimeSlotHourly.TimeSlotName
	END


END
GO
Print 'Created Procedure SLAAvailabilityPerHourPerZone'
 
Print 'END PATCHING'
 
Declare @PatchVersion nvarchar(25) = '6.2r2'
 
-- Post-patch version deployment recording
Exec dbo.RecordVersionDeployment @PatchVersion
Print 'Recorded DB version deployment for: ' + @PatchVersion
GO