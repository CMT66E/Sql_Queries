select top 1  b.InstrumentID, a.NoticeTemplateID, b.InstrumentStatusID
					from tblnotice a 
							inner join tblInstrument b on a.InstrumentID = b.InstrumentID 
							inner join tblInstrumentNotice c on a.InstrumentID = c.NoticeInstrumentID
						 
					where a.NoticeTemplateID in (379, 389) 
					and b.InstrumentStatusID = (case a.NoticeTemplateID when 379 then 566 when 389 then 11 end)  			    
						and c.InstrumentID = 10060
					and
						EXISTS 
						(  
							SELECT * FROM tblPOEOLicenceFeeBasedActivity E
							INNER JOIN tblFeeBasedActivity D ON E.FeeBasedActivityID = D.FeeBasedActivityID
							WHERE E.InstrumentID = C.InstrumentID                                
							--AND D.PremisesFlag = 0 --comment out this because we only want to know if this licence is transfer licence or not and we don't care if it is premises or transporter licence
						) 
					order by a.DateCreated desc