insert into tblClassification(ClassificationID, ClassificationDomainID, Code, Name, Description, SequenceOrder, ClassFilter, EffectiveDateFrom, EffectiveDateTo, DateCreated, 
        CreatedBySystemUserID, DateUpdated, UpdatedBySystemUserID)
SELECT  ClassificationID, ClassificationDomainID, Code, Name, Description, SequenceOrder, ClassFilter, EffectiveDateFrom, EffectiveDateTo, DateCreated, 
        CreatedBySystemUserID, DateUpdated, UpdatedBySystemUserID 
FROM    OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').[PALMSDB].[dbo].[tblClassification]
WHERE ClassificationID > 1034