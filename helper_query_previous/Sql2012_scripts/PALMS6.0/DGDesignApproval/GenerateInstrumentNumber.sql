			Select  isNull(PALMSNewNumber,0),
				    isNull(EndNumber,0)   
			  From dbo.tblInstrumentNumber WITH (TABLOCKX)
			 Where InstrumentTypeID = 990
			   and EffectiveDateTo is null

Select  isNull(MAX(InstrumentID), 5000000 - 1) 
							  From dbo.tblDGDesignApproval 
							 Where InstrumentID Between 5000000 and 5999999 


Select isNull(MAX(InstrumentID),5000000 - 1) 
From dbo.tblInstrument 
Where 
(InstrumentTypeID=750 or  InstrumentTypeID= 817 or  InstrumentTypeID= 818 or InstrumentTypeId= 990)
and InstrumentID Between 5000000 and 5999999

Select * From tblInstrument where InstrumentID = 5000000

select * from tblInstrument where InstrumentID > 5000000 

select * from tblDGDesignApproval

select * from dbo.tblInstrumentNumber

select * from tblInstrument order by DateCreated desc

 