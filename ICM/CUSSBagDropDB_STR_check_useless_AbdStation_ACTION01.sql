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
print 'Total AbdStation records which PortCode is PRN: 162'
----------------------------------------------------------------------------------------
select * from AbdModeHistory where AbdStationId in
(
select ABDStationID from @MyTable
)
print 'Total AbdModeHistory records which PortCode is PRN: 0'

select * from AbdStateHistory where AbdStationId in
(
select ABDStationID from @MyTable
)
print 'Total AbdStateHistory records which linked AbdStation PortCode is PRN: 5963'

select * from AbdWayfinderStateHistory where AbdStationId in
(
select ABDStationID from @MyTable
)
print 'Total AbdWayfinderStateHistory records which linked AbdStation PortCode is PRN: 5963'

select * from BagRejectionLog where AbdStationId in
(
select ABDStationID from @MyTable
)
print 'Total BagRejectionLog records which linked AbdStation PortCode is PRN: 0'

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
print 'Total CustomerSession records which linked AbdStation PortCode is PRN: 153'

select * from BagWeightUpdate where CustomerSessionID in
(
	select ID from CustomerSession where AbdStationId in
	(
	  select ABDStationID from @MyTable
	)
)
print 'Total BagWeightUpdate records which linked AbdStation PortCode is PRN: 8'

select * from CustomerSession where AbdStationId in
(
  select ABDStationID from @MyTable
)
print 'Total CustomerSession records which linked AbdStation PortCode is PRN: 153'

select * from ApplicationSession where CussSessionId IN
(
		select CussSessionID from CussSession where AbdStationId in
		(
		select ABDStationID from @MyTable
		)
)
print 'Total ApplicationSession records which linked AbdStation PortCode is PRN: 183'

select * from CussSession where AbdStationId in
(
select ABDStationID from @MyTable
)
print 'Total CussSession records which linked AbdStation PortCode is PRN: 126'

select *  from BagWeightUpdate where CustomerSessionID in
(
	select ID from CustomerSession where AbdStationId in
	(
	  select ABDStationID from @MyTable
	)
)
print 'Total BagWeightUpdate records which linked AbdStation PortCode is PRN: 8'

select * from AbdStation where ID in
(
select ABDStationID from @MyTable
)
print 'Total AbdStation records which linked AbdStation PortCode is PRN: 162'