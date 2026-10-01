declare @theXmlData xml
set @theXmlData =
'
<NewDataSet>
  <DGVehicle>
    <DGVehicleID>-1</DGVehicleID>
    <VehicleTypeID>862</VehicleTypeID>
    <RegistrationNumber>1231</RegistrationNumber>
    <VINNumber>21123131</VINNumber>
    <RegistrationState>NSW</RegistrationState>
    <VehicleYear>2012</VehicleYear>
    <FleetNumber>123</FleetNumber>
    <VacuumTankerFlag>false</VacuumTankerFlag>
    <CoveredInsuranceFlag>false</CoveredInsuranceFlag>
    <PhotograghAttachedFlag>false</PhotograghAttachedFlag>
    <TankerTypeID>865</TankerTypeID>
    <TankYear>2012</TankYear>
    <DesignApprovalNo>DG2/1101A</DesignApprovalNo>
    <DateLastHydraulicTest>2017-07-01T00:00:00+10:00</DateLastHydraulicTest>
    <StabilityControlFlag>false</StabilityControlFlag>
    <Comments>3123</Comments>
    <IsVehicleManufacturedAfter01July2014Flag>false</IsVehicleManufacturedAfter01July2014Flag>
    <ProhibitedVehiclesFlag>false</ProhibitedVehiclesFlag>
    <DateCreated>2017-07-03T09:32:43.7293048+10:00</DateCreated>
    <CreatedBySystemUserID>1399</CreatedBySystemUserID>
    <DGVehicleMakeID>3</DGVehicleMakeID>
    <DGTankMakeID>3</DGTankMakeID>
    <DesignApprovalRegisteredFlag>true</DesignApprovalRegisteredFlag>
    <DesignApprovalState>NSW</DesignApprovalState>
    <PayloadTypeID>1404</PayloadTypeID>
  </DGVehicle>
  <DGVehicleClass>
    <DGVehicleClassID>-1</DGVehicleClassID>
    <DGVehicleID>-1</DGVehicleID>
    <VehicleClassID>-1</VehicleClassID>
    <UNNumberID>1001</UNNumberID>
    <UNNumber>UN1073</UNNumber>
    <DateCreated>2017-07-03T09:31:29.2733048+10:00</DateCreated>
    <CreatedBySystemUserID>1399</CreatedBySystemUserID>
    <UpdatedBySystemUserID>1399</UpdatedBySystemUserID>
    <Action>I</Action>
    <VehicleClassName />
  </DGVehicleClass>
</NewDataSet>
'


