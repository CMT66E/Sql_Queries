SELECT * FROM [ReportingDB_NRT].[dbo].[ABDAvailability]
WHERE [Date] = (SELECT distinct max([Date]) as MaxDate 
FROM [ReportingDB_NRT].[dbo].[ABDAvailability]
group by [AbdStationID])

DROP TABLE IF EXISTS #TempABDStationMaxDate;
CREATE TABLE #TempABDStationMaxDate (
    AbdStationID INT,
    MaxDate  DateTime
);

insert into #TempABDStationMaxDate(AbdStationID, MaxDate)
SELECT  [AbdStationID], max([Date]) as MaxDate 
FROM [ReportingDB_NRT].[dbo].[ABDAvailability]
group by [AbdStationID]

select * from #TempABDStationMaxDate



select * 
FROM [ReportingDB_NRT].[dbo].[ABDAvailability] a inner join #TempABDStationMaxDate b on a.ABDStationID = b.AbdStationID and [Date] = b.MaxDate
--WHERE b.MaxDate = '2026-04-01 00:00:00.000'

--update a
--set a.[Date] = '2026-05-01 00:00:00.000'
--from [ReportingDB_NRT].[dbo].[ABDAvailability] a inner join #TempABDStationMaxDate b on a.ABDStationID = b.AbdStationID and [Date] = b.MaxDate
--WHERE b.MaxDate = '2026-04-01 00:00:00.000'


 