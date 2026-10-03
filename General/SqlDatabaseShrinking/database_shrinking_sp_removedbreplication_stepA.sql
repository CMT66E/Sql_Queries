USE [CUSSReportingDB_SIN];
GO

-- 2. Execute the system procedure to remove all replication metadata
EXEC sp_removedbreplication;
--EXEC sp_removedbreplication @type = 'both'; 
GO