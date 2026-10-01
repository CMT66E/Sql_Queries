
	declare @xmlSearchCriteria XML =
	'
<DataSearch>
  <PrimarySearchCriteria>
    <LicenseType>1</LicenseType>
  </PrimarySearchCriteria>
</DataSearch>
	'

	declare @NoOfRecordsRequired int = 500
	declare @MaxRecordsExport int = 5000
	declare @ToExport BIT = 0
	declare @pageSize int = 50
	declare @pageNum int = 1

BEGIN TRY
 
DECLARE 
	@LicenseNo as int, 
	@LicenseType0 as int,  -- used for new lience search situation
	@LicenseType1 as int, 
	@LicenseType2 as int, 
	@LicenseStatus as int, 			
	@APName as Varchar(100), 			
	--@FeeBasedActID as int,			
	--@LGAID as int, 
	--@CatchmentID as int, 		
	@Suburb as Varchar(100),
	@Location as Varchar(100),
	@DGRegoNumber as Varchar(100),
	@TradingName as Varchar(100)			
SELECT 
	@LicenseNo = xmlVals.rowvals.value('(LicenseNo)[1]','INT'),
	@LicenseType1 = xmlVals.rowvals.value('(LicenseType)[1]','INT'),
	@LicenseType2 = xmlVals.rowvals.value('(LicenseType)[1]','INT'),
	@LicenseStatus = xmlVals.rowvals.value('(LicenseStatus)[1]','INT'),			
	--@FeeBasedActID = xmlVals.rowvals.value('(FeeBasedActID)[1]','INT'),			
	--@LGAID = xmlVals.rowvals.value('(LGAID)[1]','INT'),
	--@CatchmentID = xmlVals.rowvals.value('(CatchmentID)[1]','INT'),			
	@Suburb = xmlVals.rowvals.value('(Suburb)[1]','VARCHAR(100)'),			
	@Location = xmlVals.rowvals.value('(Location)[1]','VARCHAR(100)'),
	@DGRegoNumber = xmlVals.rowvals.value('(DGRegoNumber)[1]','VARCHAR(100)'),
	@TradingName = xmlVals.rowvals.value('(TradingName)[1]','VARCHAR(100)'),			
	@APName = xmlVals.rowvals.value('(APName)[1]','VARCHAR(100)')			
From @xmlSearchCriteria.nodes('//DataSearch/PrimarySearchCriteria') as xmlVals(rowvals)		

if @LicenseType1 = 1
	BEGIN
		 select @LicenseType1 = 1417
		 select @LicenseType2 = -1
		 select @LicenseType0 = 751;
	END
Else
  BEGIN	
    --If the user choosed licence type: Licence Variation, Licence Transfer and Licence Surrender    
	if @LicenseType1 = 2 OR @LicenseType1 = 3 OR @LicenseType1 = 4
		BEGIN
			 select @LicenseType0 = 10000; --Block licence from showing we only show those application notices				 
			 select @LicenseType2 = @LicenseType1
			 select @LicenseType1 = 10000  		 
		END
	ELSE
	--If the user did NOT choose licence type, we allow all qualified licence which is in draft status to be shown 
	    select @LicenseType0 = null  	
  END

SET @APName = ISNULL(@APName, '');
IF @APName <> ''
  SET @APName = rtrim(ltrim(@APName));		
ELSE
  SET @APName = null
   
SET @TradingName = @APName;
 
SET @Location = ISNULL(@Location, '');
IF @Location <> ''
	SET @Location = rtrim(ltrim(@Location));
ELSE
	SET @Location = null;

SET @Suburb = ISNULL(@Suburb, '');
IF @Suburb <> ''
	SET @Suburb = rtrim(ltrim(@Suburb));
ELSE
	SET @Suburb = null;
	
----=======================================================================
--PRINT '@LicenseType1 =' + convert(varchar, ISNULL(@LicenseType1, 0))  
--PRINT '@LicenseType2 =' + convert(varchar, ISNULL(@LicenseType2, 0))    
--PRINT 'APName =' + convert(varchar, ISNULL(@APName, 0))
----=======================================================================

DECLARE @StatusTable Table(InstrumentID int)
Declare  @StatusFilterCount int
Set @StatusFilterCount = 0

