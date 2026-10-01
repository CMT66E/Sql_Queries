declare @xmlContactSearchBy XML
declare @MaxAllowed INT 
declare @MaxExport INT 
declare @DataUsage INT 
declare @OverLimit bit  
declare @pageSize int 
declare @pageNum int 
declare @fromAddAction bit  

set @xmlContactSearchBy = 
'
<DocumentElement><tblSearchContactBy><FirstName></FirstName><LastName></LastName><StreetName></StreetName><Organisation></Organisation><RecordNo>0</RecordNo><Suburb></Suburb><PageNum>1</PageNum><ContactNo>3048</ContactNo></tblSearchContactBy></DocumentElement>
'
set @MaxAllowed = 500
set @MaxExport = 5000
set @DataUsage = 0
set @OverLimit = 0 
set @pageSize = 50
set @pageNum = 3
set @fromAddAction = 0


	  DECLARE @selCmd AS NVARCHAR(4000)
	  DECLARE @selCmdForCount AS NVARCHAR(4000)
	  DECLARE @selectClause AS NVARCHAR(4000)
	  DECLARE @selectClauseForCount AS NVARCHAR(4000)
	  DECLARE @whereClause AS NVARCHAR(4000)
	  
	  
	  DECLARE @FirstName VARCHAR(60)=NULL
	  DECLARE @LastName VARCHAR(60)=NULL
	  DECLARE @StreetName VARCHAR(60)=NULL
	  DECLARE @Organisation VARCHAR(60)=NULL
	  DECLARE @RecordNo INT =0
	  DECLARE @Suburb VARCHAR(60)=NULL
	  DECLARE @NoOfRows INT =0
	  DECLARE @ParmDefinition nvarchar(500);
	  DECLARE @my_count int
	  DECLARE @ContactNo INT = 0
	  
 
			--set values for searching criteria
			SELECT
						@ContactNo = xmlVals.rowvals.query('ContactNo').value('.','INT'),
						@FirstName = xmlVals.rowvals.query('FirstName').value('.','VARCHAR(60)'),
						@LastName = xmlVals.rowvals.query('LastName').value('.','VARCHAR(60)'),
						@StreetName =xmlVals.rowvals.query('StreetName').value('.','VARCHAR(60)'),
						@Organisation =xmlVals.rowvals.query('Organisation').value('.','VARCHAR(60)'),  
						@RecordNo = xmlVals.rowvals.query('RecordNo').value('.','INT'),
						@Suburb = xmlVals.rowvals.query('Suburb').value('.','VARCHAR(60)')	
			 FROM       @xmlContactSearchBy.nodes('/DocumentElement/tblSearchContactBy') as xmlVals(rowvals)
			
			SET @FirstName = REPLACE(rtrim(ltrim(@FirstName)),'''','''''')
			SET @LastName = REPLACE(rtrim(ltrim(@LastName)),'''','''''')
			SET @StreetName = REPLACE(rtrim(ltrim(@StreetName)),'''','''''')
			SET @Organisation = REPLACE(rtrim(ltrim(@Organisation)),'''','''''')
			SET @Suburb = REPLACE(rtrim(ltrim(@Suburb)),'''','''''')
			
			
			SET @selectClauseForCount = N'SELECT @my_countOUT = COUNT(*) FROM dbo.viewContactSearchResult'
			SET @selectClause = N'SELECT DISTINCT [ContactID], [Contact Name], Position,Organisation, [Postal Address], [Email], [RecordNo],[RecordType] from dbo.viewContactSearchResult'
			SET @whereClause = N''
			SET @ParmDefinition = N'@my_countOUT int OUTPUT';

		   IF @ContactNo IS NOT NULL AND @ContactNo <> 0
			BEGIN
				SET @whereClause = @whereClause +  ' ContactID = ' + convert(varchar,@ContactNo) + ' '
			END	
			
		   IF @FirstName IS NOT NULL and @FirstName<>''
			begin
					if @whereClause <> N'' 
						set @whereClause = @whereClause + ' AND '
				  SET @whereClause = @whereClause +  ' [First Name] like ''%' + @FirstName + '%'' '
			end
			
			if @LastName is not null AND @LastName <>''
			begin
				  if @whereClause <> N'' 
						set @whereClause = @whereClause + ' AND '
				  SET @whereclause = @whereClause + '  [Last Name] like ''%' + @LastName + '%'' '
			end
			
			if @StreetName is not null AND @StreetName <>''
			begin
				  if @whereClause <> N'' 
						set @whereClause = @whereClause + ' AND '
				  SET @whereclause = @whereClause + '  [Street Name] like ''%' + @StreetName + '%'' '
			end
			
			  if @Organisation is not null AND @Organisation <>''
			begin
				  if @whereClause <> N'' 
						set @whereClause = @whereClause + ' AND '
				  SET @whereclause = @whereClause + '  Organisation like ''%' + @Organisation+ '%'' '
			end
			
			if @RecordNo <>0
			begin
				  if @whereClause <> N'' 
						set @whereClause = @whereClause + ' AND '
				  SET @whereClause = @whereClause +  ' [RecordNo] = ' + convert(varchar,@RecordNo)
			end
			
			Print @Suburb
			 if @Suburb is not null AND @Suburb <>''
			begin
				  if @whereClause <> N'' 
						set @whereClause = @whereClause + ' AND '
				  SET @whereclause = @whereClause + '  Suburb like ''%' + @Suburb + '%'' '
			end


			
			SET @selCmdForCount = @selectClauseForCount
			IF LEN(@whereClause) > 0
				  SET @selCmdForCount  = @selCmdForCount  + ' WHERE ' + @whereClause
				  
			SET @selCmd = @selectClause
			IF LEN(@whereClause) > 0
				  SET @selCmd = @selCmd + ' WHERE ' + @whereClause
			   
			Print '@@selCmd=' + @selCmd
			
			EXEC sp_executesql @selCmdForCount,@ParmDefinition, @my_countOUT = @my_count OUTPUT;
  
            if @my_count <= @MaxAllowed OR @DataUsage =1
            begin
				--Define a temp table to hold all return records
			 
				declare @InstrumentResultRows table(						  
					ContactID int null,
					[Contact Name] Varchar(255), 
					Position Varchar(255), 
					Organisation Varchar(255), 
					[Postal Address] Varchar(500),  
					Email Varchar(255), 
					RecordNo int null,
					RecordType Varchar(255),
					RowCountTotal int null					
				)
					
				Insert Into @InstrumentResultRows
				(

					ContactID, 
					[Contact Name], 
					Position,
					Organisation, 
					[Postal Address], 
					Email, 
					RecordNo,
					RecordType		 		
				)
				EXEC sp_executesql @selCmd;

				DECLARE @ActualCount INT
				SELECT @ActualCount = COUNT(ContactID) from @InstrumentResultRows			
				UPDATE @InstrumentResultRows SET RowCountTotal = @ActualCount					
			end		
			
			IF(@DataUsage = 1)
				BEGIN
					Select TOP(@MaxExport) * from @InstrumentResultRows order by RecordNo
					SET @OverLimit = 0	
				END
			Else	
			    if(@my_count <@MaxAllowed)				
			    BEGIN	
			      IF @fromAddAction = 0			
					SELECT TOP (@pageSize) *  FROM @InstrumentResultRows 
					WHERE RecordNo NOT IN  
					( SELECT TOP ((@pageNum - 1) * (@pageSize)) RecordNo FROM @InstrumentResultRows order by RecordNo )	
					order by RecordNo
				  ELSE
				    SELECT TOP (@MaxAllowed) *  FROM @InstrumentResultRows 	
				    order by RecordNo
				    
				  SET @OverLimit = 0	
			    END
			    ELSE
			    BEGIN			    
			        SET @OverLimit = 1  
			    END
            
			DELETE @InstrumentResultRows