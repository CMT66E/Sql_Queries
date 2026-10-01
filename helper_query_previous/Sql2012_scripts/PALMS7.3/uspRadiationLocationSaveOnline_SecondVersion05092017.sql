	declare @theInstrumentID INT = 5068711
-------------------------------------------------------
	declare @theXMLData AS XML = 
	'
<DataRadiationLocation>
  
  <RadiationLocation>
    <RadiationLocationID>0</RadiationLocationID>
    <LocationName>sdfsdf</LocationName>
    <AddressID>0</AddressID>
    <AdditionalAddressInformation />
  </RadiationLocation>
  
  
  <Address>
    <AddressID>0</AddressID>
    <Address>sdsf</Address>
    <Suburb>HURSTVILLE</Suburb>
    <Postcode>2220</Postcode>
    <StateCode>NSW</StateCode>
  </Address>
  
  
  <RadiationLocationRRM>
    <RadiationLocationRRMID>-1</RadiationLocationRRMID>
    <RadiationLocationID>0</RadiationLocationID>
    <RadiationLicenceRRMID>0</RadiationLicenceRRMID>
  </RadiationLocationRRM>
  <RadiationLocationRRM>
    <RadiationLocationRRMID>-1</RadiationLocationRRMID>
    <RadiationLocationID>0</RadiationLocationID>
    <RadiationLicenceRRMID>1</RadiationLicenceRRMID>
  </RadiationLocationRRM>      
  <RadiationLicenceRRM>
    <RadiationLicenceRRMID>0</RadiationLicenceRRMID>
    <RRMStatusID>784</RRMStatusID>
    <RRMTypeID>1</RRMTypeID>
    <RRMID>44</RRMID>
    <RRMPurposeID>2</RRMPurposeID>
    <WorkArea>sdfasdfsdf</WorkArea>
    <RRMSecurityClassificationID  />
    <LaboratoryClassificationID>-1</LaboratoryClassificationID>
    <RRMDepartmentID>0</RRMDepartmentID>
  </RadiationLicenceRRM>
  <RadiationLicenceRRM>
    <RadiationLicenceRRMID>1</RadiationLicenceRRMID>
    <RRMStatusID>784</RRMStatusID>
    <RRMTypeID>2</RRMTypeID>
    <RRMID>33</RRMID>
    <RRMPurposeID>-1</RRMPurposeID>
    <WorkArea>ersdasdgfsdf</WorkArea>
    <RRMSecurityClassificationID  />
    <LaboratoryClassificationID>-1</LaboratoryClassificationID>
    <RRMDepartmentID>0</RRMDepartmentID>
  </RadiationLicenceRRM>
  
   
  <RRMComponent>
    <RRMComponentID>0</RRMComponentID>
    <RadiationLicenceRRMID>0</RadiationLicenceRRMID>
    <ComponentStatusID>784</ComponentStatusID>
    <RRMComponentTypeID>1</RRMComponentTypeID>
    <ManufacturerID>167</ManufacturerID>
    <ModelNumber>12312</ModelNumber>
    <SerialNumber>fasfsd</SerialNumber>
    <ExtendedWorkingLifeFlag />
    <WorkingLife />
    <RadionuclideID />
    <NominalActivity  />
  </RRMComponent>
  <RRMComponent>
    <RRMComponentID>1</RRMComponentID>
    <RadiationLicenceRRMID>0</RadiationLicenceRRMID>
    <ComponentStatusID>784</ComponentStatusID>
    <RRMComponentTypeID>2</RRMComponentTypeID>
    <ManufacturerID>42</ManufacturerID>
    <ModelNumber>sdf</ModelNumber>
    <SerialNumber>sdfas</SerialNumber>
    <ExtendedWorkingLifeFlag  />
    <WorkingLife  />
    <RadionuclideID  />
    <NominalActivity  />
  </RRMComponent>
  <RRMComponent>
    <RRMComponentID>2</RRMComponentID>
    <RadiationLicenceRRMID>0</RadiationLicenceRRMID>
    <ComponentStatusID>784</ComponentStatusID>
    <RRMComponentTypeID>3</RRMComponentTypeID>
    <ManufacturerID>96</ManufacturerID>
    <ModelNumber>sdfasd</ModelNumber>
    <SerialNumber>sdafasdfsdfsdfasf</SerialNumber>
    <ExtendedWorkingLifeFlag  />
    <WorkingLife />
    <RadionuclideID  />
    <NominalActivity />
  </RRMComponent>
  <RRMComponent>
    <RRMComponentID>3</RRMComponentID>
    <RadiationLicenceRRMID>1</RadiationLicenceRRMID>
    <ComponentStatusID>784</ComponentStatusID>
    <RRMComponentTypeID>4</RRMComponentTypeID>
    <ManufacturerID>167</ManufacturerID>
    <ModelNumber>sdf</ModelNumber>
    <SerialNumber>sdfasdf</SerialNumber>
    <ExtendedWorkingLifeFlag />
    <WorkingLife  />
    <RadionuclideID  />
    <NominalActivity />
  </RRMComponent>
  <RRMComponent>
    <RRMComponentID>4</RRMComponentID>
    <RadiationLicenceRRMID>1</RadiationLicenceRRMID>
    <ComponentStatusID>784</ComponentStatusID>
    <RRMComponentTypeID>5</RRMComponentTypeID>
    <ManufacturerID>40</ManufacturerID>
    <SerialNumber>432</SerialNumber>
    <ExtendedWorkingLifeFlag>false</ExtendedWorkingLifeFlag>
    <WorkingLife>15</WorkingLife>
    <RadionuclideID>6</RadionuclideID>
    <NominalActivity>12.0</NominalActivity>
  </RRMComponent>
  
  
  <RadiationDepartment>
    <RadiationDepartmentID>0</RadiationDepartmentID>
    <RadiationLocationID>0</RadiationLocationID>
    <DepartmentName>1111111111111</DepartmentName>
  </RadiationDepartment>
  
