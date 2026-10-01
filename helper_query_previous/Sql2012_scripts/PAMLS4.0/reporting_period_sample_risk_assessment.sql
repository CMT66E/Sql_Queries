

select [dbo].[ufn_GetEMAssessmentPeriod](4000005)

select  * from tblEMAssessmentPeriod where InstrumentID = 4000011 order by EndDate desc


	   select  	   
	   rp.StartDate, 
	   rp.EndDate, 
	   c.Name as [Status], 
	   a.InstrumentID as ARNumber 	   
	   from tblInstrument a 
	   left outer join tblClassification c on c.ClassificationID = a.InstrumentStatusID
	   left outer join tblEMAssessmentPeriod rp on rp.EMAssessmentPeriodID = (select top 1 d.EMAssessmentPeriodID from tblEMAssessmentPeriod d where d.InstrumentID = @InstrumentID order by EndDate desc) 	   
	   where a.InstrumentID = @InstrumentID 
	   