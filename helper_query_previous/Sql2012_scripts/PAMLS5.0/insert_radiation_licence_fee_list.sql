insert into tblRadiationLicenceFeeList
(RadiationLicenceTypeID, 
FeeDescription, 
Amount, 
FeeType, 
SequenceOrder, 
EffectiveDateFrom, 
EffectiveDateTo, 
FinancialYear, 
DateCreated,
CreatedBySystemUserID,
DateUpdated, 
UpdatedBySystemUserID
)
select 
 RadiationLicenceTypeID,
 FeeDescription, 
 Amount, 
 FeeType, 
 SequenceOrder, 
 '2014-07-01 00:00:00' as EffectiveDateFrom, 
 '2015-06-30 00:00:00' as EffectiveDateTo, 
 '2014-15' as FinancialYear, 
 DateCreated, 
 CreatedBySystemUserID, 
 DateUpdated, 
 UpdatedBySystemUserID
from tblRadiationLicenceFeeList
where FinancialYear = '2013-14' and RadiationLicenceTypeID = 795