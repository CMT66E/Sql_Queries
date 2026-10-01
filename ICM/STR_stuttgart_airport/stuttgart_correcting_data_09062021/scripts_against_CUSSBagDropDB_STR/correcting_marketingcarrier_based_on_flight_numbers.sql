
--The purpose of these scripts is to correct those reporting data in month: May 2021 against database: CUSSBagDropDB_STR -- commented by Eric He 09-06-2021
--because some of digit numbers have been input into database Flight table as MarketingCarrier so we need correct them.
--I found these digit numbers mapped to Flight Numbers so we can reset these digit numbers  to EW which is the real owner of these flights
--
--2002            EW    Stuttgart to Berlin
--2028            EW    Stuttgart to Hamburg
--2032            EW    Stuttgart to Bremen
--2036            EW    Stuttgart to Hamburg
--2042            EW    Stuttgart to Hamburg
--2044            EW    Stuttgart to Hamburg
--7049            EW    Stuttgart to Hamburg
--8001            EW    Stuttgart to Berlin
--8005            EW    Stuttgart to Berlin
--8007            EW    Stuttgart to Berlin
--

use CUSSBagDropDB_STR
go

update Flight set MarketingCarrier = 'EW'
where ID in (select distinct b.FlightID from PrintDocument a inner join CustomerSession b on a.CustomerSessionID = b.ID
                                            inner join Flight c on b.FlightID = c.ID
WHERE DatePart(year, [LocalTime]) = 2021 and 
  DatePart(month, [LocalTime]) = 5 and FlightNumber in (
'2002',  
'2028',  
'2032',  
'2036',  
'2042',  
'2044',  
'7049',  
'8001',  
'8005',  
'8007' 
  )
  and c.MarketingCarrier not in ('A3', 'AF', 'DE', 'EW', 'KL', 'TK'))

------------------------------------------------------------
--we delete those CustomerSession records belongs to May 2021 and their Flights have been marked as AF
--and this AF actually has no flights in May 2021 so we should remove 3 AF flight records which written into system in May 2021
delete from [dbo].[CustomerSession] where FlightID in 
(
	SELECT ID
	FROM [dbo].[Flight]
	WHERE DatePart(year, [DepartureDate]) = 2021  
	and DatePart(month, [DepartureDate]) = 5  
	and MarketingCarrier = 'AF'
)
------------------------------------------------------------
--After the foreign key: FlightID in CustomerSession whick linked with April AF records have been deleted above 
--then we can delete AF Flight table data in May 2021 which only has 3 records

delete
from [dbo].[Flight]
where DatePart(year, [DepartureDate]) = 2021  
and DatePart(month, [DepartureDate]) = 5  
and MarketingCarrier = 'AF'