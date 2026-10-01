
---table: flight------------------
SELECT  MarketingCarrier, COUNT(MarketingCarrier) as NumberOfOccurrences
FROM CUSSReportingDB_STR.[dbo].[Flight]   
GROUP BY MarketingCarrier
order by COUNT(MarketingCarrier)

SELECT  *
FROM CUSSReportingDB_STR.[dbo].[Flight]  
WHERE MarketingCarrier = 'AF'

select * from CUSSReportingDB_STR.[dbo].[CustomerSession] where FlightID in
(
SELECT  ID
FROM CUSSReportingDB_STR.[dbo].[Flight]  
WHERE MarketingCarrier = 'AF'
)

---table: Airlines------------------
select * from CUSSBagDropDB_STR.[dbo].[Airline]
select * from CUSSReportingDB_STR.[dbo].[Airlines]

