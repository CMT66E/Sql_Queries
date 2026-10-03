USE [CUSSReportingDB_NRT]
GO



/****** Object:  View [dbo].[View_ABDAvailability]    Script Date: 12/03/2026 2:31:58 PM ******/
DROP VIEW IF EXISTS [dbo].[View_ABDAvailability]
GO

/****** Object:  View [dbo].[View_ABDAvailability]    Script Date: 12/03/2026 2:31:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[View_ABDAvailability]
AS
SELECT        ID, Date, ABDStationID, StateTimeSlotID, ABDStateID, MinutesInState
FROM            dbo.ABDAvailability
WHERE        (Date > DATEADD(month, - 2, GETDATE()))
GO



