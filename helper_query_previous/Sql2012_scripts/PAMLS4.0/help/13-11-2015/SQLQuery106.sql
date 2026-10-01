	DECLARE	 @theXmlData xml
	select @theXmlData = LicenceXML from tblOnlinePOEOApplication where OnlinePOEOApplicationID = 53

						select 
									LandTitleID
									,LocationID
									,IdentifiedByLotDPFlag
									,SpatialInfoAvailable
									,LotNumber
									,DPNumber
									,SectionNumber
									,Easting
									,Northing
									,ZoneNumber
									,CreatedBySystemUserID
									,PartLotFlag
									,LGA
									,LBLCatchment
									,Electorate  
									,PointLongitude
									,PointLatitude
						 from (				
								SELECT 
									ROW_NUMBER() OVER (ORDER BY RN.S.value('Lot[1]','varchar(20)')) AS rn, 	
									-1 AS LandTitleID,
									-1 AS LocationID,
									0 AS IdentifiedByLotDPFlag,
 									1 AS SpatialInfoAvailable,
									RN.S.value('Lot[1]', 'varchar(20)') AS LotNumber,
									RN.S.value('DP[1]', 'bigint') AS DPNumber,
									RN.S.value('SectionNumber[1]', 'varchar(20)') AS SectionNumber,
									RN.S.value('Easting[1]', 'int') AS Easting,
									RN.S.value('Northing [1]','int') AS Northing,
									RN.S.value('Zone[1]', 'int') AS ZoneNumber,
									1 AS CreatedBySystemUserID,
									0 as PartLotFlag,
									RN.S.value('LGA[1]', 'varchar(200)') AS LGA,
									RN.S.value('LBLCatchment[1]', 'varchar(200)') AS LBLCatchment,
									RN.S.value('Electorate[1]', 'varchar(200)') AS Electorate,					 
									RN.S.value('Longitude[1]', 'decimal(18, 8)') AS PointLongitude,
									RN.S.value('Latitude [1]','decimal(18, 8)') AS PointLatitude
								FROM @theXmlData.nodes('/POEOLicence/AppplicationPoint/NoisePoints/POEOLicenceNoisePoint/NoiseLocation/LotDPs/LocationSpatialLotDP') AS RN(S)
						) T1
						WHERE rn = 2	




			SELECT 
			    SpatialInfoAvailable,
			    IsLotDP
			FROM
			(  
            select  
			RN.S.value('SpatialInfoAvailable[1]','BIT') as SpatialInfoAvailable,
			RN.S.value('IsLotDP[1]','BIT') as IsLotDP,
	        ROW_NUMBER() OVER (ORDER BY RN.S.value('SpatialInfoAvailable[1]','BIT')) AS rn
			FROM @theXmlData.nodes('/POEOLicence/AppplicationPoint/NoisePoints/POEOLicenceNoisePoint/NoiseLocation') AS RN(S) 
			) T1
			WHERE rn = 2


	DECLARE @MyTable TABLE
		(
		SNo int IDENTITY(1,1), 	 
		ROW_ID int
		)    
	INSERT INTO @MyTable(ROW_ID)	    
	SELECT ROW_NUMBER() OVER (ORDER BY RN.S.value('Address[1]','varchar(100)'))
	FROM @theXmlData.nodes('/POEOLicence/AppplicationPoint/NoisePoints/POEOLicenceNoisePoint/NoiseLocation/Address') AS RN(S)

	select * from @MyTable


	declare @WorkDescription varchar(1000)
	SELECT @WorkDescription= COALESCE(@WorkDescription + ', ', '')  + COALESCE(RN.S.value('Description[1]','varchar(1000)'), '') 
	FROM @theXmlData.nodes('/POEOLicence/ScheduleWork/Stages/WorkStageDetails') AS RN(S)

	print '@WorkDescription=' + @WorkDescription

	SELECT      20731 as InstrumentID,
				RN.S.value('WorkDesc[1]','varchar(100)') AS WorkDescription,
				substring(RN.S.value('StartDate[1]','varchar(50)'), 0, 11) AS DateWorkCommence,
				substring(RN.S.value('CompleteDate[1]','varchar(50)'), 0, 11) AS DateWorkComplete,
				RN.S.value('IsWorkInStages[1]','BIT') AS ConductedInStageFlag,
				RN.S.value('StageCount[1]','varchar(100)')AS TotalStages,
				RN.S.value('AppRelatedStage[1]','varchar(100)')AS DescriptionOfStage,
				RN.S.value('StartDate[1]','DateTime')AS DateCreated,
				1 AS CreatedBySystemUserID 			 
	FROM @theXmlData.nodes('/POEOLicence/ScheduleWork') AS RN(S)


	SELECT   -1 AS AddressID,
				RN.S.value('Address[1]','varchar(100)') AS Address,
				RN.S.value('Suburb[1]','varchar(100)') AS Suburb,
				RN.S.value('Postcode[1]','char(10)') AS Postcode,
				RN.S.value('State[1]','char(20)') AS StateCode,
				1 AS CreatedBySystemUserID,
				0 AS OverseasAddressFlag,
				ROW_NUMBER() OVER (ORDER BY RN.S.value('Address[1]','varchar(100)')) AS RowNo 
	FROM @theXmlData.nodes('/POEOLicence/AppplicationPoint/NoisePoints/POEOLicenceNoisePoint/NoiseLocation/Address') AS RN(S)
 
	SELECT * FROM
	(
		SELECT ROW_NUMBER() OVER (ORDER BY RN.S.value('Address[1]','varchar(100)')) AS rn, 
				   -1 AS AddressID,
					RN.S.value('Address[1]','varchar(100)') AS Address,
					RN.S.value('Suburb[1]','varchar(100)') AS Suburb,
					RN.S.value('Postcode[1]','char(10)') AS Postcode,
					RN.S.value('State[1]','char(20)') AS StateCode,
					1 AS CreatedBySystemUserID,
					0 AS OverseasAddressFlag 
		FROM @theXmlData.nodes('/POEOLicence/AppplicationPoint/NoisePoints/POEOLicenceNoisePoint/NoiseLocation/Address') AS RN(S)
	) T1
	WHERE rn = 1

