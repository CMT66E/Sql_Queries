USE [BagDrop_QF_New]
GO 

CREATE INDEX IX_AbdStateHistory_LocalTime ON AbdStateHistory(LocalTime);

CREATE INDEX IX_AbdStateHistory_AbdStationID_LocalTime
ON AbdStateHistory(AbdStationID, LocalTime);

---Rollback script below
---DROP INDEX AbdStateHistory.IX_AbdStateHistory_LocalTime;
