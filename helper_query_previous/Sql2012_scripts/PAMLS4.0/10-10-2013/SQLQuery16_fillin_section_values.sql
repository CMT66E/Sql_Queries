SELECT     TOP (200) EMAssessmentResultAnswerID, EMAssessmentResultSectionID, EMAssessmentAnswerID, EnteredValue, ReasonForChange, DateCreated, 
                      CreatedBySystemUserID, DateUpdated, UpdatedBySystemUserID, RowTimestamp
FROM         tblEMAssessmentResultAnswer
WHERE     (EMAssessmentResultAnswerID >= 82704) AND (EMAssessmentResultAnswerID <= 82709)