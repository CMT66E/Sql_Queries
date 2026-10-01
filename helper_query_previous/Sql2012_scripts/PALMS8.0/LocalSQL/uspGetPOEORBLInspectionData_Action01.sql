declare @SystemUserId int = 1063
Declare @SectionId int,
			@TotalAlerts int = 0,
			@TotalNotifications int = 0,
	        @SevenFour int = 0

	Create Table 
			#TotalRecords
			(
			TotalRecords int Null,
			RecordType Varchar(250) Null,
			DECCWSectionID int Null,
			InstrumentTypeID int Null,
			GroupID int NULL
			)


	------------------- GroupID --------------------------
	------------- 1; Primay Record
	------------- 2; Annual Return
	------------- 3; Secondary Record
	------------- 4; Risk Based Licensing
	-------------- 5; Inspection 
	-------------- 6: Message

			
	Select @SectionId = DECCWSectionID from tblSystemUser Where SystemUserID = @SystemUserId
	select @SevenFour = value from tblSystemVariable where SystemVariableID = 20

	---Gets Primary Records---
	IF((Select COUNT(*) From tblInstrument where InstrumentTypeID = 493 AND DECCWSectionID = @SectionId AND DisplayFlag = 1)>0)
	Begin
		Insert Into #TotalRecords
			(
				TotalRecords,
				RecordType,
				DECCWSectionID,
				InstrumentTypeID,
				GroupID
			)
			Select 
				COUNT(*) As TotalRecords,
				C.Name AS RecordType,
				I.DECCWSectionID,
				I.InstrumentTypeID,
				1
			From tblInstrument I
			Inner Join tblClassification C ON I.InstrumentTypeID = C.ClassificationID
			Where I.DECCWSectionID = @SectionId AND I.DisplayFlag = 1 AND InstrumentTypeID = 493
			GROUP BY C.Name, I.DECCWSectionID, I.InstrumentTypeID
	END
	ELSE
		Insert Into #TotalRecords
			(
				TotalRecords,
				RecordType,
				DECCWSectionID,
				InstrumentTypeID,
				GroupID
			)
			Select 
				0 As TotalRecords,
				C.Name AS RecordType,
				@SectionId,
				C.ClassificationID,
				1
			From tblClassification C
			WHERE C.ClassificationID = 493
		
			
	---Gets Annual return record which also exists in tblAnnualReturn-------------
	IF((
		Select COUNT(*) From tblInstrument I INNER JOIN tblAnnualReturn A ON A.InstrumentID = I.InstrumentID
		Where I.InstrumentTypeID = 553 AND I.DisplayFlag = 1 AND I.DECCWSectionID = @SectionId)>0)
	Begin
		Insert Into #TotalRecords
			(
				TotalRecords,
				RecordType,
				DECCWSectionID,
				InstrumentTypeID,
				GroupID
			)
			SELECT     COUNT(dbo.tblInstrument.InstrumentID) AS TotalRecords, dbo.tblClassification.Name AS RecordType, dbo.tblInstrument.DECCWSectionID, 
						  dbo.tblInstrument.InstrumentTypeID,
						  2
				FROM         dbo.tblInstrument INNER JOIN
									  dbo.tblClassification ON dbo.tblInstrument.InstrumentTypeID = dbo.tblClassification.ClassificationID INNER JOIN
									  dbo.tblAnnualReturn ON dbo.tblInstrument.InstrumentID = dbo.tblAnnualReturn.InstrumentID
				Where DECCWSectionID = @SectionId
							and InstrumentTypeID= 553 
							and DisplayFlag = 1
				GROUP BY dbo.tblClassification.Name, dbo.tblInstrument.DECCWSectionID, dbo.tblInstrument.InstrumentTypeID
	End
	ELSE
	Insert Into #TotalRecords
			(
				TotalRecords,
				RecordType,
				DECCWSectionID,
				InstrumentTypeID,
				GroupID
			)
			Select 
				0 As TotalRecords,
				C.Name AS RecordType,
				@SectionId,
				C.ClassificationID,
				2
			From tblClassification C
			WHERE C.ClassificationID = 553	
	
	
	
	
	-------------------------------  PALMS V4.0 ----------------------------------------------
	
	IF((
		Select COUNT(*) From tblInstrument I INNER JOIN tblRiskAssessment A ON A.InstrumentID = I.InstrumentID
		Where I.InstrumentTypeID = 679 AND I.DisplayFlag = 1 AND I.DECCWSectionID = @SectionId and  RiskAssessmentTypeID = 694)>0)
	Begin
		Insert Into #TotalRecords
			(
				TotalRecords,
				RecordType,
				DECCWSectionID,
				InstrumentTypeID,
				GroupID
			)
			SELECT     COUNT(dbo.tblInstrument.InstrumentID) AS TotalRecords, dbo.tblClassification.Name AS RecordType, dbo.tblInstrument.DECCWSectionID, 
						  dbo.tblInstrument.InstrumentTypeID,
						  4
				FROM         dbo.tblInstrument INNER JOIN
								dbo.tblRiskAssessment ON dbo.tblInstrument.InstrumentID = dbo.tblRiskAssessment.InstrumentID INNER JOIN
									  dbo.tblClassification ON dbo.tblRiskAssessment.RiskAssessmentTypeID = dbo.tblClassification.ClassificationID 
				Where DECCWSectionID = @SectionId
							and InstrumentTypeID= 679 and  RiskAssessmentTypeID = 694  ----------  Environmental risk assessment
							and DisplayFlag = 1
				GROUP BY dbo.tblClassification.Name, dbo.tblInstrument.DECCWSectionID, dbo.tblInstrument.InstrumentTypeID
	End
	ELSE
	Insert Into #TotalRecords
			(
				TotalRecords,
				RecordType,
				DECCWSectionID,
				InstrumentTypeID,
				GroupID
			)
			Select 
				0 As TotalRecords,
				C.Name AS RecordType,
				@SectionId,
				C.ClassificationID,
				4
			From tblClassification C
			WHERE C.ClassificationID = 694	
	
	-------------------------------  PALMS V7.1 Environmental Management Category ----------------------------------------------

	-------------------------------  PALMS V7.2 Environmental risk assessment due added 22-11-2016 by Eric He ----------------------------------------------
	declare @DefinedDays int = 0
	select @DefinedDays = value from tblSystemVariable where SystemVariableID = 24

	IF((Select COUNT(*) From [ViewERADueDate] a  
	      INNER JOIN tblInstrument I ON a.InstrumentID = I.InstrumentID 
		  INNER JOIN tblClassification C ON I.InstrumentTypeID = C.ClassificationID
		  where I.InstrumentTypeID = 493 AND DECCWSectionID = @SectionId AND getdate() >= DATEADD(day, (-1)*@DefinedDays, a.ERADueDate))>0)
	Begin
			declare @Temp_TotalRecords int = 0
			declare @Temp_RecordType varchar(500) = ''
			declare @Temp_DECCWSectionID int = 0
			declare @Temp_InstrumentTypeID int = 0

			Select TOP 1
				@Temp_TotalRecords = COUNT(*),
				@Temp_RecordType = 'Environment risk assessment due',
				@Temp_DECCWSectionID = I.DECCWSectionID,
				@Temp_InstrumentTypeID = I.InstrumentTypeID 
			From [ViewERADueDate] a  INNER JOIN tblInstrument I ON a.InstrumentID = I.InstrumentID 
			INNER JOIN tblClassification C ON I.InstrumentTypeID = C.ClassificationID
			Where I.DECCWSectionID = @SectionId AND I.InstrumentTypeID = 493
			AND getdate() >= DATEADD(day, (-1)*@DefinedDays, a.ERADueDate) 
			GROUP BY C.Name, I.DECCWSectionID, I.InstrumentTypeID

			Insert Into #TotalRecords
			select @Temp_TotalRecords, @Temp_RecordType, @Temp_DECCWSectionID, @Temp_InstrumentTypeID, 4 as GroupID
	END
	ELSE
		Insert Into #TotalRecords
			(
				TotalRecords,
				RecordType,
				DECCWSectionID,
				InstrumentTypeID,
				GroupID
			)
			Select 
				0 As TotalRecords,
				'Environment risk assessment due' AS RecordType,
				@SectionId,
				C.ClassificationID,
				4
			From tblClassification C
			WHERE C.ClassificationID = 493
	-------------------------------- end of PALMS V7.2 Environmental risk assessment due -------------------------------------
	IF((
		Select COUNT(*) From tblInstrument I INNER JOIN tblRiskAssessment A ON A.InstrumentID = I.InstrumentID
		Where I.InstrumentTypeID = 679 AND I.DisplayFlag = 1 AND I.DECCWSectionID = @SectionId and RiskAssessmentTypeID = 695 and I.InstrumentStatusID = 1032)>0)  --1032 pending
	Begin
		Insert Into #TotalRecords
			(
				TotalRecords,
				RecordType,
				DECCWSectionID,
				InstrumentTypeID,
				GroupID
			)
			SELECT     COUNT(distinct dbo.tblInstrument.InstrumentID) AS TotalRecords, 'EMCs Overdue' AS RecordType, dbo.tblInstrument.DECCWSectionID,  -- PALMS V8.0 change EMCs Pending to Overdue as required Eric HE
						  dbo.tblInstrument.InstrumentTypeID,
						  4
				FROM         dbo.tblInstrument INNER JOIN
								dbo.tblRiskAssessment ON dbo.tblInstrument.InstrumentID = dbo.tblRiskAssessment.InstrumentID INNER JOIN
									  dbo.tblClassification ON dbo.tblRiskAssessment.RiskAssessmentTypeID = dbo.tblClassification.ClassificationID 
				Where DECCWSectionID = @SectionId
							and InstrumentTypeID= 679 and  RiskAssessmentTypeID = 695  ----------  Environmental risk assessment
							and DisplayFlag = 1 and tblInstrument.InstrumentStatusID = 1032
				GROUP BY dbo.tblClassification.Name, dbo.tblInstrument.DECCWSectionID, dbo.tblInstrument.InstrumentTypeID
	End
	ELSE
	Insert Into #TotalRecords
			(
				TotalRecords,
				RecordType,
				DECCWSectionID,
				InstrumentTypeID,
				GroupID
			)
			Select 
				0 As TotalRecords,
				--C.Name AS RecordType,
				'EMCs Overdue' AS RecordType,   -- PALMS V8.0 change EMCs Pending to Overdue as required Eric HE
				@SectionId,
				C.ClassificationID,
				4
			From tblClassification C
			WHERE C.ClassificationID = 695	

    -----------------------------------------------------------------------------------------------------------------------------------------------------------
	IF((
		Select COUNT(*) From tblInstrument I INNER JOIN tblRiskAssessment A ON A.InstrumentID = I.InstrumentID
		Where I.InstrumentTypeID = 679 AND I.DisplayFlag = 1 AND I.DECCWSectionID = @SectionId and RiskAssessmentTypeID = 695 and I.InstrumentStatusID = 699)>0)  --699 draft
	Begin
					   --we create a temp table to hold all select rows with maximum enddate of each RiskAssessment
						DECLARE @MyTableTemp TABLE (          
							InstrumentID int,
							MaxEndDate Datetime
						)
					   insert into @MyTableTemp
					   select a.InstrumentID, max(a.EndDate) as MaxEndDate				 
					   from tblEMAssessmentPeriod a inner join tblInstrument b on a.InstrumentID = b.InstrumentID	
					   where b.InstrumentStatusID = 699				   	 	  
					   group by a.InstrumentID 	
					    
						Insert Into #TotalRecords
						(
							TotalRecords,
							RecordType,
							DECCWSectionID,
							InstrumentTypeID,
							GroupID
						)
						SELECT     COUNT(distinct I.InstrumentID) AS TotalRecords, 'EMCs to be Approved' AS RecordType, I.DECCWSectionID, 
								   I.InstrumentTypeID,
								   4			 
						From
							tblInstrument I	
							inner join tblRiskAssessment R ON  I.InstrumentID = R.InstrumentID
							inner join dbo.tblClassification ON R.RiskAssessmentTypeID = dbo.tblClassification.ClassificationID
							inner join @MyTableTemp h on R.InstrumentID = h.InstrumentID     
							inner join tblPOEOLicence L ON R.POEOLicenceIntrumentID = L.InstrumentID
							inner join tblSystemUser RESPONSIBLE ON RESPONSIBLE.SystemUserID = I.ResponsibleSystemUserID	
							inner join tblEMAssessmentPeriod b on R.InstrumentID = b.InstrumentID
							inner join tblReportingPeriod c on R.POEOLicenceIntrumentID = c.InstrumentID and  c.EndDate = h.MaxEndDate
							inner join tblAnnualReturn d on c.ReportingPeriodID = d.ReportingPeriodID
							left outer join tblInstrument e on d.InstrumentID = e.InstrumentID 
							left outer join tblInstrument f on R.InstrumentID = f.InstrumentID 
							left outer join tblInstrument g on R.POEOLicenceIntrumentID = g.InstrumentID                      
							Where
								I.DECCWSectionID = @SectionId
								AND I.InstrumentTypeID = 679 
								AND I.DisplayFlag = 1 
								AND R.RiskAssessmentTypeID = 695 								
								and e.InstrumentStatusID in (17, 20) 				 							 			 										 
						GROUP BY dbo.tblClassification.Name, I.DECCWSectionID, I.InstrumentTypeID

					    delete @MyTableTemp
					  
	End
	ELSE
	Insert Into #TotalRecords
			(
				TotalRecords,
				RecordType,
				DECCWSectionID,
				InstrumentTypeID,
				GroupID
			)
			Select 
				0 As TotalRecords,
				'EMCs to be Approved' AS RecordType,
				@SectionId,
				C.ClassificationID,
				4
			From tblClassification C
			WHERE C.ClassificationID = 695	

	-------------------------------  End of PALMS V7.1 Environmental Management Category ----------------------------------------------
	
	IF((
		Select COUNT(*) From tblInstrument I INNER JOIN tblRiskAssessment A ON A.InstrumentID = I.InstrumentID
		Where I.InstrumentTypeID = 679 AND I.DisplayFlag = 1 AND I.DECCWSectionID = @SectionId and  RiskAssessmentTypeID = 695)>0)
	Begin
		Insert Into #TotalRecords
			(
				TotalRecords,
				RecordType,
				DECCWSectionID,
				InstrumentTypeID,
				GroupID
			)
			SELECT     COUNT(dbo.tblInstrument.InstrumentID) AS TotalRecords, dbo.tblClassification.Name AS RecordType, dbo.tblInstrument.DECCWSectionID, 
						  dbo.tblInstrument.InstrumentTypeID,
						  4
				FROM         dbo.tblInstrument INNER JOIN
								dbo.tblRiskAssessment ON dbo.tblInstrument.InstrumentID = dbo.tblRiskAssessment.InstrumentID INNER JOIN
									  dbo.tblClassification ON dbo.tblRiskAssessment.RiskAssessmentTypeID = dbo.tblClassification.ClassificationID 
				Where DECCWSectionID = @SectionId
							and InstrumentTypeID= 679 and  RiskAssessmentTypeID = 695  ----------  Environmental risk assessment
							and DisplayFlag = 1 and tblInstrument.InstrumentStatusID in (1032, 699)
				GROUP BY dbo.tblClassification.Name, dbo.tblInstrument.DECCWSectionID, dbo.tblInstrument.InstrumentTypeID
	End
	ELSE
	Insert Into #TotalRecords
			(
				TotalRecords,
				RecordType,
				DECCWSectionID,
				InstrumentTypeID,
				GroupID
			)
			Select 
				0 As TotalRecords,
				C.Name AS RecordType,
				@SectionId,
				C.ClassificationID,
				4
			From tblClassification C
			WHERE C.ClassificationID = 695	
	
	
	---Gets Secondary Records---
	IF((Select COUNT(*) From tblInstrument where InstrumentTypeID = 554 AND DECCWSectionID = @SectionId AND DisplayFlag = 1)>0)
	Begin
		Insert Into #TotalRecords
			(
				TotalRecords,
				RecordType,
				DECCWSectionID,
				InstrumentTypeID,
				GroupID
			)
			Select 
				COUNT(*) As TotalRecords,
				NT.TemplateName AS RecordType,
				I.DECCWSectionID,
				I.InstrumentTypeID,
				3
			From tblInstrument I
			Inner Join tblNotice N ON N.InstrumentID = I.InstrumentID
			INNER JOIN tblNoticeTemplate NT ON NT.NoticeTemplateID = N.NoticeTemplateID
			Where I.DECCWSectionID = @SectionId AND I.DisplayFlag = 1 AND I.InstrumentTypeID = 554 AND N.NoticeTemplateID = (select value from tblSystemVariable where SystemVariableID = 18)
			GROUP BY NT.TemplateName, I.DECCWSectionID, I.InstrumentTypeID
			ORDER BY NT.TemplateName
			--Select 
			--	COUNT(*) As TotalRecords,
			--	C.Name AS RecordType,
			--	I.DECCWSectionID,
			--	I.InstrumentTypeID
			--From tblInstrument I
			--Inner Join tblClassification C ON I.InstrumentTypeID = C.ClassificationID
			
			--Where I.DECCWSectionID = @SectionId AND I.DisplayFlag = 1 AND InstrumentTypeID = 554
			--GROUP BY C.Name, I.DECCWSectionID, I.InstrumentTypeID
	END
	ELSE
		Insert Into #TotalRecords
			(
				TotalRecords,
				RecordType,
				DECCWSectionID,
				InstrumentTypeID,
				GroupID
			)
			Select 
				0 As TotalRecords,
				(select templatename from tblnoticetemplate where noticetemplateid = 701) AS RecordType,
				@SectionId,
				C.ClassificationID,
				3
			From tblClassification C
			WHERE C.ClassificationID = 554
			
    -------------------------------  PALMS V5.0 ----------------------------------------------
	--794 Radiation licence accrediation
	IF((
		Select COUNT(*) From tblInstrument I INNER JOIN tblRadiationLicence A ON A.InstrumentID = I.InstrumentID
		Where I.InstrumentTypeID=750 and A.RadiationLicenceTypeID = 794 AND I.DECCWSectionID = @SectionId)>0)
	Begin
		Insert Into #TotalRecords
			(
				TotalRecords,
				RecordType,
				DECCWSectionID,
				InstrumentTypeID,
				GroupID
			)
			SELECT     COUNT(dbo.tblInstrument.InstrumentID) AS TotalRecords, dbo.tblClassification.Name AS RecordType, dbo.tblInstrument.DECCWSectionID, 
						  dbo.tblInstrument.InstrumentTypeID,
						  1
				FROM         dbo.tblInstrument INNER JOIN
								dbo.tblRadiationLicence ON dbo.tblInstrument.InstrumentID = dbo.tblRadiationLicence.InstrumentID INNER JOIN
									  dbo.tblClassification ON dbo.tblRadiationLicence.RadiationLicenceTypeID = dbo.tblClassification.ClassificationID 
				Where DECCWSectionID = @SectionId
							and InstrumentTypeID= 750 and  RadiationLicenceTypeID = 794  ---------- Radiation licence accrediation
							and DisplayFlag = 1
				GROUP BY dbo.tblClassification.Name, dbo.tblInstrument.DECCWSectionID, dbo.tblInstrument.InstrumentTypeID
	End
	ELSE
	Insert Into #TotalRecords
			(
				TotalRecords,
				RecordType,
				DECCWSectionID,
				InstrumentTypeID,
				GroupID
			)
			Select 
				0 As TotalRecords,
				C.Name AS RecordType,
				@SectionId,
				C.ClassificationID,
				1
			From tblClassification C
			WHERE C.ClassificationID = 794	
	
	--795 Radiation licence to use
	IF((
		Select COUNT(*) From tblInstrument I INNER JOIN tblRadiationLicence A ON A.InstrumentID = I.InstrumentID
		Where I.InstrumentTypeID=750 and A.RadiationLicenceTypeID = 795 AND I.DECCWSectionID = @SectionId)>0)
	Begin
		Insert Into #TotalRecords
			(
				TotalRecords,
				RecordType,
				DECCWSectionID,
				InstrumentTypeID,
				GroupID
			)
			SELECT     COUNT(dbo.tblInstrument.InstrumentID) AS TotalRecords, dbo.tblClassification.Name AS RecordType, dbo.tblInstrument.DECCWSectionID, 
						  dbo.tblInstrument.InstrumentTypeID,
						  1
				FROM         dbo.tblInstrument INNER JOIN
								dbo.tblRadiationLicence ON dbo.tblInstrument.InstrumentID = dbo.tblRadiationLicence.InstrumentID INNER JOIN
									  dbo.tblClassification ON dbo.tblRadiationLicence.RadiationLicenceTypeID = dbo.tblClassification.ClassificationID 
				Where DECCWSectionID = @SectionId
							and InstrumentTypeID= 750 and  RadiationLicenceTypeID = 795  ----------  Radiation licence to use
							and DisplayFlag = 1
				GROUP BY dbo.tblClassification.Name, dbo.tblInstrument.DECCWSectionID, dbo.tblInstrument.InstrumentTypeID
	End
	ELSE
	Insert Into #TotalRecords
			(
				TotalRecords,
				RecordType,
				DECCWSectionID,
				InstrumentTypeID,
				GroupID
			)
			Select 
				0 As TotalRecords,
				C.Name AS RecordType,
				@SectionId,
				C.ClassificationID,
				1
			From tblClassification C
			WHERE C.ClassificationID = 795

	IF((
		Select COUNT(*) From tblInstrument I INNER JOIN tblRadiationLicence A ON A.InstrumentID = I.InstrumentID
		Where I.InstrumentTypeID=750 and A.RadiationLicenceTypeID = 795 AND I.DECCWSectionID = @SectionId)>0)
	Begin
		Insert Into #TotalRecords
			(
				TotalRecords,
				RecordType,
				DECCWSectionID,
				InstrumentTypeID,
				GroupID
			)
			SELECT     COUNT(dbo.tblInstrument.InstrumentID) AS TotalRecords, dbo.tblClassification.Name AS RecordType, dbo.tblInstrument.DECCWSectionID, 
						  dbo.tblInstrument.InstrumentTypeID,
						  1
				FROM         dbo.tblInstrument INNER JOIN
								dbo.tblRadiationLicence ON dbo.tblInstrument.InstrumentID = dbo.tblRadiationLicence.InstrumentID INNER JOIN
									  dbo.tblClassification ON dbo.tblRadiationLicence.RadiationLicenceTypeID = dbo.tblClassification.ClassificationID 
				Where DECCWSectionID = @SectionId
							and InstrumentTypeID= 750 and  RadiationLicenceTypeID = 796  ----------  Radiation licence to use
							and DisplayFlag = 1
				GROUP BY dbo.tblClassification.Name, dbo.tblInstrument.DECCWSectionID, dbo.tblInstrument.InstrumentTypeID
	End
	ELSE
	Insert Into #TotalRecords
			(
				TotalRecords,
				RecordType,
				DECCWSectionID,
				InstrumentTypeID,
				GroupID
			)
			Select 
				0 As TotalRecords,
				C.Name AS RecordType,
				@SectionId,
				C.ClassificationID,
				1
			From tblClassification C
			WHERE C.ClassificationID = 796	

	--added in 16-06-2014 Dangerous Goods Licence IntrumentTypeID = 817
		--sub type: Dangerous Goods Driver Licence: DGLicenceTypeID=819
		--          Dangerous Goods Vehicle Licence: DGLicenceTypeID=820
	IF((
		Select COUNT(*) From tblInstrument I INNER JOIN tblDGLicence A ON A.InstrumentID = I.InstrumentID
		Where I.InstrumentTypeID=817 and A.DGLicenceTypeID = 819 AND I.DECCWSectionID = @SectionId)>0)
	Begin
		Insert Into #TotalRecords
			(
				TotalRecords,
				RecordType,
				DECCWSectionID,
				InstrumentTypeID,
				GroupID
			)
			SELECT     COUNT(dbo.tblInstrument.InstrumentID) AS TotalRecords, dbo.tblClassification.Name AS RecordType, dbo.tblInstrument.DECCWSectionID, 
						  dbo.tblInstrument.InstrumentTypeID,
						  1
				FROM         dbo.tblInstrument INNER JOIN
								dbo.tblDGLicence ON dbo.tblInstrument.InstrumentID = dbo.tblDGLicence.InstrumentID INNER JOIN
									  dbo.tblClassification ON dbo.tblDGLicence.DGLicenceTypeID = dbo.tblClassification.ClassificationID 
				Where DECCWSectionID = @SectionId
							and InstrumentTypeID= 817 and  DGLicenceTypeID = 819  ---------- Radiation licence accrediation
							and DisplayFlag = 1
				GROUP BY dbo.tblClassification.Name, dbo.tblInstrument.DECCWSectionID, dbo.tblInstrument.InstrumentTypeID
	End
	ELSE
	Insert Into #TotalRecords
			(
				TotalRecords,
				RecordType,
				DECCWSectionID,
				InstrumentTypeID,
				GroupID
			)
			Select 
				0 As TotalRecords,
				C.Name AS RecordType,
				@SectionId,
				C.ClassificationID,
				1
			From tblClassification C
			WHERE C.ClassificationID = 819	

	IF((
		Select COUNT(*) From tblInstrument I INNER JOIN tblDGLicence A ON A.InstrumentID = I.InstrumentID
		Where I.InstrumentTypeID=817 and A.DGLicenceTypeID = 820 AND I.DECCWSectionID = @SectionId)>0)
	Begin
		Insert Into #TotalRecords
			(
				TotalRecords,
				RecordType,
				DECCWSectionID,
				InstrumentTypeID,
				GroupID
			)
			SELECT     COUNT(dbo.tblInstrument.InstrumentID) AS TotalRecords, dbo.tblClassification.Name AS RecordType, dbo.tblInstrument.DECCWSectionID, 
						  dbo.tblInstrument.InstrumentTypeID,
						  1
				FROM         dbo.tblInstrument INNER JOIN
								dbo.tblDGLicence ON dbo.tblInstrument.InstrumentID = dbo.tblDGLicence.InstrumentID INNER JOIN
									  dbo.tblClassification ON dbo.tblDGLicence.DGLicenceTypeID = dbo.tblClassification.ClassificationID 
				Where DECCWSectionID = @SectionId
							and InstrumentTypeID= 817 and  DGLicenceTypeID = 820  ---------- Radiation licence accrediation
							and DisplayFlag = 1
				GROUP BY dbo.tblClassification.Name, dbo.tblInstrument.DECCWSectionID, dbo.tblInstrument.InstrumentTypeID
	End
	ELSE
	Insert Into #TotalRecords
			(
				TotalRecords,
				RecordType,
				DECCWSectionID,
				InstrumentTypeID,
				GroupID
			)
			Select 
				0 As TotalRecords,
				C.Name AS RecordType,
				@SectionId,
				C.ClassificationID,
				1
			From tblClassification C
			WHERE C.ClassificationID = 820	

						   
	--added in 16-06-2014 Pesticide Licence IntrumentTypeID = 818
	IF((Select COUNT(*) From tblInstrument where InstrumentTypeID = 818 AND DECCWSectionID = @SectionId AND DisplayFlag = 1)>0)
	Begin
		Insert Into #TotalRecords
			(
				TotalRecords,
				RecordType,
				DECCWSectionID,
				InstrumentTypeID,
				GroupID
			)
			Select 
				COUNT(*) As TotalRecords,
				C.Name AS RecordType,
				I.DECCWSectionID,
				I.InstrumentTypeID,
				1
			From tblInstrument I
			Inner Join tblClassification C ON I.InstrumentTypeID = C.ClassificationID
			Where I.DECCWSectionID = @SectionId AND I.DisplayFlag = 1 AND InstrumentTypeID = 818
			GROUP BY C.Name, I.DECCWSectionID, I.InstrumentTypeID
	END
	ELSE
		Insert Into #TotalRecords
			(
				TotalRecords,
				RecordType,
				DECCWSectionID,
				InstrumentTypeID,
				GroupID
			)
			Select 
				0 As TotalRecords,
				C.Name AS RecordType,
				@SectionId,
				C.ClassificationID,
				1
			From tblClassification C
			WHERE C.ClassificationID = 818

   ---------------------------------------------------------
	--added in 24-09-2014 DG Tank Design Approval IntrumentTypeID = 990
	IF((Select COUNT(*) From tblInstrument where InstrumentTypeID = 990 AND DECCWSectionID = @SectionId AND DisplayFlag = 1)>0)
	Begin
		Insert Into #TotalRecords
			(
				TotalRecords,
				RecordType,
				DECCWSectionID,
				InstrumentTypeID,
				GroupID
			)
			Select 
				COUNT(*) As TotalRecords,
				C.Name AS RecordType,
				I.DECCWSectionID,
				I.InstrumentTypeID,
				1
			From tblInstrument I
			Inner Join tblClassification C ON I.InstrumentTypeID = C.ClassificationID
			Where I.DECCWSectionID = @SectionId AND I.DisplayFlag = 1 AND InstrumentTypeID = 990
			GROUP BY C.Name, I.DECCWSectionID, I.InstrumentTypeID
	END
	ELSE
		Insert Into #TotalRecords
			(
				TotalRecords,
				RecordType,
				DECCWSectionID,
				InstrumentTypeID,
				GroupID
			)
			Select 
				0 As TotalRecords,
				C.Name AS RecordType,
				@SectionId,
				C.ClassificationID,
				1
			From tblClassification C
			WHERE C.ClassificationID = 990

   -------------------------------END  PALMS V5.0 ----------------------------------------------	
	
	
	
	
