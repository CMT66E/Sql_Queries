	declare @id int = 2595
	declare @IsTest bit = 1

	DECLARE @InstrumentID int = 1000000
	DECLARE @Number int = 1 --used for FitAndProperAnswer question count
	DECLARE @CreatedBySystemUserID int = 1

	DECLARE @LicenceXML xml = null

	SELECT @LicenceXML = LicenceXML 
	FROM tblOnlineRADApplication 
	WHERE OnlineRADApplicationID = @id

	 
	DECLARE @tblRadiationLicenceFitAndProper tblRadiationLicenceFitAndProperType 
	INSERT INTO @tblRadiationLicenceFitAndProper(
	 [RadiationLicenceFitAndProperID]  
	,[InstrumentID]
	,[FitAndProperQuestionID] 
	,[FitAndProperAnswerFlag] 
	,[Justification]
	,[DateCreated]
	,[CreatedBySystemUserID] 
	,[DateUpdated] 
	,[UpdatedBySystemUserID]
	,[Action]
	)
	SELECT -1 AS RadiationLicenceFitAndProperID,
		   -1 AS InstrumentID,
		   0 AS FitAndProperQuestionID,		   
		   RN.S.value('Answer[1]','varchar(20)') AS FitAndProperAnswerFlag,
		   RN.S.value('Question[1]','varchar(500)') AS Justification,		   
		   getdate() AS DateCreated,
		   1 AS CreatedBySystemUserID,
		   null AS DateUpdated,
		   null AS UpdatedBySystemUserID,
		   'I' AS Action    
	FROM @LicenceXML.nodes('/RADALicenceData/FitandProper/Questions/RADAFitandProperQuestion') AS RN(S)
    
	DECLARE @FitandProperStatement nvarchar(max) = ''
	select @FitandProperStatement = RN.S.value('Statement[1]','nvarchar(max)')
	FROM @LicenceXML.nodes('/RADALicenceData/FitandProper') AS RN(S)
 
	--we loop through all rows in table @tblRadiationLicenceFitAndProper
	declare @tblRadiationLicenceFitAndProperTemp table (
	[RadiationLicenceFitAndProperID] [int] IDENTITY(1,1) NOT NULL,
	[InstrumentID] [int] NOT NULL,
	[FitAndProperQuestionID] [smallint] NOT NULL,
	[FitAndProperAnswerFlag] [bit] NULL,
	[Justification] [varchar](500) NULL,
	[DateCreated] [smalldatetime] NOT NULL,
	[CreatedBySystemUserID] [int] NOT NULL)
 
	declare @Cnt int
	SELECT @Cnt = MIN(Sno) FROM @tblRadiationLicenceFitAndProper
	
	declare @TempFitAndProperQuestionID int
	declare @TempFitAndProperAnswerFlag int
	 	 
	WHILE (1=1)
	BEGIN
   
	SELECT @TempFitAndProperQuestionID = FitAndProperQuestionID, @TempFitAndProperAnswerFlag = FitAndProperAnswerFlag FROM @tblRadiationLicenceFitAndProper
	WHERE SNo = @Cnt
	    
	IF @@ROWCOUNT = 0
	BREAK

		if not exists(select * from tblRadiationLicenceFitAndProper where cast(InstrumentID as varchar) = cast(@InstrumentID as varchar) and FitAndProperQuestionID = @Number)
		begin
		    print '---------------------------------------------'
			print '@TempFitAndProperAnswerFlag =' + cast(@TempFitAndProperAnswerFlag as varchar)
			print '@@Number =' + cast(@Number as varchar)
			print '---------------------------------------------'
			
			if @IsTest = 1
			begin
			    if not exists(select * from @tblRadiationLicenceFitAndProper where cast(InstrumentID as varchar) = cast(@InstrumentID as varchar) and FitAndProperQuestionID = @Number)
				begin
				insert into @tblRadiationLicenceFitAndProperTemp (InstrumentID, FitAndProperQuestionID, FitAndProperAnswerFlag, Justification, DateCreated, CreatedBySystemUserID)
				values(@InstrumentID, @Number, @TempFitAndProperAnswerFlag, (case @TempFitAndProperAnswerFlag
														 when 1 then  @FitandProperStatement
														 else null
													end), getdate(), @CreatedBySystemUserID)
			    end
			end	
			else
			begin
			    if not exists(select * from tblRadiationLicenceFitAndProper where cast(InstrumentID as varchar) = cast(@InstrumentID as varchar) and FitAndProperQuestionID = @Number)
				begin
				insert into tblRadiationLicenceFitAndProper (InstrumentID, FitAndProperQuestionID, FitAndProperAnswerFlag, Justification, DateCreated, CreatedBySystemUserID)
				values(@InstrumentID, @Number, @TempFitAndProperAnswerFlag, (case @TempFitAndProperAnswerFlag
														 when 1 then  @FitandProperStatement
														 else null
													end), getdate(), @CreatedBySystemUserID)
			    end			
			end		 
		end
 	
	SELECT @Number = @Number + 1	
	SELECT @Cnt = @Cnt + 1
		
	END

	select * from @tblRadiationLicenceFitAndProperTemp
    --end loop @tblRadiationLicenceFitAndProper

	--loop for both :
	------------ tblRadiationLicenceAccreditationType -------------- 
	-------------  tblRadiationLicenceQualification ----------------
	declare @tblRadiationLicenceAccreditationTypeTemp table (
	[RadiationLicenceAccreditationTypeID] [int] IDENTITY(1,1) NOT NULL,
	[InstrumentID] [int] NOT NULL,
	[AccreditationTypeID] [smallint] NOT NULL,
	[AccreditationTypeName] [varchar](200) NULL,
	[DateCreated] [smalldatetime] NOT NULL,
	[CreatedBySystemUserID] [int] NOT NULL,
	[DateUpdated] [smalldatetime] NULL,
	[UpdatedBySystemUserID] [int] NULL,	 
	[MutualRecognitionFlag] [bit] NOT NULL,
	[QualificationId] [int] NULL,
	[QualificationAccreditationTypeId] [int] NULL,
	[QualificationName] [varchar](1000) NULL
	)
 
	insert into @tblRadiationLicenceAccreditationTypeTemp
	(
	[InstrumentID],
	[AccreditationTypeID],
	[AccreditationTypeName],
	[DateCreated],
	[CreatedBySystemUserID],
	[DateUpdated],
	[UpdatedBySystemUserID],
	[MutualRecognitionFlag],
	[QualificationId],
	[QualificationAccreditationTypeId],
	[QualificationName]
	)
	  select    
				@InstrumentID as [InstrumentID],           
				Tab.Col.value('(Id)[1]','INT') as [AccreditationTypeID],           
				Tab.Col.value('(Name)[1]','VARCHAR(100)') as [AccreditationTypeName],
				cast(getdate() as Date) as [DateCreated],
				@CreatedBySystemUserID as CreatedBySystemUserID,
				null as [DateUpdated],
				null as UpdatedBySystemUserID,
				Tab1.Col1.value('(IsMutualRecognition)[1]','BIT')  as [MutualRecognitionFlag], 
				Tab0.Col0.value('(Id)[1]','INT') as QualificationId,
				Tab0.Col0.value('(AccreditationTypeId)[1]','INT') as QualificationAccreditationTypeId,
				Tab0.Col0.value('(Name)[1]','varchar(500)') as QualificationName			
	  from @LicenceXML.nodes('/RADALicenceData/Accreditations/RADAccreditation') as TabA(ColA) 
	  cross apply TabA.ColA.nodes('Accreditation') as Tab(Col) 
	  cross apply TabA.ColA.nodes('Qualification/Details') as Tab0(Col0) 
	  cross apply TabA.ColA.nodes('MutualRecognition') as Tab1(Col1)  
	  where Tab.Col.value('(Id)[1]','INT') =  Tab0.Col0.value('(AccreditationTypeId)[1]','INT')

 
	--test purpose start
	declare @tblRadiationLicenceAccreditationType table (
	[RadiationLicenceAccreditationTypeID] [int] IDENTITY(1,1) NOT NULL,
	[InstrumentID] [int] NOT NULL,
	[AccreditationTypeID] [smallint] NOT NULL,
	[AccreditationTypeName] [varchar](200) NULL,
	[DateCreated] [smalldatetime] NOT NULL,
	[CreatedBySystemUserID] [int] NOT NULL,
	[DateUpdated] [smalldatetime] NULL,
	[UpdatedBySystemUserID] [int] NULL,	 
	[MutualRecognitionFlag] [bit] NOT NULL	 
	)

	declare @tblRadiationLicenceQualification table 
	(
	RadiationLicenceQualificationID [int] IDENTITY(1,1) NOT NULL,
	[InstrumentID] [int] NOT NULL,
	[QualificationID] [int] NOT NULL,
	[DateCreated] [smalldatetime] NOT NULL,
	[CreatedBySystemUserID] [int] NOT NULL,
	[DateUpdated] [smalldatetime] NULL,
	[UpdatedBySystemUserID] [int] NULL
	)
	--test purpose end

	
	declare @Cnt2 int
	SELECT @Cnt2 = MIN(RadiationLicenceAccreditationTypeID) FROM @tblRadiationLicenceAccreditationTypeTemp
    
	declare @TempAccreditationTypeID int
	declare @TempQualificationId int
	declare @TempMutualRecognitionFlag bit
	 	 
	WHILE (1=1)
	BEGIN
   
	SELECT 
		@TempAccreditationTypeID = AccreditationTypeID, 
		@TempQualificationId = QualificationId, 
		@TempMutualRecognitionFlag = MutualRecognitionFlag  
	FROM @tblRadiationLicenceAccreditationTypeTemp
	WHERE RadiationLicenceAccreditationTypeID = @Cnt2
	    
	IF @@ROWCOUNT = 0
	BREAK
 
		if not exists(select * from tblRadiationLicenceAccreditationType where cast(InstrumentID as varchar) = cast(@InstrumentID as varchar) and AccreditationTypeID = @TempAccreditationTypeID)
		begin
		    print '---------------------------------------------'
			print '@TempAccreditationTypeID =' + cast(@TempAccreditationTypeID as varchar)
			print '@TempQualificationId =' + cast(@TempQualificationId as varchar)
			print '@TempMutualRecognitionFlag =' + cast(@TempMutualRecognitionFlag as varchar)
			print '---------------------------------------------'
			
			if @IsTest = 1
			begin
				if not exists(select * from @tblRadiationLicenceAccreditationType 
				where cast(InstrumentID as varchar) = cast(@InstrumentID as varchar) and AccreditationTypeID = @TempAccreditationTypeID)
		        begin
				insert into @tblRadiationLicenceAccreditationType (InstrumentID, AccreditationTypeID, MutualRecognitionFlag, DateCreated, CreatedBySystemUserID)
				values(@InstrumentID, @TempAccreditationTypeID, @TempMutualRecognitionFlag,  getdate(), @CreatedBySystemUserID)
				end
			end		
			else
			begin
				if not exists(select * from tblRadiationLicenceAccreditationType 
				where cast(InstrumentID as varchar) = cast(@InstrumentID as varchar) and AccreditationTypeID = @TempAccreditationTypeID)
		        begin
					insert into tblRadiationLicenceAccreditationType (InstrumentID, AccreditationTypeID, MutualRecognitionFlag, DateCreated, CreatedBySystemUserID)
					values(@InstrumentID, @TempAccreditationTypeID, @TempMutualRecognitionFlag,  getdate(), @CreatedBySystemUserID)	
				end		       
			end 	 
		end
 	
		if not exists(select * from tblRadiationLicenceQualification where cast(InstrumentID as varchar) = cast(@InstrumentID as varchar) and QualificationID = @TempQualificationId)
		begin
			if @IsTest = 1
			begin
				insert into @tblRadiationLicenceQualification (InstrumentID, QualificationID, DateCreated, CreatedBySystemUserID)
				values(@InstrumentID, @TempQualificationId, getdate(), @CreatedBySystemUserID)
			end		
			else
		    begin
				insert into tblRadiationLicenceQualification (InstrumentID, QualificationID, DateCreated, CreatedBySystemUserID)
				values(@InstrumentID, @TempQualificationId, getdate(), @CreatedBySystemUserID)			
			end	
			   
		end
	 
	SELECT @Cnt2 = @Cnt2 + 1
		
	END	

	select * from @tblRadiationLicenceAccreditationType
	select * from @tblRadiationLicenceQualification