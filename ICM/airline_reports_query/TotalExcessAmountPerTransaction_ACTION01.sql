USE [ReportingDB]
GO

DECLARE	@return_value int,
		@TotalBagAccepted int

SELECT	@TotalBagAccepted = 0

EXEC	@return_value = [dbo].[TotalExcessAmountPerTransaction]
		@FromDateTime = N'2019/02/01 00:00:00',
		@ToDateTime = N'2019/02/28 23:59:59',
		@Terminal = N'%',
		@Area = N'%',
		@SubArea = N'%',
		@ABDStationIDs = N'0',
		@ABDStationNames = N'%',
		@TotalBagAccepted = @TotalBagAccepted OUTPUT

SELECT	@TotalBagAccepted as N'@TotalBagAccepted'

SELECT	'Return Value' = @return_value

GO


