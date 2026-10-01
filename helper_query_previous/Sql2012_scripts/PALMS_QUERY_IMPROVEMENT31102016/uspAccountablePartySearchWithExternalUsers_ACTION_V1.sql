declare @xmlSearchCriteria XML
set @xmlSearchCriteria = 
'
<DataAccountableParty>
  <SearchCriteria>
    <AccountablePartyNo>0</AccountablePartyNo>
    <TradingName />
    <ABN />
    <FirstName>Michael</FirstName>
    <LastName>Wu</LastName>
    <PrimaryRecordNo>0</PrimaryRecordNo>
    <ACN />
    <Email />
    <UserProfile>superuser</UserProfile>
  </SearchCriteria>
</DataAccountableParty>
'
declare @NoOfRecordsRequired int = 500
declare @MaxRecordsExport int = 5000
declare @ToExport BIT = 0
declare @pageSize int = 50
declare @pageNum int = 1	

BEGIN TRY

        DECLARE 
		@AccountablePartyNo AS INT,
		@EmailAddress AS VARCHAR(100),		 
		@FirstName AS VARCHAR(60), 
		@LastName AS VARCHAR(60),
		@RecordNo as INT, 
		@TradingName AS VARCHAR(128),
		@UserPrifile AS VARCHAR(200),		
		@ABN AS VARCHAR(14), 				
		@ACN AS VARCHAR(20) 

		SET @AccountablePartyNo = (SELECT xmlVals.rowvals.query('AccountablePartyNo').value('.','INT') From @xmlSearchCriteria.nodes('//DataAccountableParty/SearchCriteria') as xmlVals(rowvals))
		SET @EmailAddress = (SELECT xmlVals.rowvals.query('Email').value('.','VARCHAR(100)') From @xmlSearchCriteria.nodes('//DataAccountableParty/SearchCriteria') as xmlVals(rowvals))
		SET @FirstName = (SELECT xmlVals.rowvals.query('FirstName').value('.','VARCHAR(60)') From @xmlSearchCriteria.nodes('//DataAccountableParty/SearchCriteria') as xmlVals(rowvals))
		SET @LastName = (SELECT xmlVals.rowvals.query('LastName').value('.','VARCHAR(60)') From @xmlSearchCriteria.nodes('//DataAccountableParty/SearchCriteria') as xmlVals(rowvals))
		SET @RecordNo = (SELECT xmlVals.rowvals.query('PrimaryRecordNo').value('.','INT') From @xmlSearchCriteria.nodes('//DataAccountableParty/SearchCriteria') as xmlVals(rowvals))
		SET @TradingName = (SELECT xmlVals.rowvals.query('TradingName').value('.','VARCHAR(128)') From @xmlSearchCriteria.nodes('//DataAccountableParty/SearchCriteria') as xmlVals(rowvals))
		SET @UserPrifile = (SELECT xmlVals.rowvals.query('UserProfile').value('.','VARCHAR(128)') From @xmlSearchCriteria.nodes('//DataAccountableParty/SearchCriteria') as xmlVals(rowvals))		 
		SET @ABN = (SELECT xmlVals.rowvals.query('ABN').value('.','VARCHAR(14)') From @xmlSearchCriteria.nodes('//DataAccountableParty/SearchCriteria') as xmlVals(rowvals))		 
		SET @ACN = (SELECT xmlVals.rowvals.query('ACN').value('.','VARCHAR(20)') From @xmlSearchCriteria.nodes('//DataAccountableParty/SearchCriteria') as xmlVals(rowvals))
		
		SET @AccountablePartyNo = ISNULL(@AccountablePartyNo, 0);	
		SET @RecordNo = ISNULL(@RecordNo, 0)

		SET @FirstName = ISNULL(@FirstName, '');		 
		SET @LastName = ISNULL(@LastName, '');		 			
		SET @EmailAddress = ISNULL(@EmailAddress, '');	 
		SET @TradingName = ISNULL(@TradingName, '');
		 
		SET @UserPrifile = ISNULL(@UserPrifile, '');
		if len(@UserPrifile) > 0
		begin
		     if @UserPrifile = 'superuser'
		      SET @UserPrifile = rtrim(ltrim('PALMSOnline-Superuser'))
		     if @UserPrifile = 'editor'
		      SET @UserPrifile = rtrim(ltrim('PALMSOnline-Editor')) 
		end
print '@UserPrifile = ' + @UserPrifile				 

		SET @ABN = ISNULL(@ABN, '');
		SET @ACN = ISNULL(@ACN, '');
		