DECLARE @tblDGVehicle tblDGVehicleType
	DECLARE @tblDGVehicleClass tblDGVEhicleClassType
	declare @DGVehicleID int

	declare @RegoNo varchar(10)
	declare @VinNo varchar(20)
	declare @VehicleTypeID int

	declare @CreatedBySystemUserID int
	declare @UpdatedBySystemUserID int
	declare @Cnt int
	declare @INSERT bit
	declare @RtnVal int

   INSERT INTO @tblDGVehicle(
							  [DGVehicleID]
							  ,[VehicleTypeID]
							  ,[RegistrationNumber]
							  ,[VINNumber]
							  ,[RegistrationState]
							  ,[VehicleMake]
							  ,[VehicleYear]
							  ,[FleetNumber]
							  ,[TransportWasteFlag]
							  ,[VacuumTankerFlag]
							  ,[CoveredInsuranceFlag]
							  ,[PhotograghAttachedFlag]
							  ,[TankerTypeID]
							  ,[Capacity]
							  ,[TankMake]
							  ,[TankYear]
							  ,[TankSerialNumber]
							  ,[DesignApprovalNo]
							  ,[DateLastHydraulicTest]
							  ,[UNNumber]
							  ,[StabilityControlFlag]
							  ,[Comments]
							  ,[IsVehicleManufacturedAfter01July2014Flag]
							  ,[ProhibitedVehiclesFlag]
							  ,[DateCreated]
							  ,[CreatedBySystemUserID]
							  ,[DateUpdated]
							  ,[UpdatedBySystemUserID]
							  ,[DGVehicleMakeID]
							  ,[DGTankMakeID]
							  ,[DesignApprovalRegisteredFlag]
							  ,[DesignApprovalState]
							  ,[VehicleValidatedFlag]
							  ,[EPATankOnlyCheckFlag]
							  ,[EPATankOnlyCheckNote]
							  ,[TransportDGFlag]
							  --,[UploadDocument]
							  --,[UploadDocumentName]
							  ,[PayloadTypeID]
							)
	SELECT   RN.S.value('DGVehicleID[1]','int') AS DGVehicleID,
			 RN.S.value('VehicleTypeID[1]','int') AS VehicleTypeID,
			 RN.S.value('RegistrationNumber[1]','varchar(10)') AS RegistrationNumber,
			 RN.S.value('VINNumber[1]','varchar(20)') AS VINNumber,	
			 RN.S.value('RegistrationState[1]','varchar(3)') AS RegistrationState,
			 RN.S.value('VehicleMake[1]','varchar(50)') AS VehicleMake,
			 RN.S.value('VehicleYear[1]','varchar(4)') AS VehicleYear,
			 RN.S.value('FleetNumber[1]','varchar(20)') AS FleetNumber,	
			 RN.S.value('TransportWasteFlag[1]','bit')  AS TransportWasteFlag,
			 RN.S.value('VacuumTankerFlag[1]','bit') AS VacuumTankerFlag,
			 RN.S.value('CoveredInsuranceFlag[1]','bit') AS CoveredInsuranceFlag,
			 RN.S.value('PhotograghAttachedFlag[1]','bit') AS PhotograghAttachedFlag,
			 RN.S.value('TankerTypeID[1]','smallint') AS TankerTypeID,
			 RN.S.value('Capacity[1]','int') AS Capacity,
			 RN.S.value('TankMake[1]','varchar(50)') AS TankMake,
			 RN.S.value('TankYear[1]','varchar(4)') AS TankYear,
			 RN.S.value('TankSerialNumber[1]','varchar(50)') AS TankSerialNumber,
			 RN.S.value('DesignApprovalNo[1]','varchar(50)') AS DesignApprovalNo,
			 RN.S.value('DateLastHydraulicTest[1]','datetime') AS DateLastHydraulicTest,
			 RN.S.value('UNNumber[1]','varchar(50)') AS UNNumber,
			 RN.S.value('StabilityControlFlag[1]','bit') AS StabilityControlFlag,
			 RN.S.value('Comments[1]','varchar(600)') AS Comments,
			 RN.S.value('IsVehicleManufacturedAfter01July2014Flag[1]','bit') AS IsVehicleManufacturedAfter01July2014Flag,
			 RN.S.value('ProhibitedVehiclesFlag[1]','bit') AS ProhibitedVehiclesFlag,
			 GETDATE(),
			 RN.S.value('CreatedBySystemUserID[1]','int') AS CreatedBySystemUserID,
			 GETDATE(),
			 RN.S.value('UpdatedBySystemUserID[1]','int') AS UpdatedBySystemUserID,
		     RN.S.value('DGVehicleMakeID[1]','int') AS DGVehicleMakeID,
			 RN.S.value('DGTankMakeID[1]','int') AS DGTankMakeID,			
			 RN.S.value('DesignApprovalRegisteredFlag[1]','bit') AS DesignApprovalRegisteredFlag,
			 RN.S.value('DesignApprovalState[1]','varchar(3)') AS DesignApprovalState,
			 RN.S.value('VehicleValidatedFlag[1]','bit') AS VehicleValidatedFlag,
			 RN.S.value('EPATankOnlyCheckFlag[1]','bit') AS EPATankOnlyCheckFlag,
			 RN.S.value('EPATankOnlyCheckNote[1]','varchar(1000)') AS EPATankOnlyCheckNote,
			 RN.S.value('TransportDGFlag[1]','bit') AS TransportDGFlag,
			 RN.S.value('PayloadTypeID[1]','int') AS PayloadTypeID
			 --RN.S.value('UploadDocument[1]','varbinary(max)') AS UploadDocument,
			 --RN.S.value('UploadDocumentName[1]','varchar(128)') AS UploadDocumentName
   FROM @theXmlData.nodes('/NewDataSet/DGVehicle') AS RN(S)

   INSERT INTO @tblDGVehicleClass(
							[DGVehicleClassID],
							[DGVehicleID],
							[VehicleClassID],
							[DateCreated],
							[CreatedBySystemUserID],
							[DateUpdated],
							[UpdatedBySystemUserID],
							[UNNumberID],
							[UNNumber] ,
							[Action] 
								)
	SELECT 
			RN.S.value('DGVehicleClassID[1]','int') AS DGVehicleClassID,
			RN.S.value('DGVehicleID[1]','int') AS DGVehicleID,
			RN.S.value('VehicleClassID[1]','int') AS VehicleClassID,
			GETDATE(),
			RN.S.value('CreatedBySystemUserID[1]','int') AS CreatedBySystemUserID,
			GETDATE(),
			RN.S.value('UpdatedBySystemUserID[1]','int') AS UpdatedBySystemUserID,
			RN.S.value('UNNumberID[1]','int') AS UNNumberID,
			RN.S.value('UNNumber[1]','varchar(50)') AS UNNumber,
			RN.S.value('Action[1]','varchar(10)') AS UpdatedBySystemUserID
   FROM @theXmlData.nodes('/NewDataSet/DGVehicleClass') AS RN(S)

  

	SELECT  @DGVehicleID = DGVehicleID,
			@VehicleTypeID = VehicleTypeID,
			@RegoNo=RegistrationNumber,
			@VinNo=VINNumber,
			@CreatedBySystemUserID = CreatedBySystemUserID,
		    @UpdatedBySystemUserID = UpdatedBySystemUserID
	FROM @tblDGVehicle

	
	--check RegistrationNumber exists in system
	set @Cnt=0
	--select @Cnt=count(*) from tblDGVehicle 
	--	where (@DGVehicleID=-1 or DGVehicleID!=@DGVehicleID)
	--	and RegistrationNumber=@RegoNo


	select @Cnt=count(*) from tblDGVehicle A INNER JOIN tblDGLicenceVehicle B ON A.DGVehicleID = B.DGVehicleID
		where (@DGVehicleID=-1 or A.DGVehicleID!=@DGVehicleID) AND (B.EffectiveDateTo IS NULL)
		and RegistrationNumber=@RegoNo

	
	if @Cnt>0
		begin
			select -1 -- for duplicate Rego No
			return
		end

	
	--if (@VehicleTypeID=862 or (@VehicleTypeID = 863 and @VinNo is not null and  @VinNo != ''))--not check Vin no if Non tanker and no vin
	--	begin
	--		check VIN Number exists in system
	--		set @Cnt=0
	--		select @Cnt=count(*) from tblDGVehicle
	--			where (@DGVehicleID=-1 or DGVehicleID!=@DGVehicleID)
	--			and VINNumber=@VinNo
	
	--		if @Cnt>0
	--			begin
	--				select -2 -- for duplicate VIN No
	--				return
	--			end
	--	end

	SELECT @Cnt = count(*) From tblDGVehicle Where DGVehicleID = @DGVehicleID
	
	IF @DGVehicleID>0 AND @Cnt=1  
	   SELECT @INSERT = 0
	ELSE  
	   SELECT @INSERT = 1



	BEGIN TRAN A
	
    IF @INSERT=1
	  BEGIN
		    INSERT INTO tblDGVehicle(
						[VehicleTypeID]
						,[RegistrationNumber]
						,[VINNumber]
						,[RegistrationState]
						,[VehicleMake]
						,[VehicleYear]
						,[FleetNumber]
						,[TransportWasteFlag]
						,[VacuumTankerFlag]
						,[CoveredInsuranceFlag]
						,[PhotograghAttachedFlag]
						,[TankerTypeID]
						,[Capacity]
						,[TankMake]
						,[TankYear]
						,[TankSerialNumber]
						,[DesignApprovalNo]
						,[DateLastHydraulicTest]
						,[UNNumber]
						,[StabilityControlFlag]
						,[Comments]
						,[IsVehicleManufacturedAfter01July2014Flag]
						,[ProhibitedVehiclesFlag]
						,[DateCreated]
						,[CreatedBySystemUserID]
						,[DateUpdated]
						,[UpdatedBySystemUserID]
						,[DGVehicleMakeID]
						,[DGTankMakeID]
						,[DesignApprovalRegisteredFlag]
						,[DesignApprovalState]
						--,[VehicleValidatedFlag]
						,[EPATankOnlyCheckFlag]
						,[EPATankOnlyCheckNote]
						,[TransportDGFlag]
						,[PayloadTypeID]
						--,[UploadDocument]
						--,[UploadDocumentName]
						)
			Select		  [VehicleTypeID]
						  ,[RegistrationNumber]
						  ,[VINNumber]
						  ,[RegistrationState]
						  ,[VehicleMake]
						  ,[VehicleYear]
						  ,[FleetNumber]
						  ,[TransportWasteFlag]
						  ,[VacuumTankerFlag]
						  ,[CoveredInsuranceFlag]
						  ,[PhotograghAttachedFlag]
						  ,[TankerTypeID]
						  ,[Capacity]
						  ,[TankMake]
						  ,[TankYear]
						  ,[TankSerialNumber]
						  ,[DesignApprovalNo]
						  ,DATEADD(day,1,[DateLastHydraulicTest])
						  ,[UNNumber]
						  ,[StabilityControlFlag]
						  ,[Comments]
						  ,[IsVehicleManufacturedAfter01July2014Flag]
						  ,[ProhibitedVehiclesFlag]
						  ,[DateCreated]
						  ,[CreatedBySystemUserID]
						  ,[DateUpdated]
						  ,[UpdatedBySystemUserID]
						  ,[DGVehicleMakeID]
						  ,[DGTankMakeID]
						  ,[DesignApprovalRegisteredFlag]
						  ,[DesignApprovalState]
						  --For vehicles with DesignApprovalRegisteredFlag = False, the vehicle is saved and tblDGVehicle.VehicleValidatedFlag is set equal to False
						  --,case [DesignApprovalRegisteredFlag] when 0 then 0 else [VehicleValidatedFlag] end
						  ,[EPATankOnlyCheckFlag]
						  ,[EPATankOnlyCheckNote]
						  ,(case PayloadTypeID when 1404 then 0 else 1 end) as [TransportDGFlag]
						  ,[PayloadTypeID]
						  --,[UploadDocument]
						  --,[UploadDocumentName]
			From @tblDGVehicle
			
			Select @RtnVal = SCOPE_IDENTITY()
			
	  END
	ELSE
	  BEGIN  
			UPDATE tblDGVehicle 
			SET  [RegistrationNumber]=b.[RegistrationNumber],
			  [VINNumber]=b.[VINNumber],
			  [RegistrationState]=b.[RegistrationState],
			  [VehicleMake]=b.[VehicleMake],
			  [VehicleYear]=b.[VehicleYear],
			  [FleetNumber]=b.[FleetNumber],
			  [TransportWasteFlag]=b.[TransportWasteFlag],
			  [VacuumTankerFlag]=b.[VacuumTankerFlag],
			  [CoveredInsuranceFlag]=b.[CoveredInsuranceFlag],
			  [PhotograghAttachedFlag]=b.[PhotograghAttachedFlag],
			  [TankerTypeID]=b.[TankerTypeID],
			  [Capacity]=b.[Capacity],
			  [TankMake]=b.[TankMake],
			  [TankYear]=b.[TankYear],
			  [TankSerialNumber]=b.[TankSerialNumber],
			  [DesignApprovalNo]=b.[DesignApprovalNo],
			  [DateLastHydraulicTest]=DATEADD(day,1,b.[DateLastHydraulicTest]),
			  [UNNumber]=b.[UNNumber],
			  [StabilityControlFlag]=b.[StabilityControlFlag],
			  [Comments]=b.[Comments],
			  [IsVehicleManufacturedAfter01July2014Flag]=b.[IsVehicleManufacturedAfter01July2014Flag],
			  [ProhibitedVehiclesFlag]=b.[ProhibitedVehiclesFlag],
			  [DateUpdated]=b.[DateUpdated],
			  [UpdatedBySystemUserID]=b.  [UpdatedBySystemUserID],
			  [VehicleTypeID] = b.[VehicleTypeID],
			  [DGVehicleMakeID] =b.[DGVehicleMakeID],
			  [DGTankMakeID] = b.[DGTankMakeID],
			  [DesignApprovalRegisteredFlag] = b.[DesignApprovalRegisteredFlag],
			  [DesignApprovalState] = b.[DesignApprovalState],
			  --For vehicles with DesignApprovalRegisteredFlag = False, the vehicle is saved and tblDGVehicle.VehicleValidatedFlag is set equal to False
			  [VehicleValidatedFlag] = case b.[DesignApprovalRegisteredFlag] when 0 then 0 else a.[VehicleValidatedFlag] end, 
			  [EPATankOnlyCheckFlag] = b.[EPATankOnlyCheckFlag],
			  [EPATankOnlyCheckNote] = b.[EPATankOnlyCheckNote],
			  [TransportDGFlag] = b.[TransportDGFlag]
			  --[UploadDocument] = b.[UploadDocument],
			  --[UploadDocumentName] = b.[UploadDocumentName]
			FROM tblDGVehicle AS A JOIN @tblDGVehicle B ON A.DGVehicleID = B.DGVehicleID   
			
			select @RtnVal=@DGVehicleID     			 
	  END
	

	
	COMMIT TRAN A
	
	print 'reach here'

	--Insert/Update Contact records
	Declare @spRtnVal int
	Exec @spRtnVal = uspSaveDGVehicleClass @tblDGVehicleClass, @RtnVal
	print @spRtnVal
	IF @spRtnVal <> 0 RAISERROR ('Problem saving uspSaveDGVehicleClass' , 16, 1) 

	select @RtnVal
