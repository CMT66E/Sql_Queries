USE [ReportingDB_SIN] --it needs  27 seconds to run
GO 
 --it needs 1:37 seconds in total at local environment
--create non-clustered indexes on tables: ApplicationSessionUsage
CREATE INDEX IX_CustomerSession_FlightID ON CustomerSession([FlightID]);
print 'non-clustered index IX_CustomerSession_FlightID has been created'