--*********************** start PALMS V8.0 ********************************************************************************************
	declare @FinalInspection table
	( 
		InstrumentID int null,
		NextInspectionDueDate datetime null
	)

	DECLARE @MyTable TABLE
	(
	SNo int IDENTITY(1,1), 
	LicenceNo int 
	)    
	INSERT INTO @MyTable(LicenceNo)	    
	select distinct d.InstrumentID as LicenceNo 
	from tblNotice a inner join tblInstrument b on a.InstrumentID = b.InstrumentID 
	inner join tblNotice c on a.InstrumentID = c.InstrumentID
	inner join tblInstrumentNotice d on c.InstrumentID = d.NoticeInstrumentID
	where a.NoticeTemplateID = 532 and b.InstrumentStatusID in (11, 12) 
	and d.InstrumentID in (select InstrumentID from tblPOEOLicenceEnvironmentalRiskLevel where EnvironmentalRiskLevelID in (713, 714, 715))

    declare @Cnt int
    SELECT @Cnt = MIN(Sno) FROM @MyTable
	
	declare @TempLicenceNo int
	declare @TempNextInspectionDueDate date 

	WHILE (1=1)
	BEGIN
   
	SELECT @TempLicenceNo = LicenceNo FROM @MyTable WHERE SNo = @Cnt
	    
	IF @@ROWCOUNT = 0
		BREAK

		if @TempLicenceNo > 0
		begin
			 
			  declare @MyTableInspectionLBL table
			  (				 
				NextInspectionDueDate datetime null 
			  )

			  insert into @MyTableInspectionLBL			
			  exec [uspGetPOEORBLInspectionData] @TempLicenceNo, 1
 			  
			  select @TempNextInspectionDueDate = NextInspectionDueDate	from @MyTableInspectionLBL 

			  insert into @FinalInspection(InstrumentID, NextInspectionDueDate)
			  select @TempLicenceNo as InstrumentID, @TempNextInspectionDueDate as NextInspectionDueDate 

			  delete @MyTableInspectionLBL
		end
	 
	SELECT @Cnt = @Cnt + 1
		
	END
	delete @MyTable

	--select InstrumentID, NextInspectionDueDate, DateDIFF(DAY,GETDATE(), NextInspectionDueDate) as DateDue  from @FinalInspection
	--where DateDIFF(DAY,GETDATE(), NextInspectionDueDate) < 0		
		
	declare @TotalInspection int = 0
	Select 
	    @TotalInspection = COUNT(I.InstrumentID)
	From
		@FinalInspection a
		inner join tblInstrument I ON a.InstrumentID = I.InstrumentID
		inner Join tblPOEOLicence p ON p.InstrumentID = I.InstrumentID 
    WHERE  DateDIFF(DAY,GETDATE(), a.NextInspectionDueDate) < 0 AND I.InstrumentStatusID = 3 and I.InstrumentTypeID = 493 and I.DECCWSectionID = @SectionId		 
	 
	
