select *, RefToRACFlag from tblradiationlicence where InstrumentID not in (select [InstrumentID] from [tblRACReferral])
and RefToRACFlag = 1 and RadiationLicenceTypeID = 795
and InstrumentID in (select distinct InstrumentID from tblRadiationLicenceCondition where RadiationConditionID in (select RadiationConditionID from tblRadiationCondition
where AutomaticRACReferral = 1))


select * from tblRadiationLicenceCondition where RadiationConditionID in (select RadiationConditionID from tblRadiationCondition
where AutomaticRACReferral = 1)

select * from tblRadiationCondition
where AutomaticRACReferral = 1


select distinct InstrumentID from tblRadiationLicenceCondition where RadiationConditionID in (select RadiationConditionID from tblRadiationCondition
where AutomaticRACReferral = 1)


 update tblradiationlicence set RefToRACFlag = 0, DateUpdated= getdate(), UpdatedBySystemUserID = 1 
 where InstrumentID not in (select [InstrumentID] from [tblRACReferral])
and RefToRACFlag = 1 and RadiationLicenceTypeID = 795
and InstrumentID in (select distinct InstrumentID from tblRadiationLicenceCondition where RadiationConditionID in (select RadiationConditionID from tblRadiationCondition
where AutomaticRACReferral = 1))
