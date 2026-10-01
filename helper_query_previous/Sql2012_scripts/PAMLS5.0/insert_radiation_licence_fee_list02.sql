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
where FinancialYear = '2013-14' and RadiationLicenceTypeID = 794

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
 '2015-07-01 00:00:00' as EffectiveDateFrom, 
 '2016-06-30 00:00:00' as EffectiveDateTo, 
 '2015-16' as FinancialYear, 
 DateCreated, 
 CreatedBySystemUserID, 
 DateUpdated, 
 UpdatedBySystemUserID
from tblRadiationLicenceFeeList
where FinancialYear = '2013-14' and RadiationLicenceTypeID = 794

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
 '2016-07-01 00:00:00' as EffectiveDateFrom, 
 '2017-06-30 00:00:00' as EffectiveDateTo, 
 '2016-17' as FinancialYear, 
 DateCreated, 
 CreatedBySystemUserID, 
 DateUpdated, 
 UpdatedBySystemUserID
from tblRadiationLicenceFeeList
where FinancialYear = '2013-14' and RadiationLicenceTypeID = 794

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
 '2017-07-01 00:00:00' as EffectiveDateFrom, 
 '2018-06-30 00:00:00' as EffectiveDateTo, 
 '2017-18' as FinancialYear, 
 DateCreated, 
 CreatedBySystemUserID, 
 DateUpdated, 
 UpdatedBySystemUserID
from tblRadiationLicenceFeeList
where FinancialYear = '2013-14' and RadiationLicenceTypeID = 794