					--Here we get rid of duplicated datarows only by checking if its POEOLicencePRPID has duplications based on current InstrumentID
					Declare @InstrumentResultRowsExport Table
					(	 		
						InstrumentID int null,
						NoticeTemplateID int null,
						RecordType Varchar(500) null,
						InstrumentStatus varchar(200),									
						LocationName Varchar(200),
						InstrumentTypeID int null,
						StatusID int null,
						AccountableParty Varchar(200),
						DateIssued DateTime,
						LocationFull Varchar(200),
					    POEOLicencePRPID int null 		
					)	  
										
					DECLARE @MyTable TABLE
					(
					  SNo int IDENTITY(1,1), 
					  PrimaryId int,
					  POEOLicencePRPID int
					)    

					INSERT INTO @MyTable(PrimaryId, POEOLicencePRPID)
					SELECT InstrumentID, POEOLicencePRPID FROM @InstrumentResultRowsFinal
					ORDER BY InstrumentID 

					DECLARE @InstrumentId INTEGER
					DECLARE @POEOLicencePRPID INTEGER
					
					DECLARE @Cnt INTEGER
					SELECT @Cnt = MIN(SNo) FROM @MyTable



					WHILE (1=1)
					 BEGIN

						SELECT @InstrumentId = PrimaryId, @POEOLicencePRPID=POEOLicencePRPID  FROM @MyTable
						WHERE SNo = @Cnt					    					    					    
						IF @@ROWCOUNT = 0
						BREAK
						
						--PRINT '@InstrumentId = ' + CAST(@InstrumentId as Varchar)
					   
						IF NOT EXISTS(SELECT * FROM @InstrumentResultRowsExport WHERE InstrumentID = @InstrumentId and POEOLicencePRPID= @POEOLicencePRPID)
						BEGIN
							INSERT INTO @InstrumentResultRowsExport 
							SELECT TOP 1 * from @InstrumentResultRowsFinal tt				    
							WHERE tt.InstrumentID = @InstrumentId and POEOLicencePRPID= @POEOLicencePRPID
						END
						
						SELECT @Cnt = @Cnt + 1
						
					 END		  