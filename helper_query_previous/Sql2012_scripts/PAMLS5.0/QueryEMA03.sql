SELECT   
  
A.InstrumentID, 
A.EMAssessmentCategoryID, 
B.EMAssessmentSectionID, 
X.EMAssessmentSection, 
C.EMAssessmentAnswerID, 
Y.EMAssessmentAnswer, 
C.EnteredValue, 
Y.EMAssessmentQuestionID, 
B.EMAssessmentResultSectionID, 
C.ReasonForChange,
*

FROM 
  
  dbo.tblEMAssessmentResultCategory AS A 
  
  LEFT OUTER JOIN dbo.tblEMAssessmentResultSection AS B ON A.EMAssessmentResultCategoryID = B.EMAssessmentResultCategoryID 
  LEFT OUTER JOIN dbo.tblEMAssessmentResultAnswer AS C ON B.EMAssessmentResultSectionID = C.EMAssessmentResultSectionID 
  LEFT OUTER JOIN dbo.tblEMAssessmentSection AS X ON B.EMAssessmentSectionID = X.EMAssessmentSectionID 
  LEFT OUTER JOIN dbo.tblEMAssessmentAnswer AS Y ON C.EMAssessmentAnswerID = Y.EMAssessmentAnswerID
  
WHERE (A.EMAssessmentCategoryID > 0) and A.InstrumentID = 4000037  