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

If @CurrentVersion = @PatchVersion
BEGIN
	BEGIN TRANSACTION;  
	BEGIN TRY 
			Print 'BEGIN ROLLBACK'
			---------------------------------------------------------------------------------------------------------------------------------------------------------------
			-- Alter table CustomerSession by removing table colun: TubsCount and IsPrintBagReceipt
			IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CustomerSession]') AND type in (N'U'))
			BEGIN
				IF EXISTS(SELECT 1 FROM sys.columns 
						  WHERE Name = N'TubsCount'
						  AND Object_ID = Object_ID(N'dbo.CustomerSession'))
				BEGIN
					print 'remove existing column: TubsCount in table CustomerSession'	
 
					ALTER TABLE CustomerSession DROP CONSTRAINT DF__CustomerS__TubsC__6166761E; --please note: this value is dynamic please check database and reset it		 
					ALTER TABLE CustomerSession DROP COLUMN TubsCount;
				END

				IF EXISTS(SELECT 1 FROM sys.columns 
						  WHERE Name = N'IsPrintBagReceipt'
						  AND Object_ID = Object_ID(N'dbo.CustomerSession'))
				BEGIN
					print 'remove existing column: IsPrintBagReceipt in table CustomerSession'
					ALTER TABLE CustomerSession DROP CONSTRAINT DF__CustomerS__IsPri__625A9A57; --please note: this value is dynamic please check database and reset it		 
					ALTER TABLE CustomerSession DROP COLUMN IsPrintBagReceipt; 
				END	
			END
	 
			Print 'Alter table CustomerSession by removing table colun: TubsCount and IsPrintBagReceipt.'
			---------------------------------------------------------------------------------------------------------------------------------------------------------------

			Print 'END ROLLBACK'

 
			-- Post-rollback removal of patch version deployment record
			Exec dbo.RemoveVersionDeployment @PatchVersion
			Print 'Removed DB version deployment for: ' + @PatchVersion
			COMMIT TRANSACTION;  
	END TRY    
	BEGIN CATCH 
		ROLLBACK TRANSACTION; 
		Print 'Removed DB version deployment failed, no changes appied to database. Please check both constraint names under current table: CustomerSession'   
	END CATCH
END


---------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------
