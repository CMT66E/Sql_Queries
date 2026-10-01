USE [ReportingDB_QF_New] 
GO 


--drop non-clustered indexes  
DROP INDEX IF EXISTS IX_ABDAvailability_Date ON ABDAvailability;
print 'non-clustered index IX_ABDAvailability_Date has been dropped'

DROP INDEX IF EXISTS IX_CustomerSession_SessionDuration ON CustomerSession;
print 'non-clustered index IX_CustomerSession_SessionDuration has been dropped'

DROP INDEX IF EXISTS IX_CustomerSessionTimeOnEachScreen_CustomerSessionID ON CustomerSession;
print 'non-clustered index CustomerSessionTimeOnEachScreen has been dropped'