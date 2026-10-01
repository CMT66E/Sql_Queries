declare @AnnualReturnNo int = 87746
declare @OutLicenceNo varchar(20)  = 0
declare @OutCurrentEMCID varchar(20)  = 0 


     			DECLARE @POEOLicenceIntrumentID INT = 0

			--1. we get its correspondent licence number
			select top 1 @POEOLicenceIntrumentID = b.InstrumentID from tblAnnualReturn a inner join tblReportingPeriod b on a.ReportingPeriodID = b.ReportingPeriodID
            where a.InstrumentID = @AnnualReturnNo

			select @OutLicenceNo = @POEOLicenceIntrumentID
			
			DECLARE @MyTableTemp TABLE (          
				InstrumentID int,
				MaxEndDate Datetime, 
				DateIssued DateTime,
				InstrumentStatusID int
			)

			 -------------- 699 Draft | 1032 Pending
			 -------------- 700: Complete | 1033 : Complete Late | 1034: Complete Without AR | 1650:Auto-Complete	
			insert into @MyTableTemp
			select a.InstrumentID, max(a.EndDate) as MaxEndDate, b.DateIssued, b.InstrumentStatusID				 
			from tblEMAssessmentPeriod a inner join tblInstrument b on a.InstrumentID = b.InstrumentID
			inner join tblRiskAssessment c on b.InstrumentID = c.InstrumentID
			where 
			--b.InstrumentStatusID in(700, 1033, 1034, 1650)       
			--and 
			c.POEOLicenceIntrumentID = @POEOLicenceIntrumentID 			   	 	  
			group by a.InstrumentID, b.DateIssued, b.InstrumentStatusID 
			order by  b.DateIssued desc	

		 
			--2. Find previous Environmental management category record Id
			declare @PreviousEMCId int = 0
			select top 1 @PreviousEMCId = InstrumentID from @MyTableTemp where InstrumentStatusID = 700

			declare @CurrentEMCId int = 0
			select top 1 @CurrentEMCId = InstrumentID from @MyTableTemp 
			where InstrumentStatusID in (699, 1032)
			order by DateIssued asc

			print '@PreviousEMCId = ' + cast(@PreviousEMCId as varchar)
			print '@CurrentEMCId = ' + cast(@CurrentEMCId as varchar)
			select EnvironmentalManagementCategoryID  from [tblRiskAssessment] where [InstrumentID] = 4001359
			print '-------------------------------------------------------------------------'
			If @PreviousEMCId > 0 and @CurrentEMCId > 0
			begin
			    --We check this previous Environmental management category record 
				--a. has an exisitng EMC category A
				declare @IsPreviousCategoryA bit = 0
				if exists(select EnvironmentalManagementCategoryID  from [tblRiskAssessment] where [InstrumentID] = @PreviousEMCId and EnvironmentalManagementCategoryID = 705)
				   set @IsPreviousCategoryA = 1

				--b. Risk level is 1
				declare @IsPreviousLevelOne bit = 0
				if exists(select EnvironmentalRiskLevelID from tblPOEOLicenceEnvironmentalRiskLevel where EMAInstrumentID = @PreviousEMCId and EnvironmentalRiskLevelID = 713)
				   set @IsPreviousLevelOne = 1

				--c. Draft EMC is also in category A
				declare @IsCurrentCategoryA bit = 0
				if exists(select EnvironmentalManagementCategoryID  from [tblRiskAssessment] where [InstrumentID] = @CurrentEMCId and EnvironmentalManagementCategoryID = 705)
				   set @IsCurrentCategoryA = 1
 
				if @IsPreviousCategoryA = 1 and @IsPreviousLevelOne = 1 and @IsCurrentCategoryA = 1
				begin
				   --we can set curent EMC record from its Draft status 699 directly into 1650 AutoComplete
				   --update tblInstrument set InstrumentStatusID = 1650 where InstrumentID = @CurrentEMCId
				   select @OutLicenceNo = @POEOLicenceIntrumentID
				   select @OutCurrentEMCID = @CurrentEMCId 
				end
				else
				begin				   
				   select @OutCurrentEMCID = 0
				end
			end 
            
			print '@OutLicenceNo = ' + cast(@OutLicenceNo as varchar)
			print '@OutCurrentEMCID = ' + cast(@OutCurrentEMCID as varchar)
			delete @MyTableTemp