---------------------- INSPECTION OVERDUE  --------------------------------	
	Insert Into #TotalRecords
			(
				TotalRecords,
				RecordType,
				DECCWSectionID,
				InstrumentTypeID,
				GroupID
			)
			Select 
				@TotalInspection As TotalRecords,
				'Inspection overdue' AS RecordType,
				@SectionId,
				-10000,
				5

---------------------- INSPECTION DUE IN 1 MONTH --------------------------
	Select @TotalInspection = 0	
	Select 
	    @TotalInspection = COUNT(I.InstrumentID)
	From
		@FinalInspection a
		inner join tblInstrument I ON a.InstrumentID = I.InstrumentID
		inner Join tblPOEOLicence p ON p.InstrumentID = I.InstrumentID 
    WHERE  DateDIFF(DAY,GETDATE(), a.NextInspectionDueDate) <= 30 AND I.InstrumentStatusID = 3 and I.InstrumentTypeID = 493 and I.DECCWSectionID = @SectionId	
	AND (DateDIFF(DAY,GETDATE(),a.NextInspectionDueDate) > = 0)

	Insert Into #TotalRecords
			(
				TotalRecords,
				RecordType,
				DECCWSectionID,
				InstrumentTypeID,
				GroupID
			)
			Select 
				@TotalInspection As TotalRecords,
				'Inspection due within 1 month' AS RecordType,
				@SectionId,
				-10,
				5
