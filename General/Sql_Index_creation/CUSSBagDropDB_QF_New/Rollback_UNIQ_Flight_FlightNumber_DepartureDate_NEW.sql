USE BagDropDB_QF_NEW
GO 


--drop non-clustered indexes on table: ApplicationSession
DROP INDEX IF EXISTS UNIQ_Flight_FlightNumber_DepartureDate
ON Flight;
print 'non-clustered index UNIQ_Flight_FlightNumber_DepartureDate has been dropped'
 