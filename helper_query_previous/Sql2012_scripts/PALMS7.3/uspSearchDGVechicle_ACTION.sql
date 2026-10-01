		declare @theXMLData xml  = 
		'
<NewDataSet>
  <DGVehicleSearch>
    <DGVehicleID>23</DGVehicleID>
    <VehicleTypeID>0</VehicleTypeID>
    <RegistrationNumber />
    <VINNumber />
    <RegistrationState />
  </DGVehicleSearch>
</NewDataSet>	
		'
		declare @MaxAllowed INT = 500
		declare @MaxExport INT = 5000
		declare @DataUsage INT =0 
		declare @OverLimit bit =0 
		declare @pageSize int = 50
		declare @pageNum int = 1

    declare @dgVehicleID int=0
	declare @vehicleTypeID int=0
	declare @regoNo varchar(10)=null
	declare @registrationState varchar(3)=null
	declare @vinNumber varchar(20)=null

	 DECLARE @my_count as int		

 
		SELECT
			 @dgVehicleID = RN.S.value('DGVehicleID[1]','int'),
			 @vehicleTypeID = RN.S.value('VehicleTypeID[1]','int'),
			 @regoNo = RN.S.value('RegistrationNumber[1]','varchar(10)') ,
			 @vinNumber= RN.S.value('VINNumber[1]','varchar(20)'),
			 @registrationState = RN.S.value('RegistrationState[1]','varchar(20)') 
        FROM @theXmlData.nodes('/NewDataSet/DGVehicleSearch') AS RN(S)

   	--select  @dgVehicleID , @vehicleTypeID, @regoNo,@registrationState ,@vinNumber
		Select  @my_count = Count(*)
				from tblDGVehicle
				where	(@dgVehicleID=0 or DGVehicleID=@dgVehicleID)
					and (@vehicleTypeID=0 or VehicleTypeID=@vehicleTypeID)
					and (@regoNo ='' or RegistrationNumber=@regoNo)
					and (@registrationState ='' or RegistrationState=@registrationState)
					and (@vinNumber ='' or VINNumber=@vinNumber)
					and ProhibitedVehiclesFlag=0

		declare @tblSearchResult table
		(
			RowID INT IDENTITY,
			[DGVehicleID] [int] NOT NULL,
			[VehicleTypeID] [smallint] NOT NULL,
			[RegistrationNumber] [varchar](10) NOT NULL,
			[VINNumber] [varchar](20) NOT NULL,
			[RegistrationState] [varchar](3) NOT NULL,
			[FleetNumber] varchar(150) null,
			[Capacity] int null,
			RowCountTotal int null
		)

		--if search goes here we count the number of return rows greater than @NoOfRecordsRequired we need stop search
		if @my_count <= @MaxAllowed OR @DataUsage =1
			begin
				INSERT INTO @tblSearchResult
					(
						[DGVehicleID],
						[VehicleTypeID],
						[RegistrationNumber],
						[VINNumber],
						[RegistrationState],
						[FleetNumber],
						[Capacity]
				   )
				   Select  [DGVehicleID],
							[VehicleTypeID],
							[RegistrationNumber],
							[VINNumber],
							[RegistrationState],
							[FleetNumber],
							[Capacity]
						from tblDGVehicle
						where	(@dgVehicleID=0 or DGVehicleID=@dgVehicleID)
							and (@vehicleTypeID=0 or VehicleTypeID=@vehicleTypeID)
							and (@regoNo ='' or RegistrationNumber=@regoNo)
							and (@registrationState ='' or RegistrationState=@registrationState)
							and (@vinNumber ='' or VINNumber=@vinNumber)
							and ProhibitedVehiclesFlag=0

				DECLARE @ActualCount INT
				SELECT @ActualCount = COUNT(DGVehicleID) from @tblSearchResult			
				UPDATE @tblSearchResult SET RowCountTotal = @ActualCount	
		
			end

		IF(@DataUsage = 1)
			BEGIN
				Select TOP(@MaxExport) * from @tblSearchResult order by DGVehicleID
				SET @OverLimit = 0	
			END
		Else	
			if(@my_count <@MaxAllowed)				
			BEGIN	
			
				SELECT TOP (@pageSize) 
									[DGVehicleID],
									[VehicleTypeID],
									[RegistrationNumber],
									[VINNumber],
									[RegistrationState],
									[dbo].[ufn_GetIntrumentIDByDGVehicleID](DGVehicleID) as [InstrumentID],
									c.Name as VehicleTypeName,
									FleetNumber,
									[dbo].[ufn_GetVehicleClassByDGVehicleID](DGVehicleID) as [LicenceClass],
									[Capacity],
									RowCountTotal
								FROM @tblSearchResult r 
										inner join tblClassification c on r.VehicleTypeID=c.ClassificationID
								WHERE RowID NOT IN  
								( SELECT TOP ((@pageNum - 1) * (@pageSize)) RowID FROM @tblSearchResult order by RowID )	
								order by RowID	
		
				    
				SET @OverLimit = 0	
			END
			ELSE
			BEGIN			    
				SET @OverLimit = 1  
			END
