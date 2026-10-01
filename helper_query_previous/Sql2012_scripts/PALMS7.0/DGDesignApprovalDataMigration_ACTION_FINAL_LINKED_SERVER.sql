USE [PALMSDB]
GO 

declare @IsTest bit
set @IsTest = 1  --default we run as test case
--set @IsTest = 0  -- *****************PRODUCTION CALL*******************-- 
/*

sp_configure 'show advanced options', 1;
RECONFIGURE;
GO

sp_configure 'Ad Hoc Distributed Queries', 1;
RECONFIGURE;
GO

-- ********* PREPARE MIGRATION TABLES.
-- Table 1
ALTER TABLE dm_Instrument ALTER COLUMN Row_ID int
ALTER TABLE dm_Instrument ALTER COLUMN DateCreated smalldatetime 
ALTER TABLE dm_Instrument ALTER COLUMN DateUpdated smalldatetime
ALTER TABLE dm_Instrument ALTER COLUMN CreatedBySystemUserID int
ALTER TABLE dm_Instrument ALTER COLUMN UpdatedBySystemUserID int

update dm_Instrument
	set CreatedBySystemUserID = 1
	, UpdatedBySystemUserID = 1


-- Table 2
ALTER TABLE dm_PesticideLicence ALTER COLUMN Row_ID int
ALTER TABLE dm_PesticideLicence ALTER COLUMN DateCreated smalldatetime 
ALTER TABLE dm_PesticideLicence ALTER COLUMN DateUpdated smalldatetime
ALTER TABLE dm_PesticideLicence ALTER COLUMN CreatedBySystemUserID int
ALTER TABLE dm_PesticideLicence ALTER COLUMN UpdatedBySystemUserID int

ALTER TABLE dm_PesticideLicence ALTER COLUMN RenewalNoticeSentDate smalldatetime 
ALTER TABLE dm_PesticideLicence ALTER COLUMN PendingVariationAlertSentDate smalldatetime 
ALTER TABLE dm_PesticideLicence ALTER COLUMN ReviewDueDate smalldatetime 

update dm_PesticideLicence
	SET CreatedBySystemUserID = 1
	, UpdatedBySystemUserID = 1



-- Table 3
ALTER TABLE dm_PesticideLicenceClass ALTER COLUMN DateCreated smalldatetime
ALTER TABLE dm_PesticideLicenceClass ALTER COLUMN DateUpdated smalldatetime
ALTER TABLE dm_PesticideLicenceClass ALTER COLUMN CreatedBySystemUserID int
ALTER TABLE dm_PesticideLicenceClass ALTER COLUMN UpdatedBySystemUserID int


update dm_PesticideLicenceClass
	SET CreatedBySystemUserID = 1
	, UpdatedBySystemUserID = 1



-- Table 4
ALTER TABLE dm_Address ALTER COLUMN Row_ID int
--ALTER TABLE dm_Address ALTER COLUMN DateCreated smalldatetime -- COLUMN DOES NOT EXIST in SOURCE
ALTER TABLE dm_Address ALTER COLUMN DateUpdated smalldatetime
ALTER TABLE dm_Address ALTER COLUMN CreatedBySystemUserID int
ALTER TABLE dm_Address ALTER COLUMN UpdatedBySystemUserID int

update dm_Address
	SET CreatedBySystemUserID = 1
	, UpdatedBySystemUserID = 1


-- Table 5
ALTER TABLE dm_AccountableParty ALTER COLUMN Row_ID int
ALTER TABLE dm_AccountableParty ALTER COLUMN DateCreated smalldatetime
ALTER TABLE dm_AccountableParty ALTER COLUMN DateUpdated smalldatetime
ALTER TABLE dm_AccountableParty ALTER COLUMN CreatedBySystemUserID int
ALTER TABLE dm_AccountableParty ALTER COLUMN UpdatedBySystemUserID int

ALTER TABLE dm_AccountableParty ALTER COLUMN EffectiveDateTo smalldatetime
--ALTER TABLE dm_AccountableParty ALTER COLUMN EffectiveDateFrom smalldatetime COLUMN MISSING IN SOURCE!

update dm_AccountableParty
	SET CreatedBySystemUserID = 1
	, UpdatedBySystemUserID = 1

-- Table 6
ALTER TABLE dm_InstrumentAccountableParty ALTER COLUMN Row_ID int
ALTER TABLE dm_InstrumentAccountableParty ALTER COLUMN DateCreated smalldatetime
ALTER TABLE dm_InstrumentAccountableParty ALTER COLUMN DateUpdated smalldatetime
ALTER TABLE dm_InstrumentAccountableParty ALTER COLUMN CreatedBySystemUserID int
ALTER TABLE dm_InstrumentAccountableParty ALTER COLUMN UpdatedBySystemUserID int

ALTER TABLE dm_InstrumentAccountableParty ALTER COLUMN EffectiveDateTo smalldatetime
ALTER TABLE dm_InstrumentAccountableParty ALTER COLUMN EffectiveDateFrom smalldatetime

update dm_InstrumentAccountableParty
	SET CreatedBySystemUserID = 1
	, UpdatedBySystemUserID = 1


-- Table 7
ALTER TABLE dm_contact ALTER COLUMN Row_ID int
ALTER TABLE dm_contact ALTER COLUMN DateCreated smalldatetime
ALTER TABLE dm_contact ALTER COLUMN DateUpdated smalldatetime
ALTER TABLE dm_contact ALTER COLUMN CreatedBySystemUserID int
ALTER TABLE dm_contact ALTER COLUMN UpdatedBySystemUserID int

update dm_Contact
	SET CreatedBySystemUserID = 1
	, UpdatedBySystemUserID = 1



-- Table 8
ALTER TABLE dm_InstrumentContact ALTER COLUMN Row_ID int
ALTER TABLE dm_InstrumentContact ALTER COLUMN DateCreated smalldatetime
ALTER TABLE dm_InstrumentContact ALTER COLUMN DateUpdated smalldatetime
ALTER TABLE dm_InstrumentContact ALTER COLUMN CreatedBySystemUserID int
ALTER TABLE dm_InstrumentContact ALTER COLUMN UpdatedBySystemUserID int


update dm_InstrumentContact
	SET CreatedBySystemUserID = 1
	, UpdatedBySystemUserID = 1
GO


OPENDATASOURCE ('SQLOLEDB', 
'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB'

*/

----------------First thing we are cleaning those dirty data rows and set the linked fields
	  delete from OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').PALMSMigrationDB.dbo.dm_tblAddress where [Suburb] is null

	  update OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').PALMSMigrationDB.dbo.dm_tblAddress set ROW_ID = AddressId 
	  update OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').PALMSMigrationDB.dbo.dm_tblAccountableParty set ROW_ID = AccountablePartyID 
	  update OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').PALMSMigrationDB.dbo.dm_tblContact set ROW_ID = ContactID  

	  UPDATE  OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').PALMSMigrationDB.[dbo].dm_tblDGDesignApproval set [DesignApprovalTypeID] = (case [DesignApprovalType]	           
			  when 'S' then (case [TankerTypeID] 
								  when 864 then 991              --Rigid
								  when 865 then 993              --B-double A trailer
								  when 866 then 992              --Dog trailer
								  when 867 then 992              --Pig trailer
								  when 892 then 992              --Semi trailer
								  when 893 then 993              --B double B trailer
								  when 915 then 1023             --Unknown 
							end)   
			  when 'G' then (case [TankerTypeID] 
								  when 864 then 994              --Rigid
								  when 865 then 995              --B-double A trailer
								  when 866 then 995              --Dog trailer
								  when 867 then 995              --Pig trailer
								  when 892 then 995              --Semi trailer
								  when 893 then 996              --B double B trailer
								  when 915 then 1023             --Unknown 
							end)     
			  else null              
			  end) 

	  update OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').PALMSMigrationDB.[dbo].[dm_tblDGDesignApproval] set [DesignApprovalRestrictionID] = 998
	  where [DesignApprovalRestrictionID] = 963

	  update OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').PALMSMigrationDB.[dbo].[dm_tblDGDesignApproval] set [DesignApprovalRestrictionID] = 999
	  where [DesignApprovalRestrictionID] = 964
