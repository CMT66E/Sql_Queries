		declare @Location varchar = 'loc'
		
			SELECT 	DISTINCT
				I.InstrumentID, RLOC.LocationName
				FROM tblClassification C 
					INNER JOIN tblInstrument I 
					ON C.ClassificationID = I.InstrumentTypeID
					LEFT OUTER JOIN tblClassification C2 
						ON C2.ClassificationID = I.InstrumentStatusID
					LEFT OUTER JOIN tblSystemUser U
						ON U.SystemUserID = I.ResponsibleSystemUserID					 
					LEFT OUTER JOIN tblDECCWSection DS
						ON DS.DECCWSectionID = I.DECCWSectionID						
					LEFT OUTER JOIN tblRadiationLicence RL              ------------------PALMS V5.0
						ON I.InstrumentID = RL.InstrumentID
					LEFT OUTER JOIN tblRadiationLicenceCondition RLC
						ON RL.InstrumentID = RLC.InstrumentID
					LEFT OUTER JOIN tblRadiationCondition RC
						ON RLC.RadiationConditionID = RC.RadiationConditionID
					LEFT OUTER JOIN tblInstrumentRadiationLocation IRLOC
						ON RL.InstrumentID = IRLOC.InstrumentID AND IRLOC.VariationPendingFlag = 0 AND IRLOC.EffectiveDateTo IS NULL
					LEFT OUTER JOIN tblRadiationLocation RLOC 
						ON IRLOC.RadiationLocationID = RLOC.RadiationLocationID
					LEFT OUTER JOIN tblAddress A
						ON 	A.AddressID = RLOC.AddressID
					LEFT OUTER JOIN tblRadiationLocationRRM RLRRM 
						ON RLOC.RadiationLocationID = RLRRM.RadiationLocationID
					LEFT OUTER JOIN tblRadiationLicenceRRM RLIRRM 
						ON RLRRM.RadiationLicenceRRMID = RLIRRM.RadiationLicenceRRMID
					LEFT OUTER JOIN tblRadiationLicenceAccreditationType RLAT
						ON RL.InstrumentID = RLAT.InstrumentID
				WHERE 		
					(
						C.ClassificationDomainID = 35
					)
					AND
					(
						I.InstrumentTypeID = 750
					) 														 
                    AND 
					ISNULL(RLOC.LocationName,'') like '%loc%'

					--ISNULL(RLOC.LocationName,'') like case isnull(@Location, '') when '' then RLOC.LocationName else ('%' + @Location +'%') end



			 