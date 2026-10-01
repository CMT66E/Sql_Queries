USE CUSSReportingDB --it needs over 9 minutes
GO 

--drop non-clustered indexes on table: AbdStateHistory
DROP INDEX IF EXISTS IX_ABDAvailability_Date
ON ABDAvailability;
print 'non-clustered index IX_ABDAvailability_Date has been dropped'

DROP INDEX IF EXISTS IX_ABDAvailability_ABDStationID
ON ABDAvailability;
print 'non-clustered index IX_ABDAvailability_ABDStationID has been dropped'

DROP INDEX IF EXISTS IX_AbdStateHistory_LocalTime
ON AbdStateHistory;
print 'non-clustered index IX_AbdStateHistory_LocalTime has been dropped'