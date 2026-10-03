USE [CUSSReportingDB_NRT]
GO 

CREATE INDEX IX_ApplicationSessionUsage_Date ON ApplicationSessionUsage([Date]);

 


---Rollback script below
DROP INDEX ApplicationSessionUsage.IX_ApplicationSessionUsage_Date;