---------------------- INSPECTION DUE IN 1 to 6 MONTHS --------------------
    Select @TotalInspection = 0	
	Select 
	    @TotalInspection = COUNT(I.InstrumentID)
	From
		@FinalInspection a
		inner join tblInstrument I ON a.InstrumentID = I.InstrumentID
		inner Join tblPOEOLicence p ON p.InstrumentID = I.InstrumentID 
    WHERE  (DateDIFF(DAY,GETDATE(), a.NextInspectionDueDate) > 30 AND DateDIFF(DAY,GETDATE(), a.NextInspectionDueDate) <= 182) AND I.InstrumentStatusID = 3 and I.InstrumentTypeID = 493 and I.DECCWSectionID = @SectionId	

	Insert Into #TotalRecords
			(
				TotalRecords,
				RecordType,
				DECCWSectionID,
				InstrumentTypeID,
				GroupID
			)
			Select 
				@TotalInspection As TotalRecords,
				'Inspection due in 1 to 6 months' AS RecordType,
				@SectionId,
				-60,
				5
---------------------- INSPECTION DUE IN 6 to 12 MONTHS -------------------    
    Select @TotalInspection = 0	
	Select 
	    @TotalInspection = COUNT(I.InstrumentID)
	From
		@FinalInspection a
		inner join tblInstrument I ON a.InstrumentID = I.InstrumentID
		inner Join tblPOEOLicence p ON p.InstrumentID = I.InstrumentID 
    WHERE  (DateDIFF(DAY,GETDATE(), a.NextInspectionDueDate) > 182 AND DateDIFF(DAY,GETDATE(), a.NextInspectionDueDate) < 364) AND I.InstrumentStatusID = 3 and I.InstrumentTypeID = 493 and I.DECCWSectionID = @SectionId	

	Insert Into #TotalRecords
			(
				TotalRecords,
				RecordType,
				DECCWSectionID,
				InstrumentTypeID,
				GroupID
			)
			Select 
				@TotalInspection As TotalRecords,
				'Inspection due 6 to 12 months' AS RecordType,
				@SectionId,
				-120,
				5

	delete @FinalInspection
