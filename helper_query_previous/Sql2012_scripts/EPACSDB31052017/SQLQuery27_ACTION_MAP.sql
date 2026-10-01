	declare @Lot NVARCHAR(6) = '2'
	declare @DP INT = 795095
	declare @SectionNumber NVARCHAR(20) = NULL
	declare @Plan_Type nvarchar(5) = 'DP'
 
    SET NOCOUNT ON -- interfering with SELECT statements.
	SET XACT_ABORT OFF -- Allow procedure to continue after error

	--Delete from tmptable
	DELETE FROM tblReturnIntersectsTmp

	DECLARE @ErrorMessage varchar(2000)
	DECLARE @SiteBoundaryOverlapMessage varchar(512)
	DECLARE @WithdrawNotificationsMessage varchar(512)

	DECLARE @tblLotDP tblSpatialIntersectLotDP
	DECLARE @tblSpatialLayer tblSpatialLayer

	
	DECLARE @sql nvarchar(max)
	DECLARE @Lots varchar(2000)
	DECLARE @DPs varchar(2000)

	DECLARE @PropertyBoundary geometry
	DECLARE @RemovedLandParcel geometry

	DECLARE @IndexName varchar(255)

	DECLARE @cnt int
	
	DECLARE @RowNumber int
	DECLARE @MaxID int

	BEGIN TRY
		/* get the Lot/DP combination as passed by the UI */
		INSERT INTO @tblLotDP (
				Lot,
				DP,
				SectionNumber)
		SELECT	@Lot,
				@DP, 
				@SectionNumber

		/* prepare comma-delimited Lots and DPs to be passed to the spatial database for querying */
		-- get comma-delimited Lots
		SELECT	@Lots = SUBSTRING((	SELECT	',''''' + Lot + ''''''
									FROM	@tblLotDP
									ORDER BY Lot
									FOR XML PATH('')),2,200000)


		-- get comma-delimited DPs
		SELECT	@DPs = SUBSTRING((	SELECT	',' + cast(DP as varchar(20))
									FROM	@tblLotDP
									ORDER BY DP
									FOR XML PATH('')),2,200000)

		/* check the existance of Lot/DPs */
		-- get the attribute index name for Lot layer
		SELECT	@IndexName = ISNULL(AttributeIndexName, '')
		FROM	tblSpatialLayer
		WHERE	LayerName = 'LOT'

		-- 1. prepare the query to get the number of invalid Lot/DP combination (i.e. the Lot/DP does not exist in the cadaster)...
		if @Plan_Type = 'SP' 
			begin
				SET @sql = 'SELECT @cnt = COUNT(1) '
				SET @sql = @sql + 'FROM OPENQUERY(GIS, ''SELECT PlanNumber FROM cadastre.sde.lot ' + IIF(@IndexName = '', '', 'with (index(' + @IndexName + ')) ')
				SET @sql = @sql + 'WHERE ClassSubtype = 3 AND PlanNumber IN (' + @DPs + ') '') cad '
				SET @sql = @sql + 'RIGHT JOIN @var tmp ON tmp.DP = cad.PlanNumber '
				SET @sql = @sql + 'WHERE cad.PlanNumber IS NULL '
			end
		else
			begin
				SET @sql = 'SELECT @cnt = COUNT(1) '
				SET @sql = @sql + 'FROM OPENQUERY(GIS, ''SELECT LotNumber, PlanNumber FROM cadastre.sde.lot ' + IIF(@IndexName = '', '', 'with (index(' + @IndexName + ')) ')
				SET @sql = @sql + 'WHERE LotNumber IN (' + @Lots + ') AND PlanNumber IN (' + @DPs + ') '') cad '
				SET @sql = @sql + 'RIGHT JOIN @var tmp ON tmp.Lot = cad.LotNumber AND tmp.DP = cad.PlanNumber '
				SET @sql = @sql + 'WHERE cad.LotNumber IS NULL '
			end
		-- 2. execute the query to get the count
		SET @cnt = 0
		EXEC sp_executesql @sql, N'@var tblSpatialIntersectLotDP readonly, @cnt int output', @tblLotDP, @cnt output
		
		-- 3. throw error, if there are any invalid Lot/DPs...
		IF @cnt > 0
		BEGIN
			--RAISERROR ('Specified Lot/DP does not exist in the database. Please verify the Lot/DPs.', 16, 1)
			return;
		END
		
		/* check if any other property intersects with the current property's boundary */
		-- 1. get the number of properties that intersects with the current property
		SET @cnt = 0

		--update tblproperty set PropertyBoundary = @PropertyBoundary where propertyid = @PropertyID

		/* intersect with other required spatial layers */

		-- get intersects
		SET @RowNumber = 1
		SELECT @MaxID = MAX(SpatialLayerID) FROM tblSpatialLayer

		

		-- 1. loop through the layers as specified in the spatial layers
		WHILE(@RowNumber <= @MaxID)
		BEGIN
			SET @sql = ''
			DELETE @tblSpatialLayer

			-- 1.1 get the current layer (apart from the LOT layer)
			INSERT INTO @tblSpatialLayer (
					SpatialLayerID,
					LayerName,
					GISSource,
					FeatureColumn,
					SpatialIndexName,
					AttributeIndexName)
			SELECT	SpatialLayerID,
					LayerName,
					GISSource,
					FeatureColumn,
					SpatialIndexName,
					AttributeIndexName
			FROM	tblSpatialLayer
			WHERE	SpatialLayerID = @RowNumber
			AND		LayerName <> 'LOT'

			IF ((SELECT COUNT(*) FROM @tblSpatialLayer) > 0)
			BEGIN
				-- 1.2 prepare sql to intersect with the spatial layer
				SELECT	@sql = 'SELECT ' + CAST(tmp.SpatialLayerID as varchar) + ' LayerID, ''''' + tmp.LayerName + ''''' LayerName, ObjectID, ' + tmp.FeatureColumn + ' FeatureName FROM ' + tmp.GISSource + ' layer ' + IIF(ISNULL(tmp.SpatialIndexName, '') = '', '', 'with (index(' + tmp.SpatialIndexName + ')) ')
				FROM	@tblSpatialLayer tmp
				WHERE	SpatialLayerID = @RowNumber

				SET @sql = 'SELECT * FROM OPENQUERY(GIS, ''' + @sql
				if @Plan_Type = 'SP' 
					begin
						SET	@sql = @sql + 'JOIN (SELECT Geometry::UnionAggregate(lot.Shape) LandParcel FROM Cadastre.SDE.LOT lot where ClassSubtype = 3 AND PlanNumber IN (' + @DPs + ')) lot ON layer.Shape.STIntersects(lot.LandParcel) = 1'') '
					end
				else
					begin
						SET	@sql = @sql + 'JOIN (SELECT Geometry::UnionAggregate(lot.Shape) LandParcel FROM Cadastre.SDE.LOT lot where LotNumber IN (' + @Lots + ') AND PlanNumber IN (' + @DPs + ')) lot ON layer.Shape.STIntersects(lot.LandParcel) = 1'') '
					end
				-- 1.3 execute the sql and insert the interesects found...
				INSERT INTO tblReturnIntersectsTmp (
						LayerID,
						LayerName,
						ObjectID,
						FeatureName)
				EXEC(@sql)
			END

			-- 2. next spatial layer
			SET @RowNumber = @RowNumber + 1
		END

		print '@MaxID=' + cast(@MaxID as varchar)

		--SELECT * FROM @tblReturnIntersects
	END TRY
	BEGIN CATCH
        SET @ErrorMessage = dbo.ufn_GetErrorText()
        RAISERROR (@ErrorMessage , 16, 1)
	END CATCH


	 