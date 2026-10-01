SELECT [RiskAssessmentQuestionID]
	  ,A.[RiskAssessmentSectionID]	  
	  ,A.QuestionDescription
	  ,A.[SequenceOrder]
	  ,A.[QuestionTypeID]
	  ,C.[Description]
	  ,A.[DateCreated]
	  ,A.[CreatedBySystemUserID]
	  ,A.[DateUpdated]
	  ,A.[UpdatedBySystemUserID]
	  ,B.RiskAssessmentSection				  		  
FROM [tblRiskAssessmentQuestion] A 
INNER JOIN tblRiskAssessmentSection B ON A.RiskAssessmentSectionID = B.RiskAssessmentSectionID
INNER JOIN tblClassification C ON A.QuestionTypeID = C.ClassificationID
	
	 
		 