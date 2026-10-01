SELECT file_id, name, type_desc, physical_name, size, max_size  
FROM sys.database_files ;   --3142,976

SELECT (total_log_size_in_bytes - used_log_space_in_bytes)*1.0/1024/1024 AS [free log space in MB]  
FROM sys.dm_db_log_space_usage;


select *from sys.dm_db_log_space_usage; --61,330,944

