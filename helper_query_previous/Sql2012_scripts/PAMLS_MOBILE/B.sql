declare @theXmlData xml
declare @majorHarm int = null
set @majorHarm = 0

set @theXmlData = 
'<DataRiskERAssessment>
  <RiskAssessmentResultSection>
    <RiskAssessmentResultSectionID>-1</RiskAssessmentResultSectionID>
    <RiskAssessmentResultMediaID>1</RiskAssessmentResultMediaID>
    <RiskAssessmentSectionID>1</RiskAssessmentSectionID>
    <RiskAssessmentMediaID>1</RiskAssessmentMediaID>
    <RiskScore>4</RiskScore>
    <DateCreated>2014-12-12T16:39:11.1528483+11:00</DateCreated>
    <CreatedBySystemUserID>1378</CreatedBySystemUserID>
  </RiskAssessmentResultSection>
  <RiskAssessmentResultSection>
    <RiskAssessmentResultSectionID>-2</RiskAssessmentResultSectionID>
    <RiskAssessmentResultMediaID>1</RiskAssessmentResultMediaID>
    <RiskAssessmentSectionID>2</RiskAssessmentSectionID>
    <RiskAssessmentMediaID>1</RiskAssessmentMediaID>
    <RiskScore>0</RiskScore>
    <DateCreated>2014-12-12T16:39:11.1528483+11:00</DateCreated>
    <CreatedBySystemUserID>1378</CreatedBySystemUserID>
  </RiskAssessmentResultSection>
  <RiskAssessmentResultSection>
    <RiskAssessmentResultSectionID>-3</RiskAssessmentResultSectionID>
    <RiskAssessmentResultMediaID>1</RiskAssessmentResultMediaID>
    <RiskAssessmentSectionID>3</RiskAssessmentSectionID>
    <RiskAssessmentMediaID>1</RiskAssessmentMediaID>
    <RiskScore>3</RiskScore>
    <DateCreated>2014-12-12T16:39:11.1528483+11:00</DateCreated>
    <CreatedBySystemUserID>1378</CreatedBySystemUserID>
  </RiskAssessmentResultSection>
  <RiskAssessmentResultSection>
    <RiskAssessmentResultSectionID>-4</RiskAssessmentResultSectionID>
    <RiskAssessmentResultMediaID>1</RiskAssessmentResultMediaID>
    <RiskAssessmentSectionID>4</RiskAssessmentSectionID>
    <RiskAssessmentMediaID>1</RiskAssessmentMediaID>
    <RiskScore>1</RiskScore>
    <DateCreated>2014-12-12T16:39:11.1528483+11:00</DateCreated>
    <CreatedBySystemUserID>1378</CreatedBySystemUserID>
  </RiskAssessmentResultSection>
  <RiskAssessmentResultSection>
    <RiskAssessmentResultSectionID>-5</RiskAssessmentResultSectionID>
    <RiskAssessmentResultMediaID>1</RiskAssessmentResultMediaID>
    <RiskAssessmentSectionID>5</RiskAssessmentSectionID>
    <RiskAssessmentMediaID>1</RiskAssessmentMediaID>
    <RiskScore>1</RiskScore>
    <DateCreated>2014-12-12T16:39:11.1528483+11:00</DateCreated>
    <CreatedBySystemUserID>1378</CreatedBySystemUserID>
  </RiskAssessmentResultSection>
  <RiskAssessmentResultSection>
    <RiskAssessmentResultSectionID>-6</RiskAssessmentResultSectionID>
    <RiskAssessmentResultMediaID>1</RiskAssessmentResultMediaID>
    <RiskAssessmentSectionID>6</RiskAssessmentSectionID>
    <RiskAssessmentMediaID>1</RiskAssessmentMediaID>
    <RiskScore>4</RiskScore>
    <DateCreated>2014-12-12T16:39:11.1528483+11:00</DateCreated>
    <CreatedBySystemUserID>1378</CreatedBySystemUserID>
  </RiskAssessmentResultSection>
  <RiskAssessmentResultSection>
    <RiskAssessmentResultSectionID>-7</RiskAssessmentResultSectionID>
    <RiskAssessmentResultMediaID>1</RiskAssessmentResultMediaID>
    <RiskAssessmentSectionID>7</RiskAssessmentSectionID>
    <RiskAssessmentMediaID>1</RiskAssessmentMediaID>
    <RiskScore>1</RiskScore>
    <DateCreated>2014-12-12T16:39:11.1528483+11:00</DateCreated>
    <CreatedBySystemUserID>1378</CreatedBySystemUserID>
  </RiskAssessmentResultSection>
  <RiskAssessmentResultSection>
    <RiskAssessmentResultSectionID>-8</RiskAssessmentResultSectionID>
    <RiskAssessmentResultMediaID>2</RiskAssessmentResultMediaID>
    <RiskAssessmentSectionID>8</RiskAssessmentSectionID>
    <RiskAssessmentMediaID>2</RiskAssessmentMediaID>
    <RiskScore>1</RiskScore>
    <DateCreated>2014-12-12T16:39:11.2088483+11:00</DateCreated>
    <CreatedBySystemUserID>1378</CreatedBySystemUserID>
  </RiskAssessmentResultSection>
  <RiskAssessmentResultSection>
    <RiskAssessmentResultSectionID>-9</RiskAssessmentResultSectionID>
    <RiskAssessmentResultMediaID>2</RiskAssessmentResultMediaID>
    <RiskAssessmentSectionID>9</RiskAssessmentSectionID>
    <RiskAssessmentMediaID>2</RiskAssessmentMediaID>
    <RiskScore>0</RiskScore>
    <DateCreated>2014-12-12T16:39:11.2088483+11:00</DateCreated>
    <CreatedBySystemUserID>1378</CreatedBySystemUserID>
  </RiskAssessmentResultSection>
  <RiskAssessmentResultSection>
    <RiskAssessmentResultSectionID>-10</RiskAssessmentResultSectionID>
    <RiskAssessmentResultMediaID>2</RiskAssessmentResultMediaID>
    <RiskAssessmentSectionID>10</RiskAssessmentSectionID>
    <RiskAssessmentMediaID>2</RiskAssessmentMediaID>
    <RiskScore>5</RiskScore>
    <DateCreated>2014-12-12T16:39:11.2088483+11:00</DateCreated>
    <CreatedBySystemUserID>1378</CreatedBySystemUserID>
  </RiskAssessmentResultSection>
  <RiskAssessmentResultSection>
    <RiskAssessmentResultSectionID>-11</RiskAssessmentResultSectionID>
    <RiskAssessmentResultMediaID>2</RiskAssessmentResultMediaID>
    <RiskAssessmentSectionID>11</RiskAssessmentSectionID>
    <RiskAssessmentMediaID>2</RiskAssessmentMediaID>
    <RiskScore>0</RiskScore>
    <DateCreated>2014-12-12T16:39:11.2088483+11:00</DateCreated>
    <CreatedBySystemUserID>1378</CreatedBySystemUserID>
  </RiskAssessmentResultSection>
  <RiskAssessmentResultSection>
    <RiskAssessmentResultSectionID>-12</RiskAssessmentResultSectionID>
    <RiskAssessmentResultMediaID>3</RiskAssessmentResultMediaID>
    <RiskAssessmentSectionID>16</RiskAssessmentSectionID>
    <RiskAssessmentMediaID>3</RiskAssessmentMediaID>
    <RiskScore>4</RiskScore>
    <DateCreated>2014-12-12T16:39:11.2348483+11:00</DateCreated>
    <CreatedBySystemUserID>1378</CreatedBySystemUserID>
  </RiskAssessmentResultSection>
  <RiskAssessmentResultSection>
    <RiskAssessmentResultSectionID>-13</RiskAssessmentResultSectionID>
    <RiskAssessmentResultMediaID>3</RiskAssessmentResultMediaID>
    <RiskAssessmentSectionID>17</RiskAssessmentSectionID>
    <RiskAssessmentMediaID>3</RiskAssessmentMediaID>
    <RiskScore>1</RiskScore>
    <DateCreated>2014-12-12T16:39:11.2348483+11:00</DateCreated>
    <CreatedBySystemUserID>1378</CreatedBySystemUserID>
  </RiskAssessmentResultSection>
  <RiskAssessmentResultSection>
    <RiskAssessmentResultSectionID>-14</RiskAssessmentResultSectionID>
    <RiskAssessmentResultMediaID>3</RiskAssessmentResultMediaID>
    <RiskAssessmentSectionID>18</RiskAssessmentSectionID>
    <RiskAssessmentMediaID>3</RiskAssessmentMediaID>
    <RiskScore>0</RiskScore>
    <DateCreated>2014-12-12T16:39:11.2348483+11:00</DateCreated>
    <CreatedBySystemUserID>1378</CreatedBySystemUserID>
  </RiskAssessmentResultSection>
  <RiskAssessmentResultSection>
    <RiskAssessmentResultSectionID>-15</RiskAssessmentResultSectionID>
    <RiskAssessmentResultMediaID>3</RiskAssessmentResultMediaID>
    <RiskAssessmentSectionID>19</RiskAssessmentSectionID>
    <RiskAssessmentMediaID>3</RiskAssessmentMediaID>
    <RiskScore>1</RiskScore>
    <DateCreated>2014-12-12T16:39:11.2348483+11:00</DateCreated>
    <CreatedBySystemUserID>1378</CreatedBySystemUserID>
  </RiskAssessmentResultSection>
  <RiskAssessmentResultSection>
    <RiskAssessmentResultSectionID>-16</RiskAssessmentResultSectionID>
    <RiskAssessmentResultMediaID>4</RiskAssessmentResultMediaID>
    <RiskAssessmentSectionID>20</RiskAssessmentSectionID>
    <RiskAssessmentMediaID>4</RiskAssessmentMediaID>
    <RiskScore>0</RiskScore>
    <DateCreated>2014-12-12T16:39:11.2438483+11:00</DateCreated>
    <CreatedBySystemUserID>1378</CreatedBySystemUserID>
  </RiskAssessmentResultSection>
  <RiskAssessmentResultSection>
    <RiskAssessmentResultSectionID>-17</RiskAssessmentResultSectionID>
    <RiskAssessmentResultMediaID>4</RiskAssessmentResultMediaID>
    <RiskAssessmentSectionID>22</RiskAssessmentSectionID>
    <RiskAssessmentMediaID>4</RiskAssessmentMediaID>
    <RiskScore>0</RiskScore>
    <DateCreated>2014-12-12T16:39:11.2438483+11:00</DateCreated>
    <CreatedBySystemUserID>1378</CreatedBySystemUserID>
  </RiskAssessmentResultSection>
  <RiskAssessmentResultSection>
    <RiskAssessmentResultSectionID>-18</RiskAssessmentResultSectionID>
    <RiskAssessmentResultMediaID>4</RiskAssessmentResultMediaID>
    <RiskAssessmentSectionID>23</RiskAssessmentSectionID>
    <RiskAssessmentMediaID>4</RiskAssessmentMediaID>
    <RiskScore>0</RiskScore>
    <DateCreated>2014-12-12T16:39:11.2438483+11:00</DateCreated>
    <CreatedBySystemUserID>1378</CreatedBySystemUserID>
  </RiskAssessmentResultSection>
  <RiskAssessmentResultSection>
    <RiskAssessmentResultSectionID>-19</RiskAssessmentResultSectionID>
    <RiskAssessmentResultMediaID>4</RiskAssessmentResultMediaID>
    <RiskAssessmentSectionID>24</RiskAssessmentSectionID>
    <RiskAssessmentMediaID>4</RiskAssessmentMediaID>
    <RiskScore>0</RiskScore>
    <DateCreated>2014-12-12T16:39:11.2438483+11:00</DateCreated>
    <CreatedBySystemUserID>1378</CreatedBySystemUserID>
  </RiskAssessmentResultSection>
  <RiskAssessmentResultSection>
    <RiskAssessmentResultSectionID>-20</RiskAssessmentResultSectionID>
    <RiskAssessmentResultMediaID>4</RiskAssessmentResultMediaID>
    <RiskAssessmentSectionID>25</RiskAssessmentSectionID>
    <RiskAssessmentMediaID>4</RiskAssessmentMediaID>
    <RiskScore>0</RiskScore>
    <DateCreated>2014-12-12T16:39:11.2438483+11:00</DateCreated>
    <CreatedBySystemUserID>1378</CreatedBySystemUserID>
  </RiskAssessmentResultSection>
  <RiskAssessmentResultSection>
    <RiskAssessmentResultSectionID>-21</RiskAssessmentResultSectionID>
    <RiskAssessmentResultMediaID>4</RiskAssessmentResultMediaID>
    <RiskAssessmentSectionID>26</RiskAssessmentSectionID>
    <RiskAssessmentMediaID>4</RiskAssessmentMediaID>
    <RiskScore>0</RiskScore>
    <DateCreated>2014-12-12T16:39:11.2438483+11:00</DateCreated>
    <CreatedBySystemUserID>1378</CreatedBySystemUserID>
  </RiskAssessmentResultSection>
  <RiskAssessmentResultSection>
    <RiskAssessmentResultSectionID>-22</RiskAssessmentResultSectionID>
    <RiskAssessmentResultMediaID>4</RiskAssessmentResultMediaID>
    <RiskAssessmentSectionID>27</RiskAssessmentSectionID>
    <RiskAssessmentMediaID>4</RiskAssessmentMediaID>
    <RiskScore>0</RiskScore>
    <DateCreated>2014-12-12T16:39:11.2438483+11:00</DateCreated>
    <CreatedBySystemUserID>1378</CreatedBySystemUserID>
  </RiskAssessmentResultSection>
