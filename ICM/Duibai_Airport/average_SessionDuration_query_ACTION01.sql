/****** Script for SelectTopNRows command from SSMS  ******/
SELECT AVG(SessionDuration) as AverageSessionDuration, cast(LocalTime as date) as DateList
FROM [CussReportingDB_DXB].[dbo].[CustomerSession]
group by cast(LocalTime as date)  
order by cast(LocalTime as date) 
 