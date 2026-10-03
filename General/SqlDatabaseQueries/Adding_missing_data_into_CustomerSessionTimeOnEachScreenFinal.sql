USE [ReportingDB_NRT]
GO

INSERT INTO [dbo].[CustomerSessionTimeOnEachScreen]
SELECT [ID]
      ,[CustomerSessionID]
      ,[PageTypeID]
      ,[StepNo]
      ,[Duration]
      ,[PaxActionID]
      ,[OrdinalNo]
      ,[MachineTime]
      ,[PaxTime]
      ,[DcsTime]
      ,[BhsTime]
      ,[CsaTime]
FROM [BagDropDB_NRT].[dbo].[CustomerSessionTimeOnEachScreen]
WHERE ID > (SELECT max([ID]) FROM [ReportingDB_NRT].[dbo].[CustomerSessionTimeOnEachScreen])
order by ID desc