------------------------------------------------------------------------------------------------

    -- ********* START THE IMPORT.
    -- update the dm_Instrument table Row_ID column with NewID
	 declare @newInstrumentID int

		-- USE PROCEDURE AS GIVEN BY ERIC -----------------
		/* *********************************************** */
              Declare @NewNumber        int
              Declare @StartNumber      int
              Declare @EndNumber        int            
              Declare @CurrentNumber    int
              Declare @InstrumentID    int
                           
              Select	@StartNumber = isNull(PALMSNewNumber,0),
						@EndNumber   = isNull(EndNumber,0)   
                     From dbo.tblInstrumentNumber WITH (TABLOCKX)
                     Where InstrumentTypeID = 990  -- DG Tank Design Approval licence type
                     and EffectiveDateTo is null

			  --FOR DG Design Approval
			  --StartNumber: 5000000
			  --EndNumber  : 5999999

              Select @CurrentNumber = isNull(MAX(InstrumentID),@StartNumber - 1) 
              From dbo.tblInstrument 
                     Where 
                     (InstrumentTypeID=750 or  InstrumentTypeID= 817 or  InstrumentTypeID= 818  or  InstrumentTypeID= 990)
                     and InstrumentID Between @StartNumber and @EndNumber 
              --@CurrentNumber could be: 5066889 already existing in table: tblInstrument

              If ( @CurrentNumber = 0  OR @CurrentNumber < @EndNumber ) Begin                
                 Set @NewNumber  = @CurrentNumber + 1 
              End
              --@NewNumber could be: 5066889 + 1 = 5066890
			  

			--print '@CurrentNumber=' + cast(@CurrentNumber as varchar)
              If (@NewNumber is null or @NewNumber = 0 or exists(Select * From tblInstrument where InstrumentID = @NewNumber )) 
                     Begin
                       declare @errMsg varchar(100)
                       set @errMsg = 'Error generating newInstrumentID for type = %d' + ' there is ' + cast(@NewNumber as varchar(10))                   
                       RAISERROR (@errMsg, 16, 1, 990) 
                     End

			--print '@EndNumber=' + cast(@EndNumber as varchar)
			
			-- @NewNumber=5064550
			/* *********************************************** */

			set @newInstrumentID = @NewNumber

print '@newInstrumentID=' + cast(@newInstrumentID as varchar)

-- generate sequence of New Numbers, starting with @newInstrumentID;
-- so the mapping of old/newID's are held in this table.
--update OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB')
--    .PALMSMigrationDB.dbo.dm_tblInstrument
--	set @newInstrumentID = Row_ID = @newInstrumentID + 1
--	, CreatedBySystemUserID = 1
--	, UpdatedBySystemUserID = 1

    --this will set the column: InstrumentID in table: dm_tblInstrument to hold the real Instrument from existing PALMS system
    update OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').PALMSMigrationDB.dbo.dm_tblInstrument
	set @newInstrumentID = InstrumentID = @newInstrumentID + 1
	, CreatedBySystemUserID = 1
	, UpdatedBySystemUserID = 1


-- STEP 1. _______________________________________________________________
-- ***********************************************************************
print 'importing tblInstrument...'
if @IsTest = 1 
begin
    declare @TemptblInstrument table
	(
		[InstrumentID] [int] NOT NULL,
		[InstrumentTypeID] [smallint] NOT NULL,
		[InstrumentStatusID] [smallint] NOT NULL,
		[ResponsibleSystemUserID] [int] NOT NULL,
		[DECCWSectionID] [smallint] NOT NULL,
		[IssuedBySystemUserID] [int] NULL,
		[DateIssued] [smalldatetime] NULL,
		[DisplayFlag] [bit] NOT NULL,
		[DateCreated] [smalldatetime] NOT NULL,
		[CreatedBySystemUserID] [int] NOT NULL,
		[DateUpdated] [smalldatetime] NULL,
		[UpdatedBySystemUserID] [int] NULL,
		[RowTimestamp] [timestamp] NOT NULL,
		[ROW_ID] [nvarchar](15) NULL
	)

	INSERT INTO @TemptblInstrument (
		 [InstrumentID] -- new ID's go here.
		,[ROW_ID] -- old ID's go here (as per Source Excel table)
		,[InstrumentTypeID]
		,[InstrumentStatusID]
		,[ResponsibleSystemUserID]
		,[DECCWSectionID]
		,[IssuedBySystemUserID]
		,[DateIssued]
		,[DisplayFlag]
		,[DateCreated]
		,[CreatedBySystemUserID]
		,[DateUpdated]
		,[UpdatedBySystemUserID]
	)
	select 
		 [ROW_ID] AS newInstID		-- switch these 2
		,[InstrumentID] AS rowID	-- switch these 2
		,990 as [InstrumentTypeID]
		,(case [InstrumentStatusID] when 775 then 755 else [InstrumentStatusID] end) as [InstrumentStatusID]
		,1 as [ResponsibleSystemUserID]
		,7 as [DECCWSectionID]
		,1 as [IssuedBySystemUserID]
		,DateIssued as [DateIssued]
		,0 as [DisplayFlag]
		,GETDATE()
		,1
		,GETDATE()
		,1
	FROM OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').PALMSMigrationDB.dbo.dm_tblInstrument

	select * from @TemptblInstrument
end

if @IsTest = 0 
begin
print 'production run: tblInstrument'
	INSERT INTO tblInstrument (
		 [InstrumentID] -- new ID's go here.
		,[ROW_ID] -- old ID's go here (as per Source Excel table)
		,[InstrumentTypeID]
		,[InstrumentStatusID]
		,[ResponsibleSystemUserID]
		,[DECCWSectionID]
		,[IssuedBySystemUserID]
		,[DateIssued]
		,[DisplayFlag]
		,[DateCreated]
		,[CreatedBySystemUserID]
		,[DateUpdated]
		,[UpdatedBySystemUserID]
	)
	select 		 
		 [InstrumentID] AS rowID	-- switch these 2
		,[ROW_ID] AS newInstID		-- switch these 2
		,990 as [InstrumentTypeID]
		,(case [InstrumentStatusID] when 775 then 755 else [InstrumentStatusID] end) as [InstrumentStatusID]
		,1 as [ResponsibleSystemUserID]
		,7 as [DECCWSectionID]
		,1 as [IssuedBySystemUserID]
		,DateIssued as [DateIssued]
		,0 as [DisplayFlag]
		,GETDATE()
		,1
		,GETDATE()
		,1
	FROM OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').PALMSMigrationDB.dbo.dm_tblInstrument

	select * from tblInstrument where InstrumentID > @newInstrumentID

--INSERT INTO [dbo].[tblInstrument] (
--	 [InstrumentID] -- new ID's go here.
--	,[ROW_ID] -- old ID's go here (as per Source Excel table)
--	,[InstrumentTypeID]
--	,[InstrumentStatusID]
--	,[ResponsibleSystemUserID]
--	,[DECCWSectionID]
--	,[IssuedBySystemUserID]
--	,[DateIssued]
--	,[DisplayFlag]
--	,[DateCreated]
--	,[CreatedBySystemUserID]
--	,[DateUpdated]
--	,[UpdatedBySystemUserID]
--)
--select 
--	 [ROW_ID] AS newInstID		-- switch these 2
--	,[InstrumentID] AS rowID	-- switch these 2
--	,[InstrumentTypeID]
--	,[InstrumentStatusID]
--	,[ResponsibleSystemUserID]
--	,[DECCWSectionID]
--	,[IssuedBySystemUserID]
--	,[DateIssued]
--	,[DisplayFlag]
--	,GETDATE()
--	,1
--	,GETDATE()
--	,1
--FROM OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB')
--    .PALMSDB.dbo.dm_Instrument
end





