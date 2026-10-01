SELECT   
OWTTC.OWTTCID,     
OWTTC.PickUpActualDate, 
OWTTC.ConsignorReportingStateCode, 
Classification.Code as StatusCode, 
OWTTC.TCNumber, 
'' as WasteCode,
null as ArrivalWasteAmount,
'' as WeightCode,
OWTWasteDescriptionUnit.UnitConversionFactor, 
'' as ArrivalDate,
'' as WasteGroup,
Classification_1.Code AS ConsignorCode, 
Classification_2.Code AS ReceivingFacilityCode,
'' as TransporterCode,
'' as ReceivingFacilityCode,
null as SearchStartDate,
null as SearchEndDate,
'' as WeightUnit,
OWTCA.CANumber, 
OWTTCAssociatedEntity_1.SiteName, 
OWTTC.PickUpWasteAmount, 
'' as ExceptionCategoryType,
OWTTCAssociatedEntity.SiteName AS SiteNameB, 
'' as note,
OWTTCAssociatedEntity_1.AddressText, 
OWTTCAssociatedEntity_1.Suburb, 
OWTTCAssociatedEntity_1.ContactName, 
OWTTCAssociatedEntity_1.PhoneNumber, 
'' as SitePostcode,
'' as SiteStateCode,
OWTTCAssociatedEntity.Suburb AS AddSuburb, 
OWTTCAssociatedEntity.StateCode as AddStateCode,
OWTTCAssociatedEntity.Postcode as AddPostcode,
OWTTCAssociatedEntity.AddressText AS AddAddress
FROM    
		OWTTCAssociatedEntity AS OWTTCAssociatedEntity_1 INNER JOIN
		Classification AS Classification_1 INNER JOIN
		OWTTCAssociatedEntity AS OWTTCAssociatedEntity ON Classification_1.ClassificationID = OWTTCAssociatedEntity.AssociatedRoleTypeID 
		INNER JOIN
		OWTTC AS OWTTC ON OWTTCAssociatedEntity.OWTTCID = OWTTC.OWTTCID ON OWTTCAssociatedEntity_1.OWTTCID = OWTTC.OWTTCID INNER JOIN
		Classification AS Classification_2 ON OWTTCAssociatedEntity_1.AssociatedRoleTypeID = Classification_2.ClassificationID INNER JOIN
		Classification AS Classification ON OWTTC.TCStatusTypeID = Classification.ClassificationID INNER JOIN
		OWTCA AS OWTCA ON OWTTC.OWTCAID = OWTCA.OWTCAID LEFT OUTER JOIN
		OWTWasteDescriptionUnit AS OWTWasteDescriptionUnit ON OWTTC.OWTWasteDescriptionID = OWTWasteDescriptionUnit.OWTWasteDescriptionID AND 
		OWTTC.PickupWasteAmountWeightUnitTypeID = OWTWasteDescriptionUnit.WeightUnitTypeID
WHERE        

(Classification_1.Code = 'Consignor') 
AND (NOT (OWTTC.ConsignorReportingStateCode = 'n/a' OR OWTTC.ConsignorReportingStateCode = 'NSW')) 
AND (Classification.Code = 'Pickedup') 
AND (OWTTC.PickUpActualDate >= CONVERT(DATETIME, '2014-07-01 00:00:00', 102)) 
AND (OWTTC.PickUpActualDate < CONVERT(DATETIME, '2015-07-01 00:00:01', 102)) 
AND (Classification_2.Code = 'ReceivingFacility')

ORDER BY OWTTCAssociatedEntity_1.SiteName, OWTTCAssociatedEntity.SiteName, OWTCA.CANumber


