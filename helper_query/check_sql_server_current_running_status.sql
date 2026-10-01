SELECT sessions.session_id
    ,requests.status
    ,requests.blocking_session_id 
    ,requests.wait_type
    ,wait_resource
    ,requests.wait_time / (1000.0) 'wait_time(sec)'
    ,requests.cpu_time
    ,requests.logical_reads
    ,requests.reads
    ,requests.writes
    ,requests.total_elapsed_time / (1000.0) 'total_elapsed_time(Sec)'
    ,Substring(sqltext.TEXT, (requests.statement_start_offset / 2) + 1, (
            (
                CASE requests.statement_end_offset
                    WHEN - 1
                        THEN Datalength(sqltext.TEXT)
                    ELSE requests.statement_end_offset
                    END - requests.statement_start_offset
                ) / 2
            ) + 1) AS statement_text
    ,Coalesce(Quotename(Db_name(sqltext.dbid)) + N'.' + Quotename(Object_schema_name(sqltext.objectid, sqltext.dbid)) + N'.' + 
     Quotename(Object_name(sqltext.objectid, sqltext.dbid)), '') AS command_text
    ,requests.command
    ,sessions.login_name
    ,sessions.host_name
    ,sessions.program_name
    ,sessions.host_process_id
    ,sessions.last_request_end_time
    ,sessions.login_time
    ,requests.open_transaction_count
FROM sys.dm_exec_sessions AS sessions
INNER JOIN sys.dm_exec_requests AS requests ON requests.session_id = sessions.session_id
CROSS APPLY sys.dm_exec_sql_text(requests.sql_handle) AS sqltext
--WHERE requests.session_id != @@SPID
ORDER BY requests.cpu_time DESC