</DataRadiationLocation>


	'	
-------------------------------------------------------
    SET NOCOUNT ON
	DECLARE @tblRadiationLocation tblInstrumentRadiationLocationType
	BEGIN TRY
		if DATALENGTH(@theXMLData) > 0 
		begin
		    -----------------------------------------------------start fetch all data and insert into temp tables-----------------------------------------------------
					declare @LocationDataCount int = 0
					select  @LocationDataCount = count(*) From @theXMLData.nodes('//DataRadiationLocation/RadiationLocation') as xmlVals(rowvals) 
					where len(isnull(xmlVals.rowvals.value('(LocationName)[1]','VARCHAR(500)'), '')) > 0 

					--print '@@LocationDataCount='+ cast(@LocationDataCount as varchar)

					------ Start RadiationLocation --------------------------------
					DECLARE @TempRadiationLocation AS TABLE(
															[RadiationLocationID] [int] NOT NULL,
															[LocationName] [varchar](128) NOT NULL,
															[AddressID] [int] NULL,
															[AdditionalAddressInformation] [varchar](1000) NULL,
															[EffectiveDateFrom] [smalldatetime] NULL,
															[EffectiveDateTo] [smalldatetime] NULL,
															[DateCreated] [smalldatetime] NULL,
															[CreatedBySystemUserID] [int] NULL,
															[DateUpdated] [smalldatetime] NULL,
															[UpdatedBySystemUserID] [int] NULL,
															[RowTimestamp] [varchar](4000) NULL,
															[InstrumentID] [int] NULL,
															[Final_RadiationLocationID] [int] NULL
														    )


					INSERT INTO @TempRadiationLocation
						(
							[RadiationLocationID],
							[LocationName],
							[AddressID],
							[AdditionalAddressInformation],	
							[EffectiveDateFrom],
							[EffectiveDateTo],
							[DateCreated],
							[CreatedBySystemUserID],
							[DateUpdated],
							[UpdatedBySystemUserID],			 						 
							[InstrumentID]
						)
						SELECT
							xmlVals.rowvals.value('(RadiationLocationID)[1]','INT'),
							xmlVals.rowvals.value('(LocationName)[1]','VARCHAR(128)'),
							xmlVals.rowvals.value('(AddressID)[1]','int'),
							xmlVals.rowvals.value('(AdditionalAddressInformation)[1]','VARCHAR(1000)'),		
							getdate() as [EffectiveDateFrom],
							null as  [EffectiveDateTo],
							getdate() as [DateCreated],
							1 as [CreatedBySystemUserID],
							null as [DateUpdated],
							null as [UpdatedBySystemUserID],		 
							0 as [InstrumentID]
						From @theXMLData.nodes('//DataRadiationLocation/RadiationLocation') as xmlVals(rowvals)

					--******************************************************
					 --select * from @TempRadiationLocation
					--******************************************************
					------ End RadiationLocation --------------------------------


					------ Start Address --------------------------------
					DECLARE @tblAddress AS TABLE(
												[AddressID] [int] NOT NULL,
												[PrefixAddress] [varchar](100) NULL,
												[Country] [varchar](100) NULL,
												[OverseasAddressFlag] [bit] NULL,
												[Address] [varchar](100) NULL,
												[Suburb] [varchar](50) NOT NULL,
												[Postcode] [char](10) NOT NULL,
												[StateCode] [char](20) NOT NULL,
												[DateCreated] [smalldatetime] NULL,
												[CreatedBySystemUserID] [int] NULL,
												[DateUpdated] [smalldatetime] NULL,
												[UpdatedBySystemUserID] [int] NULL,
												[Final_AddressID] [int] NULL
												) 
					INSERT INTO @tblAddress(AddressID
											,[Address]
											,Suburb
											,Postcode
											,StateCode
											,CreatedBySystemUserID
											,UpdatedBySystemUserID								 
											,PrefixAddress
											,Country
											,OverseasAddressFlag)
					SELECT	RN.S.value('AddressID[1]','int') AS AddressID,
							RN.S.value('Address[1]','varchar(100)') AS Address,
							RN.S.value('Suburb[1]','varchar(100)') AS Suburb,
							RN.S.value('Postcode[1]','char(10)') AS Postcode,
							RN.S.value('StateCode[1]','char(20)') AS StateCode,
							1 AS CreatedBySystemUserID,
							null AS UpdatedBySystemUserID,				 
							null AS PrefixAddress,	
							null AS Country,		 
							0 AS OverseasAddressFlag			 
					FROM @theXMLData.nodes('//DataRadiationLocation/Address') AS RN(S)
					--******************************************************
					 --select * from @tblAddress
					--******************************************************
					------ End Address --------------------------------

					------- Start Radiation Department -----------------------------------
					DECLARE @tblRadiationDepartment0 as Table(
																[SNo] [int] IDENTITY(1,1) NOT NULL,
																[RadiationDepartmentID] [int] NOT NULL,
																[RadiationLocationID] [int] NOT NULL,
																[DepartmentName] [varchar](255) NOT NULL,
																[EffectiveDateFrom] [smalldatetime] NOT NULL,
																[EffectiveDateTo] [smalldatetime] NULL,
																[DateCreated] [smalldatetime] NOT NULL,
																[CreatedBySystemUserID] [int] NOT NULL,
																[DateUpdated] [smalldatetime] NULL,
																[UpdatedBySystemUserID] [int] NULL,																 
																[Action] [char](1) NULL,
																[Final_RadiationDepartmentID] [int] NULL
															 )

					INSERT INTO @tblRadiationDepartment0
						(
							[RadiationDepartmentID],
							[RadiationLocationID],
							[DepartmentName],				 
							[EffectiveDateFrom],
							[EffectiveDateTo],
							[DateCreated],
							[CreatedBySystemUserID],
							[DateUpdated],
							[UpdatedBySystemUserID],			 
							[Action]
						)
						SELECT
							xmlVals.rowvals.value('(RadiationDepartmentID)[1]','INT'),
							xmlVals.rowvals.value('(RadiationLocationID)[1]','int'),
							xmlVals.rowvals.value('(DepartmentName)[1]','VARCHAR(255)'),												 
							getdate() as [EffectiveDateFrom],
							null as  [EffectiveDateTo],
							getdate() as [DateCreated],
							1 as [CreatedBySystemUserID],
							null as [DateUpdated],
							null as [UpdatedBySystemUserID],							 
							'I' as [Action]
						From @theXMLData.nodes('//DataRadiationLocation/RadiationDepartment') as xmlVals(rowvals)

					--******************************************************
					--select * from @tblRadiationDepartment0
					--******************************************************
					------- End Radiation Department-----------------------------------
				


					------- Start RadiationLocationRRM -----------------------------------
					DECLARE @TempRadiationLocationRRM0 AS TABLE(
					                                            [SNo] [int] IDENTITY(1,1) NOT NULL,
																[RadiationLocationRRMID] [int] NOT NULL,
																[RadiationLocationID] [int] NOT NULL,
																[RadiationLicenceRRMID] [int] NOT NULL,
																[VariationPendingFlag] [bit] NOT NULL,
																[NewLocationID] [int] NULL,
																[Notes] [varchar](255) NULL,
																[InterstateOverseasRelocationFlag] [bit] NOT NULL,
																[Recipient] [varchar](150) NULL,
																[RecipientAddress] [varchar](255) NULL,
																[State] [varchar](3) NULL,
																[Country] [varchar](150) NULL,
																[EffectiveDateFrom] [smalldatetime] NOT NULL,
																[EffectiveDateTo] [smalldatetime] NULL,
																[DateCreated] [smalldatetime] NOT NULL,
																[CreatedBySystemUserID] [int] NOT NULL,
																[DateUpdated] [smalldatetime] NULL,
																[UpdatedBySystemUserID] [int] NULL,
																[RowTimestamp] [varchar](4000) NULL,
																[RecordMode] [varchar](1) NULL,
																[FLAG] [int],
																[NewRadiationLocationRRMID] [int] NULL
																) 

					INSERT INTO @TempRadiationLocationRRM0
						(
							 [RadiationLocationRRMID]
							,[RadiationLocationID]
							,[RadiationLicenceRRMID]
							,[VariationPendingFlag]
							,[InterstateOverseasRelocationFlag]
							,[Notes]
							,[EffectiveDateFrom]
							,[EffectiveDateTo]
							,[DateCreated]
							,[CreatedBySystemUserID]
							,[DateUpdated]
							,[UpdatedBySystemUserID]			 
							,[RecordMode]
							,[FLAG]
							,[NewRadiationLocationRRMID]
						)
						SELECT
							xmlVals.rowvals.value('(RadiationLocationRRMID)[1]','INT'),
							xmlVals.rowvals.value('(RadiationLocationID)[1]','INT'),
							xmlVals.rowvals.value('(RadiationLicenceRRMID)[1]','INT'),
							0 as [VariationPendingFlag],	
							0 as [InterstateOverseasRelocationFlag],			
							'' as [Notes],		
							getdate() as [EffectiveDateFrom],
							null as  [EffectiveDateTo],
							getdate() as [DateCreated],
							1 as [CreatedBySystemUserID],
							null as [DateUpdated],
							null as [UpdatedBySystemUserID],
							'A' as [RecordMode],
							0 as [FLAG],
							null as [NewRadiationLocationRRMID]
						From @theXMLData.nodes('//DataRadiationLocation/RadiationLocationRRM') as xmlVals(rowvals)

					--******************************************************
					--select * from @TempRadiationLocationRRM0
					--******************************************************
					------- End RadiationLocationRRM-----------------------------------


					------- Start RadiationLicenceRRM-----------------------------------
					DECLARE @TempRadiationLicenceRRM0 AS TABLE(
																[RadiationLicenceRRMID] [int] NOT NULL,
																[RRMStatusID] [smallint] NOT NULL,
																[RRMTypeID] [smallint] NOT NULL,
																[RRMPurposeID] [smallint] NULL,
																[RRMID] [smallint] NULL,
																[WorkArea] [varchar](255) NULL,
																[RRMSecurityClassificationID] [smallint] NULL,
																[LaboratoryClassificationID] [smallint] NULL,
																[DateCreated] [smalldatetime] NOT NULL,
																[CreatedBySystemUserID] [int] NOT NULL,
																[DateUpdated] [smalldatetime] NULL,
																[UpdatedBySystemUserID] [int] NULL,
																[RowTimestamp] [varchar](4000) NULL,
																[RecordMode] [varchar](1) NULL,
																[NewRadiationLicenceRRMID] [int] NULL,
																[RRMDepartmentID] [smallint] NULL,
																[FLAG] [int] 
																)

					INSERT INTO @TempRadiationLicenceRRM0
						(
							 [RadiationLicenceRRMID]
							,[RRMStatusID]
							,[RRMTypeID]
							,[RRMPurposeID]
							,[RRMID]
							,[WorkArea]
							,[RRMSecurityClassificationID]
							,[LaboratoryClassificationID]

							,[DateCreated]
							,[CreatedBySystemUserID]
							,[DateUpdated]
							,[UpdatedBySystemUserID]
				 
							,[RecordMode]
							,[NewRadiationLicenceRRMID]
							,[RRMDepartmentID]
							,[FLAG]
						)
						SELECT
							xmlVals.rowvals.value('(RadiationLicenceRRMID)[1]','INT'),
							xmlVals.rowvals.value('(RRMStatusID)[1]','INT'),
							xmlVals.rowvals.value('(RRMTypeID)[1]','INT'),
							xmlVals.rowvals.value('(RRMPurposeID)[1]','INT'),
							xmlVals.rowvals.value('(RRMID)[1]','int'),				
							xmlVals.rowvals.value('(WorkArea)[1]','varchar(255)'),		
							xmlVals.rowvals.value('(RRMSecurityClassificationID)[1]','smallint'),
							xmlVals.rowvals.value('(LaboratoryClassificationID)[1]','smallint'),
						
							getdate() as [DateCreated],
							1 as [CreatedBySystemUserID],
							null as [DateUpdated],
							null as [UpdatedBySystemUserID],
							'A' as RecordMode, 	
							null as [NewRadiationLicenceRRMID],							
							xmlVals.rowvals.value('(RRMDepartmentID)[1]','smallint'),
							0 as [FLAG]
						From @theXMLData.nodes('//DataRadiationLocation/RadiationLicenceRRM') as xmlVals(rowvals)
			
			  
					--******************************************************
					 --select * from @TempRadiationLicenceRRM0
					--******************************************************					 
					------- End RadiationLicenceRRM-----------------------------------


					------- Start RadiationLicenceRRMComponent-----------------------------------
					DECLARE @TempRadiationLicenceRRMComponent0 AS TABLE(
																		[RadiationLicenceRRMComponentID] [int] NOT NULL,
																		[RadiationLicenceRRMID] [int] NOT NULL,
																		[RRMComponentID] [int] NOT NULL,
																		[VariationPendingFlag] [bit] NOT NULL,
																		[NewRadiationLicenceRRMID] [int] NULL,
																		[Notes] [varchar](255) NULL,
																		[InterstateOverseasRelocationFlag] [bit] NOT NULL,
																		[Recipient] [varchar](150) NULL,
																		[RecipientAddress] [varchar](255) NULL,
																		[State] [varchar](3) NULL,
																		[Country] [varchar](150) NULL,
																		[EffectiveDateFrom] [smalldatetime] NOT NULL,
																		[EffectiveDateTo] [smalldatetime] NULL,
																		[DateCreated] [smalldatetime] NOT NULL,
																		[CreatedBySystemUserID] [int] NOT NULL,
																		[DateUpdated] [smalldatetime] NULL,
																		[UpdatedBySystemUserID] [int] NULL,
																		[RowTimestamp] [varchar](4000) NULL,
																		[RecordMode] [varchar](1) NULL)

					INSERT INTO @TempRadiationLicenceRRMComponent0
								(
									 [RadiationLicenceRRMComponentID]
									,[RadiationLicenceRRMID]
									,[RRMComponentID]
									,[VariationPendingFlag]
									,[Notes]
									,[InterstateOverseasRelocationFlag]
									,[EffectiveDateFrom]
									,[DateCreated]
									,[CreatedBySystemUserID]
									,[DateUpdated]
									,[UpdatedBySystemUserID]					 
									,[RecordMode]
								)
								SELECT
									xmlVals.rowvals.value('(RadiationLicenceRRMComponentID)[1]','INT'),
									xmlVals.rowvals.value('(RadiationLicenceRRMID)[1]','INT'),
									xmlVals.rowvals.value('(RRMComponentID)[1]','INT'),
									xmlVals.rowvals.value('(VariationPendingFlag)[1]','bit'),				
									xmlVals.rowvals.value('(Notes)[1]','varchar(255)'),
									xmlVals.rowvals.value('(InterstateOverseasRelocationFlag)[1]','bit'),
									GETDATE(),
									xmlVals.rowvals.value('(DateCreated)[1]','smalldatetime'),
									xmlVals.rowvals.value('(CreatedBySystemUserID)[1]','int'),
									xmlVals.rowvals.value('(DateUpdated)[1]','smalldatetime'),
									xmlVals.rowvals.value('(UpdatedBySystemUserID)[1]','int'),						 
									'A' as RecordMode
								From @theXMLData.nodes('//DataRadiationLocation/RadiationLicenceRRMComponent') as xmlVals(rowvals)

					--******************************************************
					--select * from @TempRadiationLicenceRRMComponent0
					--******************************************************		 
					------- End RadiationLicenceRRMComponent-----------------------------------



					------- Start RRMComponent-----------------------------------
					DECLARE @TempRRMComponent0 AS TABLE(
														[RRMComponentID] [int] NOT NULL,
														[RadiationLicenceRRMID] [int] NOT NULL,
														[ComponentStatusID] [smallint] NOT NULL,
														[RRMComponentTypeID] [smallint] NOT NULL,
														[AssayDate] [smalldatetime] NULL,
														[ManufacturerID] [smallint] NULL,
														[ModelNumber] [varchar](30) NULL,
														[SerialNumber] [varchar](30) NULL,
														[RadionuclideID] [int] NULL,
														[NominalActivity] [decimal](12, 2) NULL,
														[WorkingLife] [smallint] NULL,
														[ExtendedWorkingLifeFlag] [bit] NOT NULL,
														[DateCreated] [smalldatetime] NOT NULL,
														[CreatedBySystemUserID] [int] NOT NULL,
														[DateUpdated] [smalldatetime] NULL,
														[UpdatedBySystemUserID] [int] NULL,
														[RowTimestamp] [varchar](4000) NULL,
														[RecordMode] [varchar](1) NULL,
														[NewRRMComponentID] [int] NULL)

					INSERT INTO @TempRRMComponent0
								(
									[RRMComponentID],
									[RadiationLicenceRRMID],
									[ComponentStatusID],
									[RRMComponentTypeID],
									[AssayDate],
									[ManufacturerID],
									[ModelNumber],
									[SerialNumber],
									[RadionuclideID],
									[NominalActivity],
									[WorkingLife],
									[ExtendedWorkingLifeFlag],
									[DateCreated],
									[CreatedBySystemUserID],
									[DateUpdated],
									[UpdatedBySystemUserID],						 
									[RecordMode],
									[NewRRMComponentID]
								)
								SELECT
									xmlVals.rowvals.value('(RRMComponentID)[1]','INT'),
									xmlVals.rowvals.value('(RadiationLicenceRRMID)[1]','INT'),
									xmlVals.rowvals.value('(ComponentStatusID)[1]','INT'),
									xmlVals.rowvals.value('(RRMComponentTypeID)[1]','INT'),
									xmlVals.rowvals.value('(AssayDate)[1]','smalldatetime'),				
									xmlVals.rowvals.value('(ManufacturerID)[1]','int'),		
									xmlVals.rowvals.value('(ModelNumber)[1]','varchar(30)'),
									xmlVals.rowvals.value('(SerialNumber)[1]','varchar(30)'),
									xmlVals.rowvals.value('(RadionuclideID)[1]','int'),				
									case when len(xmlVals.rowvals.value('(NominalActivity)[1]','varchar(30)')) = 0 then 0 else xmlVals.rowvals.value('(NominalActivity)[1]','decimal(12, 2)') end,	
									xmlVals.rowvals.value('(WorkingLife)[1]','smallint'),
									xmlVals.rowvals.value('(ExtendedWorkingLifeFlag)[1]','bit'),
									getdate() as DateCreated,
									1 as CreatedBySystemUserID,
									null as DateUpdated,
									null as UpdatedBySystemUserID,					 
									'A' as RecordMode,
									null as [NewRRMComponentID]
								From @theXMLData.nodes('//DataRadiationLocation/RRMComponent') as xmlVals(rowvals)

					--******************************************************
					--select * from @TempRRMComponent0
					--******************************************************		 
					------- End RRMComponent-----------------------------------		  
		    -----------------------------------------------------end fetch all data and insert into temp tables-----------------------------------------------------


					--------START LOOP THROUGH RECDORDS ------------------------------------
					DECLARE @MyTable TABLE
					(
						SNo int IDENTITY(1,1), 
						RadiationLocationID int,
						AddressID int 
					)    
					INSERT INTO @MyTable(RadiationLocationID, AddressID)	    
					SELECT RadiationLocationID, AddressID
					FROM @TempRadiationLocation
	 
					declare @Cnt int
					SELECT @Cnt = MIN(Sno) FROM @MyTable
	
					declare @TempAddressID int
					declare @RadiationLocationID int
					declare @TempRadiationLocationID int
					declare @AddressID int  = 0
					declare @INSERT int
					declare @RadiationDepartmentID int

					declare @LocationName varchar(200)
					 
					declare @RadiationLocationCnt int = 0
					DECLARE @LocNameExists AS BIT = 0

					WHILE (1=1)
					BEGIN
						DECLARE @tblAddressTemp tblAddressType
			

						SELECT @TempAddressID = AddressID, @TempRadiationLocationID = RadiationLocationID FROM @MyTable
						WHERE SNo = @Cnt
	    
						IF @@ROWCOUNT = 0
						BREAK

						SELECT	@RadiationLocationID = RadiationLocationID,
								@LocationName = LocationName 
						From @TempRadiationLocation 
						WHERE cast(AddressID as varchar) = cast(@TempAddressID as varchar) and cast(RadiationLocationID as varchar) = cast(@TempRadiationLocationID as varchar)

						SET @LocationName = RTrim(LTrim(@LocationName))	

						SELECT @RadiationLocationCnt = count(*) From tblRadiationLocation Where LocationName = @LocationName --duplication check

						IF @LocationName ='' --Because location name is not mandatory, Dont check if location name not exists
							SET @LocNameExists = 0
						ELSE IF @RadiationLocationID < 0 AND @Cnt > 0 --When Inserting new location
							BEGIN
								SET @LocNameExists = 1
							END
						ELSE IF @RadiationLocationID > 0 AND @Cnt > 1 -- When updating location
							BEGIN
								SET @LocNameExists = 1
							END
						ELSE IF @RadiationLocationID > 0 AND @Cnt = 1
							BEGIN
							DECLARE @TLocationID AS INT
							SELECT @TLocationID = RadiationLocationID FROM tblRadiationLocation WHERE LocationName = @LocationName
							IF @RadiationLocationID <> @TLocationID  --If the Loc Id is different from the updating loc id
								BEGIN
									SET @LocNameExists = 1
								END
							END

						if exists(select * from @tblAddress where cast(AddressID as varchar) = cast(@TempAddressID as varchar))
						begin
						 --   print '---------------------------------------------'	
							--print '@TempRadiationLocationID =' + cast(@TempRadiationLocationID as varchar)
							--print '@addressID top before insert =' + cast(@TempAddressID as varchar)				
							--print '---------------------------------------------'		
				
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
											,StateCode
											,CreatedBySystemUserID
											,UpdatedBySystemUserID
											,null as RowTimestamp
											,PrefixAddress
											,Country
											,OverseasAddressFlag from  @tblAddress
							where  cast(AddressID as varchar) = cast(@TempAddressID as varchar)

						end
 
						 
						----*************************Start Real action insert record into tblAddress ************************* 
						Exec @AddressID = uspSaveAddress @tblAddressTemp		
						IF @AddressID < 0 RAISERROR ('Problem saving uspSaveAddress' , 16, 1)
						----*************************End Real action insert record into tblAddress ************************* 

						--here we update the temp table: @tblAddress column  and put the final real AddressID from DB's tblAddress table intp it
						update @tblAddress set Final_AddressID = @AddressID where  cast(AddressID as varchar) = cast(@TempAddressID as varchar)

						--here we insert data into table: tblRadiationLocation --------------------------
                        IF(@RadiationLocationID >= 0)
						Begin								 
									----*************************Real action insert record into tblRadiationLocation ************************* 
								INSERT INTO tblRadiationLocation(LocationName
											,AddressID
											,AdditionalAddressInformation
											,EffectiveDateFrom
											,DateCreated
											,CreatedBySystemUserID)
								Select		 LocationName
											,@AddressID
											,AdditionalAddressInformation
											,GETDATE()
											,GETDATE()
											,CreatedBySystemUserID
								From @TempRadiationLocation
								WHERE RadiationLocationID = @TempRadiationLocationID and AddressID = @TempAddressID and Final_RadiationLocationID is null   		  
 								SET @RadiationLocationID = (SELECT @@IDENTITY)	
							    							
															
								--here we add record into table: @tblRadiationLocation 
								if not exists(select RadiationLocationID from @tblRadiationLocation where RadiationLocationID = @RadiationLocationID)
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
								 @theInstrumentID as InstrumentID,
								 @RadiationLocationID as RadiationLocationID,
								 0 as VariationPendingFlag,
								 getdate() as EffectiveDateFrom,
								 1 as CreatedBySystemUserID,
								 null as UpdatedBySystemUserID,
								'I' as Action  								 								 
								end															
																 
								--we update the temp table: @TempRadiationLocation which containing all RadiationLocation from input XML
								update @TempRadiationLocation set Final_RadiationLocationID = @RadiationLocationID where RadiationLocationID = @TempRadiationLocationID and AddressID = @TempAddressID
						 end
					
					delete @tblAddressTemp		

					SELECT @Cnt = @Cnt + 1
		
					END
					--------END LOOP THROUGH RECORDS ---------------------------------------
					
					--------START SEOND LOOP: process RadiationDepartment data ---------------------------------------------------
					DECLARE @MyTableRadiationDepartment TABLE
					(
						SNo int IDENTITY(1,1), 								
						RadiationDepartmentID int,
						RadiationLocationID int 
					) 
					INSERT INTO @MyTableRadiationDepartment(RadiationDepartmentID, RadiationLocationID)	    
					SELECT RadiationDepartmentID, RadiationLocationID
					FROM @tblRadiationDepartment0
				 
					declare @Cnt3 int
					SELECT @Cnt3 = MIN(Sno) FROM @MyTableRadiationDepartment
	
					declare @TempRadiationDepartmentID3 int
					declare @TempRadiationLocationID3 int

					WHILE (1=1)
					BEGIN
   
					SELECT @TempRadiationDepartmentID3 = RadiationDepartmentID, @TempRadiationLocationID3 = RadiationLocationID FROM @MyTableRadiationDepartment
					WHERE SNo = @Cnt3

					IF @@ROWCOUNT = 0
					BREAK
					            --print 'value @Cnt3 = ' + cast(@Cnt3 as varchar)
								DECLARE @tblRadiationDepartment tblRadiationDepartmentType

								INSERT INTO @tblRadiationDepartment
									(
										[RadiationDepartmentID],
										[RadiationLocationID],
										[DepartmentName],				 
										[EffectiveDateFrom],
										[EffectiveDateTo],
										[DateCreated],
										[CreatedBySystemUserID],
										[DateUpdated],
										[UpdatedBySystemUserID],			 
										[Action]
									)
								select 
										(-1)*[RadiationDepartmentID] as [RadiationDepartmentID],
										[RadiationLocationID],
										[DepartmentName],				 
										[EffectiveDateFrom],
										[EffectiveDateTo],
										[DateCreated],
										[CreatedBySystemUserID],
										[DateUpdated],
										[UpdatedBySystemUserID],			 
										[Action]
								from @tblRadiationDepartment0
								where [RadiationDepartmentID] = @TempRadiationDepartmentID3 and RadiationLocationID = @TempRadiationLocationID3 and Final_RadiationDepartmentID is null

								--*************************Real action insert record into tblRadiationDepartment ************************* 								 
								if (select count(*) from @tblRadiationDepartment) >= 0
								begin
								    select @RadiationLocationID = Final_RadiationLocationID from @TempRadiationLocation where RadiationLocationID = @TempRadiationLocationID3
									Exec @RadiationDepartmentID = uspSaveRadiationDepartmentWithReturn @tblRadiationDepartment, @RadiationLocationID	
										
									update @tblRadiationDepartment0 set Final_RadiationDepartmentID = @RadiationDepartmentID
									where [RadiationDepartmentID] = @TempRadiationDepartmentID3 and RadiationLocationID = @TempRadiationLocationID3 and Final_RadiationDepartmentID is null
								end

								delete from @tblRadiationDepartment
				    SELECT @Cnt3 = @Cnt3 + 1
		
				    END
					--------END SEOND LOOP: process RadiationDepartment data -----------------------------------------------------

					--------START RadiationLicence RRM ---------------------------------------------------------------------------
					DECLARE @RowID AS INT = 0
					DECLARE @RadiationLicenceRRMID AS INT
						
					--Insert tblRadiationLicenceRRM rows and update newly created ids in the temp table
					WHILE (SELECT COUNT(*) FROM @TempRadiationLicenceRRM0 WHERE RecordMode = 'A' AND NewRadiationLicenceRRMID IS NULL) > 0
					BEGIN
						Select Top 1 @RowID = RadiationLicenceRRMID FROM @TempRadiationLicenceRRM0 WHERE RecordMode = 'A' AND NewRadiationLicenceRRMID IS NULL

						INSERT INTO [dbo].[tblRadiationLicenceRRM]
							([RRMStatusID]
							,[RRMTypeID]
							,[RRMPurposeID]
							,[RRMID]
							,[WorkArea]
							,[RRMSecurityClassificationID]
							,[LaboratoryClassificationID]
							,[DateCreated]
							,[CreatedBySystemUserID]
							,[RRMDepartmentID])
						SELECT 
							RRMStatusID,
							RRMTypeID,
							RRMPurposeID,
							RRMID,
							WorkArea,
							RRMSecurityClassificationID,
							LaboratoryClassificationID,
							GETDATE(),
							CreatedBySystemUserID,
							(select Final_RadiationDepartmentID from @tblRadiationDepartment0 where RadiationDepartmentID = RRMDepartmentID) as RRMDepartmentID									
						FROM @TempRadiationLicenceRRM0
							WHERE RadiationLicenceRRMID = @RowID

						SET @RadiationLicenceRRMID= @@IDENTITY

						UPDATE @TempRadiationLicenceRRM0								
						SET NewRadiationLicenceRRMID = @RadiationLicenceRRMID
						WHERE RadiationLicenceRRMID = @RowID
						 
						UPDATE @TempRadiationLicenceRRMComponent0
						SET RadiationLicenceRRMID = @RadiationLicenceRRMID
						WHERE RadiationLicenceRRMID = @RowID
					END
					--------END RadiationLicence RRM -----------------------------------------------------------------------------


					--------START RadiationLocation RRM ---------------------------------------------------------------------------
					 
					DECLARE @RowID2 AS INT = 1
					DECLARE @RadiationLocationRRMID AS INT
					WHILE (SELECT COUNT(*) FROM @TempRadiationLocationRRM0 WHERE RecordMode = 'A' AND NewRadiationLocationRRMID IS NULL) > 0
					BEGIN
					    --print 'loop here in temp tale: @TempRadiationLocationRRM0'
						Select Top 1 @RowID2 = SNo FROM @TempRadiationLocationRRM0 WHERE RecordMode = 'A' AND NewRadiationLocationRRMID IS NULL ORDER BY SNo

                        INSERT INTO [dbo].[tblRadiationLocationRRM]
								   ([RadiationLocationID]
								   ,[RadiationLicenceRRMID]
								   ,[VariationPendingFlag]
								   ,[Notes]
								   ,[InterstateOverseasRelocationFlag]
								   ,[EffectiveDateFrom]
								   ,[DateCreated]
								   ,[CreatedBySystemUserID])
						SELECT 
							(select Final_RadiationLocationID from @TempRadiationLocation where RadiationLocationID = a.RadiationLocationID) as RadiationLocationID,
							(select NewRadiationLicenceRRMID from @TempRadiationLicenceRRM0 where RadiationLicenceRRMID = a.RadiationLicenceRRMID) as RadiationLicenceRRMID,
							0 as VariationPendingFlag,
							null as Notes,
							0 as InterstateOverseasRelocationFlag,
							GETDATE(),
							GETDATE(),
							1 as CreatedBySystemUserID							
						FROM @TempRadiationLocationRRM0 a
						WHERE a.SNo = @RowID2 and a.NewRadiationLocationRRMID IS NULL

						SET @RadiationLocationRRMID= @@IDENTITY

						UPDATE @TempRadiationLocationRRM0								
						SET NewRadiationLocationRRMID = @RadiationLocationRRMID
						WHERE SNo = @RowID2 and NewRadiationLocationRRMID IS NULL
			 
			            select @RowID2 = @RowID2 + 1
					END
					--------START RadiationLocation RRM ---------------------------------------------------------------------------

					--------START RRMComponent --------------------------------------------------------------------------
					DECLARE @RowID3 int = 0					 
					DECLARE @RRMComponentID AS INT		
												
					WHILE (SELECT COUNT(*) FROM @TempRRMComponent0 WHERE RecordMode = 'A' AND NewRRMComponentID IS NULL) > 0
					BEGIN
						Select Top 1 @RowID3 = RRMComponentID FROM @TempRRMComponent0 WHERE RecordMode = 'A' AND NewRRMComponentID IS NULL order by RRMComponentID

						INSERT INTO [dbo].[tblRRMComponent]
							([ComponentStatusID]
							,[RRMComponentTypeID]
							,[AssayDate]
							,[ManufacturerID]
							,[ModelNumber]
							,[SerialNumber]
							,[RadionuclideID]
							,[NominalActivity]
							,[WorkingLife]
							,[ExtendedWorkingLifeFlag]
							,[DateCreated]
							,[CreatedBySystemUserID])
						SELECT 
							ComponentStatusID,
							RRMComponentTypeID,
							AssayDate,
							case ManufacturerID when 0 then 1 else ManufacturerID end as ManufacturerID,  ----NEED TO FIX THIS 0 VALUE
							ModelNumber,
							SerialNumber,
							2 as RadionuclideID,
							NominalActivity,
							WorkingLife,
							ExtendedWorkingLifeFlag,
							GETDATE(),
							CreatedBySystemUserID									
						FROM @TempRRMComponent0
						WHERE RRMComponentID = @RowID3

						SET @RRMComponentID = @@IDENTITY
									 
						UPDATE @TempRRMComponent0
						SET NewRRMComponentID = @RRMComponentID
						WHERE RRMComponentID = @RowID3 and NewRRMComponentID is null
 
					END
                    --------END RRMComponent-----------------------------------------------------------------------------


					--------START RadiationLicenceRRMComponent --------------------------------------------------------------------------
					INSERT INTO [dbo].[tblRadiationLicenceRRMComponent]
						([RadiationLicenceRRMID]
						,[RRMComponentID]
						,[VariationPendingFlag]
						,[Notes]
						,[InterstateOverseasRelocationFlag]
						,[EffectiveDateFrom]
						,[DateCreated]
						,[CreatedBySystemUserID])
					SELECT 
						(select NewRadiationLicenceRRMID from @TempRadiationLicenceRRM0 where RadiationLicenceRRMID = RRM.RadiationLicenceRRMID) as RadiationLicenceRRMID,
						RRM.NewRRMComponentID,
						0 as VariationPendingFlag,
						null as Notes,
						0 as InterstateOverseasRelocationFlag,
						GETDATE(),
						GETDATE(),
						1 as CreatedBySystemUserID							
					FROM @TempRRMComponent0 RRM 
					WHERE RRM.RecordMode = 'A' AND RRM.NewRRMComponentID > 0	
					--------END RadiationLicenceRRMComponent --------------------------------------------------------------------------

					--verify and clean address data 
					if exists(select * from @tblAddress where Final_AddressID is null)
					  print 'XML address data is missing. Not all records to be saved'
					--select * from  @tblAddress
					delete from @tblAddress

					--verify and clean DataRadiationLocation data 
					if exists(select * from @TempRadiationLocation where Final_RadiationLocationID is null)
					    print 'XML RadiationLocation data is missing. Not all records to be saved'
					--select * from @TempRadiationLocation
					delete from @TempRadiationLocation

					--verify and clean DataRadiationLocation data 
					if exists(select * from @tblRadiationDepartment0 where Final_RadiationDepartmentID is null)
					    print 'XML RadiationLocation data is missing. Not all records to be saved'
					--select * from @tblRadiationDepartment0
					delete from @tblRadiationDepartment0

					--verify and clean RadiationLicenceRRM data : @TempRadiationLicenceRRM0
					if exists(select * from @TempRadiationLicenceRRM0 where NewRadiationLicenceRRMID is null)
					    print 'XML RadiationLicenceRRM data is missing. Not all records to be saved'
					--select * from @TempRadiationLicenceRRM0
					delete from @TempRadiationLicenceRRM0

					--verify and clean RadiationLocationRRM data : @TempRadiationLocationRRM0
					if exists(select * from @TempRadiationLocationRRM0 where NewRadiationLocationRRMID is null)
					    print 'XML RadiationLocationRRM data is missing. Not all records to be saved'
					  --select * from @TempRadiationLocationRRM0
					delete from @TempRadiationLocationRRM0

					--verify and clean RRMComponent0 data : @TempRRMComponent0
					if exists(select * from @TempRRMComponent0 where NewRRMComponentID is null)
					    print 'XML RRMComponent0 data is missing. Not all records to be saved'
					  --select * from @TempRRMComponent0
					delete from @TempRRMComponent0

					--verify and clean RadiationLicenceRRMComponent data : @TempRadiationLicenceRRMComponent0
					if exists(select * from @TempRadiationLicenceRRMComponent0 where NewRadiationLicenceRRMID is null)
					    print 'XML RadiationLicenceRRMComponent data is missing. Not all records to be saved'
					--select * from @TempRadiationLicenceRRMComponent0
					delete from @TempRadiationLicenceRRMComponent0
					
			--Finally we create links on tblInstrumentRadiationLocation
			if (select count(*) from @tblRadiationLocation) > 0 
			begin
			    --print 'uspRadiationLinkLocations will be called please uncomment the bottom script lines'
				declare @RtnVal int 
				SELECT @RtnVal =0					 
				update @tblRadiationLocation set InstrumentRadiationLocationID = -1*SNo  --we make sure the InstrumentRadiationLocationID is negative unique numbers	
							 
				Exec @RtnVal = uspRadiationLinkLocations @tblRadiationLocation, @theInstrumentID
				IF @RtnVal <> 0 RAISERROR ('Problem saving uspLinkRadiationLocations' , 16, 1) 
			end
			else
			    print 'table @tblRadiationLocation has no data at all'
		end
	END TRY
	BEGIN CATCH
		DECLARE @ErrorMessage VARCHAR(2000)		 
		SET @ErrorMessage = dbo.ufn_GetErrorText()		
		RAISERROR (@ErrorMessage , 16, 1)	
	END CATCH