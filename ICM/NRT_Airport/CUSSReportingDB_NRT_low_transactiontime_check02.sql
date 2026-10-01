USE CUSSReportingDB_NRT
GO

declare @DeleteDataBeforeThisDate datetime = '2022-09-01' 

select a.*, b.* from CustomerSession a 
left outer join AbdStation b on a.AbdStationID = b.ID
where datepart(year, [LocalTime]) = datepart(year, @DeleteDataBeforeThisDate) and datepart(month, [LocalTime]) = datepart(month, @DeleteDataBeforeThisDate)
and b.Terminal in ('2')
and b.AbdType = 'KSK'
order by SessionDuration desc

select distinct b.KioskName from CustomerSession a 
left outer join AbdStation b on a.AbdStationID = b.ID
where datepart(year, [LocalTime]) = datepart(year, @DeleteDataBeforeThisDate) and datepart(month, [LocalTime]) = datepart(month, @DeleteDataBeforeThisDate)
and b.Terminal in ('2')
and b.AbdType = 'KSK'
 
select b.KioskName, avg(a.SessionDuration) as AvgTranscation from CustomerSession a 
left outer join AbdStation b on a.AbdStationID = b.ID
where datepart(year, [LocalTime]) = datepart(year, @DeleteDataBeforeThisDate) and datepart(month, [LocalTime]) = datepart(month, @DeleteDataBeforeThisDate)
and b.Terminal in ('2')
and b.AbdType = 'KSK'
and a.SessionDuration > 45
group by b.KioskName 
order by b.KioskName 

select a.*, b.* from CustomerSession a 
left outer join AbdStation b on a.AbdStationID = b.ID
where datepart(year, [LocalTime]) = datepart(year, @DeleteDataBeforeThisDate) and datepart(month, [LocalTime]) = datepart(month, @DeleteDataBeforeThisDate)
and b.Terminal in ('2')
and b.AbdType = 'KSK'
and a.SessionDuration <= 45
-----------19% <= 45 -----------------------

--select a.*, b.* from CustomerSession a 
--left outer join AbdStation b on a.AbdStationID = b.ID
--where datepart(year, [LocalTime]) = datepart(year, @DeleteDataBeforeThisDate) and datepart(month, [LocalTime]) = datepart(month, @DeleteDataBeforeThisDate)
--and b.Terminal in ('NRT2')
----and b.AbdType = 'KSK'
--order by SessionDuration desc