DBCC CHECKIDENT ('dbo.tblTemp', RESEED, 0);    
INSERT INTO dbo.tblTemp (FirstName, LastName, City)
SELECT FirstName, LastName, City
FROM (DELETE FROM tblTemp OUTPUT deleted.*) d;