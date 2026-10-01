		select c.InstrumentID, B.ResponsibleSystemUserID, c.NoticeInstrumentID
		from tblnotice a inner join tblInstrument b
			   on a.InstrumentID = b.InstrumentID inner join tblInstrumentNotice c
			   on a.InstrumentID = c.NoticeInstrumentID
		where a.NoticeTemplateID = 379 and b.InstrumentStatusID = 566 and a.ProcessedForOWT = 0
		AND
			   EXISTS (SELECT * FROM tblPOEOLicenceFeeBasedActivity E
			   INNER JOIN tblFeeBasedActivity D ON E.FeeBasedActivityID = D.FeeBasedActivityID
			   WHERE E.InstrumentID = C.InstrumentID                                
			   AND D.PremisesFlag =1 )  



		select c.InstrumentID, B.ResponsibleSystemUserID, c.NoticeInstrumentID
		from tblnotice a inner join tblInstrument b
			   on a.InstrumentID = b.InstrumentID inner join tblInstrumentNotice c
			   on a.InstrumentID = c.NoticeInstrumentID
		where a.NoticeTemplateID = 379 and b.InstrumentStatusID = 566
		and c.InstrumentID = 803		AND
			   EXISTS (SELECT * FROM tblPOEOLicenceFeeBasedActivity E
			   INNER JOIN tblFeeBasedActivity D ON E.FeeBasedActivityID = D.FeeBasedActivityID
			   WHERE E.InstrumentID = C.InstrumentID                                
			   AND D.PremisesFlag =1 )  

			   