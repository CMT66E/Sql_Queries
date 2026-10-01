
select * from [CUSSBagDropDB_DXB].[dbo].[AbdStateHistory] where AbdStationID not in (select ID from [CUSSBagDropDB_DXB].[dbo].[AbdStation])
select * from [CUSSBagDropDB_DXB_PURE].[dbo].[AbdStateHistory] where AbdStationID not in (select ID from [CUSSBagDropDB_DXB_PURE].[dbo].[AbdStation])

--checking further

select * FROM [CussReportingDB_DXB].[dbo].[ApplicationSessionUsage]  where ID not in (select ID FROM [CussReportingDB_DXB].[dbo].[ApplicationSessionUsage])
select [ApplicationSessionUsage].* FROM [CussReportingDB_DXB].[dbo].[ApplicationSessionUsage]  where ID not in (select ID FROM [CussReportingDB_DXB_PURE].[dbo].[ApplicationSessionUsage])

--checking further
select top (1000) [ID]
      ,[MarketingCarrier]
      ,[FlightNumber]
      ,[DepartureDate]
      ,[BoardPoint]
      ,[OffPoint]
from [CussReportingDB_DXB].[dbo].[Flight]
where MarketingCarrier not in ('EK', 'FZ') 


select  [MarketingCarrier], count(*)
from [CussReportingDB_DXB].[dbo].[Flight]
group by [MarketingCarrier]