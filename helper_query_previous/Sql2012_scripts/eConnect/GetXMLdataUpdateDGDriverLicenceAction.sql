declare @LicenceNumber int = 5056022
declare @RenewalNumber int = 54890
--------------------------------------------
declare  @theXmlData xml = ''

select @theXmlData = isnull(LicenceDataXML, '') from tblOnlineRADLicenceRenewal
where LicenceNumber=@LicenceNumber and RenewalNumber=@RenewalNumber 



if DATALENGTH(@theXmlData) > 0 
begin
  select @theXmlData = '
  <DGDLRenewalExtra>
  <LicenceNumber>5052701</LicenceNumber>
  <RenewalNumber>55868</RenewalNumber>
  <DGDTrainingDetailsTbl>
    <CourseConductedBy>21</CourseConductedBy>
    <RTO>19</RTO>
    <CourseHeldAt>QLD</CourseHeldAt>
    <DateCourseCompleted>2016-12-31T13:00:00</DateCourseCompleted>
    <CertificateDoc>ARBottom21062015.jpg|EC20954e7c-7cfc-4891-902d-611936e421b2.jpg</CertificateDoc>
  </DGDTrainingDetailsTbl>
  <DGDLMedicalAssesmentTbl>
    <Name>de dfsdf df dsf sdfasdfsd sdf</Name>
    <Phone>02 2222 2222</Phone>
    <Mobile>0000 000000</Mobile>
    <Date>2017-02-28T13:00:00</Date>
    <CertificateDoc>ARBottom.jpg|EC075dc36a-9dce-407b-adf3-e30c418fb121.jpg</CertificateDoc>
  </DGDLMedicalAssesmentTbl>
  <DriverLicenceDetailsTbl>
    <LicenceNo>1641612288</LicenceNo>
    <IssuingState>QLD</IssuingState>
    <LicenceClass>HRsdfsdfsdf</LicenceClass>
    <Question1>false</Question1>
    <Question2>false</Question2>
    <Question3>true</Question3>
    <PreviousDriverLicences>
      <PreviousDriverLicence>
        <LicenceNo>sdfsdfs</LicenceNo>
        <LicenceType>sdfsdfsd</LicenceType>
        <FromDate>2017-02-25T13:00:00Z</FromDate>
        <Todate>2017-03-15T13:00:00Z</Todate>
        <Jurisdiction>NT</Jurisdiction>
        <CertificateDoc>ARBottom.jpg|EC71e24cb8-cd08-46cf-827d-a7c7764b4bbb.jpg</CertificateDoc>
        <DrivingHistory>
          <Id>0</Id>
          <CommunicationTypeId>0</CommunicationTypeId>
          <DocumentName>ARBottom.jpg|EC71e24cb8-cd08-46cf-827d-a7c7764b4bbb.jpg</DocumentName>
        </DrivingHistory>
      </PreviousDriverLicence>
    </PreviousDriverLicences>
    <DriverPhotoDoc>ARBottom.jpg|ECe0c621c1-d73d-48f1-9dce-eb4bc0e1c2eb.jpg</DriverPhotoDoc>
    <DriverLicenceDoc>ARBottom22062015_Final.jpg|EC94ebc53a-1fcb-4e75-8a79-066985855dc8.jpg</DriverLicenceDoc>
    <DriverHistoryDoc>ARBottom.jpg|EC8611dfb3-4029-4b31-9311-53bddf8bca14.jpg</DriverHistoryDoc>
  </DriverLicenceDetailsTbl>
