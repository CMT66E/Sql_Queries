--Testing falg
declare @IsTesting bit = 0

--define the temp table
declare @DataMigrationRMLUserProfile table 
(
	[UserName] [nvarchar](255) NULL,
	[FirstName] [nvarchar](255) NULL,
	[LastName] [nvarchar](255) NULL,
	[Gender] [nvarchar](255) NULL,
	[DateOfBirth] [nvarchar](255) NULL,
	[Email] [nvarchar](255) NULL,
	[EmailNickName] [nvarchar](255) NULL,
	[HomePhone] [nvarchar](255) NULL,
	[MobilePhone] [nvarchar](255) NULL,
	[Password] [nvarchar](255) NULL,
	[ApplicationRoles] [nvarchar](255) NULL,
	[CreatedBy] [nvarchar](255) NULL,
	[AccountablePartyID] [nvarchar](255) NULL,
	[LicenceNo] [float] NULL,
	[ProfileID] [float] NULL,
	[AccountablePartyID1] [float] NULL
)

--loop through all email contact data total: 1999 records
 
DECLARE @MyTable TABLE
(
SNo int IDENTITY(1,1), 
InstrumentID int,
ContactID int
) 
INSERT INTO @MyTable(InstrumentID, ContactID)
select a.InstrumentID, c.ContactID 
from tblRadiationLicence a
inner join tblInstrument b on a.InstrumentID = b.InstrumentID
left outer join tblInstrumentContact c on b.InstrumentID = c.InstrumentID
where a.RadiationLicenceTypeID = 796 
and b.InstrumentStatusID = 755
and c.EmailContactFlag = 1 
group by a.InstrumentID, c.ContactID 	

declare @Cnt int
SELECT @Cnt = MIN(Sno) FROM @MyTable
	
declare @TempInstrumentID int
declare @TempContactID int
declare @EmailTemp varchar(200)
declare @TempAccountablePartyID int = 0

WHILE (1=1)
BEGIN
   
SELECT @TempInstrumentID = InstrumentID, @TempContactID = ContactID FROM @MyTable
WHERE SNo = @Cnt
	    
IF @@ROWCOUNT = 0
	BREAK

	if exists(select * from tblContact where cast(ContactID as varchar) = cast(@TempContactID as varchar))
	begin
	    select @EmailTemp = Email from tblContact where cast(ContactID as varchar) = cast(@TempContactID as varchar)
        select top 1 @TempAccountablePartyID = AccountablePartyID from tblInstrumentAccountableParty
        where InstrumentID = @TempInstrumentID

		print '@TempInstrumentID =' + cast(@TempInstrumentID as varchar)
		print '@TempContactID =' + cast(@TempContactID as varchar)
		print '---------------------------------------------'
				 		  
		if @IsTesting = 1 and not exists(select * from @DataMigrationRMLUserProfile where LicenceNo=@TempInstrumentID and Email=@EmailTemp) 
		begin
		    print 'insert data into temp @DataMigrationRMLUserProfile'
			insert into @DataMigrationRMLUserProfile
			(
			[UserName],
			[FirstName],
			[LastName],	
			[Email],
			[HomePhone],
			[MobilePhone],
			[Password],
			[ApplicationRoles],
			[CreatedBy],
			[AccountablePartyID],
			[LicenceNo],
			[ProfileID],
			[AccountablePartyID1]		   
			)
			select
			@EmailTemp as [UserName],
			GivenName,
			Surname,
			@EmailTemp as [Email],
			Phone,
			Mobile,
			'pwd321#' as [Password],
			'G-SE-AAD-B2C-PALMSOnline-Superuser-Dev' as [ApplicationRoles],
			1 as [CreatedBy],
			@TempAccountablePartyID as [AccountablePartyID],
			@TempInstrumentID as [LicenceNo],
			1 as [ProfileID],
			@TempAccountablePartyID as [AccountablePartyID1]
			from tblContact 
			where cast(ContactID as varchar) = cast(@TempContactID as varchar)
		end

		  if @IsTesting = 0 
		    and NOT exists(
			 select * from OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').[PALMSDB].[dbo].DataMigrationRMLUserProfile
			 where [UserName] = @EmailTemp and [LicenceNo] = @TempInstrumentID
			)
		  begin
			  insert into OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').[PALMSDB].[dbo].DataMigrationRMLUserProfile
			  (
				[UserName],
				[FirstName],
				[LastName],	
				[Email],
				[HomePhone],
				[MobilePhone],
				[Password],
				[ApplicationRoles],
				[CreatedBy],
				[AccountablePartyID],
				[LicenceNo],
				[ProfileID],
				[AccountablePartyID1]		   
			  )
			  select
				@EmailTemp as [UserName],
				GivenName,
				Surname,
				@EmailTemp as [Email],
				Phone,
				Mobile,
				'pwd321#' as [Password],
				'G-SE-AAD-B2C-PALMSOnline-Superuser-Dev' as [ApplicationRoles],
				1 as [CreatedBy],
				@TempAccountablePartyID as [AccountablePartyID],
				@TempInstrumentID as [LicenceNo],
				1 as [ProfileID],
				@TempAccountablePartyID as [AccountablePartyID1]
			  from tblContact 
			  where cast(ContactID as varchar) = cast(@TempContactID as varchar)
		  end
	end
 
SELECT @Cnt = @Cnt + 1
		
END

if @IsTesting = 1
    select * from @DataMigrationRMLUserProfile

if @IsTesting = 0
    select * from OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').[PALMSDB].[dbo].DataMigrationRMLUserProfile

------------------------------------------------------------------------------------------------------------
--select * from [DataMigrationRMLUserProfile]

--delete from [DataMigrationRMLUserProfile]
--where rtrim(ltrim([UserName])) <> 'theresa.yih@cibiotecheeeeeee.com.au'
------------------------------------------------------------------------------------------------------------