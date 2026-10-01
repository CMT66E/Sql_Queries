USE [CUSSBagDropDB_LHR]
GO
/****** Object:  Trigger [dbo].[trigger_customersession_after_insert_PNR]   ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Eric He
-- Create date: 10-11-2022
-- Description:	creating trigger trigger_passportinfo_insert_DocumentNumber when inserting data into tables: Passportinfo
-- =============================================
  
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID ('trigger_passportinfo_insert_DocumentNumber', 'TR') IS NOT NULL  
BEGIN
   DROP TRIGGER trigger_passportinfo_insert_DocumentNumber
   
END
GO   
 
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

		UPDATE [dbo].[PassportInfo] 
                SET DocumentNumber = (case when len(isnull(DocumentNumber, '')) > 1 then substring(DocumentNumber, 1, 1) + '########' else DocumentNumber end),
                    FirstName  = (case when len(isnull(FirstName , '')) > 1 then substring(FirstName , 1, 1) + '########' else FirstName  end),
		    LastName = (case when len(isnull(LastName, '')) > 1 then substring(LastName, 1, 1) + '########' else LastName end)                   
                WHERE ID = @row_id
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRANSACTION
		END 
	END CATCH
END
print 'Trigger trigger_passportinfo_insert_DocumentNumber has been created'
GO



