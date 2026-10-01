declare @inRadiationLicenceVariationID INT 
declare @inStatusID INT
declare @inUpdatingUser INT
declare @outErrorMsg VARCHAR(5000) 


set @inRadiationLicenceVariationID = 2218
set @inStatusID = 814
set @inUpdatingUser = 1334
set @outErrorMsg = ''

	declare @RtnVal int
	SELECT @RtnVal = 0
	DECLARE @ErrorMessage VARCHAR(2000)
	set @ErrorMessage = ''


		DECLARE @Temp VARCHAR(5000)
		SET @Temp = ''

		Declare @inInstrumentID int
		Declare @oldStatusId int
	  
		select @inInstrumentID = InstrumentID, @oldStatusId = VariationStatusID --812 means Pending, 813 means Terminated and 814 means Complete
		from dbo.tblRadiationLicenceVariation
		where RadiationLicenceVariationID = @inRadiationLicenceVariationID

		Declare @OldStatusText varchar(50)
		select @OldStatusText = [Description] from tblClassification where ClassificationID = @oldStatusId

		Declare @CurrentStatusText varchar(50)
		select @CurrentStatusText = [Description] from tblClassification where ClassificationID = @inStatusID

		DECLARE @DescriptionOfAction VARCHAR(50)

		if (@OldStatusText <> @CurrentStatusText)
		  SELECT @DescriptionOfAction ='Variation status changed:' + @OldStatusText + ' to ' + @CurrentStatusText
		else
		  SELECT @DescriptionOfAction ='Variation status unchanged:' + @OldStatusText + ' action triggered by relocation processes'  

		BEGIN TRAN A

		IF @inStatusID = 812 --possible we need reverse the variation status to pending
		begin
		  if not exists(select * from [dbo].[tblRadiationLicenceVariation] where RadiationLicenceVariationID = @inRadiationLicenceVariationID)
		   set @Temp = @Temp + '<br>' + 'No this variation record'
		  else
			begin
			   --here we back up all existing licence data in case this variation has been terminated then we can restore them back
			   exec dbo.uspBackUpRadiationLicenceData @inInstrumentID

			   update [tblRadiationLicenceVariation] set 
			   VariationStatusID = @inStatusID,
			   VariationCompletedFlag = 0, 
			   VariationCompleteDate = null,
			   UpdatedBySystemUserID = @inUpdatingUser,
			   DateUpdated = getdate()		    
			   where RadiationLicenceVariationID = @inRadiationLicenceVariationID
			end 
		end

		IF @inStatusID = 813  --terminated
		begin
		  if not exists(select * from [dbo].[tblRadiationLicenceVariation] where RadiationLicenceVariationID = @inRadiationLicenceVariationID)
		   set @Temp = @Temp + '<br>' + 'No this variation record'
		  else
			begin
			   --here we restore all back up licence data to its original licence data
			   exec dbo.uspRestoreRadiationLicenceData @inInstrumentID

			   update [tblRadiationLicenceVariation] set 
			   VariationStatusID = @inStatusID,
			   VariationCompletedFlag = 0, 
			   VariationCompleteDate = null,
			   VariationCompletedBySystemUserID = null,
			   UpdatedBySystemUserID = @inUpdatingUser,
			   DateUpdated = getdate()		    
			   where RadiationLicenceVariationID = @inRadiationLicenceVariationID
			end 
		end
 
		IF @inStatusID = 814 --we need set the variation status to complete
		begin
		  if not exists(select * from [dbo].[tblRadiationLicenceVariation] where RadiationLicenceVariationID = @inRadiationLicenceVariationID)
		   set @Temp = @Temp + '<br>' + 'No this variation record'
		  else
			begin
			   --here we delete all back up licence data as it is completed
			   exec dbo.uspDeleteBackUpRadiationLicenceData @inInstrumentID