</DataRiskERAssessment>
'

SET NOCOUNT ON;
	
	--temp table to store result section
	DECLARE @tblRiskAssessmentResultSection TABLE 
	(
		ID int identity(1,1),
		RiskAssessmentResultMediaID int,
		RiskAssessmentSectionID int,
		RiskScore int
	)
					
	--temp table to store result media
	declare @tblRiskAssessmentResultMedia TABLE
	(
		[RiskAssessmentResultMediaID] [int] IDENTITY(1,1) NOT NULL,
		[InstrumentID] [int] NOT NULL DEFAULT 1,
		[RiskAssessmentMediaID] [smallint] NOT NULL,
		[CalculatedRiskScore] [int] NULL,
		[RegulatoryPriorityID] [smallint] NULL,
		[DateCreated] [smalldatetime] NOT NULL DEFAULT GETDATE(),
		[CreatedBySystemUserID] [int] NOT NULL DEFAULT 1,
		[DateUpdated] [smalldatetime] NULL,
		[UpdatedBySystemUserID] [int] NULL,
		[RowTimestamp] [timestamp] NOT NULL
	)
	
	
	BEGIN TRY	
		--prepare the water pollutant results data passed in...
		--;WITH XMLNAMESPACES(DEFAULT 'http://tempuri.org/DataRiskERAssessment.xsd')
		INSERT INTO @tblRiskAssessmentResultSection (
				RiskAssessmentResultMediaID,
				RiskAssessmentSectionID,
				RiskScore )
		SELECT	RN.S.value('RiskAssessmentResultMediaID[1]','int'),
				RN.S.value('RiskAssessmentSectionID[1]','int'),
				RN.S.value('RiskScore[1]','int')
		FROM	@theXmlData.nodes('/DataRiskERAssessment/RiskAssessmentResultSection') as RN(S)

