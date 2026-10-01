SELECT DISTINCT [ROW_ID]
      ,[TRAVLR_UCI]
      ,[PNR_REF]
      ,[FLIGHT_NO]
      ,[LOCLDEPD]
      ,[DEPUPOR]
      ,[BAG_UBI_ID]
      ,[HIST_TRANS_ID]
      ,[BAG_TAG]
      ,[Q_BAG_TAG_ID]
      ,[OFFICE_ID]
      ,[USER_SONIC_ID]
      ,[HIST_CATG_CODE]
      ,[HIST_SUB_CAT_CODE]
      ,[SERVICE_REF]
      ,[BAG_WGT]
      ,[BAG_WGT_UOM]
      ,[TRANS_SEQ_NO]
      ,[ACTIVITY_TSMP]
      ,[ACTIVITY_TSMP_UT+10]
      ,[F20]
  FROM [CUSSReportingDB].[dbo].[QantasMay2021DataSheet]
  WHERE (datepart(year, [ACTIVITY_TSMP_UT+10]) = 2021 and datepart(month, [ACTIVITY_TSMP_UT+10]) = 5)
  and not [BAG_UBI_ID] is null
  --and [PNR_REF] is null

SELECT DISTINCT  
      [BAG_UBI_ID]
      
  FROM [CUSSReportingDB].[dbo].[QantasMay2021DataSheet]
  WHERE (datepart(year, [ACTIVITY_TSMP_UT+10]) = 2021 and datepart(month, [ACTIVITY_TSMP_UT+10]) = 5)
  and not [BAG_UBI_ID] is null
  --and [PNR_REF] is null


  SELECT  COUNT([BAG_UBI_ID]) as RecCount,  
      [BAG_UBI_ID]
      
  FROM [CUSSReportingDB].[dbo].[QantasMay2021DataSheet]
  WHERE (datepart(year, [ACTIVITY_TSMP_UT+10]) = 2021 and datepart(month, [ACTIVITY_TSMP_UT+10]) = 5)
  and not [BAG_UBI_ID] is null
  group by [BAG_UBI_ID]
  having COUNT([BAG_UBI_ID]) > 1

  select * from [CUSSReportingDB].[dbo].[QantasMay2021DataSheet] WHERE [BAG_UBI_ID] in ('10CAC200256F814B', '10CAC200257E4159') order by [BAG_UBI_ID]