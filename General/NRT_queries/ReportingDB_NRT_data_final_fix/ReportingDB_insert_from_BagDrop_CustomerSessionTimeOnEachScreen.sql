USE [ReportingDB_NRT]  -- for 4,270,430 records needs 1:14 minutes
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