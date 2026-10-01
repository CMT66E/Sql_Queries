
CREATE FUNCTION udfTransactionInYear (
    @input_year INT
)
RETURNS TABLE
AS
RETURN
    SELECT 
        CustomerSessionID,
        LocalTime,
        ABDStation,
		TransactionTime,
		MarketingCarrier,
		PNR
    FROM
        QF_SYD_T1_transaction_JAN_JUN_2022
    WHERE
        datepart(year, LocalTime) = @input_year;
GO

===========================================================

USE [STUDY_DB]
GO
SELECT * FROM dbo.udfTransactionInYear(2022)
GO