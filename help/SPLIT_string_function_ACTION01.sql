declare @Airline nvarchar(25) = ',SQ, MI, TR'

SELECT Items FROM  dbo.Split(@Airline, ',')