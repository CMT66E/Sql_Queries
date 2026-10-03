USE [ReportingDB_QF_New] 
GO 

--CREATE INDEX IX_ABDAvailability_Date ON ABDAvailability([Date]); -- it needs 57 seconds to complete on local PC
--CREATE INDEX IX_CustomerSession_SessionDuration ON CustomerSession(SessionDuration); -- it needs 26 seconds to complete on local PC
CREATE INDEX IX_CustomerSessionTimeOnEachScreen_CustomerSessionID ON CustomerSessionTimeOnEachScreen(CustomerSessionID) -- it needs 8:27 seconds