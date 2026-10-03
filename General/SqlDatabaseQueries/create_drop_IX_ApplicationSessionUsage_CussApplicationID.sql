USE [CUSSReportingDB_NRT]
GO 

CREATE INDEX IX_ApplicationSessionUsage_CussApplicationID ON ApplicationSessionUsage(CussApplicationID);

 


---Rollback script below
---DROP INDEX ApplicationSessionUsage.IX_ApplicationSessionUsage_CussApplicationID;