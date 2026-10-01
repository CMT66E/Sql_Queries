     declare @EmergencyPhone     VARCHAR(50)
	 declare @TitleCode          VARCHAR(20)
	 declare @GivenName          VARCHAR(50)
	 declare @Surname            VARCHAR(50)
	 declare @PhoneNumber        VARCHAR(50)
	 declare @MobileNumber       VARCHAR(50)
	 declare @FaxNumber          VARCHAR(50)
	 declare @Email              VARCHAR(100)
	 declare @StreetAddress      VARCHAR(200)
	 declare @Suburb             VARCHAR(50)
	 declare @Postcode           VARCHAR(10)
	 declare @StateCode          VARCHAR(10)
	 declare @UserID             INT
	 declare @CustomerID   INT
	 declare @AccountOperationID INT
	 declare @AccountOperationIDs VARCHAR(200)

	 set @UserID = 2398
	 set @CustomerID = 1034
	 set @AccountOperationID = 4444
	 set @AccountOperationIDs = '4444,2428'

SET NOCOUNT ON
	DECLARE @UserType AS int
	DECLARE @TCState AS VARCHAR(4)

	BEGIN TRY
			SELECT @UserType = ApplicationUserTypeID,
				   @TCState = StateCode
			FROM   ApplicationSystemUser
			WHERE  ApplicationSystemUserID = @UserID


			------------------------------------------ single contact update here ------------------------------------------
			IF @AccountOperationIDs is null  --please note: @AccountOperationIDs and @AccountOperationID are different values
			begin   
				If @UserType = 12 OR  @UserType = 13 -- External user
				begin
				   if exists(SELECT [AccountOperationID]					   
							  FROM [vwOWTContact]  
							  WHERE (vwOWTContact.EffectiveDateTo IS NULL OR vwOWTContact.EffectiveDateTo >= GETDATE( )) 
							  AND [AccountOperationID] = @AccountOperationID  
							  AND [CustomerID] = @CustomerID
							  AND vwOWTContact.AccountOperationID IN (SELECT AccountOperationID FROM vwOWTExternalUserAccountOperation
											WHERE  ApplicationSystemUserID = @UserID))
						begin
						    update AccountOperation set EmergencyContactPhoneNumber = @EmergencyPhone where [AccountOperationID] = @AccountOperationID

							update Individual set 
							TitleCode = @TitleCode,
							GivenName = @GivenName,
							Surname = @Surname,
							PhoneNumber = @PhoneNumber,
							MobileNumber= @MobileNumber,
							FaxNumber = @FaxNumber,
							EmailAddress = @Email,
							StreetAddress = @StreetAddress,
                            Suburb = @Suburb,
							Postcode = @Postcode,
							StateCode = @StateCode
							where IndividualID IN (select ValueA from @IntTableA) and AccountOperationID = @AccountOperationID
						end
				end

				If @UserType = 401  -- Interstate user
				begin
				   if exists(SELECT [AccountOperationID]					   
							  FROM [vwOWTContact]  
							  WHERE (vwOWTContact.EffectiveDateTo IS NULL OR vwOWTContact.EffectiveDateTo >= GETDATE( )) 
							  AND [AccountOperationID] = @AccountOperationID  --please note: @AccountOperationIDs and @AccountOperationID are different values
							  AND [CustomerID] = @CustomerID)							   
						begin
						    update AccountOperation set EmergencyContactPhoneNumber = @EmergencyPhone
							where [AccountOperationID] = @AccountOperationID

							update Individual set 
							TitleCode = @TitleCode,
							GivenName = @GivenName,
							Surname = @Surname,
							PhoneNumber = @PhoneNumber,
							MobileNumber= @MobileNumber,
							FaxNumber = @FaxNumber,
							EmailAddress = @Email,
							StreetAddress = @StreetAddress,
                            Suburb = @Suburb,
							Postcode = @Postcode,
							StateCode = @StateCode
							where IndividualID IN (select ValueA from @IntTableA) and AccountOperationID = @AccountOperationID
						end
				end
			end

			------------------------------------------ mutiple contact update here ------------------------------------------
			IF @AccountOperationIDs is not null And len(@AccountOperationIDs) > 0   --please note: @AccountOperationIDs and @AccountOperationID are different values
			begin	
				declare @Data varchar(50)
				set @Data = replace(@AccountOperationIDs, ' ', '')

				declare @IntTable TABLE ([Value] INT NULL)
				DECLARE @Ptr int, @Length int, @v nchar, @vv nvarchar(100)

				SELECT @Length = (DATALENGTH(@Data)) + 1, @Ptr = 1

					 
				WHILE (@Ptr < @Length)
				BEGIN
					SET @v = SUBSTRING(@Data, @Ptr, 1)
						
					IF @v = ','
						BEGIN
							INSERT INTO @IntTable (Value) VALUES (CAST(@vv AS int))
							SET @vv = NULL
						END
					ELSE
						BEGIN
							SET @vv = ISNULL(@vv, '') + @v							 
						END

					SET @Ptr = @Ptr + 1
				END

				-- If the last number was not followed by a comma, add it to the result set
				IF @vv IS NOT NULL
					INSERT INTO @IntTable (Value) VALUES (CAST(@vv AS int))

				IF @UserType = 12 OR  @UserType = 13 -- External user
				BEGIN
				   if exists(SELECT [AccountOperationID]					   
							  FROM [vwOWTContact]  
							  WHERE (vwOWTContact.EffectiveDateTo IS NULL OR vwOWTContact.EffectiveDateTo >= GETDATE( )) 
							  --AND [AccountOperationID] = @AccountOperationID
							  AND [CustomerID] = @CustomerID
							  AND vwOWTContact.AccountOperationID IN (select [Value] from @IntTable)
							  --AND vwOWTContact.AccountOperationID IN (SELECT AccountOperationID FROM vwOWTExternalUserAccountOperation
									--		WHERE  ApplicationSystemUserID = @UserID)
											)
						begin
						    select  EmergencyContactPhoneNumber from AccountOperation
							where AccountOperationID IN (select [Value] from @IntTable)
							 

							select  
							IndividualID,
							AccountOperationID,
							TitleCode ,
							GivenName ,
							Surname ,
							PhoneNumber,
							MobileNumber,
							FaxNumber,
							EmailAddress,
							StreetAddress,
                            Suburb,
							Postcode,
							StateCode
							from Individual
							where IndividualID  IN (select ValueA from @IntTableA)
							--and AccountOperationID IN (select [Value] from @IntTable)
							 
						end				   								
				END

				IF @UserType = 401  -- Interstate user
				BEGIN
				   	   if exists(SELECT [AccountOperationID]				   
							  FROM [vwOWTContact]  
							  WHERE (vwOWTContact.EffectiveDateTo IS NULL OR vwOWTContact.EffectiveDateTo >= GETDATE( )) 
							  AND [AccountOperationID] IN (select [Value] from @IntTable)
							  AND [CustomerID] = @CustomerID)							   
						begin
						    update AccountOperation set EmergencyContactPhoneNumber = @EmergencyPhone
							where AccountOperationID IN (select [Value] from @IntTable)

							update Individual set 
							TitleCode = @TitleCode,
							GivenName = @GivenName,
							Surname = @Surname,
							PhoneNumber = @PhoneNumber,
							MobileNumber= @MobileNumber,
							FaxNumber = @FaxNumber,
							EmailAddress = @Email,
							StreetAddress = @StreetAddress,
                            Suburb = @Suburb,
							Postcode = @Postcode,
							StateCode = @StateCode
							where IndividualID  IN (select ValueA from @IntTableA) and AccountOperationID IN (select [Value] from @IntTable)
						end
				END

				delete @IntTable
            end
		  
	        select 1 as TEMP
	END TRY
	
	BEGIN CATCH
	    select 0 as TEMP
		DECLARE @ErrorMessage VARCHAR(2000)
		SET @ErrorMessage = dbo.ufn_GetErrorTextPALMS()
		RAISERROR (@ErrorMessage , 16, 1)
	
	END CATCH