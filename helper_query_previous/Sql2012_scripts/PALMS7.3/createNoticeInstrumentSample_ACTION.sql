declare @inInstrumentID int = 5068556 --source licence No
declare @inTransferLicenceVariationID int = 1537020 
declare @inReasonForNotice varchar(500) = 'Licence variation for vehicle transfer from source licence no ' + cast(@inInstrumentID as varchar) 
declare @IsBulkVariation bit = 0
declare @NoticeTemplateID int = 403 --Transporter licence variation noticetemplateid
declare @InstrumentStatusID int = 9 --Draft status 


declare @NewNoticeInstrumentID int
Declare @InsertedInstrument as tblInstrumentType
Insert Into @InsertedInstrument
					  (
					   [InstrumentID]
					  ,[InstrumentTypeID]
					  ,[InstrumentStatusID]
					  ,[ResponsibleSystemUserID]
					  ,[ResponsibleUserLogin]
					  ,[DECCWSectionID]
					  ,[IssuedBySystemUserID]
					  ,[DateIssued]
					  ,[DisplayFlag]
					  ,[DateCreated]
					  ,[CreatedBySystemUserID]
					  ,[DateUpdated]
					  ,[UpdatedBySystemUserID]
					  )
select                 [InstrumentID]
					  ,[InstrumentTypeID]
					  ,[InstrumentStatusID]
					  ,[ResponsibleSystemUserID]
					  ,[ResponsibleUserLogin]
					  ,[DECCWSectionID]
					  ,[IssuedBySystemUserID]
					  ,[DateIssued]
					  ,[DisplayFlag]
					  ,[DateCreated]
					  ,[CreatedBySystemUserID]
					  ,[DateUpdated]
					  ,[UpdatedBySystemUserID]
where [InstrumentID] = @inTransferLicenceVariationID

Exec @NewNoticeInstrumentID = [dbo].uspSaveInstrument @InsertedInstrument, @IsBulkVariation, @NoticeTemplateID

print '@NewNoticeInstrumentID =' + cast(@NewNoticeInstrumentID as varchar)

insert into tblNotice
(
                        [InstrumentID]
					   ,[NoticeTemplateID]
					   ,[ReasonForNotice]
					   ,[FollowupDays]
					   ,[FeeAmount]
					   ,[ProrataAdminFee]
					   ,[ApplicationAppliedFlag]                                
					   ,[InspectionDate]
					   ,[DateCompleted]
					   ,[CompletedBySystemUserID]
					   ,[NoticeDocument]
					   ,[DateCreated]
					   ,[CreatedBySystemUserID]
					   ,[DateUpdated]
					   ,[UpdatedBySystemUserID]
					   ,[ParentNoticeInstrumentID]
					   ,[AuditTypeID]
					   ,[VariationReportAttachedFlag]
					    ,VNInstigatedByEPAFlag 
 						,VNPublicAdvertisedFlag 
 						,VNAdminConditionVariedFlag 
 						,VNLocationPointVariedFlag
 						,VNLimitConditionVariedFlag
 						,VNOperatingConditionVariedFlag 
 						,VNMonitoringConditionVariedFlag 
 						,VNReportingConditionVariedFlag		
 						,VNGeneralConditionVariedFlag	
 						,VNPRPVariedFlag
 						,VNSpecialConditionVariedFlag
 						,ExemptionGrantedDate
 						,ExemptionExpiryDate
 						,InspectionReportTypeID  --------- PALMS V4.0
						,InspectionArrivalTime   --------- PALMS V6.2
						,InspectionDepartureTime   --------- PALMS V6.2
						,VariationFeeAppliedFlag
						,AdministrativeFlag
)
select 
						@NewNoticeInstrumentID as [InstrumentID]
					   ,[NoticeTemplateID]
					   ,@inReasonForNotice as [ReasonForNotice]
					   ,[FollowupDays]
					   ,[FeeAmount]
					   ,[ProrataAdminFee]
					   ,0 as [ApplicationAppliedFlag]    -- set false for [ApplicationAppliedFlag] on target licence's notice
					   ,[InspectionDate]
					   ,[DateCompleted]
					   ,[CompletedBySystemUserID]
					   ,[NoticeDocument]
					   ,[DateCreated]
					   ,[CreatedBySystemUserID]
					   ,[DateUpdated]
					   ,[UpdatedBySystemUserID]
					   ,[ParentNoticeInstrumentID]
					   ,[AuditTypeID]
					   ,[VariationReportAttachedFlag]
					    ,VNInstigatedByEPAFlag 
 						,VNPublicAdvertisedFlag 
 						,VNAdminConditionVariedFlag 
 						,VNLocationPointVariedFlag
 						,VNLimitConditionVariedFlag
 						,VNOperatingConditionVariedFlag 
 						,VNMonitoringConditionVariedFlag 
 						,VNReportingConditionVariedFlag		
 						,VNGeneralConditionVariedFlag	
 						,VNPRPVariedFlag
 						,VNSpecialConditionVariedFlag
 						,ExemptionGrantedDate
 						,ExemptionExpiryDate
 						,InspectionReportTypeID    --------- PALMS V4.0
						,InspectionArrivalTime     --------- PALMS V6.2
						,InspectionDepartureTime   --------- PALMS V6.2
						,VariationFeeAppliedFlag
						,AdministrativeFlag
from tblNotice where InstrumentID = @inTransferLicenceVariationID

--we don't need create record in tblNoticeApplication table
--select 
--                        [InstrumentID]
--					   ,[ReceivedDate]
--					   ,[CompletedDate]
--					   ,[DateWithdrawn]
--					   ,[DateRefused]
--					   ,[TRIMNumber]
--					   ,[ResponsibilityDate]
--					   ,[NewAnniversaryDate]					  
--					   ,[DateCreated]
--					   ,[CreatedBySystemUserID]
--					   ,[DateUpdated]
--					   ,[UpdatedBySystemUserID]
--					   ,[FullLicenceTransferFlag]
--from tblNoticeApplication 
--where [InstrumentID] = @inTransferLicenceVariationID

insert into tblInstrumentNotice
(
         [InstrumentID]
		,[NoticeInstrumentID]
		,[DateCreated]
		,[CreatedBySystemUserID]
		,[DateUpdated]
		,[UpdatedBySystemUserID]
)
select 
		 @NewNoticeInstrumentID as [InstrumentID]
		,[NoticeInstrumentID]
		,[DateCreated]
		,[CreatedBySystemUserID]
		,[DateUpdated]
		,[UpdatedBySystemUserID]
from tblInstrumentNotice where NoticeInstrumentID = @inTransferLicenceVariationID