--1) Here we find all those qualified rows from Licence part
Declare @InstrumentAllRowsA Table 
(
    InstrumentID int,
	AccountableParty varchar(128) null,
	LocationName varchar(128) null,
	LocationFull Varchar(200) null,
	RecordType Varchar(255) null    
)

Declare @InstrumentAllRowsB Table 
(
	InstrumentID int,
	AccountableParty varchar(128) null,
	LocationName varchar(128) null,
	LocationFull Varchar(200) null,
	RecordType Varchar(255) null		
)

DECLARE @strSearchCriteria0 nvarchar(MAX)
DECLARE @whereClause0 AS nvarchar(MAX)

SELECT @strSearchCriteria0 ='			
SELECT 	DISTINCT
		I.InstrumentID,
		(CASE WHEN AP.CompanyFlag = 1 THEN AP.OrganisationName ELSE AP.GivenName + '' '' + AP.Surname END) as AccountableParty,
		(L.LocationName) as LocationName,
		(CASE WHEN ISNULL(A.[Address], '''') = '''' THEN '''' ELSE A.[Address] + '', '' END) +
		(CASE WHEN ISNULL(A.[Suburb], '''') = '''' THEN '''' ELSE A.[Suburb] + '', '' END) +			
		(CASE WHEN ISNULL(A.[StateCode], '''') = '''' THEN '''' ELSE A.[StateCode] + '' '' END) +
		(CASE WHEN ISNULL(A.[Postcode], '''') = '''' THEN '''' ELSE A.[Postcode] + '''' END) AS LocationFull,
		case P.LicenceTypeID when 1401 then ''DGV'' when 1402 then ''TWT'' else C.Description end  AS RecordType		
FROM tblClassification C 
		INNER JOIN tblInstrument I 
			ON C.ClassificationID = I.InstrumentTypeID
		LEFT OUTER JOIN tblClassification C2 
			ON C2.ClassificationID = I.InstrumentStatusID
		LEFT OUTER JOIN tblTransporterLicence P
			ON I.InstrumentID = P.InstrumentID				
		LEFT OUTER JOIN tblInstrumentAccountableParty IAP
			ON IAP.InstrumentID = I.InstrumentID
		LEFT OUTER JOIN viewInstrumentAccountableParty AP
			ON IAP.AccountablePartyID = AP.AccountablePartyID
		LEFT OUTER JOIN tblPOEOLicenceFeeBasedActivity LFBA
			ON LFBA.InstrumentID = I.InstrumentID
		LEFT OUTER JOIN tblFeeBasedActivity FBA
			ON FBA.FeeBasedActivityID = LFBA.FeeBasedActivityID							
		LEFT OUTER JOIN tblInstrumentTransporterLocation IL
			ON IL.InstrumentID =  I.InstrumentID
		LEFT OUTER JOIN tblTransporterLocation L
			ON IL.TransporterLocationID = L.TransporterLocationID
		LEFT OUTER JOIN tblAddress A
			ON 	A.AddressID = L.AddressID			
		LEFT OUTER JOIN tblLandTitle LT
			ON L.TransporterLocationID = LT.LocationID
		LEFT OUTER JOIN tblLandTitleElectorate LTE
			ON LTE.LandTitleID = LT.LandTitleID				
		LEFT OUTER JOIN	tblLandTitleLGA LTL 
			ON LT.LandTitleID = LTL.LandTitleID
		LEFT OUTER JOIN viewLGA VL
			ON VL.LGAID = LTL.LGAID
		LEFT OUTER JOIN tblLandTitleCatchment LTC
			ON LTC.LandTitleID = LT.LandTitleID
		LEFT OUTER JOIN viewCatchment VC
			ON LTC.CatchmentID = VC.CATCHMENT_ID
		LEFT OUTER JOIN tblDGLicenceVehicle aa ON P.InstrumentID = aa.InstrumentID
		LEFT OUTER JOIN tblDGVehicle b on aa.DGVehicleID = (select MIN(b1.DGVehicleID) from tblDGVehicle b1 where b1.DGVehicleID=b.DGVehicleID)	
WHERE 		
(
	I.InstrumentTypeID = 1417
)
AND 		 
(
	I.InstrumentStatusID IN (754, 751, 753)		 
) '

SET  @whereClause0 = N''

IF @LicenseNo IS NOT NULL and @LicenseNo<>0
BEGIN
      SET @whereClause0 = @whereClause0 +  ' AND I.InstrumentID = ' + convert(varchar, @LicenseNo)
END

IF @LicenseType0  IS NOT NULL
BEGIN
     SET @whereClause0 = @whereClause0 +  ' AND I.InstrumentStatusID = ' + convert(varchar, @LicenseType0)
END

IF @LicenseStatus IS NOT NULL and @LicenseStatus <> 0
BEGIN
     SET @whereClause0 = @whereClause0 +  ' AND I.InstrumentStatusID = ' + convert(varchar, @LicenseStatus)
END

IF @APName IS NOT NULL and @APName <> ''
     SET @whereClause0 = @whereClause0 + ' AND (CASE WHEN AP.CompanyFlag = 1 THEN AP.OrganisationName ELSE AP.GivenName + '' '' + AP.Surname END) like ''%'+ @APName + '%'''	

--IF @FeeBasedActID IS NOT NULL and @FeeBasedActID <> 0
--     SET @whereClause0 = @whereClause0 +  ' AND FBA.FeeBasedActivityID = ' + convert(varchar, @FeeBasedActID)
      
IF @DGRegoNumber IS NOT NULL and @DGRegoNumber <> ''
     SET @whereClause0 = @whereClause0 +  ' AND b.RegistrationNumber ''%' + convert(varchar, @DGRegoNumber) + '%'''

IF @Suburb IS NOT NULL and @Suburb <> ''
     SET @whereClause0 = @whereClause0 +  ' AND A.Suburb = ''' + convert(varchar, @Suburb) + ''''    
      
--IF @LGAID IS NOT NULL and @LGAID <> 0
--     SET @whereClause0 = @whereClause0 +  ' AND LTL.LGAID = ' + convert(varchar, @LGAID)  
     
--IF @CatchmentID IS NOT NULL and @CatchmentID <> 0
--     SET @whereClause0 = @whereClause0 +  ' AND LTC.CatchmentID = ' + convert(varchar, @CatchmentID)  



set @strSearchCriteria0 = @strSearchCriteria0 + @whereClause0     								
Insert Into @InstrumentAllRowsA
(
			InstrumentID,
			AccountableParty,
			LocationName,
			LocationFull,
			RecordType 	
) 
EXEC sp_executesql @strSearchCriteria0;	
 	 
--=================================================== 	 
--print @strSearchCriteria0; 	 
--=================================================== 	 
							
DECLARE @NoticeApplicationStatus INT
		SELECT @NoticeApplicationStatus = null
        
if (NOT @LicenseStatus IS NULL)
BEGIN
	 IF @LicenseStatus = 1
		SELECT @NoticeApplicationStatus = 15 --Withdraw on notice application
	 IF @LicenseStatus = 5
		SELECT @NoticeApplicationStatus = 9  --Draft on notice application
	 IF @LicenseStatus = 6
		SELECT @NoticeApplicationStatus = 10 --Draft on terminated application		        
	 IF @LicenseStatus = 7
		SELECT @NoticeApplicationStatus = 14 --Refused on notice application		        		     
END 				
											
--2) Here we find all those qualified rows from notice part					
DECLARE @strSearchCriteria nvarchar(MAX)
DECLARE @strSearchCriteriaExtra nvarchar(MAX) --add this on 13-11-2013 Eric He to improve the search speed
DECLARE @whereClause AS nvarchar(MAX)

SELECT @strSearchCriteria ='			
SELECT DISTINCT					 
		I.InstrumentID,
		(CASE WHEN AP.CompanyFlag = 1 THEN AP.OrganisationName ELSE AP.GivenName + '' '' + AP.Surname END) as AccountableParty,
		(L.LocationName) as LocationName,
		(CASE WHEN ISNULL(A.[Address], '''') = '''' THEN '''' ELSE A.[Address] + '', '' END) +
		(CASE WHEN ISNULL(A.[Suburb], '''') = '''' THEN '''' ELSE A.[Suburb] + '', '' END) +			
		(CASE WHEN ISNULL(A.[StateCode], '''') = '''' THEN '''' ELSE A.[StateCode] + '' '' END) +
		(CASE WHEN ISNULL(A.[Postcode], '''') = '''' THEN '''' ELSE A.[Postcode] + '''' END) AS LocationFull,
		tblNoticeTemplate.TemplateName As RecordType	 		 					
FROM [tblNotice]
		LEFT OUTER JOIN dbo.tblNoticeTemplate ON [tblNotice].NoticeTemplateID = tblNoticeTemplate.[NoticeTemplateID]
		INNER JOIN dbo.tblInstrument I ON [tblNotice].InstrumentID = I.InstrumentID
		LEFT OUTER JOIN tblNoticeApplication NA ON [tblNotice].InstrumentID = NA.InstrumentID 
		LEFT OUTER JOIN [dbo].[tblInstrumentNotice] INO ON I.InstrumentID = INO.NoticeInstrumentID
		LEFT OUTER JOIN	tblClassification C 						
			ON C.ClassificationID = I.InstrumentTypeID
		LEFT OUTER JOIN tblClassification C2 
			ON C2.ClassificationID = I.InstrumentStatusID
		LEFT OUTER JOIN tblTransporterLicence P
			ON I.InstrumentID = P.InstrumentID						
		LEFT OUTER JOIN tblInstrumentAccountableParty IAP
			ON IAP.InstrumentAccountablePartyID = 
			(Select MIN(IAP1.InstrumentAccountablePartyID) from tblInstrumentAccountableParty IAP1
			 Where IAP1.InstrumentID = INO.NoticeInstrumentID and IAP1.OldAccountablePartyFlag = 0)			 
		LEFT OUTER JOIN tblAccountableParty AP
			ON IAP.AccountablePartyID = AP.AccountablePartyID
			
		LEFT OUTER JOIN tblPOEOLicenceFeeBasedActivity LFBA
			ON LFBA.POEOLicenceFeeBasedActivityID = (Select Min(LFBA1.POEOLicenceFeeBasedActivityID)
				from tblPOEOLicenceFeeBasedActivity LFBA1 Where LFBA1.InstrumentID = I.InstrumentID)
		LEFT OUTER JOIN tblFeeBasedActivity FBA
			ON FBA.FeeBasedActivityID = LFBA.FeeBasedActivityID			
			
		LEFT OUTER JOIN tblInstrumentTransporterLocation IL
            ON IL.InstrumentID = [I].InstrumentID													
		LEFT OUTER JOIN tblTransporterLocation L
			ON IL.TransporterLocationID = L.TransporterLocationID
		LEFT OUTER JOIN tblLandTitle LT
				ON LT.LandTitleID = (Select MIN(LT1.LandTitleID) from tblLandTitle LT1
								Where LT1.LocationID = L.TransporterLocationID)
		LEFT OUTER JOIN	tblLandTitleLGA LTL 
			ON LTL.LandTitleLGAID = (Select MIN(LTL1.LandTitleLGAID) From tblLandTitleLGA LTL1
									Where LTL1.LandTitleID = LT.LandTitleID)
		LEFT OUTER JOIN viewLGA VL
			ON VL.LGAID = LTL.LGAID
		LEFT OUTER JOIN tblLandTitleCatchment LTC
			ON LTC.LandTitleCatchmentID = (Select MIN(LTC1.LandTitleCatchmentID) from tblLandTitleCatchment LTC1
										Where LTC1.LandTitleID = LT.LandTitleID)
		LEFT OUTER JOIN viewCatchment VC
			ON LTC.CatchmentID = VC.CATCHMENT_ID
		LEFT OUTER JOIN tblAddress A       
			ON 	A.AddressID = L.AddressID	
		LEFT OUTER JOIN tblDGLicenceVehicle aa ON P.InstrumentID = aa.InstrumentID
		LEFT OUTER JOIN tblDGVehicle b on aa.DGVehicleID = (select MIN(b1.DGVehicleID) from tblDGVehicle b1 where b1.DGVehicleID=b.DGVehicleID)									 
WHERE  	tblNoticeTemplate.PublicRegisterFlag = 1 	    
		AND 
			[tblNotice].ApplicationAppliedFlag = 1
		AND INO.InstrumentID IS NULL     
		AND tblNoticeTemplate.InstrumentTypeID = 1417   
		AND 
			I.InstrumentStatusID IN (9, 11, 15, 14, 566) '

SELECT @strSearchCriteriaExtra ='			
SELECT DISTINCT					 
		I.InstrumentID,
		(CASE WHEN AP.CompanyFlag = 1 THEN AP.OrganisationName ELSE AP.GivenName + '' '' + AP.Surname END) as AccountableParty,
		(L.LocationName) as LocationName,
		(CASE WHEN ISNULL(A.[Address], '''') = '''' THEN '''' ELSE A.[Address] + '', '' END) +
		(CASE WHEN ISNULL(A.[Suburb], '''') = '''' THEN '''' ELSE A.[Suburb] + '', '' END) +			
		(CASE WHEN ISNULL(A.[StateCode], '''') = '''' THEN '''' ELSE A.[StateCode] + '' '' END) +
		(CASE WHEN ISNULL(A.[Postcode], '''') = '''' THEN '''' ELSE A.[Postcode] + '''' END) AS LocationFull,
		tblNoticeTemplate.TemplateName As RecordType	 		 					
FROM [tblNotice]
		LEFT OUTER JOIN dbo.tblNoticeTemplate ON [tblNotice].NoticeTemplateID = tblNoticeTemplate.[NoticeTemplateID]
		INNER JOIN dbo.tblInstrument I ON [tblNotice].InstrumentID = I.InstrumentID
		LEFT OUTER JOIN tblNoticeApplication NA ON [tblNotice].InstrumentID = NA.InstrumentID 
		LEFT OUTER JOIN [dbo].[tblInstrumentNotice] INO ON I.InstrumentID = INO.NoticeInstrumentID
		LEFT OUTER JOIN	tblClassification C 						
			ON C.ClassificationID = I.InstrumentTypeID
		LEFT OUTER JOIN tblClassification C2 
			ON C2.ClassificationID = I.InstrumentStatusID
		LEFT OUTER JOIN tblTransporterLicence P
			ON I.InstrumentID = P.InstrumentID						
		LEFT OUTER JOIN tblInstrumentAccountableParty IAP
			ON IAP.InstrumentAccountablePartyID = 
			(Select MIN(IAP1.InstrumentAccountablePartyID) from tblInstrumentAccountableParty IAP1
			 Where IAP1.InstrumentID = INO.NoticeInstrumentID and IAP1.OldAccountablePartyFlag = 0)			 
		LEFT OUTER JOIN tblAccountableParty AP
			ON IAP.AccountablePartyID = AP.AccountablePartyID
			
		LEFT OUTER JOIN tblPOEOLicenceFeeBasedActivity LFBA
			ON LFBA.POEOLicenceFeeBasedActivityID = (Select Min(LFBA1.POEOLicenceFeeBasedActivityID)
				from tblPOEOLicenceFeeBasedActivity LFBA1 Where LFBA1.InstrumentID = I.InstrumentID)
		LEFT OUTER JOIN tblFeeBasedActivity FBA
			ON FBA.FeeBasedActivityID = LFBA.FeeBasedActivityID			
			
		LEFT OUTER JOIN tblInstrumentTransporterLocation IL
            ON IL.InstrumentID = [I].InstrumentID													
		LEFT OUTER JOIN tblTransporterLocation L
			ON IL.TransporterLocationID = L.TransporterLocationID
		LEFT OUTER JOIN tblLandTitle LT
				ON LT.LandTitleID = (Select MIN(LT1.LandTitleID) from tblLandTitle LT1
								Where LT1.LocationID = L.TransporterLocationID)
		LEFT OUTER JOIN	tblLandTitleLGA LTL 
			ON LTL.LandTitleLGAID = (Select MIN(LTL1.LandTitleLGAID) From tblLandTitleLGA LTL1
									Where LTL1.LandTitleID = LT.LandTitleID)
		LEFT OUTER JOIN viewLGA VL
			ON VL.LGAID = LTL.LGAID
		LEFT OUTER JOIN tblLandTitleCatchment LTC
			ON LTC.LandTitleCatchmentID = (Select MIN(LTC1.LandTitleCatchmentID) from tblLandTitleCatchment LTC1
										Where LTC1.LandTitleID = LT.LandTitleID)
		LEFT OUTER JOIN viewCatchment VC
			ON LTC.CatchmentID = VC.CATCHMENT_ID
		LEFT OUTER JOIN tblAddress A       
			ON 	A.AddressID = L.AddressID	
		LEFT OUTER JOIN tblDGLicenceVehicle aa ON P.InstrumentID = aa.InstrumentID
		LEFT OUTER JOIN tblDGVehicle b on aa.DGVehicleID = (select MIN(b1.DGVehicleID) from tblDGVehicle b1 where b1.DGVehicleID=b.DGVehicleID)									 
WHERE  	tblNoticeTemplate.PublicRegisterFlag = 1 	    
		AND 
			[tblNotice].ApplicationAppliedFlag = 1
		AND NOT INO.InstrumentID IS NULL     
		AND tblNoticeTemplate.InstrumentTypeID = 1417   
		AND 
			I.InstrumentStatusID IN (9, 11, 15, 14, 566)'


SET  @whereClause = N''

IF @LicenseNo IS NOT NULL and @LicenseNo<>0
BEGIN
      SET @whereClause = @whereClause +  ' AND I.InstrumentID = ' + convert(varchar, @LicenseNo)
END

IF @LicenseType2 IS NOT NULL and @LicenseType2 <> 0
BEGIN
   IF @LicenseType2 = 2
     SET  @whereClause = @whereClause +  ' AND tblNoticeTemplate.NoticeTemplateID = 403'
   IF @LicenseType2 = 3
     SET  @whereClause = @whereClause +  ' AND tblNoticeTemplate.TemplateName LIKE ''%transfer%'''
   IF @LicenseType2 = 4
     SET  @whereClause = @whereClause +  ' AND tblNoticeTemplate.TemplateName LIKE ''%suspension%'''             
END


IF @LicenseStatus IS NOT NULL and @LicenseStatus <> 0
BEGIN
			IF (NOT @LicenseStatus IS NULL)
			BEGIN
				 IF @LicenseStatus = 1
					SELECT @NoticeApplicationStatus = 15 --Withdraw on notice application
				 IF @LicenseStatus = 5
					SELECT @NoticeApplicationStatus = 9  --Draft on notice application
				 IF @LicenseStatus = 6
					SELECT @NoticeApplicationStatus = 10 --Draft on terminated application		        
				 IF @LicenseStatus = 7
					SELECT @NoticeApplicationStatus = 14 --Refused on notice application		        		     
			END 
			
			IF @NoticeApplicationStatus IS NOT NULL and @NoticeApplicationStatus <> 0
			     SET @whereClause = @whereClause +  ' AND I.InstrumentStatusID = ' + convert(varchar, @NoticeApplicationStatus)
END 

IF @APName IS NOT NULL and @APName <> ''
     SET @whereClause = @whereClause + ' AND (CASE WHEN AP.CompanyFlag = 1 THEN AP.OrganisationName ELSE AP.GivenName + '' '' + AP.Surname END) like ''%'+ @APName + '%'''	

--IF @FeeBasedActID IS NOT NULL and @FeeBasedActID <> 0
--     SET @whereClause = @whereClause +  ' AND FBA.FeeBasedActivityID = ' + convert(varchar, @FeeBasedActID)
      
IF @DGRegoNumber IS NOT NULL and @DGRegoNumber <> ''
     SET @whereClause0 = @whereClause0 +  ' AND b.RegistrationNumber ''%' + convert(varchar, @DGRegoNumber) + '%'''

IF @Suburb IS NOT NULL and @Suburb <> ''
     SET @whereClause = @whereClause +  ' AND A.Suburb = ''' + convert(varchar, @Suburb) + ''''    
      
--IF @LGAID IS NOT NULL and @LGAID <> 0
--     SET @whereClause = @whereClause +  ' AND LTL.LGAID = ' + convert(varchar, @LGAID)  
     
--IF @CatchmentID IS NOT NULL and @CatchmentID <> 0
--     SET @whereClause = @whereClause +  ' AND LTC.CatchmentID = ' + convert(varchar, @CatchmentID)  

--======================================================     
print '@LicenseType0=' + cast(ISNULL(@LicenseType0, 0) as varchar) 	 
--======================================================
                 
IF ISNULL(@LicenseType0, 0) <> 5 and ISNULL(@LicenseType0, 0) <> 751 
BEGIN      
	set @strSearchCriteria = @strSearchCriteria + @whereClause  
	set @strSearchCriteriaExtra = @strSearchCriteriaExtra + @whereClause 
	
	declare @FinalQuery nvarchar(max)
	set @FinalQuery = @strSearchCriteria + ' UNION ' + @strSearchCriteriaExtra
	--======================================================
	--print '@FinalQuery=' + @FinalQuery; 	
	--======================================================
		   								
	Insert Into @InstrumentAllRowsB
	(
			InstrumentID,
			AccountableParty,
			LocationName,
			LocationFull,
			RecordType 		
	) 
	EXEC sp_executesql @FinalQuery;			 
END		
--======================================================
--select * from @InstrumentAllRowsB
--======================================================						
						
DECLARE @TotalRowCount INT
		SELECT @TotalRowCount = 0
DECLARE @TotalRowCountA INT
		SELECT @TotalRowCountA = 0
DECLARE @TotalRowCountB INT
		SELECT @TotalRowCountB = 0	
					
Select @TotalRowCountA = COUNT(InstrumentID) from @InstrumentAllRowsA
Select @TotalRowCountB = COUNT(InstrumentID) from @InstrumentAllRowsB
SET @TotalRowCount = @TotalRowCountA + @TotalRowCountB
 
select * from @InstrumentAllRowsA		
select * from @InstrumentAllRowsB		
--HERE WE NEED CHECK HOW MANY ROWS WE WILL GET ABOVE TAKES 0 SECOND TO PROCEED
 
Declare @InstrumentResultRows Table
(
	InstrumentTypeID int null, 
	InstrumentID int null, 
	InstrumentStatusID int null, 
	InstrumentStatus Varchar(100) null,
	DateIssued DateTime null,
	AccountablePartyID int null,
	AccountableParty varchar(128) null,
	FeeBasedActivityID int null,
	FeeBasedActivity Varchar(128) null,			
	TradingName varchar(128) null,
	LocationName varchar(128) null,
	[Address] varchar(100) null,
	Suburb varchar(60) null,			
	LocationID int null,			
	LGA Varchar(100),
	Catchment Varchar(100),			
	LocationFull Varchar(200),
	RecordType Varchar(255)
)
											      																	
IF(NOT @TotalRowCount > @NoOfRecordsRequired OR @ToExport = 1)
	BEGIN	
	
	    IF @TotalRowCountA > 0
	     BEGIN
			-- Here are the mappings from Licence Status -> Notice Application status				 			      	  			      	                             
			Insert Into @InstrumentResultRows
			(
				InstrumentTypeID, 
				InstrumentID, 
				InstrumentStatusID, 
				InstrumentStatus,
				DateIssued,				
				AccountableParty,				
				LocationName,					
				LocationFull,
				RecordType
			)
			SELECT DISTINCT	TOP(@TotalRowCountA)
				I.InstrumentTypeID, 
				I.InstrumentID, 
				I.InstrumentStatusID, 		
				(CASE WHEN UPPER(C2.Name) = 'DRAFT' THEN 'Pending' ELSE C2.Name END) as Name,
				P.DateApplicationReceived AS DateIssued,				
				X.AccountableParty as AccountablePartyID,
				X.LocationName as LocationName,
				X.LocationFull as LocationFull,		
				X.RecordType as RecordType 		 	
				FROM @InstrumentAllRowsA X INNER JOIN 
				tblInstrument I ON X.InstrumentID = I.InstrumentID
				INNER JOIN tblClassification C 
					ON I.InstrumentTypeID = C.ClassificationID
				LEFT OUTER JOIN tblClassification C2 
					ON C2.ClassificationID = I.InstrumentStatusID
				LEFT OUTER JOIN tblTransporterLicence P
					ON I.InstrumentID = P.InstrumentID		
				LEFT OUTER JOIN tblInstrumentAccountableParty IAP
					ON IAP.AccountablePartyID = (Select MAX(IAP1.AccountablePartyID) from tblInstrumentAccountableParty IAP1
											Where IAP1.InstrumentID = I.InstrumentID)
				LEFT OUTER JOIN tblAccountableParty AP
					ON IAP.AccountablePartyID = AP.AccountablePartyID									
				LEFT OUTER JOIN tblInstrumentTransporterLocation IL
					ON IL.InstrumentTransporterLocationID = (Select MIN(IL1.InstrumentTransporterLocationID) from tblInstrumentTransporterLocation IL1
										Where IL1.InstrumentID = I.InstrumentID)
				LEFT OUTER JOIN tblTransporterLocation L
					ON IL.TransporterLocationID = L.TransporterLocationID				
				LEFT OUTER JOIN tblAddress A
					ON 	A.AddressID = L.AddressID
					
									
			 
            END				
 			 	
        IF @TotalRowCountB > 0	
          BEGIN																																      	
			Insert Into @InstrumentResultRows
			(
				InstrumentTypeID, 
				InstrumentID, 
				InstrumentStatusID, 
				InstrumentStatus,
				DateIssued,				
				AccountableParty,
				LocationName,						
				LocationFull,
				RecordType
			)
                        
			SELECT DISTINCT	TOP(@TotalRowCountB)
				I.InstrumentTypeID, 
				I.InstrumentID, 
				I.InstrumentStatusID,			
				(CASE 
					WHEN UPPER(C2.Name) = 'DRAFT' THEN 'Pending' 
					WHEN UPPER(C2.Name) = 'ISSUED' THEN 'Application approved' 
					ELSE C2.Name 
				 END) as Name,
				 NA.ReceivedDate AS DateIssued,
				 
				X.AccountableParty as AccountablePartyID,
				X.LocationName as LocationName,
				X.LocationFull as LocationFull,		
				X.RecordType as RecordType  	

			FROM @InstrumentAllRowsB X INNER JOIN  
			    [tblNotice] ON X.InstrumentID = [tblNotice].InstrumentID
				LEFT OUTER JOIN dbo.tblNoticeTemplate ON [tblNotice].NoticeTemplateID = tblNoticeTemplate.[NoticeTemplateID]
				INNER JOIN dbo.tblInstrument I ON [tblNotice].InstrumentID = I.InstrumentID
				LEFT OUTER JOIN tblNoticeApplication NA ON [tblNotice].InstrumentID = NA.InstrumentID 
				LEFT OUTER JOIN [dbo].[tblInstrumentNotice] INO ON I.InstrumentID = INO.NoticeInstrumentID
				LEFT OUTER JOIN	tblClassification C 						
					ON C.ClassificationID = I.InstrumentTypeID
				LEFT OUTER JOIN tblClassification C2 
					ON C2.ClassificationID = I.InstrumentStatusID
				LEFT OUTER JOIN tblTransporterLicence P
					ON I.InstrumentID = P.InstrumentID									
			WHERE 
			        tblNoticeTemplate.PublicRegisterFlag = 1 
				AND 
					[tblNotice].ApplicationAppliedFlag = 1      
				AND 
					I.InstrumentStatusID IN (9, 11, 15, 14, 566) --9: Draft (Pending), 11:Issued, 14: Refused,  15: Withdrawn, 566: Application approved															
          END
 
	    IF @LicenseType2 = -1 		 
			Select TOP(@MaxRecordsExport) 
				InstrumentTypeID, 
				InstrumentID, 
				InstrumentStatusID, 
				InstrumentStatus,
				DateIssued,				 
				AccountableParty,				 
				LocationName,				 					
				LocationFull,
				RecordType,
				0 as PINNumber			
			from @InstrumentResultRows
			WHERE InstrumentStatusID IN (5, 1, 7, 751)				   
	  ELSE
	   BEGIN
		 IF @LicenseStatus = 9
			Select TOP(@MaxRecordsExport) 
				InstrumentTypeID, 
				InstrumentID, 
				InstrumentStatusID, 
				InstrumentStatus,
				DateIssued,				 
				AccountableParty,				 
				LocationName,				 					
				LocationFull,
				RecordType,
				0 as PINNumber						
			from @InstrumentResultRows 
			WHERE InstrumentStatusID IN (566)	
		 ELSE
			Select TOP(@MaxRecordsExport) 
				InstrumentTypeID, 
				InstrumentID, 
				InstrumentStatusID, 
				InstrumentStatus,
				DateIssued,				 
				AccountableParty,				 
				LocationName,				 					
				LocationFull,
				RecordType,
				0 as PINNumber						
			from 
			@InstrumentResultRows	
	   END			    
	END
Else
	BEGIN
		Select 
			0 InstrumentTypeID, 
			0 InstrumentID, 
			0 InstrumentStatusID, 
			0 InstrumentStatus,
			0 ResponsibleSystemUserID
	END
	
delete @StatusTable		
delete @InstrumentResultRows
delete @InstrumentAllRowsA
delete @InstrumentAllRowsB
	END TRY

	BEGIN CATCH

		DECLARE @ErrorMessage VARCHAR(2000)
		SET @ErrorMessage = dbo.ufn_GetErrorText()
		RAISERROR (@ErrorMessage , 16, 1)

	END CATCH