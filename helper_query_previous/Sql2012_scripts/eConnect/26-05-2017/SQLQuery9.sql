DECLARE @OBJECTIDs VARCHAR(MAX)
DECLARE @SQL NVARCHAR(2000);
DECLARE @geom GEOMETRY;
SET @OBJECTIDS = '287,1043,4212';

SET @SQL = 'SELECT @geom = geometry::UnionAggregate([Shape]) 
  FROM OPENQUERY(GIS, ''SELECT [Shape] From [Cadastre].[sde].[LOT] where objectid in (' + @OBJECTIDS + ')'')'
  PRINT @SQL
  EXEC sp_executesql
@statement = @sql,
@params = N'@geom geometry OUTPUT', 
@geom = @geom OUTPUT
SELECT @geom