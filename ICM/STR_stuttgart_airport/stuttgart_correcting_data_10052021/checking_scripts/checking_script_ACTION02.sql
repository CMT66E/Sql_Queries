SELECT  [MarketingCarrier]
      , count(*) as TempCount
  FROM [CUSSBagDropDB_STR].[dbo].[Flight]
  WHERE DatePart(year, [DepartureDate]) = 2021  
  and DatePart(month, [DepartureDate]) = 4  
  group by [MarketingCarrier]
------------------------------------------------------------------------------------
SELECT *
  FROM [CUSSBagDropDB_STR].[dbo].[Flight]
  WHERE DatePart(year, [DepartureDate]) = 2021 and 
  DatePart(month, [DepartureDate]) = 4   and
 [MarketingCarrier] not in ('A3', 'AF', 'DE', 'EW', 'KL', 'TK')
   and FlightNumber in (
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
--------------------------------------------------------------------------------------

select a.*, b.FlightID, c.MarketingCarrier, c.FlightNumber from PrintDocument a inner join CustomerSession b on a.CustomerSessionID = b.ID
                                            inner join Flight c on b.FlightID = c.ID
WHERE DatePart(year, [LocalTime]) = 2021 and 
  DatePart(month, [LocalTime]) = 4 and FlightNumber in (
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

--------------------------------------------------------------------------------------
select distinct b.FlightID from PrintDocument a inner join CustomerSession b on a.CustomerSessionID = b.ID
                                            inner join Flight c on b.FlightID = c.ID
WHERE DatePart(year, [LocalTime]) = 2021 and 
  DatePart(month, [LocalTime]) = 4 and FlightNumber in (
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
--------------------------------------------------------------------------------------
update Flight set MarketingCarrier = 'EW'
where ID in (select distinct b.FlightID from PrintDocument a inner join CustomerSession b on a.CustomerSessionID = b.ID
                                            inner join Flight c on b.FlightID = c.ID
WHERE DatePart(year, [LocalTime]) = 2021 and 
  DatePart(month, [LocalTime]) = 4 and FlightNumber in (
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
  and c.MarketingCarrier not in ('A3', 'AF', 'DE', 'EW', 'KL', 'TK'))