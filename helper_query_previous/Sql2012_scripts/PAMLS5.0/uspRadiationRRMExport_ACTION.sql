declare @xmlRadiationLocation XML
declare @RadiationLicenceRRMID int

set @RadiationLicenceRRMID = 2126

set @xmlRadiationLocation = 
'
<DataRadiationLocation>
  <RadiationLocation>
    <RadiationLocationID>2119</RadiationLocationID>
    <LocationName>hhh</LocationName>
    <AddressID>23561</AddressID>
    <AdditionalAddressInformation />
    <EffectiveDateFrom>2014-05-06T08:10:00+10:00</EffectiveDateFrom>
    <DateCreated>2014-05-06T08:10:00+10:00</DateCreated>
    <CreatedBySystemUserID>1334</CreatedBySystemUserID>
    <DateUpdated>2014-05-06T08:22:00+10:00</DateUpdated>
    <UpdatedBySystemUserID>1334</UpdatedBySystemUserID>
    <RowTimestamp>AAAAAADFKMw=</RowTimestamp>
    <InstrumentID>-1</InstrumentID>
  </RadiationLocation>
  <Address>
    <AddressID>23561</AddressID>
    <Address>hi st</Address>
    <Suburb>HURSTVILLE</Suburb>
    <Postcode>2220</Postcode>
    <StateCode>NSW</StateCode>
    <DateCreated>2014-05-06T08:10:00+10:00</DateCreated>
    <CreatedBySystemUserID>1334</CreatedBySystemUserID>
    <DateUpdated>2014-05-06T08:22:00+10:00</DateUpdated>
    <UpdatedBySystemUserID>1334</UpdatedBySystemUserID>
    <RowTimestamp>AAAAAADFKMs=</RowTimestamp>
  </Address>
  <RadiationLocationRRM>
    <RadiationLocationRRMID>2135</RadiationLocationRRMID>
    <RadiationLocationID>2119</RadiationLocationID>
    <RadiationLicenceRRMID>2126</RadiationLicenceRRMID>
    <VariationPendingFlag>true</VariationPendingFlag>
    <InterstateOverseasRelocationFlag>true</InterstateOverseasRelocationFlag>
    <Recipient>Canberra</Recipient>
    <RecipientAddress>90 Canberra Street</RecipientAddress>
    <State>ACT</State>
    <Country />
    <EffectiveDateFrom>2014-05-06T08:11:00+10:00</EffectiveDateFrom>
    <DateCreated>2014-05-06T08:11:00+10:00</DateCreated>
    <CreatedBySystemUserID>1334</CreatedBySystemUserID>
    <UpdatedBySystemUserID>1334</UpdatedBySystemUserID>
    <RowTimestamp>AAAAAADFKWI=</RowTimestamp>
    <RecordMode>R</RecordMode>
  </RadiationLocationRRM>
  <RadiationLocationRRM>
    <RadiationLocationRRMID>2136</RadiationLocationRRMID>
    <RadiationLocationID>2119</RadiationLocationID>
    <RadiationLicenceRRMID>2127</RadiationLicenceRRMID>
    <VariationPendingFlag>false</VariationPendingFlag>
    <InterstateOverseasRelocationFlag>false</InterstateOverseasRelocationFlag>
    <EffectiveDateFrom>2014-05-06T08:11:00+10:00</EffectiveDateFrom>
    <DateCreated>2014-05-06T08:11:00+10:00</DateCreated>
    <CreatedBySystemUserID>1334</CreatedBySystemUserID>
    <RowTimestamp>AAAAAADFKWw=</RowTimestamp>
    <RecordMode>R</RecordMode>
  </RadiationLocationRRM>
  <RadiationLicenceRRMComponent>
    <RadiationLicenceRRMComponentID>2212</RadiationLicenceRRMComponentID>
    <RadiationLicenceRRMID>2126</RadiationLicenceRRMID>
    <RRMComponentID>2195</RRMComponentID>
    <VariationPendingFlag>false</VariationPendingFlag>
    <InterstateOverseasRelocationFlag>false</InterstateOverseasRelocationFlag>
    <EffectiveDateFrom>2014-05-06T08:11:00+10:00</EffectiveDateFrom>
    <DateCreated>2014-05-06T08:11:00+10:00</DateCreated>
    <CreatedBySystemUserID>1334</CreatedBySystemUserID>
    <RowTimestamp>AAAAAADFKWQ=</RowTimestamp>
    <RecordMode>R</RecordMode>
  </RadiationLicenceRRMComponent>
  <RadiationLicenceRRMComponent>
    <RadiationLicenceRRMComponentID>2213</RadiationLicenceRRMComponentID>
    <RadiationLicenceRRMID>2126</RadiationLicenceRRMID>
    <RRMComponentID>2196</RRMComponentID>
    <VariationPendingFlag>false</VariationPendingFlag>
    <InterstateOverseasRelocationFlag>false</InterstateOverseasRelocationFlag>
    <EffectiveDateFrom>2014-05-06T08:11:00+10:00</EffectiveDateFrom>
    <DateCreated>2014-05-06T08:11:00+10:00</DateCreated>
    <CreatedBySystemUserID>1334</CreatedBySystemUserID>
    <RowTimestamp>AAAAAADFKWY=</RowTimestamp>
    <RecordMode>R</RecordMode>
  </RadiationLicenceRRMComponent>
  <RadiationLicenceRRMComponent>
    <RadiationLicenceRRMComponentID>2214</RadiationLicenceRRMComponentID>
    <RadiationLicenceRRMID>2127</RadiationLicenceRRMID>
    <RRMComponentID>2197</RRMComponentID>
    <VariationPendingFlag>false</VariationPendingFlag>
    <InterstateOverseasRelocationFlag>false</InterstateOverseasRelocationFlag>
    <EffectiveDateFrom>2014-05-06T08:11:00+10:00</EffectiveDateFrom>
    <DateCreated>2014-05-06T08:11:00+10:00</DateCreated>
    <CreatedBySystemUserID>1334</CreatedBySystemUserID>
    <RowTimestamp>AAAAAADFKWg=</RowTimestamp>
    <RecordMode>R</RecordMode>
  </RadiationLicenceRRMComponent>
  <RadiationLicenceRRMComponent>
    <RadiationLicenceRRMComponentID>2215</RadiationLicenceRRMComponentID>
    <RadiationLicenceRRMID>2127</RadiationLicenceRRMID>
    <RRMComponentID>2198</RRMComponentID>
    <VariationPendingFlag>false</VariationPendingFlag>
    <InterstateOverseasRelocationFlag>false</InterstateOverseasRelocationFlag>
    <EffectiveDateFrom>2014-05-06T08:11:00+10:00</EffectiveDateFrom>
    <DateCreated>2014-05-06T08:11:00+10:00</DateCreated>
    <CreatedBySystemUserID>1334</CreatedBySystemUserID>
    <RowTimestamp>AAAAAADFKWo=</RowTimestamp>
    <RecordMode>R</RecordMode>
  </RadiationLicenceRRMComponent>
  <RadiationLicenceRRM>
    <RadiationLicenceRRMID>2126</RadiationLicenceRRMID>
    <RRMStatusID>785</RRMStatusID>
    <RRMStatus>Active</RRMStatus>
    <RRMTypeID>1</RRMTypeID>
    <RRMType>Radiation apparatus</RRMType>
    <RRMPurposeID>2</RRMPurposeID>
    <RRMPurpose>Chiropractic</RRMPurpose>
    <RRMID>2</RRMID>
    <RRM>General Radiography</RRM>
    <WorkArea>te</WorkArea>
    <RRMSecurityClassificationID>5</RRMSecurityClassificationID>
    <DateCreated>2014-05-06T08:11:00+10:00</DateCreated>
    <CreatedBySystemUserID>1334</CreatedBySystemUserID>
    <RowTimestamp>AAAAAADFKWE=</RowTimestamp>
    <RecordMode>R</RecordMode>
    <IsRelocated>false</IsRelocated>
  </RadiationLicenceRRM>
  <RadiationLicenceRRM>
    <RadiationLicenceRRMID>2127</RadiationLicenceRRMID>
    <RRMStatusID>785</RRMStatusID>
    <RRMStatus>Active</RRMStatus>
    <RRMTypeID>2</RRMTypeID>
    <RRMType>Sealed source device</RRMType>
    <RRMID>32</RRMID>
    <RRM>Cobalt Therapy Units (Gamma Knife etc)</RRM>
    <WorkArea>s</WorkArea>
    <RRMSecurityClassificationID>5</RRMSecurityClassificationID>
    <DateCreated>2014-05-06T08:11:00+10:00</DateCreated>
    <CreatedBySystemUserID>1334</CreatedBySystemUserID>
    <RowTimestamp>AAAAAADFKWs=</RowTimestamp>
    <RecordMode>R</RecordMode>
    <IsRelocated>false</IsRelocated>
  </RadiationLicenceRRM>
  <RRMComponent>
    <RRMComponentID>2195</RRMComponentID>
    <RadiationLicenceRRMID>2126</RadiationLicenceRRMID>
    <RRMTypeID>1</RRMTypeID>
    <ComponentStatusID>785</ComponentStatusID>
    <ComponentStatus>Active</ComponentStatus>
    <RRMComponentTypeID>1</RRMComponentTypeID>
    <RRMComponentType>Control console / generator</RRMComponentType>
    <ManufacturerID>52</ManufacturerID>
    <Manufacturer>ADM Nuclear</Manufacturer>
    <ModelNumber>33</ModelNumber>
    <SerialNumber>3</SerialNumber>
    <ExtendedWorkingLifeFlag>false</ExtendedWorkingLifeFlag>
    <DateCreated>2014-05-06T08:11:00+10:00</DateCreated>
    <CreatedBySystemUserID>1334</CreatedBySystemUserID>
    <RowTimestamp>AAAAAADFKWM=</RowTimestamp>
    <RecordMode>R</RecordMode>
    <RadiationLicenceStatusDisposedPending>false</RadiationLicenceStatusDisposedPending>
    <IsRelocated>false</IsRelocated>
  </RRMComponent>
  <RRMComponent>
    <RRMComponentID>2196</RRMComponentID>
    <RadiationLicenceRRMID>2126</RadiationLicenceRRMID>
    <RRMTypeID>1</RRMTypeID>
    <ComponentStatusID>785</ComponentStatusID>
    <ComponentStatus>Active</ComponentStatus>
    <RRMComponentTypeID>2</RRMComponentTypeID>
    <RRMComponentType>X-ray tube housing</RRMComponentType>
    <ManufacturerID>52</ManufacturerID>
    <Manufacturer>ADM Nuclear</Manufacturer>
    <ModelNumber>3</ModelNumber>
    <SerialNumber>3</SerialNumber>
    <ExtendedWorkingLifeFlag>false</ExtendedWorkingLifeFlag>
    <DateCreated>2014-05-06T08:11:00+10:00</DateCreated>
    <CreatedBySystemUserID>1334</CreatedBySystemUserID>
    <RowTimestamp>AAAAAADFKWU=</RowTimestamp>
    <RecordMode>R</RecordMode>
    <RadiationLicenceStatusDisposedPending>false</RadiationLicenceStatusDisposedPending>
    <IsRelocated>false</IsRelocated>
  </RRMComponent>
  <RRMComponent>
    <RRMComponentID>2197</RRMComponentID>
    <RadiationLicenceRRMID>2127</RadiationLicenceRRMID>
    <RRMTypeID>2</RRMTypeID>
    <ComponentStatusID>785</ComponentStatusID>
    <ComponentStatus>Active</ComponentStatus>
    <RRMComponentTypeID>4</RRMComponentTypeID>
    <RRMComponentType>Container</RRMComponentType>
    <ManufacturerID>2</ManufacturerID>
    <Manufacturer>Acoma</Manufacturer>
    <ModelNumber>3</ModelNumber>
    <SerialNumber>3</SerialNumber>
    <ExtendedWorkingLifeFlag>false</ExtendedWorkingLifeFlag>
    <DateCreated>2014-05-06T08:11:00+10:00</DateCreated>
    <CreatedBySystemUserID>1334</CreatedBySystemUserID>
    <RowTimestamp>AAAAAADFKWc=</RowTimestamp>
    <RecordMode>R</RecordMode>
    <RadiationLicenceStatusDisposedPending>false</RadiationLicenceStatusDisposedPending>
    <IsRelocated>false</IsRelocated>
  </RRMComponent>
  <RRMComponent>
    <RRMComponentID>2198</RRMComponentID>
    <RadiationLicenceRRMID>2127</RadiationLicenceRRMID>
    <RRMTypeID>2</RRMTypeID>
    <ComponentStatusID>785</ComponentStatusID>
    <ComponentStatus>Active</ComponentStatus>
    <RRMComponentTypeID>5</RRMComponentTypeID>
    <RRMComponentType>Sealed source</RRMComponentType>
    <AssayDate>2014-04-30T14:00:00+10:00</AssayDate>
    <ManufacturerID>3</ManufacturerID>
    <Manufacturer>Acteon</Manufacturer>
    <SerialNumber>3</SerialNumber>
    <RadionuclideID>1</RadionuclideID>
    <NominalActivity>3.00</NominalActivity>
    <WorkingLife>15</WorkingLife>
    <ExtendedWorkingLifeFlag>false</ExtendedWorkingLifeFlag>
    <DateCreated>2014-05-06T08:11:00+10:00</DateCreated>
    <CreatedBySystemUserID>1334</CreatedBySystemUserID>
    <RowTimestamp>AAAAAADFKWk=</RowTimestamp>
    <RecordMode>R</RecordMode>
    <RadiationLicenceStatusDisposedPending>false</RadiationLicenceStatusDisposedPending>
    <IsRelocated>false</IsRelocated>
  </RRMComponent>
