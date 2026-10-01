	SELECT A.[RadiationLicenceVariationID]
		  ,A.[InstrumentID]
		  ,[VariationStatusID]
		  ,(C.[Description]) as VariationStatusText
		  ,[VariationReason]
		  ,[VariationFeeAppliedFlag]
		  ,[AdministrativeFlag]
		  ,[RefToRACFlag]
		  ,[VariationCompletedFlag]
		  ,[VariationCompleteDate]
		  ,[VariationCompletedBySystemUserID]
		  ,A.[DateCreated]
		  ,A.[CreatedBySystemUserID]
		  ,A.[DateUpdated]
		  ,A.[UpdatedBySystemUserID]
		  ,A.[RowTimestamp]
		  ,'I' as [Action]
		  ,B.GivenName + ' ' + B.Surname as CreatorName
		  ,(case isnull(D.[RadiationLicenceVariationID], 0) when 0 then 0 else 1 end) as eConnectFlag
	  FROM [dbo].[tblRadiationLicenceVariation] A INNER JOIN tblSystemUser B on A.CreatedBySystemUserID = B.SystemUserID
	  INNER JOIN tblClassification C ON A.VariationStatusID = C.ClassificationID
	  LEFT OUTER JOIN tblOnlineLicenceChangeApplication D ON A.InstrumentID = D.InstrumentID AND A.[RadiationLicenceVariationID] = D.[RadiationLicenceVariationID]
	  AND D.ApplicationStatusID = 1703
	 WHERE A.InstrumentID = 5062656  
	 order by A.[RadiationLicenceVariationID] desc

	 select * from tblClassification where ClassificationID = 1703


	 select *, LicenceDataXML from tblOnlineLicenceChangeApplication where [RadiationLicenceVariationID] = 40560 and ApplicationStatusID = 1703

	 select *, LicenceDataXML from tblOnlineLicenceChangeApplication where OnlineLicenceChangeApplicationID in (1407, 1409)
 --GRANT EXECUTE ON dbo.[uspRadiationLicenceVariationeConnectDataUpdate] TO ReadWriteRole

 select * from tblRadiationLocation where RadiationLocationID in (1282, 10455, 10462, 10463, 10464)
 select * from tblAddress where AddressID in (88156, 946979, 947118, 947119)
 select * from tblInstrumentRadiationLocation where RadiationLocationID in (1282, 10455, 10463, 10464)
 -------------------------------------------------------------------------------------------------------
 select * from tblAddress where AddressID in (947118, 947119, 947120)
 select * from tblRadiationLocation where RadiationLocationID in (10463, 10464)
 select * from tblInstrumentRadiationLocation where RadiationLocationID in (10463, 10464)

 
 
 --delete from tblInstrumentRadiationLocation where RadiationLocationID in (10465)
 --delete from tblRadiationLocation where RadiationLocationID in (10465)
 --delete from tblAddress where AddressID in (947120)

 select * from tblRadiationDepartment
 select * from tblRadiationLicenceRRM where RadiationLicenceRRMID = 21486

 select * from tblRRM

 update tblRadiationLicenceRRM
 set 
 RRMTypeID = 4,
 RRMPurposeID = 13,
 RRMID = null,
 WorkArea = '232323',
 LaboratoryClassificationID = 771
 where RadiationLicenceRRMID = 21486

 select * from tblRRMComponent
 where RRMComponentID in (58893, 58895, 58896, 58897)


  select * from tblClassification where ClassificationDomainID = 92
  ---------------------------------------------------------------------
  select a.*, b.RadiationLocationID, c.InstrumentID, b.RadiationLicenceRRMID 
  from tblRadiationLicenceRRMComponent a 
  inner join tblRadiationLocationRRM b ON a.RadiationLicenceRRMID = b.RadiationLicenceRRMID
  inner join tblInstrumentRadiationLocation c on b.RadiationLocationID = c.RadiationLocationID
  where [RRMComponentID] in
  (
  SELECT  [RRMComponentID]       
  FROM [PALMSDB].[dbo].[tblRRMComponent]
  WHERE [ComponentStatusID] = 787
  )
---------------------------------------------------------------------

  select *, rrmc.ComponentStatusID 
			   FROM tblRRMComponent rrmc 
			   join tblRadiationLicenceRRMComponent lirrmc on rrmc.RRMComponentID = lirrmc.RRMComponentID
			   join tblRadiationLicenceRRM lirrm on lirrmc.RadiationLicenceRRMID = lirrm.RadiationLicenceRRMID
			   join tblRadiationLocationRRM lorrm on lirrm.RadiationLicenceRRMID = lorrm.RadiationLicenceRRMID
			   join tblRadiationLocation lo on lorrm.RadiationLocationID = lo.RadiationLocationID
			   join tblInstrumentRadiationLocation irl on lo.RadiationLocationID = irl.RadiationLocationID
			   WHERE InstrumentID = 5063418 and lirrmc.RadiationLicenceRRMID  = 9545 
			   order by rrmc.RRMComponentID
----------------------------------------------------------------------
select * from tblRRMDisposal where RadiationLicenceRRMID = 9545

select * from tblRRMDisposal
select * from tblRRMComponentDisposal  

select * from tblInstrumentRadiationLocation where TerminationPendingFlag = 1
select * from tblRadiationLicenceRRM where RadiationLicenceRRMID  = 9545 


select * from tblRRMDisposal where RadiationLicenceRRMID in (21484, 21487)
select * from tblRadiationLicenceRRM where RadiationLicenceRRMID in (21484, 21487)
select * from tblRRMComponent where RRMComponentID in (58890, 58893, 58894)