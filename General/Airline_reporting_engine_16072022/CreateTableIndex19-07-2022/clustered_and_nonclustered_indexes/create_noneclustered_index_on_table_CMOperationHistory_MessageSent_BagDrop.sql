USE [BagDropDB_SIN]
GO 

CREATE INDEX IX_CMOperationHistory_LocalTime ON CMOperationHistory(MessageSent);