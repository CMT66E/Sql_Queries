        ALTER DATABASE BagDrop_French
        SET RECOVERY SIMPLE
        GO
        DBCC SHRINKFILE (BagDrop_log, 50)  --BagDrop_log is Database BagDrop_French log name (Logical Name) 50 MB here
        GO
        ALTER DATABASE BagDrop_French
        SET RECOVERY FULL