/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [CustomerSessionID]
      ,[BagID]	  
      ,[LocalTime]
      ,[ABDStation]
      ,[TransactionTime]
      ,[MarketingCarrier]
      ,[FlightNumber]
      ,[PNR]
	  ,b.UBI
      ,[SessionDuration]
      ,[BagCount]
      ,[UtcCreationTime]
      ,[UtcCompletionTime]
      ,[Weight]
      ,[IsHeavyBag]
  FROM [ReportingDB].[dbo].[CustomerSessionQuantasData] a inner join Bag b on a.[BagID] = b.ID

  SELECT 
	   a.[PNR], b.UBI, c.BaggageReference     
  FROM [ReportingDB].[dbo].[CustomerSessionQuantasData] a inner join Bag b on a.[BagID] = b.ID inner join [BagDrop].[dbo].[BaggageGroup] c on b.BaggageGroupID = c.ID
 
  select [PNR_REF], [BAG_UBI_ID] from [CUSSReportingDB].[dbo].[QantasMay2021DataSheet]  WHERE [PNR_REF]  in ('5EG29Y', '66YFZU')
  ----------------------------------------------------------------------------------------------------------------
  --UBI: 10CAC200256F7E57
  select * from [BagDrop].[dbo].Bag where ID IN
  (
	  select BagID from [BagDrop].[dbo].BagWeightUpdate where CustomerSessionID in 
	  (
		select ID from [BagDrop].[dbo].CustomerSession where PNR in ('5EG29Y', '66YFZU')
	  )
  )
  --UBI: 10CAC200256F7E57
  select * from [ReportingDB].[dbo].Bag where ID IN
  (
    select BagID from [ReportingDB].[dbo].BagWeightUpdate where CustomerSessionID IN
    (
	  select ID from [ReportingDB].[dbo].CustomerSession where PNR in ('5EG29Y', '66YFZU')
	)
  )
  ----------------------------------------------------------------------------------------------------------------
  --UBI: null value
  select * from [CUSSBagDropDB].[dbo].Bag where ID IN
  (
     select BagID from [CUSSBagDropDB].[dbo].BagWeightUpdate where CustomerSessionID IN
	 (
     select ID from [CUSSBagDropDB].[dbo].CustomerSession where PNR in ('5EG29Y', '66YFZU')
	 )
  )

  --UBI: null value
  select * from [CUSSReportingDB].[dbo].Bag where ID IN
  (
      select BagID from [CUSSReportingDB].[dbo].BagWeightUpdate where CustomerSessionID IN
	  (
		select ID from [CUSSReportingDB].[dbo].CustomerSession where PNR in ('5EG29Y', '66YFZU')
	  )
  )
   ----------------------------------------------------------------------------------------------------------------