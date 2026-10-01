USE [ReportingDB_QF_New] 
GO 

--in total it may need around 35 seconds
CREATE INDEX IX_BagWeightUpdate_CustomerSessionID ON BagWeightUpdate(CustomerSessionID);