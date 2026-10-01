--Delete the trigger: [trigger_passportinfo_insert_DocumentNumber]
--Delete the trigger: [trigger_customersession_after_insert_PNR]
USE BagDrop
GO 

--trigger_passportinfo_insert_DocumentNumber
IF OBJECT_ID ('trigger_passportinfo_insert_DocumentNumber', 'TR') IS NOT NULL  
BEGIN
   DROP TRIGGER trigger_passportinfo_insert_DocumentNumber
   print 'Trigger trigger_passportinfo_insert_DocumentNumber has been deleted'
END
GO  

--[trigger_customersession_after_insert_PNR]
IF OBJECT_ID ('trigger_customersession_after_insert_PNR', 'TR') IS NOT NULL
BEGIN
   DROP TRIGGER trigger_customersession_after_insert_PNR
   print 'Trigger trigger_customersession_after_insert_PNR has been deleted'
END
GO  