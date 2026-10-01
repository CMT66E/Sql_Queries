USE [CUSSBagDropDB_NRT]
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


------------------------------------------------------------------

select * from AbdModeHistory where AbdStationId in
(
select ABDStationID from @MyTable
)

select * from AbdStateHistory where AbdStationId in
(
select ABDStationID from @MyTable
)

select * from AbdWayfinderStateHistory where AbdStationId in
(
select ABDStationID from @MyTable
)

select * from BagRejectionLog where AbdStationId in
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

select * from CustomerSession where AbdStationId in
(
  select ABDStationID from @MyTable
)

select * from ApplicationSession where CussSessionId IN
(
		select CussSessionID from CussSession where AbdStationId in
		(
		select ABDStationID from @MyTable
		)
)

select * from CustomerSession where ApplicationSessionId in
(
	select ApplicationSessionId from ApplicationSession where CussSessionId IN
	(
			select CussSessionID from CussSession where AbdStationId in
			(
			select ABDStationID from @MyTable
			)
	)
)

select * from CussSession where AbdStationId in
(
select ABDStationID from @MyTable
)

select * from PaperTagReadLog where AbdStationId in
(
 select ABDStationID from @MyTable
)

select * from AbdStation where ID in
(
select ABDStationID from @MyTable
)
 