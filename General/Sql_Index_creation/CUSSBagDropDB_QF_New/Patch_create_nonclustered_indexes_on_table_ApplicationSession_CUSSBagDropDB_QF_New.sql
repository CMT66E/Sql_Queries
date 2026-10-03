USE [CUSSBagDropDB_QF_New]
GO 
--it needs 7 seconds at local environment
--create non-clustered indexes on table: ApplicationSession needs around 40 seconds
CREATE INDEX IX_ApplicationSession_CussSessionId ON ApplicationSession(CussSessionId);
print 'non-clustered index IX_ApplicationSession_CussSessionId has been created'

