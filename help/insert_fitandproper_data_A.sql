--DECLARE @FinalTableRadiationLicenceFitAndProper TABLE
--	(
--	[RadiationLicenceFitAndProperID] [int] IDENTITY(1,1) NOT NULL,
--	[InstrumentID] [int] NOT NULL,
--	[FitAndProperQuestionID] [smallint] NOT NULL,
--	[FitAndProperAnswerFlag] [bit] NULL,
--	[Justification] [varchar](500) NULL,
--	[DateCreated] [smalldatetime] NOT NULL,
--	[CreatedBySystemUserID] [int] NOT NULL,
--	[DateUpdated] [smalldatetime] NULL,
--	[UpdatedBySystemUserID] [int] NULL,
--	[RowTimestamp] [timestamp] NOT NULL
--	)  


DECLARE @RadiationLicenceTypeID INT
SET @RadiationLicenceTypeID = 794 --796: Management licences  794: Accreditation licences


DECLARE @MyTable TABLE
	(
	SNo int IDENTITY(1,1), 
	PrimaryId int
	)    
INSERT INTO @MyTable(PrimaryId)	    
SELECT InstrumentID from tblRadiationLicence where RadiationLicenceTypeID = @RadiationLicenceTypeID and not OldLicenceNumber is null
	
DECLARE @Cnt INT
DECLARE @PrimaryId INT
 
SELECT @Cnt = MIN(Sno) FROM @MyTable
	
WHILE (1=1)
BEGIN
   
SELECT @PrimaryId = PrimaryId FROM @MyTable
WHERE SNo = @Cnt
	    
IF @@ROWCOUNT = 0
	BREAK
	--here we need loop through whole tblFitAndProperQuestion table rows and insert them into database table: tblRadiationLicenceFitAndProper
	DECLARE @MyTableTemp TABLE
	(
		SNo int IDENTITY(1,1), 
		QuestionId int
	)  
	INSERT INTO @MyTableTemp(QuestionId)
	select FitAndProperQuestionID from tblFitAndProperQuestion where SequenceOrder <= (case @RadiationLicenceTypeID when 796 then 8 when 794 then 4 else 100 end) order by FitAndProperQuestionID 	 

	DECLARE @CntTemp INT
	DECLARE @PrimaryQuestionId INT    		
	SELECT @CntTemp = MIN(Sno) FROM @MyTableTemp
	--start loop
		WHILE (1=1)
		BEGIN
   
		SELECT @PrimaryQuestionId = QuestionId FROM @MyTableTemp
		WHERE SNo = @CntTemp
	    
		IF @@ROWCOUNT = 0
			BREAK

			--here is the final insert action
			--insert into tblRadiationLicenceFitAndProper(
			--											   [InstrumentID]
			--											  ,[FitAndProperQuestionID]
			--											  ,[FitAndProperAnswerFlag]
			--											  ,[Justification]
			--											  ,[DateCreated]
			--											  ,[CreatedBySystemUserID]			
			--                                            ) 
			--											values
			--											(
			--											   @PrimaryId
			--											  ,@PrimaryQuestionId			
			--											  ,0	
			--											  ,null
			--											  ,GetDate()
			--											  ,1		
			--							                )

			insert into tblRadiationLicenceFitAndProper(
															[InstrumentID],
															[FitAndProperQuestionID],
															[FitAndProperAnswerFlag],
															[Justification],
															[DateCreated],
															[CreatedBySystemUserID]		
			                                           )
            select 										   @PrimaryId as [InstrumentID] 
														  ,@PrimaryQuestionId as [FitAndProperQuestionID]			
														  ,0 as [FitAndProperAnswerFlag]	
														  ,null as [Justification]
														  ,GetDate() as [DateCreated]
														  ,1 as [CreatedBySystemUserID]

		SELECT @CntTemp = @CntTemp + 1
		
		END
	--end loop
	DELETE @MyTableTemp

SELECT @Cnt = @Cnt + 1
		
END

DELETE @MyTable

--SELECT * FROM @FinalTableRadiationLicenceFitAndProper