print 'A'

			   update [tblRadiationLicenceVariation] set 
			   VariationStatusID = @inStatusID,
			   VariationCompletedFlag = 1, 
			   VariationCompleteDate = getdate(),
			   VariationCompletedBySystemUserID = @inUpdatingUser, 
			   UpdatedBySystemUserID = @inUpdatingUser,
			   DateUpdated = getdate()
			   where RadiationLicenceVariationID = @inRadiationLicenceVariationID

			   --Handles change to active
			   Update rrmc
				SET ComponentStatusID = 785
				FROM tblRRMComponent rrmc
				inner join tblRadiationLicenceRRMComponent licrrmc on rrmc.RRMComponentID = licrrmc.RRMComponentID
				inner join tblRadiationLicenceRRM rrm ON licrrmc.RadiationLicenceRRMID = rrm.RadiationLicenceRRMID
				inner join tblRadiationLocationRRM locrrm
				on rrm.RadiationLicenceRRMID = locrrm.RadiationLicenceRRMID
				inner join tblRadiationLocation loc on locrrm.RadiationLocationID = loc.RadiationLocationID
				inner join tblInstrumentRadiationLocation irl on irl.RadiationLocationID = loc.RadiationLocationID
				where irl.InstrumentID = @inInstrumentID AND ComponentStatusID = 784

				--SET Location RRM Status to active
				UPDATE rrm
					SET RRMStatusID = 785
					FROM tblRadiationLicenceRRM rrm inner join tblRadiationLocationRRM locrrm
					on rrm.RadiationLicenceRRMID = locrrm.RadiationLicenceRRMID
					inner join tblRadiationLocation loc on locrrm.RadiationLocationID = loc.RadiationLocationID
					inner join tblInstrumentRadiationLocation irl on irl.RadiationLocationID = loc.RadiationLocationID
					where irl.InstrumentID = @inInstrumentID AND RRMStatusID = 784
		   


			   -- Handles radiation location disposal logic --
			   UPDATE lirrmc
			   SET VariationPendingFlag = 0,
				 --  EffectiveDateTo = GETDATE(),
				   UpdatedBySystemUserID = @inUpdatingUser,			   
				   DateUpdated = GETDATE()
			   FROM tblRRMComponent rrmc 
			   join tblRadiationLicenceRRMComponent lirrmc on rrmc.RRMComponentID = lirrmc.RRMComponentID
			   join tblRadiationLicenceRRM lirrm on lirrmc.RadiationLicenceRRMID = lirrm.RadiationLicenceRRMID
			   join tblRadiationLocationRRM lorrm on lirrm.RadiationLicenceRRMID = lorrm.RadiationLicenceRRMID
			   join tblRadiationLocation lo on lorrm.RadiationLocationID = lo.RadiationLocationID
			   join tblInstrumentRadiationLocation irl on lo.RadiationLocationID = irl.RadiationLocationID
			   WHERE InstrumentID = @inInstrumentID AND rrmc.ComponentStatusID = 787


