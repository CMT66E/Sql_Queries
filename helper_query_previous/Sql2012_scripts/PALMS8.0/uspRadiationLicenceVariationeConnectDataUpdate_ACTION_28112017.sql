	--reference SP: [uspRadiationLocationSaveOnline]
	--select * from tblClassification where ClassificationID in (3, 11, 12)

	--select * from tblSystemVariable where SystemVariableID = 28

	--select * from tblOnlineLicenceChangeApplication
	--where RadiationLicenceVariationID > 0 and InstrumentID = 5062656

	--select RadiationLicenceVariationID from tblOnlineLicenceChangeApplication
	--where RadiationLicenceVariationID = 40560 and InstrumentID = 5062656
	
	declare @RadiationLicenceVariationID INT = 40673
	declare @CurrentUserID INT = 1399
	declare @outErrorMsg VARCHAR(1000) = ''

	SET NOCOUNT ON;
	DECLARE @Temp VARCHAR(1000)
	SET @Temp = ''

	DECLARE @InstrumentID INT
    DECLARE @LicenceDataXML XML

	SELECT @InstrumentID = InstrumentID, @LicenceDataXML = AppXML 
	from tblOnlineLicenceChangeApplication where [RadiationLicenceVariationID] = @RadiationLicenceVariationID and ApplicationStatusID = 1703
	
	 
	IF DATALENGTH(@LicenceDataXML) > 0
	BEGIN
	    --start test line----------------------------------------------------------
		--print '@LicenceDataXML value = ' + cast(@LicenceDataXML as varchar(max))
		--print '@InstrumentID value = ' + cast(@InstrumentID as varchar(max))
		--end test line -----------------------------------------------------------

		----------GET DATA FROM XML -------------
		--we need go through the whole XML data by checking the flag: VariationPendingFlag = true
		declare @LocationDataCount int = 0
		select  @LocationDataCount = count(*) From @LicenceDataXML.nodes('//RADMLicenceData/LocationsandMaterials/RADMLocation') as xmlVals(rowvals) 
		where len(isnull(xmlVals.rowvals.value('(Name)[1]','VARCHAR(500)'), '')) > 0  
 
		DECLARE @TempRADMLocation AS TABLE(
												[LocationId] [int] NOT NULL,
												[Name] [varchar](500) NOT NULL,												 
												[Address] [varchar](1000) NULL,
												[Suburb] [varchar](50) NULL,
												[Postcode] [varchar](50) NULL,
												[State] [varchar](20) NULL,
												[AddInfo] [varchar](1000) NULL,
												[RadiationLocationID] [int] NULL,
												[IsRelocated] bit NULL,
												[RelocatedLicenceID] [int] NULL, 												
												[VariationPendingFlag] [bit] NULL,
												[Final_AddressID] [int] NULL,
												[FinalRadiationLocationID] [int] NULL
												)
																
		INSERT INTO @TempRADMLocation
			(
				[LocationId],
				[Name],							 
				[Address],	
				[Suburb],
				[Postcode],
				[State],
				[AddInfo],
				[RadiationLocationID],
				[IsRelocated],			 						 
				[RelocatedLicenceID],
				[VariationPendingFlag],
				[FinalRadiationLocationID]
			)
			SELECT
				xmlVals.rowvals.value('(LocationId)[1]','INT'),
				xmlVals.rowvals.value('(Name)[1]','VARCHAR(500)'),
				xmlVals.rowvals.value('(Address)[1]','VARCHAR(1000)'),
				xmlVals.rowvals.value('(Suburb)[1]','VARCHAR(500)'),
				xmlVals.rowvals.value('(Postcode)[1]','VARCHAR(1000)'),
				xmlVals.rowvals.value('(State)[1]','VARCHAR(1000)'),
				xmlVals.rowvals.value('(AddInfo)[1]','VARCHAR(1000)'),		
				xmlVals.rowvals.value('(RadiationLocationID)[1]','INT'),							
				xmlVals.rowvals.value('(IsRelocated)[1]','INT'),
				xmlVals.rowvals.value('(RelocatedLicenceID)[1]','INT'),
				xmlVals.rowvals.value('(VariationPendingFlag)[1]','BIT'),
				xmlVals.rowvals.value('(RadiationLocationID)[1]','INT')
			From @LicenceDataXML.nodes('//RADMLicenceData/LocationsandMaterials/RADMLocation') as xmlVals(rowvals)
		
		-------------start test lines-----------	        
		--print '@LocationDataCount value = ' + cast(@LocationDataCount as varchar(max))
		------------  end test lines -----------
		-----------------------------------------------------------------------------------------------------
		DECLARE @TempRADMMaterial AS TABLE(	
		                                    [RRMId] INT NULL,		
		                                    [LocationID] INT NULL,
											[TypeId] INT NULL,
											[TypeName] [varchar](100) NULL,	
											[PurposeId] INT NULL,
											[PurposeMaterialTypeId] INT NULL,
											[PurposeName] [varchar](100) NULL,												
											[EquipmentId] INT NULL,
											[EquipmentMaterialTypeId] INT NULL,
											[EquipmentPurposeId] INT NULL,											
											[EquipmentName] [varchar](100) NULL,	
											[LabClassificationId] INT NULL,																		 
											[Department] [varchar](500) NULL,
											[WorkArea] [varchar](500) NULL,
											[SealedSources][varchar](1000) NULL,
											[RadiationLicenceRRMID]	INT NULL,
											[VariationPendingFlag] BIT NULL,
											[IsDisposed] BIT NULL,
											[IsTransferred] BIT NULL,
											[IsEdited] BIT NULL,
											[FinalRadiationLicenceRRMID] INT NULL						 												 
											)
		-----------------------------------------------------------------------------------------------------
		-----------------------------------------------------------------------------------------------------
		DECLARE @TempRADMMaterialComponent AS TABLE(	
		                                    [TypeId] INT NULL,	
											[TypeMaterialTypeId] INT NULL,
											[TypeName] [varchar](500) NULL,													
		                                    [LocationId] INT NULL,
											[RRMId] INT NULL,
											[ManufacturerId] [varchar](100) NULL,	
											[ManufacturerName] [varchar](100) NULL,	
											[ModelNo][varchar](100) NULL,
											[SerialNo][varchar](50) NULL,
											[RadionuclideId] INT NULL,
											[NominalActivity] decimal NULL,
											[IsLifeExtended] BIT NULL,
											[WorkingLife] BIT NULL,												
											[RRMComponentID] INT NULL,											 
											[VariationPendingFlag] BIT NULL,
											[IsDisposed] BIT NULL,
											[LocationName] [varchar](500) NULL,	 
											[ComponentId] INT NULL,
											[RadiationLicenceRRMID] INT NULL,
											[IsTransferred] BIT NULL,
											[IsEdited] BIT NULL						 												 
											)
		-----------------------------------------------------------------------------------------------------
		-----------------------------------------------------------------------------------------------------
		DECLARE @TempRADMDepartment AS TABLE(		
		                                    [LocationID] INT NULL,										
											[Name] [varchar](500) NOT NULL,
											[RRMDepartmentID] [int] NOT NULL,
											[Final_RadiationDepartmentID] [int] NULL 									 												 
											)
		-----------------------------------------------------------------------------------------------------
		--*************start test lines***********************
		--select * from @TempRADMLocation
		--************** end test lines **********************

		--actually we don't need consider relocation cases because eConnect applications can only change location name and additional information 01-11-2017
	    --****************************************************************************************************************************************************************
		--**************************************** START PROCESS LocationsandMaterials DATA -> RADMLocation LOOPING **************************** 
		--DECLARE @MyTable TABLE
		--(
		--	SNo int IDENTITY(1,1), 
		--	LocationId int,
		--	RadiationLocationID int null,
		--	IsRelocated bit null,
		--	RelocatedLicenceID int null,
		--	VariationPendingFlag bit null
		--)    
		--INSERT INTO @MyTable(LocationId, RadiationLocationID, IsRelocated, RelocatedLicenceID, VariationPendingFlag)	    
		--SELECT LocationId, RadiationLocationID, IsRelocated, RelocatedLicenceID, VariationPendingFlag
		--FROM @TempRADMLocation
	 
	 --   -------------start test lines-----------
	 --   --select * from @MyTable
	 --   ------------  end test lines -----------

		--declare @Cnt int
		--SELECT @Cnt = MIN(Sno) FROM @MyTable	 

		--WHILE (1=1)
		--BEGIN
		--	declare @TempLocationId int = 0
		--	declare @TempRadiationLocationID int = 0
		--	declare @TempVariationPendingFlag bit
		--	declare @TempIsRelocated bit
		--	declare @TempRelocatedLicenceID int = 0
			 		
		--	SELECT @TempLocationId = LocationId, @TempVariationPendingFlag = VariationPendingFlag, 
		--	       @TempRadiationLocationID = RadiationLocationID, @TempIsRelocated = IsRelocated, @TempRelocatedLicenceID = RelocatedLicenceID FROM @MyTable
		--	WHERE SNo = @Cnt	    
		--	IF @@ROWCOUNT = 0
		--	BREAK

		--    -------------start process location data-----------			 						
		--	If @TempVariationPendingFlag = 1 
		--	begin
		--	  -------------start test lines-----------
		--	   print '@TempLocation has been changed during variation process we need add or update location data here'
		--	  ------------  end test lines -----------

		--	  --it means the location data has been changed (newly insert or updated) 
		--	  --1. if RadiationLocationID = -1 it means this record is newly added one
		--	  if @TempRadiationLocationID = -1 
		--	  begin
		--	         DECLARE @AddressID int = 0
		--			 DECLARE @InsertRadiationLocationID int = 0
		--			 DECLARE @tblRadiationLocation tblInstrumentRadiationLocationType
		--			 DECLARE @tblAddressTemp tblAddressType
		--			 --print 'insert a new location data into database'
		--			 --1. insert into tblAddress
		--			 insert into @tblAddressTemp(
		--							 AddressID
		--							,[Address]
		--							,Suburb
		--							,Postcode
		--							,StateCode
		--							,CreatedBySystemUserID
		--							,UpdatedBySystemUserID
		--							,RowTimestamp
		--							,PrefixAddress
		--							,Country
		--							,OverseasAddressFlag)	 
		--			 select          -1 as AddressID  --make sure this record will be inserted into tblAddress table
		--							,[Address]
		--							,Suburb
		--							,Postcode
		--							,State 
		--							,@CurrentUserID as CreatedBySystemUserID
		--							,null as UpdatedBySystemUserID
		--							,null as RowTimestamp
		--							,null as PrefixAddress
		--							,null as Country
		--							,0 as OverseasAddressFlag from  @TempRADMLocation
		--			 where  cast(RadiationLocationID as varchar) = cast(@TempRadiationLocationID as varchar)

		--			 ----*************************Start Real action insert record into tblAddress ************************* 
		--			 Exec @AddressID = uspSaveAddress @tblAddressTemp		
		--			 IF @AddressID < 0 RAISERROR ('Problem saving uspSaveAddress' , 16, 1)
		--			 ----*************************End Real action insert record into tblAddress ************************* 
		--		     update @TempRADMLocation set Final_AddressID = @AddressID where  cast(RadiationLocationID as varchar) = cast(@TempRadiationLocationID as varchar)

		--			 print 'new @AddressID value = ' + cast(@AddressID as varchar(50))

		--		     --2. insert into tblRadiationLocation
		--			 INSERT INTO tblRadiationLocation(
		--			             LocationName
		--						,AddressID
		--						,AdditionalAddressInformation
		--						,EffectiveDateFrom
		--						,DateCreated
		--						,CreatedBySystemUserID)
		--			 Select		 Name
		--						,@AddressID
		--						,AddInfo
		--						,GETDATE()
		--						,GETDATE()
		--						,@CurrentUserID as CreatedBySystemUserID
		--			 From @TempRADMLocation
		--			 WHERE RadiationLocationID = @TempRadiationLocationID and Final_AddressID = @AddressID    		  
 	--				 SET @InsertRadiationLocationID = (SELECT @@IDENTITY)
					
		--			 print '@InsertRadiationLocationID = ' + cast(@InsertRadiationLocationID as varchar(50))

		--			 update @TempRADMLocation set FinalRadiationLocationID = @InsertRadiationLocationID 
		--			 where  cast(RadiationLocationID as varchar) = cast(@TempRadiationLocationID as varchar)

		--			 --here we add record into table: @tblRadiationLocation 
		--			 if not exists(select RadiationLocationID from @tblRadiationLocation where RadiationLocationID = @InsertRadiationLocationID)
		--			 begin
		--				INSERT INTO @tblRadiationLocation
		--				(InstrumentRadiationLocationID,
		--				InstrumentID,
		--				RadiationLocationID,
		--				VariationPendingFlag,
		--				EffectiveDateFrom,
		--				CreatedBySystemUserID,
		--				UpdatedBySystemUserID,						 
		--				Action)
								 							 
		--				select 
		--			    -@CurrentUserID as InstrumentRadiationLocationID,
		--				@InstrumentID as InstrumentID,
		--				@InsertRadiationLocationID as RadiationLocationID,
		--				0 as VariationPendingFlag,
		--				getdate() as EffectiveDateFrom,
		--				@CurrentUserID as CreatedBySystemUserID,
		--				null as UpdatedBySystemUserID,
		--			   'I' as Action  								 								 
		--			 end						

		--		     --3. insert into tblInstrumentRadiationLocation
		--		     declare @RtnVal int = 0
		--			 Exec @RtnVal = uspRadiationLinkLocations @tblRadiationLocation, @InstrumentID
		--			 IF @RtnVal <> 0 RAISERROR ('Problem saving uspLinkRadiationLocations' , 16, 1) 
					 
		--			 print 'Final @RtnVal value need to be 0 means successful = ' + cast(@RtnVal as varchar(50))				    
		--	  end
			  
		--	  --2. if RadiationLocationID > 0 it means this record need to be updated
		--	  if @TempRadiationLocationID > 0
		--	  begin
		--	     --print 'update location data into database'

		--		 declare @TempLocationName varchar(200) = ''
		--		 declare @TempAddInfo varchar(500) = ''
		--		 select @TempLocationName = Name, @TempAddInfo = AddInfo from @TempRADMLocation where RadiationLocationID = @TempRadiationLocationID

		--		 --1. update tblRadiationLocation
		--		 update tblRadiationLocation set LocationName = @TempLocationName, AdditionalAddressInformation = @TempAddInfo,  UpdatedBySystemUserID = 1, DateUpdated = getdate()
		--		 where RadiationLocationID = @TempRadiationLocationID

		--		 --2. update tblAddress No need this anymore because eConnect applications can only change location name and additional information 01-11-2017
		--		 --   so the following lines have been commented out
		--		 --update a set
		--		 --a.[Address] = c.[Address],
		--		 --a.[suburb] = c.Suburb,
		--		 --a.[Postcode] = c.Postcode,
		--		 --a.StateCode = c.[State]
		--		 --from tblAddress a 
		--		 --inner join tblRadiationLocation b on a.AddressID = b.AddressID
		--		 --inner join @TempRADMLocation c on b.RadiationLocationID = c.RadiationLocationID
		--		 --where c.RadiationLocationID = @TempRadiationLocationID 
		--	  end

		--	  --3. if @TempIsRelocated = 1 and @TempRelocatedLicenceID > 0
		--	  if @TempIsRelocated = 1 and @TempRelocatedLicenceID > 0
		--	  begin
		--	     print 'current radiation licence location has been relocated to another licence'
		--	  end
		--	end			 
  --          ------------  end process location data -----------

		--	--****************************************************************************************************************************************************************
		--	--------------------------------------------start Materials data process---------------------------------------------------------
  --          If @TempLocationId >= 0
		--	begin
		--	        --print '@TempLocationId value = ' + cast(@TempLocationId as varchar(50))
		--			--start build the RADMMaterial table data---	
		--			insert into @TempRADMMaterial
		--			(
		--				[RRMId],		
		--				[LocationID],
		--				[TypeId],
		--				[TypeName],
		--				[PurposeId], 	
		--				[PurposeMaterialTypeId],
		--				[PurposeName], 	
		--				[EquipmentId], 
		--				[EquipmentMaterialTypeId], 
		--				[EquipmentPurposeId],  					
		--				[EquipmentName], 
		--				[LabClassificationId], 																												 
		--				[Department],
		--				[WorkArea],
		--				[SealedSources],
		--				[RadiationLicenceRRMID],
		--				[VariationPendingFlag],
		--				[IsDisposed],
		--				[IsTransferred],
		--				[IsEdited],
		--				[FinalRadiationLicenceRRMID]
		--			)
		--			select
		--				Tab1.Col1.value('(RRMId)[1]','INT') as RRMId,
		--				@TempLocationId as  [LocationID],
		--				Tab1.Col1.value('(Type/Id)[1]','INT') as TypeId, 
		--				Tab1.Col1.value('(Type/Name)[1]','VARCHAR(100)') as TypeName, 
		--				Tab1.Col1.value('(Purpose/Id)[1]','INT') as [PurposeId], 
		--				Tab1.Col1.value('(Purpose/MaterialTypeId)[1]','INT') as [PurposeMaterialTypeId], 
		--				Tab1.Col1.value('(Purpose/Name)[1]','VARCHAR(100)') as [PurposeName], 
		--				Tab1.Col1.value('(Equipment/Id)[1]','INT') as [EquipmentId], 
		--				Tab1.Col1.value('(Equipment/MaterialTypeId)[1]','INT') as [EquipmentMaterialTypeId], 
		--				Tab1.Col1.value('(Equipment/PurposeId)[1]','INT') as [EquipmentPurposeId], 
		--				Tab1.Col1.value('(Equipment/Name)[1]','VARCHAR(100)') as [EquipmentName], 
		--				Tab1.Col1.value('(LabClassification/Id)[1]','INT') as [LabClassificationId], 
		--				Tab1.Col1.value('(Department)[1]','VARCHAR(100)') as Department,
		--				Tab1.Col1.value('(WorkArea)[1]','VARCHAR(500)') as [WorkArea],
		--				Tab1.Col1.value('(SealedSources)[1]','VARCHAR(1000)') as [SealedSources], 
		--				Tab1.Col1.value('(RadiationLicenceRRMID)[1]','INT') as RadiationLicenceRRMID, 
		--				Tab1.Col1.value('(VariationPendingFlag)[1]','BIT') as VariationPendingFlag,    
		--				Tab1.Col1.value('(IsDisposed)[1]','BIT') as IsDisposed,   
		--				Tab1.Col1.value('(IsTransferred)[1]','BIT') as IsTransferred,   
		--				Tab1.Col1.value('(IsEdited)[1]','BIT') as IsEdited,
		--				null as [FinalRadiationLicenceRRMID]
		--			from @LicenceDataXML.nodes('//RADMLicenceData/LocationsandMaterials/RADMLocation') as Tab(Col)
		--			cross apply Tab.Col.nodes('Materials/RADMMaterial') as Tab1(Col1)
		--			where Tab.Col.value('(LocationId)[1]','INT') = @TempLocationId   
		--			--end build the RADMMaterial table data ----  
					 
		--			--start insert into @TempRADMMaterialComponent---
		--			--a. Container Case
		--			insert into @TempRADMMaterialComponent
		--			(
		--                [TypeId],	
		--				[TypeMaterialTypeId],
		--				[TypeName],													
		--                [LocationId],
		--				[RRMId],
		--				[ManufacturerId],	
		--				[ManufacturerName],	
		--				[ModelNo],
		--				[SerialNo],
		--				[RadionuclideId],
		--				[NominalActivity],
		--				[IsLifeExtended],
		--				[WorkingLife],												
		--				[RRMComponentID],											 
		--				[VariationPendingFlag],
		--				[IsDisposed],
		--				[LocationName],	 
		--				[ComponentId],
		--				[RadiationLicenceRRMID],
		--				[IsTransferred],
		--				[IsEdited]			
		--			)
		--			select
		--				Tab1.Col1.value('(Type/Id)[1]','INT') as [TypeId],
		--				Tab1.Col1.value('(Type/MaterialTypeId)[1]','INT') as [TypeMaterialTypeId],
		--				Tab1.Col1.value('(Type/Name)[1]','VARCHAR(100)') as TypeName, 
		--				Tab1.Col1.value('(LocationId)[1]','INT') as [LocationId], 
		--				Tab1.Col1.value('(RRMId)[1]','INT') as [RRMId], 
		--				Tab1.Col1.value('(Manufacturer/Id)[1]','INT') as ManufacturerId, 
		--				Tab1.Col1.value('(Manufacturer/Name)[1]','VARCHAR(100)') as [ManufacturerName], 
		--				Tab1.Col1.value('(ModelNo)[1]','VARCHAR(100)') as [ModelNo], 
		--				Tab1.Col1.value('(SerialNo)[1]','VARCHAR(100)') as [SerialNo], 
		--				Tab1.Col1.value('(Radionuclide/Id)[1]','INT') as [RadionuclideId], 							
		--				Tab1.Col1.value('(NominalActivity)[1]','DECIMAL') as [NominalActivity], 
		--				Tab1.Col1.value('(IsLifeExtended)[1]','BIT') as IsLifeExtended, 
		--				Tab1.Col1.value('(WorkingLife)[1]','BIT') as WorkingLife, 
		--				Tab1.Col1.value('(RRMComponentID)[1]','INT') as RRMComponentID, 
		--				Tab1.Col1.value('(VariationPendingFlag)[1]','BIT') as VariationPendingFlag,    
		--				Tab1.Col1.value('(IsDisposed)[1]','BIT') as IsDisposed,   
		--				Tab1.Col1.value('(LocationName)[1]','VARCHAR(500)') as LocationName, 
		--				Tab1.Col1.value('(ComponentId)[1]','INT') as ComponentId, 
		--				Tab1.Col1.value('(RadiationLicenceRRMID)[1]','INT') as RadiationLicenceRRMID, 
		--				Tab1.Col1.value('(IsTransferred)[1]','BIT') as IsTransferred,   
		--				Tab1.Col1.value('(IsEdited)[1]','BIT') as IsEdited 
		--			from @LicenceDataXML.nodes('//RADMLicenceData/LocationsandMaterials/RADMLocation') as Tab(Col)
		--			cross apply Tab.Col.nodes('Materials/RADMMaterial/Containers/RADMMaterialComponent') as Tab1(Col1)
		--			where Tab.Col.value('(LocationId)[1]','INT') = @TempLocationId  
					
		--			--b. SealedSources Case
		--			insert into @TempRADMMaterialComponent
		--			(
		--                [TypeId],	
		--				[TypeMaterialTypeId],
		--				[TypeName],													
		--                [LocationId],
		--				[RRMId],
		--				[ManufacturerId],	
		--				[ManufacturerName],	
		--				[ModelNo],
		--				[SerialNo],
		--				[RadionuclideId],
		--				[NominalActivity],
		--				[IsLifeExtended],
		--				[WorkingLife],												
		--				[RRMComponentID],											 
		--				[VariationPendingFlag],
		--				[IsDisposed],
		--				[LocationName],	 
		--				[ComponentId],
		--				[RadiationLicenceRRMID],
		--				[IsTransferred],
		--				[IsEdited]			
		--			)
		--			select
		--				Tab1.Col1.value('(Type/Id)[1]','INT') as [TypeId],
		--				Tab1.Col1.value('(Type/MaterialTypeId)[1]','INT') as [TypeMaterialTypeId],
		--				Tab1.Col1.value('(Type/Name)[1]','VARCHAR(100)') as TypeName, 
		--				Tab1.Col1.value('(LocationId)[1]','INT') as [LocationId], 
		--				Tab1.Col1.value('(RRMId)[1]','INT') as [RRMId], 
		--				Tab1.Col1.value('(Manufacturer/Id)[1]','INT') as ManufacturerId, 
		--				Tab1.Col1.value('(Manufacturer/Name)[1]','VARCHAR(100)') as [ManufacturerName], 
		--				Tab1.Col1.value('(ModelNo)[1]','VARCHAR(100)') as [ModelNo], 
		--				Tab1.Col1.value('(SerialNo)[1]','VARCHAR(100)') as [SerialNo], 
		--				Tab1.Col1.value('(Radionuclide/Id)[1]','INT') as [RadionuclideId], 							
		--				Tab1.Col1.value('(NominalActivity)[1]','DECIMAL') as [NominalActivity], 
		--				Tab1.Col1.value('(IsLifeExtended)[1]','BIT') as IsLifeExtended, 
		--				Tab1.Col1.value('(WorkingLife)[1]','BIT') as WorkingLife, 
		--				Tab1.Col1.value('(RRMComponentID)[1]','INT') as RRMComponentID, 
		--				Tab1.Col1.value('(VariationPendingFlag)[1]','BIT') as VariationPendingFlag,    
		--				Tab1.Col1.value('(IsDisposed)[1]','BIT') as IsDisposed,   
		--				Tab1.Col1.value('(LocationName)[1]','VARCHAR(500)') as LocationName, 
		--				Tab1.Col1.value('(ComponentId)[1]','INT') as ComponentId, 
		--				Tab1.Col1.value('(RadiationLicenceRRMID)[1]','INT') as RadiationLicenceRRMID, 
		--				Tab1.Col1.value('(IsTransferred)[1]','BIT') as IsTransferred,   
		--				Tab1.Col1.value('(IsEdited)[1]','BIT') as IsEdited 
		--			from @LicenceDataXML.nodes('//RADMLicenceData/LocationsandMaterials/RADMLocation') as Tab(Col)
		--			cross apply Tab.Col.nodes('Materials/RADMMaterial/SealedSources/RADMMaterialComponent') as Tab1(Col1)
		--			where Tab.Col.value('(LocationId)[1]','INT') = @TempLocationId   					 
		--			--end insert into @TempRADMMaterialComponent

		--				--start build the RADMDepartment table data---												 
		--			insert into @TempRADMDepartment
		--			(
		--				[LocationID], 
		--				[Name],
		--				[RRMDepartmentID],
		--				[Final_RadiationDepartmentID] 
		--			)
		--			select    
		--				@TempLocationId as  [LocationID],
		--				Tab1.Col1.value('(Name)[1]','VARCHAR(500)') as [Name],
		--				Tab1.Col1.value('(RRMDepartmentID)[1]','INT') as [RRMDepartmentID],
		--				(case when Tab1.Col1.value('(RRMDepartmentID)[1]','INT') > 0 
		--					    then Tab1.Col1.value('(RRMDepartmentID)[1]','INT') else 0 end) as [Final_RadiationDepartmentID]       
		--			from @LicenceDataXML.nodes('//RADMLicenceData/LocationsandMaterials/RADMLocation') as Tab(Col)
		--			cross apply Tab.Col.nodes('Departments/RADMDepartment') as Tab1(Col1)
		--			where Tab.Col.value('(LocationId)[1]','INT') = @TempLocationId   
		--			--end build the RADMDepartment table data ----  
						 
                   
		--		   --select * from @TempRADMMaterial WHERE VariationPendingFlag = 1
		--		    ------------------- start loop through the table: @TempRADMMaterial ---------------------
		--			DECLARE @MyTableRADMMaterial TABLE
		--			(
		--				SNo int IDENTITY(1,1), 								
		--				RRMId int,
		--				LocationID int,
		--				RadiationLicenceRRMID int,
		--				VariationPendingFlag bit,
		--				IsDisposed bit,
		--				IsEdited bit 
		--			) 
		--			INSERT INTO @MyTableRADMMaterial(RRMId, LocationID, RadiationLicenceRRMID, VariationPendingFlag, IsDisposed, IsEdited)	    
		--			SELECT RRMId, LocationID, RadiationLicenceRRMID, VariationPendingFlag, IsDisposed, IsEdited
		--			FROM @TempRADMMaterial
		--			WHERE VariationPendingFlag = 1
				  
		--		 --start test lines---
		--		 --select * from @MyTableRADMMaterial
		--		 --select * from @TempRADMMaterialComponent --where VariationPendingFlag = 1
		--		 --end test lines---

		--			declare @Cnt2 int
		--			SELECT @Cnt2 = MIN(Sno) FROM @MyTableRADMMaterial
	
		--			declare @TempRRMId2 int
		--			declare @TempLocationID2 int
		--			declare @TempRadiationLicenceRRMID2 int
		--			declare @TempVariationPendingFlag2 bit
		--			declare @TempIsDisposed bit
		--			declare @TempIsEdited bit

		--			WHILE (1=1)
		--			BEGIN
   
		--			SELECT @TempRRMId2 = RRMId, @TempLocationID2 = LocationID, @TempRadiationLicenceRRMID2 = RadiationLicenceRRMID, 
		--			       @TempVariationPendingFlag2 = VariationPendingFlag, @TempIsDisposed = IsDisposed, @TempIsEdited = IsEdited 
		--			FROM @MyTableRADMMaterial
		--			WHERE SNo = @Cnt2

		--			IF @@ROWCOUNT = 0
		--			BREAK
		--			            --print 'value @Cnt = ' + cast(@Cnt as varchar)
								 
		--						--*************************Real action insert record into database ************************* 
								
		--						--start insert new records into tblRRMDepartment 
		--						if exists(select * from @TempRADMDepartment where Final_RadiationDepartmentID = 0)
		--						begin
		--						   -- print 'Insert into tblRRMDepartment fro RRM data'
		--						   --we have to loop through the data rows because there could be more than one new departments need to insert into DB
		--							DECLARE @RowID3 int = 0	
		--							DECLARE @RRMDepartmentName3 varchar(100) = ''				 
		--							DECLARE @FinalRRMDepartmentID3 AS INT		
												
		--							WHILE (SELECT COUNT(*) FROM @TempRADMDepartment 
		--							    where Final_RadiationDepartmentID = 0) > 0
		--							BEGIN
		--				                Select Top 1 @RRMDepartmentName3 = Name FROM @TempRADMDepartment 
		--				                WHERE Final_RadiationDepartmentID = 0 OR Final_RadiationDepartmentID IS NULL order by Name
										
		--								--here we need get the @TempRadiationLocationID value if it is 0 then we need get this from column
		--								--FinalRadiationLocationID because this is a new radiationlocation
		--								declare @TempRadiationLocationIDForInsert int = 0
		--								if @TempRadiationLocationID = 0 
		--								   select @TempRadiationLocationIDForInsert = FinalRadiationLocationID
		--								           from @TempRADMLocation where  cast(RadiationLocationID as varchar) = cast(@TempRadiationLocationID as varchar) 
		--								else
		--								   select @TempRadiationLocationIDForInsert = @TempRadiationLocationID

		--								----1. insert into tblRRMDepartment
		--							    INSERT INTO tblRadiationDepartment(
		--											   RadiationLocationID
		--											  ,DepartmentName
		--											  ,EffectiveDateFrom
		--											  ,EffectiveDateTo
		--											  ,[DateCreated]
		--											  ,[CreatedBySystemUserID]
		--											  ,[DateUpdated]
		--											  ,[UpdatedBySystemUserID])
		--							    SELECT 		 @TempRadiationLocationIDForInsert as RadiationLocationID,
		--											 @RRMDepartmentName3 as DepartmentName,
		--											 getdate() as EffectiveDateFrom,
		--											 null as EffectiveDateTo,
		--											 GetDate(),
		--											 @CurrentUserID as [CreatedBySystemUserID],
		--											 null as [DateUpdated],
		--											 null as [UpdatedBySystemUserID]

		--								SET @FinalRRMDepartmentID3 = @@IDENTITY
 
		--							    --2. update the value of Final_RadiationDepartmentID in table: @TempRADMDepartment
		--								UPDATE @TempRADMDepartment
		--								SET Final_RadiationDepartmentID = @FinalRRMDepartmentID3
		--								WHERE Name = @RRMDepartmentName3 and Final_RadiationDepartmentID = 0
                                     					    
		--							END								   								   
		--						end
		--						--end insert new records into tblRRMDepartment 
														
		--						-- start get RRM attached Component 
		--						DECLARE @LoopRADMMaterialComponent AS TABLE(	
		--								SNo int IDENTITY(1,1), 	
		--								[TypeId] INT NULL,	
		--								[TypeMaterialTypeId] INT NULL,
		--								[TypeName] [varchar](500) NULL,													
		--								[LocationId] INT NULL,
		--								[RRMId] INT NULL,
		--								[ManufacturerId] [varchar](100) NULL,	
		--								[ManufacturerName] [varchar](100) NULL,	
		--								[ModelNo][varchar](100) NULL,
		--								[SerialNo][varchar](50) NULL,
		--								[RadionuclideId] INT NULL,
		--								[NominalActivity] decimal NULL,
		--								[IsLifeExtended] BIT NULL,
		--								[WorkingLife] BIT NULL,												
		--								[RRMComponentID] INT NULL,											 
		--								[VariationPendingFlag] BIT NULL,
		--								[IsDisposed] BIT NULL,
		--								[LocationName] [varchar](500) NULL,	 
		--								[ComponentId] INT NULL,
		--								[RadiationLicenceRRMID] INT NULL,
		--								[IsTransferred] BIT NULL,
		--								[IsEdited] BIT NULL,
		--								[AssayDate] DateTime NULL,
		--								[NewRRMComponentID] INT NULL 				 												 
		--								)
		--							--1. component Containers case insert 
		--						insert into @LoopRADMMaterialComponent
		--							(
		--								[TypeId],	
		--								[TypeMaterialTypeId],
		--								[TypeName],													
		--								[LocationId],
		--								[RRMId],
		--								[ManufacturerId],	
		--								[ManufacturerName],	
		--								[ModelNo],
		--								[SerialNo],
		--								[RadionuclideId],
		--								[NominalActivity],
		--								[IsLifeExtended],
		--								[WorkingLife],												
		--								[RRMComponentID],											 
		--								[VariationPendingFlag],
		--								[IsDisposed],
		--								[LocationName],	 
		--								[ComponentId],
		--								[RadiationLicenceRRMID],
		--								[IsTransferred],
		--								[IsEdited],
		--								[AssayDate] 	
		--							)
		--							select											    
		--								Tab1.Col1.value('(Type/Id)[1]','INT') as [TypeId],
		--								Tab1.Col1.value('(Type/MaterialTypeId)[1]','INT') as [TypeMaterialTypeId],
		--								Tab1.Col1.value('(Type/Name)[1]','VARCHAR(100)') as TypeName, 
		--								Tab1.Col1.value('(LocationId)[1]','INT') as [LocationId], 
		--								Tab1.Col1.value('(RRMId)[1]','INT') as [RRMId], 
		--								Tab1.Col1.value('(Manufacturer/Id)[1]','INT') as ManufacturerId, 
		--								Tab1.Col1.value('(Manufacturer/Name)[1]','VARCHAR(100)') as [ManufacturerName], 
		--								Tab1.Col1.value('(ModelNo)[1]','VARCHAR(100)') as [ModelNo], 
		--								Tab1.Col1.value('(SerialNo)[1]','VARCHAR(100)') as [SerialNo], 
		--								Tab1.Col1.value('(Radionuclide/Id)[1]','INT') as [RadionuclideId], 							
		--								Tab1.Col1.value('(NominalActivity)[1]','DECIMAL') as [NominalActivity], 
		--								Tab1.Col1.value('(IsLifeExtended)[1]','BIT') as IsLifeExtended, 
		--								Tab1.Col1.value('(WorkingLife)[1]','BIT') as WorkingLife, 
		--								Tab1.Col1.value('(RRMComponentID)[1]','INT') as RRMComponentID, 
		--								Tab1.Col1.value('(VariationPendingFlag)[1]','BIT') as VariationPendingFlag,    
		--								Tab1.Col1.value('(IsDisposed)[1]','BIT') as IsDisposed,   
		--								Tab1.Col1.value('(LocationName)[1]','VARCHAR(500)') as LocationName, 
		--								Tab1.Col1.value('(ComponentId)[1]','INT') as ComponentId, 
		--								Tab1.Col1.value('(RadiationLicenceRRMID)[1]','INT') as RadiationLicenceRRMID, 
		--								Tab1.Col1.value('(IsTransferred)[1]','BIT') as IsTransferred,   
		--								Tab1.Col1.value('(IsEdited)[1]','BIT') as IsEdited,
		--								(case when len(Tab1.Col1.value('(AssayDate)[1]','VARCHAR(100)')) > 10 then Tab1.Col1.value('(AssayDate)[1]','DateTime') else null end) as [AssayDate] 
		--							from @LicenceDataXML.nodes('//RADMLicenceData/LocationsandMaterials/RADMLocation') as Tab(Col)	
		--							cross apply Tab.Col.nodes('Materials/RADMMaterial') as Tab0(Col0)								 
		--							cross apply Tab0.Col0.nodes('Containers/RADMMaterialComponent') as Tab1(Col1)
		--							where Tab.Col.value('(LocationId)[1]','INT') = @TempLocationId	
		--							and Tab0.Col0.value('(RRMId)[1]','INT') = @TempRRMId2							 

  
		--							--2. component Containers case insert 
		--						insert into @LoopRADMMaterialComponent
		--							(
		--								[TypeId],	
		--								[TypeMaterialTypeId],
		--								[TypeName],													
		--								[LocationId],
		--								[RRMId],
		--								[ManufacturerId],	
		--								[ManufacturerName],	
		--								[ModelNo],
		--								[SerialNo],
		--								[RadionuclideId],
		--								[NominalActivity],
		--								[IsLifeExtended],
		--								[WorkingLife],												
		--								[RRMComponentID],											 
		--								[VariationPendingFlag],
		--								[IsDisposed],
		--								[LocationName],	 
		--								[ComponentId],
		--								[RadiationLicenceRRMID],
		--								[IsTransferred],
		--								[IsEdited],
		--								[AssayDate] 	
		--							)
		--							select											    
		--								Tab1.Col1.value('(Type/Id)[1]','INT') as [TypeId],
		--								Tab1.Col1.value('(Type/MaterialTypeId)[1]','INT') as [TypeMaterialTypeId],
		--								Tab1.Col1.value('(Type/Name)[1]','VARCHAR(100)') as TypeName, 
		--								Tab1.Col1.value('(LocationId)[1]','INT') as [LocationId], 
		--								Tab1.Col1.value('(RRMId)[1]','INT') as [RRMId], 
		--								Tab1.Col1.value('(Manufacturer/Id)[1]','INT') as ManufacturerId, 
		--								Tab1.Col1.value('(Manufacturer/Name)[1]','VARCHAR(100)') as [ManufacturerName], 
		--								Tab1.Col1.value('(ModelNo)[1]','VARCHAR(100)') as [ModelNo], 
		--								Tab1.Col1.value('(SerialNo)[1]','VARCHAR(100)') as [SerialNo], 
		--								Tab1.Col1.value('(Radionuclide/Id)[1]','INT') as [RadionuclideId], 							
		--								Tab1.Col1.value('(NominalActivity)[1]','DECIMAL') as [NominalActivity], 
		--								Tab1.Col1.value('(IsLifeExtended)[1]','BIT') as IsLifeExtended, 
		--								Tab1.Col1.value('(WorkingLife)[1]','BIT') as WorkingLife, 
		--								Tab1.Col1.value('(RRMComponentID)[1]','INT') as RRMComponentID, 
		--								Tab1.Col1.value('(VariationPendingFlag)[1]','BIT') as VariationPendingFlag,    
		--								Tab1.Col1.value('(IsDisposed)[1]','BIT') as IsDisposed,   
		--								Tab1.Col1.value('(LocationName)[1]','VARCHAR(500)') as LocationName, 
		--								Tab1.Col1.value('(ComponentId)[1]','INT') as ComponentId, 
		--								Tab1.Col1.value('(RadiationLicenceRRMID)[1]','INT') as RadiationLicenceRRMID, 
		--								Tab1.Col1.value('(IsTransferred)[1]','BIT') as IsTransferred,   
		--								Tab1.Col1.value('(IsEdited)[1]','BIT') as IsEdited,
		--								(case when len(Tab1.Col1.value('(AssayDate)[1]','VARCHAR(100)')) > 10 then Tab1.Col1.value('(AssayDate)[1]','DateTime') else null end) as [AssayDate] 
		--							from @LicenceDataXML.nodes('//RADMLicenceData/LocationsandMaterials/RADMLocation') as Tab(Col)	
		--							cross apply Tab.Col.nodes('Materials/RADMMaterial') as Tab0(Col0)								 
		--							cross apply Tab0.Col0.nodes('SealedSources/RADMMaterialComponent') as Tab1(Col1)
		--							where Tab.Col.value('(LocationId)[1]','INT') = @TempLocationId	
		--							and Tab0.Col0.value('(RRMId)[1]','INT') = @TempRRMId2	
		--						-- end get RRM attached Components	
																					
 								
																 
		--						if @TempRadiationLicenceRRMID2 = -1
		--						begin
		--						    --print 'INSERT ACTION: RadiationLicenceRRMID is -1, we need insert new records' + cast(@Cnt2 as varchar)
		--							--we use this condition as we only handle the newly added RRM records
		--							if exists(select * from @TempRADMMaterial where RRMId = @TempRRMId2 
		--										and LocationId = @TempLocationID2 and RadiationLicenceRRMID = @TempRadiationLicenceRRMID2)
		--							begin
		--								--select * from @TempRADMMaterial where RRMId = @TempRRMId2 and LocationId = @TempLocationID2 and RadiationLicenceRRMID = @TempRadiationLicenceRRMID2

		--								declare @FinalRadiationLocationID int = 0
		--								select @FinalRadiationLocationID = FinalRadiationLocationID from @TempRADMLocation where RadiationLocationID = @TempRadiationLocationID

		--								--print '[FinalRadiationLocationID]location top table @TempRADMLocation -> FinalRadiationLocationID = ' + cast(@FinalRadiationLocationID as varchar)
		--								--print 'RadiationLicenceRRMID is -1, we need insert new record RRMId -> @TempRRMId2 = ' + cast(@TempRRMId2 as varchar)
		--								--print 'RadiationLicenceRRMID is -1, we need insert new record LocationId -> @TempLocationID2 = ' + cast(@TempLocationID2 as varchar)

		--								 --select * from @LoopRADMMaterialComponent
		--								--When getting here we have got a list of RRMComponents under current new RRM

		--								--------------------start RRM and its components insert action ----------------------
		--								--Insert tblRadiationLicenceRRM rows and update newly created ids in the temp table
		--								DECLARE @InsertRadiationLicenceRRMID AS INT
		--								INSERT INTO [dbo].[tblRadiationLicenceRRM]
		--									([RRMStatusID]
		--									,[RRMTypeID]
		--									,[RRMPurposeID]
		--									,[RRMID]
		--									,[WorkArea]
		--									,[RRMSecurityClassificationID]
		--									,[LaboratoryClassificationID]
		--									,[DateCreated]
		--									,[CreatedBySystemUserID]
		--									,[RRMDepartmentID])
		--								SELECT 
		--									785 as RRMStatusID,  --Active status
		--									TypeId as RRMTypeID,
		--									PurposeId as RRMPurposeID,
		--									EquipmentId as RRMID,
		--									WorkArea,
		--									null as RRMSecurityClassificationID,
		--									LabClassificationId as LaboratoryClassificationID,
		--									GETDATE(),
		--									@CurrentUserID as CreatedBySystemUserID,
		--									(select Final_RadiationDepartmentID from @TempRADMDepartment where Name = Department) as RRMDepartmentID									
		--								FROM @TempRADMMaterial 
		--								where RRMId = @TempRRMId2 and LocationId = @TempLocationID2 and RadiationLicenceRRMID = @TempRadiationLicenceRRMID2
		--								SET @InsertRadiationLicenceRRMID= @@IDENTITY
										
		--								--print '@InsertRadiationLicenceRRMID = ' + cast(@InsertRadiationLicenceRRMID as varchar)

		--							    --here we update the column [FinalRadiationLicenceRRMID] in table: 
		--								update @TempRADMMaterial 
		--								set FinalRadiationLicenceRRMID =  @InsertRadiationLicenceRRMID 
		--								where RRMId = @TempRRMId2 and LocationId = @TempLocationID2 and RadiationLicenceRRMID = @TempRadiationLicenceRRMID2

		--								--Insert into tblRadiationLocationRRM
		--								declare @InsertRadiationLocationRRMID int = 0
		--								INSERT INTO [dbo].[tblRadiationLocationRRM]
		--										   ([RadiationLocationID]
		--										   ,[RadiationLicenceRRMID]
		--										   ,[VariationPendingFlag]
		--										   ,[Notes]
		--										   ,[InterstateOverseasRelocationFlag]
		--										   ,[EffectiveDateFrom]
		--										   ,[DateCreated]
		--										   ,[CreatedBySystemUserID])
		--								SELECT 
		--									@FinalRadiationLocationID as RadiationLocationID,
		--									@InsertRadiationLicenceRRMID as RadiationLicenceRRMID,
		--									0 as VariationPendingFlag,
		--									null as Notes,
		--									0 as InterstateOverseasRelocationFlag,
		--									GETDATE(),
		--									GETDATE(),
		--									@CurrentUserID as CreatedBySystemUserID							
										 
		--								SET @InsertRadiationLocationRRMID= @@IDENTITY

										
		--								--------insert RRMComponent --------------------------------------------------------------------------
		--								DECLARE @SNoRowID3 int = 0					 
		--								DECLARE @InsertRRMComponentID AS INT		
												
		--								WHILE (SELECT COUNT(*) FROM @LoopRADMMaterialComponent WHERE NewRRMComponentID IS NULL) > 0
		--								BEGIN
		--									Select Top 1 @SNoRowID3 = SNo FROM @LoopRADMMaterialComponent WHERE NewRRMComponentID IS NULL order by SNo

		--									INSERT INTO [dbo].[tblRRMComponent]
		--										([ComponentStatusID]
		--										,[RRMComponentTypeID]
		--										,[AssayDate]
		--										,[ManufacturerID]
		--										,[ModelNumber]
		--										,[SerialNumber]
		--										,[RadionuclideID]
		--										,[NominalActivity]
		--										,[WorkingLife]
		--										,[ExtendedWorkingLifeFlag]
		--										,[DateCreated]
		--										,[CreatedBySystemUserID])
		--									SELECT 
		--										785 as ComponentStatusID,
		--										TypeId as RRMComponentTypeID,
		--										AssayDate,
		--										case ManufacturerId when 0 then 1 else ManufacturerId end as ManufacturerID,  ----NEED TO FIX THIS 0 VALUE
		--										ModelNo as ModelNumber,
		--										SerialNo as SerialNumber,
		--										2 as RadionuclideID,
		--										NominalActivity,
		--										cast(WorkingLife as int) as WorkingLife,
		--										IsLifeExtended as ExtendedWorkingLifeFlag,
		--										GETDATE(),
		--										@CurrentUserID as CreatedBySystemUserID									
		--									FROM @LoopRADMMaterialComponent
		--									WHERE SNo = @SNoRowID3

		--									SET @InsertRRMComponentID = @@IDENTITY
									 
		--									UPDATE @LoopRADMMaterialComponent
		--									SET NewRRMComponentID = @InsertRRMComponentID
		--									WHERE SNo = @SNoRowID3 and NewRRMComponentID is null
 
		--								END
		--								--------end insert RRMComponent-----------------------------------------------------------------------------
		--								print 'test test @InsertRadiationLicenceRRMID =' + cast(@InsertRadiationLicenceRRMID as varchar)

		--								--SELECT 
		--								--	@InsertRadiationLicenceRRMID as RadiationLicenceRRMID,
		--								--	RRM.NewRRMComponentID,
		--								--	0 as VariationPendingFlag,
		--								--	null as Notes,
		--								--	0 as InterstateOverseasRelocationFlag,
		--								--	GETDATE(),
		--								--	GETDATE(),
		--								--	@CurrentUserID as CreatedBySystemUserID,
		--								--	RRM.NewRRMComponentID,
		--								--	RRM.SNo							
		--								--FROM @LoopRADMMaterialComponent RRM 
		--								--WHERE RRM.NewRRMComponentID > 0	

		--								--------start insert RadiationLicenceRRMComponent --------------------------------------------------------------------------
		--								INSERT INTO [dbo].[tblRadiationLicenceRRMComponent]
		--									([RadiationLicenceRRMID]
		--									,[RRMComponentID]
		--									,[VariationPendingFlag]
		--									,[Notes]
		--									,[InterstateOverseasRelocationFlag]
		--									,[EffectiveDateFrom]
		--									,[DateCreated]
		--									,[CreatedBySystemUserID])
		--								SELECT 
		--									@InsertRadiationLicenceRRMID as RadiationLicenceRRMID,
		--									RRM.NewRRMComponentID,
		--									0 as VariationPendingFlag,
		--									null as Notes,
		--									0 as InterstateOverseasRelocationFlag,
		--									GETDATE(),
		--									GETDATE(),
		--									@CurrentUserID as CreatedBySystemUserID							
		--								FROM @LoopRADMMaterialComponent RRM 
		--								WHERE RRM.NewRRMComponentID > 0
		--								--AND RRM.SNo = @SNoRowID3  
											
		--								--------end insert RadiationLicenceRRMComponent --------------------------------------------------------------------------
										 
		--								--------------------  end RRM and its components insert action ----------------------

		--								delete @LoopRADMMaterialComponent
		--							end 
		--						end

		--						if @TempIsEdited = 1 
		--						begin								    
		--							if exists(select * from @TempRADMMaterial where RRMId = @TempRRMId2 
		--							           and LocationId = @TempLocationID2 and RadiationLicenceRRMID = @TempRadiationLicenceRRMID2)
		--							begin
		--							    --------------start test lines -----------------------------------------------------------------------------------------------------
		--								print 'IsEdited = 1 top table @@TempRADMMaterial -> @TempRadiationLicenceRRMID2 = ' + cast(@TempRadiationLicenceRRMID2 as varchar)
		--								print 'IsEdited = 1, we need update record RRMId -> @TempRRMId2 = ' + cast(@TempRRMId2 as varchar)
		--								print 'IsEdited = 1, we need update record LocationId -> @TempLocationID2 = ' + cast(@TempLocationID2 as varchar)

		--						   --     select * from @TempRADMMaterial where RRMId = @TempRRMId2 and LocationId = @TempLocationID2 
		--									--and RadiationLicenceRRMID = @TempRadiationLicenceRRMID2
		--								---------------end test lines ------------------------------------------------------------------------------------------------------
									    										
		--								--start test line listing all RRMs in Edit status
		--								--select * from @LoopRADMMaterialComponent --where VariationPendingFlag = 1	
		--								--end test line listing all RRMs in Edit status

		--								--1. update data on table: tblRadiationLicenceRRM									  
		--								update a
		--								set 
		--								a.RRMTypeID = b.TypeId,
		--								a.RRMPurposeID = b.PurposeId,
		--								a.RRMID = b.EquipmentId,
		--								a.WorkArea = b.WorkArea,
		--								a.LaboratoryClassificationID = b.LabClassificationId
		--								from tblRadiationLicenceRRM a inner join @TempRADMMaterial b on a.RadiationLicenceRRMID = b.RadiationLicenceRRMID
		--								where b.RRMId = @TempRRMId2 and b.LocationId = @TempLocationID2 and b.RadiationLicenceRRMID = @TempRadiationLicenceRRMID2

		--							   --2. update data on table: tblRadiationLicenceRRMComponent
		--							    if exists(select * from @LoopRADMMaterialComponent where VariationPendingFlag = 1)
		--								begin
		--									update a
		--									set 												 
		--										a.[RRMComponentTypeID] = b.TypeId,
		--										a.[AssayDate] = b.AssayDate,
		--										a.[ManufacturerID] = b.ManufacturerId,
		--										a.[ModelNumber] = b.ModelNo,
		--										a.[SerialNumber] = b.SerialNo,												 
		--										a.[NominalActivity] = b.NominalActivity,
		--										a.[WorkingLife] = b.WorkingLife,
		--										a.[ExtendedWorkingLifeFlag] = b.IsLifeExtended,
		--										a.[DateUpdated] = Getdate(),
		--										a.[UpdatedBySystemUserID] = 1
		--									from tblRRMComponent a inner join @LoopRADMMaterialComponent b on a.RRMComponentID = b.RRMComponentID
		--									where b.VariationPendingFlag = 1			
		--								end


		--								delete @LoopRADMMaterialComponent																		   
		--							end
		--						    --print 'EDIT ACTION: RadiationLicenceRRMID is ' + cast(@TempRadiationLicenceRRMID2 as varchar) + ', update this record' + cast(@Cnt2 as varchar)
		--						    --select * from @TempRADMMaterial where RRMId = @TempRRMId2 and LocationId = @TempLocationID2 and RadiationLicenceRRMID = @TempRadiationLicenceRRMID2
		--						    --select * from @TempRADMMaterialComponent where RRMId = @TempRRMId2 and LocationId = @TempLocationID2
		--						    --select * from tblRadiationLicenceRRM where RadiationLicenceRRMID = @TempRadiationLicenceRRMID2 
		--						end

		--						if @TempIsDisposed = 1 --we don't need handle this case so we doing nothing
		--						begin								        											
		--								--we need get all IsDisposed components under current RRM with type as: Radiation apparatus
		--								--please comment off the following condition line 09-11-2017
		--								if exists(select * from @LoopRADMMaterialComponent where IsDisposed = 1) 
		--								   --   and exists(select * from @TempRADMMaterial where RRMId = @TempRRMId2 and LocationId = @TempLocationID2 
		--											--and RadiationLicenceRRMID = @TempRadiationLicenceRRMID2 and TypeId = 1)  --RRMTypeId = 1 namely: Radiation apparatus
		--								begin	
		--									--------------start test lines -----------------------------------------------------------------------------------------------------
		--									--print 'We can see a RRM is marked as IsDisposed then its attached RRMComponents may or may not marked as IsDisposed'
		--									print 'IsDisposed = 1 top table @@TempRADMMaterial -> @TempRadiationLicenceRRMID2 = ' + cast(@TempRadiationLicenceRRMID2 as varchar)
		--									print 'IsDisposed = 1, we need update record RRMId -> @TempRRMId2 = ' + cast(@TempRRMId2 as varchar)
		--									print 'IsDisposed = 1, we need update record LocationId -> @TempLocationID2 = ' + cast(@TempLocationID2 as varchar)										 
		--									print ''
		--									--print 'RadiationLicenceRRMID is ' + cast(@TempRadiationLicenceRRMID2 as varchar) + ', we need dispose this record' + cast(@Cnt2 as varchar)
		--									---------------end test lines ------------------------------------------------------------------------------------------------------

		--									--select * from @TempRADMMaterial where RRMId = @TempRRMId2 and LocationId = @TempLocationID2 
		--									--		and RadiationLicenceRRMID = @TempRadiationLicenceRRMID2		

		--									--1. Insert record into table: tblRRMDisposal
		--									if not exists(select [RadiationLicenceRRMID] from [tblRRMDisposal] where [RadiationLicenceRRMID] = @TempRadiationLicenceRRMID2)
		--									begin
		--										INSERT INTO [dbo].[tblRRMDisposal]
		--											([RadiationLicenceRRMID]
		--											,[VariationPendingFlag]
		--											,[DisposalDate]
		--											,[DisposalFileNumber]
		--											,[CIRaMNumber]
		--											,[RegoNumber]
		--											,[IntermediateAgent]
		--											,[Recipient]
		--											,[RecipientAddress]
		--											,[Country]
		--											,[Notes]
		--											,[ReceiptNotification]
		--											,[ReceiptDispatchNotification]
		--											,[DateCreated]
		--											,[CreatedBySystemUserID])
		--										SELECT							
		--											@TempRadiationLicenceRRMID2 as [RadiationLicenceRRMID],
		--											0 as [VariationPendingFlag], 
		--											GETDATE(), 
		--											'' as [DisposalFileNumber],
		--											'onlinevar ' + cast(@RadiationLicenceVariationID as varchar) as [CIRaMNumber], 
		--											'' as [RegoNumber],
		--											'' as [IntermediateAgent],
		--											'N/A' as [Recipient],
		--											'N/A' as [RecipientAddress],
		--											'N/A' as [Country], 
		--											'' as [Notes],
		--											'' as [ReceiptNotification],
		--											'' as [ReceiptDispatchNotification],
		--											GETDATE(),
		--											@CurrentUserID as [CreatedBySystemUserID]

		--											---set RRMStatusID = 786 namely Disposed on table: tblRadiationLicenceRRM
		--											update tblRadiationLicenceRRM 
		--											set RRMStatusID = 786, DateUpdated = getdate(), UpdatedBySystemUserID = @CurrentUserID
		--											where RadiationLicenceRRMID  = @TempRadiationLicenceRRMID2 

		--											--set the RRMComponenet status: ComponentStatusID to be Disposed in table: tblRRMComponent
		--											update tblRRMComponent 
		--											set 
		--											ComponentStatusID = 786, 
		--											DateUpdated = getdate(), 
		--											UpdatedBySystemUserID = @CurrentUserID 
		--											where RRMComponentID in (select RRMComponentID from @LoopRADMMaterialComponent where IsDisposed = 1)
		--									 end

		--									--RRM component list for dispose process 						     
		--									--select * from @LoopRADMMaterialComponent where IsDisposed = 1
		--								end
		--						end
								 
  --                              --here we loop through the changed @TempRADMMaterialComponent records under current RadiationLicenceRRM record
		--						--print '@TempRRMId2 is ' + cast(@TempRRMId2 as varchar)
		--						--print '@TempLocationID2 is ' + cast(@TempLocationID2 as varchar)

		--						--select * from @TempRADMMaterialComponent 
		--						--where VariationPendingFlag = 1 and RRMId = @TempRRMId2 and LocationID = @TempLocationID2 and IsDisposed <> 1

		--						delete from @LoopRADMMaterialComponent

		--		    SELECT @Cnt2 = @Cnt2 + 1
		
		--		    END						
		--				------------------- end loop through the table: @TempRADMMaterial -----------------------                 
		--	end
  --          ---------------------------------------------end Materials data process--------------------------------------------------------
		--	--****************************************************************************************************************************************************************

		--    select @Cnt = @Cnt + 1	

		--	-------------start test lines-----------
		--	--if @Cnt > 0
		--	--begin
		--	  --print ''
		--	  --print 'please delete this section at line 573'
		--	  --select * from  @TempRADMMaterial	
		--	  --select * from  @TempRADMMaterialComponent
		--	  --select * from  @TempRADMDepartment	
		--	--end
		--	------------  end test lines -----------

		--	delete @TempRADMMaterial
		--	delete @TempRADMMaterialComponent
		--	delete @TempRADMDepartment	   
		--END
	    --****************************************************************************************************************************************************************
		--**************************************** PROCESS LocationsandMaterials DATA -> RADMLocation LOOPING      **************************** 






	  
	    --****************************************************************************************************************************************************************
		--**************************************** START PROCESS MaterialsTransfer DATA we do not need process Data section: MaterialsDispose **************************** 
		DECLARE @TempRADMRRMsTransfer AS TABLE(	
		                                SNo int IDENTITY(1,1), 	
		                                [Id] INT NULL,										
										[Recipient] [varchar](200) NULL,
										[Address] [varchar](200) NULL,
										[State] [varchar](100) NULL,
										[Country] [varchar](50) NULL,
										[ProofDoc] [varchar](200) NULL 								 												 
										)
		INSERT INTO @TempRADMRRMsTransfer
		(
			[Id],
			[Recipient],							 
			[Address],			 
			[State],
			[Country],
			[ProofDoc]
		)
		SELECT
			xmlVals.rowvals.value('(Id)[1]','INT'),
			xmlVals.rowvals.value('(Recipient)[1]','VARCHAR(200)'),
			xmlVals.rowvals.value('(Address)[1]','VARCHAR(500)'),			 
			xmlVals.rowvals.value('(State)[1]','VARCHAR(20)'),
			xmlVals.rowvals.value('(Country)[1]','VARCHAR(100)'),		
			xmlVals.rowvals.value('(ProofDoc)[1]','VARCHAR(100)') 
		From @LicenceDataXML.nodes('//RADMLicenceData/MaterialsTransfer/RADMRRMsTransfer') as xmlVals(rowvals)     
		----------------------------------------------------
