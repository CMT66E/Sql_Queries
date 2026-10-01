        ALTER DATABASE BagDrop
        SET RECOVERY SIMPLE
        GO
        DBCC SHRINKFILE (BagDrop_log, 50)  -- BagDrop_log is Database BagDrop log name (Logical Name) 50 MB here
        GO
        ALTER DATABASE BagDrop
        SET RECOVERY FULL