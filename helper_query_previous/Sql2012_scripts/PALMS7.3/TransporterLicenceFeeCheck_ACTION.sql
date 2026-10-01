				declare @inInstrumentID int = 5068555   
				declare @CalculatedAmount money = 0
				declare @FullInvoice money = 0
				declare @FullAdjustment money = 0
				declare @Temp varchar(500) = ''

				SELECT @CalculatedAmount = dbo.ufn_DGGetNewLicenceFee(@inInstrumentID)

				SELECT @FullInvoice = ISNULL(SUM(InvoiceAmount),0)
					FROM tblRadiationLicenceInvoice
					WHERE InstrumentID = @inInstrumentID and RadiationLicenceFeeTypeID = 4

				SELECT @FullAdjustment = ISNULL(SUM(AdjustmentAmount), 0) 
				FROM tblRadiationLicenceInvoiceAdjustment 
				WHERE RadiationLicenceInvoiceID IN
					(SELECT RadiationLicenceInvoiceID FROM tblRadiationLicenceInvoice WHERE InstrumentID = @inInstrumentID and RadiationLicenceFeeTypeID = 4 and SystemGeneratedFlag = 1)


				IF @CalculatedAmount <> @FullInvoice + @FullAdjustment
				BEGIN
					set @Temp = @Temp + '<br>' + 'The invoice amount is different with calculated licence fee amount, please select Calculate Fee function to create fee adjustment.' 
				END

				print '@@CalculatedAmount = ' + cast(@CalculatedAmount as varchar)
				print '@@FullInvoice = ' + cast(@FullInvoice as varchar)
				print '@@FullAdjustment = ' + cast(@FullAdjustment as varchar)

				print '@Temp = ' + @Temp


select * from tblTransporterLicence where InstrumentID in (5068555 , 5068554)

