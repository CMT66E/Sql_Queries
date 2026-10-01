DECLARE @OBJECTIDs VARCHAR(MAX)
DECLARE @SQL NVARCHAR(2000);
DECLARE @geom GEOMETRY;
SET @OBJECTIDS = '287,1043,4212';

SET @SQL = 'SELECT @geom = geometry::UnionAggregate([Shape]) 
  FROM OPENDATASOURCE(''SQLOLEDB'', ''DRIVER={SQL Server};SERVER=GOULBDB32;initial catalog=EPACSDB;user id=epacsdb_rw;password=rw2epacsdB'').[Cadastre].[sde].[LOT] where objectid in (' + @OBJECTIDS +')'
  PRINT @SQL
  EXEC sp_executesql
@statement = @sql,
@params = N'@geom geometry OUTPUT', 
@geom = @geom OUTPUT
SELECT @geom
