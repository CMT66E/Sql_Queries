--we get all those AbdStations which have no records in year 2022

USE [CUSSBagDropDB_NRT]
GO

DECLARE @MyTable TABLE
(
	SNo int IDENTITY(1,1), 
	AbdStationID int
) 

insert into @MyTable(AbdStationID)
SELECT   b.[ID]
FROM CustomerSession a inner join [AbdStation] b on a.AbdStationID = b.ID
WHERE DATEPART(year, LocalCreationTime) = 2022


select * from AbdStation where not ID in 
(
select AbdStationID from @MyTable
)