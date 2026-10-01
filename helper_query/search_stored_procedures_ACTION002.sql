--SELECT ROUTINE_NAME, ROUTINE_DEFINITION
--    FROM INFORMATION_SCHEMA.ROUTINES 
--    WHERE ROUTINE_DEFINITION LIKE '%Terminal%' 
--    AND ROUTINE_TYPE='PROCEDURE'

 

SELECT OBJECT_NAME(id) as STORED_PROCEDURE_NAME
    FROM SYSCOMMENTS 
    WHERE [text] LIKE '%@Terminal%' 
    AND OBJECTPROPERTY(id, 'IsProcedure') = 1 
    GROUP BY OBJECT_NAME(id)
-- ReportingDB database
-- did apply the terminal filter in totla 132 SPs. There are only 47 SPs referred Terminal parameters
 
 

--SELECT OBJECT_NAME(object_id)
--    FROM sys.sql_modules
--    WHERE OBJECTPROPERTY(object_id, 'IsProcedure') = 1
--    AND definition LIKE '%Terminal%'