-- STEP 2. _______________________________________________________________
-- ***********************************************************************
-- store the NEW InstID's in Row_ID of table (so the mapping is kept in dm_ table)
--update pl 
--	SET pl.Row_ID = i.Row_ID
--	from OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB')
--    .PALMSMigrationDB.dbo.dm_PesticideLicence pl
--	inner join OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB')
--    .PALMSMigrationDB.dbo.dm_instrument i on pl.InstrumentID = i.InstrumentID

    print 'importing into tblDGDesignApproval...'

    update pl 
	SET pl.InstrumentID = i.InstrumentID
	from  OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').PALMSMigrationDB.dbo.dm_tblDGDesignApproval pl
	inner join OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').PALMSMigrationDB.dbo.dm_tblInstrument i on pl.Row_ID = i.Row_ID

	if @IsTest = 1 
	begin
					Declare @TemptblDGDesignApproval Table
					(	 		
						[InstrumentID] [int] NOT NULL,
						[NSWDesignApprovalID] [int] NULL,
						[DesignApprovalNumber] [varchar](30) NULL,
						[DesignApprovalTypeID] [smallint] NOT NULL,
						[DateApplicationReceived] [smalldatetime] NOT NULL,
						[DateApplicationCompleted] [smalldatetime] NULL,
						[AdminFee] [money] NULL,
						[DesignApprovalState] [varchar](3) NOT NULL,
						[TankerTypeID] [smallint] NOT NULL,
						[Capacity] [int] NULL,
						[VINNumber] [varchar](20) NULL,
						[ExpiryDate] [smalldatetime] NULL,
						[CAPDecisionMadeFlag] [bit] NOT NULL,
						[CAPDecisionNumber] [varchar](30) NULL,
						[CAPDecisionDate] [smalldatetime] NULL,
						[DesignApprovalRestrictionID] [smallint] NULL,
						[ConsentForECFlag] [bit] NOT NULL,
						[Notes] [varchar](1000) NULL,
						[ParentApprovalID] [int] NULL,
						[DateCreated] [smalldatetime] NOT NULL,
						[CreatedBySystemUserID] [int] NOT NULL,
						[DateUpdated] [smalldatetime] NULL,
						[UpdatedBySystemUserID] [int] NULL,
						[RowTimestamp] [timestamp] NOT NULL,
						[TankSerialNumber] [varchar](20) NULL	
					)	

					insert into @TemptblDGDesignApproval(
						[InstrumentID],
						[NSWDesignApprovalID],
						[DesignApprovalNumber],
						[DesignApprovalTypeID],
					    [DateApplicationReceived],
						[DateApplicationCompleted],
						[AdminFee],
						[DesignApprovalState],
						[TankerTypeID],
						[Capacity],
						[VINNumber],
						[ExpiryDate],
						[CAPDecisionMadeFlag],
						[CAPDecisionNumber],
						[CAPDecisionDate],
						[DesignApprovalRestrictionID],
						[ConsentForECFlag],
						[Notes],
						[ParentApprovalID],
						[DateCreated],
						[CreatedBySystemUserID],
						[DateUpdated],
						[UpdatedBySystemUserID],					 
						[TankSerialNumber]	
					)
					select 
					    a.[InstrumentID],
					    null as [NSWDesignApprovalID],						
						[DesignApprovalNumber],
						[DesignApprovalTypeID],
						[DateApplicationCompleted],   ----getdate() as [DateApplicationReceived],
						[DateApplicationCompleted],
						[AdminFee],
						[DesignApprovalState],
						[TankerTypeID],
						[Capacity],
						[VINNumber],
						[ExpiryDate],
						0 as [CAPDecisionMadeFlag],
						[CAPDecisionNumber],
						[CAPDecisionDate],
						[DesignApprovalRestrictionID],
						0 as [ConsentForECFlag],
						[Notes],
						null as [ParentApprovalID],
						getdate() as [DateCreated],
						b.[CreatedBySystemUserID],
						b.[DateUpdated],
						b.[UpdatedBySystemUserID],					 
						[TankSerialNumber]	
					from dm_tblDGDesignApproval a inner join dm_tblInstrument b on a.ROW_ID = b.ROW_ID

					select * from @TemptblDGDesignApproval 
	end

	if @IsTest = 0 --production run for tblDGDesignApproval table
	begin
		print 'production run for tblDGDesignApproval'
		            --update [tblDGDesignApproval] set [ROW_ID] = null

					insert into tblDGDesignApproval(
						[InstrumentID],
						[NSWDesignApprovalID],
						[DesignApprovalNumber],
						[DesignApprovalTypeID],
					    [DateApplicationReceived],
						[DateApplicationCompleted],
						[AdminFee],
						[DesignApprovalState],
						[TankerTypeID],
						[Capacity],
						[VINNumber],
						[ExpiryDate],
						[CAPDecisionMadeFlag],
						[CAPDecisionNumber],
						[CAPDecisionDate],
						[DesignApprovalRestrictionID],
						[ConsentForECFlag],
						[Notes],
						[ParentApprovalID],
						[DateCreated],
						[CreatedBySystemUserID],
						[DateUpdated],
						[UpdatedBySystemUserID],					 
						[TankSerialNumber],
						[ROW_ID]	
					)
					select 
					    a.[InstrumentID],
					    null as [NSWDesignApprovalID],						
						[DesignApprovalNumber],
						[DesignApprovalTypeID],
						[DateApplicationCompleted],  ---getdate() [DateApplicationReceived],
						[DateApplicationCompleted],
						[AdminFee],
						[DesignApprovalState],
						[TankerTypeID],
						[Capacity],
						[VINNumber],
						[ExpiryDate],
						0 as [CAPDecisionMadeFlag],
						[CAPDecisionNumber],
						[CAPDecisionDate],
						[DesignApprovalRestrictionID],
						0 as [ConsentForECFlag],
						[Notes],
						null as [ParentApprovalID],
						getdate() as [DateCreated],
						b.[CreatedBySystemUserID],
						b.[DateUpdated],
						b.[UpdatedBySystemUserID],					 
						[TankSerialNumber],
						a.[ROW_ID]	
					from OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').PALMSMigrationDB.[dbo].dm_tblDGDesignApproval a inner join OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').PALMSMigrationDB.[dbo].dm_tblInstrument b on a.ROW_ID = b.ROW_ID

					select * from tblDGDesignApproval where InstrumentID > @newInstrumentID

		--INSERT INTO [dbo].[tblPesticideLicence] ( 
		--	  [InstrumentID] 
		--	, [ROW_ID]
		--	, [DateApplicationReceived] 
		--	, [DateApplicationCompleted] 
		--	, [AdminFee] 
		--	, [ExpiryDate] 
		--	, [ReviewDueDate] 
		--	, [ConsentForECFlag] 
		--	, [Notes] 
		--	, [RenewalNoticeSentDate] 
		--	, [DateCreated] 
		--	, [CreatedBySystemUserID] 
		--	, [DateUpdated] 
		--	, [UpdatedBySystemUserID]
		--	, [PendingVariationAlertSentDate]
		--	, [OldLicenceNumber]
		--)
		--SELECT 
		--	     Row_ID			-- new Inst.ID; goes into target table as PK.
		--	    ,[InstrumentID]	-- old/original ID (60,001 range); goes into RowID
		--      ,[DateApplicationReceived]
		--      ,[DateApplicationCompleted]
		--      ,[AdminFee]
		--      ,[ExpiryDate]
		--      ,[ReviewDueDate]
		--      ,[ConsentForECFlag]
		--      ,[Notes]
		--      ,[RenewalNoticeSentDate]
		--      ,GETDATE()
		--      ,1
		--      ,GETDATE()
		--      ,1
		--      --,[RowTimestamp]
		--      ,[PendingVariationAlertSentDate]
		--      ,[OldLicenceNumber]
		--  FROM OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB')
		--    .PALMSMigrationDB.dbo.dm_PesticideLicence
	end
					
-- STEP 3. _______________________________________________________________
-- ***********************************************************************
print 'importing dm_tblDGDesignApprovalClass...'

if @IsTest = 1 
begin
	Declare @TemptblDGDesignApprovalClassUN Table
	(
		[DGDesignApprovalClassUNID] [int] IDENTITY(1,1) NOT NULL,
		[InstrumentID] [int]  NULL,
		[DGClassID] [smallint] NULL,
		[DGUNNumberID] [smallint] NULL,
		[DateCreated] [smalldatetime] NOT NULL,
		[CreatedBySystemUserID] [int] NOT NULL,
		[DateUpdated] [smalldatetime] NULL,
		[UpdatedBySystemUserID] [int] NULL,
		[RowTimestamp] [timestamp] NOT NULL
	)

	insert into @TemptblDGDesignApprovalClassUN
	(	 
		[InstrumentID],
		[DGClassID],
		[DGUNNumberID],
		[DateCreated],
		[CreatedBySystemUserID],
		[DateUpdated],
		[UpdatedBySystemUserID]
	)
	 SELECT
		   d.InstrumentID      
		  ,(case C.ClassificationDomainID when 108 then c.ClassificationID when 116 then null end) as [DGclassID]
		  ,(case C.ClassificationDomainID when 108 then null when 116 then c.ClassificationID end) as [DGUNNumberID]
		  ,getdate() as [DateCreated]
		  ,1 as [CreatedBySystemUserID]
		  ,getdate() as [DateUpdated]
		  ,1 as [UpdatedBySystemUserID]	 
	  FROM [dbo].[dm_tblDGDesignApprovalClass] a 
	  inner join dm_tblClassificationUpdate b on a.[DGclassID] = b.tblClassificationID
	  inner join tblClassification c on b.name = c.[Description]
	  inner join dm_tblDGDesignApproval d on a.DesignApprovalID = d.DesignApprovalID
	  WHERE C.ClassificationDomainID in (108, 116) and d.InstrumentID is not null

	select * from @TemptblDGDesignApprovalClassUN
end

