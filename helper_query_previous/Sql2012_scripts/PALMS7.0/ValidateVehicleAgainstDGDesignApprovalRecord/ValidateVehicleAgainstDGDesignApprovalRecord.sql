
declare @DGDesignNo varchar(50)
set @DGDesignNo = 'NSWDGT2078'

select * from tblDGDesignApproval
where DesignApprovalNumber = @DGDesignNo

select a.*, b.DGVehicleMake from tblDGDesignApprovalVehicleMake a inner join tblDGVehicleMake b on a.DGVehicleMakeID = b.DGVehicleMakeID
where InstrumentID = (select InstrumentID from tblDGDesignApproval
where DesignApprovalNumber = @DGDesignNo)

select a.*, b.DGTankMake from tblDGDesignApprovalTankMake a inner join tblDGTankMake b on a.DGTankMakeID = b.DGTankMakeID
where InstrumentID = (select InstrumentID from tblDGDesignApproval
where DesignApprovalNumber = @DGDesignNo)

SELECT [DGDesignApprovalTankMakeID]
      ,[InstrumentID]
      ,a.[DGTankMakeID]
      ,a.[DateCreated]
      ,a.[CreatedBySystemUserID]
      ,a.[DateUpdated]
   ,b.DGTankMake
  FROM [dbo].[tblDGDesignApprovalTankMake] a inner join tblDGTankMake b on a.DGTankMakeID = b.DGTankMakeID
  WHERE A.InstrumentID = (select InstrumentID from tblDGDesignApproval
where DesignApprovalNumber = @DGDesignNo)

SELECT TOP 1000 [DGDesignApprovalClassUNID]
      ,[InstrumentID]
      ,[DGClassID]
      ,[DGUNNumberID]
      ,b.Description
  FROM [PALMSDB].[dbo].[tblDGDesignApprovalClassUN] a inner join tblClassification b on a.DGClassID = b.ClassificationID
  WHERE [InstrumentID] = (select InstrumentID from tblDGDesignApproval
where DesignApprovalNumber = @DGDesignNo)

select top 2 * from tblDGDesignApproval 
--where InstrumentID = 
order by DateCreated desc


