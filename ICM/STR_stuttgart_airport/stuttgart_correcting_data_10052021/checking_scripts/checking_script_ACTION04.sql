/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [ID]
      ,[MarketingCarrier]
      ,[FlightNumber]
      ,[DepartureDate]
      ,[BoardPoint]
      ,[OffPoint]
  FROM [CUSSReportingDB_STR].[dbo].[Flight]
  WHERE DatePart(year, [DepartureDate]) = 2021 and 
  --DatePart(month, [DepartureDate]) = 4   and
 [MarketingCarrier] not in ('A3', 'AF', 'DE', 'EW', 'KL', 'TK')
   and FlightNumber not in (
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

SELECT TOP (1000) [ID]
      ,[MarketingCarrier]
      ,[FlightNumber]
      ,[DepartureDate]
      ,[BoardPoint]
      ,[OffPoint]
  FROM [CUSSReportingDB_STR].[dbo].[Flight]
  WHERE DatePart(year, [DepartureDate]) = 2021 and 
  DatePart(month, [DepartureDate]) = 4 
  and [MarketingCarrier] not in ('A3', 'AF', 'DE', 'EW', 'KL', 'TK')
  and FlightNumber not in (
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
SELECT  [MarketingCarrier]
      , count(*) as TempCount
  FROM [CUSSReportingDB_STR].[dbo].[Flight]
  WHERE DatePart(year, [DepartureDate]) = 2021  
  and DatePart(month, [DepartureDate]) = 4  
  group by [MarketingCarrier]