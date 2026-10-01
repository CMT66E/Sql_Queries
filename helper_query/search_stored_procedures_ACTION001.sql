--SELECT ROUTINE_NAME, ROUTINE_DEFINITION
--    FROM INFORMATION_SCHEMA.ROUTINES 
--    WHERE ROUTINE_DEFINITION LIKE '%Terminal%' 
--    AND ROUTINE_TYPE='PROCEDURE'

 

SELECT OBJECT_NAME(id) as STORED_PROCEDURE_NAME
    FROM SYSCOMMENTS 
    WHERE [text] LIKE '%SLAAvailabilityPerDayPerZone%' 
    AND OBJECTPROPERTY(id, 'IsProcedure') = 1 
    GROUP BY OBJECT_NAME(id)
--did apply the terminal filter in totla 78 SPs. There are only 17 SPs referred Terminal parameters
--CalculatePeakThroughputPer15Mins
 

--SELECT OBJECT_NAME(object_id)
--    FROM sys.sql_modules
--    WHERE OBJECTPROPERTY(object_id, 'IsProcedure') = 1
--    AND definition LIKE '%Terminal%'