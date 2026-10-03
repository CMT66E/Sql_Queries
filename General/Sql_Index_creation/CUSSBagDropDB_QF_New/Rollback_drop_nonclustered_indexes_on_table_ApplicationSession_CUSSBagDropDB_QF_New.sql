USE [CUSSBagDropDB_QF_New]
GO 


--drop non-clustered indexes on table: ApplicationSession
DROP INDEX IF EXISTS IX_ApplicationSession_CussSessionId
ON ApplicationSession;
print 'non-clustered index IX_ApplicationSession_CussSessionId has been dropped'
 