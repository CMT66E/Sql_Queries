
	declare @Lot NVARCHAR(6) = '2'
	declare @DP INT = 505616
	declare @SectionNumber NVARCHAR(20) = NULL
	declare @PlanType nvarchar(5) = 'DP'
	declare @objectid int 


	SET NOCOUNT ON
	SET XACT_ABORT OFF -- Allow procedure to continue after error
	
	DECLARE @sql nvarchar(2000)
	DECLARE @ErrorMessage varchar(2000)

	--BEGIN TRY
		SET @sql = 'SELECT @objectid = OBJECTID FROM OPENQUERY(GIS, '''
		if @PlanType = 'SP'
			begin
				SET @sql = @sql + 'SELECT OBJECTID FROM [Cadastre].sde.LOT WHERE'
				SET @sql = @sql + ' PlanNumber = ''''' + CAST(@DP as varchar(10)) + ''''' ' 
				SET @sql = @sql + ' AND ClassSubtype = 3'
			end
		else
			begin				
				SET @sql = @sql + 'SELECT OBJECTID FROM [Cadastre].sde.LOT WHERE LotNumber = ''''' + @Lot + ''''''
				SET @sql = @sql + ' AND PlanNumber = ''''' + CAST(@DP as varchar(10)) + ''''' ' 
			end
				

		IF(@SectionNumber IS NOT  NULL  AND @SectionNumber <> '')
		BEGIN
			SET @sql = @sql + ' AND SectionNumber = ''''' + @SectionNumber + '''' + '''' 
		END
	
		SET @sql = @sql + ' '')' 

		EXEC sp_executesql @sql, N'@objectid int output', @objectid output

	--END TRY
	--BEGIN CATCH
	--	 SET @ErrorMessage = dbo.ufn_GetErrorText()
 --        RAISERROR(@ErrorMessage, 16, 1)
	--END CATCH

	print '@objectid = ' + cast(@objectid as varchar)