if @IsTest = 0 --production run
begin
   print 'production run dm_tblDGDesignApprovalClass...'

	insert into tblDGDesignApprovalClassUN
	(	 
		[InstrumentID],
		[DGClassID],
		[DGUNNumberID],
		[DateCreated],
		[CreatedBySystemUserID],
		[DateUpdated],
		[UpdatedBySystemUserID]
	)
	 SELECT
		   d.InstrumentID      
		  ,(case C.ClassificationDomainID when 108 then c.ClassificationID when 116 then null end) as [DGclassID]
		  ,(case C.ClassificationDomainID when 108 then null when 116 then c.ClassificationID end) as [DGUNNumberID]
		  ,getdate() as [DateCreated]
		  ,1 as [CreatedBySystemUserID]
		  ,getdate() as [DateUpdated]
		  ,1 as [UpdatedBySystemUserID]	 
	  FROM OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').PALMSMigrationDB.[dbo].[dm_tblDGDesignApprovalClass] a 
	  inner join OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').PALMSMigrationDB.[dbo].dm_tblClassificationUpdate b on a.[DGclassID] = b.tblClassificationID
	  inner join tblClassification c on b.name = c.[Description]
	  inner join OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').PALMSMigrationDB.[dbo].dm_tblDGDesignApproval d on a.DesignApprovalID = d.DesignApprovalID
	  WHERE C.ClassificationDomainID in (108, 116) and d.InstrumentID is not null

	select * from tblDGDesignApprovalClassUN where InstrumentID > @newInstrumentID

	--INSERT INTO dbo.[tblPesticideLicenceClass]
	--           ([InstrumentID] -- change the FK. (NEW Inst.ID)
	--           ,[LicenceClassID]
	--           ,[DateCreated]
	--           ,[CreatedBySystemUserID]
	--           ,[DateUpdated]
	--           ,[UpdatedBySystemUserID])
	--SELECT --,plc.[InstrumentID]
	--	   i.Row_ID -- change the FK. (NEW Inst.ID)
	--      ,[LicenceClassID]
	--      ,GETDATE()
	--      ,1
	--      ,GETDATE()
	--      ,1
	--  FROM OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB')
	--    .PALMSMigrationDB.dbo.dm_PesticideLicenceClass plc
	--inner join OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB')
	--    .PALMSMigrationDB.dbo.dm_instrument i on plc.InstrumentID = i.InstrumentID
end

-- STEP 4. _______________________________________________________________
-- ***********************************************************************
print 'importing tblAddress...'

if @IsTest = 1  --test case
begin	 
	Declare @TemptblAddress Table
	(
		[AddressID] [int] IDENTITY(1,1) NOT NULL,
		[Address] [varchar](100) NULL,
		[Suburb] [varchar](50) NOT NULL,
		[Postcode] [varchar](10) NULL,
		[StateCode] [varchar](20) NULL,
		[DateCreated] [smalldatetime] NOT NULL,
		[CreatedBySystemUserID] [int] NOT NULL,
		[DateUpdated] [smalldatetime] NULL,
		[UpdatedBySystemUserID] [int] NULL,
		[RowTimestamp] [timestamp] NOT NULL,
		[OverseasAddressFlag] [bit] NOT NULL,
		[Country] [varchar](100) NULL,
		[PrefixAddress] [varchar](100) NULL,
		[ROW_ID] [nvarchar](15) NULL
	)

	--we called these lines at the top
	--delete from dbo.dm_tblAddress
	--where [Suburb] is null

	INSERT INTO @TemptblAddress (
		   -- [AddressID] THIS IS Auto-Identity
		   [ROW_ID] -- instead stick the source table's ID in Row_ID.
		  ,[Address]
		  ,[Suburb]
		  ,[Postcode]
		  ,[StateCode]
		  ,[DateCreated]
		  ,[CreatedBySystemUserID]
		  ,[DateUpdated]
		  ,[UpdatedBySystemUserID]
		  ,[OverseasAddressFlag]
		  ,[Country]
		  ,[PrefixAddress]
	)
	SELECT 
		   [AddressID] -- store this in ROW_ID in table:  @TemptblAddress
		  ,[Address]
		  ,[Suburb]
		  ,[Postcode]
		  ,[StateCode]
		  , getdate() AS DateCreated -- missing from source.
		  ,1 as [CreatedBySystemUserID]
		  ,GETDATE() as [DateUpdated]
		  ,1 as [UpdatedBySystemUserID]
		  ,(case Country when null then 0 when '' then 0 else 1 end) as [OverseasAddressFlag]
		  ,case isnull([Country], '') when '' then 'AUSTRALIA' else [Country] end  as [country]
		  ,'' as [PrefixAddress]
	  FROM OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').PALMSMigrationDB.dbo.dm_tblAddress
	  order by addressID

    select * from @TemptblAddress
end

if @IsTest = 0 -- production run tblAddress
begin
   print 'production run tblAddress...'
    --Clean up ROW_ID column on tbale: tblAddress
	--update [tblAddress] set [ROW_ID] = null

	INSERT INTO tblAddress (
		   -- [AddressID] THIS IS Auto-Identity
		   [ROW_ID] -- instead stick the source table's ID in Row_ID.
		  ,[Address]
		  ,[Suburb]
		  ,[Postcode]
		  ,[StateCode]
		  ,[DateCreated]
		  ,[CreatedBySystemUserID]
		  ,[DateUpdated]
		  ,[UpdatedBySystemUserID]
		  ,[OverseasAddressFlag]
		  ,[Country]
		  ,[PrefixAddress]
	)
	SELECT 
		   [AddressID] -- store this in ROW_ID
		  ,[Address]
		  ,[Suburb]
		  ,[Postcode]
		  ,[StateCode]
		  , getdate() AS DateCreated -- missing from source.
		  ,1 as [CreatedBySystemUserID]
		  ,GETDATE() as [DateUpdated]
		  ,1 as [UpdatedBySystemUserID]
		  ,(case Country when null then 0 when '' then 0 else 1 end) as [OverseasAddressFlag]
		  ,case isnull([Country], '') when '' then 'AUSTRALIA' else [Country] end  as [country]
		  ,'' as [PrefixAddress]
	  FROM OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').PALMSMigrationDB.dbo.dm_tblAddress
	  order by addressID

	  --select * from tblAddress where cast(Row_ID as int) >= 1234

		--INSERT INTO [dbo].[tblAddress] (
		--	   -- [AddressID] THIS IS Auto-Identity
		--	   [ROW_ID] -- instead stick the source table's ID in Row_ID.
		--      ,[Address]
		--      ,[Suburb]
		--      ,[Postcode]
		--      ,[StateCode]
		--      ,[DateCreated]
		--      ,[CreatedBySystemUserID]
		--      ,[DateUpdated]
		--      ,[UpdatedBySystemUserID]
		--      ,[OverseasAddressFlag]
		--      ,[Country]
		--      ,[PrefixAddress]
		--)
		--SELECT 
		--	   [AddressID] -- store this in ROW_ID
		--      ,[Address]
		--      ,[Suburb]
		--      ,[Postcode]
		--      ,[StateCode]
		--	  , getdate() AS DateCreated -- missing from source.
		--      ,1
		--      ,GETDATE()
		--      ,1
		--      ,[OverseasAddressFlag]
		--      ,[Country]
		--      ,[PrefixAddress]
		--  FROM OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB')
		--    .PALMSMigrationDB.dbo.dm_Address
		--  order by addressID
end

  --  remap the new generated identities with the existing source addressID's
	declare @newAddressID int
	
	--select @newAddressID = addressID from tblAddress a
	--	where ROW_ID = '1234' -- ID from source Excel and it is 92252 in DEV
 --       If (@newAddressID is null or @newAddressID = 0 or not exists(Select * From tblAddress where addressID = @newAddressID )) BEGIN
 --               RAISERROR ('Error obtaining newAddressID',
	--				16, -- Severity.
	--				1 -- State.
	--			)
 --       END

	/*select * from tblAddress a
	where addressID between 92252 and 92252 + 200

	select * from tblAddress a
	inner join  dm_address dm_a on a.row_ID = cast(dm_a.addressID as varchar)
	where a.addressID >= @newAddressID
	*/
 
	if @IsTest = 1
	begin
		--update source address ROW_ID to be the real address IDs which from the real address table's address ID
		print 'address on test'
	    select @newAddressID = addressID from @TemptblAddress a
	    where ROW_ID = '1234' -- ID from source Excel

		UPDATE dm_a
			SET dm_a.Row_ID  = a.AddressID
		from @TemptblAddress a
			inner join  OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').PALMSMigrationDB.dbo.dm_tblAddress dm_a on a.row_ID = cast(dm_a.addressID as varchar)
		where a.addressID >= @newAddressID
	end
	else
	begin
	    print 'production run address ID reset'
	    
		select @newAddressID = addressID from tblAddress a
	    where ROW_ID = '1234' -- ID from source Excel

		UPDATE dm_a
			SET dm_a.Row_ID  = a.AddressID
		from tblAddress a
			inner join  OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').PALMSMigrationDB.dbo.dm_tblAddress dm_a on a.row_ID = cast(dm_a.addressID as varchar)
		where a.addressID >= @newAddressID

		--UPDATE dm_a
		--	SET dm_a.Row_ID  = a.AddressID
		--from tblAddress a
		--	inner join  OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB')
		--.PALMSMigrationDB.dbo.dm_address dm_a on a.row_ID = cast(dm_a.addressID as varchar)
		--where a.addressID >= @newAddressID
	end

	/*
	select a.AddressID, a.ROW_ID, dm_a.AddressID, dm_a.Row_ID  
	from tblAddress a
	inner join  dm_address dm_a on a.row_ID = cast(dm_a.addressID as varchar)
	where a.addressID >= 92252  --@newAddressID
	*/

  -- STEP 5. _______________________________________________________________
