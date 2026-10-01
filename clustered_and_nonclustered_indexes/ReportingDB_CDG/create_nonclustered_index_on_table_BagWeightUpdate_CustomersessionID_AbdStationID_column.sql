USE [ReportingDB_CDG] 
GO 

--in total it may need around 68 seconds
CREATE INDEX IX_BagWeightUpdate_CustomerSessionID_AbdStationID ON BagWeightUpdate(CustomerSessionID, AbdStationID);