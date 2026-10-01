-- ================================================
USE BagDrop
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
CREATE TRIGGER [trigger_passportinfo_insert_DocumentNumber]
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

		UPDATE [dbo].[PassportInfo] SET DocumentNumber = (case when len(isnull(DocumentNumber, '')) > 1 then substring(DocumentNumber, 1, 1) + '########' else DocumentNumber end) WHERE ID = @row_id
	END TRY

	BEGIN CATCH
	    IF @@TRANCOUNT > 0
		BEGIN
		   ROLLBACK TRANSACTION
		END 
	END CATCH
END
GO
