--Purpose: we need update all those migrated data under Dangersous Goods Vehicle licence
--we need update all those missing information which required by PAMLS system by filling in some default values

--1. We get the unknown tank type ID which we create through script below
DECLARE @NewID INT 

if not exists(select ClassificationID from tblClassification where ClassificationDomainID= 107 and Code='DGTT7' and Name='Unknown' and Description='Unknown')
begin
	SELECT @NewID = MAX(ClassificationID) FROM tblClassification 

	SELECT @NewID = @NewID +1 

	INSERT INTO tblClassification 
	(ClassificationID , ClassificationDomainID, Code,Name, Description, SequenceOrder, EffectiveDateFrom, DateCreated,CreatedBySystemUserID)

	SELECT @NewID,107,'DGTT7', 'Unknown ','Unknown ',20,'01/01/2014',GETDATE(),1 
end
else
   SELECT @NewID = ClassificationID FROM tblClassification WHERE ClassificationDomainID= 107 and Code='Unknown' and Name='Unknown' 
 
GO 

--create Unknow DGVehcile Class ID
DECLARE @NewClassVehcileClassID INT 

if not exists(select ClassificationID from tblClassification where ClassificationDomainID= 108 and Code='DGLCX' and Name='Unknown' and Description='Unknown')
begin
	SELECT @NewClassVehcileClassID = MAX(ClassificationID) FROM tblClassification 

	SELECT @NewClassVehcileClassID = @NewClassVehcileClassID +1 

	INSERT INTO tblClassification 
	(ClassificationID , ClassificationDomainID, Code,Name, Description, SequenceOrder, EffectiveDateFrom, DateCreated,CreatedBySystemUserID)

	SELECT @NewClassVehcileClassID, 108, 'DGLCX', 'Unknown ','Unknown ',20,'01/01/2014',GETDATE(),1 
end
else
    SELECT @NewClassVehcileClassID = ClassificationID FROM tblClassification WHERE ClassificationDomainID= 108 and Code='DGLCX' and Name='Unknown' and Description='Unknown'
GO

--2. we find all those Dangerous Goods Vehicle licence Issued with ROW_ID not null
			DECLARE @VehicleID int
			SET @VehicleID = 0		

			DECLARE @inInstrumentID int
			SET @inInstrumentID = 0	

			DECLARE @Temp VARCHAR(MAX)

			declare @VehicleTable table
			(
			SNo int IDENTITY(1,1), 
			DGVehicleID int,
			VehicleTypeID int,
			InstrumentID int
			)
			insert into @VehicleTable(DGVehicleID, VehicleTypeID, InstrumentID) 
			select A.DGVehicleID, A.VehicleTypeID, isnull(B.InstrumentID, 0) from tblDGVehicle A 
			left outer join tblDGLicenceVehicle B on A.DGVehicleID = B.DGVehicleID
			where A.ROW_ID IS NOT NULL 

