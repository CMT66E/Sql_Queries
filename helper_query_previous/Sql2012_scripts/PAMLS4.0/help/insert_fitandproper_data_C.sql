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


--DECLARE @RadiationLicenceTypeID INT
--SET @RadiationLicenceTypeID = 795 --794: Accreditation licences  795: Licence to use  796: Management licences  


DECLARE @MyTable TABLE
	(
	SNo int IDENTITY(1,1), 
	PrimaryId int
	)    
INSERT INTO @MyTable(PrimaryId)	    
SELECT InstrumentID from tblPesticideLicence where not OldLicenceNumber is null
	
DECLARE @Cnt INT
DECLARE @PrimaryId INT
 
SELECT @Cnt = MIN(Sno) FROM @MyTable
	
WHILE (1=1)
BEGIN
   
SELECT @PrimaryId = PrimaryId FROM @MyTable
WHERE SNo = @Cnt
	    
IF @@ROWCOUNT = 0
	BREAK
	--here we need loop through and find all necessary question based on tblPesticideLicenceClass and insert them into database table: tblRadiationLicenceFitAndProper
	DECLARE @MyTableTemp TABLE
	(
		SNo int IDENTITY(1,1), 
		QuestionId int
	)  	 
	INSERT INTO @MyTableTemp(QuestionId)
	select distinct FitAndProperQuestionForPesticideLicenceID from viewFitandProperQuestionForPestcideLicence where [LicenceClassID] IN
    (select [LicenceClassID] from tblPesticideLicenceClass where InstrumentID = @PrimaryId) 

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
			if not exists(select RadiationLicenceFitAndProperID from  tblRadiationLicenceFitAndProper where [InstrumentID] = @PrimaryId and [FitAndProperQuestionID]=@PrimaryQuestionId and not [FitAndProperAnswerFlag] is null)			 
			begin
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
            end
		SELECT @CntTemp = @CntTemp + 1
		
		END
	--end loop
	DELETE @MyTableTemp

SELECT @Cnt = @Cnt + 1
		
END

DELETE @MyTable

--SELECT * FROM @FinalTableRadiationLicenceFitAndProper
