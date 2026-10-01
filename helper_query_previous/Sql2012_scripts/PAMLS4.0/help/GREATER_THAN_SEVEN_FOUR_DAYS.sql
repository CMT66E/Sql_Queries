	   select    a.StartDate as StartDateTemp, 
				 a.EndDate as EndDateTemp,
				 DATEDIFF(day, a.EndDate, getdate()) as PassedDays,
				 a.InstrumentID,
				 b.InstrumentTypeID,
				 b.InstrumentStatusID  
	   from tblEMAssessmentPeriod a inner join tblInstrument b on a.InstrumentID = b.InstrumentID
	   where DATEDIFF(day, a.EndDate, getdate()) > 74 and b.InstrumentStatusID  = 699 --Draft status

	   select * from tblEMAssessmentPeriod where InstrumentID = 4001442
	   select * from tblInstrument where InstrumentID = 4001442


	   -------------------------------------------------------------------------------------------------------------
	   update tblInstrument set InstrumentStatusID = 1032, DateUpdated = getdate(), UpdatedBySystemUserID = 1
	   where  InstrumentID in 
	   (
		   select a.InstrumentID				 
		   from tblEMAssessmentPeriod a inner join tblInstrument b on a.InstrumentID = b.InstrumentID
		   where DATEDIFF(day, a.EndDate, getdate()) > 74 and b.InstrumentStatusID  = 699 --Draft status
	   )
	   -------------------------------------------------------------------------------------------------------------


--GRANT EXECUTE ON [dbo].[uspProcessEMCPendingStatusBatch] TO ReadWriteRole

select * from tblClassification