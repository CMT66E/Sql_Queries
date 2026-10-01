

	declare @theXMLData AS XML = 
	'
<DataRadiationLocation>
  <RadiationLocation>
    <RadiationLocationID>0</RadiationLocationID>
    <LocationName>pet shop</LocationName>
    <AddressID>0</AddressID>
    <AdditionalAddressInformation>something</AdditionalAddressInformation>
  </RadiationLocation>
  <RadiationLocation>
    <RadiationLocationID>1</RadiationLocationID>
    <LocationName>Darling Harbour</LocationName>
    <AddressID>1</AddressID>
    <AdditionalAddressInformation>in testing</AdditionalAddressInformation>
  </RadiationLocation>
  <RadiationLocation>
    <RadiationLocationID>2</RadiationLocationID>
    <LocationName>oo</LocationName>
    <AddressID>2</AddressID>
    <AdditionalAddressInformation />
  </RadiationLocation>
  <Address>
    <AddressID>0</AddressID>
    <Address>101 Jersey Street</Address>
    <Suburb>HORNSBY</Suburb>
    <Postcode>2077</Postcode>
    <StateCode>NSW</StateCode>
  </Address>
  <Address>
    <AddressID>1</AddressID>
    <Address>134 Forest Road</Address>
    <Suburb>SYDNEY</Suburb>
    <Postcode>2000</Postcode>
    <StateCode>NSW</StateCode>
  </Address>
  <Address>
    <AddressID>2</AddressID>
    <Address>oo</Address>
    <Suburb>HURSTVILLE</Suburb>
    <Postcode>2220</Postcode>
    <StateCode>NSW</StateCode>
  </Address>
  <RadiationLocationRRM>
    <RadiationLocationRRMID>-1</RadiationLocationRRMID>
    <RadiationLocationID>0</RadiationLocationID>
    <RadiationLicenceRRMID>0</RadiationLicenceRRMID>
  </RadiationLocationRRM>
  <RadiationLocationRRM>
    <RadiationLocationRRMID>-1</RadiationLocationRRMID>
    <RadiationLocationID>0</RadiationLocationID>
    <RadiationLicenceRRMID>1</RadiationLicenceRRMID>
  </RadiationLocationRRM>
  <RadiationLocationRRM>
    <RadiationLocationRRMID>-1</RadiationLocationRRMID>
    <RadiationLocationID>0</RadiationLocationID>
    <RadiationLicenceRRMID>2</RadiationLicenceRRMID>
  </RadiationLocationRRM>
  <RadiationLocationRRM>
    <RadiationLocationRRMID>-1</RadiationLocationRRMID>
    <RadiationLocationID>0</RadiationLocationID>
    <RadiationLicenceRRMID>3</RadiationLicenceRRMID>
  </RadiationLocationRRM>
  <RadiationLocationRRM>
    <RadiationLocationRRMID>-1</RadiationLocationRRMID>
    <RadiationLocationID>1</RadiationLocationID>
    <RadiationLicenceRRMID>4</RadiationLicenceRRMID>
  </RadiationLocationRRM>
  <RadiationLocationRRM>
    <RadiationLocationRRMID>-1</RadiationLocationRRMID>
    <RadiationLocationID>1</RadiationLocationID>
    <RadiationLicenceRRMID>5</RadiationLicenceRRMID>
  </RadiationLocationRRM>
  <RadiationLocationRRM>
    <RadiationLocationRRMID>-1</RadiationLocationRRMID>
    <RadiationLocationID>1</RadiationLocationID>
    <RadiationLicenceRRMID>6</RadiationLicenceRRMID>
  </RadiationLocationRRM>
  <RadiationLocationRRM>
    <RadiationLocationRRMID>-1</RadiationLocationRRMID>
    <RadiationLocationID>2</RadiationLocationID>
    <RadiationLicenceRRMID>7</RadiationLicenceRRMID>
  </RadiationLocationRRM>
  <RadiationLicenceRRM>
    <RadiationLicenceRRMID>0</RadiationLicenceRRMID>
    <RRMStatusID>784</RRMStatusID>
    <RRMTypeID>1</RRMTypeID>
    <RRMID>13</RRMID>
    <RRMPurposeID>7</RRMPurposeID>
    <WorkArea>dfdsf</WorkArea>
    <RRMSecurityClassificationID p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
    <LaboratoryClassificationID>-1</LaboratoryClassificationID>
    <RRMDepartmentID>0</RRMDepartmentID>
  </RadiationLicenceRRM>
  <RadiationLicenceRRM>
    <RadiationLicenceRRMID>1</RadiationLicenceRRMID>
    <RRMStatusID>784</RRMStatusID>
    <RRMTypeID>1</RRMTypeID>
    <RRMID>7</RRMID>
    <RRMPurposeID>5</RRMPurposeID>
    <WorkArea>efewgew</WorkArea>
    <RRMSecurityClassificationID p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
    <LaboratoryClassificationID>-1</LaboratoryClassificationID>
    <RRMDepartmentID>0</RRMDepartmentID>
  </RadiationLicenceRRM>
  <RadiationLicenceRRM>
    <RadiationLicenceRRMID>2</RadiationLicenceRRMID>
    <RRMStatusID>784</RRMStatusID>
    <RRMTypeID>1</RRMTypeID>
    <RRMID>6</RRMID>
    <RRMPurposeID>4</RRMPurposeID>
    <WorkArea>fdgdfggg</WorkArea>
    <RRMSecurityClassificationID p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
    <LaboratoryClassificationID>-1</LaboratoryClassificationID>
    <RRMDepartmentID>0</RRMDepartmentID>
  </RadiationLicenceRRM>
  <RadiationLicenceRRM>
    <RadiationLicenceRRMID>3</RadiationLicenceRRMID>
    <RRMStatusID>784</RRMStatusID>
    <RRMTypeID>1</RRMTypeID>
    <RRMID>4</RRMID>
    <RRMPurposeID>3</RRMPurposeID>
    <WorkArea>dfsdfd</WorkArea>
    <RRMSecurityClassificationID p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
    <LaboratoryClassificationID>-1</LaboratoryClassificationID>
    <RRMDepartmentID>1</RRMDepartmentID>
  </RadiationLicenceRRM>
  <RadiationLicenceRRM>
    <RadiationLicenceRRMID>4</RadiationLicenceRRMID>
    <RRMStatusID>784</RRMStatusID>
    <RRMTypeID>2</RRMTypeID>
    <RRMID>33</RRMID>
    <RRMPurposeID>-1</RRMPurposeID>
    <WorkArea>dgdguu543666u</WorkArea>
    <RRMSecurityClassificationID p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
    <LaboratoryClassificationID>-1</LaboratoryClassificationID>
    <RRMDepartmentID>3</RRMDepartmentID>
  </RadiationLicenceRRM>
  <RadiationLicenceRRM>
    <RadiationLicenceRRMID>5</RadiationLicenceRRMID>
    <RRMStatusID>784</RRMStatusID>
    <RRMTypeID>2</RRMTypeID>
    <RRMID>36</RRMID>
    <RRMPurposeID>-1</RRMPurposeID>
    <WorkArea>ertertr</WorkArea>
    <RRMSecurityClassificationID p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
    <LaboratoryClassificationID>-1</LaboratoryClassificationID>
    <RRMDepartmentID>2</RRMDepartmentID>
  </RadiationLicenceRRM>
  <RadiationLicenceRRM>
    <RadiationLicenceRRMID>6</RadiationLicenceRRMID>
    <RRMStatusID>784</RRMStatusID>
    <RRMTypeID>3</RRMTypeID>
    <RRMID>-1</RRMID>
    <RRMPurposeID>-1</RRMPurposeID>
    <WorkArea>sfgfd</WorkArea>
    <RRMSecurityClassificationID p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
    <LaboratoryClassificationID>-1</LaboratoryClassificationID>
    <RRMDepartmentID>3</RRMDepartmentID>
  </RadiationLicenceRRM>
  <RadiationLicenceRRM>
    <RadiationLicenceRRMID>7</RadiationLicenceRRMID>
    <RRMStatusID>784</RRMStatusID>
    <RRMTypeID>4</RRMTypeID>
    <RRMID>-1</RRMID>
    <RRMPurposeID>16</RRMPurposeID>
    <WorkArea>gdfgdfgfd</WorkArea>
    <RRMSecurityClassificationID p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
    <LaboratoryClassificationID>771</LaboratoryClassificationID>
    <RRMDepartmentID>5</RRMDepartmentID>
  </RadiationLicenceRRM>
  <RRMComponent>
    <RRMComponentID>0</RRMComponentID>
    <RadiationLicenceRRMID>0</RadiationLicenceRRMID>
    <ComponentStatusID>784</ComponentStatusID>
    <RRMComponentTypeID>1</RRMComponentTypeID>
    <ManufacturerID>40</ManufacturerID>
    <ModelNumber>dfsd</ModelNumber>
    <SerialNumber>dgdgggg</SerialNumber>
    <ExtendedWorkingLifeFlag p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
    <WorkingLife p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
    <RadionuclideID p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
    <NominalActivity p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
  </RRMComponent>
  <RRMComponent>
    <RRMComponentID>1</RRMComponentID>
    <RadiationLicenceRRMID>0</RadiationLicenceRRMID>
    <ComponentStatusID>784</ComponentStatusID>
    <RRMComponentTypeID>2</RRMComponentTypeID>
    <ManufacturerID>72</ManufacturerID>
    <ModelNumber>dgdg</ModelNumber>
    <SerialNumber>dgds</SerialNumber>
    <ExtendedWorkingLifeFlag p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
    <WorkingLife p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
    <RadionuclideID p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
    <NominalActivity p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
  </RRMComponent>
  <RRMComponent>
    <RRMComponentID>2</RRMComponentID>
    <RadiationLicenceRRMID>0</RadiationLicenceRRMID>
    <ComponentStatusID>784</ComponentStatusID>
    <RRMComponentTypeID>3</RRMComponentTypeID>
    <ManufacturerID>273</ManufacturerID>
    <ModelNumber>dsgfdsg</ModelNumber>
    <SerialNumber>dgsgdgdg</SerialNumber>
    <ExtendedWorkingLifeFlag p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
    <WorkingLife p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
    <RadionuclideID p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
    <NominalActivity p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
  </RRMComponent>
  <RRMComponent>
    <RRMComponentID>3</RRMComponentID>
    <RadiationLicenceRRMID>1</RadiationLicenceRRMID>
    <ComponentStatusID>784</ComponentStatusID>
    <RRMComponentTypeID>1</RRMComponentTypeID>
    <ManufacturerID>49</ManufacturerID>
    <ModelNumber>1225</ModelNumber>
    <SerialNumber>225885</SerialNumber>
    <ExtendedWorkingLifeFlag p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
    <WorkingLife p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
    <RadionuclideID p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
    <NominalActivity p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
  </RRMComponent>
  <RRMComponent>
    <RRMComponentID>4</RRMComponentID>
    <RadiationLicenceRRMID>1</RadiationLicenceRRMID>
    <ComponentStatusID>784</ComponentStatusID>
    <RRMComponentTypeID>2</RRMComponentTypeID>
    <ManufacturerID>42</ManufacturerID>
    <ModelNumber>12369</ModelNumber>
    <SerialNumber>122358</SerialNumber>
    <ExtendedWorkingLifeFlag p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
    <WorkingLife p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
    <RadionuclideID p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
    <NominalActivity p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
  </RRMComponent>
  <RRMComponent>
    <RRMComponentID>5</RRMComponentID>
    <RadiationLicenceRRMID>1</RadiationLicenceRRMID>
    <ComponentStatusID>784</ComponentStatusID>
    <RRMComponentTypeID>3</RRMComponentTypeID>
    <ManufacturerID>264</ManufacturerID>
    <ModelNumber>122558</ModelNumber>
    <SerialNumber>147877</SerialNumber>
    <ExtendedWorkingLifeFlag p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
    <WorkingLife p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
    <RadionuclideID p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
    <NominalActivity p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
  </RRMComponent>
  <RRMComponent>
    <RRMComponentID>6</RRMComponentID>
    <RadiationLicenceRRMID>2</RadiationLicenceRRMID>
    <ComponentStatusID>784</ComponentStatusID>
    <RRMComponentTypeID>1</RRMComponentTypeID>
    <ManufacturerID>92</ManufacturerID>
    <ModelNumber>44534534</ModelNumber>
    <SerialNumber>45346</SerialNumber>
    <ExtendedWorkingLifeFlag p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
    <WorkingLife p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
    <RadionuclideID p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
    <NominalActivity p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
  </RRMComponent>
  <RRMComponent>
    <RRMComponentID>7</RRMComponentID>
    <RadiationLicenceRRMID>2</RadiationLicenceRRMID>
    <ComponentStatusID>784</ComponentStatusID>
    <RRMComponentTypeID>2</RRMComponentTypeID>
    <ManufacturerID>72</ManufacturerID>
    <ModelNumber>45454</ModelNumber>
    <SerialNumber>4534534</SerialNumber>
    <ExtendedWorkingLifeFlag p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
    <WorkingLife p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
    <RadionuclideID p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
    <NominalActivity p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
  </RRMComponent>
  <RRMComponent>
    <RRMComponentID>8</RRMComponentID>
    <RadiationLicenceRRMID>2</RadiationLicenceRRMID>
    <ComponentStatusID>784</ComponentStatusID>
    <RRMComponentTypeID>3</RRMComponentTypeID>
    <ManufacturerID>262</ManufacturerID>
    <ModelNumber>545345</ModelNumber>
    <SerialNumber>5435435</SerialNumber>
    <ExtendedWorkingLifeFlag p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
    <WorkingLife p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
    <RadionuclideID p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
    <NominalActivity p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
  </RRMComponent>
  <RRMComponent>
    <RRMComponentID>9</RRMComponentID>
    <RadiationLicenceRRMID>3</RadiationLicenceRRMID>
    <ComponentStatusID>784</ComponentStatusID>
    <RRMComponentTypeID>1</RRMComponentTypeID>
    <ManufacturerID>74</ManufacturerID>
    <ModelNumber>dfsdf</ModelNumber>
    <SerialNumber>fdsfsd</SerialNumber>
    <ExtendedWorkingLifeFlag p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
    <WorkingLife p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
    <RadionuclideID p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
    <NominalActivity p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
  </RRMComponent>
  <RRMComponent>
    <RRMComponentID>10</RRMComponentID>
    <RadiationLicenceRRMID>3</RadiationLicenceRRMID>
    <ComponentStatusID>784</ComponentStatusID>
    <RRMComponentTypeID>2</RRMComponentTypeID>
    <ManufacturerID>262</ManufacturerID>
    <ModelNumber>erew</ModelNumber>
    <SerialNumber>were</SerialNumber>
    <ExtendedWorkingLifeFlag p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
    <WorkingLife p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
    <RadionuclideID p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
    <NominalActivity p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
  </RRMComponent>
  <RRMComponent>
    <RRMComponentID>11</RRMComponentID>
    <RadiationLicenceRRMID>3</RadiationLicenceRRMID>
    <ComponentStatusID>784</ComponentStatusID>
    <RRMComponentTypeID>3</RRMComponentTypeID>
    <ManufacturerID>234</ManufacturerID>
    <ModelNumber>77555</ModelNumber>
    <SerialNumber>575757</SerialNumber>
    <ExtendedWorkingLifeFlag p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
    <WorkingLife p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
    <RadionuclideID p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
    <NominalActivity p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
  </RRMComponent>
  <RRMComponent>
    <RRMComponentID>12</RRMComponentID>
    <RadiationLicenceRRMID>4</RadiationLicenceRRMID>
    <ComponentStatusID>784</ComponentStatusID>
    <RRMComponentTypeID>4</RRMComponentTypeID>
    <ManufacturerID>49</ManufacturerID>
    <ModelNumber>11555233</ModelNumber>
    <SerialNumber>2259944</SerialNumber>
    <ExtendedWorkingLifeFlag p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
    <WorkingLife p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
    <RadionuclideID p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
    <NominalActivity p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
  </RRMComponent>
  <RRMComponent>
    <RRMComponentID>13</RRMComponentID>
    <RadiationLicenceRRMID>4</RadiationLicenceRRMID>
    <ComponentStatusID>784</ComponentStatusID>
    <RRMComponentTypeID>5</RRMComponentTypeID>
    <ManufacturerID>74</ManufacturerID>
    <SerialNumber>1258522</SerialNumber>
    <ExtendedWorkingLifeFlag>false</ExtendedWorkingLifeFlag>
    <WorkingLife>15</WorkingLife>
    <RadionuclideID>6</RadionuclideID>
    <NominalActivity>12.0</NominalActivity>
  </RRMComponent>
  <RRMComponent>
    <RRMComponentID>14</RRMComponentID>
    <RadiationLicenceRRMID>4</RadiationLicenceRRMID>
    <ComponentStatusID>784</ComponentStatusID>
    <RRMComponentTypeID>5</RRMComponentTypeID>
    <ManufacturerID>49</ManufacturerID>
    <SerialNumber>1225</SerialNumber>
    <ExtendedWorkingLifeFlag>true</ExtendedWorkingLifeFlag>
    <WorkingLife>25</WorkingLife>
    <RadionuclideID>6</RadionuclideID>
    <NominalActivity>123.12</NominalActivity>
  </RRMComponent>
  <RRMComponent>
    <RRMComponentID>15</RRMComponentID>
    <RadiationLicenceRRMID>5</RadiationLicenceRRMID>
    <ComponentStatusID>784</ComponentStatusID>
    <RRMComponentTypeID>4</RRMComponentTypeID>
    <ManufacturerID>72</ManufacturerID>
    <ModelNumber>4556</ModelNumber>
    <SerialNumber>5656</SerialNumber>
    <ExtendedWorkingLifeFlag p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
    <WorkingLife p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
    <RadionuclideID p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
    <NominalActivity p3:nil="true" xmlns:p3="http://www.w3.org/2001/XMLSchema-instance" />
  </RRMComponent>
  <RRMComponent>
    <RRMComponentID>16</RRMComponentID>
    <RadiationLicenceRRMID>5</RadiationLicenceRRMID>
    <ComponentStatusID>784</ComponentStatusID>
    <RRMComponentTypeID>5</RRMComponentTypeID>
    <ManufacturerID>264</ManufacturerID>
    <SerialNumber>55</SerialNumber>
    <ExtendedWorkingLifeFlag>true</ExtendedWorkingLifeFlag>
    <WorkingLife>8</WorkingLife>
    <RadionuclideID>16</RadionuclideID>
    <NominalActivity>55.0</NominalActivity>
  </RRMComponent>
  <RRMComponent>
    <RRMComponentID>17</RRMComponentID>
    <RadiationLicenceRRMID>6</RadiationLicenceRRMID>
    <ComponentStatusID>784</ComponentStatusID>
    <RRMComponentTypeID>6</RRMComponentTypeID>
    <ManufacturerID>0</ManufacturerID>
    <SerialNumber>5455</SerialNumber>
    <ExtendedWorkingLifeFlag>false</ExtendedWorkingLifeFlag>
    <WorkingLife>15</WorkingLife>
    <RadionuclideID>0</RadionuclideID>
    <NominalActivity>78.0</NominalActivity>
  </RRMComponent>
  <RadiationDepartment>
    <RadiationDepartmentID>0</RadiationDepartmentID>
    <RadiationLocationID>0</RadiationLocationID>
    <DepartmentName>Science Department</DepartmentName>
  </RadiationDepartment>
  <RadiationDepartment>
    <RadiationDepartmentID>1</RadiationDepartmentID>
    <RadiationLocationID>0</RadiationLocationID>
    <DepartmentName>Biological Department</DepartmentName>
  </RadiationDepartment>
  <RadiationDepartment>
    <RadiationDepartmentID>2</RadiationDepartmentID>
    <RadiationLocationID>1</RadiationLocationID>
    <DepartmentName>dfsd</DepartmentName>
  </RadiationDepartment>
  <RadiationDepartment>
    <RadiationDepartmentID>3</RadiationDepartmentID>
    <RadiationLocationID>1</RadiationLocationID>
    <DepartmentName>dep 2</DepartmentName>
  </RadiationDepartment>
  <RadiationDepartment>
    <RadiationDepartmentID>4</RadiationDepartmentID>
    <RadiationLocationID>2</RadiationLocationID>
    <DepartmentName>8987989</DepartmentName>
  </RadiationDepartment>
  <RadiationDepartment>
    <RadiationDepartmentID>5</RadiationDepartmentID>
    <RadiationLocationID>2</RadiationLocationID>
    <DepartmentName>3333</DepartmentName>
  </RadiationDepartment>
