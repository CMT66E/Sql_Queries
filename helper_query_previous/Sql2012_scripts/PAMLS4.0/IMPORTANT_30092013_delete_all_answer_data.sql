delete A 
FROM tblEMAssessmentResultAnswer A 
INNER JOIN tblEMAssessmentResultSection B  ON A.EMAssessmentResultSectionID = B.EMAssessmentResultSectionID
INNER JOIN tblEMAssessmentResultCategory C ON B.EMAssessmentResultCategoryID = C.EMAssessmentResultCategoryID 
WHERE C.InstrumentID = 4000004

delete B
FROM tblEMAssessmentResultSection B 
INNER JOIN tblEMAssessmentResultCategory C ON B.EMAssessmentResultCategoryID = C.EMAssessmentResultCategoryID
WHERE C.InstrumentID = 4000004 

delete C
from tblEMAssessmentResultCategory C
where C.InstrumentID = 4000004 