declare @InstrumentID int
set @InstrumentID = 20573

--Declare a tamp table to hold temp data
--List data from PALMSDB tblInstrumentAccountableParty
DECLARE @MyTable TABLE (
    SNo int IDENTITY (1, 1),
    AccountablePartyID int
)
INSERT INTO @MyTable(AccountablePartyID)
SELECT DISTINCT [AccountablePartyID]
FROM  OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').[PALMSDB].[dbo].[tblInstrumentAccountableParty]
WHERE [InstrumentID] = @InstrumentID AND OldAccountablePartyFlag = 0 AND EffectiveDateTo is null   

-------------------------- Get PALMS tblAccountableParty data 
DECLARE @MyTableAP TABLE (
    [SNo] int IDENTITY (1, 1),
    [AccountablePartyID] int,
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
	[ACN] [varchar](20) NULL,
	[DateOfBirth] DATETIME NULL,
	[Middlename]  [varchar](60) NULL 
)

INSERT INTO @MyTableAP
SELECT [AccountablePartyID]
      ,[CompanyFlag]
      ,[OrganisationName]
      ,[TradingName]
      ,[ABN]
      ,[CompanyWebsite]
      ,[ContactRoleFlag]
      ,[TitleID]
      ,[Surname]
      ,[GivenName]
      ,[Position]
      ,[AddressID]
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
      ,[ACN]
      ,[DateOfBirth]
      ,[Middlename]
	  
FROM 
OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').[PALMSDB].[dbo].[tblAccountableParty] 
WHERE  [AccountablePartyID] IN (SELECT [AccountablePartyID] FROM @MyTable) 

DECLARE @IsCompanyFlag BIT
DECLARE @AccountablePartyID INT
DECLARE @AddressID INT

--select * FROM @MyTableAP

-------------------------- Get PALMS tblAddress data 
SELECT TOP 1 @IsCompanyFlag = [CompanyFlag], @AccountablePartyID = AccountablePartyID FROM @MyTableAP
--PRINT '@IsCompanyFlag=' + cast(@IsCompanyFlag as varchar)

IF @IsCompanyFlag = 1 
BEGIN
     --Get ContactID 
	 DECLARE @ContactID INT
	 SELECT @ContactID = ContactID FROM OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').[PALMSDB].[dbo].[tblInstrumentContact] WHERE InstrumentID = @InstrumentID and PostalContactFlag = 1	 
	 SELECT @AddressID = AddressID FROM OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').[PALMSDB].[dbo].[tblContact] WHERE ContactID = @ContactID	 
END 

IF @IsCompanyFlag = 0
BEGIN     
	 SELECT @AddressID = AddressID FROM @MyTableAP
END

SELECT * FROM OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').[PALMSDB].[dbo].[tblAddress] WHERE AddressID = @AddressID

-------------------------- Get PALMS tblLocation data 
DECLARE @SiteName varchar(255)
DECLARE @APName varchar(128)  
DECLARE @ACN_ARBN char(15)
DECLARE @StreetAddress varchar(100)
DECLARE @Suburb varchar(50)
DECLARE @PostCode varchar(4)
DECLARE @StateCode varchar(4)

if exists(select b.LocationName 
from OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').[PALMSDB].[dbo].[tblInstrumentLocation] a
left outer join OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').[PALMSDB].[dbo].[tblLocation] b on a.LocationID = b.LocationID 
where InstrumentID = @InstrumentID)
BEGIN
     select @SiteName = b.LocationName 
		from OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').[PALMSDB].[dbo].[tblInstrumentLocation] a
		left outer join OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').[PALMSDB].[dbo].[tblLocation] b on a.LocationID = b.LocationID 
		where InstrumentID = @InstrumentID
END
ELSE
BEGIN	  
    select @APName = (CASE WHEN b.CompanyFlag = 1 THEN b.OrganisationName ELSE b.GivenName + case b.Middlename when null then '' when '' then '' else b.Middlename + ' ' end + b.Surname END),
	       @ACN_ARBN = isnull(ltrim(rtrim(case isnull(ACN, '') when null then (case ABN when null then '' when '' then '' else ABN end) when '' then (case ABN when null then '' when '' then '' else ABN end) else ACN end)), '')  
	from @MyTableAP b

	select @SiteName = @APName + ' - ' + @Suburb
END

select 
@StreetAddress = [Address],
@Suburb = Suburb,
@PostCode = PostCode,
@StateCode = StateCode 
FROM OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').[PALMSDB].[dbo].[tblAddress] WHERE AddressID = @AddressID


-------------------------- Get Final General data 
DECLARE @MyTableFinal TABLE 
(   
    AccountablePartyID int,
	TradingName varchar(128),
	ACN_ARBN char(15),
	StreetAddress varchar(100),
	Suburb varchar(50),
	PostCode varchar(4),
	StateCode varchar(4)
)
INSERT INTO @MyTableFinal
SELECT 
@AccountablePartyID as AccountablePartyID,
@APName as TradingName,
@ACN_ARBN as ACN_ARBN,
@StreetAddress as StreetAddress,
@Suburb as Suburb,
@PostCode as PostCode,
@StateCode as StateCode


select * from @MyTableFinal

-------------------------- Copy Final data into WDS
DECLARE @InstrumentStatusID INT
select @InstrumentStatusID = InstrumentStatusID 
from OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').[PALMSDB].[dbo].[tblInstrument] where InstrumentID = @InstrumentID

print '@InstrumentStatusID = ' + cast(@InstrumentStatusID as varchar)
 
