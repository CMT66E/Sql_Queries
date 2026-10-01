USE [BagDropDB_QF_NEW]
GO 
-----------------------------------------
SELECT TOP (1000) [ID]
      ,[UCI]
      ,[Title]
      ,[GivenName]
      ,[Surname]
      ,[Gender]
FROM [Customer]
order  by ID desc

select count(ID) FROM [Customer]
----------------------------------------
SELECT TOP (1000) [ID]
      ,[CustomerID]
      ,[AbdStationID]
      ,[CustomerLookupType]
      ,[PNR]
      ,[UtcCreationTime]
      ,[FlightID]
      ,[UtcCompletionTime]
      ,[LocalCreationTime]
      ,[LocalCompletionTime]
      ,[MachineTime]
      ,[PaxTime]
      ,[DcsTime]
      ,[BhsTime]
      ,[CsaTime]
  FROM [CustomerSession]
  order by ID desc

  select count(ID) FROM [CustomerSession]
------------------------------------------

SELECT TOP (1000) [ID]
      ,[AbdStationID]
      ,[CustomerSessionID]
      ,[DocumentNumber]
      ,[FirstName]
      ,[LastName]
      ,[Gender]
      ,[DOB]
      ,[Expiry]
      ,[Issuer]
      ,[Nationality]
      ,[Type]
      ,[IsPassportPhotoRetrieved]
      ,[IsRFIDPhoto]
      ,[IsVerifiedSucessfully]
      ,[LocalCreationTime]
FROM [PassportInfo]

select count(ID) FROM [PassportInfo]
------------------------------------------