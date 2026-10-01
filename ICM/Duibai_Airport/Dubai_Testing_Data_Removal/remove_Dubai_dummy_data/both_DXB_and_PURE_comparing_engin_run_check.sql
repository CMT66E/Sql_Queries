

/****** Script for SelectTopNRows command from SSMS  ******/
select count(*) FROM [CussReportingDB_DXB].[dbo].[ApplicationSessionUsage]            --496800
select count(*) FROM [CussReportingDB_DXB].[dbo].[ApplicationSessionUsageProcess]     --332847
select count(*) FROM [CussReportingDB_DXB].[dbo].[ABDAvailability]                    --1100496
select count(*) FROM [CussReportingDB_DXB].[dbo].[AbdStateHistory]                    --51905
select * from [CussReportingDB_DXB].[dbo].[AbdStateHistory] where AbdStationID not in (select ID from [CussReportingDB_DXB].[dbo].[AbdStation]) --2901
            

select count(*) FROM [CussReportingDB_DXB_PURE].[dbo].[ApplicationSessionUsage]       --43200
select count(*) FROM [CussReportingDB_DXB_PURE].[dbo].[ApplicationSessionUsageProcess]--332410
select count(*) FROM [CussReportingDB_DXB_PURE].[dbo].[ABDAvailability]               --1098480
select count(*) FROM [CussReportingDB_DXB_PURE].[dbo].[AbdStateHistory]               --49004
select * from [CussReportingDB_DXB_PURE].[dbo].[AbdStateHistory] where AbdStationID not in (select ID from [CussReportingDB_DXB_PURE].[dbo].[AbdStation]) --none records




