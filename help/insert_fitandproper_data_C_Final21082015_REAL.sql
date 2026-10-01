DECLARE @tblPesticideLicenceClass TABLE
	(
	[PesticideLicenceClassID] [int] IDENTITY(1,1) NOT NULL,
	[InstrumentID] [int] NOT NULL,
	[LicenceClassID] [int] NOT NULL, 
	[DateCreated] [smalldatetime] NOT NULL,
	[CreatedBySystemUserID] [int] NOT NULL,
	[DateUpdated] [smalldatetime] NULL,
	[UpdatedBySystemUserID] [int] NULL 
	)  
INSERT INTO @tblPesticideLicenceClass
           ([InstrumentID] -- change the FK. (NEW Inst.ID)
           ,[LicenceClassID]
           ,[DateCreated]
           ,[CreatedBySystemUserID]
           ,[DateUpdated]
           ,[UpdatedBySystemUserID])
SELECT  
	   i.Row_ID -- change the FK. (NEW Inst.ID)
      ,[LicenceClassID]
      ,GETDATE()
      ,1
      ,GETDATE()
      ,1
  FROM OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB')
    .PALMSMigrationDB.dbo.dm_PesticideLicenceClassNew plc
inner join OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB')
    .PALMSMigrationDB.dbo.dm_instrument i on plc.InstrumentID = i.InstrumentID
 

--DECLARE @FinalTableRadiationLicenceFitAndProper TABLE
--	(
--		[RadiationLicenceFitAndProperID] [int] IDENTITY(1,1) NOT NULL,
--		[InstrumentID] [int] NOT NULL,
--		[FitAndProperQuestionID] [smallint] NOT NULL,
--		[FitAndProperAnswerFlag] [bit] NULL,
--		[Justification] [varchar](500) NULL,
--		[DateCreated] [smalldatetime] NOT NULL,
--		[CreatedBySystemUserID] [int] NOT NULL,
--		[DateUpdated] [smalldatetime] NULL,
--		[UpdatedBySystemUserID] [int] NULL,
--		[RowTimestamp] [timestamp] NOT NULL
--	)  
 
DECLARE @MyTable TABLE
	(
		SNo int IDENTITY(1,1), 
		PrimaryId int
	)    
INSERT INTO @MyTable(PrimaryId)	    
SELECT DISTINCT InstrumentID from @tblPesticideLicenceClass  
	
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
    (select [LicenceClassID] from @tblPesticideLicenceClass where InstrumentID = @PrimaryId) 

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
			if not exists(select RadiationLicenceFitAndProperID from  tblRadiationLicenceFitAndProper where [InstrumentID] = @PrimaryId and [FitAndProperQuestionID] = @PrimaryQuestionId and [FitAndProperAnswerFlag] = 0)			 
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

-- Check those newly insert records in table: tblRadiationLicenceFitAndProper
--SELECT * FROM tblRadiationLicenceFitAndProper
--WHERE InstrumentID in (SELECT DISTINCT InstrumentID from @tblPesticideLicenceClass)

DELETE @tblPesticideLicenceClass
