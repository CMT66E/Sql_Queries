--The purpose of these scripts is to correct those reporting data in month: April 2021 commented by Eric He 12-05-2021
--because some of digit numbers have been input into database Flight table as MarketingCarrier so we need correct them.
--I found these digit numbers mapped to Flight Numbers so we can reset these digit numbers  to EW which is the real owner of these flights
--
--2028            EW    Stuttgart to Hamburg
--2038            EW    Stuttgart to Bremen
--2002            EW    Stuttgart to Berlin
--2044            EW    Stuttgart to Hamburg
--2042            EW    Stuttgart to Hamburg
--2090            EW    Stuttgart to Hamburg
--2036            EW    Stuttgart to Hamburg
--2034            EW    Stuttgart to Bremen
--2032            EW    Stuttgart to Bremen
--2004            EW    Stuttgart to Berlin
--8001            EW    Stuttgart to Berlin
--8005            EW    Stuttgart to Berlin
--8007            EW    Stuttgart to Berlin
--

use CUSSReportingDB_STR
go

update Flight set MarketingCarrier = 'EW'
where ID in (

select distinct b.FlightID from PrintDocument a 
inner join CustomerSession b on a.CustomerSessionID = b.ID
inner join Flight c on b.FlightID = c.ID
WHERE DatePart(year, a.[localTime]) = 2021 and 
  DatePart(month, a.[localTime]) = 4 and FlightNumber in (
'2028',  
'2038',   
'2002',   
'2044',  
'2042',   
'2090',  
'2036', 
'2034',  
'2032',  
'2004',   
'8001', 
'8005',
'8007'
  )
  and c.MarketingCarrier not in ('A3', 'AF', 'DE', 'EW', 'KL', 'TK')
  
  )

------------------------------------------------------------
--we delete those CustomerSession records belongs to April 2021 and their Flights have been marked as AF
--and this AF actually has no flights in April 2021 so we should remove 4 AF flight records which written into system in April 2021
delete from [dbo].[CustomerSession] where FlightID in 
(
	SELECT ID
	FROM [dbo].[Flight]
	WHERE DatePart(year, [DepartureDate]) = 2021  
	and DatePart(month, [DepartureDate]) = 4  
	and MarketingCarrier = 'AF'
)
------------------------------------------------------------
--After the foreign key: FlightID in CustomerSession whick linked with April AF records have been deleted above 
--then we can delete AF Flight table data in April 2021 which only has 4 records
delete
from [dbo].[Flight]
where DatePart(year, [DepartureDate]) = 2021  
and DatePart(month, [DepartureDate]) = 4  
and MarketingCarrier = 'AF'
 