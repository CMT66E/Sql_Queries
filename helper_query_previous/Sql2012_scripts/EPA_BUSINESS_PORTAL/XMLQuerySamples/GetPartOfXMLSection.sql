DECLARE @InstrumentNumber INT
DECLARE @POEOApplicationid INT
set @POEOApplicationid = 1056
DECLARE	 @theXmlData xml
select @theXmlData = LicenceXML from tblOnlinePOEOApplication where OnlinePOEOApplicationID = @POEOApplicationid

DECLARE @return_value xml  
select @return_value = LicenceXML
FROM tblOnlinePOEOApplication 
WHERE OnlinePOEOApplicationID = @POEOApplicationid
print  '@return_value A =' + cast(@return_value as varchar(max))

--The following line can be used to fetch part of XML section strings 
select @return_value = @return_value.query('/POEOLicence/AppplicationPoint/NoisePoints')
print  '@return_value B =' + cast(@return_value as varchar(max))

			select  
				RN.S.value('(NoiseLocation/SpatialInfoAvailable/text())[1]','BIT'),
				RN.S.value('(NoiseLocation/IsLotDP/text())[1]','BIT')	       
			FROM @return_value.nodes('NoisePoints/POEOLicenceNoisePoint') AS RN(S) 
			where RN.S.value('(Id/text())[1]','int') = 2

select 
			rn
			,LandTitleID
			,LocationID
			,IdentifiedByLotDPFlag
			,SpatialInfoAvailable
			,PartLotFlag
			,CreatedBySystemUserID
			,LGA
			,LBLCatchment
			,Electorate
	from (				
		SELECT 
			ROW_NUMBER() OVER (ORDER BY RN.S.value('(NoisePoints/POEOLicenceNoisePoint/id/text())[1]','varchar(20)')) AS rn, 	
			-1 AS LandTitleID,
			-1 AS LocationID,
				0 AS IdentifiedByLotDPFlag,
 				0 AS SpatialInfoAvailable,
				0 AS PartLotFlag,
				1 AS CreatedBySystemUserID,								 
			RN.S.value('LGA[1]', 'varchar(200)') AS LGA,
			RN.S.value('LBLCatchment[1]', 'varchar(200)') AS LBLCatchment,
			RN.S.value('Electorate[1]', 'varchar(200)') AS Electorate
									 
		FROM @return_value.nodes('NoisePoints/POEOLicenceNoisePoint/NoiseLocation/spatialLayers') AS RN(S)
		where RN.S.value('(Id/text())[1]','int') = 2
) T1


--start looping
DECLARE @MyTable TABLE
(
SNo int IDENTITY(1,1), 	 
ROW_ID int
)    
INSERT INTO @MyTable(ROW_ID)	    
SELECT RN.S.value('(Id/text())[1]','int') as ROW_ID
--ROW_NUMBER() OVER (ORDER BY RN.S.value('id[1]','int'))
FROM @return_value.nodes('NoisePoints/POEOLicenceNoisePoint') as RN(S)
select * from @MyTable

 

--get noise point type ID
select  RN.S.value('(NoisePointTypeId/text())[1]','int')  as NoisePointTypeId										 
FROM @return_value.nodes('NoisePoints/POEOLicenceNoisePoint') AS RN(S) 
where RN.S.value('(Id/text())[1]','int') = 2

--get IsLotDP and IsSpatialInfoAvailable
select  
RN.S.value('(NoiseLocation/SpatialInfoAvailable/text())[1]','BIT') as SpatialInfoAvailable,
RN.S.value('(NoiseLocation/IsLotDP/text())[1]','BIT') as IsLotDP	       
FROM @return_value.nodes('NoisePoints/POEOLicenceNoisePoint') AS RN(S) 
where RN.S.value('(Id/text())[1]','int') = 2

--get location information 
SELECT  
	-1 AS LocationID,				 
	RN.S.value('(NoiseLocation/Description/text())[1]','varchar(128)') AS LocationName,
	-88 AS AddressID,
	0 AS PremisesFlag,
	'Please fix this' AS AdditionalAddressInformation,		 
	1 AS CreatedBySystemUserID,
	-1 AS InstrumentID			 
FROM @return_value.nodes('NoisePoints/POEOLicenceNoisePoint') AS RN(S)
where RN.S.value('(Id/text())[1]','int') = 2

--additional information fetch process
select  RN.S.value('(NoiseLocation/Address/AdditionalInfo/text())[1]','varchar(1000)') as AdditionalInfo,
        RN.S.value('(NoiseLocation/Address/Id/text())[1]','int') as AddressId	         
FROM @return_value.nodes('NoisePoints/POEOLicenceNoisePoint') AS RN(S) 
where RN.S.value('(NoiseLocation/Address/Id/text())[1]','int') = 2

