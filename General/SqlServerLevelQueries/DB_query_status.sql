
SELECT 
    name, 
    state_desc, 
    user_access_desc,
    is_in_standby,
    is_read_only
FROM sys.databases
WHERE name = 'ReportingDB_SIN';



SELECT 
    s.session_id,
    s.login_name,
    r.status,
    r.command,
    r.wait_type,
    r.wait_time,
    r.blocking_session_id,
    r.database_id
FROM sys.dm_exec_sessions s
LEFT JOIN sys.dm_exec_requests r ON s.session_id = r.session_id
WHERE r.database_id = DB_ID('ReportingDB_SIN');