--select * from @VehicleTable

			declare @DGVehicleIDTemp int
			declare @VehicleTypeIDTemp int
			declare @Cnt int
			select @Cnt = MIN(Sno) FROM @VehicleTable

			while (1=1)
			begin
                set @VehicleTypeIDTemp = 0

				select @DGVehicleIDTemp = DGVehicleID, @VehicleTypeIDTemp = VehicleTypeID, @inInstrumentID = InstrumentID from @VehicleTable
				where SNo = @Cnt
	    
				if @@rowcount = 0
				break

				set @VehicleID = 0 --reset its value to be zero before the detail loop
				-- main checking starts based on surrent Vehicle ID
				--here we check all vehicle data: tblDGVehicle
				--here start looping through
				set @Temp = ''

				 if exists(select A.[DGVehicleID]      
						  FROM tblDGLicenceVehicle A LEFT OUTER JOIN tblDGVehicle B ON A.DGVehicleID = B.DGVehicleID 
						  LEFT OUTER JOIN tblClassification C ON B.VehicleTypeID = C.ClassificationID
						  WHERE (A.EffectiveDateTo is null or A.EffectiveDateTo > GETDATE()) and A.InstrumentID = @inInstrumentID and isnull(B.RegistrationNumber, '')='' and A.DGVehicleID = @DGVehicleIDTemp)			
						  SET @Temp = @Temp + cast(@inInstrumentID as varchar) + ' ' + 'Vehicle ' + cast(@DGVehicleIDTemp as varchar) + ' - registration number is a required field' 

				if exists(select A.[DGVehicleID]      
						  FROM tblDGLicenceVehicle A LEFT OUTER JOIN tblDGVehicle B ON A.DGVehicleID = B.DGVehicleID 
						  LEFT OUTER JOIN tblClassification C ON B.VehicleTypeID = C.ClassificationID
						  WHERE (A.EffectiveDateTo is null or A.EffectiveDateTo > GETDATE()) and A.InstrumentID = @inInstrumentID and isnull(C.Description, '')='' and A.DGVehicleID = @DGVehicleIDTemp)		 
						  SET @Temp = @Temp + '<br>' + 'Vehicle ' + cast(@DGVehicleIDTemp as varchar) + ' - type is a required field' 
						  				
				if exists(select A.[DGVehicleID]      
						  FROM tblDGLicenceVehicle A LEFT OUTER JOIN tblDGVehicle B ON A.DGVehicleID = B.DGVehicleID 
						  LEFT OUTER JOIN tblClassification C ON B.VehicleTypeID = C.ClassificationID
						  WHERE (A.EffectiveDateTo is null or A.EffectiveDateTo > GETDATE()) and A.InstrumentID = @inInstrumentID and isnull(B.RegistrationState, '')='' and A.DGVehicleID = @DGVehicleIDTemp)		 
						  SET @Temp = @Temp + '<br>' + 'Vehicle ' + cast(@DGVehicleIDTemp as varchar) + ' - registration state is a required field'
 			
				if exists(select A.[DGVehicleID]       
						  FROM tblDGLicenceVehicle A LEFT OUTER JOIN tblDGVehicle B ON A.DGVehicleID = B.DGVehicleID 
						  LEFT OUTER JOIN tblClassification C ON B.VehicleTypeID = C.ClassificationID
						  WHERE (A.EffectiveDateTo is null or A.EffectiveDateTo > GETDATE()) and A.InstrumentID = @inInstrumentID and B.TransportWasteFlag is null and A.DGVehicleID = @DGVehicleIDTemp)			 
						  SET @Temp = @Temp + '<br>' + 'Vehicle ' + cast(@DGVehicleIDTemp as varchar) + ' - transport waste flag is a required field'
			
				if exists(select A.[DGVehicleID]  
						  FROM tblDGLicenceVehicle A LEFT OUTER JOIN tblDGVehicle B ON A.DGVehicleID = B.DGVehicleID 
						  LEFT OUTER JOIN tblClassification C ON B.VehicleTypeID = C.ClassificationID
						  WHERE (A.EffectiveDateTo is null or A.EffectiveDateTo > GETDATE()) and A.InstrumentID = @inInstrumentID and B.VacuumTankerFlag is null and A.DGVehicleID = @DGVehicleIDTemp)		
						  SET @Temp = @Temp + '<br>' + 'Vehicle ' + cast(@DGVehicleIDTemp as varchar) + ' - vacuum tanker flag is a required field'
			
				if exists(select A.[DGVehicleID]         
						  FROM tblDGLicenceVehicle A LEFT OUTER JOIN tblDGVehicle B ON A.DGVehicleID = B.DGVehicleID 
						  LEFT OUTER JOIN tblClassification C ON B.VehicleTypeID = C.ClassificationID
						  WHERE (A.EffectiveDateTo is null or A.EffectiveDateTo > GETDATE()) and A.InstrumentID = @inInstrumentID and B.CoveredInsuranceFlag is null and A.DGVehicleID = @DGVehicleIDTemp)							   
						  SET @Temp = @Temp + '<br>' + 'Vehicle ' + cast(@DGVehicleIDTemp as varchar) + ' - covered insurance flag is a required field'
			
				if exists(select A.[DGVehicleID]       
						  FROM tblDGLicenceVehicle A LEFT OUTER JOIN tblDGVehicle B ON A.DGVehicleID = B.DGVehicleID 
						  LEFT OUTER JOIN tblClassification C ON B.VehicleTypeID = C.ClassificationID
						  WHERE (A.EffectiveDateTo is null or A.EffectiveDateTo > GETDATE()) and A.InstrumentID = @inInstrumentID and  B.PhotograghAttachedFlag is null and A.DGVehicleID = @DGVehicleIDTemp)				 
				begin		 
						  SET @Temp = @Temp + '<br>' + 'Vehicle ' + cast(@DGVehicleIDTemp as varchar) + ' - photogragh attached flag is a required field'
						  --update tblDGVehicle set PhotograghAttachedFlag = 1 where  DGVehicleID = @DGVehicleIDTemp
			    end

				if @VehicleTypeIDTemp = 862
				begin
						if exists(select A.[DGVehicleID]   
								  FROM tblDGLicenceVehicle A LEFT OUTER JOIN tblDGVehicle B ON A.DGVehicleID = B.DGVehicleID 
								  LEFT OUTER JOIN tblClassification C ON B.VehicleTypeID = C.ClassificationID
								  WHERE (A.EffectiveDateTo is null or A.EffectiveDateTo > GETDATE()) and A.InstrumentID = @inInstrumentID and B.VehicleTypeID = 862 and B.TankerTypeID is null and A.DGVehicleID = @DGVehicleIDTemp) 					 
					    begin  
						   SET @Temp = @Temp + '<br>' + 'Vehicle ' + cast(@DGVehicleIDTemp as varchar) + ' - tanker type is a required field'
						   --update tblDGVehicle set TankerTypeID = @NewID where  DGVehicleID = @DGVehicleIDTemp
			            end 

						if exists(select A.[DGVehicleID]       
								  FROM tblDGLicenceVehicle A LEFT OUTER JOIN tblDGVehicle B ON A.DGVehicleID = B.DGVehicleID 
								  LEFT OUTER JOIN tblClassification C ON B.VehicleTypeID = C.ClassificationID
								  WHERE (A.EffectiveDateTo is null or A.EffectiveDateTo > GETDATE()) and A.InstrumentID = @inInstrumentID and B.VehicleTypeID = 862 and B.Capacity is null and A.DGVehicleID = @DGVehicleIDTemp) 
					 	begin			
								  SET @Temp = @Temp + '<br>' + 'Vehicle ' + cast(@DGVehicleIDTemp as varchar) + ' - tanker capacity is a required field'
								  --update tblDGVehicle set Capacity = 0 where  DGVehicleID = @DGVehicleIDTemp
						end
			
						if exists(select B.[DGVehicleID]          
								  FROM tblDGLicenceVehicle A LEFT OUTER JOIN tblDGVehicle B ON A.DGVehicleID = B.DGVehicleID 
								  LEFT OUTER JOIN tblClassification C ON B.VehicleTypeID = C.ClassificationID
								  WHERE (A.EffectiveDateTo is null or A.EffectiveDateTo > GETDATE()) and A.InstrumentID = @inInstrumentID and B.VehicleTypeID = 862 and isnull(B.TankerTypeID, -1) <> -1 and (cast(isnull(B.TankMake, '') as varchar)='' or cast(isnull(B.TankYear, '') as varchar) ='' or cast(isnull(B.TankSerialNumber, '') as varchar) ='') and A.DGVehicleID = @DGVehicleIDTemp) 
					 
								  SET @Temp = @Temp + '<br>' + 'Vehicle ' + cast(@DGVehicleIDTemp as varchar) + ' - tanker maker and year and serial number are required fields'

						if exists(select A.[DGVehicleID]           
								  FROM tblDGLicenceVehicle A LEFT OUTER JOIN tblDGVehicle B ON A.DGVehicleID = B.DGVehicleID 
								  LEFT OUTER JOIN tblClassification C ON B.VehicleTypeID = C.ClassificationID
								  WHERE (A.EffectiveDateTo is null or A.EffectiveDateTo > GETDATE()) and A.InstrumentID = @inInstrumentID and B.VehicleTypeID = 862 and cast(isnull(B.DesignApprovalNo, '') as varchar) = '' and A.DGVehicleID = @DGVehicleIDTemp) 
						 begin
								  SET @Temp = @Temp + '<br>' + 'Vehicle ' + cast(@DGVehicleIDTemp as varchar) + ' - design approval number is a required field'
								  --update tblDGVehicle set DesignApprovalNo = 'unknown' where  DGVehicleID = @DGVehicleIDTemp	
			             end
			          
						if exists(select B.[DGVehicleID]         
								  FROM tblDGLicenceVehicle A LEFT OUTER JOIN tblDGVehicle B ON A.DGVehicleID = B.DGVehicleID 
								  LEFT OUTER JOIN tblClassification C ON B.VehicleTypeID = C.ClassificationID
								  WHERE (A.EffectiveDateTo is null or A.EffectiveDateTo > GETDATE()) and A.InstrumentID = @inInstrumentID and B.VehicleTypeID = 862 and cast(isnull(B.DateLastHydraulicTest, '') as varchar) = '' and A.DGVehicleID = @DGVehicleIDTemp) 
						 				 
								  SET @Temp = @Temp + '<br>' + 'Vehicle ' + cast(@DGVehicleIDTemp as varchar) + ' - last hydraulic test date is a required field'

						if exists(select A.[DGVehicleID]           
								  FROM tblDGLicenceVehicle A LEFT OUTER JOIN tblDGVehicle B ON A.DGVehicleID = B.DGVehicleID 
								  LEFT OUTER JOIN tblClassification C ON B.VehicleTypeID = C.ClassificationID
								  WHERE (A.EffectiveDateTo is null or A.EffectiveDateTo > GETDATE()) and A.InstrumentID = @inInstrumentID and B.VehicleTypeID = 862 and B.IsVehicleManufacturedAfter01July2014Flag is null and A.DGVehicleID = @DGVehicleIDTemp) 
						begin 			  
								  SET @Temp = @Temp + '<br>' + 'Vehicle ' + cast(@DGVehicleIDTemp as varchar) + ' - vehicle manufactured after 01 July 2014 flag is a required field'
								  --update tblDGVehicle set IsVehicleManufacturedAfter01July2014Flag = 0 where  DGVehicleID = @DGVehicleIDTemp								  
                        end

						if exists(select A.[DGVehicleID]        
								  FROM tblDGLicenceVehicle A INNER JOIN tblDGVehicle B ON A.DGVehicleID = B.DGVehicleID 
									WHERE A.InstrumentID = @inInstrumentID and B.VehicleTypeID = 862  AND NOT EXISTS (SELECT * FROM tblDGVehicleClass WHERE DGVehicleID = B.DGVehicleID) and A.DGVehicleID = @DGVehicleIDTemp) 
						begin 				  
								  SET @Temp = @Temp + '<br>' + 'Vehicle ' + cast(@DGVehicleIDTemp as varchar) + ' - at least one DG licence classs must be added to the vehicle'
								  --insert into tblDGVehicleClass (DGVehicleID, VehicleClassID, DateCreated, CreatedBySystemUserID) values (@DGVehicleIDTemp, @NewClassVehcileClassID, getdate(), 1)
						end 
						--end of vehicle type 862 with tanker checking																	
				end
				 
				select @Cnt = @Cnt + 1	

				if len(@Temp) > 0
				   print '@Temp =' + cast(@inInstrumentID as varchar) + ' : ' + @Temp
		   end 

		   