print 'B'


			   
			   -----------TY---------------------------

			    UPDATE rrmd
			   SET VariationPendingFlag = 0,
				   disposaldate = 	GETDATE(),
				   UpdatedBySystemUserID = @inUpdatingUser,
				   DateUpdated = GETDATE()
			   FROM tblRRMDisposal rrmd 
				join tblRadiationLicenceRRM lirrm on rrmd.RadiationLicenceRRMID = lirrm.RadiationLicenceRRMID
			   join tblRadiationLocationRRM lorrm on lirrm.RadiationLicenceRRMID = lorrm.RadiationLicenceRRMID
			   join tblRadiationLocation lo on lorrm.RadiationLocationID = lo.RadiationLocationID
			   join tblInstrumentRadiationLocation irl on lo.RadiationLocationID = irl.RadiationLocationID
			   WHERE InstrumentID = @inInstrumentID AND lirrm.RRMStatusID = 787	AND lorrm.EffectiveDateTo is not null



			    UPDATE rrmcd
			   SET VariationPendingFlag = 0,
				   disposaldate = 	GETDATE(),
				   UpdatedBySystemUserID = @inUpdatingUser,
				   DateUpdated = GETDATE()
			   FROM tblRRMComponentDisposal rrmcd
				join tblRRMComponent rrmc on rrmcd.RRMComponentID = rrmc.RRMComponentID
			   join tblRadiationLicenceRRMComponent lirrmc on rrmc.RRMComponentID = lirrmc.RRMComponentID
			   join tblRadiationLicenceRRM lirrm on lirrmc.RadiationLicenceRRMID = lirrm.RadiationLicenceRRMID
			   join tblRadiationLocationRRM lorrm on lirrm.RadiationLicenceRRMID = lorrm.RadiationLicenceRRMID
			   join tblRadiationLocation lo on lorrm.RadiationLocationID = lo.RadiationLocationID
			   join tblInstrumentRadiationLocation irl on lo.RadiationLocationID = irl.RadiationLocationID
			   WHERE InstrumentID = @inInstrumentID AND rrmc.ComponentStatusID = 787 AND lirrmc.EffectiveDateTo is not null
			   
			   ---------------- END TY-------------------------



			   UPDATE rrmc
			   SET ComponentStatusID = 786,
				   UpdatedBySystemUserID = @inUpdatingUser,
				   DateUpdated = GETDATE()
			   FROM tblRRMComponent rrmc 
			   join tblRadiationLicenceRRMComponent lirrmc on rrmc.RRMComponentID = lirrmc.RRMComponentID
			   join tblRadiationLicenceRRM lirrm on lirrmc.RadiationLicenceRRMID = lirrm.RadiationLicenceRRMID
			   join tblRadiationLocationRRM lorrm on lirrm.RadiationLicenceRRMID = lorrm.RadiationLicenceRRMID
			   join tblRadiationLocation lo on lorrm.RadiationLocationID = lo.RadiationLocationID
			   join tblInstrumentRadiationLocation irl on lo.RadiationLocationID = irl.RadiationLocationID
			   WHERE InstrumentID = @inInstrumentID AND rrmc.ComponentStatusID = 787 and lirrmc.EffectiveDateTo is null

			   UPDATE lorrm
			   SET VariationPendingFlag = 0,
				  -- EffectiveDateTo = GETDATE(),
				   UpdatedBySystemUserID = @inUpdatingUser,
				   DateUpdated = GETDATE()
			   FROM tblRadiationLicenceRRM lirrm
			   join tblRadiationLocationRRM lorrm on lirrm.RadiationLicenceRRMID = lorrm.RadiationLicenceRRMID
			   join tblRadiationLocation lo on lorrm.RadiationLocationID = lo.RadiationLocationID
			   join tblInstrumentRadiationLocation irl on lo.RadiationLocationID = irl.RadiationLocationID
			   WHERE InstrumentID = @inInstrumentID AND lirrm.RRMStatusID = 787

			   

