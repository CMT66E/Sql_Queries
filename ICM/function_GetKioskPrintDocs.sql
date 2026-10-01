-- ================================================
-- Template generated from Template Explorer using:
-- Create Scalar Function (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION  [dbo].[GetKioskPrintDocs]
(
	-- Add the parameters for the function here
	@CustomerSessionID bigint
)
RETURNS int
AS
BEGIN
	-- Return the result of the function
	declare @TempCount bigint
	select @TempCount = count(ID) from PrintDocument where CustomerSessionID = @CustomerSessionID
	RETURN @TempCount

END
GO

