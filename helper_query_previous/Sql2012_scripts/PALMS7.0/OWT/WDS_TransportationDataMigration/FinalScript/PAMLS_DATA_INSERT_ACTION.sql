--Scripts for data integration from PALMS database to WDS database
--Eric He 27-01-2016

--PALMSDB actions:
--1. PALMSDB we need insert address data into tblAddress and create new AddressID
--2. Then we can insert data into tblTransporterLocation
--3. We insert data into tblInstrumentTransporterLocation

--select * from OWT_tblAddress  -- total 396 rows: AddressID 100395 has no record in OWT_tblTransporterLocation
--select * from OWT_tblTransporterLocation --total 395 rows
--select AddressID from OWT_tblAddress where NOT AddressID IN (select AddressID from OWT_tblTransporterLocation)

------------------------------------------------------------------------------------------------------------------------------
--we define temp tables for testing purpose
--DECLARE @tblAddress TABLE
--(
--	[AddressID] [int] IDENTITY(1,1) NOT NULL,
--	[Address] [varchar](100) NULL,
--	[Suburb] [varchar](50) NOT NULL,
--	[Postcode] [varchar](10) NULL,
--	[StateCode] [varchar](20) NULL,
--	[DateCreated] [smalldatetime] NOT NULL,
--	[CreatedBySystemUserID] [int] NOT NULL,
--	[DateUpdated] [smalldatetime] NULL,
--	[UpdatedBySystemUserID] [int] NULL,
--	[RowTimestamp] [timestamp] NOT NULL,
--	[OverseasAddressFlag] [bit] NOT NULL,
--	[Country] [varchar](100) NULL,
--	[PrefixAddress] [varchar](100) NULL, 
--	[ROW_ID] [nvarchar](10) NULL
--)

--DECLARE @tblTransporterLocation TABLE
--(
--	[TransporterLocationID] [int] IDENTITY(1,1) NOT NULL,
--	[LocationName] [varchar](128) NOT NULL,
--	[AddressID] [int] NOT NULL,
--	[AdditionalAddressInformation] [varchar](1000) NULL,
--	[Notes] [varchar](1000) NULL,
--	[EffectiveDateFrom] [smalldatetime] NOT NULL,
--	[EffectiveDateTo] [smalldatetime] NULL,
--	[DateCreated] [smalldatetime] NOT NULL,
--	[CreatedBySystemUserID] [int] NOT NULL,
--	[DateUpdated] [smalldatetime] NULL,
--	[UpdatedBySystemUserID] [int] NULL,
--	[RowTimestamp] [timestamp] NOT NULL
--)

--DECLARE @tblInstrumentTransporterLocation TABLE
--(
--	[InstrumentTransporterLocationID] [int] IDENTITY(1,1) NOT NULL,
--	[InstrumentID] [int] NOT NULL,
--	[TransporterLocationID] [int] NOT NULL,
--	[DateCreated] [smalldatetime] NOT NULL,
--	[CreatedBySystemUserID] [int] NOT NULL,
--	[DateUpdated] [smalldatetime] NULL,
--	[UpdatedBySystemUserID] [int] NULL,
--	[RowTimestamp] [timestamp] NOT NULL
--)
------------------------------------------------------------------------------------------------------------------------------
BEGIN TRANSACTION


DECLARE @MyTable1 TABLE
(
SNo int IDENTITY(1,1), 
AddressID int 
)    
INSERT INTO @MyTable1(AddressID)	    
SELECT AddressID 
from [dbo].[OWT_tblAddress] 




declare @Cnt1 int
SELECT @Cnt1 = MIN(Sno) FROM @MyTable1

declare @CreatedBySystemUserID int
set @CreatedBySystemUserID = 1 
	
declare @NewAddressID int
set @NewAddressID = 0

declare @TempAddressID int
 
WHILE (1=1)
BEGIN
   
SELECT @TempAddressID = AddressID FROM @MyTable1
WHERE SNo = @Cnt1
 
IF @@ROWCOUNT = 0
	BREAK

	if @TempAddressID > 0  
	begin
		--print '@TempAddressID =' + cast(@TempAddressID as varchar)	 
		--print '---------------------------------------------'
	    
		set @NewAddressID = 0 --Reset this addressID on every loop starts

		insert into tblAddress
		(
			[Address],
			Suburb,
			Postcode,
			StateCode,
			DateCreated,
			CreatedBySystemUserID,
			DateUpdated,
			UpdatedBySystemUserID,
			OverseasAddressFlag,
			Country,
			PrefixAddress,
			ROW_ID
		)
		select 
			[Address],
			Suburb,
			Postcode,
			Statecode,
			GetDate(),
			@CreatedBySystemUserID as CreatedBySystemUserID,
			null as DateUpdated,
			null as UpdatedBySystemUserID,
			0 as OverseasAddressFlag,
			'AUSTRALIA' as Country,
			null as PrefixAddress,
			cast(AddressID as varchar) as ROW_ID
		from OWT_tblAddress
		WHERE AddressID = @TempAddressID
		
		select @NewAddressID = @@IDENTITY

		--Here we start insert into tblTransporterLocation table
		--we need TransporterLocationID and AddressID from table: OWT_tblTransporterLocation
		declare @OWTTransporterLocationID int
		declare @NewTransporterLocationID int

		insert into tblTransporterLocation
		(
			LocationName,
			AddressID,
			AdditionalAddressInformation,
			Notes,
			EffectiveDateFrom,
			EffectiveDateTo,
			DateCreated,
			CreatedBySystemUserID
		)
		select 
			LocationName,
			@NewAddressID as AddressID,
			AdditionalAddressInformation as AdditionalAddressInformation,
			null as Notes,
			GetDate() as EffectiveDateFrom,
			null as EffectiveDateTo,
			GetDate() as DateCreated,
			@CreatedBySystemUserID as CreatedBySystemUserID
		from OWT_tblTransporterLocation	
		where AddressID = @TempAddressID
		
		select @NewTransporterLocationID = MAX(TransporterLocationID) from tblTransporterLocation
		--select @NewTransporterLocationID = @@IDENTITY	--When using it second time it is working properly

		--here we get old TransporterLocationID from OWT_tblTransporterLocation
		 
		select @OWTTransporterLocationID = TransporterLocationID
		from OWT_tblTransporterLocation
		where AddressID = @TempAddressID

		declare @CurrentInstrumentID int
		select @CurrentInstrumentID = InstrumentID from OWT_tblInstrumentTransporterLocation where TransporterLocationID = @OWTTransporterLocationID

		--Here we start insert into tblInstrumentTransporterLocation table
		if exists(select InstrumentID from tblInstrument where InstrumentID = @CurrentInstrumentID)
		begin
			insert into tblInstrumentTransporterLocation
			(
				InstrumentID,
				TransporterLocationID,
				DateCreated,
				CreatedBySystemUserID
			)
			select 
				InstrumentID,
				@NewTransporterLocationID as TransporterLocationID,
				getdate() as DateCreated,
				@CreatedBySystemUserID as CreatedBySystemUserID
			from OWT_tblInstrumentTransporterLocation
			where TransporterLocationID = @OWTTransporterLocationID
		end
	end 
SELECT @Cnt1 = @Cnt1 + 1
		
END

COMMIT TRANSACTION 

--select * from @tblAddress 
--select * from @tblTransporterLocation
--select * from @tblInstrumentTransporterLocation
------------------------------------------------------------------------------------------------------------------------------
