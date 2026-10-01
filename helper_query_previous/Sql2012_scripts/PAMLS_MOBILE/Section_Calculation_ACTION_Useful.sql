---------------------------------- get answer ------------------------ 

select * from tblRiskAssessmentResultMedia where InstrumentID = 4000003 

select * from tblRiskAssessmentResultSection where RiskAssessmentResultMediaID =9 

select c.RiskAssessmentQuestionID, c.QuestionDescription, b.RiskAssessmentAnswerID, b.AnswerDescription, c.RiskAssessmentSectionID  
from tblRiskAssessmentResultAnswer a 
inner join tblRiskAssessmentAnswer b
inner join tblRiskAssessmentQuestion c 
on b.RiskAssessmentQuestionID = c.RiskAssessmentQuestionID 
on a.RiskAssessmentAnswerID = b.RiskAssessmentAnswerID 
where RiskAssessmentResultSectionID in 
(select RiskAssessmentResultSectionID from tblRiskAssessmentResultSection where RiskAssessmentResultMediaID =9) 



---------------------------------

--SELECT	*
----MAX(raz.Score)
--										FROM	tblRiskAssessmentResultAssessmentZone result
--										JOIN	tblRiskAssessmentZone raz ON raz.RiskAssessmentZoneID = result.RiskAssessmentZoneID
--										JOIN	tblRiskAssessmentResultSection rs ON rs.RiskAssessmentResultSectionID = result.RiskAssessmentResultSectionID
--										WHERE	rs.RiskAssessmentResultMediaID = @RiskAssessmentResultMediaID

