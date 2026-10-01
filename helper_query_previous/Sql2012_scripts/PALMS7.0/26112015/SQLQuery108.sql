----now we update the table: [tblRadiationLicenceRRM_BK] to set its RRMDepartmentID to be RadiationDepartmentID on table: tblRadiationDepartment 
--SELECT a.[RadiationLicenceRRMID]
--      ,[RRMStatusID]
--      ,[RRMTypeID]
--      ,[RRMPurposeID]
--      ,[RRMID]
--      ,[WorkArea]
--      ,[RRMSecurityClassificationID]
--      ,[LaboratoryClassificationID] 
--      ,[ROW_ID]
--      ,[OldAssetNumber]
--      ,[RRMDepartmentID]
--	  ,c.RadiationDepartmentID
--	  ,b.RadiationDepartmentID
--	  ,c.RadiationLocationID
--	  ,c.DepartmentName
--  FROM [dbo].[tblRadiationLicenceRRM_BK] a 
--  INNER JOIN [DM_tblRadiationLicenceRRM] b
--  on a.RadiationLicenceRRMID = b.RadiationLicenceRRMID
--  INNER JOIN [tblRadiationDepartment] c on b.RadiationDepartmentID = c.RowID
--  WHERE c.RadiationLocationID in (select RadiationLocationID from tblRadiationLocation)

--  select * from [tblRadiationLicenceRRM_BK]
--  where RRMDepartmentID is not null

SELECT a.[RadiationLicenceRRMID]
      ,[RRMStatusID]
      ,[RRMTypeID]
      ,[RRMPurposeID]
      ,[RRMID]
      ,[WorkArea]
      ,[RRMSecurityClassificationID]
      ,[LaboratoryClassificationID]
      ,a.[DateCreated]
      ,a.[CreatedBySystemUserID]
      ,a.[DateUpdated]
      ,a.[UpdatedBySystemUserID]
      ,a.[RowTimestamp]
      ,[ROW_ID]
      ,[OldAssetNumber]
      ,[RRMDepartmentID]
	  ,c.RadiationDepartmentID
	  ,b.RadiationDepartmentID
	  ,c.RadiationLocationID
	  ,c.DepartmentName
  FROM [dbo].[tblRadiationLicenceRRM] a 
  INNER JOIN [dbo].[DM_tblRadiationLicenceRRM] b
  on a.RadiationLicenceRRMID = b.RadiationLicenceRRMID
  INNER JOIN [dbo].[tblRadiationDepartment] c on b.RadiationDepartmentID = c.RowID
  WHERE c.RadiationLocationID in (select RadiationLocationID from tblRadiationLocation)

  update a set a.RRMDepartmentID = c.RadiationDepartmentID
  FROM [dbo].[tblRadiationLicenceRRM] a 
  INNER JOIN [dbo].[DM_tblRadiationLicenceRRM] b
  on a.RadiationLicenceRRMID = b.RadiationLicenceRRMID
  INNER JOIN [dbo].[tblRadiationDepartment] c on b.RadiationDepartmentID = c.RowID
  WHERE c.RadiationLocationID in (select RadiationLocationID from tblRadiationLocation)

  select *, b.* from DM_tblRadiationLicenceRRM a inner join DM_tblRadiationDepartment b on a.RadiationDepartmentID = b.RadiationDepartmentID where RadiationLicenceRRMID in (7, 84)

  select * from tblOnlinePOEOApplication where POEOApplicationNumber = 'POEOA1068'

  exec uspSubmitPOEOApplication 1068, 0