exec uspOWTNewPremisesLicencesForBatchProcess
exec uspOWTNewWasteTransporterLicencesForBatchProcess
exec uspOWTVariationPremisesLicencesForBatchProcess
exec uspOWTVariationTransporterLicencesForBatchProcess
exec uspOWTRevokePremisesLicencesForBatchProcess
exec uspOWTRevokeTransporterLicencesForBatchProcess
exec uspOWTLiftSuspensionPremisesLicencesForBatchProcess      
exec uspOWTLiftSuspensionTransporterLicencesForBatchProcess  
exec uspOWTTransferPremisesLicencesForBatchProcess  
exec uspOWTTransferTransporterLicencesForBatchProcess

exec uspOWTGeneralSingleLicenceDataForIntegrationProcess 803, 9

select * from [WDS].[dbo].[Customer] where PALMSAccountablePartyID in (4271, 5747) and ActiveFlag  = 1
select * from [WDS].[dbo].[Site] where PALMSLocationID  in (2627) and ActiveFlag  = 1