</DataRadiationLocation>
	'


-------------------------------------------------------
	declare @theInstrumentID INT = 5068698
-------------------------------------------------------
    SET NOCOUNT ON
	DECLARE @tblRadiationLocation tblInstrumentRadiationLocationType

	BEGIN TRY
			if DATALENGTH(@theXMLData) > 0 
			begin
					declare @LocationDataCount int = 0
					select  @LocationDataCount = count(*) From @theXMLData.nodes('//DataRadiationLocation/RadiationLocation') as xmlVals(rowvals) 
					where len(isnull(xmlVals.rowvals.value('(LocationName)[1]','VARCHAR(500)'), '')) > 0 

					--print '@@LocationDataCount='+ cast(@LocationDataCount as varchar)

					------ Start RadiationLocation --------------------------------
					DECLARE @TempRadiationLocation AS TABLE(
															[RadiationLocationID] [int] NOT NULL,
															[LocationName] [varchar](128) NOT NULL,
															[AddressID] [int] NULL,
															[AdditionalAddressInformation] [varchar](1000) NULL,
															[EffectiveDateFrom] [smalldatetime] NULL,
															[EffectiveDateTo] [smalldatetime] NULL,
															[DateCreated] [smalldatetime] NULL,
															[CreatedBySystemUserID] [int] NULL,
															[DateUpdated] [smalldatetime] NULL,
															[UpdatedBySystemUserID] [int] NULL,
															[RowTimestamp] [varchar](4000) NULL,
															[InstrumentID] [int] NULL)

					INSERT INTO @TempRadiationLocation
						(
							[RadiationLocationID],
							[LocationName],
							[AddressID],
							[AdditionalAddressInformation],	
							[EffectiveDateFrom],
							[EffectiveDateTo],
							[DateCreated],
							[CreatedBySystemUserID],
							[DateUpdated],
							[UpdatedBySystemUserID],			 						 
							[InstrumentID]
						)
						SELECT
							xmlVals.rowvals.value('(RadiationLocationID)[1]','INT'),
							xmlVals.rowvals.value('(LocationName)[1]','VARCHAR(128)'),
							xmlVals.rowvals.value('(AddressID)[1]','int'),
							xmlVals.rowvals.value('(AdditionalAddressInformation)[1]','VARCHAR(1000)'),		
							getdate() as [EffectiveDateFrom],
							null as  [EffectiveDateTo],
							getdate() as [DateCreated],
							1 as [CreatedBySystemUserID],
							null as [DateUpdated],
							null as [UpdatedBySystemUserID],		 
							0 as [InstrumentID]
						From @theXMLData.nodes('//DataRadiationLocation/RadiationLocation') as xmlVals(rowvals)

					--******************************************************
					--select * from @TempRadiationLocation
					--******************************************************
					------ End RadiationLocation --------------------------------


					------ Start Address --------------------------------
					DECLARE @tblAddress tblAddressType

					INSERT INTO @tblAddress(AddressID
											,[Address]
											,Suburb
											,Postcode
											,StateCode
											,CreatedBySystemUserID
											,UpdatedBySystemUserID
								 
											,PrefixAddress
											,Country
											,OverseasAddressFlag)
					SELECT	RN.S.value('AddressID[1]','int') AS AddressID,
							RN.S.value('Address[1]','varchar(100)') AS Address,
							RN.S.value('Suburb[1]','varchar(100)') AS Suburb,
							RN.S.value('Postcode[1]','char(10)') AS Postcode,
							RN.S.value('StateCode[1]','char(20)') AS StateCode,
							1 AS CreatedBySystemUserID,
							null AS UpdatedBySystemUserID,
				 
							null AS PrefixAddress,	
							null AS Country,		 
							0 AS OverseasAddressFlag			 
					FROM @theXMLData.nodes('//DataRadiationLocation/Address') AS RN(S)
					--******************************************************
					--select * from @tblAddress
					--******************************************************
					------ End Address --------------------------------

					------- Start Radiation Department -----------------------------------
					DECLARE @TempRadiationDepartmentHold AS TABLE(
					                                        [RadiationDepartmentID] [int] NOT NULL,
															[RadiationLocationID] [int] NOT NULL,
															[DepartmentName] [varchar](200) NOT NULL,														 
															[EffectiveDateFrom] [smalldatetime] NULL,
															[EffectiveDateTo] [smalldatetime] NULL,
															[DateCreated] [smalldatetime] NULL,
															[CreatedBySystemUserID] [int] NULL,
															[DateUpdated] [smalldatetime] NULL,
															[UpdatedBySystemUserID] [int] NULL,		
															[Action] [char] NULL,													 
															[FinalDepartmentID] [int] NULL)

					DECLARE @tblRadiationDepartment0 tblRadiationDepartmentType

					INSERT INTO @tblRadiationDepartment0
						(
							[RadiationDepartmentID],
							[RadiationLocationID],
							[DepartmentName],				 
							[EffectiveDateFrom],
							[EffectiveDateTo],
							[DateCreated],
							[CreatedBySystemUserID],
							[DateUpdated],
							[UpdatedBySystemUserID],			 
							[Action]
						)
						SELECT
							xmlVals.rowvals.value('(RadiationDepartmentID)[1]','INT'),
							xmlVals.rowvals.value('(RadiationLocationID)[1]','int'),
							xmlVals.rowvals.value('(DepartmentName)[1]','VARCHAR(255)'),												 
							getdate() as [EffectiveDateFrom],
							null as  [EffectiveDateTo],
							getdate() as [DateCreated],
							1 as [CreatedBySystemUserID],
							null as [DateUpdated],
							null as [UpdatedBySystemUserID],							 
							'I' as [Action]
						From @theXMLData.nodes('//DataRadiationLocation/RadiationDepartment') as xmlVals(rowvals)

					   --we make a replicated table to hold values
					   insert into @TempRadiationDepartmentHold
					   (
					                                        [RadiationDepartmentID],
															[RadiationLocationID],
															[DepartmentName],														 
															[EffectiveDateFrom],
															[EffectiveDateTo],
															[DateCreated],
															[CreatedBySystemUserID],
															[DateUpdated],
															[UpdatedBySystemUserID],		
															[Action],													 
															[FinalDepartmentID]
					   )
					   select 
					                                        [RadiationDepartmentID],
															[RadiationLocationID],
															[DepartmentName],														 
															[EffectiveDateFrom],
															[EffectiveDateTo],
															[DateCreated],
															[CreatedBySystemUserID],
															[DateUpdated],
															[UpdatedBySystemUserID],		
															[Action],	
															0 as [FinalDepartmentID]
					   from @tblRadiationDepartment0
					--******************************************************
					--select * from @tblRadiationDepartment
					--******************************************************
						------- End Radiation Department-----------------------------------
				


						------- Start RadiationLocationRRM -----------------------------------
					DECLARE @TempRadiationLocationRRM0 AS TABLE(
																[RadiationLocationRRMID] [int] NOT NULL,
																[RadiationLocationID] [int] NOT NULL,
																[RadiationLicenceRRMID] [int] NOT NULL,
																[VariationPendingFlag] [bit] NOT NULL,
																[NewLocationID] [int] NULL,
																[Notes] [varchar](255) NULL,
																[InterstateOverseasRelocationFlag] [bit] NOT NULL,
																[Recipient] [varchar](150) NULL,
																[RecipientAddress] [varchar](255) NULL,
																[State] [varchar](3) NULL,
																[Country] [varchar](150) NULL,
																[EffectiveDateFrom] [smalldatetime] NOT NULL,
																[EffectiveDateTo] [smalldatetime] NULL,
																[DateCreated] [smalldatetime] NOT NULL,
																[CreatedBySystemUserID] [int] NOT NULL,
																[DateUpdated] [smalldatetime] NULL,
																[UpdatedBySystemUserID] [int] NULL,
																[RowTimestamp] [varchar](4000) NULL,
																[RecordMode] [varchar](1) NULL,
																[FLAG] [int]) 

					INSERT INTO @TempRadiationLocationRRM0
						(
							[RadiationLocationRRMID]
							,[RadiationLocationID]
							,[RadiationLicenceRRMID]
							,[VariationPendingFlag]
							,[InterstateOverseasRelocationFlag]
							,[Notes]
							,[EffectiveDateFrom]
							,[EffectiveDateTo]
							,[DateCreated]
							,[CreatedBySystemUserID]
							,[DateUpdated]
							,[UpdatedBySystemUserID]			 
							,[RecordMode]
							,[FLAG]
						)
						SELECT
							xmlVals.rowvals.value('(RadiationLocationRRMID)[1]','INT'),
							xmlVals.rowvals.value('(RadiationLocationID)[1]','INT'),
							xmlVals.rowvals.value('(RadiationLicenceRRMID)[1]','INT'),
							0 as [VariationPendingFlag],	
							0 as [InterstateOverseasRelocationFlag],			
							'' as [Notes],		
							getdate() as [EffectiveDateFrom],
							null as  [EffectiveDateTo],
							getdate() as [DateCreated],
							1 as [CreatedBySystemUserID],
							null as [DateUpdated],
							null as [UpdatedBySystemUserID],
							'A' as [RecordMode],
							0 as [FLAG]
						From @theXMLData.nodes('//DataRadiationLocation/RadiationLocationRRM') as xmlVals(rowvals)

					--******************************************************
					--select * from @TempRadiationLocationRRM0
					--******************************************************
						------- End RadiationLocationRRM-----------------------------------


					------- Start RadiationLicenceRRM-----------------------------------
					DECLARE @TempRadiationLicenceRRM0 AS TABLE(
																[RadiationLicenceRRMID] [int] NOT NULL,
																[RRMStatusID] [smallint] NOT NULL,
																[RRMTypeID] [smallint] NOT NULL,
																[RRMPurposeID] [smallint] NULL,
																[RRMID] [smallint] NULL,
																[WorkArea] [varchar](255) NULL,
																[RRMSecurityClassificationID] [smallint] NULL,
																[LaboratoryClassificationID] [smallint] NULL,
																[DateCreated] [smalldatetime] NOT NULL,
																[CreatedBySystemUserID] [int] NOT NULL,
																[DateUpdated] [smalldatetime] NULL,
																[UpdatedBySystemUserID] [int] NULL,
																[RowTimestamp] [varchar](4000) NULL,
																[RecordMode] [varchar](1) NULL,
																[NewRadiationLicenceRRMID] [int] NULL,
																[RRMDepartmentID] [smallint] NULL,
																[FLAG] [int] 
																)

					INSERT INTO @TempRadiationLicenceRRM0
						(
								[RadiationLicenceRRMID]
							,[RRMStatusID]
							,[RRMTypeID]
							,[RRMPurposeID]
							,[RRMID]
							,[WorkArea]
							,[RRMSecurityClassificationID]
							,[LaboratoryClassificationID]

							,[DateCreated]
							,[CreatedBySystemUserID]
							,[DateUpdated]
							,[UpdatedBySystemUserID]
				 
							,[RecordMode]
							,[NewRadiationLicenceRRMID]
							,[RRMDepartmentID]
							,[FLAG]
						)
						SELECT
							xmlVals.rowvals.value('(RadiationLicenceRRMID)[1]','INT'),
							xmlVals.rowvals.value('(RRMStatusID)[1]','INT'),
							xmlVals.rowvals.value('(RRMTypeID)[1]','INT'),
							xmlVals.rowvals.value('(RRMPurposeID)[1]','INT'),
							xmlVals.rowvals.value('(RRMID)[1]','int'),				
							xmlVals.rowvals.value('(WorkArea)[1]','varchar(255)'),		
							xmlVals.rowvals.value('(RRMSecurityClassificationID)[1]','smallint'),
							xmlVals.rowvals.value('(LaboratoryClassificationID)[1]','smallint'),
						
							getdate() as [DateCreated],
							1 as [CreatedBySystemUserID],
							null as [DateUpdated],
							null as [UpdatedBySystemUserID],
							'A' as RecordMode, 	
							null as [NewRadiationLicenceRRMID],							
							xmlVals.rowvals.value('(RRMDepartmentID)[1]','smallint'),
							0 as [FLAG]
						From @theXMLData.nodes('//DataRadiationLocation/RadiationLicenceRRM') as xmlVals(rowvals)
			
			  
					--******************************************************
					--select * from @TempRadiationLicenceRRM0
					--******************************************************					 
						------- End RadiationLicenceRRM-----------------------------------


						------- Start RadiationLicenceRRMComponent-----------------------------------
					DECLARE @TempRadiationLicenceRRMComponent0 AS TABLE(
																		[RadiationLicenceRRMComponentID] [int] NOT NULL,
																		[RadiationLicenceRRMID] [int] NOT NULL,
																		[RRMComponentID] [int] NOT NULL,
																		[VariationPendingFlag] [bit] NOT NULL,
																		[NewRadiationLicenceRRMID] [int] NULL,
																		[Notes] [varchar](255) NULL,
																		[InterstateOverseasRelocationFlag] [bit] NOT NULL,
																		[Recipient] [varchar](150) NULL,
																		[RecipientAddress] [varchar](255) NULL,
																		[State] [varchar](3) NULL,
																		[Country] [varchar](150) NULL,
																		[EffectiveDateFrom] [smalldatetime] NOT NULL,
																		[EffectiveDateTo] [smalldatetime] NULL,
																		[DateCreated] [smalldatetime] NOT NULL,
																		[CreatedBySystemUserID] [int] NOT NULL,
																		[DateUpdated] [smalldatetime] NULL,
																		[UpdatedBySystemUserID] [int] NULL,
																		[RowTimestamp] [varchar](4000) NULL,
																		[RecordMode] [varchar](1) NULL)

					INSERT INTO @TempRadiationLicenceRRMComponent0
								(
									[RadiationLicenceRRMComponentID]
									,[RadiationLicenceRRMID]
									,[RRMComponentID]
									,[VariationPendingFlag]
									,[Notes]
									,[InterstateOverseasRelocationFlag]
									,[EffectiveDateFrom]
									,[DateCreated]
									,[CreatedBySystemUserID]
									,[DateUpdated]
									,[UpdatedBySystemUserID]					 
									,[RecordMode]
								)
								SELECT
									xmlVals.rowvals.value('(RadiationLicenceRRMComponentID)[1]','INT'),
									xmlVals.rowvals.value('(RadiationLicenceRRMID)[1]','INT'),
									xmlVals.rowvals.value('(RRMComponentID)[1]','INT'),
									xmlVals.rowvals.value('(VariationPendingFlag)[1]','bit'),				
									xmlVals.rowvals.value('(Notes)[1]','varchar(255)'),
									xmlVals.rowvals.value('(InterstateOverseasRelocationFlag)[1]','bit'),
									GETDATE(),
									xmlVals.rowvals.value('(DateCreated)[1]','smalldatetime'),
									xmlVals.rowvals.value('(CreatedBySystemUserID)[1]','int'),
									xmlVals.rowvals.value('(DateUpdated)[1]','smalldatetime'),
									xmlVals.rowvals.value('(UpdatedBySystemUserID)[1]','int'),						 
									'A' as RecordMode
								From @theXMLData.nodes('//DataRadiationLocation/RadiationLicenceRRMComponent') as xmlVals(rowvals)

					--******************************************************
					--select * from @TempRadiationLicenceRRMComponent0
					--******************************************************		 
						------- End RadiationLicenceRRMComponent-----------------------------------



					------- Start RRMComponent-----------------------------------
					DECLARE @TempRRMComponent0 AS TABLE(
														[RRMComponentID] [int] NOT NULL,
														[RadiationLicenceRRMID] [int] NOT NULL,
														[ComponentStatusID] [smallint] NOT NULL,
														[RRMComponentTypeID] [smallint] NOT NULL,
														[AssayDate] [smalldatetime] NULL,
														[ManufacturerID] [smallint] NULL,
														[ModelNumber] [varchar](30) NULL,
														[SerialNumber] [varchar](30) NULL,
														[RadionuclideID] [int] NULL,
														[NominalActivity] [decimal](12, 2) NULL,
														[WorkingLife] [smallint] NULL,
														[ExtendedWorkingLifeFlag] [bit] NOT NULL,
														[DateCreated] [smalldatetime] NOT NULL,
														[CreatedBySystemUserID] [int] NOT NULL,
														[DateUpdated] [smalldatetime] NULL,
														[UpdatedBySystemUserID] [int] NULL,
														[RowTimestamp] [varchar](4000) NULL,
														[RecordMode] [varchar](1) NULL,
														[NewRRMComponentID] [int] NULL)

					INSERT INTO @TempRRMComponent0
								(
									[RRMComponentID],
									[RadiationLicenceRRMID],
									[ComponentStatusID],
									[RRMComponentTypeID],
									[AssayDate],
									[ManufacturerID],
									[ModelNumber],
									[SerialNumber],
									[RadionuclideID],
									[NominalActivity],
									[WorkingLife],
									[ExtendedWorkingLifeFlag],
									[DateCreated],
									[CreatedBySystemUserID],
									[DateUpdated],
									[UpdatedBySystemUserID],
						 
									[RecordMode],
									[NewRRMComponentID]
								)
								SELECT
									xmlVals.rowvals.value('(RRMComponentID)[1]','INT'),
									xmlVals.rowvals.value('(RadiationLicenceRRMID)[1]','INT'),
									xmlVals.rowvals.value('(ComponentStatusID)[1]','INT'),
									xmlVals.rowvals.value('(RRMComponentTypeID)[1]','INT'),
									xmlVals.rowvals.value('(AssayDate)[1]','smalldatetime'),				
									xmlVals.rowvals.value('(ManufacturerID)[1]','int'),		
									xmlVals.rowvals.value('(ModelNumber)[1]','varchar(30)'),
									xmlVals.rowvals.value('(SerialNumber)[1]','varchar(30)'),
									xmlVals.rowvals.value('(RadionuclideID)[1]','int'),				
									case when len(xmlVals.rowvals.value('(NominalActivity)[1]','varchar(30)')) = 0 then 0 else xmlVals.rowvals.value('(NominalActivity)[1]','decimal(12, 2)') end,	
									xmlVals.rowvals.value('(WorkingLife)[1]','smallint'),
									xmlVals.rowvals.value('(ExtendedWorkingLifeFlag)[1]','bit'),
									getdate() as DateCreated,
									1 as CreatedBySystemUserID,
									null as DateUpdated,
									null as UpdatedBySystemUserID,
					 
									'A' as RecordMode,
									null as [NewRRMComponentID]
								From @theXMLData.nodes('//DataRadiationLocation/RRMComponent') as xmlVals(rowvals)

					--******************************************************
					--select * from @TempRRMComponent0
					--******************************************************		 
					------- End RRMComponent-----------------------------------



					--------START LOOP THROUGH RECDORDS ------------------------------------
					DECLARE @MyTable TABLE
					(
					SNo int IDENTITY(1,1), 
					RadiationLocationID int,
					AddressID int 
					)    
					INSERT INTO @MyTable(RadiationLocationID, AddressID)	    
					SELECT RadiationLocationID, AddressID
					FROM @TempRadiationLocation
	 
					declare @Cnt int
					SELECT @Cnt = MIN(Sno) FROM @MyTable
	
					declare @TempAddressID int
					declare @RadiationLocationID int
					declare @TempRadiationLocationID int
					declare @AddressID int  = 0
					declare @INSERT int
					declare @RadiationDepartmentID int

					declare @LocationName varchar(200)
					 
					declare @RadiationLocationCnt int = 0
					DECLARE @LocNameExists AS BIT = 0

					WHILE (1=1)
					BEGIN
						DECLARE @tblAddressTemp tblAddressType
			

						SELECT @TempAddressID = AddressID, @TempRadiationLocationID = RadiationLocationID FROM @MyTable
						WHERE SNo = @Cnt
	    
						IF @@ROWCOUNT = 0
						BREAK

						SELECT	@RadiationLocationID = RadiationLocationID,
								@LocationName = LocationName 
						From @TempRadiationLocation 
						WHERE cast(AddressID as varchar) = cast(@TempAddressID as varchar) and cast(RadiationLocationID as varchar) = cast(@TempRadiationLocationID as varchar)

						SET @LocationName = RTrim(LTrim(@LocationName))	
						SELECT @RadiationLocationCnt = count(*) From tblRadiationLocation Where LocationName = @LocationName --duplication check

						IF @LocationName ='' --Because location name is not mandatory,Dont chk if location name not exists
							SET @LocNameExists = 0
						ELSE IF @RadiationLocationID < 0 AND @Cnt > 0 --When Inserting new location
							BEGIN
								SET @LocNameExists = 1
							END
						ELSE IF @RadiationLocationID > 0 AND @Cnt > 1 -- When updating location
							BEGIN
								SET @LocNameExists = 1
							END
						ELSE IF @RadiationLocationID > 0 AND @Cnt = 1
							BEGIN
							DECLARE @TLocationID AS INT
							SELECT @TLocationID = RadiationLocationID FROM tblRadiationLocation WHERE LocationName = @LocationName
							IF @RadiationLocationID <> @TLocationID  --If the Loc Id is different from the updating loc id
								BEGIN
									SET @LocNameExists = 1
								END
							END

						if exists(select * from @tblAddress where cast(AddressID as varchar) = cast(@TempAddressID as varchar))
						begin
							--print '@TempRadiationLocationID =' + cast(@TempRadiationLocationID as varchar)
							--print '@addressID top before insert =' + cast(@TempAddressID as varchar)				
							print '---------------------------------------------'		
				
							insert into @tblAddressTemp(
											 AddressID
											,[Address]
											,Suburb
											,Postcode
											,StateCode
											,CreatedBySystemUserID
											,UpdatedBySystemUserID
											,RowTimestamp
											,PrefixAddress
											,Country
											,OverseasAddressFlag)	 
							select          -1 as AddressID  --make sure this record will be inserted into tblAddress table
											,[Address]
											,Suburb
											,Postcode
											,StateCode
											,CreatedBySystemUserID
											,UpdatedBySystemUserID
											,RowTimestamp
											,PrefixAddress
											,Country
											,OverseasAddressFlag from  @tblAddress
							where  cast(AddressID as varchar) = cast(@TempAddressID as varchar)

						end
 
						--BEGIN TRAN A
			
						----*************************Real action insert record into tblAddress ************************* 
						Exec @AddressID = uspSaveAddress @tblAddressTemp		

						IF @AddressID < 0 RAISERROR ('Problem saving uspSaveAddress' , 16, 1)
		    
						--print '@AddressID newly insert record = ' + cast(@Cnt as varchar) + ' = ' + cast(@AddressID as varchar)

						IF(@RadiationLocationID >= 0)
						Begin
								SET @INSERT = 1 --Insert
				     
									----*************************Real action insert record into tblRadiationLocation ************************* 
								INSERT INTO tblRadiationLocation(LocationName
											,AddressID
											,AdditionalAddressInformation
											,EffectiveDateFrom
											,DateCreated
											,CreatedBySystemUserID)
								Select		 LocationName
											,@AddressID
											,AdditionalAddressInformation
											,GETDATE()
											,GETDATE()
											,CreatedBySystemUserID
								From @TempRadiationLocation
								WHERE RadiationLocationID = @TempRadiationLocationID and AddressID = @TempAddressID  
 		  
 								SET @RadiationLocationID = (SELECT @@IDENTITY)	

								--here we add record into table: @tblRadiationLocation 
								if not exists(select RadiationLocationID from @tblRadiationLocation where RadiationLocationID = @RadiationLocationID)
								begin
								 INSERT INTO @tblRadiationLocation
								 (InstrumentRadiationLocationID,
								 InstrumentID,
								 RadiationLocationID,
								 VariationPendingFlag,
								 EffectiveDateFrom,
								 CreatedBySystemUserID,
								 UpdatedBySystemUserID,						 
								 Action)
								 							 
								 select 
								-1 as InstrumentRadiationLocationID,
								 @theInstrumentID as InstrumentID,
								 @RadiationLocationID as RadiationLocationID,
								 0 as VariationPendingFlag,
								 getdate() as EffectiveDateFrom,
								 1 as CreatedBySystemUserID,
								 null as UpdatedBySystemUserID,
								'I' as Action  								 								 
								end
								----------------------------- start handle all issues with RRM data -----------------------------------
								--*********************
								--we need do second loop based on @TempRadiationLocationID
								--we loop through RadiationLocationRRM data: RadiationLocationID AND RadiationLicenceRRMID

								DECLARE @MyTableLocationRRM TABLE
								(
									SNo int IDENTITY(1,1), 
									RadiationLocationID int,
									RadiationLicenceRRMID int 
								)  
								INSERT INTO @MyTableLocationRRM(RadiationLocationID, RadiationLicenceRRMID)	    
								SELECT RadiationLocationID, RadiationLicenceRRMID
								FROM @TempRadiationLocationRRM0
								WHERE RadiationLocationID = @TempRadiationLocationID 

								declare @Cnt2 int
								SELECT @Cnt2 = MIN(Sno) FROM @MyTableLocationRRM

								declare @TempRadiationLocationID2 int
								declare @TempRadiationLicenceRRMID2 int
								WHILE (1=1)
								BEGIN
   
									SELECT @TempRadiationLocationID2 = RadiationLocationID, @TempRadiationLicenceRRMID2 = RadiationLicenceRRMID FROM @MyTableLocationRRM
									WHERE SNo = @Cnt2	    
									IF @@ROWCOUNT = 0
										BREAK	
											-------------------------- start third level looping: RadiationDepartment data --------------------------
								 
											DECLARE @MyTableRadiationDepartment TABLE
											(
												SNo int IDENTITY(1,1), 								
												RadiationDepartmentID int,
												RadiationLocationID int 
											) 
											INSERT INTO @MyTableRadiationDepartment(RadiationDepartmentID, RadiationLocationID)	    
											SELECT RadiationDepartmentID, RadiationLocationID
											FROM @tblRadiationDepartment0
											WHERE RadiationLocationID = @TempRadiationLocationID

											declare @Cnt3 int
											SELECT @Cnt3 = MIN(Sno) FROM @MyTableRadiationDepartment
	
											declare @TempRadiationDepartmentID3 int
											declare @TempRadiationLocationID3 int

											WHILE (1=1)
											BEGIN
   
											SELECT @TempRadiationDepartmentID3 = RadiationDepartmentID, @TempRadiationLocationID3 = RadiationLocationID FROM @MyTableRadiationDepartment
											WHERE SNo = @Cnt3

											IF @@ROWCOUNT = 0
											BREAK
																	       
													--start we can insert data into tblRadiationDepartment and get the returned RadiationDepartmentID
													DECLARE @tblRadiationDepartment tblRadiationDepartmentType

													INSERT INTO @tblRadiationDepartment
														(
															[RadiationDepartmentID],
															[RadiationLocationID],
															[DepartmentName],				 
															[EffectiveDateFrom],
															[EffectiveDateTo],
															[DateCreated],
															[CreatedBySystemUserID],
															[DateUpdated],
															[UpdatedBySystemUserID],			 
															[Action]
														)
													select 
															(-1)*[RadiationDepartmentID] as [RadiationDepartmentID],
															@RadiationLocationID as [RadiationLocationID],
															[DepartmentName],				 
															[EffectiveDateFrom],
															[EffectiveDateTo],
															[DateCreated],
															[CreatedBySystemUserID],
															[DateUpdated],
															[UpdatedBySystemUserID],			 
															[Action]
													from @tblRadiationDepartment0
													where [RadiationDepartmentID] = @TempRadiationDepartmentID3 and RadiationLocationID = @TempRadiationLocationID3

													--*************************Real action insert record into tblRadiationDepartment ************************* 


													if (select count(*) from @tblRadiationDepartment) > 0
													begin

														--select * from @tblRadiationDepartment0
														--select * from @tblRadiationDepartment
														--print '@RadiationLocationID = ' + cast(@RadiationLocationID as varchar)
														Exec @RadiationDepartmentID = uspSaveRadiationDepartmentWithReturn @tblRadiationDepartment, @RadiationLocationID	
										                --print '@RadiationDepartmentID = ' + cast(@RadiationDepartmentID as varchar)

														--here we update the holding table for final DepartmentID
														update @TempRadiationDepartmentHold set FinalDepartmentID = @RadiationDepartmentID
														where [RadiationDepartmentID] = @TempRadiationDepartmentID3 and RadiationLocationID = @TempRadiationLocationID3
