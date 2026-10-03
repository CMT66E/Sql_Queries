USE BagDropDB_QF_NEW
GO 


--drop non-clustered indexes on table: ApplicationSession
DROP INDEX IF EXISTS UNIQ_CustomerSession_ID_UtcCreationTime
ON CustomerSession;
print 'non-clustered index UNIQ_CustomerSession_ID_UtcCreationTime has been dropped'
 