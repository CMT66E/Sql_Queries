  USE [CUSSBagDropDB_NRT]
  GO

  declare @CheckingStartDate DateTime = '2026-01-01 00:00:00 AM'
  declare @CheckingEndDate DateTime = '2026-07-01 00:00:00 AM'
  
  SELECT  
      FORMAT([LocalCreationTime], 'yyyy-MM') AS YearMonth,
      count(ID) as TotalRows
  FROM [CUSSBagDropDB_NRT].[dbo].[CustomerSession]
  WHERE  [LocalCreationTime] >= @CheckingStartDate and [LocalCreationTime] < @CheckingEndDate
  GROUP BY FORMAT([LocalCreationTime], 'yyyy-MM')
  order by YearMonth



  SELECT  
      FORMAT([LocalTime], 'yyyy-MM') AS YearMonth,
      count(ID) as TotalRows
  FROM [CUSSBagDropDB_NRT].[dbo].[BagWeightUpdate]
  WHERE  [LocalTime] >= @CheckingStartDate and [LocalTime] < @CheckingEndDate
  GROUP BY FORMAT([LocalTime], 'yyyy-MM')
  order by YearMonth
 
