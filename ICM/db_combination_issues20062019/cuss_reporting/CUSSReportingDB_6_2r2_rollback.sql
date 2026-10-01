USE [CUSSReportingDB]
GO
 
DECLARE @PatchVersion nvarchar(25) = '6.2r2'
 
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
 
 
--Update SP PaperTagReadsPerABD
 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransferSLAAvailabilityUptoDatePerZone]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TransferSLAAvailabilityUptoDatePerZone]
GO

PRINT 'Dropped Procedure TransferSLAAvailabilityUptoDatePerZone'


 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SLAAvailabilityPerHourPerZone]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SLAAvailabilityPerHourPerZone]
GO

PRINT 'Dropped Procedure SLAAvailabilityPerHourPerZone'


 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SLAAvailabilityPerDayPerZone]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SLAAvailabilityPerDayPerZone]
GO

PRINT 'Dropped Procedure SLAAvailabilityPerDayPerZone'


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SLAAvailabilityPerZone]') AND type in (N'U'))
DROP TABLE [dbo].[SLAAvailabilityPerZone]
GO

PRINT ' Dropped table SLAAvailabilityPerZone'

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SLARequirementsPerZone]') AND type in (N'U'))
DROP TABLE [dbo].[SLARequirementsPerZone]
GO

PRINT ' Dropped table SLARequirementsPerZone'
Print 'Rolledback Procedure TransactionTimeForNoOfBagsPerABD_SSIS'
 
 
Print 'END ROLLBACK'
 
 
Declare @PatchVersion nvarchar(25) = '6.2r2'
 
-- Post-rollback removal of patch version deployment record
Exec dbo.RemoveVersionDeployment @PatchVersion
Print 'Removed DB version deployment for: ' + @PatchVersion
GO