
if exists(select * from tblDGWTLicenceFeeUnit)
begin
    truncate table tblDGWTLicenceFeeUnit
end
else
begin
	insert into tblDGWTLicenceFeeUnit
	(
		   [DGWTLicenceFeeUnitID]
		  ,[FeeDescription]
		  ,[Amount]
		  ,[FeeTypeID]
		  ,[FeeAppliedTypeID]
		  ,[DGWTLicenceDurationID]
		  ,[VehicleTypeID]
		  ,[PayloadTypeID]
		  ,[TransporterLicenceTypeID]
		  ,[EffectiveDateFrom]
		  ,[EffectiveDateTo]
		  ,[DateCreated]
		  ,[CreatedBySystemUserID]
		  ,[DateUpdated]
		  ,[UpdatedBySystemUserID] 
	)
	select 
		   [DGWTLicenceFeeUnitID]
		  ,[FeeDescription]
		  ,[Amount]
		  ,[FeeTypeID]
		  ,[FeeAppliedTypeID]
		  ,[DGWTLicenceDurationID]
		  ,[VehicleTypeID]
		  ,[PayloadTypeID]
		  ,[TransporterLicenceTypeID]
		  ,[EffectiveDateFrom]
		  ,[EffectiveDateTo]
		  ,[DateCreated]
		  ,[CreatedBySystemUserID]
		  ,[DateUpdated]
		  ,[UpdatedBySystemUserID]
	 from OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').[PALMSDB].[dbo].tblDGWTLicenceFeeUnit
end

 select * from tblDGWTLicenceFeeUnit