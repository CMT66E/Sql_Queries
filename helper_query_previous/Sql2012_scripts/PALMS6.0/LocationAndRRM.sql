declare @InstrumentID int = 5063419 

	SELECT IRL.RadiationLocationID
		  ,LI.[RadiationLicenceRRMID]
		  ,[RRMStatusID]
		  ,ST.Name [RRMStatus]
		  ,LI.[RRMTypeID]		  
		  ,ISNULL(RRMT.RRMType, '') RRMType
		  ,LI.[RRMPurposeID]
		  ,ISNULL(RRMP.RRMPurpose, '') RRMPurpose
		  ,LI.[RRMID]
		  ,ISNULL(RRM.RegulatedMaterial, '') [RRM]
		  ,[WorkArea]
		  ,[RRMSecurityClassificationID]
		  ,[LaboratoryClassificationID]
		  ,LI.[DateCreated]
		  ,LI.[CreatedBySystemUserID]
		  ,LI.[DateUpdated]
		  ,LI.[UpdatedBySystemUserID]
		  ,LI.[RowTimestamp]
		  ,'R' [RecordMode]
	  FROM [dbo].[tblRadiationLicenceRRM] LI
	  JOIN tblRadiationLocationRRM LO ON LI.RadiationLicenceRRMID = LO.RadiationLicenceRRMID
	  LEFT JOIN tblRRMType RRMT ON LI.[RRMTypeID] = RRMT.[RRMTypeID]
	  LEFT JOIN tblRRMPurpose RRMP ON LI.RRMPurposeID = RRMP.RRMPurposeID
	  LEFT JOIN tblRRM RRM ON LI.RRMID = RRM.RRMID
	  LEFT JOIN tblClassification ST ON LI.RRMStatusID = ST.ClassificationID
	  JOIN tblRadiationLocation Loc ON LO.RadiationLocationID = Loc.[RadiationLocationID]
	  JOIN [tblInstrumentRadiationLocation] IRL ON Loc.RadiationLocationID = IRL.RadiationLocationID
	  WHERE IRL.InstrumentID = @InstrumentID AND LO.EffectiveDateTo IS NULL