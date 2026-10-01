DECLARE @theXmlData xml
set @theXmlData = 
'
<SurrenderDTO>
  <Id>0</Id>
  <Type>0</Type>
  <LicenseeTypeId>0</LicenseeTypeId>
  <SavedFormList>
    <int>1</int>
  </SavedFormList>
  <ModifiedFormList />
  <ErrorFormList />
  <LicenceTypeID>0</LicenceTypeID>
  <ApplicantTypeID>0</ApplicantTypeID>
  <PrimaryContact>
    <Id>0</Id>
    <ContactType>0</ContactType>
    <TitleId>548</TitleId>
    <GivenName>James</GivenName>
    <Surname>Bond</Surname>
    <MiddleName>King</MiddleName>
    <OrganizationName>Spy Agency</OrganizationName>
    <Position>Professor</Position>
    <Phone>(02) 7899 9900</Phone>
    <Mobile>0421 657890</Mobile>
    <Email>ehe868@gmail.com</Email>
    <Fax>(02) 7899 9900</Fax>
    <Pager>12</Pager>
    <Signed>false</Signed>
  </PrimaryContact>
</SurrenderDTO>
'
 
select @theXmlData = isnull(AppXML, '') from tblOnlineLicenceChangeApplication
where OnlineLicenceChangeApplicationID = 8

declare @ContactDataCount int = 0
select  @ContactDataCount = count(*) From @theXmlData.nodes('//SurrenderDTO/PrimaryContact') as xmlVals(rowvals) 
where len(isnull(xmlVals.rowvals.value('(GivenName)[1]','VARCHAR(50)'), '')) > 0 

print '@ContactDataCount='+ cast(@ContactDataCount as varchar)

if Datalength(@theXmlData) > 0 and @ContactDataCount > 0
begin
			declare @TempId int
			declare @TempContactType int
			declare @TempTitleId int
			declare @TempGivenName varchar(50)
			declare @TempSurname varchar(50)
			declare @TempMiddleName varchar(50)
			declare @TempOrganizationName varchar(500)
			declare @TempPosition varchar(50)
			declare @TempPhone varchar(20)
			declare @TempMobile varchar(20) 
			declare @TempEmail varchar(100)
		    declare @TempFax varchar(20) 
			declare @TempPager varchar(50)
			declare @TempSigned bit

			SELECT 
				@TempId = xmlVals.rowvals.value('(Id)[1]','INT'),	
				@TempContactType = xmlVals.rowvals.value('(ContactType)[1]','INT'),			 
				@TempTitleId = xmlVals.rowvals.value('(TitleId)[1]','INT'),
				@TempGivenName = xmlVals.rowvals.value('(GivenName)[1]','VARCHAR(50)'),
				@TempSurname = xmlVals.rowvals.value('(Surname)[1]','VARCHAR(50)'),
				@TempMiddleName = xmlVals.rowvals.value('(MiddleName)[1]','VARCHAR(50)'),
				@TempOrganizationName = xmlVals.rowvals.value('(OrganizationName)[1]','VARCHAR(500)'), 				 
				@TempPosition = xmlVals.rowvals.value('(Position)[1]','VARCHAR(50)'),
				@TempPhone = xmlVals.rowvals.value('(Phone)[1]','VARCHAR(50)'),
				@TempMobile = xmlVals.rowvals.value('(Mobile)[1]','VARCHAR(50)'),
				@TempEmail = xmlVals.rowvals.value('(Email)[1]','VARCHAR(50)'),
				@TempFax = xmlVals.rowvals.value('(Fax)[1]','VARCHAR(50)'),
				@TempPager = xmlVals.rowvals.value('(Pager)[1]','VARCHAR(50)'),
				@TempSigned = xmlVals.rowvals.value('(Signed)[1]','BIT')
			From @theXmlData.nodes('//SurrenderDTO/PrimaryContact') as xmlVals(rowvals)
			

			select 
			 @TempId as Id,
			 @TempContactType as ContactType,
			 @TempTitleId as TitleId,
			 @TempGivenName as GivenName,
			 @TempSurname as Surname,
			 @TempMiddleName as MiddleName,
			 @TempOrganizationName as OrganizationName,
			 @TempPosition as Position,
			 Replace(Replace(@TempPhone,'(',''), ')','') as Phone, 
			 @TempMobile as Mobile, 
			 @TempEmail as Email,
		     Replace(Replace(@TempFax,'(',''), ')','') as Fax, 
			 @TempPager as Pager,
			 @TempSigned as Signed
			  
end



