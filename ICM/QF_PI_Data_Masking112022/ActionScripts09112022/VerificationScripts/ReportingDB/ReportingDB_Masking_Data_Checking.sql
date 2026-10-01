USE [ReportingDB]
GO 
 
----------------------------------------
SELECT TOP (1000) [ID]
      ,[CustomerID]
      ,[AbdStationID]
      ,[CustomerLookupType]
      ,[PNR]
      ,[UtcCreationTime]
      ,[FlightID]
      ,[TimeSlot5minID]
      ,[TimeSlot10minID]
      ,[TimeSlotHourlyID]
      ,[DayOfTheWeekID]
      ,[LocalTime]
      ,[UtcCompletionTime]
      ,[SessionDuration]
      ,[SessionEndReasonID]
      ,[SessionEndPageID]
      ,[MachineTime]
      ,[PaxTime]
      ,[DcsTime]
      ,[BhsTime]
      ,[CsaTime]
      ,[NumberOfTubs]
      ,[IsReceiptPrinted]
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
order by ID desc

select count(ID) FROM [PassportInfo]
------------------------------------------