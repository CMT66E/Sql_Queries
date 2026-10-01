/****** Script for SelectTopNRows command from SSMS  ******/
SELECT count(*)
  FROM [CussReportingDB_DXB].
  [dbo].[ABDAvailability]

 

 --total 100998 records
  select * from 
  [CussReportingDB_DXB].
  [dbo].[ABDAvailability]
  where AbdStationID not in (select ID from [CussReportingDB_DXB].
  [dbo].AbdStation)

  ----total 100998 records
  --delete from 
  --[CussReportingDB_DXB].
  --[dbo].[ABDAvailability]
  --where AbdStationID not in (select ID from [CussReportingDB_DXB].
  --[dbo].AbdStation)

--total 2901 records
--delete 
--from [dbo].[AbdStateHistory]
--WHERE [AbdStationID] not in (select ID from AbdStation)