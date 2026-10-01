-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Eric He
-- Create date: 31-05-2017
-- Description:	we grab all objectID list from tblLot based on SiteId then call geometry::UnionAggregate to get its geometry data 
-- then save it into table tblSite column SiteBoundary for map boundary display purpose
-- =============================================
ALTER PROCEDURE uspUpdateSiteBoundaryBySiteId
	-- Add the parameters for the stored procedure here
@SiteId int 

AS
BEGIN
		declare @ObjectIDList varchar(max) = ''
		select @ObjectIDList = @ObjectIDList + COALESCE( cast(ObjectID as varchar(max)) + ', ' ,'')  from tblLot where Id in (select Lot_Id from tblSiteLot where Site_Id = @SiteId)

		if len(@ObjectIDList) > 0
			  select @ObjectIDList = substring(@ObjectIDList, 0, len(@ObjectIDList))
 
		if len(@ObjectIDList) > 0 
		begin
				DECLARE @OBJECTIDs VARCHAR(MAX)
				DECLARE @SQL NVARCHAR(2000);
				DECLARE @geom GEOMETRY;
				SET @OBJECTIDS = @ObjectIDList;

				SET @SQL = 'SELECT @geom = geometry::UnionAggregate([Shape]) 
  				  FROM OPENQUERY(GIS, ''SELECT [Shape] From [Cadastre].[sde].[LOT] where objectid in (' + @OBJECTIDS + ')'')'
 
				--PRINT @SQL
				EXEC sp_executesql

				@statement = @sql,
				@params = N'@geom geometry OUTPUT',   

				@geom = @geom OUTPUT
 
				if @geom.STIsEmpty() = 0  --check if @geom has value on it before update the data
				begin
				  --we update table tblSite column SiteBoundary
				  update tblSite set SiteBoundary = @geom where Id = @SiteId
				end 
		end
END
GO