--*********************** end of PALMS V8.0 ******************************************************************************************** 
	
	
	
	
	-------------- PALMS V3.0 ---------------------
	
	DECLARE @TotalReview INT = 0
	
	
	---------------------- REVIEW OVERDUE  -------------------	
	Select 
			@TotalReview = COUNT(I.InstrumentID)
	From
		tblInstrument I
		Inner Join tblPOEOLicence p ON p.InstrumentID = I.InstrumentID AND p.LowRiskFlag =0 
		AND (DateDIFF(DAY,GETDATE(),p.ReviewDueDate)<0)
	Where
		I.DECCWSectionID   = @SectionId and I.InstrumentTypeID = 493 AND I.InstrumentStatusID = 3
		
	
	Insert Into #TotalRecords
			(
				TotalRecords,
				RecordType,
				DECCWSectionID,
				InstrumentTypeID,
				GroupID
			)
			Select 
				@TotalReview As TotalRecords,
				'Licence review overdue' AS RecordType,
				@SectionId,
				-1000,
				1
	
	---------------------- REVIEW DUE IN 1 MONTH -------------------	
	Select @TotalReview = 0	
	Select 
			@TotalReview = COUNT(I.InstrumentID)
	From
		tblInstrument I
		Inner Join tblPOEOLicence p ON p.InstrumentID = I.InstrumentID AND p.LowRiskFlag =0 
		AND (DateDIFF(DAY,GETDATE(),p.ReviewDueDate)<=30 AND DateDIFF(DAY,GETDATE(),p.ReviewDueDate)>= 0)
	Where
		I.DECCWSectionID   = @SectionId and I.InstrumentTypeID = 493 AND I.InstrumentStatusID = 3
		
	
	Insert Into #TotalRecords
			(
				TotalRecords,
				RecordType,
				DECCWSectionID,
				InstrumentTypeID,
				GroupID
			)
			Select 
				@TotalReview As TotalRecords,
				'Licence review due within 1 month' AS RecordType,
				@SectionId,
				-1,
				1
	
	---------------------- REVIEW DUE IN 1 to 6 MONTHS -------------------	
	Select @TotalReview = 0	
	Select 
			@TotalReview = COUNT(I.InstrumentID)
	From
		tblInstrument I
		Inner Join tblPOEOLicence p ON p.InstrumentID = I.InstrumentID AND p.LowRiskFlag =0 
		AND (DateDIFF(DAY,GETDATE(),p.ReviewDueDate)<=182 AND DateDIFF(DAY,GETDATE(),p.ReviewDueDate)> 30)
	Where
		I.DECCWSectionID   = @SectionId and I.InstrumentTypeID = 493 AND I.InstrumentStatusID = 3
			
			Insert Into #TotalRecords
			(
				TotalRecords,
				RecordType,
				DECCWSectionID,
				InstrumentTypeID,
				GroupID
			)
			Select 
				@TotalReview As TotalRecords,
				'Licence review due in 1 to 6 months' AS RecordType,
				@SectionId,
				-6,
				1
				
	---------------------- REVIEW DUE IN 6 to 12 MONTHS -------------------	
	Select @TotalReview = 0		
	Select 
			@TotalReview = COUNT(I.InstrumentID)
	From
		tblInstrument I
		Inner Join tblPOEOLicence p ON p.InstrumentID = I.InstrumentID AND p.LowRiskFlag =0 
		AND (DateDIFF(DAY,GETDATE(),p.ReviewDueDate)<=364 AND DateDIFF(DAY,GETDATE(),p.ReviewDueDate)> 182)
	Where
		I.DECCWSectionID   = @SectionId and I.InstrumentTypeID = 493 AND I.InstrumentStatusID = 3		
			Insert Into #TotalRecords
			(
				TotalRecords,
				RecordType,
				DECCWSectionID,
				InstrumentTypeID,
				GroupID
			)
			Select 
				@TotalReview As TotalRecords,
				'Licence review due in 6 to 12 months' AS RecordType,
				@SectionId,
				-12,
				1
			
	--------------- end of PALMS V3.0 ----------------		
	
	


	-------------- PALMS V5.1       ---------------------
	
	DECLARE @TotalPRP INT = 0
	
	
	----------------------   OVERDUE  -------------------	
	Select 
			@TotalPRP = COUNT(I.InstrumentID)
	From
		tblInstrument I
		Inner Join tblPOEOLicencePRP p ON p.InstrumentID = I.InstrumentID 
		AND (DateDIFF(DAY,GETDATE(),p.ProposedEndDate)<0)
	Where
		I.DECCWSectionID   = @SectionId and I.InstrumentTypeID = 493 AND I.InstrumentStatusID = 3 and p.CompletedDate is null and p.CancelledFlag = 0
		
	
	Insert Into #TotalRecords
			(
				TotalRecords,
				RecordType,
				DECCWSectionID,
				InstrumentTypeID,
				GroupID
			)
			Select 
				@TotalPRP As TotalRecords,
				'Program review overdue' AS RecordType,
				@SectionId,
				-100,
				1

	----------------------    DUE IN 1 MONTH -------------------	
	Select @TotalPRP = 0	
	Select 
			@TotalPRP = COUNT(I.InstrumentID)
	From
		tblInstrument I
		Inner Join tblPOEOLicencePRP p ON p.InstrumentID = I.InstrumentID 
		AND (DateDIFF(DAY,GETDATE(),p.ProposedEndDate)<=30 AND DateDIFF(DAY,GETDATE(),p.ProposedEndDate)>= 0)
	Where
		I.DECCWSectionID   = @SectionId and I.InstrumentTypeID = 493 AND I.InstrumentStatusID = 3 and p.CompletedDate is null and p.CancelledFlag = 0
		
	
	Insert Into #TotalRecords
			(
				TotalRecords,
				RecordType,
				DECCWSectionID,
				InstrumentTypeID,
				GroupID
			)
			Select 
				@TotalPRP As TotalRecords,
				'Program review due within 1 month' AS RecordType,
				@SectionId,
				-101,
				1
	
	----------------------    DUE IN 6 MONTHS -------------------	
	Select @TotalPRP = 0	
	Select 
			@TotalPRP = COUNT(I.InstrumentID)
	From
		tblInstrument I
		Inner Join tblPOEOLicencePRP p ON p.InstrumentID = I.InstrumentID 
		AND (DateDIFF(DAY,GETDATE(),p.ProposedEndDate)<=182 AND DateDIFF(DAY,GETDATE(),p.ProposedEndDate)> 30)

	Where
		I.DECCWSectionID   = @SectionId and I.InstrumentTypeID = 493 AND I.InstrumentStatusID = 3 and p.CompletedDate is null and p.CancelledFlag = 0
			
			Insert Into #TotalRecords
			(
				TotalRecords,
				RecordType,
				DECCWSectionID,
				InstrumentTypeID,
				GroupID
			)
			Select 
				@TotalPRP As TotalRecords,
				'Program review due in 1 to 6 months' AS RecordType,
				@SectionId,
				-102,
				1


		------------ END OF PROBRAM DUE --------------------------


	
	
	---Gets Secondary Records---
	IF((Select COUNT(*) From tblInstrument where InstrumentTypeID = 554 AND DECCWSectionID = @SectionId AND DisplayFlag = 1)>0)
	Begin
		Insert Into #TotalRecords
			(
				TotalRecords,
				RecordType,
				DECCWSectionID,
				InstrumentTypeID,
				GroupID
			)
			Select 
				COUNT(*) As TotalRecords,
				NT.TemplateName AS RecordType,
				I.DECCWSectionID,
				I.InstrumentTypeID,
				3
			From tblInstrument I
			Inner Join tblNotice N ON N.InstrumentID = I.InstrumentID
			INNER JOIN tblNoticeTemplate NT ON NT.NoticeTemplateID = N.NoticeTemplateID
			Where I.DECCWSectionID = @SectionId AND I.DisplayFlag = 1 AND I.InstrumentTypeID = 554 AND N.NoticeTemplateID <> 701
			GROUP BY NT.TemplateName, I.DECCWSectionID, I.InstrumentTypeID
			ORDER BY NT.TemplateName
			--Select 
			--	COUNT(*) As TotalRecords,
			--	C.Name AS RecordType,
			--	I.DECCWSectionID,
			--	I.InstrumentTypeID
			--From tblInstrument I
			--Inner Join tblClassification C ON I.InstrumentTypeID = C.ClassificationID
			
			--Where I.DECCWSectionID = @SectionId AND I.DisplayFlag = 1 AND InstrumentTypeID = 554
			--GROUP BY C.Name, I.DECCWSectionID, I.InstrumentTypeID
	END
	ELSE
		Insert Into #TotalRecords
			(
				TotalRecords,
				RecordType,
				DECCWSectionID,
				InstrumentTypeID,
				GroupID
			)
			Select 
				0 As TotalRecords,
				C.Name AS RecordType,
				@SectionId,
				C.ClassificationID,
				3
			From tblClassification C
			WHERE C.ClassificationID = 554
				
	Select @TotalAlerts = COUNT(*) from tblUserAlert
		Inner Join tblSystemUser S On S.SystemUserID = tblUserAlert.SystemUserID
		Inner Join tblInstrument ON tblInstrument.InstrumentID = tblUserAlert.InstrumentID
	Where S.DECCWSectionID = @SectionId
	
	Select @TotalNotifications = COUNT(*) from tblUserNotification
		Inner Join tblSystemUser S On S.SystemUserID = tblUserNotification.SystemUserID
		Inner Join tblInstrument ON tblInstrument.InstrumentID = tblUserNotification.InstrumentID
	Where S.DECCWSectionID = @SectionId
	
	Insert Into #TotalRecords
		(
			TotalRecords,
			RecordType,
			DECCWSectionID,
			InstrumentTypeID,
			GroupID
		)
		Values
		(
			@TotalAlerts + @TotalNotifications,
			'Messages',
			@SectionId,
			1,
			6
		)
		
	Select * from #TotalRecords where TotalRecords > 0
	
	Drop Table #TotalRecords	