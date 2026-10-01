DECLARE @Search varchar(255)
SET @Search='''ABD'''

--    SELECT DISTINCT
--    o.name AS Object_Name,o.type_desc
--    FROM sys.sql_modules        m 
--        INNER JOIN sys.objects  o ON m.object_id=o.object_id
--    WHERE m.definition Like '%'+@Search+'%'
--    ORDER BY 2,1
    
SELECT Name
FROM sys.procedures
WHERE OBJECT_DEFINITION(OBJECT_ID) Like '%'+@Search+'%'
AND OBJECT_DEFINITION(OBJECT_ID) Like '%'+@Search+'%'


--select * from sys.objects where type = 'p' order by modify_date desc


--GRANT EXECUTE ON [dbo].[uspRadiationMLeConnectSubmitDocDataGet] TO ReadWriteRole
--GRANT EXECUTE ON [dbo].[uspReference_admin_radiation_manufacturer_delete] TO ReadWriteRole
--GRANT EXECUTE ON [dbo].[uspRadiationDGLicneceTypeIdGet] TO ReadWriteRole

--for readonly role here-----------------------------------------------------------
--GRANT EXECUTE ON dbo.[uspPRTransporterAllSearch] TO ReadOnlyRole
-----------------------------------------------------------------------------------

--GRANT EXECUTE ON [dbo].[uspPALMSWasteCodeDetailsByAccountOperationID] TO OWTReadWriteRole
--GRANT EXECUTE ON [dbo].[uspPALMSSearchConsignmentApproval] TO OWTReadWriteRole
-----------------------------------------------------------------------------------
--OWTReadOnlyRole
--GRANT EXECUTE ON [dbo].[uspPALMSWasteCodeFetch] TO OWTReadOnlyRole
-----------------------------------------------------------------------------------
--PALMS ONLINE: 2017
--GRANT EXECUTE ON [dbo].[uspOnlineGetRMLRenewalSimple] TO ReadWriteOnlineRole
-----------------------------------------------------------------------------------

  --select * from tblAddress
  --where  AddressID in (134910, 134911, 134912, 134913, 134914, 134915)
  --select TransporterLocationID - 4175 as TEMP,  * from tblTransporterLocation
  --WHERE TransporterLocationID - 4175 > 0

  --select * from OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=OWT_RW;PWD=rw2owT').[WDS].[dbo].[Site] 
  --WHERE PALMSLocationID is not null
  --order by PALMSLocationID 

  --FOR PALMS DATABASE
   --GRANT EXECUTE ON [dbo].[uspRadiationMLeConnectSubmitDocDataGet] TO ReadWriteRole

   --\\goulbwb32\wwwroot\PALMSapp
   --\\goulbap36\Inetpub\wwwroot\Palmsmt
    