print 'C'


			   UPDATE lirrm
			   SET RRMStatusID = 786,
				   UpdatedBySystemUserID = @inUpdatingUser,
				   DateUpdated = GETDATE()
			   FROM tblRadiationLicenceRRM lirrm 
			   join tblRadiationLocationRRM lorrm on lirrm.RadiationLicenceRRMID = lorrm.RadiationLicenceRRMID
			   join tblRadiationLocation lo on lorrm.RadiationLocationID = lo.RadiationLocationID
			   join tblInstrumentRadiationLocation irl on lo.RadiationLocationID = irl.RadiationLocationID
			   WHERE InstrumentID = @inInstrumentID AND lirrm.RRMStatusID = 787	 and 	lorrm.EffectiveDateTo is null   
			   -- Handles radiation location disposal logic *****END******* --

			   --Creates Draft Variations
			   DECLARE @tblInstrumentVariations AS TABLE (InstrumentID INT, DraftCreated BIT DEFAULT(0), IssueCreated BIT DEFAULT(0))

				INSERT INTO @tblInstrumentVariations(InstrumentID)
				SELECT Distinct inirl.InstrumentID FROM tblRadiationLicenceRRMComponent lirrmc
				   join tblRadiationLicenceRRM lirrm on lirrmc.RadiationLicenceRRMID = lirrm.RadiationLicenceRRMID
				   join tblRadiationLocationRRM lorrm on lirrm.RadiationLicenceRRMID = lorrm.RadiationLicenceRRMID
				   join tblRadiationLocation lo on lorrm.RadiationLocationID = lo.RadiationLocationID
				   join tblInstrumentRadiationLocation irl on lo.RadiationLocationID = irl.RadiationLocationID
				   join tblRadiationLicenceRRMComponent inlirrmc on lirrmc.NewRadiationLicenceRRMID = inlirrmc.RadiationLicenceRRMID
				   join tblRadiationLicenceRRM inlirrm on inlirrmc.RadiationLicenceRRMID = inlirrm.RadiationLicenceRRMID
				   join tblRadiationLocationRRM inlorrm on inlirrm.RadiationLicenceRRMID = inlorrm.RadiationLicenceRRMID
				   join tblRadiationLocation inlo on inlorrm.RadiationLocationID = inlo.RadiationLocationID
				   join tblInstrumentRadiationLocation inirl on inlo.RadiationLocationID = inirl.RadiationLocationID
				   WHERE irl.InstrumentID = @inInstrumentID AND lirrmc.VariationPendingFlag = 1 AND lirrmc.NewRadiationLicenceRRMID IS NOT NULL
		
				INSERT INTO @tblInstrumentVariations(InstrumentID)
				SELECT DISTINCT inirl.InstrumentID FROM tblRadiationLocationRRM lorrm
					join tblRadiationLocation lo on lorrm.RadiationLocationID = lo.RadiationLocationID
					join tblInstrumentRadiationLocation irl on lo.RadiationLocationID = irl.RadiationLocationID
					join tblRadiationLocation inlo on lorrm.NewLocationID = inlo.RadiationLocationID
					join tblInstrumentRadiationLocation inirl on inlo.RadiationLocationID = inirl.RadiationLocationID
					WHERE irl.InstrumentID = @inInstrumentID AND lorrm.VariationPendingFlag = 1 AND lorrm.NewLocationID IS NOT NULL
					AND inirl.InstrumentID NOT IN(SELECT InstrumentID FROM @tblInstrumentVariations) --distinct instrument ids

				INSERT INTO @tblInstrumentVariations(InstrumentID)
				SELECT DISTINCT IRL.NewInstrumentID FROM tblInstrumentRadiationLocation IRL			
					WHERE InstrumentID = @inInstrumentID AND IRL.VariationPendingFlag = 1 AND NewInstrumentID IS NOT NULL
					AND IRL.NewInstrumentID NOT IN(SELECT InstrumentID FROM @tblInstrumentVariations) --Distinct instrument ids
			
