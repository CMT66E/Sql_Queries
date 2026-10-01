--Scripts for data integration from PALMS database to WDS database
--Eric He 27-01-2016

--PALMSDB actions:
--1. PALMSDB we need insert address data into tblAddress and create new AddressID
--2. Then we can insert data into tblTransporterLocation
--3. We insert data into tblInstrumentTransporterLocation

--WDS actions:
--1. we update Site table in WDS by linking it with PALMS PALMSLocationID
--2. we update Customer table by linking CustomerID in WDS to PALMSAccountablePartyID from PALMS

--Here we do some checking data from PALMS and WDS
-----------------------------------------------------------------------------------------------------------
--Customer TABLE:
--select * from tblAccountableParty where AccountablePartyID in 
--(
--select PALMSAccountablePartyID from OWT_Customer
--)

--select * from OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=OEH30612\OEH30612_SQL2012;UID=sa;PWD=eric12345@').[WDS].[dbo].[Customer] 
--where CustomerID in
--(
--  select CustomerID from OWT_Customer
--)
-----------------------------------------------------------------------------------------------------------
--Site TABLE:
--select * from tblLocation where LocationID in 
--(
--	select PALMSLocationID from [OWT_Site]
--)

--select * from OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=OEH30612\OEH30612_SQL2012;UID=sa;PWD=eric12345@').[WDS].[dbo].[Site] 
--where SiteID in
--(
--  select SiteID from [OWT_Site]
--)
-----------------------------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------------------------
--UPDATE WDS TABLE: Customer
-----------------------------------------------------------------------------------------------------------
--we create a temp table then looppp through to do the WDS updating actions
--BEGIN TRANSACTION

DECLARE @MyTable1 TABLE
	(
	SNo int IDENTITY(1,1), 
	CustomerID int,
	PALMSAccountablePartyID int
	)    
INSERT INTO @MyTable1(CustomerID, PALMSAccountablePartyID)	    
SELECT CustomerID, PALMSAccountablePartyID
from [dbo].[OWT_Customer] 

--select * from @MyTable1
 	
declare @Cnt1 int
SELECT @Cnt1 = MIN(Sno) FROM @MyTable1
	
declare @TempCustomerID int
declare @TempPALMSAccountablePartyID int

WHILE (1=1)
BEGIN
   
SELECT @TempCustomerID = CustomerID, @TempPALMSAccountablePartyID = isnull(PALMSAccountablePartyID, 0) FROM @MyTable1
WHERE SNo = @Cnt1
 
IF @@ROWCOUNT = 0
	BREAK

	if @TempPALMSAccountablePartyID > 0 and exists(select CustomerID from OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=OWT_RW;PWD=rw2owT').[WDS].[dbo].[Customer] where cast(CustomerID as varchar) = cast(@TempCustomerID as varchar))
	begin
		--print '@TempCustomerID =' + cast(@TempCustomerID as varchar)
		--print '@TempPALMSAccountablePartyID =' + cast(@TempPALMSAccountablePartyID as varchar)
		--print '---------------------------------------------'
	    
		--if @TempCustomerID = 29  --PALMSAccountablePartyID is 4568
		Update OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=OWT_RW;PWD=rw2owT').[WDS].[dbo].[Customer] set PALMSAccountablePartyID = @TempPALMSAccountablePartyID where cast(CustomerID as varchar) = cast(@TempCustomerID as varchar)  
	end 
SELECT @Cnt1 = @Cnt1 + 1
		
END

print '---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'
-----------------------------------------------------------------------------------------------------------
--UPDATE WDS TABLE: Site
-----------------------------------------------------------------------------------------------------------
--we create a temp table then looppp through to do the WDS updating actions
DECLARE @MyTable2 TABLE
	(
	SNo int IDENTITY(1,1), 
	SiteID int,
	PALMSLocationID int
	)    
INSERT INTO @MyTable2(SiteID, PALMSLocationID)	    
SELECT SiteID, PALMSLocationID
from [dbo].[OWT_Site] 

--select * from @MyTable2
 	
declare @Cnt2 int
SELECT @Cnt2 = MIN(Sno) FROM @MyTable2
	
declare @TempSiteID int
declare @TempPALMSLocationID int

WHILE (1=1)
BEGIN
   
SELECT @TempSiteID = SiteID, @TempPALMSLocationID = isnull(PALMSLocationID, 0) FROM @MyTable2
WHERE SNo = @Cnt2
 
IF @@ROWCOUNT = 0
	BREAK

	if @TempPALMSLocationID > 0 and exists(select SiteID from OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=OWT_RW;PWD=rw2owT').[WDS].[dbo].[Site] where cast(SiteID as varchar) = cast(@TempSiteID as varchar))
	begin
		--print '@TempSiteID =' + cast(@TempSiteID as varchar)
		--print '@TempPALMSLocationID =' + cast(@TempPALMSLocationID as varchar)
		--print '---------------------------------------------'
	    
		--if @TempSiteID = 1174  --PALMSLocationID is 637
		Update OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=OWT_RW;PWD=rw2owT').[WDS].[dbo].[Site] set PALMSLocationID = @TempPALMSLocationID where cast(SiteID as varchar) = cast(@TempSiteID as varchar)  
	end 
SELECT @Cnt2 = @Cnt2 + 1
		
END

--COMMIT TRANSACTION 