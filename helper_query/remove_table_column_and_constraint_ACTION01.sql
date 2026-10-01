Use BagDrop_French
GO

Declare @PatchVersion nvarchar(25) = '11_4a2'

-- Pre-rollback version check
Declare @CurrentVersion nvarchar(25)
Exec dbo.GetCurrentVersion @CurrentVersion Output

Print 'Current DB version is: ' + @CurrentVersion
Print ''

If @CurrentVersion <> @PatchVersion Begin
	Print 'Rollback aborted because current database version is not ' + @PatchVersion + '.'
	Return
	Raiserror ('Rollback aborted.',20, 10) With Log
End
 
Print 'BEGIN ROLLBACK'
---------------------------------------------------------------------------------------------------------------------------------------------------------------
Declare @ErrorCount int = 0
-- Alter table CustomerSession by removing table colun: TubsCount and IsPrintBagReceipt
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CustomerSession]') AND type in (N'U'))
BEGIN
	IF EXISTS(SELECT 1 FROM sys.columns 
				WHERE Name = N'TubsCount'
				AND Object_ID = Object_ID(N'dbo.CustomerSession'))
	BEGIN		        
		BEGIN TRY		    
			ALTER TABLE CustomerSession DROP CONSTRAINT DF_customersession_tubscount; --please note: this value could be dynamic please check database to verify
			ALTER TABLE CustomerSession DROP COLUMN TubsCount;	 
		END TRY
		BEGIN CATCH
		    print 'remove existing column: TubsCount in table CustomerSession failed'	
		    select @ErrorCount = @ErrorCount + 1;
		END CATCH;		
	END

	IF EXISTS(SELECT 1 FROM sys.columns 
				WHERE Name = N'IsPrintBagReceipt'
				AND Object_ID = Object_ID(N'dbo.CustomerSession'))
	BEGIN
	    BEGIN TRY			 
			ALTER TABLE CustomerSession DROP CONSTRAINT DF_customersession_isprintbagreceipt; --please note: this value could be dynamic please check database to verify	 
			ALTER TABLE CustomerSession DROP COLUMN IsPrintBagReceipt; 
		END TRY
		BEGIN CATCH
		    print 'remove existing column: IsPrintBagReceipt in table CustomerSession failed'	
		    select @ErrorCount = @ErrorCount + 1;
		END CATCH;	
	END	
END

if @ErrorCount = 0  -- if there is no error at all we reset the version
BEGIN
	Print 'Alter table CustomerSession by removing table colun: TubsCount and IsPrintBagReceipt.'
	---------------------------------------------------------------------------------------------------------------------------------------------------------------
	Print 'END ROLLBACK'
	--------------------------------------------------------------------------------------------------------------------------------------------------------------- 
    -- Post-rollback removal of patch version deployment record
 
	Exec dbo.RemoveVersionDeployment @PatchVersion
	Print 'Removed DB version deployment for: ' + @PatchVersion
END
---------------------------------------------------------------------------------------------------------------------------------------------------------------
