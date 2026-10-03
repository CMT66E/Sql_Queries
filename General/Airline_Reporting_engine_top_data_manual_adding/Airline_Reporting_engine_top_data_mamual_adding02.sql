SELECT TOP (10) *
  FROM [BagDropDB_SIN].[dbo].[PaperTagReadScanner]
  order by ID desc

SELECT TOP (10) *
  FROM [ReportingDB_SIN_APR2026].[dbo].[PaperTagReadScanner]
  order by ID desc

-------------------------------
 --these two ok
SELECT TOP (10) *
  FROM [BagDropDB_SIN].[dbo].[ClvScannerType]
  order by ID desc


SELECT TOP (10) *
  FROM [ReportingDB_SIN_APR2026].[dbo].[ClvScannerType]
  order by ID desc
-------------------------------
SELECT TOP (10) *
  FROM [BagDropDB_SIN].[dbo].[PaperTagReadLog]
  order by ID desc


SELECT TOP (10) *
  FROM [ReportingDB_SIN].[dbo].[PaperTagReadLog]
  order by ID desc

-------------------------------

SELECT TOP (10) *
  FROM [BagDropDB_SIN].[dbo].[HeavyTagReadSuccessData]
  order by ID desc

SELECT TOP (10) *
  FROM [ReportingDB_SIN].[dbo].[HeavyTagReadSuccessData]
  order by ID desc
 ------------------------------- 
 --these two ok
SELECT TOP (10) *
  FROM [BagDropDB_SIN].[dbo].[HeavyTagReadStep]
  order by ID desc
  

SELECT TOP (10) *
  FROM [ReportingDB_SIN].[dbo].[HeavyTagReadStep]
  order by ID desc
  