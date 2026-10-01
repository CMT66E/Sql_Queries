USE [ReportingDB_NRT]
GO 

CREATE INDEX IX_ABDErrorLog_LocalCreationTime ON ABDErrorLog(LocalCreationTime);

CREATE INDEX IX_BagWeightUpdate_LocalTime ON BagWeightUpdate(LocalTime);


---Rollback script below
---DROP INDEX AbdStateHistory.IX_AbdStateHistory_LocalTime;
