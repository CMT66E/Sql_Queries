 

SELECT D.EMAssessmentQuestionID, * FROM tblEMAssessmentResultAnswer A 
INNER JOIN tblEMAssessmentResultSection B ON A.EMAssessmentResultSectionID = B.EMAssessmentResultSectionID
INNER JOIN tblEMAssessmentResultCategory C ON B.EMAssessmentResultCategoryID = C.EMAssessmentResultCategoryID 
INNER JOIN tblEMAssessmentAnswer D ON A.EMAssessmentAnswerID = D.EMAssessmentAnswerID
WHERE C.InstrumentID = 4001124 and B.EMAssessmentSectionID = 12