--8888888888888888888888888888888888888888888888888888888888888
														--select * from @TempRadiationDepartmentHold
--8888888888888888888888888888888888888888888888888888888888888
														delete from @tblRadiationDepartment0 
														where [RadiationDepartmentID] = @TempRadiationDepartmentID3 and RadiationLocationID = @TempRadiationLocationID3 
													end
													--end insert data into tblRadiationDepartment 
	                      
										if @RadiationDepartmentID >= 0
										begin          
										           --actually we need loop through RadiationLicenceRRM by using RadiationLicenceRRMID and RRMDepartmentID to avoid missing data
												   --start added on 04-09-2017
												    
													DECLARE @RadiationLicenceRRMID AS INT

													DECLARE @MyTableRadiationLicenceRRM TABLE
													(
													SNo int IDENTITY(1,1), 
													RadiationLicenceRRMID int,
													RRMDepartmentID int
													)   
													INSERT INTO @MyTableRadiationLicenceRRM(RadiationLicenceRRMID, RRMDepartmentID)	    
													SELECT RadiationLicenceRRMID, RRMDepartmentID
													FROM @TempRadiationLicenceRRM0
													WHERE RRMDepartmentID = @TempRadiationDepartmentID3 and [FLAG] = 0 
 
													declare @Cnt4 int
													SELECT @Cnt4 = MIN(Sno) FROM @MyTableRadiationLicenceRRM

													declare @TempRadiationLicenceRRMID4 int
													declare @TempRRMDepartmentID4 int

													WHILE (1=1)
													BEGIN
   
													SELECT @TempRadiationLicenceRRMID4 = RadiationLicenceRRMID, @TempRRMDepartmentID4 = RRMDepartmentID FROM @MyTableRadiationLicenceRRM
													WHERE SNo = @Cnt4
	    
													IF @@ROWCOUNT = 0
														BREAK
                                                            -- start processing --
															if exists(select * from @TempRadiationLicenceRRM0
															          where RRMDepartmentID = @TempRRMDepartmentID4 and [FLAG] = 0)
															begin --start begin A
															 
																INSERT INTO [dbo].[tblRadiationLicenceRRM]
																	([RRMStatusID]
																	,[RRMTypeID]
																	,[RRMPurposeID]
																	,[RRMID]
																	,[WorkArea]
																	,[RRMSecurityClassificationID]
																	,[LaboratoryClassificationID]
																	,[DateCreated]
																	,[CreatedBySystemUserID]
																	,[RRMDepartmentID])
																SELECT 
																	RRMStatusID,
																	RRMTypeID,
																	RRMPurposeID,
																	RRMID,
																	WorkArea,
																	RRMSecurityClassificationID,
																	LaboratoryClassificationID,
																	GETDATE(),
																	CreatedBySystemUserID,
																	@RadiationDepartmentID as RRMDepartmentID	
																FROM @TempRadiationLicenceRRM0
																WHERE RRMDepartmentID = @TempRRMDepartmentID4 and [FLAG] = 0  

																SET @RadiationLicenceRRMID= @@IDENTITY	
															 
																--update @TempRadiationLicenceRRM0 set [FLAG] = @RadiationLicenceRRMID 
																--where RadiationLicenceRRMID = @TempRadiationLicenceRRMID4 and RRMDepartmentID = @TempRRMDepartmentID4 and [FLAG] = 0 

															end  --end begin A

															--delete from @TempRadiationLicenceRRM0
															--WHERE RadiationLicenceRRMID = @TempRadiationLicenceRRMID4 and RRMDepartmentID = @TempRRMDepartmentID4  

															declare @RadiationLocationRRM_TEST int
															--insert into RadiationLocationRRM
															if exists(select * from @TempRadiationLocationRRM0
															where RadiationLocationID = @TempRadiationLocationID2 and RadiationLicenceRRMID = @TempRadiationLicenceRRMID4 and [FLAG] = 0)
															begin --start begin B
																		INSERT INTO [dbo].[tblRadiationLocationRRM]
																			([RadiationLocationID]
																			,[RadiationLicenceRRMID]
																			,[VariationPendingFlag]
																			,[Notes]
																			,[InterstateOverseasRelocationFlag]
																			,[EffectiveDateFrom]
																			,[DateCreated]
																			,[CreatedBySystemUserID])
																		SELECT 
																			@RadiationLocationID as RadiationLocationID,
																			@RadiationLicenceRRMID,
																			0 as VariationPendingFlag,
																			null as Notes,
																			0 as InterstateOverseasRelocationFlag,
																			GETDATE(),
																			GETDATE(),
																			1 as CreatedBySystemUserID							
																		FROM @TempRadiationLocationRRM0
																		WHERE RadiationLocationID = @TempRadiationLocationID2 and RadiationLicenceRRMID = @TempRadiationLicenceRRMID4 and [FLAG] = 0    

																		SET @RadiationLocationRRM_TEST = @@IDENTITY

																		update @TempRadiationLocationRRM0 set [FLAG] = @RadiationLocationRRM_TEST  
																		where RadiationLocationID = @TempRadiationLocationID2 and RadiationLicenceRRMID = @TempRadiationLicenceRRMID4 
															end --end begin B

															--delete from @TempRadiationLocationRRM0
															--WHERE RadiationLocationID = @TempRadiationLocationID2 and RadiationLicenceRRMID = @TempRadiationLicenceRRMID4 
															-- end processing ----
		
													SELECT @Cnt4 = @Cnt4 + 1
 
													END
												   --end added on 04-09-2017 
									-----------------------------------------------------------------------------------------------------------------------------
													DECLARE @TempRadiationLocationRRM AS TABLE(
															[RadiationLocationRRMID] [int] NOT NULL,
															[RadiationLocationID] [int] NOT NULL,
															[RadiationLicenceRRMID] [int] NOT NULL,
															[VariationPendingFlag] [bit] NOT NULL,
															[NewLocationID] [int] NULL,
															[Notes] [varchar](255) NULL,
															[InterstateOverseasRelocationFlag] [bit] NOT NULL,
															[Recipient] [varchar](150) NULL,
															[RecipientAddress] [varchar](255) NULL,
															[State] [varchar](3) NULL,
															[Country] [varchar](150) NULL,
															[EffectiveDateFrom] [smalldatetime] NOT NULL,
															[EffectiveDateTo] [smalldatetime] NULL,
															[DateCreated] [smalldatetime] NOT NULL,
															[CreatedBySystemUserID] [int] NOT NULL,
															[DateUpdated] [smalldatetime] NULL,
															[UpdatedBySystemUserID] [int] NULL,
															[RowTimestamp] [varchar](4000) NULL,
															[RecordMode] [varchar](1) NULL)

													INSERT INTO @TempRadiationLocationRRM
													(
														 [RadiationLocationRRMID]
														,[RadiationLocationID]
														,[RadiationLicenceRRMID]
														,[VariationPendingFlag]
														,[InterstateOverseasRelocationFlag]
														,[Notes]
														,[EffectiveDateFrom]
														,[EffectiveDateTo]
														,[DateCreated]
														,[CreatedBySystemUserID]
														,[DateUpdated]
														,[UpdatedBySystemUserID]			 
														,[RecordMode]
													)
													select 			 
													 [RadiationLocationRRMID]
													,[RadiationLocationID]
													,[RadiationLicenceRRMID]
													,[VariationPendingFlag]
													,[InterstateOverseasRelocationFlag]
													,[Notes]
													,[EffectiveDateFrom]
													,[EffectiveDateTo]
													,[DateCreated]
													,[CreatedBySystemUserID]
													,[DateUpdated]
													,[UpdatedBySystemUserID]			 
													,[RecordMode]
													from @TempRadiationLocationRRM0 
													where RadiationLocationID = @TempRadiationLocationID2
													and RadiationLicenceRRMID = @TempRadiationLicenceRRMID2

													--select * from @TempRadiationLocationRRM0
													--print '@@TempRadiationLocationID2 newly insert record = ' + cast(@Cnt as varchar) + ' = ' + cast(@TempRadiationLocationID2 as varchar)
													--print '@@TempRadiationLicenceRRMID2 newly insert record = ' + cast(@Cnt as varchar) + ' = ' + cast(@TempRadiationLicenceRRMID2 as varchar)
													--select * from @TempRadiationLocationRRM

													--delete it so we avoid duplicatted processes
													delete from @TempRadiationLocationRRM0 
													where RadiationLocationID = @TempRadiationLocationID2 
													and RadiationLicenceRRMID = @TempRadiationLicenceRRMID2
			 						-----------------------------------------------------------------------------------------------------------------------------								        
													DECLARE @TempRadiationLicenceRRMComponent AS TABLE(
													[RadiationLicenceRRMComponentID] [int] NOT NULL,
													[RadiationLicenceRRMID] [int] NOT NULL,
													[RRMComponentID] [int] NOT NULL,
													[VariationPendingFlag] [bit] NOT NULL,
													[NewRadiationLicenceRRMID] [int] NULL,
													[Notes] [varchar](255) NULL,
													[InterstateOverseasRelocationFlag] [bit] NOT NULL,
													[Recipient] [varchar](150) NULL,
													[RecipientAddress] [varchar](255) NULL,
													[State] [varchar](3) NULL,
													[Country] [varchar](150) NULL,
													[EffectiveDateFrom] [smalldatetime] NOT NULL,
													[EffectiveDateTo] [smalldatetime] NULL,
													[DateCreated] [smalldatetime] NOT NULL,
													[CreatedBySystemUserID] [int] NOT NULL,
													[DateUpdated] [smalldatetime] NULL,
													[UpdatedBySystemUserID] [int] NULL,
													[RowTimestamp] [varchar](4000) NULL,
													[RecordMode] [varchar](1) NULL)

													INSERT INTO @TempRadiationLicenceRRMComponent
													(
														[RadiationLicenceRRMComponentID]
														,[RadiationLicenceRRMID]
														,[RRMComponentID]
														,[VariationPendingFlag]
														,[Notes]
														,[InterstateOverseasRelocationFlag]
														,[EffectiveDateFrom]
														,[DateCreated]
														,[CreatedBySystemUserID]
														,[DateUpdated]
														,[UpdatedBySystemUserID]					 
														,[RecordMode]
													)
													select 
															[RadiationLicenceRRMComponentID]
														,[RadiationLicenceRRMID]
														,[RRMComponentID]
														,[VariationPendingFlag]
														,[Notes]
														,[InterstateOverseasRelocationFlag]
														,[EffectiveDateFrom]
														,[DateCreated]
														,[CreatedBySystemUserID]
														,[DateUpdated]
														,[UpdatedBySystemUserID]					 
														,[RecordMode]
													from @TempRadiationLicenceRRMComponent0 where [RadiationLicenceRRMID] = @TempRadiationLicenceRRMID2

													--delete it so we avoid duplicatted processes
													delete from @TempRadiationLicenceRRMComponent0 where [RadiationLicenceRRMID] = @TempRadiationLicenceRRMID2
									------------------------------------------------------------------------------------------------------------------------------
													DECLARE @TempRadiationLicenceRRM AS TABLE(
															[RadiationLicenceRRMID] [int] NOT NULL,
															[RRMStatusID] [smallint] NOT NULL,
															[RRMTypeID] [smallint] NOT NULL,
															[RRMPurposeID] [smallint] NULL,
															[RRMID] [smallint] NULL,
															[WorkArea] [varchar](255) NULL,
															[RRMSecurityClassificationID] [smallint] NULL,
															[LaboratoryClassificationID] [smallint] NULL,
															[DateCreated] [smalldatetime] NOT NULL,
															[CreatedBySystemUserID] [int] NOT NULL,
															[DateUpdated] [smalldatetime] NULL,
															[UpdatedBySystemUserID] [int] NULL,
															[RowTimestamp] [varchar](4000) NULL,
															[RecordMode] [varchar](1) NULL,
															[NewRadiationLicenceRRMID] [int] NULL,
															[RRMDepartmentID] [smallint] NULL
															)
													INSERT INTO @TempRadiationLicenceRRM
														(
															 [RadiationLicenceRRMID]
															,[RRMStatusID]
															,[RRMTypeID]
															,[RRMPurposeID]
															,[RRMID]
															,[WorkArea]
															,[RRMSecurityClassificationID]
															,[LaboratoryClassificationID]
															,[DateCreated]
															,[CreatedBySystemUserID]
															,[DateUpdated]
															,[UpdatedBySystemUserID]				 
															,[RecordMode]
															,[NewRadiationLicenceRRMID]
															,[RRMDepartmentID]
														)
													SELECT 
															 [RadiationLicenceRRMID]
															,[RRMStatusID]
															,[RRMTypeID]
															,[RRMPurposeID]
															,[RRMID]
															,[WorkArea]
															,[RRMSecurityClassificationID]
															,[LaboratoryClassificationID]
															,[DateCreated]
															,[CreatedBySystemUserID]
															,[DateUpdated]
															,[UpdatedBySystemUserID]				 
															,[RecordMode]
															,[NewRadiationLicenceRRMID]
															,[RRMDepartmentID]
													FROM @TempRadiationLicenceRRM0
													WHERE 
													RadiationLicenceRRMID = @TempRadiationLicenceRRMID2 
													and 
													[RRMDepartmentID] = @TempRadiationDepartmentID3

													--delete it so we avoid duplicatted processes
													delete from @TempRadiationLicenceRRM0 
													WHERE 
													RadiationLicenceRRMID = @TempRadiationLicenceRRMID2 and 
													[RRMDepartmentID] = @TempRadiationDepartmentID3

									------------------------------------------------------------------------------------------------------------------------------
													DECLARE @TempRRMComponent AS TABLE(
													[RRMComponentID] [int] NOT NULL,
													[RadiationLicenceRRMID] [int] NOT NULL,
													[ComponentStatusID] [smallint] NOT NULL,
													[RRMComponentTypeID] [smallint] NOT NULL,
													[AssayDate] [smalldatetime] NULL,
													[ManufacturerID] [smallint] NULL,
													[ModelNumber] [varchar](30) NULL,
													[SerialNumber] [varchar](30) NULL,
													[RadionuclideID] [int] NULL,
													[NominalActivity] [decimal](12, 2) NULL,
													[WorkingLife] [smallint] NULL,
													[ExtendedWorkingLifeFlag] [bit] NOT NULL,
													[DateCreated] [smalldatetime] NOT NULL,
													[CreatedBySystemUserID] [int] NOT NULL,
													[DateUpdated] [smalldatetime] NULL,
													[UpdatedBySystemUserID] [int] NULL,
													[RowTimestamp] [varchar](4000) NULL,
													[RecordMode] [varchar](1) NULL,
													[NewRRMComponentID] [int] NULL)
													INSERT INTO @TempRRMComponent
													(
														[RRMComponentID],
														[RadiationLicenceRRMID],
														[ComponentStatusID],
														[RRMComponentTypeID],
														[AssayDate],
														[ManufacturerID],
														[ModelNumber],
														[SerialNumber],
														[RadionuclideID],
														[NominalActivity],
														[WorkingLife],
														[ExtendedWorkingLifeFlag],
														[DateCreated],
														[CreatedBySystemUserID],
														[DateUpdated],
														[UpdatedBySystemUserID],						 
														[RecordMode]
													)
													select 
														[RRMComponentID],
														[RadiationLicenceRRMID],
														[ComponentStatusID],
														[RRMComponentTypeID],
														[AssayDate],
														[ManufacturerID],
														[ModelNumber],
														[SerialNumber],
														[RadionuclideID],
														[NominalActivity],
														[WorkingLife],
														[ExtendedWorkingLifeFlag],
														[DateCreated],
														[CreatedBySystemUserID],
														[DateUpdated],
														[UpdatedBySystemUserID],						 
														[RecordMode]
													from @TempRRMComponent0 where [RadiationLicenceRRMID] = @TempRadiationLicenceRRMID2 
													--delete it so we avoid duplicatted processes
													delete from @TempRRMComponent0 WHERE [RadiationLicenceRRMID] = @TempRadiationLicenceRRMID2 
									------------------------------------------------------------------------------------------------------------------------------
														-----------start RRM actions---------------------------
													if exists(select * from @TempRadiationLicenceRRM) or exists(select * from @TempRadiationLocationRRM)
													begin
														print '------------- this writing is used for removing exception between begin and end statements-----------------'  

														-- **********************start action RRMs ************************************
														--DELETE LIRRMC FROM tblRadiationLicenceRRMComponent LIRRMC							
														--	JOIN tblRadiationLicenceRRM LIRRM ON LIRRMC.RadiationLicenceRRMID = LIRRM.RadiationLicenceRRMID
														--	JOIN tblRadiationLocationRRM LORRM ON LIRRM.RadiationLicenceRRMID = LORRM.RadiationLicenceRRMID
														--	WHERE LORRM.RadiationLocationID = @RadiationLocationID
														--	AND LIRRMC.RadiationLicenceRRMComponentID NOT IN(SELECT RadiationLicenceRRMComponentID FROM @TempRadiationLicenceRRMComponent WHERE RecordMode != 'A')
														--	AND LIRRMC.EffectiveDateTo IS NULL  -- in order to protected the history of a component we do not delete those old records only new ones if there are any

														--DELETE RRMC FROM tblRRMComponent RRMC JOIN tblRadiationLicenceRRMComponent LIRRMC 
														--	ON RRMC.RRMComponentID = LIRRMC.RRMComponentID
														--	JOIN tblRadiationLicenceRRM LIRRM ON LIRRMC.RadiationLicenceRRMID = LIRRM.RadiationLicenceRRMID
														--	JOIN tblRadiationLocationRRM LORRM ON LIRRM.RadiationLicenceRRMID = LORRM.RadiationLicenceRRMID
														--	WHERE LORRM.RadiationLocationID = @RadiationLocationID
														--	AND RRMC.RRMComponentID NOT IN (SELECT RRMComponentID FROM tblRadiationLicenceRRMComponent)						

														--DELETE LORRM FROM tblRadiationLocationRRM LORRM
														--	WHERE LORRM.RadiationLocationID = @RadiationLocationID
														--	AND LORRM.RadiationLocationRRMID NOT IN (SELECT RadiationLocationRRMID FROM @TempRadiationLocationRRM WHERE RecordMode != 'A')
														--	AND LORRM.EffectiveDateTo IS NULL   -- in order to protected the history of a RRM we do not delete those old records only new ones if there are any

														--DELETE LIRRM FROM tblRadiationLicenceRRM LIRRM
														--	JOIN tblRadiationLocationRRM LORRM ON LIRRM.RadiationLicenceRRMID = LORRM.RadiationLicenceRRMID
														--	WHERE LORRM.RadiationLocationID = @RadiationLocationID
														--	AND LIRRM.RadiationLicenceRRMID NOT IN (SELECT RadiationLicenceRRMID FROM tblRadiationLocationRRM)

														DECLARE @RowID AS INT = 0
														--DECLARE @RadiationLicenceRRMID AS INT
												        							
																				
			--select * from @TempRadiationLicenceRRM0																						
														--Insert tblRadiationLicenceRRM rows and update newly created ids in the temp table
														--WHILE (SELECT COUNT(*) FROM @TempRadiationLicenceRRM WHERE RecordMode = 'A' AND NewRadiationLicenceRRMID IS NULL) > 0
														--BEGIN
														--	Select Top 1 @RowID = RadiationLicenceRRMID FROM @TempRadiationLicenceRRM 
														--	WHERE RecordMode = 'A' AND NewRadiationLicenceRRMID IS NULL 
												
														--	--************** real action into DB ******************************
														--	--INSERT INTO [dbo].[tblRadiationLicenceRRM]
														--	--	([RRMStatusID]
														--	--	,[RRMTypeID]
														--	--	,[RRMPurposeID]
														--	--	,[RRMID]
														--	--	,[WorkArea]
														--	--	,[RRMSecurityClassificationID]
														--	--	,[LaboratoryClassificationID]
														--	--	,[DateCreated]
														--	--	,[CreatedBySystemUserID]
														--	--	,[RRMDepartmentID])
														--	--SELECT 
														--	--	RRMStatusID,
														--	--	RRMTypeID,
														--	--	RRMPurposeID,
														--	--	RRMID,
														--	--	WorkArea,
														--	--	RRMSecurityClassificationID,
														--	--	LaboratoryClassificationID,
														--	--	GETDATE(),
														--	--	CreatedBySystemUserID,
														--	--	@RadiationDepartmentID as RRMDepartmentID									
														--	--FROM @TempRadiationLicenceRRM
														--	--WHERE RadiationLicenceRRMID = @RowID  

														--	--SET @RadiationLicenceRRMID= @@IDENTITY									
														--	----print '@RadiationLicenceRRMID newly insert id line 1349 =' + cast(@RadiationLicenceRRMID as varchar)		

														--	--UPDATE @TempRadiationLicenceRRM								
														--	--SET NewRadiationLicenceRRMID = @RadiationLicenceRRMID 
														--	--WHERE RadiationLicenceRRMID = @RowID 
									 
														--	--UPDATE @TempRadiationLicenceRRMComponent
														--	--SET RadiationLicenceRRMID = @RadiationLicenceRRMID
														--	--WHERE RadiationLicenceRRMID = @RowID  
														--END
						 
														--declare @RadiationLocationRRM_TEST int
		----start Insert tblRadiationLocationRRM rows-----------------------------------------------------------------------------------------------

			--select * from @TempRadiationLocationRRM
			--select * from @TempRadiationLicenceRRM
													--if exists(select * from @TempRadiationLocationRRM)
													--begin
													--	--************** real action into DB ******************************
													--	if not exists(select * from tblRadiationLocationRRM where RadiationLocationID = @RadiationLocationID and RadiationLicenceRRMID = @RadiationLicenceRRMID)
													--	begin --start duplication check
													--	    print 'test A'
													--		--INSERT INTO [dbo].[tblRadiationLocationRRM]
													--		--	([RadiationLocationID]
													--		--	,[RadiationLicenceRRMID]
													--		--	,[VariationPendingFlag]
													--		--	,[Notes]
													--		--	,[InterstateOverseasRelocationFlag]
													--		--	,[EffectiveDateFrom]
													--		--	,[DateCreated]
													--		--	,[CreatedBySystemUserID])
													--		--SELECT 
													--		--	@RadiationLocationID as RadiationLocationID,
													--		--	@RadiationLicenceRRMID,
													--		--	0 as VariationPendingFlag,
													--		--	null as Notes,
													--		--	0 as InterstateOverseasRelocationFlag,
													--		--	GETDATE(),
													--		--	GETDATE(),
													--		--	1 as CreatedBySystemUserID							
													--		--FROM @TempRadiationLocationRRM LO
													--		--WHERE RadiationLocationID = @TempRadiationLocationID2

													--		--INNER JOIN @TempRadiationLicenceRRM LI ON LO.RadiationLicenceRRMID = LI.RadiationLicenceRRMID
													--		--WHERE LI.RecordMode = 'A' AND LI.NewRadiationLicenceRRMID > 0

													--		--select @RadiationLocationRRM_TEST = @@IDENTITY
													--    end --start duplication check

													--	--print '@RadiationLocationRRM_TEST  =' + cast(@RadiationLocationRRM_TEST as varchar)	
													--end --end of if exists(select * from @TempRadiationLocationRRM) above


														SET @RowID = 0
														DECLARE @RRMComponentID AS INT		
												
														WHILE (SELECT COUNT(*) FROM @TempRRMComponent WHERE RecordMode = 'A' AND NewRRMComponentID IS NULL) > 0
														BEGIN
															Select Top 1 @RowID = RRMComponentID FROM @TempRRMComponent WHERE RecordMode = 'A' AND NewRRMComponentID IS NULL

															INSERT INTO [dbo].[tblRRMComponent]
																([ComponentStatusID]
																,[RRMComponentTypeID]
																,[AssayDate]
																,[ManufacturerID]
																,[ModelNumber]
																,[SerialNumber]
																,[RadionuclideID]
																,[NominalActivity]
																,[WorkingLife]
																,[ExtendedWorkingLifeFlag]
																,[DateCreated]
																,[CreatedBySystemUserID])
															SELECT 
																ComponentStatusID,
																RRMComponentTypeID,
																AssayDate,
																case ManufacturerID when 0 then 1 else ManufacturerID end as ManufacturerID,  ----NEED TO FIX THIS 0 VALUE
																ModelNumber,
																SerialNumber,
																2 as RadionuclideID,
																NominalActivity,
																WorkingLife,
																ExtendedWorkingLifeFlag,
																GETDATE(),
																CreatedBySystemUserID									
															FROM @TempRRMComponent
															WHERE RRMComponentID = @RowID

															SET @RRMComponentID = @@IDENTITY
									 
															UPDATE @TempRRMComponent
															SET NewRRMComponentID = @RRMComponentID
															WHERE RRMComponentID = @RowID
 
														END

														----Insert tblRadiationLicenceRRMComponent rows
														INSERT INTO [dbo].[tblRadiationLicenceRRMComponent]
															([RadiationLicenceRRMID]
															,[RRMComponentID]
															,[VariationPendingFlag]
															,[Notes]
															,[InterstateOverseasRelocationFlag]
															,[EffectiveDateFrom]
															,[DateCreated]
															,[CreatedBySystemUserID])
														SELECT 
															@RadiationLicenceRRMID as RadiationLicenceRRMID,
															RRM.NewRRMComponentID,
															0 as VariationPendingFlag,
															null as Notes,
															0 as InterstateOverseasRelocationFlag,
															GETDATE(),
															GETDATE(),
															1 as CreatedBySystemUserID							
														FROM @TempRRMComponent RRM 
														WHERE RRM.RecordMode = 'A' AND RRM.NewRRMComponentID > 0												
						
														----Update records
														--UPDATE A
														--   SET
														--	   [RRMPurposeID] = B.RRMPurposeID
														--	  ,[RRMID] = B.RRMID
														--	  ,[WorkArea] = B.WorkArea
														--	  ,[RRMSecurityClassificationID] = B.RRMSecurityClassificationID
														--	  ,[LaboratoryClassificationID] = B.LaboratoryClassificationID
														--	  ,[DateUpdated] = GetDate()
														--	  ,[UpdatedBySystemUserID] = B.UpdatedBySystemUserID
														--	  ,[RRMDepartmentID] = (case B.RRMDepartmentID when null  then null when 0 then null else B.RRMDepartmentID end)                        
														-- FROM tblRadiationLicenceRRM A
														-- INNER JOIN @TempRadiationLicenceRRM B ON A.RadiationLicenceRRMID = B.RadiationLicenceRRMID
														-- WHERE B.RecordMode = 'U'  -- this never happened when doing eConnect data insert

														--UPDATE A
														--   SET [AssayDate] = B.AssayDate
														--	  ,[ManufacturerID] = B.ManufacturerID
														--	  ,[ModelNumber] = B.ModelNumber
														--	  ,[SerialNumber] = B.SerialNumber
														--	  ,[RadionuclideID] = B.RadionuclideID
														--	  ,[NominalActivity] = B.NominalActivity
														--	  ,[WorkingLife] = B.WorkingLife
														--	  ,[ExtendedWorkingLifeFlag] = B.ExtendedWorkingLifeFlag
														--	  ,[DateUpdated] = GETDATE()
														--	  ,[UpdatedBySystemUserID] = B.UpdatedBySystemUserID
														--FROM tblRRMComponent A
														--INNER JOIN @TempRRMComponent B ON A.RRMComponentID = B.RRMComponentID
														--WHERE B.RecordMode = 'U' -- this never happened when doing eConnect data insert

														--DECLARE @RecordCount AS INT = 0
														--DECLARE @RecordsUpdated AS INT = 0
														--SELECT @RecordCount = Count(*) FROM @TempRadiationLicenceRRM LICRRM WHERE RadiationLicenceRRMID < 0
														--DECLARE @RecordID AS INT = 0
														--DECLARE @RadLicRRMID AS INT = 0
														--DECLARE @SecurityID AS INT = 0

														--IF(@RecordCount > 0)
														--BEGIN								
														--	While(1 = 1)
														--	BEGIN
														--			SET @RadLicRRMID = 0
														--			SET @SecurityID = 0

														--			IF (@RecordsUpdated > @RecordCount)
														--			BEGIN
														--				Break
														--			END

														--			IF(@RecordID < (SELECT TOP 1 RadiationLicenceRRMID FROM @TempRadiationLicenceRRM ORDER BY RadiationLicenceRRMID))
														--			BEGIN
														--				Break
														--			END

														--			SET @RecordID = @RecordID - 1
								
														--			IF(Exists(Select * FROM @TempRadiationLicenceRRM WHERE RadiationLicenceRRMID = @RecordID))
														--			BEGIN										
														--				SELECT @RadLicRRMID = NewRadiationLicenceRRMID FROM @TempRadiationLicenceRRM WHERE RadiationLicenceRRMID = @RecordID
																				
														--				SELECT @SecurityID = dbo.ufn_RadiationGetRRMSecurityClassificationID(@RadLicRRMID)
										
														--				IF(@SecurityID > 0)
														--					BEGIN
														--						UPDATE tblRadiationLicenceRRM
														--						SET RRMSecurityClassificationID = @SecurityID
														--						WHERE RadiationLicenceRRMID = @RadLicRRMID
														--					END
														--				SET @RecordsUpdated = @RecordsUpdated + 1
														--			END
														--		END
														--END

														--SET @RecordCount = 0
														--SET @RecordsUpdated = 0
														--SELECT @RecordCount = Count(*) FROM @TempRadiationLicenceRRM LICRRM WHERE RadiationLicenceRRMID > 0
														--SET @RecordID = 0						
						
														--IF(@RecordCount > 0)
														--BEGIN
														--	While(1 = 1)
														--	BEGIN
														--			SET @RadLicRRMID = 0
														--			SET @SecurityID = 0

														--			IF (@RecordsUpdated > @RecordCount)
														--			BEGIN
														--				Break
														--			END

														--			IF(@RecordID > (SELECT TOP 1 RadiationLicenceRRMID FROM @TempRadiationLicenceRRM ORDER BY RadiationLicenceRRMID DESC))
														--			BEGIN
														--				Break
														--			END

														--			SET @RecordID = @RecordID + 1
								
														--			IF(Exists(Select * FROM @TempRadiationLicenceRRM WHERE RadiationLicenceRRMID = @RecordID))
														--			BEGIN

														--				SELECT @RadLicRRMID = RadiationLicenceRRMID FROM @TempRadiationLicenceRRM WHERE RadiationLicenceRRMID = @RecordID
														--				print @RadLicRRMID
																	
														--				SELECT @SecurityID = dbo.ufn_RadiationGetRRMSecurityClassificationID(@RadLicRRMID)
										
														--				IF(@SecurityID > 0)
														--					BEGIN
														--						UPDATE tblRadiationLicenceRRM
														--						SET RRMSecurityClassificationID = @SecurityID
														--						WHERE RadiationLicenceRRMID = @RadLicRRMID
														--					END

														--				SET @RecordsUpdated = @RecordsUpdated + 1
														--			END
														--		END
														--END
														----end Insert tblRadiationLocationRRM rows-----------------------------------------------------------------------------------------------
														-- **********************end action RRMs ************************************
												end
						 
											-----------end RRM actions ----------------------------
													--clean up all temp table data
													delete @tblRadiationDepartment
													delete @TempRadiationLocationRRM
													delete @TempRadiationLicenceRRMComponent
													delete @TempRadiationLicenceRRM
													delete @TempRRMComponent

										end -- end of if @RadiationDepartmentID > 0

										SELECT @Cnt3 = @Cnt3 + 1
		
										END

											-------------------------- end third level looping: RadiationLicenceRRM data ----------------------------




							
										--select * from @TempRadiationLocationRRM
										--select * from @TempRadiationLicenceRRMComponent
										--select * from @TempRadiationLicenceRRM
										--select * from @TempRRMComponent
										--print '------------------------------------------------------------------------------------------' 
										--print '@TempRadiationLocationID top loop value =' + cast(@TempRadiationLocationID as varchar)					 					 
										--print '@TempRadiationLicenceRRMID2 nested loop value =' + cast(@TempRadiationLicenceRRMID2 as varchar)
										--print '------------------------------------------------------------------------------------------' 

									SELECT @Cnt2 = @Cnt2 + 1
						 
								END
								--********************* 
								----------------------------- end handle all issues with RRM data -------------------------------------

						END
		 


						--COMMIT TRAN A

						--If creating new radiation location then return radiation location id else return 0(i.e update success)			 
						--SELECT @RadiationLocationID as InsertLocationID  --for inserting

						--select * from @tblAddressTemp

					delete @tblAddressTemp		

					SELECT @Cnt = @Cnt + 1
		
					END
					--------END LOOP THROUGH RECORDS ---------------------------------------

					--Finally we create links on tblInstrumentRadiationLocation
					declare @RtnVal int 
					SELECT @RtnVal =0
					 
					update @tblRadiationLocation set InstrumentRadiationLocationID = -1*SNo  --we make sure the InstrumentRadiationLocationID is negative unique numbers
					--select * from @tblRadiationLocation

					Exec @RtnVal = uspRadiationLinkLocations @tblRadiationLocation, @theInstrumentID
					IF @RtnVal <> 0 RAISERROR ('Problem saving uspLinkRadiationLocations' , 16, 1) 
	   end
	END TRY
	BEGIN CATCH
		DECLARE @ErrorMessage VARCHAR(2000)
		
		--ROLLBACK TRAN A
	
		SET @ErrorMessage = dbo.ufn_GetErrorText()
		
		RAISERROR (@ErrorMessage , 16, 1)	
	END CATCH