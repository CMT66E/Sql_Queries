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
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[trig_employee_for_update]
   ON  [dbo].[employee]
   FOR UPDATE 
AS 
BEGIN
    DECLARE @Count  int
	SET @Count = @@ROWCOUNT

	IF @Count = 0
	   RETURN

	SET NOCOUNT ON

	BEGIN TRY
	    declare @employee_no int = 0
		select @employee_no = i.employee_no from inserted i

		UPDATE [dbo].[employee_backup] SET employee_name = 'YYYYYY' WHERE employee_no = @employee_no
	END TRY

	BEGIN CATCH
	    IF @@TRANCOUNT > 0
		BEGIN
		   ROLLBACK TRANSACTION
		END 

		EXECUTE [dbo].[uspLogServerError] @@error 
	END CATCH

END
