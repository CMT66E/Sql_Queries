  update [WDS].[dbo].[AccountOperation]
  set [NSWLicenceFlag] = 1
  WHERE dbo.IsInteger(isnull(AccountOperationPermit, '')) = 1