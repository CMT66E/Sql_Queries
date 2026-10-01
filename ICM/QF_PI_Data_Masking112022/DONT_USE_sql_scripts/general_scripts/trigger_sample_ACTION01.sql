-- ================================================
-- Template generated from Template Explorer using:
-- Create Trigger (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- See additional Create Trigger templates for more
-- examples of different Trigger statements.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Eric He
-- Create date: 26-06-2019
-- Description:	tesing on using trigger when inserting data into table
-- =============================================
CREATE TRIGGER [trigger_employee]
   ON  [dbo].[employee]
   AFTER INSERT, UPDATE 
AS 
BEGIN
    DECLARE @Count  int
	SET @Count = @@ROWCOUNT

	IF @Count = 0
	   RETURN

	SET NOCOUNT ON

	BEGIN TRY
	    INSERT INTO [dbo].[employee_backup]
		(
		  employee_no, 
		  employee_name, 
		  job, 
		  hiredate, 
		  salary 	
		)
		SELECT 
		  inserted.employee_no,
		  inserted.employee_name, 
		  inserted.job, 
		  inserted.hiredate, 
		  inserted.salary
		FROM inserted
	END TRY

	BEGIN CATCH
	    IF @@TRANCOUNT > 0
		BEGIN
		   ROLLBACK TRANSACTION
		END 

		EXECUTE [dbo].[uspLogServerError] @@error 
	END CATCH

END
GO