</DGDLRenewalExtra>
	'
	    declare @certificateDoc varchar(200)

		declare @MedicalDataCount int = 0
		declare @TrainingDataCount int = 0
		declare @DriverDataCount int = 0
		declare @PreviousLicenceDataCount int = 0
		

		select  @TrainingDataCount = count(*) From @theXmlData.nodes('//DGDLRenewalExtra/DGDTrainingDetailsTbl') as xmlVals(rowvals) 
		where xmlVals.rowvals.value('(CourseConductedBy)[1]','INT') > 0

		select @MedicalDataCount = count(*) From @theXmlData.nodes('//DGDLRenewalExtra/DGDLMedicalAssesmentTbl') as xmlVals(rowvals)
		where len(isnull(xmlVals.rowvals.value('(Name)[1]','VARCHAR(100)'), '')) > 0 

		select @DriverDataCount = count(*) From @theXmlData.nodes('//DGDLRenewalExtra/DriverLicenceDetailsTbl') as xmlVals(rowvals)
		where len(isnull(xmlVals.rowvals.value('(LicenceNo)[1]','VARCHAR(100)'), '')) > 0 

		select @PreviousLicenceDataCount = count(*) From @theXmlData.nodes('//DGDLRenewalExtra/DriverLicenceDetailsTbl/PreviousDriverLicences/PreviousDriverLicence') as xmlVals(rowvals)
		where len(isnull(xmlVals.rowvals.value('(LicenceNo)[1]','VARCHAR(100)'), '')) > 0 

		if @TrainingDataCount > 0
		begin
			declare @CourseConductedBy int
			declare @RTO int
			declare @CourseHeldAt varchar(100)
			declare @DateCourseCompleted datetime		 
			SELECT 
				@CourseConductedBy = xmlVals.rowvals.value('(CourseConductedBy)[1]','INT'),
				@RTO = xmlVals.rowvals.value('(RTO)[1]','INT'),			 
				@CourseHeldAt = xmlVals.rowvals.value('(CourseHeldAt)[1]','VARCHAR(100)'),			 
				@DateCourseCompleted = xmlVals.rowvals.value('(DateCourseCompleted)[1]','datetimeoffset'),
				@CertificateDoc = xmlVals.rowvals.value('(CertificateDoc)[1]','VARCHAR(200)')
			From @theXmlData.nodes('//DGDLRenewalExtra/DGDTrainingDetailsTbl') as xmlVals(rowvals)

			--update tblDGLicenceDriver set				  
			--	   DGLicenceCourseConductedByID = @CourseConductedBy,
			--	   DGLicenceRTOID = @RTO,
			--	   CourseHeldAt = @CourseHeldAt,
			--	   DateOfCourse = @DateCourseCompleted,
			--	   TrainingRequiredFlag = 1 --need do somthing with it  
			--where InstrumentID = @LicenceNumber

			SELECT 
				@CourseConductedBy as DGLicenceCourseConductedByID,
				@RTO as DGLicenceRTOID,			 
				@CourseHeldAt as CourseHeldAt,			 
				@DateCourseCompleted as DateCourseCompleted,
				@CertificateDoc as CertificateDoc
		end

		if @MedicalDataCount > 0
		begin
			declare @MedicalPractitionerName varchar(100)
			declare @Phone varchar(50)
			declare @Mobile varchar(50)
			declare @DateMedicalExamination datetime
			
			SELECT 
				@MedicalPractitionerName = xmlVals.rowvals.value('(Name)[1]','VARCHAR(50)'),	
				@Phone = xmlVals.rowvals.value('(Phone)[1]','VARCHAR(50)'),	
				@Mobile = xmlVals.rowvals.value('(Mobile)[1]','VARCHAR(50)'),			 
				@DateMedicalExamination = xmlVals.rowvals.value('(Date)[1]','datetimeoffset'),
				@CertificateDoc = xmlVals.rowvals.value('(CertificateDoc)[1]','VARCHAR(200)')
			From @theXmlData.nodes('//DGDLRenewalExtra/DGDLMedicalAssesmentTbl') as xmlVals(rowvals)
			
			--update tblDGLicenceDriver set
			--MedicalAssessmentID = 1, -- need do somthing with this value
			--MedicalPractitionerName = @MedicalPractitionerName,
			--MedicalPractitionerTelephone = '(' + SUBSTRING(ltrim(rtrim(@Phone)), 0, 3) + ')' + SUBSTRING(ltrim(rtrim(@Phone)), 3, 10),
			--DateMedicalExamination = @DateMedicalExamination
			--where InstrumentID = @LicenceNumber

			SELECT 
				@MedicalPractitionerName as MedicalPractitionerName,	
				@Phone as MedicalPractitionerTelephone,
				'(' + SUBSTRING(ltrim(rtrim(@Phone)), 0, 3) + ')' + SUBSTRING(ltrim(rtrim(@Phone)), 3, 10) as Telephone,
				@Mobile as Mobile,			 
				@DateMedicalExamination as DateMedicalExamination,
				@CertificateDoc as CertificateDoc

		end

		if @DriverDataCount > 0
		begin
			declare @DriversLicenceNo varchar(15)
			declare @DriversLicenceClass varchar(15)
			declare @LicenceIssuedState varchar(3)

			declare @driverPhotoDoc varchar(200)
			declare @driverLicenceDoc varchar(200)
			declare @driverHistoryDoc varchar(200)

			declare @Question1 bit
			declare @Question2 bit
			declare @Question3 bit

			SELECT 
				@DriversLicenceNo = xmlVals.rowvals.value('(LicenceNo)[1]','VARCHAR(15)'),	
				@DriversLicenceClass = xmlVals.rowvals.value('(LicenceClass)[1]','VARCHAR(15)'),			 
				@LicenceIssuedState = xmlVals.rowvals.value('(IssuingState)[1]','VARCHAR(3)'),
				@driverPhotoDoc = xmlVals.rowvals.value('(DriverPhotoDoc)[1]','VARCHAR(200)'),
				@driverLicenceDoc = xmlVals.rowvals.value('(DriverLicenceDoc)[1]','VARCHAR(200)'),
				@driverHistoryDoc = xmlVals.rowvals.value('(DriverHistoryDoc)[1]','VARCHAR(200)'),
				@Question1 = xmlVals.rowvals.value('(Question1)[1]','BIT'),	
				@Question2 = xmlVals.rowvals.value('(Question2)[1]','BIT'),	
				@Question3 = xmlVals.rowvals.value('(Question3)[1]','BIT')
			From @theXmlData.nodes('//DGDLRenewalExtra/DriverLicenceDetailsTbl') as xmlVals(rowvals)

			--update tblDGLicenceDriver set
			-- DriversLicenceNo = @DriversLicenceNo,
			-- DriversLicenceClass = @DriversLicenceClass,
			-- LicenceIssuedState = @LicenceIssuedState,
			-- HeldDriversLicenceForFiveYearsFlag = @Question1,
			-- LicenceDisqualifiedFlag = @Question2
			--where InstrumentID = @LicenceNumber


			select 
			@DriversLicenceNo as LicenceNo,
			@DriversLicenceClass as LicenceClass,
			@LicenceIssuedState as IssuingState,
			@driverPhotoDoc as  DriverPhotoDoc,
			@driverLicenceDoc as  DriverLicenceDoc,
			@driverHistoryDoc as  DriverHistoryDoc,
			@Question1 as Question1,
			@Question2 as Question2,
			@Question3 as Question3
		end

		if @PreviousLicenceDataCount > 0
		begin
			DECLARE @PreviousLicences TABLE(								 
										LicenceNo NVARCHAR(35),
										LicenceType NVARCHAR(50),
										FromDate DATE,													 
										Todate DATE,								 
										Jurisdiction VARCHAR(40),
										OutsideAUIssued VARCHAR(200),
										CertificateDoc  VARCHAR(200)  																				   
									);

			INSERT INTO @PreviousLicences
			SELECT 
				xmlVals.rowvals.value('(LicenceNo)[1]','VARCHAR(100)'),
				xmlVals.rowvals.value('(LicenceType)[1]','VARCHAR(100)'),		 
				xmlVals.rowvals.value('(FromDate)[1]','datetimeoffset'),			 
				xmlVals.rowvals.value('(Todate)[1]','datetimeoffset'),
				xmlVals.rowvals.value('(Jurisdiction)[1]','VARCHAR(100)'),
				xmlVals.rowvals.value('(OutsideAUIssued)[1]','VARCHAR(200)'),
				xmlVals.rowvals.value('(DrivingHistory/DocumentName)[1]','VARCHAR(200)')
			From @theXmlData.nodes('//DGDLRenewalExtra/DriverLicenceDetailsTbl/PreviousDriverLicences/PreviousDriverLicence') as xmlVals(rowvals)

			declare @Jurisdiction varchar(10)
			select top 1 @Jurisdiction = Jurisdiction from @PreviousLicences where len(LicenceNo)  > 0 

			--update tblDGLicenceDriver set
		 --      StateTerritoryOfIssue = @Jurisdiction
			--where InstrumentID = @LicenceNumber
 
            select 	@Jurisdiction as StateTerritoryOfIssue	 

			delete @PreviousLicences
		end
end