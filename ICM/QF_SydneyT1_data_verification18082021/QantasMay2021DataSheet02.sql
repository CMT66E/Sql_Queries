
select * from [CUSSReportingDB].[dbo].CustomerSession
where PNR in
(
	  SELECT [PNR_REF] 
	  FROM [CUSSReportingDB].[dbo].[QantasMay2021DataSheet]
	  WHERE not [PNR_REF] is null and NOT PNR_REF IN 
	  (
	  SELECT [PNR]      
	  FROM [ReportingDB].[dbo].[CustomerSessionQuantasData]
	  )
)


select * from [ReportingDB].[dbo].CustomerSession
where PNR in
(
	  SELECT [PNR_REF] 
	  FROM [CUSSReportingDB].[dbo].[QantasMay2021DataSheet]
	  WHERE not [PNR_REF] is null and NOT PNR_REF IN 
	  (
	  SELECT [PNR]      
	  FROM [ReportingDB].[dbo].[CustomerSessionQuantasData]
	  )
)