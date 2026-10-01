select   [ABDStationID],
      cast(max([Date]) as date) as ABD_Reached_Date_Short,
	  max([Date]) as ABD_Reached_Date
FROM ABDAvailability  INNER JOIN AbdStation on ABDAvailability.[ABDStationID] = AbdStation.ID
group by [ABDStationID]
order by   max([Date]) desc


declare @TempABDAvailability TABLE
(	   
	ABDStationID int,
	ABD_Reached_Date_Short datetime,
	ABD_Reached_Date datetime
)

insert into @TempABDAvailability
select   [ABDStationID],
      cast(max([Date]) as date) as ABD_Reached_Date_Short,
	  max([Date]) as ABD_Reached_Date
FROM ABDAvailability  INNER JOIN AbdStation on ABDAvailability.[ABDStationID] = AbdStation.ID
group by [ABDStationID]
order by   max([Date]) desc

declare @TempABDAvailabilityABDs TABLE
(	   
	ABDStationID int,
	ABD_Reached_Date_Short datetime,
	TotalCount int
)
insert into @TempABDAvailabilityABDs
select ABDStationID, ABD_Reached_Date_Short, count(*) from @TempABDAvailability
group by ABDStationID, ABD_Reached_Date_Short

select a. ABDStationID, b.* from @TempABDAvailabilityABDs a inner join AbdStation b on a.ABDStationID = b.ID

