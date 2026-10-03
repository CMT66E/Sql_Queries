USE [ReportingDB_T4] 
GO 
 
--in total it needs around 12:41 minutes
CREATE INDEX IX_ABDAvailability_Date ON ABDAvailability([Date]); -- it needs 57 seconds to complete on local PC
print 'non-clustered index IX_ABDAvailability_Date has been created'

CREATE INDEX IX_CustomerSession_SessionDuration ON CustomerSession(SessionDuration); -- it needs 26 seconds to complete on local PC
print 'non-clustered index IX_CustomerSession_SessionDuration has been created'

CREATE INDEX IX_CustomerSessionTimeOnEachScreen_CustomerSessionID ON CustomerSessionTimeOnEachScreen(CustomerSessionID) -- it needs 8:27 seconds
print 'non-clustered index IX_CustomerSessionTimeOnEachScreen_CustomerSessionID has been created'


--in total it may need around 35 seconds
CREATE INDEX IX_BagWeightUpdate_CustomerSessionID ON BagWeightUpdate(CustomerSessionID);


