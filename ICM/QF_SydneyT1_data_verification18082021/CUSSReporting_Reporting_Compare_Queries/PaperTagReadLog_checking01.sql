/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (10) a.[ID]
      ,[BaggageGroupID]
      ,[UBI]
      ,[BagTagType]
	  ,b.*
  FROM [ReportingDB].[dbo].[Bag] a 
  inner join PaperTagReadScanner b on a.BaggageGroupID = b.ID
  order by [BaggageGroupID] desc

  --select * from PaperTagReadScanner where ID = 1217633
  select * from PaperTagReadSuccessData where PaperTagReadLogID in 
  (
  SELECT TOP (10) b.PaperTagReadLogID 
  FROM [ReportingDB].[dbo].[Bag] a 
  inner join PaperTagReadScanner b on a.BaggageGroupID = b.ID 
  order by [BaggageGroupID] desc
  )

  select BagWeightUpdate.*, CustomerSession.PNR  from BagWeightUpdate inner join CustomerSession on CustomerSessionID = CustomerSession.ID  
  where BagID in
  (
  SELECT TOP (10) a.[ID]     
  FROM [ReportingDB].[dbo].[Bag] a 
  inner join PaperTagReadScanner b on a.BaggageGroupID = b.ID
  order by [BaggageGroupID] desc
  )