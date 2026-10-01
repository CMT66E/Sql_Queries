-- ================================================
USE [CUSSBagDropDB]
GO 
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Eric He
-- Create date: 10-11-2022
-- Description:	Using trigger when inserting data into table:PassportInfo
-- Purpose:Based on Singapore government's requirements we do not keep passport document number into our database
--         we replace this column data to be ########
-- =============================================
CREATE TRIGGER [trigger_customer_insert_givenname_surname]
   ON  [dbo].[PassportInfo]
   AFTER INSERT, UPDATE
AS 
BEGIN
    DECLARE @Count  int
	SET @Count = @@ROWCOUNT

	IF @Count = 0
	   RETURN

	SET NOCOUNT ON

	BEGIN TRY
	    declare @row_id int = 0
		select @row_id = i.ID from inserted i

		UPDATE [dbo].[PassportInfo] SET GivenName = (case when len(isnull(GivenName, '')) > 1 then substring(GivenName, 1, 1) + '########' else GivenName end),
                 Surname = (case when len(isnullSurname, '')) > 1 then substring(Surname, 1, 1) + '########' else Surname end)
                WHERE ID = @row_id
	END TRY

	BEGIN CATCH
	    IF @@TRANCOUNT > 0
		BEGIN
		   ROLLBACK TRANSACTION
		END 
	END CATCH
END
GO
