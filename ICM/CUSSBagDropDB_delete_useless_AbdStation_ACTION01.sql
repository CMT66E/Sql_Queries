USE [CUSSBagDropDB_LHR]
GO

	--select DISTINCT AbdStationID from [dbo].[CustomerSession]
	--where LocalTime >= '2021-01-01'

DECLARE @MyTable TABLE
	(
	SNo int IDENTITY(1,1), 
	ABDStationID int
	) 
insert into @MyTable(ABDStationID)
select DISTINCT AbdStationID from [CustomerSession]
where LocalCreationTime >= '2021-01-01'
order by AbdStationID

select * from @MyTable


--select * from AbdModeHistory where NOT AbdStationId in
--(
--select ABDStationID from @MyTable
--)

--select * from AbdStateHistory where NOT AbdStationId in
--(
--select ABDStationID from @MyTable
--)

--select * from AbdWayfinderStateHistory where NOT AbdStationId in
--(
--select ABDStationID from @MyTable
--)

--select * from BagRejectionLog where NOT AbdStationId in
--(
--select ABDStationID from @MyTable
--)


--select * from ApplicationSession where CussSessionId IN
--(
--		select CussSessionID from CussSession where NOT AbdStationId in
--		(
--		select ABDStationID from @MyTable
--		)
--)

--select * from CussSession where NOT AbdStationId in
--(
--select ABDStationID from @MyTable
--)

--select * from BagWeightUpdate where CustomerSessionID in
--(
--	select ID from CustomerSession where NOT AbdStationId in
--	(
--	  select ABDStationID from @MyTable
--	)
--)



--select * from CustomerSession where ApplicationSessionId in
--(
--	select ApplicationSessionId from ApplicationSession where CussSessionId IN
--	(
--			select CussSessionID from CussSession where NOT AbdStationId in
--			(
--			select ABDStationID from @MyTable
--			)
--	)
--)

--select * from CustomerSession where NOT AbdStationId in
--(
--  select ABDStationID from @MyTable
--)


--delete from AbdStation where NOT ID in
--(
--select ABDStationID from @MyTable
--)

----------------------------------------------------------------------------------------
delete from AbdModeHistory where NOT AbdStationId in
(
select ABDStationID from @MyTable
)

delete from AbdStateHistory where NOT AbdStationId in
(
select ABDStationID from @MyTable
)

delete from AbdWayfinderStateHistory where NOT AbdStationId in
(
select ABDStationID from @MyTable
)

delete from BagRejectionLog where NOT AbdStationId in
(
select ABDStationID from @MyTable
)

delete from CustomerSession where ApplicationSessionId in
(
	select ApplicationSessionId from ApplicationSession where CussSessionId IN
	(
			select CussSessionID from CussSession where NOT AbdStationId in
			(
			select ABDStationID from @MyTable
			)
	)
)

delete from CustomerSession where NOT AbdStationId in
(
  select ABDStationID from @MyTable
)

delete from ApplicationSession where CussSessionId IN
(
		select CussSessionID from CussSession where NOT AbdStationId in
		(
		select ABDStationID from @MyTable
		)
)


delete from CussSession where NOT AbdStationId in
(
select ABDStationID from @MyTable
)

delete  from BagWeightUpdate where CustomerSessionID in
(
	select ID from CustomerSession where NOT AbdStationId in
	(
	  select ABDStationID from @MyTable
	)
)


delete from AbdStation where NOT ID in
(
select ABDStationID from @MyTable
)
 