-- ***********************************************************************
print 'importing tblAccountableParty...'
if @IsTest = 1
begin
	Declare @TemptblAccountableParty Table
	(
		[AccountablePartyID] [int] IDENTITY(1,1) NOT NULL,
		[CompanyFlag] [bit] NOT NULL,
		[OrganisationName] [varchar](128) NULL,
		[TradingName] [varchar](128) NULL,
		[ABN] [varchar](14) NULL,
		[CompanyWebsite] [varchar](128) NULL,
		[ContactRoleFlag] [bit] NOT NULL,
		[TitleID] [smallint] NULL,
		[Surname] [varchar](60) NULL,
		[GivenName] [varchar](60) NULL,
		[Position] [varchar](128) NULL,
		[AddressID] [int] NULL,
		[Phone] [varchar](20) NULL,
		[Mobile] [varchar](20) NULL,
		[AfterHoursNumber] [varchar](20) NULL,
		[Fax] [varchar](20) NULL,
		[Email] [varchar](128) NULL,
		[Pager] [varchar](20) NULL,
		[EffectiveDateFrom] [smalldatetime] NOT NULL,
		[EffectiveDateTo] [smalldatetime] NULL,
		[DateCreated] [smalldatetime] NOT NULL,
		[CreatedBySystemUserID] [int] NOT NULL,
		[DateUpdated] [smalldatetime] NULL,
		[UpdatedBySystemUserID] [int] NULL,
		[RowTimestamp] [timestamp] NOT NULL,
		[ACN] [varchar](20) NULL,
		[DateOfBirth] [date] NULL,
		[Middlename] [varchar](60) NULL,
		[ROW_ID] [nvarchar](15) NULL
	)
	insert into @TemptblAccountableParty
	(
					[ROW_ID]		-- put the original Excel AccountablePartyID's here.
				   ,[AddressID]	    -- put the newly generated AddressID's here (as a FK)

				   ,[CompanyFlag]
				   ,[OrganisationName]
				   ,[TradingName]
				   ,[ABN]
				   ,[CompanyWebsite]

				   ,[ContactRoleFlag]
				   ,[TitleID]
				   ,[Surname]
				   ,[Middlename]
				   ,[GivenName]

				   ,[Position]
				   ,[Phone]
				   ,[Mobile]
				   ,[AfterHoursNumber]
				   ,[Fax]

				   ,[Email]
				   ,[Pager]
				   , EffectiveDateFrom
				   ,[EffectiveDateTo]

				   ,[DateCreated]
				   ,[CreatedBySystemUserID]
				   ,[DateUpdated]
				   ,[UpdatedBySystemUserID]
				   ,[ACN]
				   ,[DateOfBirth] 
	)
		SELECT [AccountablePartyID] -- Excel's PK field goes into ROW_ID
			  ,a.Row_ID -- contains the NEW AddressID's here, goes as foreign key.

			  ,[CompanyFlag]
			  ,[OrganisationName]
			  ,[TradingName]
			  ,substring(ABN, 0, 15) as [ABN]
			  ,[CompanyWebsite]

			  ,0 as [ContactRoleFlag]
			  ,null as [TitleID]
			  ,null as [Surname]
			  ,null as [Middlename]
			  ,null as [GivenName]

			  ,null as [Position]
			  ,[Phone]
			  ,null as [Mobile]
			  ,null as [AfterHoursNumber]
			  ,[Fax]

			  ,[Email]
			  ,null as [Pager]
			  , EffectiveDateFrom = getdate()
			  ,NULL

			  ,GETDATE()
			  ,1
			  ,GETDATE()
			  ,1
			  ,[ACN]
			  ,null as [DateOfBirth]
		  FROM  OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').PALMSMigrationDB.dbo.dm_tblAccountableParty ap
		  inner join OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').PALMSMigrationDB.dbo.dm_tblAddress a on ap.AddressID = a.AddressID -- the original Excel 30,001 ID's are used to join, BUT don't need to be carried forward into new tables.
		  order by a.Row_ID

      select * from @TemptblAccountableParty
end
else
begin
    --update tblAccountableParty set [ROW_ID] = null

	INSERT INTO [dbo].[tblAccountableParty]
			   (-- AccountablePartyID is auto-generated/identity
			    [ROW_ID]		-- put the original Excel AccountablePartyID's here.
			   ,[AddressID]	    -- put the newly generated AddressID's here (as a FK)

			   ,[CompanyFlag]
			   ,[OrganisationName]
			   ,[TradingName]
			   ,[ABN]
			   ,[CompanyWebsite]

			   ,[ContactRoleFlag]
			   ,[TitleID]
			   ,[Surname]
			   ,[Middlename]
			   ,[GivenName]

			   ,[Position]
			   ,[Phone]
			   ,[Mobile]
			   ,[AfterHoursNumber]
			   ,[Fax]

			   ,[Email]
			   ,[Pager]
			   , EffectiveDateFrom
			   ,[EffectiveDateTo]

			   ,[DateCreated]
			   ,[CreatedBySystemUserID]
			   ,[DateUpdated]
			   ,[UpdatedBySystemUserID]
			   ,[ACN]
			   ,[DateOfBirth] )

		SELECT [AccountablePartyID] -- Excel's PK field goes into ROW_ID
			  ,a.Row_ID -- contains the NEW AddressID's here, goes as foreign key.

			  ,[CompanyFlag]
			  ,[OrganisationName]
			  ,[TradingName]
			  ,substring(ABN, 0, 15) as [ABN]
			  ,[CompanyWebsite]

			  ,0 as [ContactRoleFlag]
			  ,null as [TitleID]
			  ,null as [Surname]
			  ,null as [Middlename]
			  ,null as [GivenName]

			  ,null as [Position]
			  ,[Phone]
			  ,null as [Mobile]
			  ,null as [AfterHoursNumber]
			  ,[Fax]

			  ,[Email]
			  ,null as [Pager]
			  , EffectiveDateFrom = getdate()
			  ,NULL

			  ,GETDATE()
			  ,1
			  ,GETDATE()
			  ,1
			  ,[ACN]
			  ,null as [DateOfBirth]
		  FROM  OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').PALMSMigrationDB.dbo.dm_tblAccountableParty ap
		  inner join OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').PALMSMigrationDB.dbo.dm_tblAddress a on ap.AddressID = a.AddressID -- the original Excel 30,001 ID's are used to join, BUT don't need to be carried forward into new tables.
		  order by a.Row_ID

	--SELECT [AccountablePartyID] -- Excel's PK field goes into ROW_ID
	--	  ,a.Row_ID -- contains the NEW AddressID's here, goes as foreign key.

	--	  ,[CompanyFlag]
	--	  ,[OrganisationName]
	--	  ,[TradingName]
	--	  ,[ABN]
	--	  ,[CompanyWebsite]

	--	  ,[ContactRoleFlag]
	--	  ,[TitleID]
	--	  ,[Surname]
	--	  ,[Middlename]
	--	  ,[GivenName]

	--	  ,[Position]
	--	  ,[Phone]
	--	  ,[Mobile]
	--	  ,[AfterHoursNumber]
	--	  ,[Fax]

	--	  ,[Email]
	--	  ,[Pager]
	--	  , EffectiveDateFrom = getdate()
	--	  ,NULL

	--	  ,GETDATE()
	--	  ,1
	--	  ,GETDATE()
	--	  ,1
	--	  ,[ACN]
	--	  ,[DateOfBirth]
	--  FROM OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB')
	--	.PALMSMigrationDB.dbo.dm_AccountableParty ap
	--  inner join OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB')
	--	.PALMSMigrationDB.dbo.dm_Address a on ap.AddressID = a.AddressID -- the original Excel 30,001 ID's are used to join, BUT don't need to be carried forward into new tables.
	--  order by a.Row_ID
