USE [CUSSReportingDB_QF_New]
GO 
 --it needs 1:37 seconds in total at local environment
--create non-clustered indexes on tables: ApplicationSessionUsage
CREATE INDEX IX_ApplicationSessionUsage_Date_ABDStationID_AirlineID ON ApplicationSessionUsage([Date], ABDStationID, AirlineID);
print 'non-clustered index IX_ApplicationSessionUsage_Date_ABDStationID_AirlineID has been created'

--create non-clustered indexes on tables: AbdStateHistory, ABDAvailability, CustomerSession
CREATE INDEX IX_AbdStateHistory_LocalTime ON AbdStateHistory(LocalTime);
print 'non-clustered index IX_AbdStateHistory_LocalTime has been created'

--CREATE INDEX IX_AbdStateHistory_AbdStationID_LocalTime ON AbdStateHistory(AbdStationID, LocalTime);
--print 'non-clustered index IX_AbdStateHistory_AbdStationID_LocalTime has been created'

CREATE INDEX IX_ABDAvailability_Date ON ABDAvailability([Date]); -- it needs 57 seconds to complete on local PC
print 'non-clustered index IX_ABDAvailability_Date has been created'

CREATE INDEX IX_CustomerSession_SessionDuration ON CustomerSession(SessionDuration); -- it needs 26 seconds to complete on local PC
print 'non-clustered index IX_CustomerSession_SessionDuration has been created'
 