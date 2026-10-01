/****** Script for SelectTopNRows command from SSMS  ******/

SELECT distinct [AbdStationID] into #TempAbdStation     
FROM [CUSSReportingDB_CDG].[dbo].[CustomerSession]
WHERE datepart(year, localTime) = 2021

delete from AbdStation where not ID in 
(
select [AbdStationID] from #TempAbdStation     
)

--select * from AbdStation