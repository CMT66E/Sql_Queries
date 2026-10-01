USE BagDrop_French
GO

DECLARE @ExpectedPreviousVersion nvarchar(25) = '11_4a1'
DECLARE @PatchVersion nvarchar(25) = '11_4a2'

-- Pre-patch version check
Declare @CurrentVersion nvarchar(25)
Exec dbo.GetCurrentVersion @CurrentVersion Output

Print 'Current DB version is: ' + @CurrentVersion
Print ''

If @CurrentVersion <> @ExpectedPreviousVersion AND @CurrentVersion <> @PatchVersion Begin
	Print 'Patching aborted because current database version is not ' + @ExpectedPreviousVersion + ' or ' + @PatchVersion + '.'
	Raiserror ('Patch aborted.',20, 10) With Log
	Return
End


Print 'BEGIN PATCHING'

---Create table ExcessTierLog
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CustomerSession]') AND type in (N'U'))
BEGIN
	IF NOT EXISTS(SELECT 1 FROM sys.columns 
			  WHERE Name = N'TubsCount'
			  AND Object_ID = Object_ID(N'dbo.CustomerSession'))
	BEGIN
		print 'create new column: TubsCount in table CustomerSession'
		ALTER TABLE CustomerSession
		ADD TubsCount INT CONSTRAINT DF_customersession_tubscount DEFAULT(0) NOT NULL  
	END
	ELSE
	BEGIN
	   print 'This column: TubsCount already exists in table CustomerSession'
	END

	IF NOT EXISTS(SELECT 1 FROM sys.columns 
			  WHERE Name = N'IsPrintBagReceipt'
			  AND Object_ID = Object_ID(N'dbo.CustomerSession'))
	BEGIN
		print 'create new column: IsPrintBagReceipt in table CustomerSession'
		ALTER TABLE CustomerSession
		ADD IsPrintBagReceipt BIT CONSTRAINT DF_customersession_isprintbagreceipt DEFAULT 0 NOT NULL;
	END
	ELSE
	BEGIN
	   print 'This column: IsPrintBagReceipt already cexists in table CustomerSession'
	END
END
GO
 
Print 'Alter table CustomerSession adding columns: TubsCount, IsPrintBagReceipt'

Print 'END PATCHING'

Declare @PatchVersion nvarchar(25) = '11_4a2'

-- Post-patch version deployment recording
Exec dbo.RecordVersionDeployment @PatchVersion
Print 'Recorded DB version deployment for: ' + @PatchVersion
GO

--------------------------------------------------------------------
--------------------------------------------------------------------

