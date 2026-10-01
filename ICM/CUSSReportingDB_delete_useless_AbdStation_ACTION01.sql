

	--select DISTINCT AbdStationID from [dbo].[CustomerSession]
	--where LocalTime >= '2021-01-01'

DECLARE @MyTable TABLE
	(
	SNo int IDENTITY(1,1), 
	ABDStationID int
	) 
insert into @MyTable(ABDStationID)
select DISTINCT AbdStationID from [CUSSReportingDB_LHR].[dbo].[CustomerSession]
where LocalTime >= '2021-01-01'
order by AbdStationID

select * from @MyTable

--delete from AbdStation where NOT ID in
--(
--select ABDStationID from @MyTable
--)

 