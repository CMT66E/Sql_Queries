  --------------------------customer--------------------------
  --select * from OWT_Customer_BK
  --where CustomerID in (select CustomerID from OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=OWT_RW;PWD=rw2owT').[WDS].[dbo].[Customer])

  --select * from OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=OWT_RW;PWD=rw2owT').[WDS].[dbo].[Customer]
  --where CustomerID in (select CustomerID from OWT_Customer_BK)

  --Finally we can reset all import data from [WDS].[dbo].[Customer] as following
  update Table_A 
  set Table_A.PALMSAccountablePartyID = null
  from OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=OWT_RW;PWD=rw2owT').[WDS].[dbo].[Customer] Table_A
  where Table_A.CustomerID in
  (
     select CustomerID from OWT_Customer_BK
  )

  --------------------------site------------------------------
  --select * from OWT_Site_BK where SiteID in (select SiteID from OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=OWT_RW;PWD=rw2owT').[WDS].[dbo].[Site])
  --select SiteID, * from OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=OWT_RW;PWD=rw2owT').[WDS].[dbo].[Site]
  --where SiteID in (select SiteID from OWT_Site_BK) 

  --Finally we can reset all import data from [WDS].[dbo].[Site] as following
  update Table_A 
  set Table_A.PALMSLocationID = null
  from OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=OWT_RW;PWD=rw2owT').[WDS].[dbo].[Site] Table_A
  where Table_A.SiteID in
  (
     select SiteID from OWT_Site_BK
  )