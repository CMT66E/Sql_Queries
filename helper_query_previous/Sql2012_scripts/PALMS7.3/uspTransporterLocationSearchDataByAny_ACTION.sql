
		declare @xmlLocationSearchBy XML = NULL

		set @xmlLocationSearchBy = 
		'
<DocumentElement>
  <SearchRadiationLocationBy>
    <RadiationLocationID>0</RadiationLocationID>
    <Street></Street>
    <Suburb></Suburb>
    <LocationName></LocationName>
    <RecordNo>0</RecordNo>
    <RRMTypeID>0</RRMTypeID>
    <RRMID>0</RRMID>
    <SerialNumber>0</SerialNumber>
    <SecurityClassificationID>0</SecurityClassificationID>
    <SectionID>0</SectionID>
    <PageNum>1</PageNum>
    <LicenceTypeID>1402</LicenceTypeID>
  </SearchRadiationLocationBy>
</DocumentElement>
		'

		declare @MaxAllowed INT = 500
		declare @MaxExport INT = 5000
		declare @DataUsage INT =0 
		declare @OverLimit bit =0  
		declare @pageSize int = 50
		declare @pageNum int = 1
		declare @fromAddAction bit = 0	
		declare @relocationSearch bit = 0
		declare @forLocationID int = 0
		declare @RRMSearch BIT = 0

      DECLARE @selCmdForCount AS NVARCHAR(4000)
      DECLARE @selCmdForRecord AS NVARCHAR(4000)
      DECLARE @selectClauseForCount AS NVARCHAR(4000)
      DECLARE @selectClauseForRecord AS NVARCHAR(max)
	  DECLARE @selectClauseForRecordExtra AS NVARCHAR(max) --added for filter same licence relocating issue Eric He 11-04-2014
      DECLARE @whereClause AS NVARCHAR(4000)
      
      
      DECLARE @TransporterLocationID INT = 0
	  DECLARE @LicenceTypeID INT = 0
      DECLARE @Street VARCHAR(60)=NULL
      DECLARE @Suburb VARCHAR(60)=NULL
      DECLARE @LocationName VARCHAR(60)=NULL
      DECLARE @RecordNo INT =0
      DECLARE @RRMTypeID INT =0
      DECLARE @RRMID INT =0
      DECLARE @SerialNumber INT =0
      DECLARE @ComponentTypeID INT =0
      DECLARE @SecurityClassificationID INT =0

      DECLARE @ParmDefinition nvarchar(500);
      DECLARE @my_count int
      
    
	  
	  Create Table #tblRadiationLocation
						(
							RadiationLocationID int
						)
     
