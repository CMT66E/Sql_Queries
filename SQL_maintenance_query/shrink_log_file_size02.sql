        ALTER DATABASE ReportingDB_French
        SET RECOVERY SIMPLE
        GO
        DBCC SHRINKFILE (ReportingDB_log, 50)  -- ReportingDB_log is Database ReportingDB_French log name (Logical Name) 50 MB here
        GO
        ALTER DATABASE ReportingDB_French
        SET RECOVERY FULL