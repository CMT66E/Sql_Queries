USE [CUSSReportingDB_NRT]
GO

DECLARE @MyTable TABLE
(
	SNo int IDENTITY(1,1), 
	AbdStationID int
) 

insert into @MyTable(AbdStationID)
SELECT   [ID]
FROM [AbdStation]
where ID in
(
	1,
	2,
	3,
	4, 
	5, 
	6,
	7, 
	8,
	9,
	10,
	12,
	13,
	11,
	14,
	15,
	17,
	16,
	18,
	19,
	101,
	103,
	102,
	104,
	109,
	106,
	107
)

delete from AbdStation where ID in
(
select ABDStationID from @MyTable
)