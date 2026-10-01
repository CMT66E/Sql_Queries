		
		declare @IsFromeConnect bit = 0

		if @IsFromeConnect is not null
		begin
		  if @IsFromeConnect = 1 
		    print '@IsFromeConnect true = ' + cast(@IsFromeConnect as varchar)
		  if @IsFromeConnect = 0 
		    print '@IsFromeConnect false = ' + cast(@IsFromeConnect as varchar)		  
		end 					

		SELECT DISTINCT
			[I].InstrumentID	
		FROM 
			tblInstrument I				
			LEFT OUTER JOIN tblInstrumentNotice [IN]
				ON [IN].NoticeInstrumentID = I.InstrumentID
			LEFT OUTER JOIN tblNotice N
				ON [I].InstrumentID = N.InstrumentID
			INNER JOIN tblNoticeTemplate NT
				ON NT.NoticeTemplateID = N.NoticeTemplateID
			LEFT OUTER JOIN tblClassification C ON
				C.ClassificationID = I.InstrumentStatusID
			LEFT OUTER JOIN tblInstrumentAuditLog AL
				ON AL.InstrumentAuditLogID = 
					(Select MAX(AL1.InstrumentAuditLogID) FROM tblInstrumentAuditLog AL1
					Where I.InstrumentID = AL1.InstrumentID)
			LEFT OUTER JOIN tblDECCWSection DS
				ON DS.DECCWSectionID = I.DECCWSectionID
 
			LEFT OUTER JOIN tblInstrumentAccountableParty IAP ON
			IAP.InstrumentAccountablePartyID = (Select MIN(IAP1.InstrumentAccountablePartyID)
				FROM tblInstrumentAccountableParty IAP1 WHERE IAP1.InstrumentID = I.InstrumentID)
			LEFT OUTER JOIN tblAccountableParty APR ON IAP.AccountablePartyID = APR.AccountablePartyID	
									
			LEFT OUTER JOIN tblSystemUser U
				ON I.ResponsibleSystemUserID = U.SystemUserID
			LEFT OUTER JOIN tblInstrument PRI 
				ON PRI.InstrumentID = [IN].InstrumentID
			LEFT OUTER JOIN tblClassification C1
				ON PRI.InstrumentTypeID = C1.ClassificationID	
			LEFT OUTER JOIN tblOnlineLicenceChangeApplication OLC ON [IN].NoticeInstrumentID = OLC.NoticeInstrumentID
			--                       CASE @IsFromeConnect when null then [IN].NoticeInstrumentID
			--					                        when 1 then (select MIN(NoticeInstrumentID) from tblOnlineLicenceChangeApplication where not NoticeInstrumentID is null)
			--					                        when 0 then (select MIN(NoticeInstrumentID) from tblOnlineLicenceChangeApplication where not NoticeInstrumentID is null)
			--					   END					
			WHERE NOT N.NoticeTemplateID IN (21, 22, 23, 24)
			    AND
				(
					NT.DocumentRequiredFlag <> 0
				)
				AND		
				(
					I.InstrumentTypeID = 554
				)
			 
				AND
				(	
					 [NT].NoticeTemplateID = 391
				)
				AND 	 
				(
					  ([I].InstrumentStatusID = 9)
				)
				AND 
				[IN].NoticeInstrumentID IN
			                        (CASE @IsFromeConnect when null then [IN].NoticeInstrumentID
								                        when 1 then (select MIN(NoticeInstrumentID) from tblOnlineLicenceChangeApplication where not NoticeInstrumentID is null and NoticeInstrumentID = [IN].NoticeInstrumentID)
								                        when 0 then 
														  (select NoticeInstrumentID from tblInstrumentNotice where NoticeInstrumentID = [IN].NoticeInstrumentID and not NoticeInstrumentID in (select NoticeInstrumentID from tblOnlineLicenceChangeApplication where not NoticeInstrumentID is null))
								   END)	

				----AND [IN].NoticeInstrumentID not in (select distinct NoticeInstrumentID from tblOnlineLicenceChangeApplication where not NoticeInstrumentID is null)