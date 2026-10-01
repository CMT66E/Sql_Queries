USE [CUSSBagDropDB_STR]
GO
 

DECLARE @MyTable TABLE
	(
	SNo int IDENTITY(1,1), 
	ABDStationID int
	) 
insert into @MyTable(ABDStationID)
select DISTINCT ID from [AbdStation]
where PortCode = 'PRN'
order by ID

select * from @MyTable

----------------------------------------------------------------------------------------
--AbdModeHistory : delete PRN AbdStation linked data if there is any
delete from AbdModeHistory where AbdStationId in
(
select ABDStationID from @MyTable
)

--AbdStateHistory : delete PRN AbdStation linked data if there is any
delete from AbdStateHistory where AbdStationId in
(
select ABDStationID from @MyTable
)

--AbdWayfinderStateHistory : delete PRN AbdStation linked data if there is any
delete from AbdWayfinderStateHistory where AbdStationId in
(
select ABDStationID from @MyTable
)

--BagRejectionLog : delete PRN AbdStation linked data if there is any
delete from BagRejectionLog where AbdStationId in
(
select ABDStationID from @MyTable
)

--BagWeightUpdate : delete PRN AbdStation linked data if there is any
delete from BagWeightUpdate where CustomerSessionID in
(
	select ID from CustomerSession where AbdStationId in
	(
	  select ABDStationID from @MyTable
	)
)

--CustomerSession : delete ApplicationSessionId linked data which created by PRN AbdStation linked data if there is any
delete from CustomerSession where ApplicationSessionId in
(
	select ApplicationSessionId from ApplicationSession where CussSessionId IN
	(
			select CussSessionID from CussSession where AbdStationId in
			(
			select ABDStationID from @MyTable
			)
	)
)

--CustomerSession : delete PRN AbdStation linked data if there is any
delete from CustomerSession where AbdStationId in
(
  select ABDStationID from @MyTable
)

--ApplicationSession : delete PRN AbdStation linked data if there is any
delete from ApplicationSession where CussSessionId IN
(
		select CussSessionID from CussSession where AbdStationId in
		(
		select ABDStationID from @MyTable
		)
)

--CussSession : delete PRN AbdStation linked data if there is any
delete from CussSession where AbdStationId in
(
select ABDStationID from @MyTable
)

--BagWeightUpdate : delete PRN AbdStation linked data if there is any
delete  from BagWeightUpdate where CustomerSessionID in
(
	select ID from CustomerSession where AbdStationId in
	(
	  select ABDStationID from @MyTable
	)
)

--AbdStation : delete PRN AbdStation linked data if there is any
delete from AbdStation where ID in
(
select ABDStationID from @MyTable
)
 