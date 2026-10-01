
		declare @xmlSearchCriteria XML
		declare @NoOfRecordsRequired int = 2000
		declare @MaxRecordsExport int = 3000
		declare @ToExport BIT = 0
		declare @pageSize int = 50
		declare @pageNum int = 1

		set @xmlSearchCriteria = 
		'
			<DataPRHWapp>
			  <PrimarySearchCriteria>
				<Suburb>%</Suburb>
				<WasteCodeID>0</WasteCodeID>
			  </PrimarySearchCriteria>
			</DataPRHWapp>
		'
		DECLARE @LicenceNo as int,
		        @FacilityName as Varchar(255), 
				@Suburb VARCHAR(50),
		        @WasteCodeID as int 
						 		
		SELECT 
			@LicenceNo = xmlVals.rowvals.value('(LicenceNo)[1]','INT'),
			@FacilityName = xmlVals.rowvals.value('(Name)[1]','VARCHAR(255)'),
			@Suburb = xmlVals.rowvals.value('(Suburb)[1]','VARCHAR(50)'),
			@WasteCodeID = xmlVals.rowvals.value('(WasteCodeID)[1]','INT') 
		From @xmlSearchCriteria.nodes('//DataPRHWapp/PrimarySearchCriteria') as xmlVals(rowvals)		
				
 		CREATE TABLE #InstrumentResultRows  
		(
		    AccountOperationID int null,
			LicenceNo int null, 
			Name VARCHAR(255) null,		 
			[Address] Varchar(500) null,			 
			WasteCode varchar(5000) null,
			RowCountTotal int null			 
		)

		SET NOCOUNT ON
 
		INSERT INTO #InstrumentResultRows(AccountOperationID, LicenceNo, Name, [Address], WasteCode, RowCountTotal)
		 
		SELECT DISTINCT 
		AO.AccountOperationID AS AccountOperationID, 
		[dbo].[ufn_PALMSGetAccountOperationPermitNumber] (AO.AccountOperationID) as LicenceNo, 
		SITE.SiteAliasName AS Name, 
		CAST(SITE.StreetAddress AS Varchar(255)) + ', ' + CAST(SITE.Suburb AS Varchar(255)) + ' ' + CAST(SITE.PostCode AS Varchar(255)) + ' ' + CAST(SITE.StateCode AS Varchar(255)) AS [Address], 
		[dbo].[ufn_PALMSGetWasteCodeListByAccountOperationID] (AO.AccountOperationID) as WasteCode, 
		0 as RowCountTotal 
		FROM AccountOperation AO 
		JOIN Site SITE ON Site.SiteID = AO.SiteID 
		LEFT JOIN Individual IND ON IND.AccountOperationID = AO.AccountOperationID 
		LEFT JOIN OWTAccountOperationWasteCode AOW ON AOW.AccountOperationID = AO.AccountOperationID 
		WHERE AO.EffectiveDateFrom <= GETDATE( ) 
		AND (AO.EffectiveDateTo IS NULL OR AO.EffectiveDateTo >= GETDATE( )) 
		AND AO.AccountOperationRoleTypeID = 289 			 	 
		AND
		(
			@FacilityName IS NULL OR @FacilityName = ''
			OR (PATINDEX(@FacilityName, isnull([Site].SiteAliasName, '')) > 0)
		)
		AND (@LicenceNo is null or @LicenceNo = 0 or AO.AccountOperationPermit = cast(@LicenceNo as varchar)) 
		AND
		(
			@Suburb IS NULL OR @Suburb = ''
			OR (PATINDEX(@Suburb, isnull([Site].Suburb, '')) > 0)		   
		)		 
		AND (@WasteCodeID = 0 or AOW.OWTWasteCodeID = @WasteCodeID) 		 
		Order by Name
	 
 

		SET NOCOUNT OFF		
		 
		DECLARE @ActualCount INT
	    SELECT @ActualCount = COUNT(LicenceNo) from #InstrumentResultRows
		
		UPDATE #InstrumentResultRows SET RowCountTotal = @ActualCount
		
		 
		IF(@ToExport = 1)
			BEGIN
				Select TOP(CASE WHEN @ToExport = 1 THEN @MaxRecordsExport ELSE @NoOfRecordsRequired END) * from #InstrumentResultRows order by LicenceNo
			END
		Else
			Begin
			    --If the return count is less than the limit such as 500 records in total then
			    --we get those records in batch such as every time we get 50 records
			    
                IF(@ActualCount <= @NoOfRecordsRequired)
					SELECT TOP (@pageSize) 
					AccountOperationID,
					(case LicenceNo when 0 then null else LicenceNo end) as LicenceNo, 
					Name,		 
					[Address],			 
					WasteCode,
					RowCountTotal	
					FROM #InstrumentResultRows as PrimarySearchResults 
					WHERE LicenceNo NOT IN (SELECT TOP ((@pageNum - 1) * (@pageSize)) LicenceNo FROM #InstrumentResultRows order by LicenceNo)	
					 order by LicenceNo	
                ElSE 
				    Select 
					0 as LicenceNo, 
					'' as Name, 
					'' as [Address], 
					'' as WasteCode               		                												                
			End
	
		drop table #InstrumentResultRows
     