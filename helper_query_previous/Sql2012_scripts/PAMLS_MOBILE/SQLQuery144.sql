	SELECT Distinct FeeBasedActivity.POEOLicenceFeeBasedActivityID,
		   FeeBasedActivity.InstrumentID,
		   FeeBasedActivity.FeeBasedActivityID,
		   FBA.Description AS FeeBasedActivityName,
		   FBA.PremisesFlag AS Premises,
		   FeeScale.AssessablePollutantFlag AS AssesablePollutants,
		   FeeBasedActivity.FeeBasedActivityScaleID,
		   CASE WHEN FeeScale.GreaterSignFlag=1 THEN '> ' ELSE '' END +
		   ISNULL(CONVERT(VARCHAR,FeeScale.ScaleLowRange),'Any') + --CONVERT(VARCHAR,FeeScale.ScaleLowRange) + 
		   CASE FeeScale.ScaleHighRange WHEN NULL THEN '' ELSE '-' + CONVERT(VARCHAR,FeeScale.ScaleHighRange) END
		   + ' ' + FBA.ScaleHeader AS Scale,		  
		   FeeBasedActivity.DateCreated,
		   FeeBasedActivity.CreatedBySystemUserID,
		   FeeBasedActivity.DateUpdated,
		   FeeBasedActivity.UpdatedBySystemUserID,
		   dbo.ufn_varbintohexstr(FeeBasedActivity.RowTimestamp) AS RowTimestamp,
		   FBA.GenerateARFlag AS GenerateARFlag,
		   FeeBasedActivity.PrimaryFlag,
		   B.AccountablePartyID
	 FROM tblPOEOLicenceFeeBasedActivity AS FeeBasedActivity
	 JOIN tblFeeBasedActivity FBA ON FBA.FeeBasedActivityID = FeeBasedActivity.FeeBasedActivityID
	 JOIN tblFeeBasedActivityScale FeeScale ON FBA.FeeBasedActivityID = FeeScale.FeeBasedActivityID AND FeeBasedActivity.FeeBasedActivityScaleID = FeeScale.FeeBasedActivityScaleID
	 JOIN tblInstrument A ON FeeBasedActivity.InstrumentID = A.InstrumentID
	 JOIN tblInstrumentAccountableParty B ON A.InstrumentID = B.InstrumentID 
	 WHERE 
	 B.AccountablePartyID = 3250 
	 AND
	 FBA.PremisesFlag = 1
	 ORDER BY DateCreated Desc