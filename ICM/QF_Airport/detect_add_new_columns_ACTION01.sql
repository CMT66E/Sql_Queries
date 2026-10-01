IF NOT EXISTS(SELECT 1 FROM sys.columns 
          WHERE Name = N'TubsCount'
          AND Object_ID = Object_ID(N'dbo.CustomerSession'))
BEGIN
    print 'create new column: TubsCount in table CustomerSession'
	ALTER TABLE CustomerSession
	ADD TubsCount INT NOT NULL DEFAULT(0) 
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
	ADD IsPrintBagReceipt BIT NOT NULL DEFAULT 0;
END
ELSE
BEGIN
   print 'This column: IsPrintBagReceipt already cexists in table CustomerSession'
END