-----------------
--start looping
DECLARE @MyTable TABLE
	(
	SNo int IDENTITY(1,1), 	 
	ROW_ID int
	)    
INSERT INTO @MyTable(ROW_ID)	    
SELECT ROW_NUMBER() OVER (ORDER BY RN.S.value('Address[1]','varchar(100)'))
FROM @theXmlData.nodes('/POEOLicence/AppplicationPoint/NoisePoints/POEOLicenceNoisePoint/NoiseLocation/Address') AS RN(S)
 
declare @Cnt int
SELECT @Cnt = MIN(Sno) FROM @MyTable
	 
declare @TempROW_ID int

WHILE (1=1)
BEGIN
   
SELECT @TempROW_ID = ROW_ID FROM @MyTable
WHERE SNo = @Cnt
	    
IF @@ROWCOUNT = 0
	BREAK
	if @TempROW_ID > 0
	begin	      
			SELECT AddressID,  
			       Address,
				   Suburb,
				   Postcode,
				   StateCode,
				   CreatedBySystemUserID,
				   OverseasAddressFlag
			FROM
			(
				SELECT ROW_NUMBER() OVER (ORDER BY RN.S.value('Address[1]','varchar(100)')) AS rn, 
						   -1 AS AddressID,
							RN.S.value('Address[1]','varchar(100)') AS Address,
							RN.S.value('Suburb[1]','varchar(100)') AS Suburb,
							RN.S.value('Postcode[1]','char(10)') AS Postcode,
							RN.S.value('State[1]','char(20)') AS StateCode,
							1 AS CreatedBySystemUserID,
							0 AS OverseasAddressFlag 
				FROM @theXmlData.nodes('/POEOLicence/AppplicationPoint/NoisePoints/POEOLicenceNoisePoint/NoiseLocation/Address') AS RN(S)
			) T1
			WHERE rn = @TempROW_ID		 

		    SELECT 
                        LandTitleID
						,LocationID
						,IdentifiedByLotDPFlag
						,PartLotFlag
						,LotNumber
						,DPNumber
						,SectionNumber
						,Easting
						,Northing
						,ZoneNumber
						,CreatedBySystemUserID
						,PartLotFlag
						,LGA
						,LBLCatchment
						,Electorate  
			 FROM 
			 (
			         SELECT  
						ROW_NUMBER() OVER (ORDER BY RN.S.value('Lot[1]','varchar(20)')) AS rn, 				
						-1 AS LandTitleID,
						-1 AS LocationID,
						0 AS IdentifiedByLotDPFlag,
 						0 AS PartLotFlag,
						RN.S.value('Lot[1]', 'varchar(20)') AS LotNumber,
						RN.S.value('DP[1]', 'bigint') AS DPNumber,
						RN.S.value('SectionNumber[1]', 'varchar(20)') AS SectionNumber,
						RN.S.value('Easting[1]', 'int') AS Easting,
						RN.S.value('Northing [1]','int') AS Northing,
						RN.S.value('ZoneNumber[1]', 'int') AS ZoneNumber,
						1 AS CreatedBySystemUserID,
						0 as PartLotFlag2,
						RN.S.value('LGA[1]', 'varchar(200)') AS LGA,
						RN.S.value('LBLCatchment[1]', 'varchar(200)') AS LBLCatchment,
						RN.S.value('Electorate[1]', 'varchar(200)') AS Electorate
					FROM @theXmlData.nodes('/POEOLicence/AppplicationPoint/NoisePoints/POEOLicenceNoisePoint/NoiseLocation/LotDPs/LocationSpatialLotDP') AS RN(S)
			) as T1
			WHERE rn = @TempROW_ID	

		 
	end 
SELECT @Cnt = @Cnt + 1		
END
--end looping
-----------------


	  --      declare @AdditionalAddressInformationPortal varchar(500)
			--SELECT @AdditionalAddressInformationPortal = AdditionalInfo
			--FROM
			--(  
   --         select  RN.S.value('AdditionalInfo[1]','varchar(1000)') as AdditionalInfo,
	  --      ROW_NUMBER() OVER (ORDER BY RN.S.value('AdditionalInfo[1]','varchar(1000)')) AS rn
			--FROM @theXmlData.nodes('/POEOLicence/AppplicationPoint/NoisePoints/POEOLicenceNoisePoint/NoiseLocation/Address') AS RN(S) 
			--) T1
			--WHERE rn = 2	

   -- select @AdditionalAddressInformationPortal as AdditionalAddressInformation

	--SELECT  -1 AS LocationID,
	--		--RN.S.value('Name[1]','varchar(128)') AS LocationName, 
	--		RN.S.value('Description[1]','varchar(128)') AS LocationName,
	--	   -88 AS AddressID,
	--		0 AS PremisesFlag,
	--	    @AdditionalAddressInformationPortal AS AdditionalAddressInformation,		 
	--		1 AS CreatedBySystemUserID,
	--	   -1 AS InstrumentID			 
 --   FROM @theXmlData.nodes('/POEOLicence/AppplicationPoint/NoisePoints/POEOLicenceNoisePoint/NoiseLocation') AS RN(S)