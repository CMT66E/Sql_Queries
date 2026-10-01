USE CUSSReportingDB --it needs over 9 minutes
GO 

CREATE INDEX IX_ABDAvailability_Date ON ABDAvailability([Date]);
print 'Nonclustered index IX_ABDAvailability_Date has been created'

--needs 1:43 minutes
CREATE INDEX IX_ABDAvailability_ABDStationID ON ABDAvailability(ABDStationID);
print 'Nonclustered index IX_ABDAvailability_ABDStationID has been created'

CREATE INDEX IX_AbdStateHistory_LocalTime ON AbdStateHistory(LocalTime);
print 'Nonclustered index IX_AbdStateHistory_LocalTime has been created'
