SET IDENTITY_INSERT [ReportingDB_NRT].[dbo].[FrequentFlyer] ON;

insert into [ReportingDB_NRT].[dbo].[FrequentFlyer]
(
       [ID]
      ,[CustomerSessionID]
      ,[Carrier]
      ,[Number]
      ,[CmTierCode]
      ,[AirlinePriority]
      ,[Description]
      ,[DoNotPrintInReceipt]
)
select *
FROM [BagDropDB_NRT].[dbo].[FrequentFlyer] 
where ID > (SELECT Max(ID) 
  FROM [ReportingDB_NRT].[dbo].[FrequentFlyer])

SET IDENTITY_INSERT [ReportingDB_NRT].[dbo].[FrequentFlyer] Off;