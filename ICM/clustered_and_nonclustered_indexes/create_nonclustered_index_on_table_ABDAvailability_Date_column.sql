USE [ReportingDB_QF_New] -- it needs 57 seconds to complete on local PC
GO 

CREATE INDEX IX_ABDAvailability_Date ON ABDAvailability([Date]);
