USE [BagDrop_QF_New]
GO 
--create non-clustered indexes on table: AbdStateHistory
CREATE INDEX IX_AbdStateHistory_LocalTime ON AbdStateHistory(LocalTime);
print 'non-clustered index IX_AbdStateHistory_LocalTime has been created'

CREATE INDEX IX_AbdStateHistory_AbdStationID_LocalTime ON AbdStateHistory(AbdStationID, LocalTime);
print 'non-clustered index IX_AbdStateHistory_AbdStationID_LocalTime has been created'