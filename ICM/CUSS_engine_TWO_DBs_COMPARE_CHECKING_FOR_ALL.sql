select count(*) FROM [CUSSBagDropDB_NRT].[dbo].[ApplicationSession]
--select '-----seperate line-----'  
-------------------------------------------------------------------------- 
select count(*) FROM [CUSSBagDropDB_NRT].[dbo].[AbdStateHistory]
select count(*) FROM [CUSSReportingDB_NRT].[dbo].[AbdStateHistory] 
--select '-----seperate line-----'  
--------------------------------------------------------------------------
select count(*) FROM [CUSSBagDropDB_NRT].[dbo].[CustomerSession]
select count(*) FROM [CUSSReportingDB_NRT].[dbo].[CustomerSession] 
--select '-----seperate line-----'  
--------------------------------------------------------------------------
select count(*) FROM [CUSSBagDropDB_NRT].[dbo].[BagWeightUpdate]
select count(*) FROM [CUSSReportingDB_NRT].[dbo].[BagWeightUpdate] 
--select '-----seperate line-----'  
--------------------------------------------------------------------------
select count(*) as Count_BagWeightUpdate FROM [CUSSBagDropDB_NRT].[dbo].[BagWeightUpdate]
select count(*) as Count_BagWeightUpdate FROM [CUSSReportingDB_NRT].[dbo].[BagWeightUpdate] 
--select '-------------------------'  
--------------------------------------------------------------------------
select count(*) as Count_ApplicationSessionUsage FROM [CUSSReportingDB_NRT].[dbo].[ApplicationSessionUsage]          --3415880
select count(*) as Count_ApplicationSessionUsageProcess FROM [CUSSReportingDB_NRT].[dbo].[ApplicationSessionUsageProcess]   --603248 stoppped on 603900
--------------------------------------------------------------------------

--------------------------------------------------------------------------

--------------------------------------------------------------------------