--select * from @tblRiskAssessmentResultSection

		--Air calculation
		DECLARE @Air1 INT,
				@Air2 INT,
				@Air3 INT,
				@Air4 INT,
				@Air5 INT,
				@Air6 INT,
				@Air7 INT,
				@AirRiskScore INT,
				@AirRegulatoryPriority SMALLINT
				
		-- Calculate @Air1		
		SELECT @Air1 = RiskScore FROM @tblRiskAssessmentResultSection 
		WHERE 
		RiskAssessmentResultMediaID = 1 
		and RiskAssessmentSectionID = 1

		-- Calculate @Air2
		SELECT @Air2 = RiskScore FROM @tblRiskAssessmentResultSection
		WHERE
		RiskAssessmentResultMediaID = 1 
		AND RiskAssessmentSectionID = 2

		-- Calculate @Air3
		SELECT @Air3 = RiskScore FROM @tblRiskAssessmentResultSection 
		WHERE 
		RiskAssessmentResultMediaID = 1 
		AND RiskAssessmentSectionID = 3

		-- Calculate @Air4
		SELECT @Air4 = RiskScore FROM @tblRiskAssessmentResultSection 
		WHERE 
		RiskAssessmentResultMediaID = 1 
		AND RiskAssessmentSectionID = 4

		-- Calculate @Air5
		SELECT @Air5 = RiskScore FROM @tblRiskAssessmentResultSection 
		WHERE 
		RiskAssessmentResultMediaID = 1 
		AND RiskAssessmentSectionID = 5

		-- Calculate @Air6
		SELECT @Air6 = RiskScore FROM @tblRiskAssessmentResultSection
		WHERE
		RiskAssessmentResultMediaID = 1 
		AND RiskAssessmentSectionID = 6

		-- Calculate @Air7
		SELECT @Air7 = RiskScore FROM @tblRiskAssessmentResultSection 
		WHERE
		RiskAssessmentResultMediaID = 1 
		AND RiskAssessmentSectionID = 7


		--select @PaOAir1 INT,
		--		@PaOAir2 INT,
		--		@PaOAir3 INT,
		--		@EAir INT,
		--		@ECAir1 INT,
		--		@ECAir2 INT,
		--		@ECAir3 INT,
		--		@AirRiskScore INT,
		--		@AirRegulatoryPriority SMALLINT
				
		IF(@Air1 IS NOT NULL
			AND @Air2 IS NOT NULL 
			AND @Air3 IS NOT NULL
			AND @Air4 IS NOT NULL
			AND @Air5 IS NOT NULL
			AND @Air6 IS NOT NULL
			AND @Air7 IS NOT NULL) -- Only calculate when all the fields are available
			BEGIN
				-- Calculate Air Risk Score
				SET @AirRiskScore =
					(@Air1 * (@Air2 + @Air5 + @Air6)) + (@Air4 * (@Air5 + @Air6)) + (@Air3 * @Air7)

				--select * from @tblRiskAssessmentResultSection where RiskAssessmentResultMediaID=1
				
				print 'air step1 score' + convert(varchar,(@Air1 * (@Air2 + @Air5 + @Air7)))
				-- Calculate Air Regulatory Priority
				IF(@Air1 * (@Air2 + @Air5 + @Air6)) >= (SELECT IntermediateThreshold FROM tblRiskAssessmentHighThreshold WHERE RiskAssessmentMediaID = 1)
					BEGIN
						print 'air rule 1 calculation'
						SET @AirRegulatoryPriority = 710
					END
				ELSE IF @AirRiskScore >= (Select HighThreshold FROM tblRiskAssessmentHighThreshold WHERE RiskAssessmentMediaID = 1)
					BEGIN
						SET @AirRegulatoryPriority  = 710								
					END
				ELSE IF @AirRiskScore <= (Select LowThreshold FROM tblRiskAssessmentLowThreshold WHERE RiskAssessmentMediaID = 1)
					BEGIN
						SET @AirRegulatoryPriority = 712								
					END
				ELSE
					BEGIN
						SET @AirRegulatoryPriority = 711								
					END
			END

		IF(@AirRegulatoryPriority IS NOT NULL AND @AirRiskScore IS NOT NULL)
			BEGIN
				insert into @tblRiskAssessmentResultMedia
					(CalculatedRiskScore,RegulatoryPriorityID,RiskAssessmentMediaID)
				values (@AirRiskScore,@AirRegulatoryPriority,1)							
			END	
			
		--WATER
		DECLARE @PaOWater1 INT,
				@EWater INT,
				@ECWater1 INT,
				@ECWater2 INT,
				@WaterRiskScore INT,
				@WaterRegulatoryPriority SMALLINT
		
		-- Calculate PaOWater1		
		SELECT @PaOWater1 = RiskScore FROM @tblRiskAssessmentResultSection 
		WHERE 
		RiskAssessmentResultMediaID = 2
		AND RiskAssessmentSectionID = 8
		
		-- Calculate EWater
		SELECT @EWater = RiskScore FROM @tblRiskAssessmentResultSection 
		WHERE 
		RiskAssessmentResultMediaID = 2
		AND RiskAssessmentSectionID = 9
		
		-- Calculate ECWater1
		SELECT @ECWater1 = RiskScore FROM @tblRiskAssessmentResultSection 
		WHERE 
		RiskAssessmentResultMediaID = 2
		AND RiskAssessmentSectionID = 10
		
		-- Calculate ECWater2
		SELECT @ECWater2 = RiskScore FROM @tblRiskAssessmentResultSection
		WHERE 
		RiskAssessmentResultMediaID = 2 
		AND RiskAssessmentSectionID = 11
		print 'reached here'
		 
		print		@EWater 
			print	@ECWater1 
				print @ECWater2 
				print @PaOWater1 
				print 'end'
		IF(@EWater IS NOT NULL
			AND @ECWater1 IS NOT NULL 
			AND @ECWater2 IS NOT NULL
			AND @PaOWater1 IS NOT NULL) -- Only calculate when all the fields are available
			BEGIN
				print 'water calculation'
				-- Calculate Water Risk Score
				SET @WaterRiskScore =
					(@PaOWater1) * (@EWater + @ECWater1 + @ECWater2)
				
				-- Calculate Water Regulatory Priority
				IF @WaterRiskScore <= (SELECT LowThreshold FROM tblRiskAssessmentLowThreshold WHERE RiskAssessmentMediaID = 2)
					BEGIN
						SET @WaterRegulatoryPriority = 712
					END
				ELSE IF (@WaterRiskScore > (Select LowThreshold FROM tblRiskAssessmentLowThreshold WHERE RiskAssessmentMediaID = 2))
					AND (@WaterRiskScore < (Select HighThreshold FROM tblRiskAssessmentHighThreshold WHERE RiskAssessmentMediaID = 2))
					BEGIN
						SET @WaterRegulatoryPriority = 711								
					END
				ELSE IF @WaterRiskScore >= (Select HighThreshold FROM tblRiskAssessmentHighThreshold WHERE RiskAssessmentMediaID = 2)
					BEGIN
						SET @WaterRegulatoryPriority = 710
					END
			END
			
		IF(@WaterRegulatoryPriority IS NOT NULL AND @WaterRiskScore IS NOT NULL)
			BEGIN
				insert into @tblRiskAssessmentResultMedia
					(CalculatedRiskScore,RegulatoryPriorityID,RiskAssessmentMediaID)
				values (@WaterRiskScore,@WaterRegulatoryPriority,2)
			END

		--Noise
		DECLARE @PaONoise1 INT,
				@ENoise INT,
				@ECNoise1 INT,
				@ECNoise2 INT,
				@NoiseRiskScore INT,
				@NoiseRegulatoryPriority SMALLINT
		
		-- Calculate PaONoise1		
		SELECT @PaONoise1 = RiskScore FROM @tblRiskAssessmentResultSection 
		WHERE RiskAssessmentResultMediaID = 3
		AND RiskAssessmentSectionID = 16
		
		-- Calculate ENoise
		SELECT @ENoise = RiskScore FROM @tblRiskAssessmentResultSection 
		WHERE RiskAssessmentResultMediaID = 3
		AND RiskAssessmentSectionID = 17
		
		-- Calculate ECNoise1- We can get this from Air tab Proximity to sensitive receivers
		SELECT @ECNoise1 = RiskScore FROM @tblRiskAssessmentResultSection 
		WHERE RiskAssessmentResultMediaID = 1
		AND RiskAssessmentSectionID = 5
		
		IF(SELECT RiskScore FROM @tblRiskAssessmentResultSection 
				WHERE RiskAssessmentResultMediaID = 3
				AND RiskAssessmentSectionID = 18) IS NULL
			BEGIN
				UPDATE RAS
				SET RiskScore = @ECNoise1
				FROM @tblRiskAssessmentResultSection RAS
				WHERE 
				 RiskAssessmentResultMediaID = 3
				AND RiskAssessmentSectionID = 18
			END
			
		-- Calculate ECWater2
		SELECT @ECNoise2 = RiskScore FROM @tblRiskAssessmentResultSection 
		WHERE
		RiskAssessmentResultMediaID = 3
		AND RiskAssessmentSectionID = 19
		
		IF(@ENoise IS NOT NULL
			AND @ECNoise1 IS NOT NULL 
			AND @ECNoise2 IS NOT NULL
			AND @PaONoise1 IS NOT NULL) -- Only calculate when all the fields are available
			BEGIN
				-- Calculate Noise Risk Score
				SET @NoiseRiskScore =
					(@PaONoise1) * (@ENoise + @ECNoise1 + @ECNoise2)
				
				-- Calculate Noise Regulatory Priority
				IF @NoiseRiskScore <= (SELECT LowThreshold FROM tblRiskAssessmentLowThreshold WHERE RiskAssessmentMediaID = 3)
					BEGIN
						SET @NoiseRegulatoryPriority = 712
					END
				ELSE IF (@NoiseRiskScore > (Select LowThreshold FROM tblRiskAssessmentLowThreshold WHERE RiskAssessmentMediaID = 3))
					AND (@NoiseRiskScore < (Select HighThreshold FROM tblRiskAssessmentHighThreshold WHERE RiskAssessmentMediaID = 3))
					BEGIN
						SET @NoiseRegulatoryPriority = 711								
					END
				ELSE IF @NoiseRiskScore >= (Select HighThreshold FROM tblRiskAssessmentHighThreshold WHERE RiskAssessmentMediaID = 3)
					BEGIN
						SET @NoiseRegulatoryPriority = 710
					END
			END
			
		IF(@NoiseRegulatoryPriority IS NOT NULL AND @NoiseRiskScore IS NOT NULL)
			BEGIN
				insert into @tblRiskAssessmentResultMedia
				(CalculatedRiskScore,RegulatoryPriorityID,RiskAssessmentMediaID)
				values (@NoiseRiskScore,@NoiseRegulatoryPriority,3)
			END
			
		--Incidents/Pollution
		DECLARE @PaOPollution1 INT,
				@ECPollution1 INT,
				@ECPollution2 INT,
				@ECPollution3 INT,
				@PollutionRiskScore INT,
				@PollutionRegulatoryPriority SMALLINT
		
		-- Calculate PaOPollution1		
		SELECT @PaOPollution1 = RiskScore FROM @tblRiskAssessmentResultSection 
		WHERE RiskAssessmentResultMediaID = 4
		AND RiskAssessmentSectionID = 20
		
		-- Calculate ECPollution1
		SELECT @ECPollution1 = RiskScore FROM @tblRiskAssessmentResultSection 
		WHERE RiskAssessmentResultMediaID = 4
		AND RiskAssessmentSectionID = 23
		
		-- Calculate ECPollution2
		SELECT @ECPollution2 = RiskScore FROM @tblRiskAssessmentResultSection 
		WHERE 
		RiskAssessmentResultMediaID = 4
		AND RiskAssessmentSectionID = 25
		
		-- Calculate ECPollution3 - We can get this from Air tab Proximity to sensitive receivers
		SELECT @ECPollution3 = RiskScore FROM @tblRiskAssessmentResultSection
		WHERE 
		RiskAssessmentResultMediaID = 1
		AND RiskAssessmentSectionID = 5
		
		--UPDATE Section Score
		IF(SELECT RiskScore FROM @tblRiskAssessmentResultSection  
				WHERE 
				RiskAssessmentResultMediaID = 4
				AND RiskAssessmentSectionID = 26) IS NULL
			BEGIN
				UPDATE RAS
				SET RiskScore = @ECPollution3
				FROM @tblRiskAssessmentResultSection RAS 
				WHERE 
				RiskAssessmentResultMediaID = 4
				AND RAS.RiskAssessmentSectionID = 26
			END
		
		IF(@ECPollution1 IS NOT NULL
			AND @ECPollution2 IS NOT NULL 
			AND @ECPollution3 IS NOT NULL
			AND @PaOPollution1 IS NOT NULL) -- Only calculate when all the fields are available
			BEGIN
				-- Calculate Pollution Risk Score
				SET @PollutionRiskScore =
					(@PaOPollution1) * (@ECPollution1 + @ECPollution2 + @ECPollution3)
				
				-- Calculate Pollution Regulatory Priority
				IF @PollutionRiskScore <= (SELECT LowThreshold FROM tblRiskAssessmentLowThreshold WHERE RiskAssessmentMediaID = 4)
					BEGIN
						SET @PollutionRegulatoryPriority = 712
					END
				ELSE IF (@PollutionRiskScore > (Select LowThreshold FROM tblRiskAssessmentLowThreshold WHERE RiskAssessmentMediaID = 4))
					AND (@PollutionRiskScore < (Select HighThreshold FROM tblRiskAssessmentHighThreshold WHERE RiskAssessmentMediaID = 4))
					BEGIN
						SET @PollutionRegulatoryPriority = 711
					END
				ELSE IF @PollutionRiskScore >= (Select HighThreshold FROM tblRiskAssessmentHighThreshold WHERE RiskAssessmentMediaID = 4)
					BEGIN
						SET @PollutionRegulatoryPriority = 710
					END
			END
			
		if @majorHarm = 1
			begin
							insert into @tblRiskAssessmentResultMedia
							(CalculatedRiskScore,RegulatoryPriorityID,RiskAssessmentMediaID)
							values (48,710,4)	
			end
		else
		begin
			IF(@PollutionRegulatoryPriority IS NOT NULL AND @PollutionRiskScore IS NOT NULL)
				BEGIN
			
				 if @majorHarm is null or @majorHarm = 0
					insert into @tblRiskAssessmentResultMedia
					(CalculatedRiskScore,RegulatoryPriorityID,RiskAssessmentMediaID)
					values (@PollutionRiskScore,@PollutionRegulatoryPriority,4)		 
				END
			
		end
			
    --Final output				
	select * from @tblRiskAssessmentResultMedia
			

	END TRY
	BEGIN CATCH
		DECLARE @ErrorMessage VARCHAR(2000)
		
		SET @ErrorMessage = dbo.ufn_GetErrorText()
		
		RAISERROR (@ErrorMessage , 16, 1)
	END CATCH