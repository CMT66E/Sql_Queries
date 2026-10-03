USE [BagDrop_QF_New]
GO 


--drop non-clustered indexes on table: AbdStateHistory
DROP INDEX IF EXISTS IX_AbdStateHistory_LocalTime
ON AbdStateHistory;
print 'non-clustered index IX_AbdStateHistory_LocalTime has been dropped'

DROP INDEX IF EXISTS IX_AbdStateHistory_AbdStationID_LocalTime
ON AbdStateHistory;
print 'non-clustered index IX_AbdStateHistory_AbdStationID_LocalTime has been dropped'