declare @StableNullCount int
declare @StableCount int 
declare @TotalCount int

declare @StableRate as varchar(10)
declare @NotStableRate as varchar(10)
declare @StableNullRate as varchar(10)

 
declare @DGLicenceTypeID int = 1401
declare @InstrumentID int = 5068607
--==============================================================================================================================
SELECT @StableNullCount = count(*)  
				  FROM [dbo].[tblTransporterLicence] a 
				  left outer join tblDGLicenceVehicle b on a.[InstrumentID] = b.[InstrumentID]
				  left outer join tblDGVehicle c on b.DGVehicleID = c.DGVehicleID
				  WHERE [LicenceTypeID] = @DGLicenceTypeID and a.InstrumentID = @InstrumentID and b.EffectiveDateTo IS NULL
				  and
				  c.IsVehicleManufacturedAfter01July2014Flag = 0
				  and 
				  c.StabilityControlFlag is null

				  SELECT @StableCount = count(*)  
				  FROM [dbo].[tblTransporterLicence] a 
				  left outer join tblDGLicenceVehicle b on a.[InstrumentID] = b.[InstrumentID]
				  left outer join tblDGVehicle c on b.DGVehicleID = c.DGVehicleID
				  WHERE [LicenceTypeID] = @DGLicenceTypeID and a.InstrumentID = @InstrumentID and b.EffectiveDateTo IS NULL
				  and
				  c.IsVehicleManufacturedAfter01July2014Flag = 0
				  and 
				  c.StabilityControlFlag = 1

				  SELECT @TotalCount = count(*)  
				  FROM [dbo].[tblTransporterLicence] a 
				  left outer join tblDGLicenceVehicle b on a.[InstrumentID] = b.[InstrumentID]
				  left outer join tblDGVehicle c on b.DGVehicleID = c.DGVehicleID
				  WHERE [LicenceTypeID] = @DGLicenceTypeID and a.InstrumentID = @InstrumentID and b.EffectiveDateTo IS NULL
				  and
				  c.IsVehicleManufacturedAfter01July2014Flag = 0

print '@TotalCount = ' + cast(@TotalCount as varchar)
   
				  if @TotalCount > 0 and @StableCount >= 0
				  begin
					select  @StableRate = cast(round(cast(@StableCount as float) / cast(@TotalCount as float), 2)*100 as varchar) + '%' 
				  end 

				  if @TotalCount > 0 and @StableNullCount >= 0
				  begin
					select  @StableNullRate = cast(round(cast(@StableNullCount as float) / cast(@TotalCount as float), 2)*100 as varchar) + '%'  
				  end 
				  
				  if @TotalCount > 0
				  begin
				      if @StableCount > 0 and @StableNullCount <= 0
				        select @NotStableRate = cast(100-(round(cast(@StableCount as float) / cast(@TotalCount as float), 2)*100) as varchar) + '%'  					  
					  else
					    select @NotStableRate = cast(100-(round(cast(@StableCount as float) / cast(@TotalCount as float), 2)*100 + round(cast(@StableNullCount as float) / cast(@TotalCount as float), 2)*100) as varchar) + '%' 
				  end
				  ----------------------------------------------------------------
                 SELECT DGLicence.[InstrumentID]
				      ,[LicenceTypeID] as [DGLicenceTypeID]
					  ,[DateApplicationReceived]
					  ,[DateApplicationCompleted]
					  ,[AdminFee]
					  ,LicenceDurationID as [DriverLicenceDurationID]
					  ,[ExpiryDate]
					  ,[ReviewDueDate]
					  ,[ConsentForECFlag]
					  ,[Notes]
					  ,[RenewalNoticeSentDate]    
					  ,DGLicence.DateCreated    
					  ,DGLicence.CreatedBySystemUserID
					  ,DGLicence.DateUpdated					
					  ,DGLicence.OldLicenceNumber
					  ,d.[Description] as DGLicenceType
					  ,c.[Description] as DGLicenceStatus
				      ,(CASE WHEN AP.CompanyFlag = 1 THEN AP.OrganisationName ELSE AP.GivenName + ' ' + AP.Surname END) AccountableParty	
					  ,AP.DateOfBirth 	
					  ,@StableRate as StableRate
					  ,@NotStableRate as NotStableRate
					  ,@StableNullRate as StableNullRate			  
					FROM [dbo].[tblTransporterLicence] DGLicence
					inner join tblInstrument b on DGLicence.[InstrumentID] = b.[InstrumentID]
					inner join tblClassification c on b.InstrumentStatusID = c.ClassificationID 
					inner join tblClassification d on DGLicence.[LicenceTypeID] = d.ClassificationID
					left outer join tblInstrumentAccountableParty IAP
						ON IAP.InstrumentAccountablePartyID = (Select MIN(IAP1.InstrumentAccountablePartyID) from tblInstrumentAccountableParty IAP1
												Where IAP1.InstrumentID = b.InstrumentID)
					left outer join tblAccountableParty AP
						ON IAP.AccountablePartyID = AP.AccountablePartyID					 
					WHERE DGLicence.[InstrumentID] = @InstrumentID and DGLicence.[LicenceTypeID] = @DGLicenceTypeID


--select a.* from tblTransporterLicence a inner join tblInstrument b on a.InstrumentID = b.InstrumentID 
--where LicenceTypeID = 1401 and b.InstrumentStatusID = 755 and a.InstrumentID in (select InstrumentID from tblDGLicenceVehicle)

--select * from tblDGLicenceVehicle
--where InstrumentID = 5068607

--select *, IsVehicleManufacturedAfter01July2014Flag from tblDGVehicle where DGVehicleID = 16296
--update tblDGVehicle set IsVehicleManufacturedAfter01July2014Flag = 0 where DGVehicleID = 16296