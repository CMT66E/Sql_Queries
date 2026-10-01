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
	105,
	106,
	107
)

delete from AbdModeHistory where AbdStationId in
(
select ABDStationID from @MyTable
)

delete from AbdStateHistory where AbdStationId in
(
select ABDStationID from @MyTable
)

delete from AbdWayfinderStateHistory where AbdStationId in
(
select ABDStationID from @MyTable
)

delete from PaperTagReadLog where AbdStationId in
(
 select ABDStationID from @MyTable
)

delete  from BagWeightUpdate where CustomerSessionID in
(
	select ID from CustomerSession where AbdStationId in
	(
	  select ABDStationID from @MyTable
	)
)

delete from CustomerSession where AbdStationId in
(
  select ABDStationID from @MyTable
)

delete from ApplicationSession where CussSessionId IN
(
		select CussSessionID from CussSession where AbdStationId in
		(
		select ABDStationID from @MyTable
		)
)

delete from CussSession where AbdStationId in
(
select ABDStationID from @MyTable
)

delete from AbdStation where ID in
(
select ABDStationID from @MyTable
)