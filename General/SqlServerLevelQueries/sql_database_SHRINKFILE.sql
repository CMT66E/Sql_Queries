-- 1. Check if the block is cleared (log_reuse_wait_desc should now show NOTHING or LOG_BACKUP)
SELECT name, log_reuse_wait_desc FROM sys.databases WHERE name = 'CUSSReportingDB_SIN';
GO

-- 2. If it shows NOTHING, shrink the log file to your target size (e.g., 1024 MB)
-- Replace 'YourDatabase_Log' with your actual logical log file name
DBCC SHRINKFILE (CUSSReportingDB_log, 1024);
GO

USE [CUSSReportingDB_SIN];
GO
-- Replace ACTUAL_LOG_NAME_HERE with the logical name from Step 1
DBCC SHRINKFILE (CUSSReportingDB_log, 1024);
GO
