select SiteBoundary, * from tblSite
WHERE 
not SiteBoundary is null
and 
id = 27096

SELECT sp.* FROM tblSitePoint sp where sp.Site_Id = 3108

SELECT TOP 1000 [Site_Id]
      ,[SitePointGeometry]
  FROM [EPACSDB].[dbo].[tblSitePoint]
  WHERE [Site_Id] = 3108

select * from tblSiteLot where Site_Id = 3108

select count(Lot_Id), Site_Id from tblSiteLot
where Site_Id in (select Id from tblSite)
group by Site_Id
having count(Lot_Id) > 2
------------------------------------------------------------------------------------------------------------

select * from tblLot where Id in (select Lot_Id from tblSiteLot where Site_Id = 3108)

------------------------------------------------------------------------------------------------------------
declare @SiteId int = 330
declare @ObjectIDList varchar(max) = ''
select @ObjectIDList = @ObjectIDList + COALESCE( cast(ObjectID as varchar(max)) + ', ' ,'')  from tblLot where Id in (select Lot_Id from tblSiteLot where Site_Id = @SiteId)

if len(@ObjectIDList) > 0
      select @ObjectIDList = substring(@ObjectIDList, 0, len(@ObjectIDList))

print '@ObjectIDList = ' + @ObjectIDList

if len(@ObjectIDList) > 0 
begin
		DECLARE @OBJECTIDs VARCHAR(MAX)
		DECLARE @SQL NVARCHAR(2000);
		DECLARE @geom GEOMETRY;
		SET @OBJECTIDS = @ObjectIDList;

		SET @SQL = 'SELECT @geom = geometry::UnionAggregate([Shape]) 
  		  FROM OPENQUERY(GIS, ''SELECT [Shape] From [Cadastre].[sde].[LOT] where objectid in (' + @OBJECTIDS + ')'')'
 
		PRINT @SQL
		EXEC sp_executesql

		@statement = @sql,
		@params = N'@geom geometry OUTPUT',   

		@geom = @geom OUTPUT


		SELECT @geom
		 
		if @geom.STIsEmpty() = 0  --check if @geom has value on it before update the data
		begin
		  --we update table tblSite column SiteBoundary
		  update tblSite set SiteBoundary = @geom where Id = @SiteId
		end 
end
------------------------------------------------------------------------------------------------
--declare @ObjectID int = 0
--EXEC [dbo].[uspSpatialGetObjectIDLotDP] '1', 795095, null, 'DP', @ObjectID out
--print '@ObjectID = ' + cast(@ObjectID as varchar)

--COALESCE(@VehicleClass+', ' ,'')
------------------------------------------------------------------------------------------------


--GRANT EXECUTE ON [dbo].uspUpdateSiteBoundaryBySiteId TO ReadWriteRole