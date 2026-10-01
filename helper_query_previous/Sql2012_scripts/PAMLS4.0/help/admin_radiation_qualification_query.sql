select A.*, B.[ConditionName], B.[Description] as ConditionDesc
,C.Description as AccreditationType
from tblQualification A 
LEFT OUTER JOIN tblRadiationCondition B ON A.RadiationConditionID = B.RadiationConditionID 
LEFT OUTER JOIN tblClassification C ON A.AccreditationTypeID = C.ClassificationID 