print 'D'
select * from @tblInstrumentVariations

				IF(SELECT Count(*) FROM @tblInstrumentVariations) > 0
					BEGIN
						WHILE (1=1)
							BEGIN
								DECLARE @VarInID AS INT

								IF (SELECT Count(*) FROM @tblInstrumentVariations WHERE DraftCreated = 0) = 0
									BEGIN
										Break;
									END
							
								SELECT TOP 1 @VarInID = InstrumentID FROM @tblInstrumentVariations WHERE DraftCreated = 0

								IF(@VarInID > 0 and (@VarInID <> @inInstrumentID))
								BEGIN
										EXEC dbo.uspRadiationLicenceVariationCreate @VarInID, 812 , 'Relocation', 1, @inUpdatingUser,''
										UPDATE @tblInstrumentVariations
										SET DraftCreated = 1
										WHERE InstrumentID = @VarInID
								END

										UPDATE @tblInstrumentVariations
										SET DraftCreated = 1
										WHERE InstrumentID = @VarInID

							END
					END
			   --End Creates Draft Variations

			   -- Handles radiation location export logic --
			   UPDATE lirrmc
			   SET VariationPendingFlag = 0,
				   --EffectiveDateTo = GETDATE(),
				   ExportedDate = GETDATE(),
				   UpdatedBySystemUserID = @inUpdatingUser,
				   DateUpdated = GETDATE()
			   FROM tblRRMComponent rrmc 
			   join tblRadiationLicenceRRMComponent lirrmc on rrmc.RRMComponentID = lirrmc.RRMComponentID
			   join tblRadiationLicenceRRM lirrm on lirrmc.RadiationLicenceRRMID = lirrm.RadiationLicenceRRMID
			   join tblRadiationLocationRRM lorrm on lirrm.RadiationLicenceRRMID = lorrm.RadiationLicenceRRMID
			   join tblRadiationLocation lo on lorrm.RadiationLocationID = lo.RadiationLocationID
			   join tblInstrumentRadiationLocation irl on lo.RadiationLocationID = irl.RadiationLocationID
			   WHERE InstrumentID = @inInstrumentID AND rrmc.ComponentStatusID = 811

			   UPDATE rrmc
			   SET ComponentStatusID = 810,
				   UpdatedBySystemUserID = @inUpdatingUser,
				   DateUpdated = GETDATE()
			   FROM tblRRMComponent rrmc 
			   join tblRadiationLicenceRRMComponent lirrmc on rrmc.RRMComponentID = lirrmc.RRMComponentID
			   join tblRadiationLicenceRRM lirrm on lirrmc.RadiationLicenceRRMID = lirrm.RadiationLicenceRRMID
			   join tblRadiationLocationRRM lorrm on lirrm.RadiationLicenceRRMID = lorrm.RadiationLicenceRRMID
			   join tblRadiationLocation lo on lorrm.RadiationLocationID = lo.RadiationLocationID
			   join tblInstrumentRadiationLocation irl on lo.RadiationLocationID = irl.RadiationLocationID
			   WHERE InstrumentID = @inInstrumentID AND rrmc.ComponentStatusID = 811

			   UPDATE lorrm
			   SET VariationPendingFlag = 0,
				   --EffectiveDateTo = GETDATE(),
				   ExportedDate = GETDATE(),
				   UpdatedBySystemUserID = @inUpdatingUser,
				   DateUpdated = GETDATE()
			   FROM tblRadiationLicenceRRM lirrm
			   join tblRadiationLocationRRM lorrm on lirrm.RadiationLicenceRRMID = lorrm.RadiationLicenceRRMID
			   join tblRadiationLocation lo on lorrm.RadiationLocationID = lo.RadiationLocationID
			   join tblInstrumentRadiationLocation irl on lo.RadiationLocationID = irl.RadiationLocationID
			   WHERE InstrumentID = @inInstrumentID AND lirrm.RRMStatusID = 811


			   UPDATE lirrm
			   SET RRMStatusID = 810,
				   UpdatedBySystemUserID = @inUpdatingUser,
				   DateUpdated = GETDATE()
			   FROM tblRadiationLicenceRRM lirrm 
			   join tblRadiationLocationRRM lorrm on lirrm.RadiationLicenceRRMID = lorrm.RadiationLicenceRRMID
			   join tblRadiationLocation lo on lorrm.RadiationLocationID = lo.RadiationLocationID
			   join tblInstrumentRadiationLocation irl on lo.RadiationLocationID = irl.RadiationLocationID
			   WHERE InstrumentID = @inInstrumentID AND lirrm.RRMStatusID = 811		   
			   -- Handles radiation location export logic *****END******* --

			   -- Handles radiation location relocation logic --
			   DECLARE @MinID AS INT, @MaxID AS INT
		   
			   SELECT @MinID = Min(RadiationLicenceRRMComponentID) FROM tblRadiationLicenceRRMComponent lirrmc
			   join tblRadiationLicenceRRM lirrm on lirrmc.RadiationLicenceRRMID = lirrm.RadiationLicenceRRMID
			   join tblRadiationLocationRRM lorrm on lirrm.RadiationLicenceRRMID = lorrm.RadiationLicenceRRMID
			   join tblRadiationLocation lo on lorrm.RadiationLocationID = lo.RadiationLocationID
			   join tblInstrumentRadiationLocation irl on lo.RadiationLocationID = irl.RadiationLocationID
			   WHERE InstrumentID = @inInstrumentID AND lirrmc.VariationPendingFlag = 1 AND NewRadiationLicenceRRMID IS NOT NULL

			   SELECT @MaxID = MAX(RadiationLicenceRRMComponentID) FROM tblRadiationLicenceRRMComponent lirrmc
			   join tblRadiationLicenceRRM lirrm on lirrmc.RadiationLicenceRRMID = lirrm.RadiationLicenceRRMID
			   join tblRadiationLocationRRM lorrm on lirrm.RadiationLicenceRRMID = lorrm.RadiationLicenceRRMID
			   join tblRadiationLocation lo on lorrm.RadiationLocationID = lo.RadiationLocationID
			   join tblInstrumentRadiationLocation irl on lo.RadiationLocationID = irl.RadiationLocationID
			   WHERE InstrumentID = @inInstrumentID AND lirrmc.VariationPendingFlag = 1 AND NewRadiationLicenceRRMID IS NOT NULL

			   SET @MaxID = ISNULL(@MaxID, 0) 

			   IF(@MinID > 0)
				BEGIN
				   WHILE(1=1)
					BEGIN
						IF EXISTS(SELECT 1 FROM tblRadiationLicenceRRMComponent lirrmc
						   join tblRadiationLicenceRRM lirrm on lirrmc.RadiationLicenceRRMID = lirrm.RadiationLicenceRRMID
						   join tblRadiationLocationRRM lorrm on lirrm.RadiationLicenceRRMID = lorrm.RadiationLicenceRRMID
						   join tblRadiationLocation lo on lorrm.RadiationLocationID = lo.RadiationLocationID
						   join tblInstrumentRadiationLocation irl on lo.RadiationLocationID = irl.RadiationLocationID
						   WHERE InstrumentID = @inInstrumentID AND lirrmc.VariationPendingFlag = 1 AND NewRadiationLicenceRRMID IS NOT NULL
						   AND RadiationLicenceRRMComponentID = @MinID)
						   BEGIN
								INSERT INTO [dbo].[tblRadiationLicenceRRMComponent]
								   ([RadiationLicenceRRMID]
								   ,[RRMComponentID]
								   ,[VariationPendingFlag]
								   ,[Notes]
								   ,[InterstateOverseasRelocationFlag]
								   ,[EffectiveDateFrom]
								   ,[DateCreated]
								   ,[CreatedBySystemUserID])
								SELECT 
									lirrmc.NewRadiationLicenceRRMID,
									lirrmc.RRMComponentID,
									0,
									lirrmc.Notes,
									0,
									GETDATE(),
									GETDATE(),
									@inUpdatingUser							
								FROM tblRadiationLicenceRRMComponent lirrmc
								join tblRadiationLicenceRRM lirrm on lirrmc.RadiationLicenceRRMID = lirrm.RadiationLicenceRRMID
								join tblRadiationLocationRRM lorrm on lirrm.RadiationLicenceRRMID = lorrm.RadiationLicenceRRMID
								join tblRadiationLocation lo on lorrm.RadiationLocationID = lo.RadiationLocationID
								join tblInstrumentRadiationLocation irl on lo.RadiationLocationID = irl.RadiationLocationID
								WHERE InstrumentID = @inInstrumentID AND lirrmc.VariationPendingFlag = 1 AND NewRadiationLicenceRRMID IS NOT NULL
								AND RadiationLicenceRRMComponentID = @MinID
													
								UPDATE lirrmc
									SET VariationPendingFlag = 0,
										EffectiveDateTo = GETDATE(),
										UpdatedBySystemUserID = @inUpdatingUser,
										DateUpdated = GETDATE()
								FROM tblRadiationLicenceRRMComponent lirrmc
								join tblRadiationLicenceRRM lirrm on lirrmc.RadiationLicenceRRMID = lirrm.RadiationLicenceRRMID
								join tblRadiationLocationRRM lorrm on lirrm.RadiationLicenceRRMID = lorrm.RadiationLicenceRRMID
								join tblRadiationLocation lo on lorrm.RadiationLocationID = lo.RadiationLocationID
								join tblInstrumentRadiationLocation irl on lo.RadiationLocationID = irl.RadiationLocationID
								WHERE InstrumentID = @inInstrumentID AND lirrmc.VariationPendingFlag = 1 AND NewRadiationLicenceRRMID IS NOT NULL
								AND RadiationLicenceRRMComponentID = @MinID
														
								UPDATE rrmc
									SET ComponentStatusID = 785,
										UpdatedBySystemUserID = @inUpdatingUser,
										DateUpdated = GETDATE()
								FROM tblRRMComponent rrmc
								Join tblRadiationLicenceRRMComponent lirrmc ON rrmc.RRMComponentID = lirrmc.RRMComponentID
								WHERE RadiationLicenceRRMComponentID = @MinID AND ComponentStatusID = 788
						   END

						SET @MinID = @MinID + 1

						IF(@MinID > @MaxID)
							BEGIN
								BREAK;
							END
					END
				END

				SET @MinID = 0
				SET @MaxID = 0

				SELECT @MinID = MIN(RadiationLocationRRMID) FROM tblRadiationLocationRRM lorrm
				join tblRadiationLocation lo on lorrm.RadiationLocationID = lo.RadiationLocationID
				join tblInstrumentRadiationLocation irl on lo.RadiationLocationID = irl.RadiationLocationID
				WHERE InstrumentID = @inInstrumentID AND lorrm.VariationPendingFlag = 1 AND NewLocationID IS NOT NULL

			   SELECT @MaxID = MAX(RadiationLocationRRMID) FROM tblRadiationLocationRRM lorrm
				join tblRadiationLocation lo on lorrm.RadiationLocationID = lo.RadiationLocationID
				join tblInstrumentRadiationLocation irl on lo.RadiationLocationID = irl.RadiationLocationID
				WHERE InstrumentID = @inInstrumentID AND lorrm.VariationPendingFlag = 1 AND NewLocationID IS NOT NULL

				SET @MaxID = ISNULL(@MaxID, 0) 

				IF(@MinID > 0)
					BEGIN
					   WHILE(1=1)
						BEGIN
							IF EXISTS(SELECT 1 FROM tblRadiationLocationRRM lorrm
								join tblRadiationLocation lo on lorrm.RadiationLocationID = lo.RadiationLocationID
								join tblInstrumentRadiationLocation irl on lo.RadiationLocationID = irl.RadiationLocationID
								WHERE InstrumentID = @inInstrumentID AND lorrm.VariationPendingFlag = 1 AND NewLocationID IS NOT NULL
								AND RadiationLocationRRMID = @MinID)
							   BEGIN
									INSERT INTO [dbo].[tblRadiationLocationRRM]
									   ([RadiationLocationID]
									   ,[RadiationLicenceRRMID]
									   ,[VariationPendingFlag]
									   ,[Notes]
									   ,[InterstateOverseasRelocationFlag]
									   ,[EffectiveDateFrom]
									   ,[DateCreated]
									   ,[CreatedBySystemUserID])
									SELECT 
										lorrm.NewLocationID,
										lorrm.RadiationLicenceRRMID,
										0,
										lorrm.Notes,
										0,
										GETDATE(),
										GETDATE(),
										@inUpdatingUser					
									FROM tblRadiationLocationRRM lorrm
									join tblRadiationLocation lo on lorrm.RadiationLocationID = lo.RadiationLocationID
									join tblInstrumentRadiationLocation irl on lo.RadiationLocationID = irl.RadiationLocationID
									WHERE InstrumentID = @inInstrumentID AND lorrm.VariationPendingFlag = 1 AND NewLocationID IS NOT NULL
									AND RadiationLocationRRMID = @MinID

									UPDATE lorrm
										SET VariationPendingFlag = 0,
											EffectiveDateTo = GETDATE(),
											UpdatedBySystemUserID = @inUpdatingUser,
											DateUpdated = GETDATE()
									FROM tblRadiationLocationRRM lorrm
									join tblRadiationLocation lo on lorrm.RadiationLocationID = lo.RadiationLocationID
									join tblInstrumentRadiationLocation irl on lo.RadiationLocationID = irl.RadiationLocationID
									WHERE InstrumentID = @inInstrumentID AND lorrm.VariationPendingFlag = 1 AND NewLocationID IS NOT NULL
									AND RadiationLocationRRMID = @MinID	
								
									UPDATE lirrm
									SET RRMStatusID = 785,
										UpdatedBySystemUserID = @inUpdatingUser,
										DateUpdated = GETDATE()
									FROM tblRadiationLicenceRRM lirrm
									join tblRadiationLocationRRM lorrm on lirrm.RadiationLicenceRRMID = lorrm.RadiationLicenceRRMID
									WHERE RadiationLocationRRMID = @MinID AND RRMStatusID = 788							
							   END

							SET @MinID = @MinID + 1

							IF(@MinID > @MaxID)
								BEGIN
									BREAK;
								END
						END
				END
			   -- Handles radiation location relocation logic *****END******

			   --Handles radiation location relocation logic to licecne
				SET @MinID = 0
				SET @MaxID = 0

				SELECT @MinID = MIN(InstrumentRadiationLocationID) FROM tblInstrumentRadiationLocation IRL
				WHERE InstrumentID = @inInstrumentID AND IRL.VariationPendingFlag = 1 AND NewInstrumentID IS NOT NULL

			   SELECT @MaxID = MAX(InstrumentRadiationLocationID) FROM tblInstrumentRadiationLocation IRL
				WHERE InstrumentID = @inInstrumentID AND IRL.VariationPendingFlag = 1 AND NewInstrumentID IS NOT NULL

				SET @MaxID = ISNULL(@MaxID, 0) 

				IF(@MinID > 0)
					BEGIN
					   WHILE(1=1)
						BEGIN
							IF EXISTS(SELECT 1 FROM tblInstrumentRadiationLocation IRL
								WHERE InstrumentID = @inInstrumentID AND IRL.VariationPendingFlag = 1 AND NewInstrumentID IS NOT NULL
								AND InstrumentRadiationLocationID = @MinID)
							   BEGIN
									INSERT INTO [dbo].[tblInstrumentRadiationLocation]
									   ([InstrumentID]
									   ,[RadiationLocationID]
									   ,[VariationPendingFlag]
									   ,[EffectiveDateFrom]								   
									   ,[DateCreated]
									   ,[CreatedBySystemUserID])
									SELECT 
										IRL.NewInstrumentID,
										IRL.RadiationLocationID,
										0,
										GETDATE(),
										GETDATE(),
										@inUpdatingUser			
									FROM tblInstrumentRadiationLocation IRL
									WHERE InstrumentID = @inInstrumentID AND IRL.VariationPendingFlag = 1 AND NewInstrumentID IS NOT NULL
									AND InstrumentRadiationLocationID = @MinID

									UPDATE IRL
										SET VariationPendingFlag = 0,
											EffectiveDateTo = GETDATE(),
											UpdatedBySystemUserID = @inUpdatingUser,
											DateUpdated = GETDATE()
									FROM tblInstrumentRadiationLocation IRL
									WHERE InstrumentID = @inInstrumentID AND IRL.VariationPendingFlag = 1 AND NewInstrumentID IS NOT NULL
									AND InstrumentRadiationLocationID = @MinID					
							   END

							SET @MinID = @MinID + 1

							IF(@MinID > @MaxID)
								BEGIN
									BREAK;
								END
						END
				END
				--Handles radiation location relocation logic to licecne

				--Complete created variations
				IF(SELECT Count(*) FROM @tblInstrumentVariations) > 0
					BEGIN
						WHILE (1=1)
							BEGIN							
								IF(SELECT Count(*) FROM @tblInstrumentVariations WHERE IssueCreated = 0) = 0
									BEGIN
										Break;
									END
								
								SELECT TOP 1 @VarInID = InstrumentID FROM @tblInstrumentVariations WHERE IssueCreated = 0

								IF(@VarInID > 0)
									BEGIN
										DECLARE @VarID AS INT
										SELECT @VarID = RadiationLicenceVariationID FROM tblRadiationLicenceVariation
										WHERE InstrumentID = @VarInID AND VariationStatusID = 812

										EXEC dbo.uspRadiationUpdateVariationStatus @VarID, 814, @inUpdatingUser,''
									
										UPDATE @tblInstrumentVariations
										SET IssueCreated = 1
										WHERE InstrumentID = @VarInID
									END
							END
					END
				--End Complete created variations
			end 
		end

		declare @VariationExtraInfo VARCHAR(50) --Radiation Licence VariationID
		set @VariationExtraInfo = 'Radiation Licence VariationID: ' + cast(@inRadiationLicenceVariationID as varchar(50))

		if @inInstrumentID != null
		  EXEC @RtnVal = uspAuditLogInsert @inInstrumentID, @DescriptionOfAction, @VariationExtraInfo, @inUpdatingUser, @inUpdatingUser, 1

		COMMIT TRAN A



		--FINALLY WE RETURN
		--here we clean up the prefix <br> which is not necessary
		if len(@Temp) > 4
		begin		 
			set @outErrorMsg= substring(@Temp, 5, len(@Temp) - 3)    
		end
		else
			set @outErrorMsg = @Temp  
		   
		SELECT @outErrorMsg as TEMP	