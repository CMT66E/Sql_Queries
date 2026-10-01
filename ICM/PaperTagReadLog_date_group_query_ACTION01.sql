select  
cast([LocalLogTime] as date) as LogDate, 
count(*) as NumberOfOccurrecnces       
from [CUSSBagDropDB_DXB_PURE].[dbo].[PaperTagReadLog]
group by cast([LocalLogTime] as date)
order by NumberOfOccurrecnces

select  
cast([LocalLogTime] as date) as LogDate, 
count(*) as NumberOfOccurrecnces       
from [CussReportingDB_DXB].[dbo].[PaperTagReadLog]
group by cast([LocalLogTime] as date)
order by NumberOfOccurrecnces