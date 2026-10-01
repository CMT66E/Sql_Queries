ALTER PROCEDURE [dbo].[uspRiskAssessmentSectionScoreCalculationRESTFul]
( 
	@MediaTypeID int,
	@theXmlData xml,
	@SystemUserID int
)
AS
BEGIN
    SET NOCOUNT ON

	DECLARE @RiskAssessmentResultMediaID int
	DECLARE @RiskAssessmentAnswerID INT

	DECLARE @RowNumber int = 0
	
	DECLARE @PreviousSectionID int
	DECLARE @SectionID int
	DECLARE @Score int
	DECLARE @SectionScore int
	DECLARE @ScoreTypeID int
	DECLARE @ScoreFactor decimal(5,1)

	DECLARE @tblRiskAssessmentResultMedia TABLE (
				RiskAssessmentResultMediaID int identity(1,1),
				InstrumentID int,
				RiskAssessmentMediaID int,
				CalculatedRiskScore int,
				RegulatoryPriorityID int,
				DateCreated datetime,
				CreatedBySystemUserID int)

	DECLARE @tblRiskAssessment TABLE (
				InstrumentID int,
				AssessmentReasonID int,
				ResponsibleSystemUserID int,
				DECCWSectionID int,
				ConditionAssessedFlag BIT,
				LicenceReviewCompletedFlag BIT,
				LicenceVariedFlag BIT,
				ReviewComments VARCHAR(500),
				MajorEnvironmentalHarmFlag BIT)
				
	DECLARE @tblRiskAssessmentSectionScore TABLE (
				ID int identity(1,1),
				RiskAssessmentResultMediaID int,
				RiskAssessmentResultSectionID int,
				RiskAssessmentMediaID int,
				RiskAssessmentSectionID int,
				RiskScore int,
				CreatedBySystemUserID int
				)

	DECLARE @tblRiskAssessmentResultAnswer TABLE (
				ID int identity(1,1),
				RiskAssessmentSectionID int,
				RiskAssessmentAnswerID int,
				ProvidedReasonID int,
				ProvidedReason2ID int,        ------------ PALMS 5.1
				ProvidedReason3ID int,			------------ PALMS 5.1
				Justification VARCHAR(1000))   ----------- PALMS 5.1

	DECLARE @tblRiskAssessmentResultPollutant TABLE (
				ID int identity(1,1),
				RiskAssessmentSectionID int,
				RiskAssessmentPollutantID int)

	DECLARE @tblRiskAssessmentResultWaterHazardPollutant TABLE (
				ID int identity(1,1),
				RiskAssessmentSectionID int,
				RiskAssessmentWaterHazardPollutantID int)
	
	DECLARE @tblRiskAssessmentResultWaterType TABLE (
				ID int identity(1,1),
				RiskAssessmentSectionID int,
				RiskAssessmentWaterTypeID int)

	DECLARE @tblRiskAssessmentResultWaterPollutant TABLE (
				ID int identity(1,1),
				RiskAssessmentSectionID int,
				RiskAssessmentWaterTypeID int,
				RiskAssessmentPollutantID int)


	BEGIN TRY
		IF(@MediaTypeID <> 0) --Not detail tab
			BEGIN
				-- get the "RiskAssessmentResultMediaID" for the given InstrumentID and MediaTypeID...
				--If Media ID does not exist then create one
				IF EXISTS(SELECT rm.RiskAssessmentResultMediaID
						FROM	@tblRiskAssessmentResultMedia rm
						WHERE	rm.RiskAssessmentMediaID = @MediaTypeID)
					BEGIN			
						SELECT	@RiskAssessmentResultMediaID = rm.RiskAssessmentResultMediaID
						FROM	@tblRiskAssessmentResultMedia rm
						WHERE	rm.RiskAssessmentMediaID = @MediaTypeID
					END
				ELSE
					BEGIN						
						INSERT INTO @tblRiskAssessmentResultMedia 
						(
							InstrumentID,
							RiskAssessmentMediaID,
							DateCreated,
							CreatedBySystemUserID 
						)
						SELECT 1000, @MediaTypeID, GETDATE(), @SystemUserID


						SELECT	@RiskAssessmentResultMediaID = rm.RiskAssessmentResultMediaID
						FROM	@tblRiskAssessmentResultMedia rm
						WHERE	rm.RiskAssessmentMediaID = @MediaTypeID
					END

				-- get the previous "Section Score" details...				 
				INSERT INTO @tblRiskAssessmentSectionScore (				        
						RiskAssessmentResultSectionID,
						RiskAssessmentResultMediaID,
						RiskAssessmentMediaID, 
						RiskAssessmentSectionID,
						RiskScore,
						CreatedBySystemUserID )

				SELECT [RiskAssessmentSectionID],  @MediaTypeID,  @MediaTypeID, [RiskAssessmentSectionID], null, @SystemUserID     
				FROM [tblRiskAssessmentSection]
				WHERE [RiskAssessmentMediaID] = @MediaTypeID

			 
				INSERT INTO @tblRiskAssessmentResultAnswer (
						RiskAssessmentSectionID,
						RiskAssessmentAnswerID,
						ProvidedReasonID,
						Justification,
						ProvidedReason2ID,          ------------ PALMS 5.1
						ProvidedReason3ID)
				SELECT	RN.S.value('RiskAssessmentSectionID[1]','int'),
						RN.S.value('RiskAssessmentAnswerID[1]','int'),
						RN.S.value('ProvidedReasonID[1]','int'),
						RN.S.value('Justification[1]','VARCHAR(1000)'),
						RN.S.value('ProvidedReason2ID[1]','int'),
						RN.S.value('ProvidedReason3ID[1]','int')
				FROM	@theXmlData.nodes('/DataRiskERAssessment/RiskAssessmentResultAnswer') as RN(S)

	 
				INSERT INTO @tblRiskAssessmentResultPollutant (
						RiskAssessmentSectionID,
						RiskAssessmentPollutantID )
				SELECT	RN.S.value('RiskAssessmentSectionID[1]','int'),
						RN.S.value('RiskAssessmentAirPollutantID[1]','int')
				FROM	@theXmlData.nodes('/DataRiskERAssessment/RiskAssessmentResultAirPollutant') as RN(S)

			 
				INSERT INTO @tblRiskAssessmentResultWaterHazardPollutant (
						RiskAssessmentSectionID,
						RiskAssessmentWaterHazardPollutantID )
				SELECT	RN.S.value('RiskAssessmentSectionID[1]','int'),
						RN.S.value('RiskAssessmentWaterHazardPollutantID[1]','int')
				FROM	@theXmlData.nodes('/DataRiskERAssessment/RiskAssessmentResultWaterHazardPollutant') as RN(S)

				INSERT INTO @tblRiskAssessmentResultWaterType (
						RiskAssessmentSectionID,
						RiskAssessmentWaterTypeID)
				SELECT	RN.S.value('RiskAssessmentSectionID[1]','int'),
						RN.S.value('RiskAssessmentWaterTypeID[1]','int')
				FROM	@theXmlData.nodes('/DataRiskERAssessment/RiskAssessmentResultWaterType') as RN(S)
							
				INSERT INTO @tblRiskAssessmentResultWaterPollutant (
						RiskAssessmentSectionID,
						RiskAssessmentWaterTypeID,
						RiskAssessmentPollutantID )
				SELECT	RN.S.value('RiskAssessmentSectionID[1]','int'),
						RN.S.value('RiskAssessmentWaterTypeID[1]','int'),
						RN.S.value('PollutantID[1]','int')
				FROM	@theXmlData.nodes('/DataRiskERAssessment/RiskAssessmentResultWaterPollutant') as RN(S)
				
				--============================START here we check all calculation tables to make sure all data had been put into================================ 
                --select * from @tblRiskAssessmentResultAnswer
				--============================END here we check all calculation tables to make sure all data had been put into================================ 

				-- process the answers to calculate the score, before inserting the results in the actual tables...
				SET	@PreviousSectionID = 0
				SET @Score = 0
				SET @SectionScore = NULL
				
				-- reset the current score...
				UPDATE	@tblRiskAssessmentSectionScore
				SET		RiskScore = NULL
				
				DECLARE @RiskAssessmentResultSectionID AS INT
				DECLARE @OldSectionScore INT = 0
						
				WHILE (1 = 1)
				BEGIN
					SET @RowNumber = @RowNumber + 1

					--reset @RiskAssessmentResultSectionID
					SET @RiskAssessmentResultSectionID = null;
					
					IF NOT EXISTS (SELECT 1 FROM @tblRiskAssessmentResultAnswer WHERE ID = @RowNumber)
					BEGIN
						-- Get risk assessment result section ID
						--SELECT @RiskAssessmentResultSectionID = RiskAssessmentResultSectionID FROM tblRiskAssessmentResultSection WHERE RiskAssessmentResultMediaID = @RiskAssessmentResultMediaID
						--	AND RiskAssessmentSectionID = @PreviousSectionID
							
						-- update the last row
						UPDATE	@tblRiskAssessmentSectionScore
						SET		RiskScore = @SectionScore
						WHERE	RiskAssessmentResultSectionID = @RiskAssessmentResultSectionID

						BREAK
					END			
					
					SELECT	@SectionID = tmp.RiskAssessmentSectionID,
							@ScoreTypeID = ans.ScoreTypeID,
							@Score = ISNULL(ans.Score, 0),
							@ScoreFactor = ans.ScoreFactor,
							@RiskAssessmentAnswerID = tmp.RiskAssessmentAnswerID
					FROM	@tblRiskAssessmentResultAnswer tmp
					JOIN	tblRiskAssessmentAnswer ans ON ans.RiskAssessmentAnswerID = tmp.RiskAssessmentAnswerID
					WHERE	ID = @RowNumber
					
					IF @SectionID > 0
					BEGIN						 
						-- update the previous section score...
						UPDATE	@tblRiskAssessmentSectionScore
						SET		RiskScore = @SectionScore
						WHERE	RiskAssessmentResultSectionID = @RiskAssessmentResultSectionID
						
						--Reset SectionScore
						SET @SectionScore = NULL
						SET @PreviousSectionID = @SectionID
					END
					-- increase the current section score...
					-- reset the score...
					IF @ScoreTypeID = 685
					BEGIN
						SET @SectionScore = @Score

						------------ PALMS V5.1
						IF @SectionID = 8
						BEGIN
							IF @Score > @OldSectionScore
							BEGIN
								SET  @SectionScore = @Score
								SET @OldSectionScore = @Score
							END
							ELSE
							BEGIN
								SET @SectionScore = @OldSectionScore
							END
						END
						------------ END OF PALMS V5.1

					END
					ELSE IF @ScoreTypeID = 686
					BEGIN
						SET @SectionScore = @SectionScore + @ScoreFactor
					END
					ELSE IF @ScoreTypeID = 687
					BEGIN
						SET @SectionScore = @SectionScore - @ScoreFactor
					END
					ELSE IF @ScoreTypeID = 688
					BEGIN
						SET @SectionScore = @SectionScore * @ScoreFactor
					END
					ELSE IF @ScoreTypeID = 385
					BEGIN
						SET @SectionScore = @Score

						------------ PALMS V5.2
						IF @SectionID = 20  AND (@RiskAssessmentAnswerID = 37 OR @RiskAssessmentAnswerID = 91)
						BEGIN
							IF @Score > @OldSectionScore
							BEGIN
								SET @SectionScore = @Score
								SET @OldSectionScore = @Score
							END
							ELSE
							BEGIN
								SET @SectionScore = @OldSectionScore
							END
						END

						IF @SectionID = 20  AND (@RiskAssessmentAnswerID = 117) --Question 52 (in UI question 5) answered: NO then we need check Q50 and Q51 to decide the final score
						BEGIN
							IF @Score > @OldSectionScore
							BEGIN
							    DECLARE @Q50AnswerID INT
								DECLARE @Q51AnswerID INT

								if exists(select RiskAssessmentAnswerID from @tblRiskAssessmentResultAnswer where RiskAssessmentAnswerID in (113, 114))
								   select @Q50AnswerID = RiskAssessmentAnswerID from @tblRiskAssessmentResultAnswer where RiskAssessmentAnswerID in (113, 114)
								else
								   select @Q50AnswerID = 0

								if exists(select RiskAssessmentAnswerID from @tblRiskAssessmentResultAnswer where RiskAssessmentAnswerID in (115, 116))
								   select @Q51AnswerID = RiskAssessmentAnswerID from @tblRiskAssessmentResultAnswer where RiskAssessmentAnswerID in (115, 116)
								else
								   select @Q51AnswerID = 0

								if @Q50AnswerID > 0 and @Q51AnswerID > 0 
								   select @Score =  [dbo].[ufn_GetRiskAssessmentIncidentScore](@Q50AnswerID, @Q51AnswerID, 0)

								SET @SectionScore = @Score
								SET @OldSectionScore = @Score
							END
							ELSE
							BEGIN
								SET @SectionScore = @OldSectionScore
							END
						END

						IF @SectionID = 20  AND (@RiskAssessmentAnswerID = 119 or @RiskAssessmentAnswerID = 120 or @RiskAssessmentAnswerID = 121) --Question 53 (in UI question 6) answered: total three options then we need check Q50 and Q51 to decide the final score
						BEGIN					 
							IF @Score > @OldSectionScore
							BEGIN
							    DECLARE @Q50AnswerIDfinal INT
								DECLARE @Q51AnswerIDfinal INT
								DECLARE @Q53AnswerID INT

								if exists(select RiskAssessmentAnswerID from @tblRiskAssessmentResultAnswer where RiskAssessmentAnswerID in (113, 114))
								   select @Q50AnswerIDfinal = RiskAssessmentAnswerID from @tblRiskAssessmentResultAnswer where RiskAssessmentAnswerID in (113, 114)
								else
								   select @Q50AnswerIDfinal = 0

								if exists(select RiskAssessmentAnswerID from @tblRiskAssessmentResultAnswer where RiskAssessmentAnswerID in (115, 116))
								   select @Q51AnswerIDfinal = RiskAssessmentAnswerID from @tblRiskAssessmentResultAnswer where RiskAssessmentAnswerID in (115, 116)
								else
								   select @Q51AnswerIDfinal = 0

								if exists(select RiskAssessmentAnswerID from @tblRiskAssessmentResultAnswer where RiskAssessmentAnswerID in (119, 120, 121))
								   select @Q53AnswerID = RiskAssessmentAnswerID from @tblRiskAssessmentResultAnswer where RiskAssessmentAnswerID in (119, 120, 121)
								else
								   select @Q53AnswerID = 0
 
								if @Q50AnswerIDfinal > 0 and @Q51AnswerIDfinal > 0 and @Q53AnswerID > 0
								   select @Score =  [dbo].[ufn_GetRiskAssessmentIncidentScore](@Q50AnswerIDfinal, @Q51AnswerIDfinal, @Q53AnswerID)
 
								SET @SectionScore = @Score
								SET @OldSectionScore = @Score
							END
							ELSE
							BEGIN
								SET @SectionScore = @OldSectionScore
							END
						END
					END					
				END
				
				-- remove existing answers for the current media type...
				--DELETE	ra
				--FROM	tblRiskAssessmentResultAnswer ra
				--JOIN	tblRiskAssessmentResultSection rs ON rs.RiskAssessmentResultSectionID = ra.RiskAssessmentResultSectionID
				--WHERE	rs.RiskAssessmentResultMediaID = @RiskAssessmentResultMediaID
				
				-- reset the "Section" score...
				--UPDATE	rs
				--SET		rs.RiskScore = NULL
				--FROM	tblRiskAssessmentResultSection rs
				--WHERE	rs.RiskAssessmentResultMediaID = @RiskAssessmentResultMediaID
				
				-- insert new answers
				--INSERT INTO tblRiskAssessmentResultAnswer (
				--		RiskAssessmentResultSectionID,
				--		RiskAssessmentAnswerID,
				--		ProvidedReasonID,
				--		Justification,
				--		CreatedBySystemUserID,
				--		DateCreated,
				--		UpdatedBySystemUserID,
				--		DateUpdated,
				--		ProvidedReason2ID,
				--		ProvidedReason3ID )
				--SELECT	rs.RiskAssessmentResultSectionID,
				--		ra.RiskAssessmentAnswerID,
				--		tmp.ProvidedReasonID,
				--		tmp.Justification,
				--		@SystemUserID,
				--		GETDATE(),
				--		@SystemUserID,
				--		GETDATE(),
				--		tmp.ProvidedReason2ID,
				--		tmp.ProvidedReason3ID
				--FROM	@tblRiskAssessmentResultAnswer tmp
				--JOIN	tblRiskAssessmentResultSection rs ON rs.RiskAssessmentSectionID = tmp.RiskAssessmentSectionID
				--JOIN	tblRiskAssessmentResultMedia rm ON rm.RiskAssessmentResultMediaID = rs.RiskAssessmentResultMediaID
				--JOIN	tblRiskAssessmentAnswer ra ON ra.RiskAssessmentAnswerID = tmp.RiskAssessmentAnswerID
				--WHERE	rm.RiskAssessmentResultMediaID = @RiskAssessmentResultMediaID
				
				-- MediaType = Air
				IF @MediaTypeID = 1
				BEGIN
					-- remove existing pollutant data for the current media type...
					--DELETE	air
					--FROM	tblRiskAssessmentResultAirPollutant air
					--JOIN	tblRiskAssessmentResultSection rs ON rs.RiskAssessmentResultSectionID = air.RiskAssessmentResultSectionID
					--WHERE	rs.RiskAssessmentResultMediaID = @RiskAssessmentResultMediaID

					-- insert new pollutants
					--INSERT INTO tblRiskAssessmentResultAirPollutant (
					--		RiskAssessmentResultSectionID,
					--		RiskAssessmentAirPollutantID,
					--		CreatedBySystemUserID,
					--		DateCreated,
					--		UpdatedBySystemUserID,
					--		DateUpdated )
					--SELECT	rs.RiskAssessmentResultSectionID,
					--		pollutant.RiskAssessmentAirPollutantID,
					--		@SystemUserID,
					--		GETDATE(),
					--		@SystemUserID,
					--		GETDATE()
					--FROM	@tblRiskAssessmentResultPollutant tmp
					--JOIN	tblRiskAssessmentResultSection rs ON rs.RiskAssessmentSectionID = tmp.RiskAssessmentSectionID
					--JOIN	tblRiskAssessmentResultMedia rm ON rm.RiskAssessmentResultMediaID = rs.RiskAssessmentResultMediaID
					--JOIN	tblRiskAssessmentAirPollutant pollutant ON pollutant.RiskAssessmentAirPollutantID = tmp.RiskAssessmentPollutantID
					--WHERE	rm.RiskAssessmentResultMediaID = @RiskAssessmentResultMediaID

					-- update the pollutant score
					UPDATE	tmp
					SET		RiskScore = (	SELECT	MAX(pollutant.Score)
											FROM	@tblRiskAssessmentResultPollutant tmp
											JOIN	tblRiskAssessmentResultSection rs ON rs.RiskAssessmentSectionID = tmp.RiskAssessmentSectionID
											JOIN	tblRiskAssessmentResultMedia rm ON rm.RiskAssessmentResultMediaID = rs.RiskAssessmentResultMediaID
											JOIN	tblRiskAssessmentAirPollutant pollutant ON pollutant.RiskAssessmentAirPollutantID = tmp.RiskAssessmentPollutantID
											WHERE	rm.RiskAssessmentResultMediaID = @RiskAssessmentResultMediaID)
					FROM	@tblRiskAssessmentSectionScore tmp
					WHERE	tmp.RiskAssessmentSectionID = 2
				END
				ELSE IF @MediaTypeID = 2 -- MediaType = Water
				BEGIN			
					-- remove existing hazard pollutant data for the current media type...
					--DELETE	hazard
					--FROM	tblRiskAssessmentResultWaterHazardPollutant hazard
					--JOIN	tblRiskAssessmentResultSection rs ON rs.RiskAssessmentResultSectionID = hazard.RiskAssessmentResultSectionID
					--WHERE	rs.RiskAssessmentResultMediaID = @RiskAssessmentResultMediaID
					
					-- insert new hazrad pollutants
					--INSERT INTO tblRiskAssessmentResultWaterHazardPollutant (
					--		RiskAssessmentResultSectionID,
					--		RiskAssessmentWaterHazardPollutantID,
					--		CreatedBySystemUserID,
					--		DateCreated,
					--		UpdatedBySystemUserID,
					--		DateUpdated )
					--SELECT	rs.RiskAssessmentResultSectionID,
					--		hazardpollutant.RiskAssessmentWaterHazardPollutantID,
					--		@SystemUserID,
					--		GETDATE(),
					--		@SystemUserID,
					--		GETDATE()
					--FROM	@tblRiskAssessmentResultWaterHazardPollutant tmp
					--JOIN	tblRiskAssessmentResultSection rs ON rs.RiskAssessmentSectionID = tmp.RiskAssessmentSectionID
					--JOIN	tblRiskAssessmentResultMedia rm ON rm.RiskAssessmentResultMediaID = rs.RiskAssessmentResultMediaID
					--JOIN	tblRiskAssessmentWaterHazardPollutant hazardpollutant ON hazardpollutant.RiskAssessmentWaterHazardPollutantID = tmp.RiskAssessmentWaterHazardPollutantID
					--WHERE	rm.RiskAssessmentResultMediaID = @RiskAssessmentResultMediaID
								
					-- remove existing water pollutant data for the current media type...
					--DELETE	waterpollutant
					--FROM	tblRiskAssessmentResultWaterPollutant waterpollutant
					--JOIN	tblRiskAssessmentResultWaterType watertype ON watertype.RiskAssessmentResultWaterTypeID = waterpollutant.RiskAssessmentResultWaterTypeID
					--JOIN	tblRiskAssessmentResultSection rs ON rs.RiskAssessmentResultSectionID = watertype.RiskAssessmentResultSectionID
					--WHERE	rs.RiskAssessmentResultMediaID = @RiskAssessmentResultMediaID
					
					-- remove existing water type data for the current media type...
					--DELETE	watertype
					--FROM	tblRiskAssessmentResultWaterType watertype
					--JOIN	tblRiskAssessmentResultSection rs ON rs.RiskAssessmentResultSectionID = watertype.RiskAssessmentResultSectionID
					--WHERE	rs.RiskAssessmentResultMediaID = @RiskAssessmentResultMediaID
					
					DECLARE @WaterTypeRASectionID AS INT,
							@WaterTypeRAWaterTypeID AS INT,
							@WaterTypeResultID AS INT
					
					DECLARE watertypecursor cursor for
						SELECT DISTINCT	rs.RiskAssessmentResultSectionID,
							tmp.RiskAssessmentWaterTypeID
					FROM	@tblRiskAssessmentResultWaterType tmp
					JOIN	tblRiskAssessmentResultSection rs ON rs.RiskAssessmentSectionID = tmp.RiskAssessmentSectionID
					JOIN	tblRiskAssessmentResultMedia rm ON rm.RiskAssessmentResultMediaID = rs.RiskAssessmentResultMediaID
					JOIN	tblRiskAssessmentWaterPollutant waterpollutant ON waterpollutant.RiskAssessmentWaterTypeID = tmp.RiskAssessmentWaterTypeID
					WHERE	rm.RiskAssessmentResultMediaID = @RiskAssessmentResultMediaID
					
					--OPEN watertypecursor

					--FETCH NEXT FROM watertypecursor 
					--INTO @WaterTypeRASectionID, @WaterTypeRAWaterTypeID

					--WHILE @@FETCH_STATUS = 0
					--BEGIN
						--INSERT INTO tblRiskAssessmentResultWaterType (
						--	RiskAssessmentResultSectionID,
						--	RiskAssessmentWaterTypeID,
						--	CreatedBySystemUserID,
						--	DateCreated,
						--	UpdatedBySystemUserID,
						--	DateUpdated )
						--	VALUES
						--	(@WaterTypeRASectionID,
						--	@WaterTypeRAWaterTypeID,
						--	@SystemUserID,
						--	GETDATE(),
						--	@SystemUserID,
						--	GETDATE()
						--	)
							
						--	select @WaterTypeResultID = @@IDENTITY
							
							--INSERT INTO tblRiskAssessmentResultWaterPollutant (
							--RiskAssessmentResultWaterTypeID,
							--RiskAssessmentWaterPollutantID,
							--CreatedBySystemUserID,
							--DateCreated,
							--UpdatedBySystemUserID,
							--DateUpdated )
							--SELECT	@WaterTypeResultID,
							--		waterpollutant.RiskAssessmentWaterPollutantID,
							--		@SystemUserID,
							--		GETDATE(),
							--		@SystemUserID,
							--		GETDATE()
							--FROM	@tblRiskAssessmentResultWaterPollutant tmp
							--JOIN	tblRiskAssessmentWaterPollutant waterpollutant ON waterpollutant.PollutantID = tmp.RiskAssessmentPollutantID AND waterpollutant.RiskAssessmentWaterTypeID = tmp.RiskAssessmentWaterTypeID
							--WHERE	tmp.RiskAssessmentWaterTypeID = @WaterTypeRAWaterTypeID							
					
					--	FETCH NEXT FROM watertypecursor 
					--	INTO @WaterTypeRASectionID, @WaterTypeRAWaterTypeID
					--END 
					--CLOSE watertypecursor;
					--DEALLOCATE watertypecursor;
					
					-- update the hazard pollutant score
					UPDATE	tmp
					SET		RiskScore = (	SELECT	MAX(hazardpollutant.Score)
											FROM	@tblRiskAssessmentResultWaterHazardPollutant tmp
											JOIN	tblRiskAssessmentResultSection rs ON rs.RiskAssessmentSectionID = tmp.RiskAssessmentSectionID
											JOIN	tblRiskAssessmentResultMedia rm ON rm.RiskAssessmentResultMediaID = rs.RiskAssessmentResultMediaID
											JOIN	tblRiskAssessmentWaterHazardPollutant hazardpollutant ON hazardpollutant.RiskAssessmentWaterHazardPollutantID = tmp.RiskAssessmentWaterHazardPollutantID
											WHERE	rm.RiskAssessmentResultMediaID = @RiskAssessmentResultMediaID)
					FROM	@tblRiskAssessmentSectionScore tmp
					WHERE	tmp.RiskAssessmentSectionID = 9
					
					-- update the water pollutant score
					DECLARE @WaterPollutantScore AS INT
					
					SELECT	@WaterPollutantScore = MAX(waterpollutant.Score)
													FROM	@tblRiskAssessmentResultWaterPollutant tmp
													JOIN	tblRiskAssessmentResultSection rs ON rs.RiskAssessmentSectionID = tmp.RiskAssessmentSectionID
													JOIN	tblRiskAssessmentResultMedia rm ON rm.RiskAssessmentResultMediaID = rs.RiskAssessmentResultMediaID
													JOIN	tblRiskAssessmentWaterPollutant waterpollutant ON waterpollutant.PollutantID = tmp.RiskAssessmentPollutantID AND waterpollutant.RiskAssessmentWaterTypeID = tmp.RiskAssessmentWaterTypeID
													WHERE	rm.RiskAssessmentResultMediaID = @RiskAssessmentResultMediaID
													
					--IF EXISTS(SELECT * FROM tblRiskAssessmentResultAnswer rara 
					--		JOIN tblRiskAssessmentResultSection rs ON rara.RiskAssessmentResultSectionID = rs.RiskAssessmentResultSectionID
					--		JOIN tblRiskAssessmentResultMedia rm ON rm.RiskAssessmentResultMediaID = rs.RiskAssessmentResultMediaID
					--		JOIN tblRiskAssessmentAnswer ra ON rara.RiskAssessmentAnswerID = ra.RiskAssessmentAnswerID
					--		WHERE rm.InstrumentID = @InstrumentID AND rs.RiskAssessmentSectionID = 11 AND ra.RiskAssessmentQuestionID = 47)
					--	BEGIN							
					--		IF(SELECT LOWER(ra.AnswerDescription) FROM tblRiskAssessmentResultAnswer rara 
					--		JOIN tblRiskAssessmentResultSection rs ON rara.RiskAssessmentResultSectionID = rs.RiskAssessmentResultSectionID
					--		JOIN tblRiskAssessmentResultMedia rm ON rm.RiskAssessmentResultMediaID = rs.RiskAssessmentResultMediaID
					--		JOIN tblRiskAssessmentAnswer ra ON rara.RiskAssessmentAnswerID = ra.RiskAssessmentAnswerID
					--		WHERE rm.InstrumentID = @InstrumentID AND rs.RiskAssessmentSectionID = 11 AND ra.RiskAssessmentQuestionID = 47) = 'yes'
					--			BEGIN
					--				IF(SELECT COUNT(*) FROM tblRiskAssessmentResultWaterType rwt
					--					JOIN tblRiskAssessmentResultSection rs on rwt.RiskAssessmentResultSectionID = rs.RiskAssessmentResultSectionID
					--					JOIN tblRiskAssessmentResultMedia rm on rs.RiskAssessmentResultMediaID = rm.RiskAssessmentResultMediaID
					--					WHERE rm.InstrumentID = @InstrumentID) > 1
					--					BEGIN
					--						--SET @WaterPollutantScore = @WaterPollutantScore + 1

					--						-----------------  PALMS V6.3
					--						SELECT @WaterPollutantScore = ra.Score FROM tblRiskAssessmentResultAnswer rara 
					--						JOIN tblRiskAssessmentResultSection rs ON rara.RiskAssessmentResultSectionID = rs.RiskAssessmentResultSectionID
					--						JOIN tblRiskAssessmentResultMedia rm ON rm.RiskAssessmentResultMediaID = rs.RiskAssessmentResultMediaID
					--						JOIN tblRiskAssessmentAnswer ra ON rara.RiskAssessmentAnswerID = ra.RiskAssessmentAnswerID
					--						WHERE rm.InstrumentID = @InstrumentID AND rs.RiskAssessmentSectionID = 11 AND ra.RiskAssessmentQuestionID = 47


					--					END
					--				ELSE
					--					BEGIN
					--						SELECT @WaterPollutantScore = ra.Score FROM tblRiskAssessmentResultAnswer rara 
					--						JOIN tblRiskAssessmentResultSection rs ON rara.RiskAssessmentResultSectionID = rs.RiskAssessmentResultSectionID
					--						JOIN tblRiskAssessmentResultMedia rm ON rm.RiskAssessmentResultMediaID = rs.RiskAssessmentResultMediaID
					--						JOIN tblRiskAssessmentAnswer ra ON rara.RiskAssessmentAnswerID = ra.RiskAssessmentAnswerID
					--						WHERE rm.InstrumentID = @InstrumentID AND rs.RiskAssessmentSectionID = 11 AND ra.RiskAssessmentQuestionID = 47
					--					END
					--			END
								
							--IF(SELECT LOWER(ra.AnswerDescription) FROM tblRiskAssessmentResultAnswer rara 
							--JOIN tblRiskAssessmentResultSection rs ON rara.RiskAssessmentResultSectionID = rs.RiskAssessmentResultSectionID
							--JOIN tblRiskAssessmentResultMedia rm ON rm.RiskAssessmentResultMediaID = rs.RiskAssessmentResultMediaID
							--JOIN tblRiskAssessmentAnswer ra ON rara.RiskAssessmentAnswerID = ra.RiskAssessmentAnswerID
							--WHERE rm.InstrumentID = @InstrumentID AND rs.RiskAssessmentSectionID = 11 AND ra.RiskAssessmentQuestionID = 47) = 'no'
							--	BEGIN
							--		IF(SELECT COUNT(*) FROM tblRiskAssessmentResultWaterType rwt
							--			JOIN tblRiskAssessmentResultSection rs on rwt.RiskAssessmentResultSectionID = rs.RiskAssessmentResultSectionID
							--			JOIN tblRiskAssessmentResultMedia rm on rs.RiskAssessmentResultMediaID = rm.RiskAssessmentResultMediaID
							--			WHERE rm.InstrumentID = @InstrumentID) > 1
							--			BEGIN
							--				SET @WaterPollutantScore = @WaterPollutantScore + 1
							--			END
							--	END
								
						END
						
						if(@WaterPollutantScore > 5)
							BEGIN
								SET @WaterPollutantScore = 5
							END
										
						UPDATE	tmp
							SET		RiskScore = @WaterPollutantScore
							FROM	@tblRiskAssessmentSectionScore tmp
							WHERE	tmp.RiskAssessmentSectionID = 11
				END

				--ELSE IF @MediaTypeID = 3 -- MediaType = Noise
				--	BEGIN
				--		--Set score of section 17 to null because there is an exception
				--		--for this section later on in this stored proc
				--		UPDATE rs
				--			SET RiskScore = NULL 
				--			FROM tblRiskAssessmentResultSection rs JOIN tblRiskAssessmentResultMedia rm 
				--				ON rs.RiskAssessmentResultMediaID = rm.RiskAssessmentResultMediaID
				--			WHERE rm.InstrumentID = @InstrumentID AND rs.RiskAssessmentSectionID = 17
				--	END
				
				-- update the zone score
				UPDATE	tmp
				SET		RiskScore = (	SELECT	MAX(raz.Score)
										FROM	tblRiskAssessmentResultAssessmentZone result
										JOIN	tblRiskAssessmentZone raz ON raz.RiskAssessmentZoneID = result.RiskAssessmentZoneID
										JOIN	tblRiskAssessmentResultSection rs ON rs.RiskAssessmentResultSectionID = result.RiskAssessmentResultSectionID
										WHERE	rs.RiskAssessmentResultMediaID = @RiskAssessmentResultMediaID)
				FROM	@tblRiskAssessmentSectionScore tmp
				WHERE	tmp.RiskAssessmentSectionID = 7
				AND		@MediaTypeID = 1
				
				--Water - Section 10 can have a max score of 5
				UPDATE @tblRiskAssessmentSectionScore
				SET RiskScore = 5
				WHERE RiskAssessmentSectionID = 10 AND RiskScore > 5
				
				--Noise - Section 16 can have a max score of 5
				UPDATE @tblRiskAssessmentSectionScore
				SET RiskScore = 5
				WHERE RiskAssessmentSectionID = 16 AND RiskScore > 5
				
				--Noise - Section 16 can have a min score of 1
				UPDATE @tblRiskAssessmentSectionScore
				SET RiskScore = 1
				WHERE RiskAssessmentSectionID = 16 AND RiskScore < 1
				
				--Incident - Section 23 can have a max score of 5
				UPDATE @tblRiskAssessmentSectionScore
				SET RiskScore = 5
				WHERE RiskAssessmentSectionID = 23 AND RiskScore > 5

				--------------------- PALMS v5.2 -----------------------
				UPDATE @tblRiskAssessmentSectionScore
				SET RiskScore = 1
				WHERE RiskScore < 1

				----------------------------------------------------------

				
				-- update the "Section" score...
				--UPDATE	rs
				--SET		rs.RiskScore = tmp.RiskScore,
				--		rs.DateUpdated = GETDATE(),
				--		rs.UpdatedBySystemUserID = @SystemUserID
				--FROM	tblRiskAssessmentResultSection rs
				--JOIN	@tblRiskAssessmentSectionScore tmp ON tmp.RiskAssessmentResultSectionID = rs.RiskAssessmentResultSectionID
				
				-- update the "Media" score...
				--SET @Score = NULL
				
				-- get the total score for the media...
				-- Turning this off because we have a store proc uspRiskCalculateOverallSummaryByMediaID which calculates the total section score
				--SELECT	@Score = SUM(ISNULL(rs.RiskScore, 0))
				--FROM	tblRiskAssessmentResultSection rs
				--JOIN	tblRiskAssessmentResultMedia rm ON rm.RiskAssessmentResultMediaID = rs.RiskAssessmentResultMediaID
				--WHERE	rm.RiskAssessmentResultMediaID = @RiskAssessmentResultMediaID
				
				--UPDATE	rm
				--SET		rm.CalculatedRiskScore = @Score
				--FROM	tblRiskAssessmentResultMedia rm
				--WHERE	RiskAssessmentResultMediaID = @RiskAssessmentResultMediaID
				
				-- Validate Sensitivity of noise receivers as per requirement				
				--Proximity to sensitive receivers score
				--EXEC uspSaveERAssessmentNoiseAirProximityScore @InstrumentID				
				
				--******There is an exception when Air - Are there any air emissions? is answered no*******
				--Below logic will cater for that exception					
				--EXEC uspSaveERAssessmentAirEmissionHazardLevelScore @InstrumentID
				
				--Section 8 - Water exception
				--IF(@MediaTypeID = 3)
				--BEGIN
				--	EXEC uspSaveERAssessmentWaterPotentialForDischargesScore @InstrumentID
				--END
				--******There is an exception when Water - Does the activity have any diffuse discharges to waters?  is answered no*******
				--Below logic will cater for that exception					
				--EXEC uspSaveERAssessmentWaterDiffuseChargesHazardLevelAndPollutantScore @InstrumentID				
				
				--Water proximity score for Incidents
				--EXEC uspSaveERAssessmentIncidentsWaterProximityScore @InstrumentID
				
				--Exceptional step - If questions 25 and 26 been answered no then Nuisance level of noise from activities 
				--automatically scores 1 and disable
				--IF(@MediaTypeID = 3)
				--BEGIN
				--	EXEC uspSaveERAssessmentNoiseNuisanceLevelScore @InstrumentID
				--END	
				
				--EXEC dbo.uspRiskCalculateOverallSummaryByMediaID @InstrumentID
				
				--Exec [dbo].[uspAuditLogInsert] @InstrumentID,'Update','environment licence risk assessment',@SystemUserId,@SystemUserId
				
				--UPDATE ra
				--SET	DateUpdated = GETDATE(),
				--	UpdatedBySystemUserID = @SystemUserID							
				--FROM tblRiskAssessment ra WHERE InstrumentID = @InstrumentID

				----------------------------------------------------------------------------------------------------------------------
				--added in 16-10-2014 as we moved Major Environmental Harm flag question from details tab into incident tab
				--we need update this flag when it is in incident tab
				--IF @MediaTypeID = 4
				--BEGIN
				--        --;WITH XMLNAMESPACES(DEFAULT 'http://tempuri.org/DataRiskERAssessment.xsd')
				--		INSERT INTO @tblRiskAssessment (
				--				InstrumentID,
				--				AssessmentReasonID,
				--				ResponsibleSystemUserID,
				--				DECCWSectionID,
				--				ConditionAssessedFlag,
				--				LicenceReviewCompletedFlag,
				--				LicenceVariedFlag,
				--				ReviewComments,
				--				MajorEnvironmentalHarmFlag )
				--		SELECT	RN.S.value('InstrumentID[1]','int'),
				--				RN.S.value('AssessmentReasonID[1]','int'),
				--				RN.S.value('ResponsibleSystemUserID[1]','int'),
				--				RN.S.value('DECCWSectionID[1]','int'),
				--				RN.S.value('ConditionAssessedFlag[1]','bit'),
				--				RN.S.value('LicenceReviewCompletedFlag[1]','bit'),
				--				RN.S.value('LicenceVariedFlag[1]','bit'),
				--				RN.S.value('ReviewComments[1]','varchar(500)'),
				--				RN.S.value('MajorEnvironmentalHarmFlag[1]','bit')
				--		FROM	@theXmlData.nodes('/DataRiskERAssessment/RiskAssessment') as RN(S)
				
				--		----------------------- PALMS V5.1 ------------------
				--		UPDATE ra        						 
				--	    SET MajorEnvironmentalHarmFlag = tmp.MajorEnvironmentalHarmFlag								
				--		FROM tblRiskAssessment ra
				--		INNER JOIN @tblRiskAssessment tmp ON ra.InstrumentID = tmp.InstrumentID


				--		---------------------- PALMS V5.1 ------------------
				--		DECLARE @MajorEnvironmentalHarmFlag BIT

				--		IF EXISTS(SELECT * FROM tblRiskAssessment WHERE InstrumentID = @InstrumentID AND MajorEnvironmentalHarmFlag >= 0)
				--		BEGIN
				--			EXEC dbo.uspRiskCalculateOverallSummaryByMediaID @InstrumentID							 
				--		END
						 				
				--		Exec [dbo].[uspAuditLogInsert] @InstrumentID,'Update','environment licence risk assessment',@SystemUserId,@SystemUserId		
				----------------------------------------------------------------------------------------------------------- 
				--END
		       
			   select
			    RiskAssessmentResultSection.RiskAssessmentResultMediaID, 			    
			    RiskAssessmentResultSection.RiskAssessmentResultSectionID,
				RiskAssessmentResultSection.RiskAssessmentMediaID,
				RiskAssessmentResultSection.RiskAssessmentSectionID,
				RiskAssessmentResultSection.RiskScore, 
				RiskAssessmentResultSection.CreatedBySystemUserID
				from @tblRiskAssessmentSectionScore as RiskAssessmentResultSection
	END TRY
	BEGIN CATCH
		DECLARE @ErrorMessage VARCHAR(2000)
		
		SET @ErrorMessage = dbo.ufn_GetErrorText()
		
		RAISERROR (@ErrorMessage , 16, 1)
	END CATCH
END