</DataRadiationLocation>'

        DECLARE @tblRadiationLocationRRM as tblRadiationLocationRRMType
       
		DECLARE @RadiationLocationRRMID as int = 0
		DECLARE @CreatedByUserID AS INT = 0
		DECLARE @UpdatedByUserID AS INT = 0

		DECLARE @VariationPendingFlag as BIT
		DECLARE @InterstateOverseasRelocationFlag as BIT
		DECLARE @Recipient VARCHAR(150)
		DECLARE @RecipientAddress VARCHAR(255)
		DECLARE @State VARCHAR(3)
		DECLARE @Country VARCHAR(150)

		INSERT INTO @tblRadiationLocationRRM(
												 [RadiationLocationRRMID]
												,[RadiationLocationID]
												,[RadiationLicenceRRMID]
												,[VariationPendingFlag]
												,[NewLocationID]
												,[Notes]
												,[InterstateOverseasRelocationFlag]
												,[Recipient]
												,[RecipientAddress]
												,[State]
												,[Country]
												,[ExportedDate]
												,[EffectiveDateFrom]
												,[EffectiveDateTo]
												,[DateCreated]
												,[CreatedBySystemUserID]
												,[DateUpdated]
												,[UpdatedBySystemUserID]
		                                    )
	SELECT   RN.S.value('RadiationLocationRRMID[1]','int') AS RadiationLocationRRMID,
	         RN.S.value('RadiationLocationID[1]','int') AS RadiationLocationID,
			 RN.S.value('RadiationLicenceRRMID[1]','int') AS RadiationLicenceRRMID,
			 RN.S.value('VariationPendingFlag[1]','bit') AS VariationPendingFlag,
			 RN.S.value('NewLocationID[1]','int') AS NewLocationID,
			 RN.S.value('Notes[1]','varchar(255)')  AS Notes,
			 RN.S.value('InterstateOverseasRelocationFlag[1]','bit') AS InterstateOverseasRelocationFlag,	
			 RN.S.value('Recipient[1]','varchar(150)') AS Recipient,	 			 			 		
			 RN.S.value('RecipientAddress[1]','varchar(255)') AS RecipientAddress,
			 RN.S.value('State[1]','varchar(3)') AS State,
			 RN.S.value('Country[1]','varchar(150)') AS Country,			 	 		 			 			 		  			 			 
			 RN.S.value('ExportedDate[1]', 'smalldatetime') AS ExportedDate,
		     RN.S.value('EffectiveDateFrom[1]', 'smalldatetime') AS EffectiveDateFrom,
		     RN.S.value('EffectiveDateTo[1]', 'smalldatetime') AS EffectiveDateTo,
			 RN.S.value('DateCreated[1]', 'smalldatetime') AS DateCreated,
			 RN.S.value('CreatedBySystemUserID[1]','int') AS CreatedBySystemUserID,
			 RN.S.value('DateUpdated[1]', 'smalldatetime') AS DateUpdated,
			 RN.S.value('UpdatedBySystemUserID[1]','int') AS UpdatedBySystemUserID 
   FROM @xmlRadiationLocation.nodes('//DataRadiationLocation/RadiationLocationRRM') AS RN(S)


   SELECT	@RadiationLocationRRMID = xmlVals.rowvals.query('RadiationLocationRRMID').value('.','INT'),
			@CreatedByUserID = xmlVals.rowvals.query('CreatedBySystemUserID').value('.','INT'),
			@UpdatedByUserID = xmlVals.rowvals.query('UpdatedBySystemUserID').value('.','INT')
   From @xmlRadiationLocation.nodes('//DataRadiationLocation/RadiationLocationRRM') as xmlVals(rowvals)

   if exists(select * from @tblRadiationLocationRRM where RadiationLicenceRRMID = @RadiationLicenceRRMID and VariationPendingFlag = 1)
   begin
	    select @RadiationLocationRRMID=RadiationLocationRRMID,
		   @CreatedByUserID = CreatedByUserID,
		   @UpdatedByUserID = UpdatedByUserID,
		   @VariationPendingFlag = VariationPendingFlag,
		   @InterstateOverseasRelocationFlag = InterstateOverseasRelocationFlag,
		   @Recipient = Recipient,
		   @RecipientAddress = RecipientAddress,
		   @State = State,
		   @Country = Country
	    from @tblRadiationLocationRRM where RadiationLicenceRRMID = @RadiationLicenceRRMID and VariationPendingFlag = 1

		IF EXISTS(SELECT 1 from tblRadiationLocationRRM WHERE RadiationLocationRRMID = @RadiationLocationRRMID)
			BEGIN
				Update rrmc
					SET ComponentStatusID = 811,
					UpdatedBySystemUserID = @CreatedByUserID,
					DateUpdated = GETDATE()				
				FROM tblRRMComponent rrmc
				inner join tblRadiationLicenceRRMComponent licrrmc on rrmc.RRMComponentID = licrrmc.RRMComponentID
				inner join tblRadiationLicenceRRM rrm ON licrrmc.RadiationLicenceRRMID = rrm.RadiationLicenceRRMID
				inner join tblRadiationLocationRRM locrrm
				on rrm.RadiationLicenceRRMID = locrrm.RadiationLicenceRRMID
				where locrrm.RadiationLocationRRMID = @RadiationLocationRRMID
				AND rrmc.ComponentStatusID = 785

				UPDATE lirrmc
					SET VariationPendingFlag = 1,
					UpdatedBySystemUserID = @CreatedByUserID,
					DateUpdated = GETDATE()
				FROM tblRadiationLicenceRRMComponent lirrmc
				INNER JOIN tblRadiationLicenceRRM rrm ON lirrmc.RadiationLicenceRRMID = rrm.RadiationLicenceRRMID
				inner join tblRadiationLocationRRM locrrm
				on rrm.RadiationLicenceRRMID = locrrm.RadiationLicenceRRMID
				WHERE locrrm.RadiationLocationRRMID = @RadiationLocationRRMID AND lirrmc.VariationPendingFlag = 0

				UPDATE lorrm
					SET VariationPendingFlag = @VariationPendingFlag,
						InterstateOverseasRelocationFlag = @InterstateOverseasRelocationFlag,
						Recipient = @Recipient,
						RecipientAddress = @RecipientAddress,
						[State] = @State,
						Country = @Country,
						DateUpdated = GETDATE(),
						UpdatedBySystemUserID = @UpdatedByUserID
				FROM tblRadiationLocationRRM lorrm
				WHERE lorrm.RadiationLocationRRMID = @RadiationLocationRRMID

				--UPDATE lorrm
				--	SET VariationPendingFlag = xmlR.VariationPendingFlag,
				--		InterstateOverseasRelocationFlag = xmlR.InterstateOverseasRelocationFlag,
				--		Recipient = xmlR.Recipient,
				--		RecipientAddress = xmlR.RecipientAddress,
				--		[State] = xmlR.[State],
				--		Country = xmlR.Country,
				--		DateUpdated = GETDATE(),
				--		UpdatedBySystemUserID = @UpdatedByUserID
				--FROM tblRadiationLocationRRM lorrm
				--INNER JOIN
				--(
				--	SELECT							
				--	xmlVals.rowvals.value('(RadiationLocationRRMID)[1]','INT') RadiationLocationRRMID,
				--	xmlVals.rowvals.value('(VariationPendingFlag)[1]','BIT') VariationPendingFlag,
				--	xmlVals.rowvals.value('(InterstateOverseasRelocationFlag)[1]','BIT') InterstateOverseasRelocationFlag,
				--	xmlVals.rowvals.value('(Recipient)[1]','VARCHAR(150)') Recipient,
				--	xmlVals.rowvals.value('(RecipientAddress)[1]','VARCHAR(255)') RecipientAddress,
				--	xmlVals.rowvals.value('(State)[1]','VARCHAR(3)') [State],
				--	xmlVals.rowvals.value('(Country)[1]','VARCHAR(150)') Country
				--	From @xmlRadiationLocation.nodes('//DataRadiationLocation/RadiationLocationRRM') as xmlVals(rowvals)
				--) xmlR
				--ON
				--lorrm.RadiationLocationRRMID = xmlR.RadiationLocationRRMID

				UPDATE lirrm
					SET RRMStatusID = 811,
						DateUpdated = GETDATE(),
						UpdatedBySystemUserID = @UpdatedByUserID
				FROM tblRadiationLicenceRRM lirrm
				join tblRadiationLocationRRM lorrm on lirrm.RadiationLicenceRRMID = lorrm.RadiationLicenceRRMID
				WHERE lorrm.RadiationLocationRRMID = @RadiationLocationRRMID AND lirrm.RRMStatusID not in(810,786)
			END

		select 1

	end
