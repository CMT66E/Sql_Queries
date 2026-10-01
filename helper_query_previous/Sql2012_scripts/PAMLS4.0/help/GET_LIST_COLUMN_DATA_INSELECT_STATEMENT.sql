	  declare @InstrumentID int = 4003797
	  
	    DECLARE @MyTable TABLE
		(
		SNo int IDENTITY(1,1), 
		POEOLicencenNo int,
		AccountablePartyName varchar(500),
		AssessmentStatus varchar(50),
		AssessmentNumber int,
		TypeText varchar(500)
		)  
    
	   insert into @MyTable
	   SELECT AccountableParty.InstrumentID as POEOLicencenNo,		 
			 dbo.ufn_GetNameByAccountablePartyId(AccountableParty.AccountablePartyID) AS AccountablePartyName,
			 (select  	    
	   c.Name as AssessmentStatus	   	   	   
	   from tblInstrument a 
	   left outer join tblClassification c on c.ClassificationID = a.InstrumentStatusID
	   inner join tblRiskAssessment d on a.InstrumentID = d.InstrumentID
	   inner join tblClassification e ON d.RiskAssessmentTypeID = e.ClassificationID
	   where a.InstrumentID = @InstrumentID) as AssessmentStatus,

	  (select  	    	    
	   a.InstrumentID as AssessmentNumber  
	   from tblInstrument a 
	   left outer join tblClassification c on c.ClassificationID = a.InstrumentStatusID
	   inner join tblRiskAssessment d on a.InstrumentID = d.InstrumentID
	   inner join tblClassification e ON d.RiskAssessmentTypeID = e.ClassificationID
	   where a.InstrumentID = @InstrumentID) as AssessmentNumber,
	   
	   (select isnull(e.[Description], '') + ' ' + cast(a.InstrumentID as varchar)  from tblInstrument a 
	   left outer join tblClassification c on c.ClassificationID = a.InstrumentStatusID
	   inner join tblRiskAssessment d on a.InstrumentID = d.InstrumentID
	   inner join tblClassification e ON d.RiskAssessmentTypeID = e.ClassificationID
	   where a.InstrumentID = @InstrumentID) as TypeText 	
	   	 
	   FROM tblInstrumentAccountableParty AS AccountableParty
	   WHERE AccountableParty.InstrumentID = (SELECT TOP 1 POEOLicenceIntrumentID from tblRiskAssessment WHERE InstrumentID = @InstrumentID)
	   ORDER BY InstrumentAccountablePartyID  

	   --modified this 17-06-2016 we make sure we only choose single row of RiskTitleSummary
	   declare @TempChar varchar(1) = ''	
	   declare @AccountablePartyName varchar(1000) = ''	
	   select @AccountablePartyName = @AccountablePartyName + COALESCE(AccountablePartyName + ', ' ,'')   from @MyTable
	   set @AccountablePartyName = ltrim(rtrim(@AccountablePartyName))
	   select @TempChar = SUBSTRING(@AccountablePartyName, DATALENGTH(@AccountablePartyName), 1) 

	   if @TempChar= ','
	     select @AccountablePartyName = SUBSTRING(@AccountablePartyName, 1, DATALENGTH(@AccountablePartyName)-1)  
	   --end modified this

       select Top 1 POEOLicencenNo, @AccountablePartyName as AccountablePartyName, AssessmentStatus, AssessmentNumber, TypeText from @MyTable as RiskTitleSummary



	   print '@AccountablePartyName= ' + @AccountablePartyName
       delete @MyTable