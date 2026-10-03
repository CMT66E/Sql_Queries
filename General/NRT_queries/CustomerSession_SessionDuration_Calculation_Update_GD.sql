  Update [ReportingDB_NRT].[dbo].[CustomerSession] set [SessionDuration] = isnull(cast(cast(DATEDIFF(MILLISECOND, [UtcCreationTime], [UtcCompletionTime]) as decimal(12, 2))/1000 as decimal(12,2)), 0.00)
  WHERE [SessionDuration] is null
