select A.*, 
B.ScoreFactor ,
B.ScoreTypeID
from viewEMAssessmentResult A
inner join tblEMAssessmentAnswer B on A.EMAssessmentAnswerID = B.EMAssessmentAnswerID
where InstrumentID = 4000011 and EMAssessmentSectionID = 1

 
SELECT (
  case B.ScoreTypeID
  when 688 then isnull([EnteredValue], 0)*isnull(B.ScoreFactor, 0)
  when 685 then isnull([EnteredValue], 0)
  end) as totalscore, *		 
FROM [viewEMAssessmentResult] A
INNER JOIN tblEMAssessmentAnswer B ON A.EMAssessmentAnswerID = B.EMAssessmentAnswerID
WHERE InstrumentID = 4000005
-- and A.EMAssessmentSectionID = 1 