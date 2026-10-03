USE [CUSSReportingDB_SIN];
GO
SELECT name AS LogicalName, physical_name AS PhysicalFilePath, type_desc 
FROM sys.database_files;
GO