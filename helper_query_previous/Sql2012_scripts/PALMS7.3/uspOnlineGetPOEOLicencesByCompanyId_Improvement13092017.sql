declare @profileId int = 1871

SET NOCOUNT ON;
    DECLARE @companyId INT;

	DECLARE @companies TABLE(
								AccountablePartyId INT, 	
								AccountableParty VARCHAR(200), 
								Location NVARCHAR(300)
	                        );

	DECLARE @DateToday AS DATE = GETDATE();

	DECLARE @licences TABLE(
								AppId INT,
								HasAR BIT,
								AccountablePartyId INT, 
								InstrumentID INT,
								RecordType NVARCHAR(35),
								RecordStatus NVARCHAR(50),
								RecordMessage NVARCHAR(200),
								DueDate DATE,
								DaysRemaining NVARCHAR(15),
								StartDate DATE,
								EndDate DATE,
								ReportingPeriodID INT,
								AppNumber VARCHAR(12),
								ResponsibleUser VARCHAR(40)   ,
								ReportingPeriod VARCHAR(40)  -----------new
							);

	DECLARE @acclicences TABLE(
								AccountablePartyId INT null,
								LicenceNumber INT null,	
								LicenceType 		NVARCHAR(50) null,					 
								[Status] NVARCHAR(255) null,
								Location NVARCHAR(255) null,
								Suburb NVARCHAR(50)	null,
								ActiveVariationAppFlag BIT null,
								ActiveSurrenderAppFlag BIT null,
								ActiveVariationFromPALMSFlag BIT null,
								ActiveSurrenderFromPALMSFlag BIT null,
								ApplicationTypeId INT null,
								ProfileId INT null,
								LicenceTypeID INT null						    
							);

	DECLARE @actapplications TABLE(
								AccountablePartyId INT null,
								LicenceNumber INT null,	
								ApplicationNumber NVARCHAR(50) null,
								ApplicationType NVARCHAR(255) null,								 
								[Status] NVARCHAR(255) null,
								Location NVARCHAR(255) null,
								Suburb NVARCHAR(50)	null,
								ActiveVariationAppFlag BIT null,
								ActiveSurrenderAppFlag BIT null,
								ActiveVariationFromPALMSFlag BIT null,
								ActiveSurrenderFromPALMSFlag BIT null,
								ResponsibleUser NVARCHAR(50) null,
								AppId  INT null,
								LicenceTypeID  INT null 							    
							);

    --start added on 06-09-2017 for Radiation licence renewal records
	DECLARE @actrenewal TABLE(
								AccountablePartyId INT null,
								InstrumentID INT null,	
								LicenceType 		NVARCHAR(50) null,					 
								ExpiryDate DATETIME null,
								RecordStatus NVARCHAR(255) null,
								DaysRemaining INT null,
								RenewalNo INT null,
								CompanyFlag BIT null							    
							);
    --end added on 06-09-2017 for Radiation licence renewal records

    INSERT INTO @companies(
							AccountablePartyId,
							AccountableParty,
							Location
							)
	SELECT ua.AccountablePartyID, 
			CASE WHEN ap.CompanyFlag = 0 THEN
					ap.GivenName + ' ' + ap.Surname ELSE ap.OrganisationName END AS OrganisationName, 
			a.[Address] + ',' + a.Suburb + ',' + a.Postcode + ',' + a.StateCode
	FROM tblOnlineUserAccess ua
	INNER JOIN tblAccountableParty ap ON ap.AccountablePartyID= ua.AccountablePartyID
	LEFT OUTER JOIN tblAddress a ON a.AddressID=ap.AddressID
	WHERE ProfileID=@profileId;

	--select * from @companies

	--start loop through @companies
	DECLARE @MyTable TABLE
		(
		SNo int IDENTITY(1,1), 
		AccountablePartyId int	 
		)    
	INSERT INTO @MyTable(AccountablePartyId)	    
	SELECT AccountablePartyId
	FROM @companies

	declare @Cnt int
	SELECT @Cnt = MIN(Sno) FROM @MyTable	
	 
	WHILE (1=1)
	BEGIN
   
	SELECT @companyId = AccountablePartyId FROM @MyTable
	WHERE SNo = @Cnt
	    
	IF @@ROWCOUNT = 0
		BREAK

		if exists(select * from @companies where cast(AccountablePartyId as varchar) = cast(@companyId as varchar))
		begin
		    print '---------------------------------------------'	   
			print '@companyId =' + cast(@companyId as varchar)			 
			print '---------------------------------------------'	 
			INSERT INTO @licences(
								InstrumentID,	
								RecordType,
								RecordStatus,
						   		RecordMessage,	
								DueDate,	
								DaysRemaining,	
								StartDate,
								EndDate,
								ReportingPeriodID
							 )
			EXEC usponlinegetcustomerinbox @companyId;
	   
			UPDATE @licences
			SET  AccountablePartyId=  @companyId ,
				 HasAR = CAST(0 AS BIT),
				 RecordType='Annual Return'
			WHERE AccountablePartyId IS NULL; 

			INSERT INTO @licences(
									AppId,
									HasAr,
									InstrumentID,	
									RecordType,
									RecordStatus,
									ReportingPeriodID,
									AccountablePartyId,
									AppNumber,
									DueDate,
									DaysRemaining,
									ResponsibleUser
								 )
			SELECT	ar.AnnualReturnAppID,
					1,
					ar.InstrumentID,
					'Annual Return',
					c.Name,
					ar.ReportingPeriodID,
					@companyId,
					ar.AnnualReturnAppNumber,
					rp.DueDate,
					(CASE WHEN ar.ApplicationStatusID =  1182 THEN '' ELSE
						(CASE WHEN DATEDIFF(day,@DateToday,DueDate ) < 0  
							THEN 'Overdue ' + CAST(DATEDIFF(day,DueDate,@DateToday ) AS VARCHAR(20)) 
							ELSE CAST(DATEDIFF(day,@DateToday,DueDate ) AS VARCHAR(20))	END) 
							
						END	) AS DaysRemaining,
					p.FirstName+' '+p.LastName	 
			FROM tblOnlineAnnualReturnApplication ar
			LEFT OUTER JOIN tblClassification c ON c.ClassificationID = ar.ApplicationStatusID
			LEFT OUTER JOIN tblReportingPeriod rp ON rp.ReportingPeriodID = ar.ReportingPeriodID
			LEFT OUTER JOIN vwProfile p ON p.ProfileID = ar.CreatedBySystemUserID
			WHERE ar.AccountablePartyID = @companyId;


			------------- add one more field 			
			UPDATE @licences 
			SET ReportingPeriod = CONVERT(VARCHAR(10), B.StartDate, 103) + ' - '+ CONVERT(VARCHAR(10), B.EndDate, 103) 			
			From @licences AS a
				JOIN tblReportingPeriod AS b ON a.ReportingPeriodID = b.ReportingPeriodID 
						
			--added by Eric He 15-03-2017 to fetch licences under current accountablepartyID
			INSERT INTO @acclicences(			                        
								LicenceNumber,	
								LicenceType,							 
								[Status],
								Location,
								Suburb,
								ActiveVariationAppFlag,
								ActiveSurrenderAppFlag,
								ActiveVariationFromPALMSFlag,
								ActiveSurrenderFromPALMSFlag,
								LicenceTypeID 							 
							 )
			exec uspOnlineGetCustomerActiveLicence @companyId;
			update @acclicences set AccountablePartyId = @companyId, ApplicationTypeId = 0, ProfileId= 0 where AccountablePartyId is null
			--end added by Eric He 



			--------------- RML -----------------

			INSERT INTO @acclicences(			                        
								LicenceNumber,		
								LicenceType,						 
								[Status],
								Location,
								Suburb,
								ActiveVariationAppFlag,
								ActiveSurrenderAppFlag,
								ActiveVariationFromPALMSFlag,
								ActiveSurrenderFromPALMSFlag,
								LicenceTypeID 								 
							 )
			exec uspOnlineGetCustomerActiveRMLLicence @companyId;
			update @acclicences set AccountablePartyId = @companyId, ApplicationTypeId = 0, ProfileId= 0 where AccountablePartyId is null

			----------------------------------------------------

			--added by Eric He 24-03-2017 to fetch change applications (licences) including surrender and variation under current accountablepartyID
			INSERT INTO @actapplications(			                        
								LicenceNumber,	
								ApplicationNumber,
								ApplicationType,								 
								[Status],
								Location,
								Suburb, 
								ResponsibleUser,
								AppId,
								LicenceTypeID
							 )
			exec uspOnlineGetCustomerActiveApplication @companyId;
			update @actapplications set AccountablePartyId = @companyId where AccountablePartyId is null
			--end added by Eric He 

			--start added on 06-09-2017 to fetch Radiation licence renewal records
			INSERT INTO @actrenewal(										 
										InstrumentID,	
										LicenceType,					 
										ExpiryDate,
										RecordStatus,
										DaysRemaining,
										RenewalNo,
										CompanyFlag							    
									)
			exec [uspOnlineGetCustomerLicenceRenewal] @companyId;
			update @actrenewal set AccountablePartyId = @companyId where AccountablePartyId is null
			--end added on 06-09-2017 to fetch Radiation licence renewal records
			-----------------------------			  
		end
 		
	SELECT @Cnt = @Cnt + 1
		
	END

	--end loop through @companies

	--DECLARE db_cursor CURSOR FOR SELECT AccountablePartyId FROM @companies 
	--OPEN db_cursor   
	--	FETCH NEXT FROM db_cursor INTO @companyId WHILE @@FETCH_STATUS = 0   
	--	BEGIN  
	--		INSERT INTO @licences(
	--							InstrumentID,	
	--							RecordType,
	--							RecordStatus,
	--					   		RecordMessage,	
	--							DueDate,	
	--							DaysRemaining,	
	--							StartDate,
	--							EndDate,
	--							ReportingPeriodID
	--						 )
	--		EXEC usponlinegetcustomerinbox @companyId;
	   
	--		UPDATE @licences
	--		SET  AccountablePartyId=  @companyId ,
	--			 HasAR = CAST(0 AS BIT),
	--			 RecordType='Annual Return'
	--		WHERE AccountablePartyId IS NULL; 

	--		INSERT INTO @licences(
	--								AppId,
	--								HasAr,
	--								InstrumentID,	
	--								RecordType,
	--								RecordStatus,
	--								ReportingPeriodID,
	--								AccountablePartyId,
	--								AppNumber,
	--								DueDate,
	--								DaysRemaining,
	--								ResponsibleUser
	--							 )
	--		SELECT	ar.AnnualReturnAppID,
	--				1,
	--				ar.InstrumentID,
	--				'Annual Return',
	--				c.Name,
	--				ar.ReportingPeriodID,
	--				@companyId,
	--				ar.AnnualReturnAppNumber,
	--				rp.DueDate,
	--				(CASE WHEN ar.ApplicationStatusID =  1182 THEN '' ELSE
	--					(CASE WHEN DATEDIFF(day,@DateToday,DueDate ) < 0  
	--						THEN 'Overdue ' + CAST(DATEDIFF(day,DueDate,@DateToday ) AS VARCHAR(20)) 
	--						ELSE CAST(DATEDIFF(day,@DateToday,DueDate ) AS VARCHAR(20))	END) 
							
	--					END	) AS DaysRemaining,
	--				p.FirstName+' '+p.LastName	 
	--		FROM tblOnlineAnnualReturnApplication ar
	--		LEFT OUTER JOIN tblClassification c ON c.ClassificationID = ar.ApplicationStatusID
	--		LEFT OUTER JOIN tblReportingPeriod rp ON rp.ReportingPeriodID = ar.ReportingPeriodID
	--		LEFT OUTER JOIN vwProfile p ON p.ProfileID = ar.CreatedBySystemUserID
	--		WHERE ar.AccountablePartyID = @companyId;


	--		------------- add one more field 
			

	--		UPDATE @licences 
	--		SET ReportingPeriod = CONVERT(VARCHAR(10), B.StartDate, 103) + ' - '+ CONVERT(VARCHAR(10), B.EndDate, 103) 

			
	--		From @licences AS a
	--			JOIN tblReportingPeriod AS b ON a.ReportingPeriodID = b.ReportingPeriodID 
		

	--		-----------------------------



	--		--added by Eric He 15-03-2017 to fetch licences under current accountablepartyID
	--		INSERT INTO @acclicences(			                        
	--							LicenceNumber,	
	--							LicenceType,							 
	--							[Status],
	--							Location,
	--							Suburb,
	--							ActiveVariationAppFlag,
	--							ActiveSurrenderAppFlag,
	--							ActiveVariationFromPALMSFlag,
	--							ActiveSurrenderFromPALMSFlag,
	--							LicenceTypeID 							 
	--						 )
	--		exec uspOnlineGetCustomerActiveLicence @companyId;
	--		update @acclicences set AccountablePartyId = @companyId, ApplicationTypeId = 0, ProfileId= 0 where AccountablePartyId is null
	--		--end added by Eric He 



	--		--------------- RML -----------------

	--			INSERT INTO @acclicences(			                        
	--							LicenceNumber,		
	--							LicenceType,						 
	--							[Status],
	--							Location,
	--							Suburb,
	--							ActiveVariationAppFlag,
	--							ActiveSurrenderAppFlag,
	--							ActiveVariationFromPALMSFlag,
	--							ActiveSurrenderFromPALMSFlag,
	--							LicenceTypeID 								 
	--						 )
	--		exec uspOnlineGetCustomerActiveRMLLicence @companyId;
	--		update @acclicences set AccountablePartyId = @companyId, ApplicationTypeId = 0, ProfileId= 0 where AccountablePartyId is null

	--		----------------------------------------------------

	--		--added by Eric He 24-03-2017 to fetch change applications (licences) including surrender and variation under current accountablepartyID
	--		INSERT INTO @actapplications(			                        
	--							LicenceNumber,	
	--							ApplicationNumber,
	--							ApplicationType,								 
	--							[Status],
	--							Location,
	--							Suburb, 
	--							ResponsibleUser,
	--							AppId,
	--							LicenceTypeID
	--						 )
	--		exec uspOnlineGetCustomerActiveApplication @companyId;
	--		update @actapplications set AccountablePartyId = @companyId where AccountablePartyId is null
	--		--end added by Eric He 

	--		--start added on 06-09-2017 to fetch Radiation licence renewal records
	--		INSERT INTO @actrenewal(										 
	--									InstrumentID,	
	--									LicenceType,					 
	--									ExpiryDate,
	--									RecordStatus,
	--									DaysRemaining,
	--									RenewalNo,
	--									CompanyFlag							    
	--								)
	--		exec [uspOnlineGetCustomerLicenceRenewal] @companyId;
	--		update @actrenewal set AccountablePartyId = @companyId where AccountablePartyId is null
	--		--end added on 06-09-2017 to fetch Radiation licence renewal records

	--		FETCH NEXT FROM db_cursor INTO @companyId;
	--	END
	
	--CLOSE db_cursor;   
	--DEALLOCATE db_cursor;
    
	SELECT * FROM @companies;	
    SELECT *, (case RecordStatus when 'Submitted' then 'View' else 'Update' end) as ButtonText FROM @licences;
	SELECT *, (case [Status] when 'Submitted' then 'View' 
	                         when 'Withdrawn' then 'View'
							 else 'Update' end) as ButtonText FROM @acclicences;
	SELECT *, (case [Status] when 'Submitted' then 'View' 
	                         when 'Withdrawn' then 'View'
							 else 'Update' end) as ButtonText FROM @actapplications;

	SELECT *, (case RecordStatus when 'Due' then 'Create' 	                        
							 else 'Update' end) as ButtonText FROM @actrenewal;