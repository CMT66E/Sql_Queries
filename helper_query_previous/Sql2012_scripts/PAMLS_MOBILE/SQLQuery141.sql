		  select 
			  b.AccountablePartyID,		  			  
			  c.InstrumentID as LicenceNo,
			  e.LocationID,
			  e.LocationName,			  
			  ((case isnull(h.PrefixAddress, '') when '' then '' else h.PrefixAddress + ' ' end) 
			  + (case h.Address when null then '' when '' then '' else h.Address end)
			  + (case h.Suburb when null then '' when '' then '' else ', ' + h.Suburb end)
			  + (case h.StateCode when null then '' when '' then '' else ' ' + h.StateCode end)
			  + (case h.Postcode when null then '' when '' then '' else ' ' + h.Postcode end)) as LocationAddress,
			  e.AdditionalAddressInformation
          from
		  dbo.tblInstrumentAccountableParty  a 
			  left outer join tblAccountableParty b on a.AccountablePartyID= b.AccountablePartyID
			  left outer join tblInstrument c on a.InstrumentID = c.InstrumentID 
			  left outer join tblInstrumentLocation d on c.InstrumentID = d.InstrumentID 
			  inner join tblLocation e on d.LocationID = e.LocationID
			  left outer join tblAddress h on e.AddressID = h.AddressID 
			  inner join tblPOEOLicenceFeeBasedActivity AS FeeBasedActivity ON c.InstrumentID = FeeBasedActivity.InstrumentID
			  inner join tblFeeBasedActivity FBA ON FBA.FeeBasedActivityID = FeeBasedActivity.FeeBasedActivityID
			  inner join tblFeeBasedActivityScale FeeScale ON FBA.FeeBasedActivityID = FeeScale.FeeBasedActivityID AND FeeBasedActivity.FeeBasedActivityScaleID = FeeScale.FeeBasedActivityScaleID
		  where c.InstrumentTypeID = 493    --poeo licence type only
			  and c.InstrumentStatusID = 3  --issued
			  and FBA.PremisesFlag = 1        --premise flaghas to be true
			  and b.AccountablePartyID = 3250





 
		 