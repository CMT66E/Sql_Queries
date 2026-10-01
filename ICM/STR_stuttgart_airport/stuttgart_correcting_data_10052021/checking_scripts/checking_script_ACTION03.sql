use CUSSBagDropDB_STR
go

select * from Flight
where ID in (select distinct b.FlightID from PrintDocument a inner join CustomerSession b on a.CustomerSessionID = b.ID
                                            inner join Flight c on b.FlightID = c.ID
WHERE DatePart(year, a.[LocalTime]) = 2021 and 
  DatePart(month, a.[LocalTime]) = 4 and c.MarketingCarrier = 'AF')


select * from Flight where MarketingCarrier = 'AF' and DatePart(year, DepartureDate) = 2021 and 
  DatePart(month, DepartureDate) = 4 


----------------------------------------------------------

use CUSSReportingDB_STR
go

select * from Flight
where ID in (select distinct b.FlightID from PrintDocument a inner join CustomerSession b on a.CustomerSessionID = b.ID
                                            inner join Flight c on b.FlightID = c.ID
WHERE DatePart(year, a.[LocalTime]) = 2021 and 
  DatePart(month, a.[LocalTime]) = 4 and c.MarketingCarrier = 'AF')

select * from Flight where MarketingCarrier = 'AF' and DatePart(year, DepartureDate) = 2021 and 
  DatePart(month, DepartureDate) = 4 