--start testing
		Declare @ResultRowsFinal Table
		(	 
		APNo int null,
		APName Varchar(200),
		Email Varchar(100), 
		ABN Varchar(14),
		ACN Varchar(20),
		FirstName Varchar(100),
		LastName Varchar(100),
		Recordno int null,
		UserProfile Varchar(200),
		TradingName Varchar(500), 					 									 				 
		RowCountTotal int null 													
		)
						    
		DECLARE @strSearchCriteria nvarchar(MAX)
		SELECT @strSearchCriteria =N'		
		select  
				b.AccountablePartyID as APNo,
				c.OrganisationName as APName,
				a.Email as Email, 
				c.ABN,
				c.ACN,
				a.FirstName,
				a.LastName,
				d.InstrumentID as Recordno,
				a.ApplicationRoles as UserProfile,
				c.TradingName, 					 									 				 
				0 as RowCountTotal 
		from vwProfile a 
		left outer join tblOnlineUserAccess b on a.ProfileID = b.ProfileID
		left outer join tblAccountableParty c on b.AccountablePartyID = c.AccountablePartyID 
		left outer join tblInstrumentAccountableParty d on c.AccountablePartyID = d.AccountablePartyID
		where not b.AccountablePartyID is null '

		DECLARE @whereClause0 AS nvarchar(MAX)                        
		SET  @whereClause0 = N''

		IF @AccountablePartyNo > 0
		BEGIN
			SET @whereClause0 = @whereClause0 +  ' b.AccountablePartyID = ' + convert(varchar, @AccountablePartyNo)
		END 

		IF @Recordno > 0
		BEGIN
			SET @whereClause0 = @whereClause0 +  ' d.InstrumentID = ' + convert(varchar, @Recordno)
		END 

		IF @EmailAddress IS NOT NULL and Len(@EmailAddress) > 0
		BEGIN
				SET @whereClause0 = @whereClause0 +  ' AND a.Email like ''%' + convert(varchar, @EmailAddress) + '%'' '
		END

		IF @FirstName IS NOT NULL and Len(@FirstName) > 0
		BEGIN
				SET @whereClause0 = @whereClause0 +  ' AND a.FirstName like ''%' + convert(varchar, @FirstName) + '%'' '
		END
					
		IF @LastName IS NOT NULL and LEN(@LastName) > 0
		BEGIN
			SET @whereClause0 = @whereClause0 +  ' AND a.LastName like ''%' + convert(varchar, @LastName) + '%'' '
		END				
					
		IF @TradingName IS NOT NULL and LEN(@TradingName) > 0  
		BEGIN
				SET @whereClause0 = @whereClause0 +  ' AND c.TradingName  like ''%' + convert(varchar, @TradingName) + '%'' ' 
		END						 

		IF @UserPrifile IS NOT NULL and LEN(@UserPrifile) > 0  
		BEGIN
				SET @whereClause0 = @whereClause0 +  ' AND a.ApplicationRoles like ''%' + convert(varchar, @UserPrifile) + '%'' '  
		END	

		IF @ABN IS NOT NULL and LEN(@ABN) > 0  
		BEGIN
				SET @whereClause0 = @whereClause0 +  ' AND c.ABN like ''%' + convert(varchar, @ABN) + '%'' '  
		END	

		IF @ACN IS NOT NULL and LEN(@ACN) > 0  
		BEGIN
				SET @whereClause0 = @whereClause0 +  ' AND c.ACN like ''%' + convert(varchar, @ACN) + '%'' '  
		END	

		set @strSearchCriteria = @strSearchCriteria + @whereClause0 
		
		Insert Into @ResultRowsFinal 
		(
			APNo,
			APName,
			Email, 
			ABN,
			ACN,
			FirstName,
			LastName,
			Recordno,
			UserProfile,
			TradingName, 					 									 				 
			RowCountTotal			
		)			
		EXEC sp_executesql @strSearchCriteria;	
							

		DECLARE @NoOfRecords as int	
		SELECT @NoOfRecords=COUNT(APNo) from @ResultRowsFinal	
		Update 	@ResultRowsFinal set RowCountTotal = @NoOfRecords
--end testing
 
		IF(@ToExport = 1)
		BEGIN
				SELECT DISTINCT TOP (@MaxRecordsExport)
							APNo,
							APName,
							Email, 
							ABN,
							ACN,
							FirstName,
							LastName,
							Recordno,
							UserProfile,
							TradingName, 					 									 				 
							RowCountTotal											  
						FROM @ResultRowsFinal  
						ORDER BY APNo	
		END
		ELSE			
			IF (@NoOfRecords <= @NoOfRecordsRequired)
			  BEGIN
			     
				SELECT TOP (@pageSize) *  FROM @ResultRowsFinal 
				WHERE APNo NOT IN  
				( SELECT TOP ((@pageNum - 1) * (@pageSize)) APNo FROM @ResultRowsFinal order by APNo )	
				order by APNo						
			  END		
			ELSE	
				SELECT 
					'0' as [APno], 
					'0' as [APname],
					'0' as [Postaladdress],
					'0' as [Recordno],
					'0' as [Recordtype], 
					'0' as [Section], 					 
					'0' as [Streetname],
					'0' as [Suburb]				
	END TRY

	BEGIN CATCH

		DECLARE @ErrorMessage VARCHAR(2000)
		SET @ErrorMessage = dbo.ufn_GetErrorText()
		RAISERROR (@ErrorMessage , 16, 1)

	END CATCH	