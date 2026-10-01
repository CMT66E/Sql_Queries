declare @Filter int = 1
declare @InstrumentId int = 6092
declare @NoOfRecords int = 50

 BEGIN TRY	
		DECLARE @CommunicationType Table
						(	
							[Type] Varchar(50) null,
							RecordNo int null, 
							InstrumentID int null, 
							CommunicationTypeID int null, 
							CreatedDate DATETIME null, 
							CreatedDateString VARCHAR(10) null,
							AdditionalInfo varchar(500) null, 
							CommunicationType varchar(128) null, 
							UploadDocumentName varchar(128) null, 
							[Status] varchar(50) null, 
							StatusDate DATE null, 
							StatusDateString VARCHAR(10) null,
							DocumentExists BIT null
						)
		
			
	
		IF(@Filter = 1)
			Begin
				Insert Into @CommunicationType
				(
					Type,
					RecordNo,
					InstrumentID,
					CommunicationTypeID,
					CreatedDate,
					CreatedDateString,
					AdditionalInfo,
					CommunicationType,
					UploadDocumentName,
					Status,
					StatusDate,
					StatusDateString,
					DocumentExists
				)
				SELECT     
					'CommunicationRecord' AS [Type], 
					IC.InstrumentCommunicationID AS RecordNo, 
					IC.InstrumentID, 
					IC.CommunicationTypeID, 
					IC.DateCreated AS CreatedDate, 
					Convert(VARCHAR(10),IC.ReceivedDate,103) AS CreatedDateString,
					IC.BriefDescription AS AdditionalInfo, 
					C.CommunicationType, 
					IC.UploadDocumentName, 
					'' AS Status, 
					IC.ReceivedDate as StatusDate, 
					null,
					CAST((CASE WHEN (UploadDocumentName != NULL OR
						UploadDocumentName != '') THEN 1 ELSE 0 END) AS BIT) AS DocumentExists
				FROM
					dbo.tblInstrumentCommunication IC INNER JOIN
					dbo.tblCommunicationType C
					ON 	IC.CommunicationTypeID = C.CommunicationTypeID
				Where	IC.InstrumentID = @InstrumentId
				Order by IC.InstrumentCommunicationID DESC
				
				Insert Into @CommunicationType
				(
					Type,
					RecordNo,
					InstrumentID,
					CommunicationTypeID,
					CreatedDate,
					CreatedDateString,
					AdditionalInfo,
					CommunicationType,
					UploadDocumentName,
					Status,
					StatusDate,
					StatusDateString,
					DocumentExists
				)
				Select 
					'LicenseVersion' [Type],
					ID.LicenceDocumentID RecordNo,
					ID.InstrumentID,
					null,
					ID.DateCreated,
					Convert(VARCHAR(10),ID.DateCreated,103),
					ID.VersionDescription,
					'Licence Version' + ' ' + Cast(ID.VersionNo as varchar(10)),
					null,
					null,
					ID.DateCreated,
					Convert(VARCHAR(10),ID.DateCreated,103),
					1
				From viewLicenceDocument ID
					Where ID.InstrumentID = @InstrumentId
					Order by ID.LicenceDocumentID DESC
					
				Insert Into @CommunicationType
				(
					Type,
					RecordNo,
					InstrumentID,
					CommunicationTypeID,
					CreatedDate,
					CreatedDateString,
					AdditionalInfo,
					CommunicationType,
					UploadDocumentName,
					Status,
					StatusDate,
					StatusDateString,
					DocumentExists
				)
				Select 
					'ARDoc' [Type],
					ID.AnnualReturnDocumentID RecordNo,
					ID.LicenceNo,
					null,
					ID.DateCreated,
					Convert(VARCHAR(10),ID.DateCreated,103),
					ID.VersionDescription,
					null,
					null,
					null,
					ID.DateCreated,
					Convert(VARCHAR(10),ID.DateCreated,103),
					1
				From viewAnnualReturnDocument ID
					Where ID.LicenceNo = @InstrumentId
					Order by ID.AnnualReturnDocumentID DESC
				
				---modified below 03-11-2016
		            DECLARE @tblInstrumentNoticeTemp Table
					(								 							
						InstrumentID int null,
						InstrumentAuditLogID int null 						 
					)
					insert into @tblInstrumentNoticeTemp
					select a.InstrumentID, b.InstrumentAuditLogID 
					from tblInstrumentNotice a 
					left outer join tblInstrumentAuditLog b on a.NoticeInstrumentID = b.InstrumentID
					where a.InstrumentID = @InstrumentId and b.ChangedStatusFlag = 1
				---end modified above 03-11-2016

				Insert Into @CommunicationType
					(
						Type,
						RecordNo,
						InstrumentID,
						CommunicationTypeID,
						CreatedDate,
						CreatedDateString,
						AdditionalInfo,
						CommunicationType,
						UploadDocumentName,
						Status,
						StatusDate,
						StatusDateString,
						DocumentExists
					)	
					SELECT 
						'Notice' [Type],
						[IN].NoticeInstrumentID RecordNo,
						I.InstrumentID,
						null,
						N.DateCreated,
						Convert(VARCHAR(10),N.DateCreated,103),
						N.ReasonForNotice,
						NT.TemplateName,
						null,
						C.Name as [Status],
						AL.DateCreated as StatusDate,
						Convert(VARCHAR(10),AL.DateCreated,103),
						(CASE WHEN (N.NoticeTemplateID = 23 OR N.NoticeTemplateID = 24) THEN 0 ELSE
						(CASE WHEN (I1.InstrumentStatusID = 11 OR
									I1.InstrumentStatusID = 12 OR 
									I1.InstrumentStatusID = 566 OR 
									I1.InstrumentStatusID = 630 OR
									(I1.InstrumentStatusID = 15 AND N.NoticeTemplateID = 21)) THEN 1 ELSE 0 END) END)
					 FROM 
						tblInstrumentNotice [IN]
					LEFT OUTER JOIN tblInstrument I
					ON [IN].InstrumentID = I.InstrumentID
					LEFT OUTER JOIN tblInstrument I1 ON
					[IN].NoticeInstrumentID = I1.InstrumentID
					LEFT OUTER JOIN tblNotice N
					ON [IN].NoticeInstrumentID = N.InstrumentID
					LEFT OUTER JOIN tblNoticeTemplate NT
					ON NT.NoticeTemplateID = N.NoticeTemplateID
					LEFT OUTER JOIN tblClassification C ON
					C.ClassificationID = I1.InstrumentStatusID
                    LEFT OUTER JOIN tblInstrumentAuditLog AL
						    ON AL.InstrumentAuditLogID = (Select MAX(AL1.InstrumentAuditLogID) FROM @tblInstrumentNoticeTemp AL1  
													      Where AL1.InstrumentID = N.InstrumentID)
					--LEFT OUTER JOIN tblInstrumentAuditLog AL
					--ON AL.InstrumentAuditLogID = (Select MAX(AL1.InstrumentAuditLogID) FROM tblInstrumentAuditLog AL1
					--								Where AL1.InstrumentID = N.InstrumentID AND AL1.ChangedStatusFlag = 1)
						Where I.InstrumentID = @InstrumentId
						Order by N.NoticeTemplateID DESC 	
				
				Insert Into @CommunicationType
				(
					Type,
					RecordNo,
					InstrumentID,
					CommunicationTypeID,
					CreatedDate,
					CreatedDateString,
					AdditionalInfo,
					CommunicationType,
					UploadDocumentName,
					Status,
					StatusDate,
					StatusDateString,
					DocumentExists
				)	
				SELECT 'ELRA' [Type],
					ra.InstrumentID RecordNo,
					I.InstrumentID,
					null,
					ra.DateCreated,
					Convert(VARCHAR(10),ra.DateCreated,103),
					reason.Name,
					'Environment licence risk assessment',
					null,
					C.Name as [Status],
					AL.DateCreated as StatusDate,
					Convert(VARCHAR(10),AL.DateCreated,103),
					1
				FROM tblRiskAssessment ra
				LEFT OUTER JOIN tblInstrument I ON ra.InstrumentID = I.InstrumentID 
				LEFT OUTER JOIN tblInstrument primaryrecord ON ra.POEOLicenceIntrumentID = primaryrecord.InstrumentID
				LEFT OUTER JOIN tblClassification C ON C.ClassificationID = I.InstrumentStatusID
				LEFT OUTER JOIN tblClassification reason ON ra.AssessmentReasonID = reason.ClassificationID
				LEFT OUTER JOIN tblInstrumentAuditLog AL
									ON AL.InstrumentAuditLogID = (Select MAX(AL1.InstrumentAuditLogID) FROM tblInstrumentAuditLog AL1
																	Where AL1.InstrumentID = ra.InstrumentID AND AL1.ChangedStatusFlag = 1)
				Where primaryrecord.InstrumentID = @InstrumentId 
					AND ra.RiskAssessmentTypeID = 694 AND I.InstrumentStatusID = 700
				Order by ra.InstrumentID DESC
				
				Insert Into @CommunicationType
					(
						Type,
						RecordNo,
						InstrumentID,
						CommunicationTypeID,
						CreatedDate,
						CreatedDateString,
						AdditionalInfo,
						CommunicationType,
						UploadDocumentName,
						Status,
						StatusDate,
						StatusDateString,
						DocumentExists
					)	
					SELECT 'EMA' [Type],
						ra.InstrumentID RecordNo,
						I.InstrumentID,
						null,
						ra.DateCreated,
						Convert(VARCHAR(10),ra.DateCreated,103),
						docra.VersionDescription,
						'Environmental management assessment',
						null,
						C.Name as [Status],
						AL.DateCreated as StatusDate,
						Convert(VARCHAR(10),AL.DateCreated,103),
						1
					FROM tblRiskAssessment ra
					LEFT OUTER JOIN tblInstrument I ON ra.InstrumentID = I.InstrumentID 
					LEFT OUTER JOIN tblInstrument primaryrecord ON ra.POEOLicenceIntrumentID = primaryrecord.InstrumentID
					LEFT OUTER JOIN tblClassification C ON C.ClassificationID = I.InstrumentStatusID					
					LEFT OUTER JOIN tblInstrumentAuditLog AL
										ON AL.InstrumentAuditLogID = (Select MAX(AL1.InstrumentAuditLogID) FROM tblInstrumentAuditLog AL1
																		Where AL1.InstrumentID = ra.InstrumentID AND AL1.ChangedStatusFlag = 1)
					LEFT OUTER JOIN PALMSDocDB.dbo.tblRiskAssessmentDocument docra ON ra.InstrumentID = docra.InstrumentID
					Where 
					primaryrecord.InstrumentID = @InstrumentId AND 
					ra.RiskAssessmentTypeID = 695 AND I.InstrumentStatusID = 700
					Order by ra.InstrumentID DESC
					
					----added V5.0 radiation licence Eric He 15-01-2014
					Insert Into @CommunicationType
					(
						Type,
						RecordNo,
						InstrumentID,
						CommunicationTypeID,
						CreatedDate,
						CreatedDateString,
						AdditionalInfo,
						CommunicationType,
						UploadDocumentName,
						Status,
						StatusDate,
						StatusDateString,
						DocumentExists
					)
					Select
						'RenewalDoc' [Type],
						ID.RadiationLicenceRenewDocumentID RecordNo,
						ID.LicenceNo,
						null,
						ID.DateCreated,
						Convert(VARCHAR(10),ID.DateCreated,103),
						ID.VersionDescription,
						'Radiation licence renewal notice',
						null,
						null,
						ID.DateCreated,
						Convert(VARCHAR(10),ID.DateCreated,103),
						1
					From viewRadiationLicenceRenewalDocument ID
						Where ID.LicenceNo = @InstrumentId
						Order by ID.RadiationLicenceRenewDocumentID DESC


				Select Top(@NoOfRecords) * from @CommunicationType order by CreatedDate DESC, RecordNo DESC
			End
		Else IF(@Filter = 2)
			Begin
				Insert Into @CommunicationType
				(
					Type,
					RecordNo,
					InstrumentID,
					CommunicationTypeID,
					CreatedDate,
					CreatedDateString,
					AdditionalInfo,
					CommunicationType,
					UploadDocumentName,
					Status,
					StatusDate,
					StatusDateString,
					DocumentExists
				)
				SELECT     
					'CommunicationRecord' AS [Type], 
					IC.InstrumentCommunicationID AS RecordNo, 
					IC.InstrumentID, 
					IC.CommunicationTypeID, 
					IC.DateCreated AS CreatedDate, 
					Convert(VARCHAR(10),IC.ReceivedDate,103),
					IC.BriefDescription AS AdditionalInfo, 
					C.CommunicationType, 
					IC.UploadDocumentName, 
					'' AS Status, 
					IC.ReceivedDate as StatusDate, 
					null,
					CAST((CASE WHEN (UploadDocumentName != NULL OR
						UploadDocumentName != '') THEN 1 ELSE 0 END) AS BIT) AS DocumentExists
				FROM
					dbo.tblInstrumentCommunication IC INNER JOIN
					dbo.tblCommunicationType C
					ON 	IC.CommunicationTypeID = C.CommunicationTypeID
				Where	IC.InstrumentID = @InstrumentId
				Order by IC.InstrumentCommunicationID DESC
				
				Insert Into @CommunicationType
				(
					Type,
					RecordNo,
					InstrumentID,
					CommunicationTypeID,
					CreatedDate,
					CreatedDateString,
					AdditionalInfo,
					CommunicationType,
					UploadDocumentName,
					Status,
					StatusDate,
					StatusDateString,
					DocumentExists
				)
				Select
					'LicenseVersion' [Type],
					ID.LicenceDocumentID RecordNo,
					ID.InstrumentID,
					null,
					ID.DateCreated,
					Convert(VARCHAR(10),ID.DateCreated,103),
					ID.VersionDescription,
					'License Version' + ' ' + Cast(ID.VersionNo as varchar(10)),
					null,
					null,
					ID.DateCreated,
					Convert(VARCHAR(10),ID.DateCreated,103),
					1
				From viewLicenceDocument ID
					Where ID.InstrumentID = @InstrumentId
					Order by ID.LicenceDocumentID DESC
					
				Insert Into @CommunicationType
				(
					Type,
					RecordNo,
					InstrumentID,
					CommunicationTypeID,
					CreatedDate,
					CreatedDateString,
					AdditionalInfo,
					CommunicationType,
					UploadDocumentName,
					Status,
					StatusDate,
					StatusDateString,
					DocumentExists
				)
				Select
					'ARDoc' [Type],
					ID.AnnualReturnDocumentID RecordNo,
					ID.LicenceNo,
					null,
					ID.DateCreated,
					Convert(VARCHAR(10),ID.DateCreated,103),
					ID.VersionDescription,
					null,
					null,
					null,
					ID.DateCreated,
					Convert(VARCHAR(10),ID.DateCreated,103),
					1
				From viewAnnualReturnDocument ID
					Where ID.LicenceNo = @InstrumentId
					Order by ID.AnnualReturnDocumentID DESC
				
				Insert Into @CommunicationType
					(
						Type,
						RecordNo,
						InstrumentID,
						CommunicationTypeID,
						CreatedDate,
						CreatedDateString,
						AdditionalInfo,
						CommunicationType,
						UploadDocumentName,
						Status,
						StatusDate,
						StatusDateString,
						DocumentExists
					)	
					SELECT 
						'Notice' [Type],
						[IN].NoticeInstrumentID RecordNo,
						I.InstrumentID,
						null,
						N.DateCreated,
						Convert(VARCHAR(10),N.DateCreated,103),
						N.ReasonForNotice,
						NT.TemplateName,
						null,
						C.Name as [Status],
						AL.DateCreated as StatusDate,
						Convert(VARCHAR(10),AL.DateCreated,103),
						(CASE WHEN (N.NoticeTemplateID = 23 OR N.NoticeTemplateID = 24) THEN 0 ELSE
						(CASE WHEN (I1.InstrumentStatusID = 11 OR
									I1.InstrumentStatusID = 12 OR 
									I1.InstrumentStatusID = 566 OR 
									I1.InstrumentStatusID = 630 OR
									(I1.InstrumentStatusID = 15 AND N.NoticeTemplateID = 21)) THEN 1 ELSE 0 END) END)
					 FROM 
						tblInstrumentNotice [IN]
					LEFT OUTER JOIN tblInstrument I
					ON [IN].InstrumentID = I.InstrumentID
					LEFT OUTER JOIN tblInstrument I1 ON
					[IN].NoticeInstrumentID = I1.InstrumentID
					LEFT OUTER JOIN tblNotice N
					ON [IN].NoticeInstrumentID = N.InstrumentID
					LEFT OUTER JOIN tblNoticeTemplate NT
					ON NT.NoticeTemplateID = N.NoticeTemplateID
					LEFT OUTER JOIN tblClassification C ON
					C.ClassificationID = I1.InstrumentStatusID
					LEFT OUTER JOIN tblInstrumentAuditLog AL
					ON AL.InstrumentAuditLogID = (Select MAX(AL1.InstrumentAuditLogID) FROM tblInstrumentAuditLog AL1
													Where AL1.InstrumentID = N.InstrumentID AND AL1.ChangedStatusFlag = 1)
									Where I.InstrumentID = @InstrumentId
									Order by N.NoticeTemplateID DESC 	
					
					Insert Into @CommunicationType
					(
						Type,
						RecordNo,
						InstrumentID,
						CommunicationTypeID,
						CreatedDate,
						CreatedDateString,
						AdditionalInfo,
						CommunicationType,
						UploadDocumentName,
						Status,
						StatusDate,
						StatusDateString,
						DocumentExists
					)	
					SELECT 'ELRA' [Type],
						ra.InstrumentID RecordNo,
						I.InstrumentID,
						null,
						ra.DateCreated,
						Convert(VARCHAR(10),ra.DateCreated,103),
						reason.Name,
						'Environment licence risk assessment',
						null,
						C.Name as [Status],
						AL.DateCreated as StatusDate,
						Convert(VARCHAR(10),AL.DateCreated,103),
						1
					FROM tblRiskAssessment ra
					LEFT OUTER JOIN tblInstrument I ON ra.InstrumentID = I.InstrumentID 
					LEFT OUTER JOIN tblInstrument primaryrecord ON ra.POEOLicenceIntrumentID = primaryrecord.InstrumentID
					LEFT OUTER JOIN tblClassification C ON C.ClassificationID = I.InstrumentStatusID
					LEFT OUTER JOIN tblClassification reason ON ra.AssessmentReasonID = reason.ClassificationID
					LEFT OUTER JOIN tblInstrumentAuditLog AL
										ON AL.InstrumentAuditLogID = (Select MAX(AL1.InstrumentAuditLogID) FROM tblInstrumentAuditLog AL1
																		Where AL1.InstrumentID = ra.InstrumentID AND AL1.ChangedStatusFlag = 1)
					Where 
					primaryrecord.InstrumentID = @InstrumentId AND 
					ra.RiskAssessmentTypeID = 694 AND I.InstrumentStatusID = 700
					Order by ra.InstrumentID DESC
					
					Insert Into @CommunicationType
					(
						Type,
						RecordNo,
						InstrumentID,
						CommunicationTypeID,
						CreatedDate,
						CreatedDateString,
						AdditionalInfo,
						CommunicationType,
						UploadDocumentName,
						Status,
						StatusDate,
						StatusDateString,
						DocumentExists
					)	
					SELECT 'EMA' [Type],
						ra.InstrumentID RecordNo,
						I.InstrumentID,
						null,
						ra.DateCreated,
						Convert(VARCHAR(10),ra.DateCreated,103),
						docra.VersionDescription,
						'Environmental management assessment',
						null,
						C.Name as [Status],
						AL.DateCreated as StatusDate,
						Convert(VARCHAR(10),AL.DateCreated,103),
						1
					FROM tblRiskAssessment ra
					LEFT OUTER JOIN tblInstrument I ON ra.InstrumentID = I.InstrumentID 
					LEFT OUTER JOIN tblInstrument primaryrecord ON ra.POEOLicenceIntrumentID = primaryrecord.InstrumentID
					LEFT OUTER JOIN tblClassification C ON C.ClassificationID = I.InstrumentStatusID					
					LEFT OUTER JOIN tblInstrumentAuditLog AL
										ON AL.InstrumentAuditLogID = (Select MAX(AL1.InstrumentAuditLogID) FROM tblInstrumentAuditLog AL1
																		Where AL1.InstrumentID = ra.InstrumentID AND AL1.ChangedStatusFlag = 1)
					LEFT OUTER JOIN PALMSDocDB.dbo.tblRiskAssessmentDocument docra ON ra.InstrumentID = docra.InstrumentID
					Where 
					primaryrecord.InstrumentID = @InstrumentId AND 
					ra.RiskAssessmentTypeID = 695 AND I.InstrumentStatusID = 700
					Order by ra.InstrumentID DESC
					
					----added V5.0 radiation licence Eric He 15-01-2014
					Insert Into @CommunicationType
					(
						Type,
						RecordNo,
						InstrumentID,
						CommunicationTypeID,
						CreatedDate,
						CreatedDateString,
						AdditionalInfo,
						CommunicationType,
						UploadDocumentName,
						Status,
						StatusDate,
						StatusDateString,
						DocumentExists
					)
					Select
						'RenewalDoc' [Type],
						ID.RadiationLicenceRenewDocumentID RecordNo,
						ID.LicenceNo,
						null,
						ID.DateCreated,
						Convert(VARCHAR(10),ID.DateCreated,103),
						ID.VersionDescription,
						'Radiation licence renewal notice',
						null,
						null,
						ID.DateCreated,
						Convert(VARCHAR(10),ID.DateCreated,103),
						1
					From viewRadiationLicenceRenewalDocument ID
						Where ID.LicenceNo = @InstrumentId
						Order by ID.RadiationLicenceRenewDocumentID DESC

					----end of add 15-01-2014







					Select * from @CommunicationType order by CreatedDate DESC, RecordNo DESC
			End
		Else if (@Filter = 3)
			Begin
				Insert Into @CommunicationType
				(
					Type,
					RecordNo,
					InstrumentID,
					CommunicationTypeID,
					CreatedDate,
					CreatedDateString,
					AdditionalInfo,
					CommunicationType,
					UploadDocumentName,
					Status,
					StatusDate,
					StatusDateString,
					DocumentExists
				)
				Select 
					'LicenseVersion' [Type],
					ID.LicenceDocumentID RecordNo,
					ID.InstrumentID,
					null,
					ID.DateCreated,
					Convert(VARCHAR(10),ID.DateCreated,103),
					ID.VersionDescription,
					'License Version' + ' ' + Cast(ID.VersionNo as varchar(10)),
					null,
					null,
					ID.DateCreated,
					Convert(VARCHAR(10),ID.DateCreated,103),
					1
				From viewLicenceDocument ID
					Where ID.InstrumentID = @InstrumentId
					Order by ID.LicenceDocumentID DESC
										
				Select * from @CommunicationType order by CreatedDate DESC, RecordNo DESC
			End
		ELSE IF (@Filter = 4)
			Begin
				Insert Into @CommunicationType
					(
						Type,
						RecordNo,
						InstrumentID,
						CommunicationTypeID,
						CreatedDate,
						CreatedDateString,
						AdditionalInfo,
						CommunicationType,
						UploadDocumentName,
						Status,
						StatusDate,
						StatusDateString,
						DocumentExists
					)	
						SELECT 
						'Notice' [Type],
						[IN].NoticeInstrumentID RecordNo,
						I.InstrumentID,
						null,
						N.DateCreated,
						Convert(VARCHAR(10),N.DateCreated,103),
						N.ReasonForNotice,
						NT.TemplateName,
						null,
						C.Name as [Status],
						AL.DateCreated as StatusDate,
						Convert(VARCHAR(10),AL.DateCreated,103),
						(CASE WHEN (N.NoticeTemplateID = 23 OR N.NoticeTemplateID = 24) THEN 0 ELSE
						(CASE WHEN (I1.InstrumentStatusID = 11 OR
									I1.InstrumentStatusID = 12 OR 
									I1.InstrumentStatusID = 566 OR 
									I1.InstrumentStatusID = 630 OR
									(I1.InstrumentStatusID = 15 AND N.NoticeTemplateID = 21)) THEN 1 ELSE 0 END) END)
					 FROM
						tblInstrumentNotice [IN]
					LEFT OUTER JOIN tblInstrument I
					ON [IN].InstrumentID = I.InstrumentID
					LEFT OUTER JOIN tblInstrument I1 ON
					[IN].NoticeInstrumentID = I1.InstrumentID
					LEFT OUTER JOIN tblNotice N
					ON [IN].NoticeInstrumentID = N.InstrumentID
					LEFT OUTER JOIN tblNoticeTemplate NT
					ON NT.NoticeTemplateID = N.NoticeTemplateID
					LEFT OUTER JOIN tblClassification C ON
					C.ClassificationID = I1.InstrumentStatusID
					LEFT OUTER JOIN tblInstrumentAuditLog AL
					ON AL.InstrumentAuditLogID = (Select MAX(AL1.InstrumentAuditLogID) FROM tblInstrumentAuditLog AL1
													Where AL1.InstrumentID = N.InstrumentID AND AL1.ChangedStatusFlag = 1)
									Where I.InstrumentID = @InstrumentId
									Order by N.NoticeTemplateID DESC 
									
				Select * from @CommunicationType order by CreatedDate DESC, RecordNo DESC
				 
			END
  END TRY
  BEGIN CATCH

		DECLARE @ErrorMessage VARCHAR(2000)
		ROLLBACK TRAN
		SET @ErrorMessage = dbo.ufn_GetErrorText()
		RAISERROR (@ErrorMessage , 16, 1)	
  END CATCH