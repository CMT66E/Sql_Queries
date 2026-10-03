USE [CUSSReportingDB_QF_New]
GO 


--drop non-clustered indexes on tables: ApplicationSessionUsage, AbdStateHistory, ABDAvailability, CustomerSession
DROP INDEX IF EXISTS IX_ApplicationSessionUsage_Date_ABDStationID_AirlineID
ON ApplicationSessionUsage;
print 'non-clustered index IX_ApplicationSessionUsage_Date_ABDStationID_AirlineID has been dropped'

DROP INDEX IF EXISTS IX_AbdStateHistory_LocalTime
ON AbdStateHistory;
print 'non-clustered index IX_AbdStateHistory_LocalTime has been dropped'

--DROP INDEX IF EXISTS IX_AbdStateHistory_AbdStationID_LocalTime
--ON AbdStateHistory;
--print 'non-clustered index IX_AbdStateHistory_AbdStationID_LocalTime has been dropped'

DROP INDEX IF EXISTS IX_ABDAvailability_Date
ON ABDAvailability;
print 'non-clustered index IX_ABDAvailability_Date has been dropped'

DROP INDEX IF EXISTS IX_CustomerSession_SessionDuration
ON CustomerSession;
print 'non-clustered index IX_CustomerSession_SessionDuration has been dropped'


 