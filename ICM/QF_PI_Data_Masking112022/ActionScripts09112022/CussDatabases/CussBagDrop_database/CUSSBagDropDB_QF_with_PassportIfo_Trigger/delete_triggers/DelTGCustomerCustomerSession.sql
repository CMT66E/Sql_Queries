--Delete the trigger: [trigger_customer_insert_givenname_surname]
--Delete the trigger: [trigger_customersession_after_insert_PNR]
USE CUSSBagDropDB_LHR
GO 

--[trigger_customer_insert_givenname_surname]
IF OBJECT_ID ('trigger_customer_insert_givenname_surname', 'TR') IS NOT NULL  
BEGIN
   DROP TRIGGER trigger_customer_insert_givenname_surname
   print 'Trigger trigger_customer_insert_givenname_surname has been deleted'
END
GO  

--[trigger_customersession_after_insert_PNR]
IF OBJECT_ID ('trigger_customersession_after_insert_PNR', 'TR') IS NOT NULL
BEGIN
   DROP TRIGGER trigger_customersession_after_insert_PNR
   print 'Trigger trigger_customersession_after_insert_PNR has been deleted'
END
GO  

--[trigger_passportinfo_insert_DocumentNumber]
IF OBJECT_ID ('trigger_passportinfo_insert_DocumentNumber', 'TR') IS NOT NULL
BEGIN
   DROP TRIGGER trigger_passportinfo_insert_DocumentNumber
   print 'trigger_passportinfo_insert_DocumentNumber has been deleted'
END
GO  