	declare @RadiationLicenceVariationID INT = 40560
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
												[Final_AddressID] [int] NULL
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
				[VariationPendingFlag]
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
				xmlVals.rowvals.value('(VariationPendingFlag)[1]','BIT')
			From @LicenceDataXML.nodes('//RADMLicenceData/LocationsandMaterials/RADMLocation') as xmlVals(rowvals)
		
		--start test line-------------------------			        
		--print '@LocationDataCount value = ' + cast(@LocationDataCount as varchar(max))
		--end test line --------------------------
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
											[IsTranferred] BIT NULL,
											[IsEdited] BIT NULL						 												 
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
											[IsTranferred] BIT NULL,
											[IsEdited] BIT NULL						 												 
											)
		-----------------------------------------------------------------------------------------------------
		-----------------------------------------------------------------------------------------------------
		DECLARE @TempRADMDepartment AS TABLE(		
		                                    [LocationID] INT NULL,										
											[Name] [varchar](500) NOT NULL,
											[RRMDepartmentID] [int] NOT NULL 									 												 
											)
		-----------------------------------------------------------------------------------------------------
         
		--start test line-------------------------
		--select * from @TempRADMLocation
		--end test line --------------------------

		----- start loop through the top level radiation location data rows-------------------------------------------------------------------
		DECLARE @MyTable TABLE
		(
			SNo int IDENTITY(1,1), 
			LocationId int,
			RadiationLocationID int null,
			IsRelocated bit null,
			RelocatedLicenceID int null,
			VariationPendingFlag bit null
		)    
		INSERT INTO @MyTable(LocationId, RadiationLocationID, IsRelocated, RelocatedLicenceID, VariationPendingFlag)	    
		SELECT LocationId, RadiationLocationID, IsRelocated, RelocatedLicenceID, VariationPendingFlag
		FROM @TempRADMLocation
	 
		declare @Cnt int
		SELECT @Cnt = MIN(Sno) FROM @MyTable	 

		WHILE (1=1)
		BEGIN
			declare @TempLocationId int = 0
			declare @TempRadiationLocationID int = 0
			declare @TempVariationPendingFlag bit
			declare @TempIsRelocated bit
			declare @TempRelocatedLicenceID int = 0
			 		
			SELECT @TempLocationId = LocationId, @TempVariationPendingFlag = VariationPendingFlag, @TempRadiationLocationID = RadiationLocationID, @TempIsRelocated = IsRelocated, @TempRelocatedLicenceID = RelocatedLicenceID FROM @MyTable
			WHERE SNo = @Cnt	    
			IF @@ROWCOUNT = 0
			BREAK


		    -------------start test lines-----------
			--select * from @TempRADMLocation where RadiationLocationID = @TempRadiationLocationID
			------------  end test lines -----------

			-----------------------------------------------------------------------------------------------------
			If @TempVariationPendingFlag = 1 
			begin
			   
			   -------------start test lines-----------
			   --print '@TempLocation has been changed during variation process we need update location data here'
			   --print '@@TempRadiationLocationID value = ' + cast(@TempRadiationLocationID as varchar(50))
			   ------------  end test lines -----------

			  --it means the location data has been changed we need do update here
			  --1. if RadiationLocationID = -1 it means this record is newly added one
			  if @TempRadiationLocationID = 100 
			  begin
			         DECLARE @AddressID int = 0
					 DECLARE @InsertRadiationLocationID int = 0
					 DECLARE @tblRadiationLocation tblInstrumentRadiationLocationType
					 DECLARE @tblAddressTemp tblAddressType
					 print 'insert a new location data into database'
					 --1. insert into tblAddress
					 insert into @tblAddressTemp(
									 AddressID
									,[Address]
									,Suburb
									,Postcode
									,StateCode
									,CreatedBySystemUserID
									,UpdatedBySystemUserID
									,RowTimestamp
									,PrefixAddress
									,Country
									,OverseasAddressFlag)	 
					 select          -1 as AddressID  --make sure this record will be inserted into tblAddress table
									,[Address]
									,Suburb
									,Postcode
									,State 
									,@CurrentUserID as CreatedBySystemUserID
									,null as UpdatedBySystemUserID
									,null as RowTimestamp
									,null as PrefixAddress
									,null as Country
									,0 as OverseasAddressFlag from  @TempRADMLocation
					 where  cast(LocationId as varchar) = cast(@TempRadiationLocationID as varchar)

					 ----*************************Start Real action insert record into tblAddress ************************* 
					 Exec @AddressID = uspSaveAddress @tblAddressTemp		
					 IF @AddressID < 0 RAISERROR ('Problem saving uspSaveAddress' , 16, 1)
					 ----*************************End Real action insert record into tblAddress ************************* 
				     update @TempRADMLocation set Final_AddressID = @AddressID where  cast(LocationId as varchar) = cast(@TempRadiationLocationID as varchar)

				     --2. insert into tblRadiationLocation
					 INSERT INTO tblRadiationLocation(
					             LocationName
								,AddressID
								,AdditionalAddressInformation
								,EffectiveDateFrom
								,DateCreated
								,CreatedBySystemUserID)
					 Select		 Name
								,@AddressID
								,AddInfo
								,GETDATE()
								,GETDATE()
								,@CurrentUserID as CreatedBySystemUserID
					 From @TempRADMLocation
					 WHERE LocationId = @TempRadiationLocationID and Final_AddressID = @AddressID    		  
 					 SET @InsertRadiationLocationID = (SELECT @@IDENTITY)
					
					 --here we add record into table: @tblRadiationLocation 
					 if not exists(select RadiationLocationID from @tblRadiationLocation where RadiationLocationID = @InsertRadiationLocationID)
					 begin
						INSERT INTO @tblRadiationLocation
						(InstrumentRadiationLocationID,
						InstrumentID,
						RadiationLocationID,
						VariationPendingFlag,
						EffectiveDateFrom,
						CreatedBySystemUserID,
						UpdatedBySystemUserID,						 
						Action)
								 							 
						select 
					    -1 as InstrumentRadiationLocationID,
						@InstrumentID as InstrumentID,
						@InsertRadiationLocationID as RadiationLocationID,
						0 as VariationPendingFlag,
						getdate() as EffectiveDateFrom,
						@CurrentUserID as CreatedBySystemUserID,
						null as UpdatedBySystemUserID,
					   'I' as Action  								 								 
					 end						

				     --3. insert into tblInstrumentRadiationLocation
				     declare @RtnVal int = 0
					 Exec @RtnVal = uspRadiationLinkLocations @tblRadiationLocation, @InstrumentID
					 IF @RtnVal <> 0 RAISERROR ('Problem saving uspLinkRadiationLocations' , 16, 1) 				    
			  end
			  
			  if @TempRadiationLocationID > 0
			  begin
			     print 'update location data into database'

				 declare @TempLocationName varchar(200) = ''
				 declare @TempAddInfo varchar(500) = ''
				 select @TempLocationName = Name, @TempAddInfo = AddInfo from @TempRADMLocation where RadiationLocationID = @TempRadiationLocationID

				 --1. update tblRadiationLocation
				 --update tblRadiationLocation set LocationName = @TempLocationName, AdditionalAddressInformation = @TempAddInfo,  UpdatedBySystemUserID = 1, DateUpdated = getdate()
				 --where RadiationLocationID = @TempRadiationLocationID

				 --2. update tblAddress
				 --update a set
				 --a.[Address] = c.[Address],
				 --a.[suburb] = c.Suburb,
				 --a.[Postcode] = c.Postcode,
				 --a.StateCode = c.[State]
				 --from tblAddress a 
				 --inner join tblRadiationLocation b on a.AddressID = b.AddressID
				 --inner join @TempRADMLocation c on b.RadiationLocationID = c.RadiationLocationID
				 --where c.RadiationLocationID = @TempRadiationLocationID 
			  end
			end
			-----------------------------------------------------------------------------------------------------
 
            If @TempLocationId > 0
			begin
			            print '@TempLocationId value = ' + cast(@TempLocationId as varchar(50))
						--start build the RADMMaterial table data---	
						insert into @TempRADMMaterial
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
							[LabClassificationId], 																												 
							[Department],
							[WorkArea],
							[SealedSources],
							[RadiationLicenceRRMID],
							[VariationPendingFlag],
							[IsDisposed],
							[IsTranferred],
							[IsEdited]
						)
						select
						    Tab1.Col1.value('(RRMId)[1]','INT') as RRMId,
						    @TempLocationId as  [LocationID],
							Tab1.Col1.value('(Type/Id)[1]','INT') as TypeId, 
							Tab1.Col1.value('(Type/Name)[1]','VARCHAR(100)') as TypeName, 
							Tab1.Col1.value('(Purpose/Id)[1]','INT') as [PurposeId], 
							Tab1.Col1.value('(Purpose/MaterialTypeId)[1]','INT') as [PurposeMaterialTypeId], 
							Tab1.Col1.value('(Purpose/Name)[1]','VARCHAR(100)') as [PurposeName], 
							Tab1.Col1.value('(Equipment/Id)[1]','INT') as [EquipmentId], 
							Tab1.Col1.value('(Equipment/MaterialTypeId)[1]','INT') as [EquipmentMaterialTypeId], 
							Tab1.Col1.value('(Equipment/PurposeId)[1]','INT') as [EquipmentPurposeId], 
							Tab1.Col1.value('(Equipment/Name)[1]','VARCHAR(100)') as [EquipmentName], 
							Tab1.Col1.value('(LabClassification/Id)[1]','INT') as [LabClassificationId], 
							Tab1.Col1.value('(Department)[1]','VARCHAR(100)') as Department,
							Tab1.Col1.value('(WorkArea)[1]','VARCHAR(500)') as [WorkArea],
							Tab1.Col1.value('(SealedSources)[1]','VARCHAR(1000)') as [SealedSources], 
							Tab1.Col1.value('(RadiationLicenceRRMID)[1]','INT') as RadiationLicenceRRMID, 
							Tab1.Col1.value('(VariationPendingFlag)[1]','BIT') as VariationPendingFlag,    
							Tab1.Col1.value('(IsDisposed)[1]','BIT') as IsDisposed,   
							Tab1.Col1.value('(IsTranferred)[1]','BIT') as IsTranferred,   
							Tab1.Col1.value('(IsEdited)[1]','BIT') as IsEdited
						from @LicenceDataXML.nodes('//RADMLicenceData/LocationsandMaterials/RADMLocation') as Tab(Col)
						cross apply Tab.Col.nodes('Materials/RADMMaterial') as Tab1(Col1)
						where Tab.Col.value('(LocationId)[1]','INT') = @TempLocationId   
						--end build the RADMMaterial table data ----  

						--start insert into @TempRADMMaterialComponent---
						insert into @TempRADMMaterialComponent
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
							[IsTranferred],
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
							Tab1.Col1.value('(IsTranferred)[1]','BIT') as IsTranferred,   
							Tab1.Col1.value('(IsEdited)[1]','BIT') as IsEdited 
						from @LicenceDataXML.nodes('//RADMLicenceData/LocationsandMaterials/RADMLocation') as Tab(Col)
						cross apply Tab.Col.nodes('Materials/RADMMaterial/Containers/RADMMaterialComponent') as Tab1(Col1)
						where Tab.Col.value('(LocationId)[1]','INT') = @TempLocationId   
						--end insert into @TempRADMMaterialComponent

						 --start build the RADMDepartment table data---												 
						insert into @TempRADMDepartment
						(
						    [LocationID], 
							[Name],
							[RRMDepartmentID] 
						)
						select    
						    @TempLocationId as  [LocationID],
							Tab1.Col1.value('(Name)[1]','VARCHAR(500)') as [Name],
							Tab1.Col1.value('(RRMDepartmentID)[1]','INT') as [RRMDepartmentID]     
						from @LicenceDataXML.nodes('//RADMLicenceData/LocationsandMaterials/RADMLocation') as Tab(Col)
						cross apply Tab.Col.nodes('Departments/RADMDepartment') as Tab1(Col1)
						where Tab.Col.value('(LocationId)[1]','INT') = @TempLocationId   
						--end build the RADMDepartment table data ----                    
			end
  
		    select @Cnt = @Cnt + 1	

			-------------start test lines-----------
			--select * from  @TempRADMMaterial	
			--select * from  @TempRADMMaterialComponent
			--select * from  @TempRADMDepartment	
			------------  end test lines -----------

			delete @TempRADMMaterial
			delete @TempRADMMaterialComponent
			delete @TempRADMDepartment	   
		END

	  
		--delete the temp radiation location data
		delete @MyTable
		----- start loop through the top level radiation location data rows-------------------------------------------------------------------
 	 
	END
 