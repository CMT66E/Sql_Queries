select * from tblOnlinePOEOApplication
where OnlinePOEOApplicationID = 53
--where OnlinePOEOApplicationID in (68, 67, 66)
--where cast(LicenceXML as varchar(max)) like '%WorkStageDetails%'

select * from tblInstrument where InstrumentID = 20581

select * from tblOnlinePOEOApplication where InstrumentID is not null


select * from tblInstrument where InstrumentID = 5004138 

select * from tblInstrumentInvoice  where InstrumentID = 20588

select * from tblPOEOLicence where InstrumentID = 20588

declare @TotalFee Money
Select @TotalFee = isnull(dbo.ufn_GetPOEOAdminFee(20588), 0)

declare @InvoiceFee Money
select @InvoiceFee = isnull(InvoiceAmount, 0) from tblInstrumentInvoice  where InstrumentID = 20588

if @TotalFee <= @InvoiceFee
  print 'The Total Fee ' + cast(@TotalFee as varchar) + '$ is less than Invoice Fee ' +   cast(@InvoiceFee as varchar) +'$'


--GRANT EXECUTE ON dbo.[uspPOEOLicneceInvoiceFeeChecking] TO ReadWriteRole

update tblOnlinePOEOApplication set LicenceXML
=
'

<POEOLicence>
  <Id>1</Id>
  <Title>Capture POEO Application Details</Title>
  <Type>0</Type>
  <SavedFormList>
    <int>3</int>
    <int>2</int>
    <int>8</int>
    <int>7</int>
    <int>6</int>
    <int>5</int>
    <int>9</int>
    <int>10</int>
    <int>11</int>
    <int>15</int>
    <int>1</int>
    <int>12</int>
    <int>4</int>
  </SavedFormList>
  <ModifiedFormList>
    <int>13</int>
  </ModifiedFormList>
  <ErrorFormList />
  <Age>0</Age>
  <LicenceTypeID>1100</LicenceTypeID>
  <ApplicantTypeID>1106</ApplicantTypeID>
  <PostalContact>
    <ContactType>0</ContactType>
    <TitleId>0</TitleId>
    <CompanyWeb />
    <IsPostalAddressDifferent>0</IsPostalAddressDifferent>
    <Prefix />
    <Address>sdf</Address>
    <Unit />
    <StreetNo />
    <StreetName>PO BOX 1000</StreetName>
    <Suburb>HURSTVILLE</Suburb>
    <State>NSW</State>
    <Postcode>2222</Postcode>
    <Phone />
    <Email />
    <Fax />
  </PostalContact>
  <PrimaryContact>
    <ContactType>1110</ContactType>
    <TitleId>552</TitleId>
    <GivenName>sdf</GivenName>
    <Surname>sdf</Surname>
    <MiddleName />
    <OrganizationName />
    <Position />
    <IsPostalAddressDifferent>0</IsPostalAddressDifferent>
    <Prefix />
    <Unit />
    <StreetNo>2333</StreetNo>
    <StreetName>woodcrest place</StreetName>
    <Suburb>CHERRYBROOK</Suburb>
    <State>NSW</State>
    <Postcode>2126</Postcode>
    <Phone>(02) 5555 5555</Phone>
    <AfterHoursNumber />
    <Mobile>3333 333333</Mobile>
    <Email>DSFSDF@ADFSDF.COM.AU</Email>
    <Fax />
    <Pager />
  </PrimaryContact>
  <LocationDetails>
    <Name>XCVSDFSDFDFd</Name>
    <Description />
    <SpatialInfoAvailable>true</SpatialInfoAvailable>
    <IsLotDP>true</IsLotDP>
    <spatialLayers>
      <LGA />
      <LBLCatchment />
      <Electorate />
    </spatialLayers>
    <LotDPs>
      <LocationSpatialLotDP>
        <Lot>3</Lot>
        <DP>755253</DP>
        <LGA>GOSFORD</LGA>
        <PartLot>false</PartLot>
        <SectionNumber />
        <LBLCatchment>Hawkesbury</LBLCatchment>
        <Electorate>GOSFORD</Electorate>
      </LocationSpatialLotDP>
      <LocationSpatialLotDP>
        <Lot>45</Lot>
        <DP>816026</DP>
        <LGA>GREATER TAREE</LGA>
        <PartLot>true</PartLot>
        <SectionNumber />
        <LBLCatchment>Hastings</LBLCatchment>
        <Electorate>PORT MACQUARIE</Electorate>
      </LocationSpatialLotDP>
    </LotDPs>
    <SpatialEasting>
      <Easting />
      <Northing />
      <Zone />
      <LGA />
      <LBLCatchment />
      <Electorate />
      <Latitude xmlns:p4="http://www.w3.org/2001/XMLSchema-instance" p4:nil="true" />
      <Longitude xmlns:p4="http://www.w3.org/2001/XMLSchema-instance" p4:nil="true" />
    </SpatialEasting>
    <Address>
      <ContactType>0</ContactType>
      <TitleId>0</TitleId>
      <IsPostalAddressDifferent>0</IsPostalAddressDifferent>
      <Address>DS</Address>
      <Suburb>HURSTVILLE</Suburb>
      <State>NSW</State>
      <Postcode>1212</Postcode>
      <AdditionalInfo />
    </Address>
    <Documents />
  </LocationDetails>
  <FitandProperPerson>
    <R431>false</R431>
    <R432>false</R432>
    <R433>false</R433>
    <R434>false</R434>
    <R435>false</R435>
    <R436>false</R436>
    <Documents>
      <POEOApplicationCommunication>
        <Id>0</Id>
        <CommunicationTypeId>1123</CommunicationTypeId>
        <DocumentName>4000011.pdf|PALMS4df3c6a3-b16a-457a-a8bd-0f94b1bb622c.pdf</DocumentName>
        <Comments />
      </POEOApplicationCommunication>
    </Documents>
    <Statement />
  </FitandProperPerson>
  <AncillaryActivities>
    <POEOAncillaryActivity>
      <ActivityGroupId>0</ActivityGroupId>
      <FeeBasedActivityId>348</FeeBasedActivityId>
    </POEOAncillaryActivity>
  </AncillaryActivities>
  <NonScheduledActivityList />
  <ScheduledActivityList>
    <POEOScheduledActivity>
      <Id>0</Id>
      <ActivityGroupId>43</ActivityGroupId>
      <FeeBasedActivityId>242</FeeBasedActivityId>
      <FeeBasedActivityScaleId>625</FeeBasedActivityScaleId>
    </POEOScheduledActivity>
    <POEOScheduledActivity>
      <Id>0</Id>
      <ActivityGroupId>44</ActivityGroupId>
      <FeeBasedActivityId>342</FeeBasedActivityId>
      <FeeBasedActivityScaleId>957</FeeBasedActivityScaleId>
    </POEOScheduledActivity>
  </ScheduledActivityList>
  <DevConsentDocList />
  <AccountablePartyList>
    <POEOAccountableParty>
      <Id>0</Id>
      <Type>ABN</Type>
      <OrganizationName>SUPERCHARGE BATTERIES PTY LTD</OrganizationName>
      <TradingName />
      <ABN>99 002 848 580</ABN>
      <ACN />
    </POEOAccountableParty>
  </AccountablePartyList>
  <AccountablePartyIndividualList>
    <POEOAccountablePartyIndividual>
      <Id>0</Id>
      <TitleId>552</TitleId>
      <GivenName>Lee</GivenName>
      <Surname>Theresa</Surname>
      <MiddleName />
      <ContactRoleFlag>0</ContactRoleFlag>
      <TradingName />
    </POEOAccountablePartyIndividual>
    <POEOAccountablePartyIndividual>
      <Id>0</Id>
      <TitleId>548</TitleId>
      <GivenName>Howands</GivenName>
      <Surname>John</Surname>
      <MiddleName />
      <ContactRoleFlag>0</ContactRoleFlag>
      <TradingName>hterewrwerwer werwer</TradingName>
    </POEOAccountablePartyIndividual>
  </AccountablePartyIndividualList>
  <PreviousLicenceSupportDocs />
  <ScheduleWork>
    <WorkDesc>asedssdfsdaf</WorkDesc>
    <StartDate>2015-10-08T00:00:00</StartDate>
    <CompleteDate>2015-09-27T00:00:00</CompleteDate>
    <IsWorkInStages>true</IsWorkInStages>
    <StageCount>3</StageCount>
    <AppRelatedStage>1</AppRelatedStage>
    <Stages>
      <WorkStageDetails>
        <StageId>1</StageId>
        <Description>sdfasdfasdf</Description>
      </WorkStageDetails>
      <WorkStageDetails>
        <StageId>2</StageId>
        <Description>23123123123123</Description>
      </WorkStageDetails>
    </Stages>
  </ScheduleWork>
  <WasteDetails>
    <IsOffsiteWasteId>1</IsOffsiteWasteId>
    <IsInsideRegulatedAreaId>1</IsInsideRegulatedAreaId>
    <TrackedWaste>
      <TrackedWasteDetails>
        <WasteCode>3</WasteCode>
        <WasteUse>asdas2342342323234234</WasteUse>
      </TrackedWasteDetails>
      <TrackedWasteDetails>
        <WasteCode>16</WasteCode>
        <WasteUse>dsd23423423423xcvxcvsdffsdfasdfasdfsdsdf</WasteUse>
      </TrackedWasteDetails>
    </TrackedWaste>
    <Classifications>
      <WasteClassification>
        <Classification>1137</Classification>
        <Description>sdfasdfsdf</Description>
      </WasteClassification>
    </Classifications>
  </WasteDetails>
  <Signature>
    <signedByTypeId>4</signedByTypeId>
    <IndividualSignee>
      <ContactType>0</ContactType>
      <TitleId>0</TitleId>
      <IsPostalAddressDifferent>0</IsPostalAddressDifferent>
      <Postcode>0</Postcode>
    </IndividualSignee>
    <DirectorSignee1>
      <ContactType>0</ContactType>
      <TitleId>0</TitleId>
      <IsPostalAddressDifferent>0</IsPostalAddressDifferent>
      <Postcode>0</Postcode>
    </DirectorSignee1>
    <DirectorSignee2>
      <ContactType>0</ContactType>
      <TitleId>0</TitleId>
      <IsPostalAddressDifferent>0</IsPostalAddressDifferent>
      <Postcode>0</Postcode>
    </DirectorSignee2>
    <SecretarySignee>
      <ContactType>0</ContactType>
      <TitleId>0</TitleId>
      <IsPostalAddressDifferent>0</IsPostalAddressDifferent>
      <Postcode>0</Postcode>
    </SecretarySignee>
    <SignatureMethodId>4</SignatureMethodId>
    <isDeclared>1</isDeclared>
  </Signature>
  <supportingDocuments />
  <AppplicationPoint>
    <Id>0</Id>
    <IsDischargePollutants>1</IsDischargePollutants>
    <MapDocs>
      <POEOApplicationCommunication>
        <Id>0</Id>
        <CommunicationTypeId>1115</CommunicationTypeId>
        <DocumentName>ar.pdf|PALMS705bd013-0800-40e7-8e2b-6c6ee626762d.pdf</DocumentName>
        <Comments>test</Comments>
      </POEOApplicationCommunication>
    </MapDocs>
    <LicencePoints>
      <POEOLicencePoint>
        <Id>0</Id>
        <PointTypeId>43</PointTypeId>
        <PointMediumTypeId>562</PointMediumTypeId>
        <PointTypeDescription>dfdfggasdgasdgsdg</PointTypeDescription>
        <RegulatoryGroupId>48</RegulatoryGroupId>
        <EffectiveDate>2015-11-03T00:00:00</EffectiveDate>
        <Easting>319751</Easting>
        <Northing>6705063</Northing>
        <Zone>55</Zone>
        <LGA>INVERELL</LGA>
        <LBLCatchment>Border Rivers</LBLCatchment>
        <Electorate>NORTHERN TABLELANDS</Electorate>
        <Latitude>0</Latitude>
        <Longitude>0</Longitude>
      </POEOLicencePoint>
      <POEOLicencePoint>
        <Id>0</Id>
        <PointTypeId>43</PointTypeId>
        <PointMediumTypeId>563</PointMediumTypeId>
        <PointTypeDescription>my locationds falsdkfjasdklfj sdklfj</PointTypeDescription>
        <RegulatoryGroupId>0</RegulatoryGroupId>
        <ReceivingWaterBody>sdfasdsdsdfasdfsdafsdaf</ReceivingWaterBody>
        <EffectiveDate xmlns:p5="http://www.w3.org/2001/XMLSchema-instance" p5:nil="true" />
        <Easting>554166</Easting>
        <Northing>6139845</Northing>
        <Zone>57</Zone>
        <LGA>JUNEE</LGA>
        <LBLCatchment>Murrumbidgee</LBLCatchment>
        <Electorate>MURRUMBIDGEE</Electorate>
        <Latitude>0</Latitude>
        <Longitude>0</Longitude>
      </POEOLicencePoint>
    </LicencePoints>
    <NoisePoints>
      <POEOLicenceNoisePoint>
        <Id>0</Id>
        <NoisePointTypeId>649</NoisePointTypeId>
        <NoiseLocation>
          <Description>TEST SDFSDAFSDFASDFSDFA SDFASD</Description>
          <SpatialInfoAvailable>true</SpatialInfoAvailable>
          <IsLotDP>true</IsLotDP>
          <spatialLayers>
            <LGA />
            <LBLCatchment />
            <Electorate />
          </spatialLayers>
          <LotDPs>
            <LocationSpatialLotDP>
              <Lot>10</Lot>
              <DP>241859</DP>
              <LGA>PENRITH</LGA>
              <PartLot>false</PartLot>
              <SectionNumber />
              <LBLCatchment>Hawkesbury</LBLCatchment>
              <Electorate>LONDONDERRY</Electorate>
            </LocationSpatialLotDP>
          </LotDPs>
          <SpatialEasting>
            <Easting />
            <Northing />
            <Zone />
            <LGA />
            <LBLCatchment />
            <Electorate />
            <Latitude>0</Latitude>
            <Longitude>0</Longitude>
          </SpatialEasting>
          <Address>
            <ContactType>0</ContactType>
            <TitleId>0</TitleId>
            <IsPostalAddressDifferent>0</IsPostalAddressDifferent>
            <Address>10 KEE</Address>
            <Suburb>HURLSTONE PARK</Suburb>
            <State>NSW</State>
            <Postcode>2193</Postcode>
            <AdditionalInfo>SDSDFSDFSDFSDFSDF</AdditionalInfo>
          </Address>
        </NoiseLocation>
      </POEOLicenceNoisePoint>
      <POEOLicenceNoisePoint>
        <Id>0</Id>
        <NoisePointTypeId>649</NoisePointTypeId>
        <NoiseLocation>
          <Description>test noise</Description>
          <SpatialInfoAvailable>true</SpatialInfoAvailable>
          <IsLotDP>false</IsLotDP>
          <spatialLayers>
            <LGA />
            <LBLCatchment />
            <Electorate />
          </spatialLayers>
          <LotDPs />
          <SpatialEasting>
            <Easting>299321</Easting>
            <Northing>6267962</Northing>
            <Zone>56</Zone>
            <LGA>BLACKTOWN</LGA>
            <LBLCatchment>Hawkesbury</LBLCatchment>
            <Electorate>RIVERSTONE</Electorate>
            <Latitude>-33.7093738835122</Latitude>
            <Longitude>150.834469703756</Longitude>
          </SpatialEasting>
          <Address>
            <ContactType>0</ContactType>
            <TitleId>0</TitleId>
            <IsPostalAddressDifferent>0</IsPostalAddressDifferent>
            <Address>232 pitt st</Address>
            <Suburb>HURSTVILLE</Suburb>
            <State>NSW</State>
            <Postcode>2220</Postcode>
            <AdditionalInfo />
          </Address>
        </NoiseLocation>
      </POEOLicenceNoisePoint>
    </NoisePoints>
  </AppplicationPoint>
  <DevelopmetConsentGrantedFlag>2</DevelopmetConsentGrantedFlag>
  <DevelopmetConsentNeccesoryFlag>0</DevelopmetConsentNeccesoryFlag>
  <DevelopmetConsentDetails />
  <HasPreviousLicence>2</HasPreviousLicence>
  <PreviousLicenceNo />
</POEOLicence>
'
where OnlinePOEOApplicationID = 1
 