end
  --  remap the new generated identities (AccountablePartyID's) with the Excel source's ID's (20,001).
  --(mapping is already in tblAccountableParty, but ROW_ID in this table is varchar, which makes it difficult to join, instead we use the dm_AccountableParty table)
   
   /*
	select * 
	from tblAccountableParty ap
		inner join  dm_AccountableParty dm_ap  on ap.row_ID = cast(dm_ap.AccountablePartyID  as varchar)
	where ap.AccountablePartyID >= 69342 -- TODO: USE VARIABLE. */

declare @newAccPartyID int


if @IsTest = 1
	begin
	    select @newAccPartyID = AccountablePartyID from @TemptblAccountableParty where row_id = '4114'
        IF (@newAccPartyID is null or @newAccPartyID = 0 or not exists(Select * From @TemptblAccountableParty where AccountablePartyID = @newAccPartyID )) BEGIN
                RAISERROR ('Error obtaining newAccountablePartyID',
					16, -- Severity.
					1 -- State.
				)
        END
	    --set source table: dm_tblAccountableParty ROW_ID equal the real accountable table: tblAccountableParty AccountablePartyID
		print 'Test accountable ID reset'
		UPDATE dm_ap
			SET dm_ap.Row_ID  = ap.AccountablePartyID
		from @TemptblAccountableParty ap
			inner join  OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').PALMSMigrationDB.dbo.dm_tblAccountableParty dm_ap on ap.row_ID = cast(dm_ap.AccountablePartyID  as varchar)
		where ap.AccountablePartyID >= @newAccPartyID
	end
else
  begin
        print 'Production accountable ID reset'
	    select @newAccPartyID = AccountablePartyID from tblAccountableParty where row_id = '4114'
        IF (@newAccPartyID is null or @newAccPartyID = 0 or not exists(Select * From tblAccountableParty where AccountablePartyID = @newAccPartyID )) BEGIN
                RAISERROR ('Error obtaining newAccountablePartyID',
					16, -- Severity.
					1 -- State.
				)
        END

		UPDATE dm_ap
			SET dm_ap.Row_ID  = ap.AccountablePartyID
		from tblAccountableParty ap
			inner join OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').PALMSMigrationDB.[dbo].dm_tblAccountableParty dm_ap  on ap.row_ID = cast(dm_ap.AccountablePartyID  as varchar)
		where ap.AccountablePartyID >= @newAccPartyID

		--UPDATE dm_ap
		--	SET dm_ap.Row_ID  = ap.AccountablePartyID
		--from tblAccountableParty ap
		--	inner join  OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB')
		--.PALMSMigrationDB.dbo.dm_AccountableParty dm_ap  on ap.row_ID = cast(dm_ap.AccountablePartyID  as varchar)
		--where ap.AccountablePartyID >= @newAccPartyID
  end

  -- STEP 6. _______________________________________________________________
  -- ***********************************************************************
print 'importing tblInstrumentAccountableParty...'
if @IsTest = 1 --test action
begin
	Declare @TemptblInstrumentAccountableParty Table
	(
		[InstrumentAccountablePartyID] [int] IDENTITY(1,1) NOT NULL,
		[InstrumentID] [int] NOT NULL,
		[AccountablePartyID] [int] NOT NULL,
		[LandownerFlag] [bit] NOT NULL,
		[DescriptionOfRelationship] [varchar](200) NULL,
		[OldAccountablePartyFlag] [bit] NULL,
		[EffectiveDateFrom] [smalldatetime] NOT NULL,
		[EffectiveDateTo] [smalldatetime] NULL,
		[DateCreated] [smalldatetime] NOT NULL,
		[CreatedBySystemUserID] [int] NOT NULL,
		[DateUpdated] [smalldatetime] NULL,
		[UpdatedBySystemUserID] [int] NULL,
		[RowTimestamp] [timestamp] NOT NULL,
		[ROW_ID] [nvarchar](15) NULL
	)
		INSERT INTO @TemptblInstrumentAccountableParty
				   ([ROW_ID] -- -- store the original PK here.
				   ,[InstrumentID]
				   ,[AccountablePartyID]
				   ,[LandownerFlag]
				   ,[DescriptionOfRelationship]
				   ,[OldAccountablePartyFlag]
				   ,[EffectiveDateFrom]
				   ,[EffectiveDateTo]
				   ,[DateCreated]
				   ,[CreatedBySystemUserID]
				   ,[DateUpdated]
				   ,[UpdatedBySystemUserID])
		SELECT [InstrumentAccountablePartyID] -- store the original PK in the ROW_ID of the target table
			  --,dm_iap.[InstrumentID] -- original FK's not required, use the new ID's
			  --,dm_iap.[AccountablePartyID] -- original FK's not required, use the new ID's
			  , dm_i.InstrumentID as newInstrumentID -- new FK's
			  , dm_ap.Row_ID as newAccountablePartyID -- new FK's
			  ,0 as [LandownerFlag]
			  ,null as [DescriptionOfRelationship]
			  ,null as [OldAccountablePartyFlag]
			  ,GETDATE() as [EffectiveDateFrom]
			  ,null as [EffectiveDateTo]
			  ,GETDATE()
			  ,1
			  ,GETDATE()
			  ,1
			  --,dm_iap.[RowTimestamp] //can't use to insert.
			  --,dm_iap.[Row_ID] //is empty in source.
		  FROM OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').PALMSMigrationDB.dbo.dm_tblInstrumentAccountableParty dm_iap
			inner join OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').PALMSMigrationDB.dbo.dm_tblInstrument dm_i on dm_iap.InstrumentID = dm_i.ROW_ID
			inner join OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').PALMSMigrationDB.dbo.dm_tblAccountableParty dm_ap on dm_iap.AccountablePartyID = dm_ap.AccountablePartyID
		  order by dm_iap.InstrumentAccountablePartyID

	      select * from @TemptblInstrumentAccountableParty
end

if @IsTest = 0 --production action
begin
    --update tblInstrumentAccountableParty set [ROW_ID] = null

	INSERT INTO [dbo].[tblInstrumentAccountableParty]
			   ([ROW_ID] -- -- store the original PK here.
			   ,[InstrumentID]
			   ,[AccountablePartyID]
			   ,[LandownerFlag]
			   ,[DescriptionOfRelationship]
			   ,[OldAccountablePartyFlag]
			   ,[EffectiveDateFrom]
			   ,[EffectiveDateTo]
			   ,[DateCreated]
			   ,[CreatedBySystemUserID]
			   ,[DateUpdated]
			   ,[UpdatedBySystemUserID])
		SELECT DISTINCT  [InstrumentAccountablePartyID] -- store the original PK in the ROW_ID of the target table
			  --,dm_iap.[InstrumentID] -- original FK's not required, use the new ID's
			  --,dm_iap.[AccountablePartyID] -- original FK's not required, use the new ID's
			  , dm_i.InstrumentID as newInstrumentID -- new FK's
			  , dm_ap.Row_ID as newAccountablePartyID -- new FK's
			  ,0 as [LandownerFlag]
			  ,null as [DescriptionOfRelationship]
			  ,null as [OldAccountablePartyFlag]
			  ,GETDATE() as [EffectiveDateFrom]
			  ,null as [EffectiveDateTo]
			  ,GETDATE()
			  ,1
			  ,GETDATE()
			  ,1
			  --,dm_iap.[RowTimestamp] //can't use to insert.
			  --,dm_iap.[Row_ID] //is empty in source.
		  FROM OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').PALMSMigrationDB.dbo.dm_tblInstrumentAccountableParty dm_iap
			inner join OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').PALMSMigrationDB.dbo.dm_tblInstrument dm_i on dm_iap.InstrumentID = dm_i.ROW_ID
			inner join OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').PALMSMigrationDB.dbo.dm_tblAccountableParty dm_ap on dm_iap.AccountablePartyID = dm_ap.AccountablePartyID
		  order by dm_iap.InstrumentAccountablePartyID

	--SELECT [InstrumentAccountablePartyID] -- store the original PK in the ROW_ID of the target table
	--	  --,dm_iap.[InstrumentID] -- original FK's not required, use the new ID's
	--	  --,dm_iap.[AccountablePartyID] -- original FK's not required, use the new ID's
	--	  , dm_i.Row_ID as newInstrumentID -- new FK's
	--	  , dm_ap.Row_ID as newAccountablePartyID -- new FK's
	--	  ,[LandownerFlag]
	--	  ,[DescriptionOfRelationship]
	--	  ,[OldAccountablePartyFlag]
	--	  ,dm_iap.[EffectiveDateFrom]
	--	  ,dm_iap.[EffectiveDateTo]
	--	  ,GETDATE()
	--	  ,1
	--	  ,GETDATE()
	--	  ,1
	--	  --,dm_iap.[RowTimestamp] //can't use to insert.
	--	  --,dm_iap.[Row_ID] //is empty in source.
	--  FROM OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB')
	--	.PALMSMigrationDB.dbo.dm_InstrumentAccountableParty dm_iap
	--	inner join OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB')
	--	.PALMSMigrationDB.dbo.dm_Instrument dm_i on dm_iap.InstrumentID = dm_i.InstrumentID
	--	inner join OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB')
	--	.PALMSMigrationDB.dbo.dm_AccountableParty dm_ap on dm_iap.AccountablePartyID = dm_ap.AccountablePartyID
	--  order by dm_iap.InstrumentAccountablePartyID
end


-- STEP 7. _______________________________________________________________
-- ***********************************************************************
print 'importing tblContact...'

if @IsTest = 1 --test action
begin
	Declare @TemptblContact Table
	(
		[ContactID] [int] IDENTITY(1,1) NOT NULL,
		[TitleID] [smallint] NULL,
		[Surname] [varchar](60) NULL,
		[GivenName] [varchar](60) NULL,
		[OrganisationName] [varchar](128) NULL,
		[Position] [varchar](128) NULL,
		[AddressID] [int] NULL,
		[Phone] [varchar](20) NULL,
		[Mobile] [varchar](20) NULL,
		[AfterHoursNumber] [varchar](20) NULL,
		[Fax] [varchar](20) NULL,
		[Email] [varchar](128) NULL,
		[Pager] [varchar](20) NULL,
		[EffectiveDateFrom] [smalldatetime] NOT NULL,
		[EffectiveDateTo] [smalldatetime] NULL,
		[DateCreated] [smalldatetime] NOT NULL,
		[CreatedBySystemUserID] [int] NOT NULL,
		[DateUpdated] [smalldatetime] NULL,
		[UpdatedBySystemUserID] [int] NULL,
		[RowTimestamp] [timestamp] NOT NULL,
		[Middlename] [varchar](60) NULL,
		[ROW_ID] [nvarchar](15) NULL
	)

	INSERT INTO @TemptblContact(
			-- ContactID is auto-generated/identity
			 [ROW_ID] -- put the original Excel ContactID here. (70,001)
			,[AddressID] -- put the newly generated AddressID's here (as a FK)

			,[TitleID] 
			,[Surname]
			,[Middlename]
			,[GivenName]
			,[OrganisationName]

			,[Position]
			,[Phone]
			,[Mobile]
			,[AfterHoursNumber]
			,[Fax]

			,[Email]
			,[Pager]
			,[EffectiveDateFrom]
			,[EffectiveDateTo]
			,[DateCreated]
			,[CreatedBySystemUserID]
			,[DateUpdated]
			,[UpdatedBySystemUserID]
		)
		SELECT distinct d.[ContactID] -- Excel's PK field goes into ROW_ID of target table.
			  ,d.[ROW_ID]  -- contains the NEW AddressID's here, goes as foreign key.

			  ,null as [TitleID]
			  ,null as [Surname]
			  ,null as [Middlename]
			  ,null as [GivenName]
			  ,b.[OrganisationName]

			  ,null as [Position]
			  ,b.[Phone]
			  ,null as [Mobile]
			  ,null as [AfterHoursNumber]
			  ,b.[Fax]

			  ,[Email]
			  ,null as [Pager]
			  ,[EffectiveDateFrom] = getdate()
			  ,NULL
			  ,GETDATE()
			  ,1
			  ,GETDATE()
			  ,1
		  FROM OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').PALMSMigrationDB.dbo.[dm_tblInstrumentContact] a
		  inner join OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').PALMSMigrationDB.dbo.dm_tblContact d on a.ContactID = d.ContactID
		  left outer join OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').PALMSMigrationDB.dbo.dm_tblAccountableParty b on a.[accountable party ID] = b.AccountablePartyID
		  left outer join OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').PALMSMigrationDB.dbo.dm_tblAddress c on a.[addressID] = c.AddressId -- the original Excel 35,001 ID's are used to join, BUT don't need to be carried forward into new tables.

		  select * from @TemptblContact
end


if @IsTest = 0 --production action
begin
    --update [tblContact] set [ROW_ID] = null

	INSERT INTO [dbo].[tblContact] (
		-- ContactID is auto-generated/identity
		 [ROW_ID] -- put the original Excel ContactID here. (70,001)
		,[AddressID] -- put the newly generated AddressID's here (as a FK)

		,[TitleID] 
		,[Surname]
		,[Middlename]
		,[GivenName]
		,[OrganisationName]

		,[Position]
		,[Phone]
		,[Mobile]
		,[AfterHoursNumber]
		,[Fax]

		,[Email]
		,[Pager]
		,[EffectiveDateFrom]
		,[EffectiveDateTo]
		,[DateCreated]
		,[CreatedBySystemUserID]
		,[DateUpdated]
		,[UpdatedBySystemUserID]
	)

		SELECT distinct 
		        d.[ContactID] -- Excel's PK field goes into ROW_ID of target table.
			  ,d.[ROW_ID]  -- contains the NEW ContactID's here, goes as foreign key.

			  ,null as [TitleID]
			  ,null as [Surname]
			  ,null as [Middlename]
			  ,null as [GivenName]
			  ,b.[OrganisationName]

			  ,null as [Position]
			  ,b.[Phone]
			  ,null as [Mobile]
			  ,null as [AfterHoursNumber]
			  ,b.[Fax]

			  ,[Email]
			  ,null as [Pager]
			  ,[EffectiveDateFrom] = getdate()
			  ,NULL
			  ,GETDATE()
			  ,1
			  ,GETDATE()
			  ,1
		  FROM OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').PALMSMigrationDB.dbo.[dm_tblInstrumentContact] a
		  inner join OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').PALMSMigrationDB.dbo.dm_tblContact d on a.ContactID = d.ContactID
		  left outer join OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').PALMSMigrationDB.dbo.dm_tblAccountableParty b on a.[accountable party ID] = b.AccountablePartyID
		  left outer join OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').PALMSMigrationDB.dbo.dm_tblAddress c on a.[addressID] = c.AddressId -- the original Excel 35,001 ID's are used to join, BUT don't need to be carried forward into new tables.

	--SELECT [ContactID] -- Excel's PK field goes into ROW_ID of target table.
	--	  , a.Row_ID -- contains the NEW AddressID's here, goes as foreign key.

	--	  ,[TitleID]
	--	  ,[Surname]
	--	  ,c.[Middlename]
	--	  ,[GivenName]
	--	  ,[OrganisationName]

	--	  ,[Position]
	--	  ,[Phone]
	--	  ,[Mobile]
	--	  ,[AfterHoursNumber]
	--	  ,[Fax]

	--	  ,[Email]
	--	  ,[Pager]
	--	  ,[EffectiveDateFrom] = getdate()
	--	  ,NULL
	--	  ,GETDATE()
	--	  ,1
	--	  ,GETDATE()
	--	  ,1
	--  FROM OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB')
	--	.PALMSMigrationDB.dbo.dm_Contact c
	--  inner join OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB')
	--	.PALMSMigrationDB.dbo.dm_Address a on c.AddressID = a.AddressID -- the original Excel 35,001 ID's are used to join, BUT don't need to be carried forward into new tables.
	--  order by a.Row_ID   
end

	  --  remap the new generated identities (ContactID's) with the Excel source's ID's (70,001).
	  --(mapping is already in tblContact, but ROW_ID in this table is varchar, which makes it difficult to join, instead we use the dm_Contact table)

		/*
		select * 
		from tblContact c
			inner join  dm_Contact dm_c  on c.row_ID = cast(dm_c.ContactID as varchar)
		where c.ContactID >= 100000 -- TODO: USE VARIABLE. */
	  declare @newContactID int


if @IsTest = 1
begin
        print 'testing tblContact ID reset'
	  select @newContactID = ContactID from @TemptblContact where row_id = '100000'
			IF (@newContactID is null or @newContactID = 0 or not exists(Select * From @TemptblContact where ContactID = @newContactID )) BEGIN
					RAISERROR ('Error obtaining newContactID',
						16, -- Severity.
						1 -- State.
					)
			END

		UPDATE dm_c
			SET dm_c.Row_ID  = c.ContactID
		from @TemptblContact c
			inner join OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').PALMSMigrationDB.dbo.dm_tblContact dm_c  on c.row_ID = cast(dm_c.ContactID as varchar)
		where c.ContactID >= @newContactID 
end

if @IsTest = 0
begin
        print 'production tblContact ID reset'
	  select @newContactID = ContactID from [tblContact] where row_id = '100000'
			IF (@newContactID is null or @newContactID = 0 or not exists(Select * From [tblContact] where ContactID = @newContactID )) BEGIN
					RAISERROR ('Error obtaining newContactID',
						16, -- Severity.
						1 -- State.
					)
			END

		UPDATE dm_c
			SET dm_c.Row_ID  = c.ContactID
		from tblContact c
			inner join  OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').PALMSMigrationDB.dbo.dm_tblContact dm_c  on c.row_ID = cast(dm_c.ContactID as varchar)
		where c.ContactID >= @newContactID 
end


-- STEP 8. _______________________________________________________________
-- ***********************************************************************
print 'importing tblInstrumentContact...'
if @IsTest = 1
begin
	declare @TemptblInstrumentContact table
	(
		[InstrumentContactID] [int] IDENTITY(1,1) NOT NULL,
		[InstrumentID] [int] NOT NULL,
		[ContactID] [int] NOT NULL,
		[PostalContactFlag] [bit] NOT NULL,
		[EmailContactFlag] [bit] NOT NULL,
		[DateCreated] [smalldatetime] NOT NULL,
		[CreatedBySystemUserID] [int] NOT NULL,
		[DateUpdated] [smalldatetime] NULL,
		[UpdatedBySystemUserID] [int] NULL,
		[RowTimestamp] [timestamp] NOT NULL,
		[ROW_ID] [nvarchar](15) NULL
	)

		  --,ic.[InstrumentID] -- original FK's not required, use the new ID's
		  --,ic.[ContactID]	-- original FK's not required, use the new ID's

	INSERT INTO @TemptblInstrumentContact
			   (
			    [ROW_ID] -- store the source Excel's PK here. (85,001)
			   ,[InstrumentID]
			   ,[ContactID]
			   ,[PostalContactFlag]
			   ,[EmailContactFlag]
			   ,[DateCreated]
			   ,[CreatedBySystemUserID]
			   ,[DateUpdated]
			   ,[UpdatedBySystemUserID])
	SELECT 
	       [InstrumentContactID] -- store the original PK in the ROW_ID of the target table
		  ,i.InstrumentID as newInstrumentID -- new FK's
		  ,c.ROW_ID as newContactID -- new FK's

		  ,1 as [PostalContactFlag]
		  ,0 as [EmailContactFlag]
		  ,GETDATE()
		  ,1
		  ,GETDATE()
		  ,1
		  --,ic.[RowTimestamp] //can't use to insert.
		  --,ic.[Row_ID] //is empty in source.
	  FROM  OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').PALMSMigrationDB.dbo.dm_tblInstrumentContact ic
		inner join OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').PALMSMigrationDB.dbo.dm_tblInstrument i on ic.ROW_ID = i.ROW_ID
		inner join OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').PALMSMigrationDB.dbo.dm_tblContact c on ic.ContactID = c.ContactID
	order by ic.InstrumentContactID

	select * from @TemptblInstrumentContact
end

if @IsTest = 0
begin
	INSERT INTO [dbo].[tblInstrumentContact]
			   ([ROW_ID] -- store the source Excel's PK here. (85,001)
			   ,[InstrumentID]
			   ,[ContactID]
			   ,[PostalContactFlag]
			   ,[EmailContactFlag]
			   ,[DateCreated]
			   ,[CreatedBySystemUserID]
			   ,[DateUpdated]
			   ,[UpdatedBySystemUserID])
	SELECT 
	       [InstrumentContactID] -- store the original PK in the ROW_ID of the target table
		  ,i.InstrumentID as newInstrumentID -- new FK's
		  ,c.ROW_ID as newContactID -- new FK's

		  ,1 as [PostalContactFlag]
		  ,0 as [EmailContactFlag]
		  ,GETDATE()
		  ,1
		  ,GETDATE()
		  ,1
		  --,ic.[RowTimestamp] //can't use to insert.
		  --,ic.[Row_ID] //is empty in source.
	  FROM  OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').PALMSMigrationDB.dbo.dm_tblInstrumentContact ic
		inner join OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').PALMSMigrationDB.dbo.dm_tblInstrument i on ic.ROW_ID = i.ROW_ID
		inner join OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').PALMSMigrationDB.dbo.dm_tblContact c on ic.ContactID = c.ContactID
	order by ic.InstrumentContactID

	--SELECT [InstrumentContactID] -- store the original PK in the ROW_ID of the target table
	--	  --,ic.[InstrumentID] -- original FK's not required, use the new ID's
	--	  --,ic.[ContactID]	-- original FK's not required, use the new ID's
	--	  ,i.Row_ID as newInstrumentID -- new FK's
	--	  ,c.Row_ID as newContactID -- new FK's

	--	  ,[PostalContactFlag]
	--	  ,[EmailContactFlag]
	--	  ,GETDATE()
	--	  ,1
	--	  ,GETDATE()
	--	  ,1
	--	  --,ic.[RowTimestamp] //can't use to insert.
	--	  --,ic.[Row_ID] //is empty in source.
	--  FROM OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB')
	--	.PALMSMigrationDB.dbo.dm_InstrumentContact ic
	--	inner join OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB')
	--	.PALMSMigrationDB.dbo.dm_Instrument i on ic.InstrumentID = i.InstrumentID
	--	inner join OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB')
	--	.PALMSMigrationDB.dbo.dm_Contact c on ic.ContactID = c.ContactID
	--order by ic.InstrumentContactID
end

-- STEP 9. tblDGDesignApprovalTankMake _______________________________________________________________
-- ***********************************************************************
if @IsTest = 1
begin
	declare @TemptblDGDesignApprovalTankMake table
	(
		[DGDesignApprovalTankMakeID] [int] IDENTITY(1,1) NOT NULL,
		[InstrumentID] [int] NOT NULL,
		[DGTankMakeID] [smallint] NOT NULL,
		[DateCreated] [smalldatetime] NOT NULL,
		[CreatedBySystemUserID] [int] NOT NULL,
		[DateUpdated] [smalldatetime] NULL,
		[UpdatedBySystemUserID] [int] NULL,
		[RowTimestamp] [timestamp] NOT NULL
	)

	insert into @TemptblDGDesignApprovalTankMake
	(
	[InstrumentID],
	[DGTankMakeID],
	[DateCreated],
	[CreatedBySystemUserID],
	[DateUpdated],
	[UpdatedBySystemUserID]
	)
	select 
	b.InstrumentID,
	a.DGTankMakeID,
	getdate() as  [DateCreated],
	1 as [CreatedBySystemUserID],
	getdate() as [DateUpdated],
	1 as [UpdatedBySystemUserID]
	from dm_tblDGDesignApprovalDGTankMake a inner join dm_tblDGDesignApproval b
	on a.DGDesignApprovalID = b.DesignApprovalID 
	where b.InstrumentID is not null

	select * from  @TemptblDGDesignApprovalTankMake
end

if @IsTest = 0 --production run: tblDGDesignApprovalTankMake
begin
	 
	insert into tblDGDesignApprovalTankMake
	(
	[InstrumentID],
	[DGTankMakeID],
	[DateCreated],
	[CreatedBySystemUserID],
	[DateUpdated],
	[UpdatedBySystemUserID]
	)
	select 
	b.InstrumentID,
	a.DGTankMakeID,
	getdate() as  [DateCreated],
	1 as [CreatedBySystemUserID],
	getdate() as [DateUpdated],
	1 as [UpdatedBySystemUserID]
	from OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').PALMSMigrationDB.dbo.dm_tblDGDesignApprovalDGTankMake a inner join OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').PALMSMigrationDB.dbo.dm_tblDGDesignApproval b
	on a.DGDesignApprovalID = b.DesignApprovalID 
	where b.InstrumentID is not null

	select * from  tblDGDesignApprovalTankMake where [InstrumentID] > @newInstrumentID
end

-- STEP 10. tblDGDesignApprovalVehicleMake _______________________________________________________________
-- ***********************************************************************
if @IsTest = 1
begin
	declare @TemptblDGDesignApprovalVehicleMake table
	(
		[DGDesignApprovalVehicleMakeID] [int] IDENTITY(1,1) NOT NULL,
		[InstrumentID] [int] NOT NULL,
		[DGVehicleMakeID] [smallint] NOT NULL,
		[DateCreated] [smalldatetime] NOT NULL,
		[CreatedBySystemUserID] [int] NOT NULL,
		[DateUpdated] [smalldatetime] NULL,
		[UpdatedBySystemUserID] [int] NULL,
		[RowTimestamp] [timestamp] NOT NULL
	)
	insert into @TemptblDGDesignApprovalVehicleMake
	(
	[InstrumentID],
	[DGVehicleMakeID],
	[DateCreated],
	[CreatedBySystemUserID],
	[DateUpdated],
	[UpdatedBySystemUserID]
	)
	select 
	b.InstrumentID,
	a.DGVehicleMakeID,
	getdate() as  [DateCreated],
	1 as [CreatedBySystemUserID],
	getdate() as [DateUpdated],
	1 as [UpdatedBySystemUserID]
	from dm_tblDGDesignApprovalDGVehicleMake a inner join dm_tblDGDesignApproval b
	on a.DGDesignApprovalID = b.DesignApprovalID 
	where b.InstrumentID is not null

	select * from @TemptblDGDesignApprovalVehicleMake
end

if @IsTest = 0
begin	 
	insert into tblDGDesignApprovalVehicleMake
	(
	[InstrumentID],
	[DGVehicleMakeID],
	[DateCreated],
	[CreatedBySystemUserID],
	[DateUpdated],
	[UpdatedBySystemUserID]
	)
	select 
	b.InstrumentID,
	a.DGVehicleMakeID,
	getdate() as  [DateCreated],
	1 as [CreatedBySystemUserID],
	getdate() as [DateUpdated],
	1 as [UpdatedBySystemUserID]
	from OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').PALMSMigrationDB.dbo.dm_tblDGDesignApprovalDGVehicleMake a inner join OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').PALMSMigrationDB.dbo.dm_tblDGDesignApproval b
	on a.DGDesignApprovalID = b.DesignApprovalID 
	where b.InstrumentID is not null

	select * from tblDGDesignApprovalVehicleMake where [InstrumentID] > @newInstrumentID
end


--FINALLY we clean up all temp tables if it is testing case
if @IsTest = 1
begin
    delete @TemptblInstrument
	delete @TemptblDGDesignApprovalTankMake
	delete @TemptblDGDesignApprovalVehicleMake
end

--IssuedDate on tblInstrument table to set it by completeddate on tblDGDesignApproval
 --update a
 --set a.DateIssued = b.DateApplicationCompleted
 --from tblInstrument a  inner join tblDGDesignApproval b on a.InstrumentID = b.InstrumentID 
 --where InstrumentTypeID = 990 and datepart(day, a.DateCreated) = 22 and datepart(month, a.DateCreated) = 10 and datepart(year, a.DateCreated) = 2015 

print 'Done!'
