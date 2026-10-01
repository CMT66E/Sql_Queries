--checking the trigger: [trigger_customer_insert_givenname_surname]
--checking the trigger: [trigger_customersession_after_insert_PNR]
--checking the trigger: [trigger_passportinfo_insert_DocumentNumber]

USE [BagDropDB_QF_NEW]
GO 


--[trigger_customer_insert_givenname_surname]
IF OBJECT_ID ('trigger_customer_insert_givenname_surname', 'TR') IS NOT NULL
BEGIN
   print 'Trigger trigger_customer_insert_givenname_surname has been found'
END
ELSE
   print 'Trigger trigger_customer_insert_givenname_surname HAS NOT BEEN FOUND'
GO  

--[trigger_customersession_after_insert_PNR]
IF OBJECT_ID ('trigger_customersession_after_insert_PNR', 'TR') IS NOT NULL
BEGIN
   print 'Trigger trigger_customersession_after_insert_PNR has been found'
END
ELSE
   print 'Trigger trigger_customersession_after_insert_PNR HAS NOT BEEN FOUND'
GO  

--trigger_passportinfo_insert_DocumentNumber
IF OBJECT_ID ('trigger_passportinfo_insert_DocumentNumber', 'TR') IS NOT NULL  
BEGIN
   print 'Trigger trigger_passportinfo_insert_DocumentNumber has been found'
END
ELSE
   print 'Trigger trigger_passportinfo_insert_DocumentNumber HAS NOT BEEN FOUND'
GO  