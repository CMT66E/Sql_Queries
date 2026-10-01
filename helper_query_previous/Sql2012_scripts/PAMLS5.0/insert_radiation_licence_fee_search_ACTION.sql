declare @RadiationLicenceFeeListID INT
declare @RadiationLicenceTypeID INT
declare @FeeDescription  VARCHAR(255)
declare @Amount decimal(12, 2)
declare @FeeType  VARCHAR(255)
declare @FinancialYear VARCHAR(25)
declare @IsActive   BIT

set @RadiationLicenceFeeListID = 0
set @RadiationLicenceTypeID = 0
set @FeeDescription = ''
set @Amount = 0
set @FeeType = ''
set @FinancialYear = ''
set @IsActive= 1

	    IF @RadiationLicenceFeeListID = 0 AND @RadiationLicenceTypeID = 0 AND @FeeDescription='' AND @IsActive = 0
	    BEGIN
					SELECT [RadiationLicenceFeeListID]
					  ,[RadiationLicenceTypeID]
					  ,AA.Description as RadiationLicenceType
					  ,[FeeDescription]
					  ,[Amount]
					  ,[FeeType]
					  ,A.[SequenceOrder]
					  ,A.[EffectiveDateFrom]
					  ,A.[EffectiveDateTo]
					  ,[FinancialYear] 
					  ,A.[DateCreated]
					  ,A.[CreatedBySystemUserID]
					  ,A.[DateUpdated]
					  ,A.[UpdatedBySystemUserID]
					  ,0 AS CanBeDeleted					       
					FROM [dbo].[tblRadiationLicenceFeeList] A INNER JOIN tblClassification AA ON A.RadiationLicenceTypeID = AA.ClassificationID
					WHERE A.EffectiveDateTo IS NOT NULL
                    ORDER BY A.SequenceOrder
					                
	                RETURN
	    END
	
        IF @RadiationLicenceFeeListID > 0 
				BEGIN			 			   
					SELECT [RadiationLicenceFeeListID]
					  ,[RadiationLicenceTypeID]
					  ,AA.Description as RadiationLicenceType
					  ,[FeeDescription]
					  ,[Amount]
					  ,[FeeType]
					  ,A.[SequenceOrder]
					  ,A.[EffectiveDateFrom]
					  ,A.[EffectiveDateTo]
					  ,[FinancialYear] 
					  ,A.[DateCreated]
					  ,A.[CreatedBySystemUserID]
					  ,A.[DateUpdated]
					  ,A.[UpdatedBySystemUserID]
					  ,0 AS CanBeDeleted					       
					FROM [dbo].[tblRadiationLicenceFeeList] A INNER JOIN tblClassification AA ON A.RadiationLicenceTypeID = AA.ClassificationID
					WHERE RadiationLicenceFeeListID = @RadiationLicenceFeeListID
                    ORDER BY A.SequenceOrder		 	 
				END
	    ELSE
				IF @RadiationLicenceFeeListID = 0
				BEGIN
					Declare @RadiationFeeListResultRowsFinal Table
					(	
						RadiationLicenceFeeListID smallint NULL,
						RadiationLicenceTypeID smallint  NULL,
						RadiationLicenceType varchar(255)  NULL,
						FeeDescription varchar(255)  NULL,
						Amount decimal(12, 2)  NULL,
						FeeType varchar(255)  NULL,
						SequenceOrder smallint  NULL,
						EffectiveDateFrom smalldatetime  NULL,
						EffectiveDateTo smalldatetime NULL,
						FinancialYear varchar(25)  NULL,
						DateCreated smalldatetime  NULL,
						CreatedBySystemUserID int  NULL,
						DateUpdated smalldatetime NULL,
						UpdatedBySystemUserID int NULL,
						CanBeDeleted BIT NULL																
					)
						    
					DECLARE @strSearchCriteria nvarchar(MAX)
					SELECT @strSearchCriteria =N'		
					SELECT RadiationLicenceFeeListID
					  ,RadiationLicenceTypeID
					  ,AA.Description as RadiationLicenceType
					  ,FeeDescription
					  ,Amount
					  ,FeeType
					  ,A.SequenceOrder
					  ,A.EffectiveDateFrom
					  ,A.EffectiveDateTo
					  ,A.FinancialYear 
					  ,A.DateCreated
					  ,A.CreatedBySystemUserID
					  ,A.DateUpdated
					  ,A.UpdatedBySystemUserID
					  ,0 AS CanBeDeleted					       
					FROM [dbo].[tblRadiationLicenceFeeList] A INNER JOIN tblClassification AA ON A.RadiationLicenceTypeID = AA.ClassificationID 
					WHERE RadiationLicenceFeeListID > 0 '

					DECLARE @whereClause0 AS nvarchar(MAX)                        
					SET  @whereClause0 = N''
					
					IF @RadiationLicenceFeeListID > 0
					BEGIN
					  SET @whereClause0 = @whereClause0 +  ' AND A.RadiationLicenceFeeListID = ' + convert(varchar, @RadiationLicenceFeeListID)
					END 

					IF @RadiationLicenceTypeID IS NOT NULL and @RadiationLicenceTypeID > 0
					BEGIN
					   SET @whereClause0 = @whereClause0 +  ' AND A.RadiationLicenceTypeID = ' + convert(varchar, @RadiationLicenceTypeID)
					END	

					IF @FeeDescription IS NOT NULL and Len(@FeeDescription) > 0
					BEGIN
						  SET @whereClause0 = @whereClause0 +  ' AND A.FeeDescription like ''%' + convert(varchar, @FeeDescription) + '%'' '
					END

					IF @Amount IS NOT NULL and @Amount > 0
					BEGIN
					   SET @whereClause0 = @whereClause0 +  ' AND A.Amount = ' + convert(varchar, @Amount) 
					END	

					IF @FeeType IS NOT NULL and Len(@FeeType) > 0
					BEGIN
						  SET @whereClause0 = @whereClause0 +  ' AND A.FeeType like ''%' + convert(varchar, @FeeType) + '%'' '
					END					

					IF @IsActive IS NOT NULL and @IsActive = 1
					BEGIN
						 SET @whereClause0 = @whereClause0 +  ' AND A.EffectiveDateTo IS NULL OR A.EffectiveDateTo >= GETDATE() '
					END
					
					IF @IsActive IS NOT NULL and @IsActive = 0
					BEGIN
						 SET @whereClause0 = @whereClause0 +  ' AND A.EffectiveDateTo IS NOT NULL '
					END		
					
					set @strSearchCriteria = @strSearchCriteria + @whereClause0 	

					
print '@strSearchCriteria=' + @strSearchCriteria 					
					
					Insert Into @RadiationFeeListResultRowsFinal 
					(
					   RadiationLicenceFeeListID,
					   RadiationLicenceTypeID,
					   RadiationLicenceType,
					   FeeDescription,
					   Amount,
					   FeeType,
					   SequenceOrder,
					   EffectiveDateFrom,
					   EffectiveDateTo,
					   FinancialYear, 
					   DateCreated, 
					   CreatedBySystemUserID, 
					   DateUpdated, 	
					   UpdatedBySystemUserID,
					   CanBeDeleted
					)			
					EXEC sp_executesql @strSearchCriteria;	
					


					SELECT P.*, 0 AS CanBeDeleted						  
					FROM @RadiationFeeListResultRowsFinal P  
					ORDER BY P.SequenceOrder				
			   END
