USE BagDropDB_QF_NEW
GO

CREATE INDEX UNIQ_CustomerSession_ID_UtcCreationTime ON CustomerSession(ID, UtcCreationTime);