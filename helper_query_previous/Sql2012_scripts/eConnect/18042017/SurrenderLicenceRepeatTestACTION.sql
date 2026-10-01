


-----------------------------------------------------
--update tblOnlineLicenceChangeApplication set ApplicationStatusID = 1701 where OnlineLicenceChangeApplicationID = 8
-----------------------------------------------------
--update tblOnlineLicenceChangeApplication set ElectronicSignatureSubmittedFlag = null where OnlineLicenceChangeApplicationID = 8
-----------------------------------------------------

select * from tblOnlineLicenceChangeApplication where OnlineLicenceChangeApplicationID in (13, 8)

select * from tblClassification where ClassificationDomainID = 135

select * from tblOnlineAnnualReturnApplication WHERE AnnualReturnAppID = 3167

-----------------------------------------------------
declare @AppXML XML =
'
<SurrenderDTO>
  <Id>8</Id>
  <Type>0</Type>
  <LicenseeTypeId>1105</LicenseeTypeId>
  <SavedFormList>
    <int>1</int>
    <int>2</int>
    <int>3</int>
  </SavedFormList>
  <ModifiedFormList />
  <ErrorFormList />
  <LicenceTypeID>0</LicenceTypeID>
  <ApplicantTypeID>0</ApplicantTypeID>
  <SurrenderReason>top reason texts</SurrenderReason>
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
  <Signature>
    <signedByTypeId>4</signedByTypeId>
    <TypeOfLicenceHolder>0</TypeOfLicenceHolder>
    <Signee1>
      <Id>0</Id>
      <ContactType>0</ContactType>
      <TitleId>0</TitleId>
      <FullName>MeiX</FullName>
      <Position>Boss</Position>
      <IsPostalAddressDifferent>0</IsPostalAddressDifferent>
      <IsAddressValidationRequred>false</IsAddressValidationRequred>
      <Postcode>0</Postcode>
      <Phone>02 9878 9900</Phone>
      <Email>eric.he@environment.nsw.gov.au</Email>
      <Signed>true</Signed>
      <InstrumentID>0</InstrumentID>
      <IsOverseasAddr>false</IsOverseasAddr>
      <PostalContactFlag>false</PostalContactFlag>
      <EmailContactFlag>false</EmailContactFlag>
      <LinkedLicencesCount>0</LinkedLicencesCount>
    </Signee1>
    <Signee2>
      <Id>0</Id>
      <ContactType>0</ContactType>
      <TitleId>0</TitleId>
      <FullName>Eric Lee</FullName>
      <Position>CEO</Position>
      <IsPostalAddressDifferent>0</IsPostalAddressDifferent>
      <IsAddressValidationRequred>false</IsAddressValidationRequred>
      <Postcode>0</Postcode>
      <Phone>02 9878 9900</Phone>
      <Email>ehe868@gmail.com</Email>
      <Signed>false</Signed>
      <InstrumentID>0</InstrumentID>
      <IsOverseasAddr>false</IsOverseasAddr>
      <PostalContactFlag>false</PostalContactFlag>
      <EmailContactFlag>false</EmailContactFlag>
      <LinkedLicencesCount>0</LinkedLicencesCount>
    </Signee2>
    <IsSignedCopy>2</IsSignedCopy>
    <SignatureMethodId>0</SignatureMethodId>
    <IsDeclared>false</IsDeclared>
  </Signature>
  <supportingDocuments>
    <DocumentDTO>
      <Id>0</Id>
      <CommunicationTypeId>0</CommunicationTypeId>
      <DocumentName>Photo555.jpg|EC8a84ae6e-02f3-47e3-8123-6d7fe2b466a1.jpg</DocumentName>
      <Comments>AAAAAAAAAAAAA</Comments>
    </DocumentDTO>
    <DocumentDTO>
      <Id>0</Id>
      <CommunicationTypeId>0</CommunicationTypeId>
      <DocumentName>Photo444.jpg|EC700a8d91-db4a-456f-9f73-53e881b0944a.jpg</DocumentName>
      <Comments>BBBBBBBBBBB</Comments>
    </DocumentDTO>
  </supportingDocuments>
</SurrenderDTO>
' 
update tblOnlineLicenceChangeApplication set AppXML = @AppXML where OnlineLicenceChangeApplicationID = 8
update tblOnlineLicenceChangeApplication set ElectronicSignatureSubmittedFlag = null where OnlineLicenceChangeApplicationID = 8
update tblOnlineLicenceChangeApplication set ApplicationStatusID = 1701 where OnlineLicenceChangeApplicationID = 7
-----------------------------------------------------

select top 10 * from tblInstrument order by DateCreated desc
select top 10 * from tblNotice order by DateCreated desc

select * from tblAccountableParty where AccountablePartyID = 1593
select * from tblClassification where ClassificationID = 1502
-----------------------------------------------------