--address information fetch
SELECT ROW_NUMBER() OVER (ORDER BY RN.S.value('(NoisePoints/POEOLicenceNoisePoint/id/text())[1]','varchar(100)')) AS rn, 
			-1 AS AddressID,
			RN.S.value('(NoiseLocation/Address/Address/text())[1]','varchar(100)') AS Address,
			RN.S.value('(NoiseLocation/Address/Suburb/text())[1]','varchar(100)') AS Suburb,
			RN.S.value('(NoiseLocation/Address/Postcode/text())[1]','char(10)') AS Postcode,
			RN.S.value('(NoiseLocation/Address/State/text())[1]','char(20)') AS StateCode,
			1 AS CreatedBySystemUserID,
			0 AS OverseasAddressFlag 
FROM @return_value.nodes('NoisePoints/POEOLicenceNoisePoint') AS RN(S)
where RN.S.value('(Id/text())[1]','int') = 2

SELECT RN.S.value('(Id/text())[1]','int') as ROW_ID
FROM @return_value.nodes('NoisePoints/POEOLicenceNoisePoint') as RN(S)
where RN.S.value('(Id/text())[1]','int') = 2

DECLARE @NoisePoint_XML xml
select @NoisePoint_XML = @return_value.query('NoisePoints/POEOLicenceNoisePoint/NoiseLocation/LotDPs/LocationSpatialLotDP') FROM @return_value.nodes('NoisePoints/POEOLicenceNoisePoint') as RN(S)
where RN.S.value('(Id/text())[1]','int') = 2

print '@NoisePoint_XML=' + cast(@NoisePoint_XML as varchar(max))

DECLARE @tblLandTitleDetail tblLandTitleDetailType

--INSERT INTO @tblLandTitleDetail( 
-- LandTitleID
--,LocationID
--,IdentifiedByLotDPFlag
--,SpatialInfoAvailable
--,LotNumber
--,DPNumber
--,SectionNumber
--,Easting
--,Northing
--,ZoneNumber
--,CreatedBySystemUserID
--,PartLotFlag
--,LGA
--,LBLCatchment
--,Electorate
--,PointLongitude
--,PointLatitude
--)	

select 
* 
from
(			
SELECT 
ROW_NUMBER() OVER (ORDER BY RN.S.value('(id/text())[1]','varchar(20)')) as RC,
-1 AS LandTitleID,
-1 AS LocationID,
0 AS IdentifiedByLotDPFlag,
0 AS SpatialInfoAvailable,
RN.S.value('Lot[1]', 'varchar(20)') AS LotNumber,
RN.S.value('DP[1]', 'bigint') AS DPNumber,
RN.S.value('SectionNumber[1]', 'varchar(20)') AS SectionNumber,
RN.S.value('Easting[1]', 'int') AS Easting,
RN.S.value('Northing [1]','int') AS Northing,
RN.S.value('ZoneNumber[1]', 'int') AS ZoneNumber,
1 AS CreatedBySystemUserID,
0 as PartLotFlag,
RN.S.value('LGA[1]', 'varchar(200)') AS LGA,
RN.S.value('LBLCatchment[1]', 'varchar(200)') AS LBLCatchment,
RN.S.value('Electorate[1]', 'varchar(200)') AS Electorate,
RN.S.value('Longitude[1]', 'decimal(18, 8)') AS PointLongitude,
RN.S.value('Latitude[1]','decimal(18, 8)') AS PointLatitude
FROM @NoisePoint_XML.nodes('LocationSpatialLotDP') AS RN(S)
where RN.S.value('(Id/text())[1]','int') = 2 )  T1
where RC = 1

--INSERT INTO @tblLandTitleDetail(LandTitleID
--,LocationID
--,IdentifiedByLotDPFlag
--,SpatialInfoAvailable
--,LotNumber
--,DPNumber
--,SectionNumber
--,Easting
--,Northing
--,ZoneNumber
--,CreatedBySystemUserID
--,PartLotFlag
--,LGA
--,LBLCatchment
--,Electorate
--)
				
--SELECT -1 AS LandTitleID,
---1 AS LocationID,
--0 AS IdentifiedByLotDPFlag,
--0 AS PartLotFlag,
--RN.S.value('Lot[1]', 'varchar(20)') AS LotNumber,
--RN.S.value('DP[1]', 'bigint') AS DPNumber,
--RN.S.value('SectionNumber[1]', 'varchar(20)') AS SectionNumber,
--RN.S.value('Easting[1]', 'int') AS Easting,
--RN.S.value('Northing [1]','int') AS Northing,
--RN.S.value('ZoneNumber[1]', 'int') AS ZoneNumber,
--1 AS CreatedBySystemUserID,
--0,
--RN.S.value('LGA[1]', 'varchar(200)') AS LGA,
--RN.S.value('LBLCatchment[1]', 'varchar(200)') AS LBLCatchment,
--RN.S.value('Electorate[1]', 'varchar(200)') AS Electorate
--FROM @return_value.nodes('NoisePoints/POEOLicenceNoisePoint/NoiseLocation/SpatialEasting') AS RN(S)
--where RN.S.value('(Id/text())[1]','int') = 2

select * from @tblLandTitleDetail


exec  [dbo].[uspSubmitPOEOApplication] 1, 0
 
