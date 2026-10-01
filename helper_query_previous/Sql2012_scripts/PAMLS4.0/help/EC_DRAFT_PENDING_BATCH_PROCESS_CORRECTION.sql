			           declare @SevenFour int
				       select @SevenFour = value from tblSystemVariable where SystemVariableID = 20		
		
						DECLARE @MyTableTemp TABLE (          
							InstrumentID int,
							MaxEndDate Datetime
						)
					   insert into @MyTableTemp
					   select a.InstrumentID, max(a.EndDate) as MaxEndDate				 
					   from tblEMAssessmentPeriod a inner join tblInstrument b on a.InstrumentID = b.InstrumentID					   					 	  
					   group by a.InstrumentID 	

--select * from @MyTableTemp

					   --update tblInstrument set InstrumentStatusID = 1032, DateUpdated = getdate(), UpdatedBySystemUserID = 1
					    DECLARE @MyTable TABLE (
						    SNo int IDENTITY(1,1),           
							InstrumentID int,
							InstrumentStatusIDA int,
							InstrumentStatusIDB int
						)
					  
					   insert into @MyTable
					   select a.InstrumentID, a.InstrumentStatusID, b.InstrumentStatusID 
					   from tblInstrument a inner join RiskAccessmentCorrecion b on a.InstrumentID = b.InstrumentID
					   where  a.InstrumentID in 
					   (
						select InstrumentID from @MyTableTemp where DATEDIFF(day, MaxEndDate, getdate()) > @SevenFour 
					   )
					   and a.InstrumentStatusID = 1032
					   				 
					   --we need find its previous status
					select * from @MyTable where InstrumentStatusIDB <> 1032  --total 1859					   
					--select * from tblInstrument where InstrumentID in (select InstrumentID from @MyTable where InstrumentStatusIDB <> 1032)

					   --here we looping through each record
					declare @Cnt int
					SELECT @Cnt = MIN(Sno) FROM @MyTable
		               
					declare @Row_Count int

					declare @TempInstrumentID int
					declare @TempInstrumentStatusIDA int
					declare @TempInstrumentStatusIDB int

					WHILE (1=1)
					BEGIN                             
					        SELECT @TempInstrumentID = InstrumentID, @TempInstrumentStatusIDA = InstrumentStatusIDA, @TempInstrumentStatusIDB = InstrumentStatusIDB FROM @MyTable
					        WHERE SNo = @Cnt  					
							---- don't insert anything here ----	   
							select @Row_Count = @@ROWCOUNT
							
							--print '@TempInstrumentID =' + cast(@TempInstrumentID as varchar)

							--print '@@@ROWCOUNT =' + cast(@@ROWCOUNT as varchar)  
							 							
					        IF @Row_Count = 0
						    BREAK

						if exists(select * from tblInstrument where InstrumentID = @TempInstrumentID)
						begin
						  if @TempInstrumentStatusIDA = 1032 and @TempInstrumentStatusIDB = 700
						  begin
							--print '@TempInstrumentID =' + cast(@TempInstrumentID as varchar)
							--print '@TempInstrumentStatusIDA =' + cast(@TempInstrumentStatusIDA as varchar)
							--print '@TempInstrumentStatusIDB =' + cast(@TempInstrumentStatusIDB as varchar)
							--print '---------------------------------------------'
							--select InstrumentID, InstrumentStatusID, @TempInstrumentStatusIDB as InstrumentStatusShouldBe  from tblInstrument where InstrumentID = @TempInstrumentID
							Update tblInstrument set InstrumentStatusID = @TempInstrumentStatusIDB where InstrumentID = @TempInstrumentID  
					      end
						   --if @TempInstrumentStatusIDB = 700
						   --   Update tblInstrument set InstrumentStatusID = @TempInstrumentStatusIDB where InstrumentID = @TempInstrumentID  
						     
						   
						end 
		
					    SELECT @Cnt = @Cnt + 1
		
					END
				  
					print '@@Cnt end =' + cast(@Cnt as varchar)
                

					   
					   
                   
				    delete @MyTable
					delete @MyTableTemp

					--select * from OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=OEH30612\OEH30612_SQL2012;UID=admin-hee;PWD=guilin2016@').[PALMSDB].[dbo].[tblInstrument]

					--select * from RiskAccessmentCorrecion where InstrumentStatusID = 1032