select cast(LocalTime as date) as DateTemp, count(*)  from [CUSSBagDropDB_JFK].[dbo].[BagWeightUpdate]
group by cast(LocalTime as date)
order by cast(LocalTime as date)

--select * from [CUSSReportingDB_JFK].[dbo].[BagWeightUpdate]  
select cast(LocalTime as date) as DateTemp, count(*)  from [CUSSReportingDB_JFK].[dbo].[BagWeightUpdate]
group by cast(LocalTime as date)
order by cast(LocalTime as date)

--select * from [CUSSReportingDB_JFK_PURE].[dbo].[BagWeightUpdate]  
select cast(LocalTime as date) as DateTemp, count(*)  from [CUSSReportingDB_JFK_PURE].[dbo].[BagWeightUpdate]
group by cast(LocalTime as date)
order by cast(LocalTime as date)