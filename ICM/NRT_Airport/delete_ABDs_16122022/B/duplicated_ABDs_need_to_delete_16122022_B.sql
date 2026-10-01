/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [ID]
      ,[PortCode]
      ,[Identifier]
      ,[AbdType]
      ,[Terminal]
      ,[KioskName]
      ,[Zone]
      ,[Area]
      ,[SubArea]
  FROM [CUSSBagDropDB_NRT].[dbo].[AbdStation]
  where KioskName in 
  (
'NRTT1SABD15',
'NRTT1SABD14',
'NRTT1SABD17',
'NRTT1SABD16',
'NRTT1SABD20',
'NRTT1SABD23',
'NRTT1SABD22',
'NRTT1SABD18',
'NRTT1SABD21',
'NRTT1SABD19'
  )