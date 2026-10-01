 
SELECT [ID]
      ,[PaperTagReadStepID]
      ,[AbdStationID]
      ,[UtcLogTime]
      ,[LocalLogTime]
      ,[WasReadSuccessful]
  FROM [CussReportingDB_DXB].[dbo].[PaperTagReadLog]
WHERE DATEPART(year, LocalLogTime) = 2021 and DATEPART(month, LocalLogTime) = 9 and WasReadSuccessful = 0 -- 59301 records 
                                                                                                          -- WasReadSuccessful = 1 case: 58608 we only count successful read 
																										  -- WasReadSuccessful = 0 case: 693 records which we don't count them at all

select distinct [AbdStationID] FROM [CussReportingDB_DXB].[dbo].[PaperTagReadLog]
WHERE DATEPART(year, LocalLogTime) = 2021 and DATEPART(month, LocalLogTime) = 9 -- 36 ABDs

SELECT [ID]
      ,[PaperTagReadStepID]
      ,[AbdStationID]
      ,[UtcLogTime]
      ,[LocalLogTime]
      ,[WasReadSuccessful]
  FROM [CussReportingDB_DXB].[dbo].[PaperTagReadLog]
WHERE DATEPART(year, LocalLogTime) = 2021 and DATEPART(month, LocalLogTime) = 8 -- 31525 records
select distinct [AbdStationID] FROM [CussReportingDB_DXB].[dbo].[PaperTagReadLog]
WHERE DATEPART(year, LocalLogTime) = 2021 and DATEPART(month, LocalLogTime) = 8 -- 11 ABDs

SELECT [ID]
      ,[PaperTagReadStepID]
      ,[AbdStationID]
      ,[UtcLogTime]
      ,[LocalLogTime]
      ,[WasReadSuccessful]
  FROM [CussReportingDB_DXB].[dbo].[PaperTagReadLog]
WHERE DATEPART(year, LocalLogTime) = 2021 and DATEPART(month, LocalLogTime) = 7 -- 37978 records
select distinct [AbdStationID] FROM [CussReportingDB_DXB].[dbo].[PaperTagReadLog]
WHERE DATEPART(year, LocalLogTime) = 2021 and DATEPART(month, LocalLogTime) = 7 -- 8 ABDs

SELECT [ID]
      ,[PaperTagReadStepID]
      ,[AbdStationID]
      ,[UtcLogTime]
      ,[LocalLogTime]
      ,[WasReadSuccessful]
  FROM [CussReportingDB_DXB].[dbo].[PaperTagReadLog]
WHERE DATEPART(year, LocalLogTime) = 2021 and DATEPART(month, LocalLogTime) = 6 ---- 27852 records
select distinct [AbdStationID] FROM [CussReportingDB_DXB].[dbo].[PaperTagReadLog]
WHERE DATEPART(year, LocalLogTime) = 2021 and DATEPART(month, LocalLogTime) = 6 -- 8 ABDs

SELECT [ID]
      ,[PaperTagReadStepID]
      ,[AbdStationID]
      ,[UtcLogTime]
      ,[LocalLogTime]
      ,[WasReadSuccessful]
  FROM [CussReportingDB_DXB].[dbo].[PaperTagReadLog]
WHERE DATEPART(year, LocalLogTime) = 2021 and DATEPART(month, LocalLogTime) = 5 -- 22602 records
select distinct [AbdStationID] FROM [CussReportingDB_DXB].[dbo].[PaperTagReadLog]
WHERE DATEPART(year, LocalLogTime) = 2021 and DATEPART(month, LocalLogTime) = 5 -- 30 ABDs

SELECT [ID]
      ,[PaperTagReadStepID]
      ,[AbdStationID]
      ,[UtcLogTime]
      ,[LocalLogTime]
      ,[WasReadSuccessful]
  FROM [CussReportingDB_DXB].[dbo].[PaperTagReadLog]
WHERE DATEPART(year, LocalLogTime) = 2021 and DATEPART(month, LocalLogTime) = 4 -- 9320 records
select distinct [AbdStationID] FROM [CussReportingDB_DXB].[dbo].[PaperTagReadLog]
WHERE DATEPART(year, LocalLogTime) = 2021 and DATEPART(month, LocalLogTime) = 4 -- 4 ABDs

SELECT [ID]
      ,[PaperTagReadStepID]
      ,[AbdStationID]
      ,[UtcLogTime]
      ,[LocalLogTime]
      ,[WasReadSuccessful]
FROM [CussReportingDB_DXB].[dbo].[PaperTagReadLog]
WHERE DATEPART(year, LocalLogTime) = 2021 and DATEPART(month, LocalLogTime) = 3 -- no records
select distinct [AbdStationID] FROM [CussReportingDB_DXB].[dbo].[PaperTagReadLog]
WHERE DATEPART(year, LocalLogTime) = 2021 and DATEPART(month, LocalLogTime) = 3 -- no ABDs