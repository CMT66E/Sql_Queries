USE [ReportingDB_CDG]
GO 


--drop non-clustered indexes on table: AbdStateHistory
DROP INDEX IF EXISTS IX_BagWeightUpdate_CustomerSessionID_AbdStationID
ON BagWeightUpdate;
print 'non-clustered index IX_BagWeightUpdate_CustomerSessionID_AbdStationID has been dropped'