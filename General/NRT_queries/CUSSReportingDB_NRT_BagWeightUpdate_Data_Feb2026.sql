USE CUSSReportingDB_NRT
GO

declare @FromDateTime DateTime = '2026/02/24 00:00:00 AM'

select * from [CUSSReportingDB_NRT].dbo.BagWeightUpdate a 
inner join [CUSSReportingDB_NRT].dbo.CustomerSession b on a.CustomerSessionID = b.ID
inner join [CUSSReportingDB_NRT].dbo.Flight c on b.FlightID = c.ID
where c.MarketingCarrier ='GK' and 
DATEPART(year, a.LocalTime) = DATEPART(year, @FromDateTime) and 
DATEPART(month, a.LocalTime) = DATEPART(month, @FromDateTime) and 
DATEPART(day, a.LocalTime) = DATEPART(day, @FromDateTime)



