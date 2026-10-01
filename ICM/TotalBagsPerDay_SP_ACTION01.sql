USE [ReportingDB_QF_New]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[TotalBagsPerDay]
		@FromDateTime = N'2023/01/01 00:00:00',
		@ToDateTime = N'2023/01/31 23:59:59',
		@FlightNumber = N'%',
		@BoardPass = N'%',
		@BagTagType = N'%',
		@Airline = N'%',
		@Terminal = N'WLG',
		@Area = N'%',
		@SubArea = N'%',
		@ABDStationIDs = N'0',
		@ABDStationNames = N'Display All ABDs'

SELECT	'Return Value' = @return_value

GO
