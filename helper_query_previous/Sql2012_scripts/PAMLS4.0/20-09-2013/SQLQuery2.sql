			--select A.*, C.* 			  
			--from viewEMAssessmentResult A	
			--inner join tblEMAssessmentAnswer C ON A.EMAssessmentAnswerID = C.EMAssessmentAnswerID
			--inner join tblEMAssessmentCategory B ON A.EMAssessmentCategoryID = B.EMAssessmentCategoryID 	 
			--where A.InstrumentID = 4000005 
 
 
             declare @InstrumentID int
             set @InstrumentID = 4000005
             declare   @YearOneScore int,    
					   @YearTwoScore int,
					   @YearThreeScore int; 
 
			 SELECT  A.*, B.ScoreTypeID, B.Score, B.ScoreFactor,
			 (case B.ScoreTypeID
			  when 688 then isnull([EnteredValue], 0)*isnull(B.ScoreFactor, 0)    --multiply by factor
			  when 685 then isnull([EnteredValue], 0)
			  end) as CalculatedScore  
			 FROM [viewEMAssessmentResult] A
			 INNER JOIN tblEMAssessmentAnswer B ON A.EMAssessmentQuestionID = B.EMAssessmentQuestionID 
			 WHERE InstrumentID = @InstrumentID
			 --and A.EMAssessmentAnswer like '%1 year%'
			 
			 SELECT @YearOneScore = SUM(case B.ScoreTypeID
			  when 688 then isnull([EnteredValue], 0)*isnull(B.ScoreFactor, 0)    --multiply by factor
			  when 685 then isnull([EnteredValue], 0)
			  end)  
			 FROM [viewEMAssessmentResult] A
			 INNER JOIN tblEMAssessmentAnswer B ON A.EMAssessmentQuestionID = B.EMAssessmentQuestionID 
			 WHERE InstrumentID = @InstrumentID
			 --and A.EMAssessmentAnswer like '%1 year%'			 
			  
			 --SELECT @YearTwoScore = sum(isnull([EnteredValue], 0))  
			 -- FROM [viewEMAssessmentResult]
			 -- WHERE InstrumentID = @InstrumentID
			 -- and EMAssessmentAnswer like '%2 year%'  
			  
			 --SELECT @YearThreeScore = sum(isnull([EnteredValue], 0)) 
			 -- FROM [viewEMAssessmentResult]
			 -- WHERE InstrumentID = @InstrumentID
			 -- and EMAssessmentAnswer like '%3 year%'  
			 
			 
			 --select * from [viewEMAssessmentResult] A  
			 --where A.InstrumentID = 4000005
			
			 