--********************************************************************************
select * from @TempRADMRRMsTransfer
--********************************************************************************

		DECLARE @TempTransferredRADMLocation AS TABLE(	
		                                SNo int IDENTITY(1,1), 	
		                                [LocationId] INT NULL,										
										[Name] [varchar](200) NULL,
										[Address] [varchar](200) NULL,
										[Suburb] [varchar](50) NULL,
										[Postcode] [varchar](50) NULL,
										[State] [varchar](100) NULL,											 
										[AddInfo] [varchar](1000) NULL,
										[RadiationLocationID] INT NULL,	
										[IsRelocated] BIT NULL,
										[RelocatedLicenceID] INT NULL,
										[VariationPendingFlag] BIT NULL	 								 												 
										)
		INSERT INTO @TempTransferredRADMLocation
		(
										[LocationId],										
										[Name],
										[Address],
										[Suburb],
										[Postcode],
										[State],											 
										[AddInfo],
										[RadiationLocationID],	
										[IsRelocated],
										[RelocatedLicenceID],
										[VariationPendingFlag]	
		)	       
		SELECT
			xmlVals.rowvals.value('(LocationId)[1]','INT'),
			xmlVals.rowvals.value('(Name)[1]','VARCHAR(200)'),
			xmlVals.rowvals.value('(Address)[1]','VARCHAR(500)'),	
			xmlVals.rowvals.value('(Suburb)[1]','VARCHAR(50)'),
			xmlVals.rowvals.value('(Postcode)[1]','VARCHAR(20)'),						 
			xmlVals.rowvals.value('(State)[1]','VARCHAR(20)'),			 
			xmlVals.rowvals.value('(AddInfo)[1]','VARCHAR(500)'), 
			xmlVals.rowvals.value('(RadiationLocationID)[1]','INT'),
			xmlVals.rowvals.value('(IsRelocated)[1]','BIT'),
			xmlVals.rowvals.value('(RelocatedLicenceID)[1]','INT'),
			xmlVals.rowvals.value('(VariationPendingFlag)[1]','BIT')
		From @LicenceDataXML.nodes('//RADMLicenceData/MaterialsTransfer/RADMRRMsTransfer/RRMsTransferred/RADMLocation') as xmlVals(rowvals)    
	 
	   
		declare @Temp_Recipient [varchar](200) 
		declare @Temp_Address [varchar](200)
		declare @Temp_State [varchar](100)
		declare @Temp_Country [varchar](50)
		declare @Temp_ProofDoc [varchar](200)  
				
		select 
			    @Temp_Recipient = Recipient  ,
				@Temp_Address = [Address],
				@Temp_State = [State],
				@Temp_Country = Country,
				@Temp_ProofDoc = ProofDoc
		from @TempRADMRRMsTransfer

		--On above table, it has Recipient, Address...Country this actually mapped to table: tblRadiationLocationRRM
		-------------start test lines-----------
		delete from  @TempTransferredRADMLocation where not LocationId in (14, 15)
		select * from @TempTransferredRADMLocation
		------------  end test lines -----------
		--Here we need loop through RRMsTransferred -> RADMLocation 
			
			
		declare @Cnt3 int
		SELECT @Cnt3 = MIN(Sno) FROM @TempTransferredRADMLocation
			
		declare @TmpLocationID int
		declare @TmpRadiationLocationID int
		declare @TmpName VARCHAR(200)
		declare @TmpAddress VARCHAR(200)

		------------------------------start @Tep temp table declarations -----------------------------------
		DECLARE @TepRADMMaterial AS TABLE(	
		                                [RRMId] INT NULL,		
		                                [LocationID] INT NULL,
										[TypeId] INT NULL,
										[TypeName] [varchar](100) NULL,	
										[PurposeId] INT NULL,
										[PurposeMaterialTypeId] INT NULL,
										[PurposeName] [varchar](100) NULL,												
										[EquipmentId] INT NULL,
										[EquipmentMaterialTypeId] INT NULL,
										[EquipmentPurposeId] INT NULL,											
										[EquipmentName] [varchar](100) NULL,
										[Department] [varchar](500) NULL,
										[WorkArea] [varchar](500) NULL,	
										[LabClassificationId] INT NULL,												
										[SealedSources][varchar](1000) NULL,
										[RadiationLicenceRRMID]	INT NULL,
										[VariationPendingFlag] BIT NULL,
										[IsDisposed] BIT NULL,
										[IsTransferred] BIT NULL,
										[IsEdited] BIT NULL,
										[NewRADMMaterial] INT NULL --we use this one as flag to loop this table						 										
										)

		DECLARE @TepRADMMaterialComponent AS TABLE(	
		                                [TypeId] INT NULL,	
										[TypeMaterialTypeId] INT NULL,
										[TypeName] [varchar](500) NULL,													
		                                [LocationId] INT NULL,
										[RRMId] INT NULL,
										[ManufacturerId] [varchar](100) NULL,	
										[ManufacturerName] [varchar](100) NULL,	
										[ModelNo][varchar](100) NULL,
										[SerialNo][varchar](50) NULL,
										[RadionuclideId] INT NULL,
										[NominalActivity] decimal NULL,
										[IsLifeExtended] BIT NULL,
										[WorkingLife] BIT NULL,												
										[RRMComponentID] INT NULL,											 
										[VariationPendingFlag] BIT NULL,
										[IsDisposed] BIT NULL,
										[LocationName] [varchar](500) NULL,	 
										[ComponentId] INT NULL,
										[RadiationLicenceRRMID] INT NULL,
										[IsTransferred] BIT NULL,
										[IsEdited] BIT NULL						 												 
										)

		DECLARE @TepRADMDepartment AS TABLE(		
		                                [LocationID] INT NULL,										
										[Name] [varchar](500) NOT NULL,
										[RRMDepartmentID] [int] NOT NULL,
										[Final_RadiationDepartmentID] [int] NULL 									 												 
										)
		------------------------------end @Tep temp table declarations -----------------------------------

		WHILE (1=1)
		BEGIN
				 
			SELECT @TmpLocationID = LocationID, @TmpName = Name, @TmpRadiationLocationID = RadiationLocationID FROM @TempTransferredRADMLocation
			WHERE SNo = @Cnt3
			IF @@ROWCOUNT = 0
			BREAK

			print '@Cnt3 loop value = ' + cast(@Cnt3 as varchar)
			print '@Cnt3 loop value @TmpRadiationLocationID = ' + cast(@TmpRadiationLocationID as varchar)
			
			--here we start to get <Materials> data

					insert into @TepRADMMaterial
					(
								[RRMId],		
								[LocationID],
								[TypeId],
								[TypeName],
								[PurposeId], 	
								[PurposeMaterialTypeId],
								[PurposeName], 	
								[EquipmentId], 
								[EquipmentMaterialTypeId], 
								[EquipmentPurposeId],  					
								[EquipmentName], 
								[Department],
								[WorkArea],
								[LabClassificationId], 																												 
								[SealedSources],
								[RadiationLicenceRRMID],
								[VariationPendingFlag],
								[IsDisposed],
								[IsTransferred],
								[IsEdited]
					)
					select
						Tab1.Col1.value('(RRMId)[1]','INT') as RRMId,
						Tab1.Col1.value('(LocationId)[1]','INT') as  [LocationID],
						Tab1.Col1.value('(Type/Id)[1]','INT') as TypeId, 
						Tab1.Col1.value('(Type/Name)[1]','VARCHAR(100)') as TypeName, 
						Tab1.Col1.value('(Purpose/Id)[1]','INT') as [PurposeId], 
						Tab1.Col1.value('(Purpose/MaterialTypeId)[1]','INT') as [PurposeMaterialTypeId], 
						Tab1.Col1.value('(Purpose/Name)[1]','VARCHAR(100)') as [PurposeName], 
						Tab1.Col1.value('(Equipment/Id)[1]','INT') as [EquipmentId], 
						Tab1.Col1.value('(Equipment/MaterialTypeId)[1]','INT') as [EquipmentMaterialTypeId], 
						Tab1.Col1.value('(Equipment/PurposeId)[1]','INT') as [EquipmentPurposeId], 
						Tab1.Col1.value('(Equipment/Name)[1]','VARCHAR(100)') as [EquipmentName], 
						Tab1.Col1.value('(Department)[1]','VARCHAR(100)') as Department,
						Tab1.Col1.value('(WorkArea)[1]','VARCHAR(500)') as [WorkArea],
						Tab1.Col1.value('(LabClassification/Id)[1]','INT') as [LabClassificationId], 
						Tab1.Col1.value('(SealedSources)[1]','VARCHAR(1000)') as [SealedSources], 
						Tab1.Col1.value('(RadiationLicenceRRMID)[1]','INT') as RadiationLicenceRRMID, 
						Tab1.Col1.value('(VariationPendingFlag)[1]','BIT') as VariationPendingFlag,    
						Tab1.Col1.value('(IsDisposed)[1]','BIT') as IsDisposed,   
						Tab1.Col1.value('(IsTransferred)[1]','BIT') as IsTransferred,   
						Tab1.Col1.value('(IsEdited)[1]','BIT') as IsEdited
					from @LicenceDataXML.nodes('//RADMLicenceData/MaterialsTransfer/RADMRRMsTransfer/RRMsTransferred/RADMLocation') as Tab(Col)
					cross apply Tab.Col.nodes('Materials/RADMMaterial') as Tab1(Col1)
					where Tab.Col.value('(LocationId)[1]','INT') = @TmpLocationID 

					--------------------start test lines-----------------
					select * from @TepRADMMaterial
					--------------------end test lines ------------------

					declare @TmpRowID int = 0
					declare @TmpRadiationLicenceRRMID int = 0
					declare @TmpVariationPendingFlag bit = 0

					WHILE (SELECT COUNT(*) FROM @TepRADMMaterial WHERE [NewRADMMaterial] IS NULL) > 0
					BEGIN
						Select Top 1 @TmpRowID = RRMId, @TmpRadiationLicenceRRMID= RadiationLicenceRRMID, 
						@TmpVariationPendingFlag = VariationPendingFlag FROM @TepRADMMaterial WHERE  [NewRADMMaterial] IS NULL
							
						-- Start Handles radiation location export logic --
						if @TmpVariationPendingFlag = 1
						begin
						         print '@Temp_Recipient =' + @Temp_Recipient
								 print '@Temp_State =' + @Temp_State
								 print '@Temp_Country =' + @Temp_Country
								 print '@TmpRadiationLocationID = ' + cast(@TmpRadiationLocationID as varchar)
								 print '@TmpRadiationLicenceRRMID = ' + cast(@TmpRadiationLicenceRRMID as varchar)
							     print ''
								 print ''

								 --Update table: tblRadiationLocationRRM
								 UPDATE tblRadiationLocationRRM
								 SET InterstateOverseasRelocationFlag = 1,
									Recipient = @Temp_Recipient,
									[RecipientAddress]  = @Temp_Address,
									[State] = upper(@Temp_State),
									Country = @Temp_Country
								 WHERE RadiationLocationID = @TmpRadiationLocationID 
									and RadiationLicenceRRMID = @TmpRadiationLicenceRRMID
			 
								 UPDATE lirrmc
								 SET VariationPendingFlag = 0,									 
									  ExportedDate = GETDATE(),
									  UpdatedBySystemUserID = 1,
									  DateUpdated = GETDATE()
								 FROM tblRRMComponent rrmc 
								 join tblRadiationLicenceRRMComponent lirrmc on rrmc.RRMComponentID = lirrmc.RRMComponentID
								 join tblRadiationLicenceRRM lirrm on lirrmc.RadiationLicenceRRMID = lirrm.RadiationLicenceRRMID
								 join tblRadiationLocationRRM lorrm on lirrm.RadiationLicenceRRMID = lorrm.RadiationLicenceRRMID
								 join tblRadiationLocation lo on lorrm.RadiationLocationID = lo.RadiationLocationID
								 join tblInstrumentRadiationLocation irl on lo.RadiationLocationID = irl.RadiationLocationID
								 WHERE InstrumentID = @InstrumentID AND lo.RadiationLocationID = @TmpRadiationLocationID and lirrm.RadiationLicenceRRMID = @TmpRadiationLicenceRRMID 

								 UPDATE rrmc
								 SET ComponentStatusID = 810,
									  UpdatedBySystemUserID = 1,
									  DateUpdated = GETDATE()
								 FROM tblRRMComponent rrmc 
								 join tblRadiationLicenceRRMComponent lirrmc on rrmc.RRMComponentID = lirrmc.RRMComponentID
								 join tblRadiationLicenceRRM lirrm on lirrmc.RadiationLicenceRRMID = lirrm.RadiationLicenceRRMID
								 join tblRadiationLocationRRM lorrm on lirrm.RadiationLicenceRRMID = lorrm.RadiationLicenceRRMID
								 join tblRadiationLocation lo on lorrm.RadiationLocationID = lo.RadiationLocationID
								 join tblInstrumentRadiationLocation irl on lo.RadiationLocationID = irl.RadiationLocationID
								 WHERE InstrumentID = @InstrumentID AND lo.RadiationLocationID = @TmpRadiationLocationID and lirrm.RadiationLicenceRRMID = @TmpRadiationLicenceRRMID 

								 UPDATE lorrm
								 SET VariationPendingFlag = 0,
									  --EffectiveDateTo = GETDATE(),
									  ExportedDate = GETDATE(),
									  UpdatedBySystemUserID = 1,
									  DateUpdated = GETDATE()
								 FROM tblRadiationLicenceRRM lirrm
								 join tblRadiationLocationRRM lorrm on lirrm.RadiationLicenceRRMID = lorrm.RadiationLicenceRRMID
								 join tblRadiationLocation lo on lorrm.RadiationLocationID = lo.RadiationLocationID
								 join tblInstrumentRadiationLocation irl on lo.RadiationLocationID = irl.RadiationLocationID
								 WHERE InstrumentID = @InstrumentID AND lo.RadiationLocationID = @TmpRadiationLocationID and lirrm.RadiationLicenceRRMID = @TmpRadiationLicenceRRMID 

								 UPDATE lirrm
								 SET RRMStatusID = 810,
									  UpdatedBySystemUserID = 1,
									  DateUpdated = GETDATE()
								 FROM tblRadiationLicenceRRM lirrm 
								 join tblRadiationLocationRRM lorrm on lirrm.RadiationLicenceRRMID = lorrm.RadiationLicenceRRMID
								 join tblRadiationLocation lo on lorrm.RadiationLocationID = lo.RadiationLocationID
								 join tblInstrumentRadiationLocation irl on lo.RadiationLocationID = irl.RadiationLocationID
								 WHERE InstrumentID = @InstrumentID AND lo.RadiationLocationID = @TmpRadiationLocationID and lirrm.RadiationLicenceRRMID = @TmpRadiationLicenceRRMID 
						end
						-- End Handles radiation location export logic

						insert into @TepRADMMaterialComponent
						(
							[TypeId],	
							[TypeMaterialTypeId],
							[TypeName],													
							[LocationId],
							[RRMId],
							[ManufacturerId],	
							[ManufacturerName],	
							[ModelNo],
							[SerialNo],
							[RadionuclideId],
							[NominalActivity],
							[IsLifeExtended],
							[WorkingLife],												
							[RRMComponentID],											 
							[VariationPendingFlag],
							[IsDisposed],
							[LocationName],	 
							[ComponentId],
							[RadiationLicenceRRMID],
							[IsTransferred],
							[IsEdited]			
						)
						select
							Tab1.Col1.value('(Type/Id)[1]','INT') as [TypeId],
							Tab1.Col1.value('(Type/MaterialTypeId)[1]','INT') as [TypeMaterialTypeId],
							Tab1.Col1.value('(Type/Name)[1]','VARCHAR(100)') as TypeName, 
							Tab1.Col1.value('(LocationId)[1]','INT') as [LocationId], 
							Tab1.Col1.value('(RRMId)[1]','INT') as [RRMId], 
							Tab1.Col1.value('(Manufacturer/Id)[1]','INT') as ManufacturerId, 
							Tab1.Col1.value('(Manufacturer/Name)[1]','VARCHAR(100)') as [ManufacturerName], 
							Tab1.Col1.value('(ModelNo)[1]','VARCHAR(100)') as [ModelNo], 
							Tab1.Col1.value('(SerialNo)[1]','VARCHAR(100)') as [SerialNo], 
							Tab1.Col1.value('(Radionuclide/Id)[1]','INT') as [RadionuclideId], 							
							Tab1.Col1.value('(NominalActivity)[1]','DECIMAL') as [NominalActivity], 
							Tab1.Col1.value('(IsLifeExtended)[1]','BIT') as IsLifeExtended, 
							Tab1.Col1.value('(WorkingLife)[1]','BIT') as WorkingLife, 
							Tab1.Col1.value('(RRMComponentID)[1]','INT') as RRMComponentID, 
							Tab1.Col1.value('(VariationPendingFlag)[1]','BIT') as VariationPendingFlag,    
							Tab1.Col1.value('(IsDisposed)[1]','BIT') as IsDisposed,   
							Tab1.Col1.value('(LocationName)[1]','VARCHAR(500)') as LocationName, 
							Tab1.Col1.value('(ComponentId)[1]','INT') as ComponentId, 
							Tab1.Col1.value('(RadiationLicenceRRMID)[1]','INT') as RadiationLicenceRRMID, 
							Tab1.Col1.value('(IsTransferred)[1]','BIT') as IsTransferred,   
							Tab1.Col1.value('(IsEdited)[1]','BIT') as IsEdited 
						from @LicenceDataXML.nodes('//RADMLicenceData/MaterialsTransfer/RADMRRMsTransfer/RRMsTransferred/RADMLocation') as Tab(Col)
						cross apply Tab.Col.nodes('Materials/RADMMaterial/Containers/RADMMaterialComponent') as Tab1(Col1)
						where Tab.Col.value('(LocationId)[1]','INT') = @TmpLocationID   

						--------------------start test lines-----------------
						--select * from @TepRADMMaterialComponent
						--------------------end test lines ------------------

						insert into @TepRADMDepartment
						(
						    [LocationID], 
							[Name],
							[RRMDepartmentID],
							[Final_RadiationDepartmentID] 
						)
						select    
						    @TmpLocationID as  [LocationID],
							Tab1.Col1.value('(Name)[1]','VARCHAR(500)') as [Name],
							Tab1.Col1.value('(RRMDepartmentID)[1]','INT') as [RRMDepartmentID],
							(case when Tab1.Col1.value('(RRMDepartmentID)[1]','INT') > 0 
							      then Tab1.Col1.value('(RRMDepartmentID)[1]','INT') else 0 end) as [Final_RadiationDepartmentID]       
						from @LicenceDataXML.nodes('//RADMLicenceData/MaterialsTransfer/RADMRRMsTransfer/RRMsTransferred/RADMLocation') as Tab(Col)
						cross apply Tab.Col.nodes('Departments/RADMDepartment') as Tab1(Col1)
						where Tab.Col.value('(LocationId)[1]','INT') = @TmpLocationID 

						--------------------start test lines-----------------
						--select * from @TepRADMDepartment
						--------------------end test lines ------------------	

						--The following line will help to stop the looping
						UPDATE @TepRADMMaterial SET [NewRADMMaterial] = 100 WHERE RRMId = @TmpRowID
					END
					 
			SELECT @Cnt3 = @Cnt3 + 1
				
			delete @TepRADMMaterial	
			delete @TepRADMMaterialComponent
			delete @TepRADMDepartment	
		END
		 
	    --****************************************************************************************************************************************************************
		--**************************************** END PROCESS MaterialsTransfer DATA we do not need process Data section: MaterialsDispose **************************** 
		
		
		--delete the temp radiation location data
		delete @TempRADMLocation
		--delete @MyTable
		----- start loop through the top level radiation location data rows-------------------------------------------------------------------			 
	END				

	