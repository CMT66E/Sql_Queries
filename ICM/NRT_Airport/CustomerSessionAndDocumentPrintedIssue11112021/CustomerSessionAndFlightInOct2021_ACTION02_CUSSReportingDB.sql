 
select a.*, c.*, b.* from 
[dbo].[CustomerSession] a 
inner join Flight b on a.FlightID = b.ID
inner join AbdStation c on a.AbdStationID = c.ID
where datepart(year, LocalTime) = 2021 and datepart(month, LocalTime) = 10 and datepart(day, LocalTime) = 31 
and AbdStationId = 136