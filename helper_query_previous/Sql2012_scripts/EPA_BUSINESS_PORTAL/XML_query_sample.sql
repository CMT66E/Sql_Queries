USE [PALMSDB]
GO

DECLARE       @return_value xml
DECLARE       @address xml
select @return_value = LicenceXML.query('/POEOLicence/AppplicationPoint/NoisePoints')  from [tblOnlinePOEOApplication] where onlineapplicationcodeid = 1

select @return_value

DECLARE @RbarTable TABLE (id int, PointType int, Add1 VARCHAR(50), Add2 VARCHAR(50), Easting VARCHAR(50),  Northing VARCHAR(50));

DECLARE @IsLotDPPortal BIT
DECLARE @SpatialInfoAvailablePortal BIT

--INSERT INTO @RbarTable (id, PointType, Add1, Add2, Easting, Northing)
select T1.*
from
(
SELECT ROW_NUMBER() OVER (ORDER BY m.c.value('(NoisePointTypeId)[1]','int')) AS id,
			  m.c.value('(NoisePointTypeId)[1]','int') as PointType,
              m.c.value('(NoiseLocation/Address/Address/text())[1]','nvarchar(max)') as Add1,
              m.c.value('(NoiseLocation/Address/Suburb/text())[1]','nvarchar(max)') as Add2,
              m.c.value('(NoiseLocation/SpatialEasting/Easting/text())[1]','nvarchar(max)') as Easting,
              m.c.value('(NoiseLocation/SpatialEasting/Northing/text())[1]','nvarchar(max)') as Northing,

			  m.c.value('(NoiseLocation/LotDPs/LocationSpatialLotDP/LBLCatchment/text())[1]','nvarchar(max)') as LBLCatchment,
			  m.c.value('(NoiseLocation/LotDPs/LocationSpatialLotDP/Electorate/text())[1]','nvarchar(max)') as Electorate,
			  m.c.value('(NoiseLocation/SpatialInfoAvailable/text())[1]','bit') as SpatialInfoAvailablePortal,
			  m.c.value('(NoiseLocation/IsLotDP/text())[1]','bit') as IsLotDP
FROM @return_value.nodes('NoisePoints/POEOLicenceNoisePoint') as m(c)
) T1
WHERE id = 1

select @SpatialInfoAvailablePortal = SpatialInfoAvailablePortal, @IsLotDPPortal = IsLotDP
from
(
SELECT ROW_NUMBER() OVER (ORDER BY m.c.value('(NoisePointTypeId)[1]','int')) AS id,
			  m.c.value('(NoisePointTypeId)[1]','int') as PointType,
              m.c.value('(NoiseLocation/Address/Address/text())[1]','nvarchar(max)') as Add1,
              m.c.value('(NoiseLocation/Address/Suburb/text())[1]','nvarchar(max)') as Add2,
              m.c.value('(NoiseLocation/SpatialEasting/Easting/text())[1]','nvarchar(max)') as Easting,
              m.c.value('(NoiseLocation/SpatialEasting/Northing/text())[1]','nvarchar(max)') as Northing,

			  m.c.value('(NoiseLocation/LotDPs/LocationSpatialLotDP/LBLCatchment/text())[1]','nvarchar(max)') as LBLCatchment,
			  m.c.value('(NoiseLocation/LotDPs/LocationSpatialLotDP/Electorate/text())[1]','nvarchar(max)') as Electorate,
			  m.c.value('(NoiseLocation/SpatialInfoAvailable/text())[1]','bit') as SpatialInfoAvailablePortal,
			  m.c.value('(NoiseLocation/IsLotDP/text())[1]','bit') as IsLotDP
FROM @return_value.nodes('NoisePoints/POEOLicenceNoisePoint') as m(c)
) T1
WHERE id = 1

							select 
										LandTitleID
										,LocationID
										,IdentifiedByLotDPFlag
										,SpatialInfoAvailable
										,LotNumber
										,DPNumber
										,SectionNumber
										,Easting
										,Northing
										,ZoneNumber
										,CreatedBySystemUserID
										,PartLotFlag
										,LGA
										,LBLCatchment
										,Electorate 
										,PointLongitude
										,PointLatitude									 
							 from (
										SELECT  
										ROW_NUMBER() OVER (ORDER BY RN.S.value('Lot[1]','varchar(20)')) AS rn, 				
										-1 AS LandTitleID,
										-1 AS LocationID,
										@IsLotDPPortal AS IdentifiedByLotDPFlag,
 										@SpatialInfoAvailablePortal AS SpatialInfoAvailable,
										RN.S.value('Lot[1]', 'varchar(20)') AS LotNumber,
										RN.S.value('DP[1]', 'bigint') AS DPNumber,
										RN.S.value('SectionNumber[1]', 'varchar(20)') AS SectionNumber,
										RN.S.value('Easting[1]', 'int') AS Easting,
										RN.S.value('Northing [1]','int') AS Northing,
										RN.S.value('Zone[1]', 'int') AS ZoneNumber,
										1 AS CreatedBySystemUserID,
										0 as PartLotFlag,
										RN.S.value('LGA[1]', 'varchar(200)') AS LGA,
										RN.S.value('LBLCatchment[1]', 'varchar(200)') AS LBLCatchment,
										RN.S.value('Electorate[1]', 'varchar(200)') AS Electorate,
										RN.S.value('Longitude[1]', 'decimal(18, 8)') AS PointLongitude,
										RN.S.value('Latitude [1]','decimal(18, 8)') AS PointLatitude
										FROM @return_value.nodes('NoisePoints/POEOLicenceNoisePoint/NoiseLocation/LotDPs/LocationSpatialLotDP') AS RN(S)
							) T1
							WHERE rn = 1	


--SELECT * from @RbarTable



GO
