USE [BagDropDB_QF_BNE]
GO

INSERT INTO dbo.Customer (UCI, Title, GivenName, Surname, Gender)
VALUES ('2005EA920000B255', NULL, 'Ken', 'Homles', 'M')
GO


UPDATE dbo.Customer
SET  GivenName = 'Ken'
	,Surname = 'Homles'	 
WHERE ID = 5
GO

select TOP 10 * from dbo.Customer order by ID desc
select * from dbo.Customer where ID = 5
-----------------------------------------------------------------

INSERT INTO dbo.CustomerSession (CustomerID, AbdStationID, CustomerLookupType, PNR, UtcCreationTime, FlightID, UtcCompletionTime, LocalCreationTime, LocalCompletionTime, MachineTime, PaxTime, DcsTime, BhsTime, CsaTime, NumberOfTubs, IsReceiptPrinted)
VALUES (3, 5, 'PaperBoardPass', 'RA9080PA', '03/08/2018 05:31:31 AM', 1, '03/08/2018 05:32:24 AM', '03/08/2018 04:31:31 PM', '03/08/2018 04:32:24 PM', 21754, 29320, 1866, 0, 0, 0, 0)
GO


UPDATE dbo.CustomerSession
SET  PNR = 'R#####' 
WHERE ID = 5
GO

select TOP 10 * from dbo.CustomerSession order by ID desc
select * from dbo.CustomerSession where ID = 5
-----------------------------------------------------------------
INSERT INTO dbo.PassportInfo (AbdStationID, CustomerSessionID, DocumentNumber, FirstName, LastName, Gender, DOB, Expiry, Issuer, Nationality, Type, IsPassportPhotoRetrieved, IsRFIDPhoto, IsVerifiedSucessfully, LocalCreationTime)
VALUES (4, 5, 'PA889900D', 'Henry', 'Milson', 'F', '05/21/1994', '06/11/2025', 'AUS', 'AUS', 'PASSPORT', 1, 0, 1, '03/18/2018 02:53:48 PM')
GO

UPDATE dbo.PassportInfo
SET 
	 DocumentNumber = 'PA99890D'
	,FirstName = 'Henry'
	,LastName = 'Milson'
	
WHERE ID = 5
GO

select TOP 10 * from dbo.PassportInfo order by ID desc
select * from dbo.PassportInfo where ID = 5
-----------------------------------------------------------------