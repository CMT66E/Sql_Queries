USE [CUSSReportingDB]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[TransactionRawData]
		@FromDate = N'2021/05/01 00:00:00',
		@ToDate = N'2021/05/31 23:59:59'

SELECT	'Return Value' = @return_value

GO


USE [ReportingDB]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[TransactionRawData]
		@FromDate = N'2021/05/01 00:00:00',
		@ToDate = N'2021/05/31 23:59:59'

SELECT	'Return Value' = @return_value

GO