 
-- upsPALMSCustomerCreate
-- upsPALMSSiteCreate
-- upsPALMSAccountOperationCreateUpdate
 
 
---------------  NEW PREMISES LIENCE -----------------------------
SELECT A.InstrumentID 
FROM tblPOEOLicence A INNER JOIN tblInstrument B 
	ON A.InstrumentID = B.InstrumentID
WHERE B.InstrumentStatusID  = 3 and A.ProcessedForOWT = 0   
	AND
EXISTS 
    (SELECT * FROM tblPOEOLicenceFeeBasedActivity C
	INNER JOIN tblFeeBasedActivity D ON C.FeeBasedActivityID = D.FeeBasedActivityID
	WHERE C.InstrumentID = A.InstrumentID 					
	AND D.PremisesFlag =1 )         ---------------- 5-Draft, 3-Issued



--------------- NEW WASTE TRANSPORTER LIENCE -----------------------------
SELECT A.InstrumentID FROM tblPOEOLicence A INNER JOIN tblInstrument B 
	ON A.InstrumentID = B.InstrumentID
WHERE B.InstrumentStatusID  = 3 and A.ProcessedForOWT = 0   
	AND
EXISTS 	
	(SELECT * FROM tblPOEOLicenceFeeBasedActivity C
	INNER JOIN tblFeeBasedActivity D ON C.FeeBasedActivityID = D.FeeBasedActivityID
	WHERE C.InstrumentID = A.InstrumentID 					
	AND D.GenerateARFlag =0 )         ---------------- 5-Draft, 3-Issued

 
----------------------- PREMISE LICENCE VARIATION -------------------------

select c.InstrumentID
from tblnotice a inner join tblInstrument b
	on a.InstrumentID = b.InstrumentID inner join tblInstrumentNotice c
	on a.InstrumentID = c.NoticeInstrumentID
where a.NoticeTemplateID = 389 and b.InstrumentStatusID = 11 and a.ProcessedForOWT = 0 
 AND
	EXISTS (SELECT * FROM tblPOEOLicenceFeeBasedActivity E
	INNER JOIN tblFeeBasedActivity D ON E.FeeBasedActivityID = D.FeeBasedActivityID
	WHERE E.InstrumentID = C.InstrumentID 					
	AND D.PremisesFlag =1 )  


----------------------- TRANSPORTER LICENCE VARIATION -------------------------

select c.InstrumentID
from tblnotice a inner join tblInstrument b
	on a.InstrumentID = b.InstrumentID inner join tblInstrumentNotice c
	on a.InstrumentID = c.NoticeInstrumentID
where a.NoticeTemplateID = 389 and b.InstrumentStatusID = 11 and a.ProcessedForOWT = 0 
 AND
	EXISTS (SELECT * FROM tblPOEOLicenceFeeBasedActivity E
	INNER JOIN tblFeeBasedActivity D ON E.FeeBasedActivityID = D.FeeBasedActivityID
	WHERE E.InstrumentID = C.InstrumentID				
	AND D.GenerateARFlag =0)  

	--------------------------------------
	--------------------------------------
 
----------------------- PREMISE LICENCE VARIATION -----------------------------------------
select c.InstrumentID, b.ResponsibleSystemUserID
from tblnotice a inner join tblInstrument b
	on a.InstrumentID = b.InstrumentID inner join tblInstrumentNotice c
	on a.InstrumentID = c.NoticeInstrumentID
where a.NoticeTemplateID = 389 and b.InstrumentStatusID = 11 and a.ProcessedForOWT = 0 
 AND
	EXISTS (SELECT * FROM tblPOEOLicenceFeeBasedActivity E
	INNER JOIN tblFeeBasedActivity D ON E.FeeBasedActivityID = D.FeeBasedActivityID
	WHERE E.InstrumentID = C.InstrumentID 					
	AND D.PremisesFlag =1 )  


----------------------- TRANSPORTER LICENCE VARIATION -------------------------------------
select c.InstrumentID, b.ResponsibleSystemUserID
from tblnotice a inner join tblInstrument b
	on a.InstrumentID = b.InstrumentID inner join tblInstrumentNotice c
	on a.InstrumentID = c.NoticeInstrumentID
where a.NoticeTemplateID = 389 and b.InstrumentStatusID = 11 and a.ProcessedForOWT = 0 
 AND
	EXISTS (SELECT * FROM tblPOEOLicenceFeeBasedActivity E
	INNER JOIN tblFeeBasedActivity D ON E.FeeBasedActivityID = D.FeeBasedActivityID
	WHERE E.InstrumentID = C.InstrumentID				
	AND D.GenerateARFlag =0)  

--------------------------------------------------------------------------------------------
select InstrumentID, WasteCode from [WDS].[dbo].[vwPALMSPOEOLicenceWaste] 
select * from [WDS].[dbo].[tblPALMSandOWT_WasteCodeMapping] 
--------------------------------------------------------------------------------------------

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [WasteTypeID]
      ,[WasteCode]
      ,[WasteType]
      ,[EffectiveDateFrom]
      ,[EffectiveDateTo]
      ,[DateCreated]
      ,[CreatedBySystemUserID]
      ,[DateUpdated]
      ,[UpdatedBySystemUserID]
      ,[RowTimestamp]
      ,[TrackableWasteFlag]
  FROM [PALMSDB].[dbo].[tblWasteType]


select * from [WDS].[dbo].OWTWasteCode
select * from [WDS].[dbo].tblPALMSandOWT_WasteCodeMapping


GRANT EXECUTE ON [dbo].[uspPALMSandOWTGeneralIngetrationProcess] TO ReadWriteRole
GRANT EXECUTE ON [dbo].[uspOWTVariationTransporterLicencesForBatchProcess] TO ReadWriteRole

GRANT EXECUTE ON [dbo].[uspPALMSandOWTGeneralIngetrationProcess] TO OWTReadWriteRole