--    BEGIN TRY

			 --set values for searching criteria
			 SELECT
						@TransporterLocationID = xmlVals.rowvals.query('RadiationLocationID').value('.','INT'),
						@LicenceTypeID = xmlVals.rowvals.query('LicenceTypeID').value('.','INT'),
						@Street = xmlVals.rowvals.query('Street').value('.','VARCHAR(60)'), 
						@Suburb =xmlVals.rowvals.query('Suburb').value('.','VARCHAR(60)'),
						@LocationName = xmlVals.rowvals.query('LocationName').value('.','VARCHAR(60)'),
						@RecordNo = xmlVals.rowvals.query('RecordNo').value('.','INT'),
						@RRMTypeID = xmlVals.rowvals.query('RRMTypeID').value('.','INT'),
						@RRMID = xmlVals.rowvals.query('RRMID').value('.','INT'),
						@SerialNumber = xmlVals.rowvals.query('SerialNumber').value('.','INT'),
						@ComponentTypeID = xmlVals.rowvals.query('ComponentTypeID').value('.','INT'),
						@SecurityClassificationID = xmlVals.rowvals.query('SecurityClassificationID').value('.','INT')
			 FROM       @xmlLocationSearchBy.nodes('/DocumentElement/SearchRadiationLocationBy') as xmlVals(rowvals)
			 
			 SET @Street = REPLACE(rtrim(ltrim(@Street)),'''','''''')
			 SET @Suburb = REPLACE(rtrim(ltrim(@Suburb)),'''','''''')
			 SET @LocationName = REPLACE(rtrim(ltrim(@LocationName)),'''','''''')
 
			SET @selectClauseForCount = N'SELECT  @my_countOUT = COUNT(Distinct TransporterLocationID) FROM dbo.viewSearchTransporterLocCount'
			SET @selectClauseForRecord  = N'SELECT distinct TransporterLocationID FROM dbo.viewSearchTransporterLocCount'
			 
            SET  @whereClause = N''
            SET @ParmDefinition = N'@my_countOUT int OUTPUT';
	   
            IF @TransporterLocationID IS NOT NULL and @TransporterLocationID <> 0
            begin
                  SET @whereClause = @whereClause +  ' TransporterLocationID = ' + convert(varchar, @TransporterLocationID)
            end

            IF @LicenceTypeID IS NOT NULL and @LicenceTypeID <> 0
            begin
                  SET @whereClause = @whereClause +  ' LicenceTypeID = ' + convert(varchar, @LicenceTypeID)
            end

            if @Street is not null AND @Street <>''
            begin
                  if @whereClause <> N'' 
                        set @whereClause = @whereClause + ' AND '
                  SET @whereclause = @whereClause + '  Street like ''%' + @Street + '%'' '
            end
            
            if @Suburb is not null AND @Suburb <>''
            begin
                  if @whereClause <> N'' 
                        set @whereClause = @whereClause + ' AND '
                  SET @whereclause = @whereClause + '  Suburb like ''%' + @Suburb + '%'' '
            end
            
            if @LocationName is not null AND @LocationName <>''
            begin
                  if @whereClause <> N'' 
                        set @whereClause = @whereClause + ' AND '
                  SET @whereclause = @whereClause + '  [LocationName] like ''%' + @LocationName + '%'' '
            end
            
            IF @RecordNo IS NOT NULL and @RecordNo<>0
            begin
				 if @whereClause <> N'' 
					set @whereClause = @whereClause + ' AND '
                  SET @whereClause = @whereClause +  ' [RecordNo] = ' + convert(varchar, @RecordNo)
            end
            
			IF @RRMTypeID IS NOT NULL and @RRMTypeID <> 0
            begin
				if @whereClause <> N'' 
					set @whereClause = @whereClause + ' AND '
                  SET @whereClause = @whereClause +  ' RRMTypeID = ' + convert(varchar, @RRMTypeID)
            end
            
			IF @RRMID IS NOT NULL and @RRMID <> 0
            begin
				if @whereClause <> N'' 
					set @whereClause = @whereClause + ' AND '
                  SET @whereClause = @whereClause +  ' RRMID = ' + convert(varchar, @RRMID)
            end

			IF @SerialNumber IS NOT NULL and @SerialNumber<>0
            begin
				 if @whereClause <> N'' 
					set @whereClause = @whereClause + ' AND '
                  SET @whereClause = @whereClause +  ' [SerialNumber] = ' + convert(varchar, @SerialNumber)
            end
            
			IF @ComponentTypeID IS NOT NULL and @ComponentTypeID <> 0
            begin
				if @whereClause <> N'' 
					set @whereClause = @whereClause + ' AND '
                  SET @whereClause = @whereClause +  ' ComponentTypeID = ' + convert(varchar, @ComponentTypeID)
            end
            
			IF @SecurityClassificationID IS NOT NULL and @SecurityClassificationID <> 0
            begin
				if @whereClause <> N'' 
					set @whereClause = @whereClause + ' AND '
                  SET @whereClause = @whereClause +  ' RRMSecurityClassificationID = ' + convert(varchar, @SecurityClassificationID)
            end

			IF (@relocationSearch IS NOT NULL AND @relocationSearch = 1)
			begin
				if @whereClause <> N'' 
					set @whereClause = @whereClause + ' AND '
				SET @whereClause = @whereClause +  ' RecordStatusID in (' + convert(varchar, 755) + ', '+ convert(varchar, 751) + ', '+ convert(varchar, 752) + ')' --issue licence and draft licence

				if @forLocationID is not null and @forLocationID > 0
				begin
					if @relocationSearch <> 1
					begin		
						if @whereClause <> N'' 
							set @whereClause = @whereClause + ' AND '
						SET @whereClause = @whereClause +  ' TransporterLocationID <> ' + convert(varchar, @forLocationID) --do not include this locaiton
					end
					else
					begin
					  if @RRMSearch = 0  -- when it is 0 then @forLocationID is RadiationLcoationID of current relocation search 
					  begin
						if @whereClause <> N'' 
							set @whereClause = @whereClause + ' AND '
						SET @whereClause = @whereClause +  ' TransporterLocationID <> ' + convert(varchar, @forLocationID) --do not include this locaiton
					  end
					end
				end				
			end

			if(@RRMSearch IS NOT NULL AND @RRMSearch = 1) --means it is RRM component relocation search
			begin
				if @whereClause <> N'' 
					set @whereClause = @whereClause + ' AND '

				SET @whereClause = @whereClause +  ' RRMStatusID = ' + convert(varchar, 785)				

				if @forLocationID is not null and @forLocationID > 0
				begin
					if @whereClause <> N'' 
						set @whereClause = @whereClause + ' AND '
						
					SET @whereClause = @whereClause +  ' RadiationLicenceRRMID <> ' + convert(varchar, @forLocationID) --do not include this RRM
				end				
			end

			
           SET @OverLimit = 0--false
           
           IF LEN(@whereClause) <= 0
				 RETURN 
			
           SET @selCmdForCount = @selectClauseForCount
           
           IF LEN(@whereClause) > 0
                 SET @selCmdForCount  = @selCmdForCount  + ' WHERE ' + @whereClause
               
           SET @selCmdForRecord = @selectClauseForRecord
           IF LEN(@whereClause) > 0
                SET @selCmdForRecord  = @selCmdForRecord  + ' WHERE ' + @whereClause + ' ORDER BY TransporterLocationID'

			--print @selCmdForCount
			EXEC sp_executesql @selCmdForCount, @ParmDefinition, @my_countOUT = @my_count OUTPUT;
                
              
		    --Define a temp table to hold all return records
			Create Table #InstrumentResultRows
			(					  				
				RadiationLocationID int null,
				LocationName Varchar(255), 
				Street Varchar(100), 
				Suburb Varchar(100),
				RecordNo int null,
				ResponsibleOfficer Varchar(100),
				Section Varchar(500),
				Postcode varchar(100),	
				StateCode varchar(50),
				RRMNo INT null,
				RRMType VARCHAR(200) null,
				Equipment VARCHAR(200) null,
				RowCountTotal int null 									
			)
                
			Create Table #InstrumentResultRowsFinal
			(					  				
				RadiationLocationID int null,
				LocationName Varchar(255), 
				Street Varchar(100), 
				Suburb Varchar(100),
				RecordNo int null,
				ResponsibleOfficer Varchar(100),
				Section Varchar(500),
				Postcode varchar(100),	
				StateCode varchar(50),
				RRMNo INT null,
				RRMType VARCHAR(200) null,
				Equipment VARCHAR(200) null,
				RowCountTotal int null 										
			)
            
			INSERT INTO #tblRadiationLocation
			EXEC sp_executesql @selCmdForRecord;
		    
			DECLARE @ConcatString VARCHAR(MAX)

			SELECT @ConcatString = coalesce(@ConcatString + ',' , '')   + Convert(varchar, RadiationLocationID) 
			FROM #tblRadiationLocation
			
			select @ConcatString = CASE WHEN Len(@ConcatString) > 0 THEN LEFT(@ConcatString,LEN(@ConcatString)) ELSE @ConcatString END
			
			declare @CurrentInstrumentID int  --handle the RRM component to be allocate to its own RRM record location
			set @CurrentInstrumentID = 0



			IF(@RRMSearch = 1 OR @RRMSearch = 0) --means it is RRM component relocation search
			   BEGIN
					SET @selectClauseForRecord  = N'SELECT DISTINCT ' +  ' TransporterLocationID, LocationName, Street, Suburb, RecordNo, ResponsibleOfficer, Section, Postcode, StateCode, RRMNo, RRMType, Equipment FROM dbo.viewSearchTransporterLocRRMResult X WHERE TransporterLocationID IN('+@ConcatString+')'

					--Modified by Eric He from bug fixing 07-04-2014
					if @relocationSearch = 1  --for relocation we only return all issued radiation licences
					begin
					    if @RRMSearch = 1 and @forLocationID > 0  -- means when @RRMSearch = 1 the value @forLocationID is RRMNo; when @RRMSearch = 0 it is RadiationLocationID
						begin
						    --we need get current record number based on input RRMNo
							select @CurrentInstrumentID = isnull(RecordNo, 0) from dbo.viewSearchRadiationLocRRMResult where RRMNo = @forLocationID						   
						end

			            if @RRMSearch = 0  and @forLocationID > 0  --when @RRMSearch = 0 the value @forLocationID is TransporterLocationID
			            begin
						   select @CurrentInstrumentID = InstrumentID from tblInstrumentTransporterLocation where TransporterLocationID = @forLocationID
					    end

						--get rid of those locations which their licences are in variation status
					    set @selectClauseForRecord = N'SELECT DISTINCT ' +  '  X.TransporterLocationID, LocationName, Street, Suburb, ' + 
														'RecordNo, '  + 
														'ResponsibleOfficer, ' + 
														'Section, '  + 
														'Postcode, '  + 
														'StateCode, '  + 
														'RRMNo, '  +  
														'RRMType, '  + 
														'Equipment '  +
														'FROM dbo.viewSearchTransporterLocRRMResult X ' + 
														'INNER JOIN tblInstrumentRadiationLocation A ON RecordNo = A.InstrumentID ' + 
														'INNER JOIN tblInstrument B on RecordNo = B.InstrumentID ' + 
														'WHERE B.InstrumentStatusID in (755, 751, 752) ' + 
														'and dbo.ufn_RadiationLicenceHasActiveVariation(RecordNo) = 0'
														--755: issued 751: draft and 752: Submitted PALMS V6.0 asked to allow draft licence to be relocate to commented by Eric He 16
														--Modified in 22-07-2015 required by Sean Nunan: I have discussed the matter with Tony and he agreed that the business rules 
														--should allow regulated material to be transferred to a target licence that has a status of renewal pending. 
														--we commented out the ufn_RadiationLicenceHasPendingRenewal checking from stored procedure:
														--and dbo.ufn_RadiationLicenceHasPendingRenewal(RecordNo) = 0
						if @CurrentInstrumentID > 0 
						begin
						   set @selectClauseForRecord = @selectClauseForRecord + ' AND RecordNo <> ' + convert(varchar, @CurrentInstrumentID)

						   --we do allow RRM and RRM components to be relocated within same licence. In this case current radiation licence is in variation status
						   set @selectClauseForRecordExtra = N'SELECT DISTINCT ' +  '  X.TransporterLocationID, LocationName, Street, Suburb, ' + 
														'RecordNo, '  + 
														'ResponsibleOfficer, ' + 
														'Section, '  + 
														'Postcode, '  + 
														'StateCode, '  + 
														'RRMNo, '  +  
														'RRMType, '  + 
														'Equipment '  +
														'FROM dbo.viewSearchTransporterLocRRMResult X ' + 
														'INNER JOIN tblInstrumentRadiationLocation A ON RecordNo = A.InstrumentID ' + 
														'INNER JOIN tblInstrument B on RecordNo = B.InstrumentID ' + 
														'WHERE B.InstrumentStatusID in (755, 751, 752) AND RecordNo = ' + convert(varchar, @CurrentInstrumentID) 
														--755: issued 751: draft and 752: Submitted PALMS V6.0 asked to allow draft licence to be relocate to commented by Eric He 
					    end
					end

					if @forLocationID is not null and @forLocationID > 0 and @relocationSearch = 1
					begin					    
						if @RRMSearch = 1 -- if it is RRM componenet search then we need mark sure the RRM No should not be itself we don't allow relocate to be itself RRM No
						begin
						    --Only when it is component search we make sure RRMStatus checked for simple RRM search we only care is location whether it has RRM record is not important
							SET @selectClauseForRecord = @selectClauseForRecord + ' AND RRMStatusID = 785 ' 
							if len(@selectClauseForRecordExtra) > 0
							   SET @selectClauseForRecordExtra = @selectClauseForRecordExtra + ' AND RRMStatusID = 785 '

							SET @selectClauseForRecord = @selectClauseForRecord + ' AND RRMNo <> ' + convert(varchar, @forLocationID)
							if len(@selectClauseForRecordExtra) > 0
							   SET @selectClauseForRecordExtra = @selectClauseForRecordExtra + ' AND RRMNo <> ' + convert(varchar, @forLocationID)
						end
					end

					--print '@ConcatString=' + @ConcatString

					if @relocationSearch = 1 
					begin
					    SET @selectClauseForRecord = @selectClauseForRecord  + ' AND X.TransporterLocationID IN (' + @ConcatString + ')' 
						if len(@selectClauseForRecordExtra) > 0
						   SET @selectClauseForRecordExtra = @selectClauseForRecordExtra + ' AND X.TransporterLocationID IN (' + @ConcatString + ')' 
					end

					IF @RRMTypeID IS NOT NULL and @RRMTypeID <> 0
					begin
					      declare @RRMTypeText varchar(200)
						  select @RRMTypeText = RRMType from tblRRMType where RRMTypeID = @RRMTypeID						 
						  SET @selectClauseForRecord = @selectClauseForRecord  +   ' AND X.RRMType = ''' + @RRMTypeText + '''' 

						  if len(@selectClauseForRecordExtra) > 0
						    SET @selectClauseForRecordExtra = @selectClauseForRecordExtra +   ' AND X.RRMType = ''' + @RRMTypeText + ''''
					end
				END
			ELSE 
			   BEGIN		 
					SET @selectClauseForRecord  = N'SELECT DISTINCT ' +  ' TransporterLocationID, LocationName, Street, Suburb, RecordNo, ResponsibleOfficer, Section, Postcode, StateCode, viewSearchTransporterLocCount FROM dbo.viewSearchTransporterLocResult WHERE TransporterLocationID IN('+@ConcatString+')'
			   END
			
			print @selectClauseForRecord
            if @my_count <= @MaxAllowed OR @DataUsage =1
			begin
				
					IF(@RRMSearch = 1 OR @RRMSearch = 0)
						BEGIN
							Insert Into #InstrumentResultRows
							(
								RadiationLocationID,
								LocationName, 
								Street, 
								Suburb,
								RecordNo,
								ResponsibleOfficer,
								Section,
								Postcode,	
								StateCode,
								RRMNo,
								RRMType,
								Equipment 	
							)
							EXEC sp_executesql @selectClauseForRecord;
							if @CurrentInstrumentID > 0 AND Len(@selectClauseForRecordExtra) >0 
							Insert Into #InstrumentResultRows
							(
								RadiationLocationID,
								LocationName, 
								Street, 
								Suburb,
								RecordNo,
								ResponsibleOfficer,
								Section,
								Postcode,	
								StateCode,
								RRMNo,
								RRMType,
								Equipment 
							)
							EXEC sp_executesql @selectClauseForRecordExtra;
						END
					ELSE
						BEGIN
							Insert Into #InstrumentResultRows
							(
								RadiationLocationID,
								LocationName, 
								Street, 
								Suburb,
								RecordNo,
								ResponsibleOfficer,
								Section,
								Postcode,	
								StateCode 
							)
							EXEC sp_executesql @selectClauseForRecord;
						END
							                
					DECLARE @ActualCount INT
					SELECT @ActualCount = COUNT(DISTINCT RadiationLocationID) from #InstrumentResultRows A left outer join tblInstrumentTransporterLocation B ON A.RadiationLocationID = B.TransporterLocationID and A.RecordNo = B.InstrumentID
							left outer join tblTransporterLicence TL ON B.InstrumentID = TL.InstrumentID
							left outer join tblClassification TLC ON TL.LicenceTypeID = TLC.ClassificationID
										
					UPDATE #InstrumentResultRows SET RowCountTotal = @ActualCount
			 end			
			
			--Added by Eric He 24-04-2013
			--because we are not using RRMNo, RRMType, Equipment columns when the user is doing RRM component search for relocation purpose
			--so we can set them as null to avoid the duplications
			IF @RRMSearch = 0 -- if it is RRM component search
			   update 	#InstrumentResultRows set RRMNo = null, RRMType = null, Equipment = null

			insert into #InstrumentResultRowsFinal 
			select distinct * from #InstrumentResultRows

		 
			SELECT @ActualCount = COUNT(RadiationLocationID) from #InstrumentResultRowsFinal
			UPDATE #InstrumentResultRowsFinal SET RowCountTotal = @ActualCount

			IF(@DataUsage =1) --If it is for export we will get MaxExport records and return
			begin			   
			   Select TOP(@MaxExport) A.*, B.InstrumentID as LicenceNo  FROM #InstrumentResultRows A  
							left outer join tblInstrumentTransporterLocation B ON A.RadiationLocationID = B.TransporterLocationID and A.RecordNo = B.InstrumentID 
							--where B.EffectiveDateTo is null
							order by RadiationLocationID	
			   SET @OverLimit = 0 --set false
			end
			else              --If it is not for export purpose we check the number of returned records
			begin
			    if @my_count <= @MaxAllowed
					  BEGIN
					       IF @fromAddAction = 0
							SELECT DISTINCT TOP (@pageSize) A.*, B.InstrumentID as LicenceNo, TLC.[Description] as LicenceType  
							FROM #InstrumentResultRowsFinal A  
							left outer join tblInstrumentTransporterLocation B ON A.RadiationLocationID = B.TransporterLocationID and A.RecordNo = B.InstrumentID
							left outer join tblTransporterLicence TL ON B.InstrumentID = TL.InstrumentID
							left outer join tblClassification TLC ON TL.LicenceTypeID = TLC.ClassificationID
							WHERE  
							--B.EffectiveDateTo is null and 
							A.RadiationLocationID NOT IN  
							( SELECT TOP ((@pageNum - 1) * (@pageSize)) RadiationLocationID FROM #InstrumentResultRowsFinal order by RadiationLocationID )	
							order by RadiationLocationID		
						   Else
							SELECT DISTINCT TOP (@MaxAllowed) A.*, B.InstrumentID as LicenceNo, TLC.[Description] as LicenceType  
							FROM #InstrumentResultRowsFinal A	
							left outer join tblInstrumentTransporterLocation B ON A.RadiationLocationID = B.TransporterLocationID and A.RecordNo = B.InstrumentID	
							left outer join tblTransporterLicence TL ON B.InstrumentID = TL.InstrumentID
							left outer join tblClassification TLC ON TL.LicenceTypeID = TLC.ClassificationID						 
							--B.EffectiveDateTo is null				
							order by RadiationLocationID							   	
							
							SET @OverLimit = 0		  						
					  END
			    else
			          SET @OverLimit = 1			    			    
			end
			
		   Drop Table #tblRadiationLocation
		   Drop Table #InstrumentResultRows
		   Drop Table #InstrumentResultRowsFinal