select * from tblClassification 
--where ClassificationDomainID in (114)
where ClassificationDomainID in (35, 108, 114, 115, 116)

select * from tblClassification where description like '%UNNumber%'

select * from tblClassification where ClassificationDomainID in (116)

select * from tblDGDesignApprovalClassUN

GRANT EXECUTE ON [dbo].[uspSaveDGDesignApprovalSec] TO ReadWriteRole