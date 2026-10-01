select * from [CUSSReportingDB_JFK].[dbo].CustomerSession  
select cast(LocalTime as date) as DateTemp, count(*)  from [CUSSReportingDB_JFK].[dbo].CustomerSession
group by cast(LocalTime as date)
order by cast(LocalTime as date)

select * from [CUSSReportingDB_JFK_PURE].[dbo].CustomerSession  
select cast(LocalTime as date) as DateTemp, count(*)  from [CUSSReportingDB_JFK_PURE].[dbo].CustomerSession
group by cast(LocalTime as date)
order by cast(LocalTime as date)
