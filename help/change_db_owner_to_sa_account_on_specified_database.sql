--this is useful if some of databases were restored from other machine's backup
--for example when we retoring DBs from 192.168.15.24 to a new DB server
exec sp_changedbowner 'sa', 'true'