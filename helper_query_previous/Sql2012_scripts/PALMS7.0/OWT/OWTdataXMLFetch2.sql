declare @theXMLData XML

set @theXMLData = 
'
<DataBatchJob>
  <OWTAccountableParty>
    <InstrumentID>20556</InstrumentID>
    <AccountablePartyID>4722</AccountablePartyID>
    <TradingName>DP WORLD SYDNEY LIMITED</TradingName>
    <ACN_ARBN />
    <ActiveFlag>true</ActiveFlag>
    <StreetAddress>PO Box 192</StreetAddress>
    <Suburb>MATRAVILLE</Suburb>
    <PostCode>2036</PostCode>
    <StateCode>NSW</StateCode>
  </OWTAccountableParty>
  <OWTLocation>
    <InstrumentID>20556</InstrumentID>
    <LocationID>4299</LocationID>
    <SiteName>DP WORLD SYDNEY LIMITED</SiteName>
    <StreetAddress>42 Friendship Drive</StreetAddress>
    <Suburb>PORT BOTANY</Suburb>
    <PostCode>2036</PostCode>
    <StateCode>NSW</StateCode>
  </OWTLocation>
  <OWTContact>
    <ContactID>13710</ContactID>
    <TitleCodeID>7</TitleCodeID>
    <Surname>Sansom</Surname>
    <Middlename />
    <GivenName>Gavin</GivenName>
    <OrganisationName>DP WORLD SYDNEY LIMITED </OrganisationName>
    <Phone>(02) 9394 0997</Phone>
    <Mobile>0401 148597</Mobile>
    <AfterHoursNumber />
    <Fax>(02) 9394 0940</Fax>
    <Email />
    <AddressID>18417</AddressID>
    <StreetAddress>PO Box 192</StreetAddress>
    <Suburb>MATRAVILLE</Suburb>
    <PostCode>2036</PostCode>
    <StateCode>NSW</StateCode>
  </OWTContact>
</DataBatchJob>
'
declare @TempContactID int
SELECT @TempContactID = xmlVals.rowvals.value('(ContactID)[1]','INT')			 
From @theXmlData.nodes('//DataBatchJob/OWTContact') as xmlVals(rowvals)	

print '@TempContactID=' + cast(@TempContactID as varchar)

