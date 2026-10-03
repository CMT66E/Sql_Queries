
USE BagDropDB_QF_NEW
GO

CREATE INDEX UNIQ_Flight_FlightNumber_DepartureDate ON Flight(FlightNumber, DepartureDate);