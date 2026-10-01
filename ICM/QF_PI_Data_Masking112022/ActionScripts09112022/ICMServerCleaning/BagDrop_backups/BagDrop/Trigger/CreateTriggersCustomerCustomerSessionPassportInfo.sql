-- ================================================
USE [BagDrop]
GO 
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Eric He
-- Create date: 10-11-2022
-- Description:	Using trigger when inserting or updating data into table:PassportInfo
-- Purpose:Based on government's requirements we do not keep passport document number, passenger names and PNR numbers in our database
--         we replace this column data to be ######## to mask them
--===============================================

IF OBJECT_ID ('trigger_customer_insert_givenname_surname', 'TR') IS NOT NULL
BEGIN
   DROP TRIGGER trigger_customer_insert_givenname_surname
   
END
GO

CREATE TRIGGER [trigger_customer_insert_givenname_surname]
	ON  [dbo].[Customer]
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

		UPDATE [dbo].[Customer] SET GivenName = (case when len(isnull(GivenName, '')) > 1 then substring(GivenName, 1, 1) + '########' else GivenName end),
					Surname = (case when len(isnull(Surname, '')) > 1 then substring(Surname, 1, 1) + '########' else Surname end)
				WHERE ID = @row_id
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRANSACTION
		END 
	END CATCH
END

print 'Trigger trigger_customer_insert_givenname_surname has been created'
GO
-----------------------------------------------------------------------------------------------
 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID ('trigger_customersession_after_insert_PNR', 'TR') IS NOT NULL
BEGIN
   DROP TRIGGER trigger_customersession_after_insert_PNR
   
END
GO  

CREATE TRIGGER [dbo].[trigger_customersession_after_insert_PNR]
   ON  [dbo].[CustomerSession]
   AFTER INSERT, UPDATE 
AS 
BEGIN
    DECLARE @Count  int
	SET @Count = @@ROWCOUNT

	IF @Count = 0
	   RETURN

	SET NOCOUNT ON

	BEGIN TRY
	    declare @customersession_id int = 0
        select @customersession_id = i.id from inserted i
		UPDATE [dbo].[CustomerSession] SET PNR = (case when len(isnull(PNR, '')) > 1 then substring(PNR, 1, 1) + '########' else PNR end) WHERE id = @customersession_id
	END TRY

	BEGIN CATCH
	    IF @@TRANCOUNT > 0
		BEGIN
		   ROLLBACK TRANSACTION
		END 

		--we may create a new table to hold sql query execution error shortly
		--EXECUTE [dbo].[uspLogServerError] @@error 
	END CATCH

END

print 'Trigger trigger_customersession_after_insert_PNR has been created'
GO 
-----------------------------------------------------------------------------------------------


-- ================================================
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

