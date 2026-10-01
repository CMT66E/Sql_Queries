declare @DGVehicleID int
set @DGVehicleID = 13212

SELECT [DGVehicleID]
		  ,[VehicleTypeID]
		  ,[RegistrationNumber]
		  ,tblDGVehicle.[VINNumber]
		  ,[RegistrationState]
		  ,[VehicleMake]
		  ,[VehicleYear]
		  ,[FleetNumber]
		  ,[TransportWasteFlag]
		  ,[VacuumTankerFlag]
		  ,[CoveredInsuranceFlag]
		  ,[PhotograghAttachedFlag]
		  ,tblDGVehicle.[TankerTypeID]
		  ,tblDGVehicle.[Capacity]
		  ,[TankMake]
		  ,[TankYear]
		  ,tblDGVehicle.[TankSerialNumber]
		  ,[DesignApprovalNo]
		  ,[DateLastHydraulicTest]
		  ,[UNNumber]
		  ,[StabilityControlFlag]
		  ,[Comments]
		  ,[IsVehicleManufacturedAfter01July2014Flag]
		  ,[ProhibitedVehiclesFlag]
		  ,[DGVehicleMakeID]
		  ,[DGTankMakeID]
		  ,[tblDGVehicle].[DateCreated]
		  ,[tblDGVehicle].[CreatedBySystemUserID]
		  ,[tblDGVehicle].[DateUpdated]
		  ,[tblDGVehicle].[UpdatedBySystemUserID]
		  ,[tblDGVehicle].[RowTimestamp]
		  ,tblClassification.Name as VehicleTypeName
		  ,[dbo].[ufn_GetVehicleClassByDGVehicleID](DGVehicleID) as [LicenceClass]
          ,'' as VehicleTypeName 
          ,DGVehicleMakeID 
          ,DGTankMakeID 
          ,DesignApprovalRegisteredFlag 
          ,tblDGVehicle.DesignApprovalState 
          ,VehicleValidatedFlag 
          ,EPATankOnlyCheckFlag 
          ,EPATankOnlyCheckNote  
          ,UploadDocumentName 
		  ,isnull(d.DesignApprovalTypeID, 0) as DesignApprovalTypeID
	    FROM [dbo].[tblDGVehicle] 
				inner join tblClassification on tblDGVehicle.VehicleTypeID=tblClassification.ClassificationID
				left outer join tblDGDesignApproval d on tblDGVehicle.[DesignApprovalNo]=d.DesignApprovalNumber
	    where [DGVehicleID]= @DGVehicleID

		SELECT        
			tblDGVehicleClass.DGVehicleClassID, 
			isnull(tblDGVehicleClass.DGVehicleID, 0) as DGVehicleID, 
			isnull(tblDGVehicleClass.VehicleClassID, 0) as VehicleClassID, 
			tblDGVehicleClass.DateCreated, 
			tblDGVehicleClass.CreatedBySystemUserID, 
			tblDGVehicleClass.DateUpdated, 
			tblDGVehicleClass.UpdatedBySystemUserID, 
			tblDGVehicleClass.RowTimestamp, 
			tblDGVehicleClass.UNNumber, 
			tblClassification.Name as VehicleClassName,			 
			isnull(tblDGVehicleClass.UNNumberID, 0) as UNNumberID, 
			B.[Description] as UNNumber
	   FROM            tblDGVehicleClass LEFT OUTER JOIN
							 tblClassification ON tblDGVehicleClass.VehicleClassID = tblClassification.ClassificationID
							             LEFT OUTER JOIN
							 tblClassification B ON tblDGVehicleClass.UNNumberID = B.ClassificationID
	   WHERE        (tblDGVehicleClass.DGVehicleID = @DGVehicleID)
	    
       SELECT Instrument.InstrumentID,
		   Instrument.InstrumentTypeID,
		   Instrument.InstrumentStatusID,
		   Instrument.ResponsibleSystemUserID,
		   dbo.ufn_GetResponsibleUserByUserID(Instrument.ResponsibleSystemUserID) AS ResponsibleUser,
		   '' AS LoginName,
		   Instrument.DECCWSectionID,
		   Instrument.IssuedBySystemUserID,
		   dbo.ufn_GetUserNameByUserID(Instrument.IssuedBySystemUserID) AS IssuedBy,
		   Instrument.DateIssued,
		   Instrument.DisplayFlag,
		   Instrument.DateCreated,
		   Instrument.CreatedBySystemUserID,
		   Instrument.DateUpdated,
		   Instrument.UpdatedBySystemUserID,
		   dbo.ufn_varbintohexstr(Instrument.RowTimestamp) AS RowTimestamp,
		   0 AS HasRecordService,
		   dbo.ufn_RadiationLicenceHasActiveVariation(A.InstrumentID) AS HasActiveVariation,
		   CASE WHEN dbo.ufn_GetActiveNotice(A.InstrumentID)='' THEN 0 ELSE 1 END AS HasActiveSystemNotice,
		   dbo.ufn_GetActiveNotice(A.InstrumentID) AS SystemNoticeName,
		   dbo.ufn_GetSectionNameByID(DECCWSectionID) AS SectionName,
		   dbo.ufn_RadiationLicenceHasPendingRenewal(A.InstrumentID) AS HasActiveCorrection
	  FROM tblInstrument Instrument inner join [dbo].[tblDGLicenceVehicle] A
	  ON Instrument.InstrumentID = A.InstrumentID 
	  WHERE A.DGVehicleID = @DGVehicleID AND a.EffectiveDateTo IS NULL

	  exec uspGetDGVehicleByID 15008


	  select DesignApprovalNumber, CAPDecisionMadeFlag from tblDGDesignApproval where InstrumentID = 5065888 
	  select DesignApprovalNo from tblDGVehicle WHERE RegistrationNumber like '%test%'

