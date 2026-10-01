	declare @theXmlData xml
	declare @POEOApplicationid int = 68  
	declare @InstrumentID INT
	set @InstrumentID = 20588

select cast(([dbo].[ufn_CheckSendToSAPForPOEOLicence](@InstrumentID)) as varchar)


	SELECT @theXmlData = LicenceXML
	FROM tblOnlinePOEOApplication 
	WHERE OnlinePOEOApplicationID = 68
 
	DECLARE @tblMonitoringPoint tblPOEOLicencePointType
	DECLARE	@POEOLicencePointID Int
  
	--SELECT  
	--	   case substring(RN.S.value('EffectiveDate[1]', 'varchar(50)'), 1, 10) when '0001-01-01' then '1900-01-01' end AS EffectiveDate
		   
 --  FROM @theXmlData.nodes('/POEOLicence/AppplicationPoint/LicencePoints/POEOLicencePoint') AS RN(S)

	INSERT INTO @tblMonitoringPoint(POEOLicencePointID
							,InstrumentID
							,PointNo
							,PointMediumTypeID
							,PointTypeID
							,PointTypeDescription
							,LocationDescription
							,Easting
							,Northing
							,ZoneNumber
							,CatchmentID
							,SubcatchmentID
							,ReceivingWaterBody
							,RegulatoryGroupID
							,EffectiveDate
      						,CreatedBySystemUserID
							,UpdatedBySystemUserID
							,RowTimestamp
							,PointLatitude
							,PointLongitude)
	SELECT RN.S.value('Id[1]','int') AS POEOLicencePointID,
		   @InstrumentID AS InstrumentID,
		   RN.S.value('PointNo[1]','smallint') AS PointNo,
		   RN.S.value('PointMediumTypeId[1]','smallint') AS PointMediumTypeID,
		   RN.S.value('PointTypeId[1]','smallint') AS PointTypeID,
		   RN.S.value('PointTypeDescription[1]','varchar(255)') AS PointTypeDescription,
		   RN.S.value('LocationDescription[1]','varchar(255)') AS LocationDescription,
		   RN.S.value('Easting[1]','int') AS Easting,
		   RN.S.value('Northing[1]','int') AS Northing,
		   RN.S.value('Zone[1]','int') AS ZoneNumber,		  
		   (SELECT TOP 1 [CatchmentID] FROM tblCatchment WHERE [Name] = RN.S.value('LBLCatchment[1]','varchar(100)')) as CatchmentID,
		   RN.S.value('SubcatchmentID[1]','int') AS SubcatchmentID,
		   RN.S.value('ReceivingWaterBody[1]','varchar(50)') AS ReceivingWaterBody,
		   RN.S.value('RegulatoryGroupId[1]','smallint') AS RegulatoryGroupID,
		   case substring(RN.S.value('EffectiveDate[1]', 'varchar(50)'), 1, 10) when '0001-01-01' then null else RN.S.value('EffectiveDate[1]', 'smalldatetime') end AS EffectiveDate,
		   RN.S.value('CreatedBySystemUserID[1]','int') AS CreatedBySystemUserID,
		   RN.S.value('UpdatedBySystemUserID[1]','int') AS UpdatedBySystemUserID,
		   RN.S.value('RowTimestamp[1]','varchar(4000)') AS RowTimestamp,
		   RN.S.value('Latitude[1]','decimal(25,15)') AS PointLatitude,
		   RN.S.value('Longitude[1]','decimal(25,15)') AS PointLongitude
   FROM @theXmlData.nodes('/POEOLicence/AppplicationPoint/LicencePoints/POEOLicencePoint') AS RN(S)
