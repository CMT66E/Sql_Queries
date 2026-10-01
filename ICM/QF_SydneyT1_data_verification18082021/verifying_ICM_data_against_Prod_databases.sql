--ICM all data records are in QF datasheet
SELECT [CustomerSessionID]
      ,[BagID]
      ,[LocalTime]
      ,[ABDStation]
      ,[TransactionTime]
      ,[MarketingCarrier]
      ,[FlightNumber]
      ,[PNR]
      ,[SessionDuration]
      ,[BagCount]
      ,[UtcCreationTime]
      ,[UtcCompletionTime]
      ,[Weight]
      ,[IsHeavyBag]
  FROM [ReportingDB].[dbo].[CustomerSessionQuantasData] --total 5454 rows 
  WHERE NOT PNR in 
  (
    SELECT [PNR_REF]
  FROM [CUSSReportingDB].[dbo].[QantasMay2021DataSheet]
  )
------------------------------------------------------------------------------------------------------------------
--Possible ICM missed 803 checked_in bag on its report???
  SELECT * 
  FROM [CUSSReportingDB].[dbo].[QantasMay2021DataSheet]
  WHERE not [PNR_REF] is null and datePart(year, [ACTIVITY_TSMP_UT+10]) = 2021 and datePart(month, [ACTIVITY_TSMP_UT+10]) = 5 and NOT PNR_REF IN 
  (
  SELECT [PNR]      
  FROM [ReportingDB].[dbo].[CustomerSessionQuantasData]
  )
------------------------------------------------------------------------------------------------------------------



 -- where PNR ='6MUHZL' or PNR = '5EG29Y'
 --select * from BagWeightUpdate where BagID in (1959387, 1959388)
 --select * from CustomerSession where PNR in ('5EG29Y', '66YFZU')

 --select * from BagWeightUpdate where CustomerSessionID in (1580425, 1580427)